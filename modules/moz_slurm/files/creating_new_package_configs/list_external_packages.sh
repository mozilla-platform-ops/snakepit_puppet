#!/bin/sh

# from https://askubuntu.com/questions/342434/find-what-packages-are-installed-from-a-repository

# Print packages installed from different origins.
# Exclude standard Ubuntu repositories.

#set -x

grep -H '^Origin:' /var/lib/apt/lists/*Release | grep -v ' Ubuntu$' | sort -u \
| while read -r line; do
    origin=${line#* }
    echo "$origin":

    list=${line%%:*}
    # original line, doesn't work on lz4 archives
    #sed -rn 's/^Package: (.*)$/\1/p' ${list%_*Release}*Packages | sort -u \
    # updated for lz4
    lz4cat "${list%_*Release}"*Packages.lz4 | sed -rn 's/^Package: (.*)$/\1/p' | sort -u \
    | xargs -r dpkg -l 2>/dev/null | grep '^.i '
    echo
 done
