#! /bin/bash

# delete any htmldocs/*.idx file before starting
# nim doc --project --index:on --git.url:<url> --git.commit:<tag> --outdir:htmldocs <main_filename>.nim
nim doc --project --index:on --outdir:htmldocs main.nim

# this will generate html files, a theindex.html index, css and js under `htmldocs`
# See also `--docroot` to specify a relative root.
# to get search (dochacks.js) to work locally, you need a server otherwise
# CORS will prevent opening file:// urls; this works:
python3 -m http.server 7029 --directory htmldocs
# When --outdir is omitted it defaults to $projectPath/htmldocs,
# or `$nimcache/htmldocs` with `--usenimcache` which avoids clobbering your sources;
# and likewise without `--project`.
# Adding `-r` will open in a browser directly.
# Use `--showNonExports` to show non-exported fields of an exported type.