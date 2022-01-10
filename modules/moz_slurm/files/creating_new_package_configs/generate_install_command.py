#!/usr/bin/env python3

# TODO: make this generate install and uninstall scripts
#       - name based on the metapackage they install

import subprocess

# TODO: take as an arg
metapackage_to_install = "cuda-11-5"
# output_file = "/tmp/output/packages-in-%s-metapackage.txt" % metapackage_to_install

cmd1 = "dpkg --list | grep '%s' |  tr -s ' ' | cut -d ' ' -f 3" % metapackage_to_install
result = subprocess.run(cmd1, stdout=subprocess.PIPE, encoding="UTF8", shell=True)
metapackage_version = result.stdout.rstrip()


# old method: resulted in a broken installer, got ubuntu packages also
#
# cmd2 = (
#     "diff /tmp/output/base_bom.txt /tmp/output/final_bom.txt  | grep -E 'cuda|nvidia' | grep -v '%s'"
#     % metapackage_to_install
# )
# result = subprocess.run(cmd2, stdout=subprocess.PIPE, encoding="UTF8", shell=True)


# new method: only show pacakges from nvidia repo
# - uses list_external_packages.sh
f = open("/Users/aerickson/git/snakepit_puppet/in.txt", "r")
results = f.read()

output = "# packages installed by metapackage %s at version %s\n\n" % (
    metapackage_to_install,
    metapackage_version,
)

for line in results.rstrip().split("\n"):
    line_parts = line.split()
    try:
        output += '  "%s=%s" \\' % (line_parts[1], line_parts[2])
        output += "\n"
    except IndexError:
        print(line_parts)
        raise Exception("strange line format!")

print(output)

# TODO: strip off last \ and newline

# # write out to filename based on metapackage
# with open(output_file, "w") as opened_file:
#     opened_file.write(output)

# display to screen (vestigial)
# print("")
# print(output)
