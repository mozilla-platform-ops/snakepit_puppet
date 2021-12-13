#!/usr/bin/env python3

import argparse
import os
import sys
import subprocess

# args:
#  - substring: string to check for (file ending like'.pp' or path like 'modules/')
#  - command: the command to run if above is matched
#  - optional: base: base branch if not master or main

# https://stackoverflow.com/questions/5243593/how-to-trigger-a-build-only-if-changes-happen-on-particular-set-of-files

# advantages:
# - saves a bunch of time if commits are just .txt files changes
# downsides:
# - if a test passes, have to check to see that this step was run vs knowing
#   - make the CI system show skipped vs passed? not possible in CircleCI

# logic:
# - if branch == main|master
#   - run
# - if files of type x have changed (git diff-tree --name-only HEAD)
#   - run
# - if commit message has FORCE_TRIGGER or similar keyword
#   - run
# - else
#   - print "no files matching pattern and not on master/main/base branch"
#   - ideally set state 'skipped' if ci system supported
#   - exit 0


def files_in_diff_match(match_string, verbose=False):
    output = subprocess.getoutput("git diff-tree --name-only HEAD 2>&1")
    # first line has gitref, skip
    if verbose:
        print("changes files:")
    for line in output.split("\n")[1:]:
        if verbose:
            print("  %s" % line)
        if match_string in line:
            print("'%s' matched pattern, running test..." % line)
            return True
    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process some integers.")
    parser.add_argument('--command', '-c')
    parser.add_argument('--substring_to_match', '-s')
    parser.add_argument('--verbose', '-v', default=False, action='store_true')
    args = parser.parse_args()
    print(args)

    try:
        branch = os.environ["CIRCLE_BRANCH"]
    except KeyError:
        print("warning: CIRCLE_BRANCH not defined")
        branch = "UNKNOWN"
    # print(branch)

    if branch == "master" or branch == "main":
        pass
    if files_in_diff_match(args.substring_to_match, verbose=args.verbose):
        pass
    # TODO: support force-run trigger in description
    # TODO: support force-skip ...
    else:
        print("- No changed files matched the selection criteria.")
        print("- Not on master or main braches.")
        # print("- Commit doesn't have force ci in message.")
        print("Skipping test.")
        sys.exit(0)

    # TODO: run test
    # print("would have run test (%s)" % args.command)
    process = subprocess.Popen(args.command, stdout=subprocess.PIPE, shell=True)
    for c in iter(lambda: process.stdout.read(1), b''):
        sys.stdout.buffer.write(c)
        # flush buffer to avoid hiding output
        sys.stdout.buffer.flush()
