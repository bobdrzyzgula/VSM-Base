# Documents snapshot

The documents as single, self-contained HTML pages (pictures and diagrams
included), published at
**[vsm-base.ephemeral-bozonics.com](https://vsm-base.ephemeral-bozonics.com/)**.
GitHub shows HTML files here as source; open them from that page.

**They may not be the latest versions.** They are copied here by hand from
time to time, not built automatically, so the sources in `docs/` (and
`standalone/motor-rig/`) may have moved on since. The index page names the
build and the date of the snapshot. Each release on the Releases page carries
the documents built from that release, as HTML and PDF.

To read a document offline, save its page from the browser and open the
saved file; nothing else is needed.

## Updating the snapshot

    make html
    make snapshot          # copies build/*.html here and stamps index.html
    git add docs-snapshot
    git commit -m "Update the documents snapshot"

Pushing it to main republishes the site (`.github/workflows/pages.yml`).
Nothing else in the build reads or writes this folder.
