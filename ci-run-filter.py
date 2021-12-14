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
#   example usage:
#     ./ci-run-filter.py -c 'bundle exec kitchen verify' -s 'modules/' -v

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
#
# potential issues:
# - if developers push a bunch of commits at once, the we could 'miss' commits that should be triggered on
#   - mitigation: encourage developers to push frequently
#
# TODOs:
# - use a config file to load shared settings


def inspect_commit_message():
    # `git show HEAD -s` and look for SKIP_CI or FORCE_CI
    # - see what CI services are using for defaults
    pass


def files_in_diff_match(match_strings, verbose=False, git_ref='HEAD'):
    # doesn't get full path
    # cmd_to_run = "git diff-tree --name-only %s 2>&1" % git_ref

    # full paths, only need to strip off last line
    cmd_to_run = "git show --stat --name-only --pretty='format:' %s 2>&1" % git_ref

    # print(cmd_to_run)
    output = subprocess.getoutput(cmd_to_run)

    # first to last line has summary, skip with slice
    for line in output.split("\n")[:-1]:
        for _mstring_counter, mstring in enumerate(match_strings):
            if mstring in line:
                if verbose:
                    print("  ✓ %s (matches '%s')" % (line, mstring))
                return True
        if verbose:
            print("  ✗ %s" % line)

    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process some integers.")
    parser.add_argument('--command', '-c')
    parser.add_argument('--substring_to_match', '-s', dest='match_strings', action='append')
    parser.add_argument('--verbose', '-v', default=False, action='store_true')
    parser.add_argument('--git-ref', '-g', dest="git_ref", default='HEAD')
    # TODO: add skip_commit_message, run_commit_message
    args = parser.parse_args()

    file_name = os.path.basename(__file__)

    # debugging
    # print(args)
    # sys.exit(0)

    try:
        branch = os.environ["CIRCLE_BRANCH"]
    except KeyError:
        print("%s: warning: CIRCLE_BRANCH not defined" % file_name)
        branch = "UNKNOWN"
    # print(branch)

    # TODO: support force-run trigger in description
    # TODO: support force-skip ...
    # TODO: what order/priority for force options?
    if branch == "master" or branch == "main":
        pass
    if files_in_diff_match(args.match_strings, git_ref=args.git_ref, verbose=args.verbose):
        pass
    else:
        # TODO: make sure this matches actual order above? or just omit it?
        print("- No changed files matched the selection criteria.")
        print("- Not on master or main braches.")
        # print("- Commit doesn't have force_run or force_skip keywords in message.")
        print("Skipping test.")
        sys.exit(0)

    # run test
    if args.verbose:
        print("%s: running command ('%s')..." % (file_name, args.command))
    process = subprocess.Popen(args.command, stdout=subprocess.PIPE, shell=True)
    for c in iter(lambda: process.stdout.read(1), b''):
        sys.stdout.buffer.write(c)
        # flush buffer to avoid hiding output
        sys.stdout.buffer.flush()

    # collect the exit code
    process.wait()
    print('%s: process exited with result code %s' % (file_name, process.returncode))
    sys.exit(process.returncode)
