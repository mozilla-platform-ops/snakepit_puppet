#!/usr/bin/env python3

# TODO: make this generate install and uninstall scripts
#       - name based on the metapackage they install
#       - grep -v that metapackage name out

import subprocess

# TODO: take as an arg
metapackage_to_install = 'cuda-11-5'

cmd = "diff /tmp/base_bom.txt /tmp/final_bom.txt  | grep -E 'cuda|nvidia' | grep -v '%s'" % metapackage_to_install
result = subprocess.run(cmd, stdout=subprocess.PIPE, encoding='UTF8', shell=True)

print("")
for line in result.stdout.rstrip().split("\n"):
    line_parts = line.split()
    try:
        print('  "%s=%s" \\' % (line_parts[2], line_parts[3]))
    except IndexError:
        print(line_parts)
        raise Exception("strange line format!")

# TODO: strip off last \

# TODO: write out to filename based on metapackage
