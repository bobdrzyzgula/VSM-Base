#!/usr/bin/env python3
"""Look for code that changes meaning under OpenSCAD's lazy union.

With lazy union turned on (an experimental feature in newer builds, used
for multi-color 3MF export), for(), if/else, let(), echo(), assert() and
children() hand their objects to the parent one by one instead of as a
single union. That is harmless almost everywhere, but not in two places:

  - a child of intersection(): the pieces are intersected with one
    another, so a set of ribs or pegs can vanish;
  - the first child of difference(): only the first piece is kept, and
    the rest are subtracted from it.

This reads the source text (no OpenSCAD needed) and reports those spots:

  - for() and intersection_for(), always;
  - if, let, echo and assert when a branch holds a block of more than one
    statement, or an if has no else (inside intersection() an empty
    branch is dropped, not empty);
  - children(), which depends on how many children each caller passes, so
    a reviewed site is listed in REVIEWED below by file and module.

The cure is to wrap the child in union(). A spot that is truly safe can be
added to REVIEWED, with the reason.

Usage: tools/check_lazy_union.py [file.scad ...]   (default: every .scad
file under scad/ and standalone/). Exits 1 if it finds anything.
"""

import glob
import os
import re
import sys

# (file, enclosing module, operator): why it is safe
REVIEWED = {
    ("scad/vsm_base.scad", "fm_clip", "intersection"): "one child, face_marks_2d()",
    ("scad/vsm_base.scad", "split_halves", "intersection"): "one child, base()",
    ("scad/vsm_base.scad", "split_halves", "difference"): "one child, base()",
    ("scad/vsm_base.scad", "base_masked", "intersection"): "one child: a cube, or a union()",
    ("scad/vsm_base.scad", "top_slice", "intersection"): "one child: one part per call",
    ("scad/vsm_base.scad", "kn_rolled2d", "intersection"): "one child, the gear outline",
    ("standalone/bobbin-box/bobbin_box.scad", "cell", "intersection"): "one child, one tray",
}

LAZY = {"for", "intersection_for", "if", "let", "echo", "assert", "children"}
TOKEN = re.compile(r"[A-Za-z_$][A-Za-z_0-9$]*|\d+\.?\d*(?:[eE][-+]?\d+)?|\S")


def strip(s):
    """Blank out comments and string contents, keeping line numbers."""
    out, i, n = [], 0, len(s)
    while i < n:
        if s.startswith("//", i):
            j = s.find("\n", i)
            i = n if j < 0 else j
        elif s.startswith("/*", i):
            j = s.find("*/", i)
            j = n if j < 0 else j + 2
            out.append(re.sub(r"[^\n]", " ", s[i:j]))
            i = j
        elif s[i] == '"':
            j = i + 1
            while j < n and s[j] != '"':
                j += 2 if s[j] == "\\" else 1
            out.append('"' + " " * (j - i - 1) + '"')
            i = j + 1
        else:
            out.append(s[i])
            i += 1
    return "".join(out)


class Source:
    def __init__(self, path):
        s = strip(open(path).read())
        self.t = [(m.group(), s.count("\n", 0, m.start()) + 1) for m in TOKEN.finditer(s)]

    def w(self, k):
        return self.t[k][0] if k < len(self.t) else ""

    def skip_group(self, k):
        """k at ( or [: the index after its match"""
        d = 0
        while k < len(self.t):
            x = self.w(k)
            if x in "([":
                d += 1
            elif x in ")]":
                d -= 1
                if d == 0:
                    return k + 1
            k += 1
        return k

    def skip_block(self, k):
        """k at {: the index after its match"""
        d = 0
        while k < len(self.t):
            x = self.w(k)
            if x in "([":
                k = self.skip_group(k)
                continue
            if x == "{":
                d += 1
            elif x == "}":
                d -= 1
                if d == 0:
                    return k + 1
            k += 1
        return k

    def stmt_end(self, k, take_else=True):
        """the index after the statement starting at k (an if's else included, unless not take_else)"""
        while k < len(self.t):
            x = self.w(k)
            if x in "([":
                k = self.skip_group(k)
            elif x == ";":
                return k + 1
            elif x == "{":
                k = self.skip_block(k)
                if take_else and self.w(k) == "else":
                    k += 1
                    continue
                return k
            elif x == "}":
                return k
            elif x == "else":
                k += 1
            else:
                k += 1
        return k

    def block_stmts(self, k):
        """k at {: start indices of the statements inside"""
        end = self.skip_block(k) - 1
        k += 1
        res = []
        while k < end:
            if self.w(k) == ";":
                k += 1
                continue
            res.append(k)
            k = self.stmt_end(k)
        return res

    def children(self, k):
        """k at an operator's name: start indices of its children"""
        k = self.skip_group(k + 1)
        return self.block_stmts(k) if self.w(k) == "{" else [k]

    def head(self, k):
        while self.w(k) in ("!", "#", "%", "*"):
            k += 1
        return k

    def branch_risky(self, k):
        """k at the start of a branch statement: does it give more than one object?"""
        k = self.head(k)
        if self.w(k) == "{":
            n = self.block_stmts(k)
            return len(n) != 1 or self.risky(n[0])
        return self.risky(k)

    def risky(self, k):
        """does the statement at k hand over other than exactly one object?"""
        k = self.head(k)
        x = self.w(k)
        if x in ("for", "intersection_for", "children"):
            return True
        if x in ("let", "echo", "assert"):
            return self.branch_risky(self.skip_group(k + 1))
        if x == "if":
            b = self.skip_group(k + 1)
            if self.branch_risky(b):
                return True
            e = self.stmt_end(b, take_else=False)
            if self.w(e) != "else":
                return True                 # an empty branch
            return self.branch_risky(e + 1)
        return False

    def module_spans(self):
        spans = []
        for i, (x, _) in enumerate(self.t):
            if x == "module" and self.w(i + 2) == "(":
                b = self.skip_group(i + 2)
                spans.append((b, self.stmt_end(b), self.w(i + 1)))
        return spans


def check(path, rel):
    src = Source(path)
    spans = src.module_spans()
    found = []
    for i, (x, line) in enumerate(src.t):
        if x not in ("intersection", "difference") or src.w(i + 1) != "(" or src.w(i - 1) == "module":
            continue
        kids = src.children(i)
        for c in (kids if x == "intersection" else kids[:1]):
            h = src.head(c)
            if src.w(h) not in LAZY or not src.risky(h):
                continue
            mod = min((s for s in spans if s[0] <= i < s[1]), key=lambda s: s[1] - s[0],
                      default=(0, 0, "(top level)"))[2]
            if src.w(h) == "children" and (rel, mod, x) in REVIEWED:
                continue
            found.append("%s:%d: in %s, a %s() child of %s() is split by lazy union; wrap it in union()"
                         % (rel, src.t[h][1], mod, src.w(h), x))
    return found


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    files = sys.argv[1:] or sorted(glob.glob(os.path.join(root, "scad", "*.scad"))
                                   + glob.glob(os.path.join(root, "standalone", "**", "*.scad"),
                                               recursive=True))
    found = []
    for f in files:
        rel = os.path.relpath(os.path.abspath(f), root)
        found += check(f, rel)
    for line in found:
        print(line)
    print("lazy union: %d file(s), %s" % (len(files), "%d spot(s) to fix" % len(found) if found else "clean"),
          file=sys.stderr)
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main())
