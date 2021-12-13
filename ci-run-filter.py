#!/usr/bin/env python3

import argparse
import os
import sys
import subprocess

# ci-run-filter.py
#
#   only runs the given command (usually a long running test command) if the
#   files changed in current git commit match the pattern specified.
#
#   exceptions:
#     - always runs on master/main
#     - TODO: run or don't run based on certain tags in the commit message
#

# advantages:
# - saves a bunch of time if commits are just .txt files changes
#
# downsides:
# - if patterns miss dependencies, failures could be missed
#   - suggest full path matches (/path/to/module) vs suffixes ('.pp')
# - if a test passes, users to check to see that this step was run vs knowing
#   - possible solution: let CI system know by exiting a specific code.
#     - circleci: https://ideas.circleci.com/cloud-feature-requests/p/set-job-state-based-on-exit-code
#     - gitlab: https://gitlab.com/gitlab-org/gitlab/-/issues/16733
#     - github: no public issue mentioning this


def inspect_commit_message():
    # `git show HEAD -s` and look for SKIP_CI or FORCE_CI
    # - see what CI services are using for defaults
    pass


def files_in_diff_match(match_string, verbose=False):
    output = subprocess.getoutput("git diff-tree --name-only HEAD 2>&1")
    # first line has gitref, skip
    if verbose:
        print("changes files:")
    for line in output.split("\n")[1:]:
        if verbose:
            print("  %s" % line)
        # TODO: iterate over array of potential matches
        if match_string in line:
            print("'%s' matched pattern, running test..." % line)
            return True
    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process some integers.")
    parser.add_argument('--command', '-c')
    # TODO: take multiple
    parser.add_argument('--substring_to_match', '-s')
    parser.add_argument('--verbose', '-v', default=False, action='store_true')
    # TODO: add skip_commit_message, run_commit_message
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
