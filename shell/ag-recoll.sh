 #!/bin/bash
dir=$1; shift
ors=$(printf '%s|' address@hidden)
recoll -t -b $@ dir:$dir | sed -e "s/file:\/\///" | xargs -d '\n' ag --max-count 10 --group --line-number column --color --color-match 30\;43 --color-path 1\;32 --smart-case ${ors%|}


