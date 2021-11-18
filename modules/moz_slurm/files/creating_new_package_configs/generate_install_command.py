#!/usr/bin/env python3

import subprocess

cmd = "diff /tmp/base_bom.txt /tmp/final_bom.txt  | grep -E 'cuda|nvidia'"
result = subprocess.run(cmd, stdout=subprocess.PIPE, encoding='UTF8', shell=True)

print("")
for line in result.stdout.rstrip().split("\n"):
    line_parts = line.split()
    try:
        print('  %s=%s \\' % (line_parts[2], line_parts[3]))
    except IndexError:
        print(line_parts)
        raise Exception("strange line format!")

# TODO: strip off last \
