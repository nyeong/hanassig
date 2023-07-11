#!/bin/sh
# Sort markdown files in `notes/` in descending order of most recently
# modified at.
git ls-files HEAD notes/*.md \
| xargs -I{} git --no-pager log -1 --date=iso-local --format="%ad {}" {} \
| sort --reverse \
| head -n 10
