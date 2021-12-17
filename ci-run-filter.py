#!/usr/bin/env python3

import argparse
import os
import sys
import subprocess
import configparser

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
# future features:
# - support forcing and skipping via env var
#   - configurable via config file/argument
#   - https://circleci.com/docs/2.0/pipeline-variables/#pipeline-parameters-in-configuration
#   - advantage: doesn't require something in commit message
#   - disadvantage: more CI configuration required
#
# potential issues:
# - if developers push a bunch of commits at once, the we could 'miss' commits that should be triggered on
#   - mitigation: encourage developers to push frequently
#
# potential improvements:
# - figure out how to inspect diff between last CI run and HEAD (vs just HEAD and HEAD~1)
#   - avoid 'potential issue' above


# returns 'skip', 'run', or None (for no action advised)
def inspect_commit_message(git_ref, run_string, skip_string):
    # `git show HEAD -s` and look for SKIP_CI or FORCE_CI
    cmd_to_run = "git show %s -s 2>&1" % git_ref
    output = subprocess.getoutput(cmd_to_run)
    # TODO: which should be handled first? run or skip?
    # TODO: handle if both are present?
    if run_string in output:
        return "run"
    elif skip_string in output:
        return "skip"
    else:
        return None


def files_in_diff_match(match_strings, verbose=False, git_ref="HEAD"):
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


def run_test_if_matches(
    match_strings, command, git_ref, force_run, force_skip, verbose=False
):
    # TODO: define at root?
    file_name = os.path.basename(__file__)

    # debugging
    # print(args)
    # sys.exit(0)

    # TODO: figure out how to support other CI systems
    #       - github `GITHUB_REF=refs/heads/feature-branch-1`
    try:
        branch = os.environ["CIRCLE_BRANCH"]
    except KeyError:
        print("%s: WARN: CIRCLE_BRANCH not defined" % file_name)
        branch = "UNKNOWN"
    # print(branch)

    commit_msg_inspection_result = inspect_commit_message(
        git_ref, force_run, force_skip
    )

    # TODO: where should force options fall in priority?
    if branch == "master" or branch == "main":
        pass
    elif commit_msg_inspection_result and commit_msg_inspection_result == "run":
        print(
            "%s: Forcing a command run due to keyword (%s) in commit message."
            % (file_name, force_run)
        )
        pass
    elif commit_msg_inspection_result and commit_msg_inspection_result == "skip":
        print(
            "%s: Skipping command run due to keyword (%s) in commit message."
            % (file_name, force_skip)
        )
        sys.exit(0)
    elif files_in_diff_match(match_strings, git_ref=git_ref, verbose=verbose):
        pass
    else:
        print("%s: Skipping test." % file_name)
        if verbose:
            # TODO: make sure this matches actual order above? or just omit it?
            # TODO: mention the actual args
            print("  - Not on master or main branches.")
            print(
                "  - Commit doesn't have force_run or force_skip keywords in message."
            )
            print("  - No changed files matched the selection criteria.")
        sys.exit(0)

    # run test
    if verbose:
        print("%s: running command ('%s')..." % (file_name, command))
    process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    for c in iter(lambda: process.stdout.read(1), b""):
        sys.stdout.buffer.write(c)
        # flush buffer to avoid hiding output
        sys.stdout.buffer.flush()

    # collect the exit code
    process.wait()
    print("%s: process exited with result code %s" % (file_name, process.returncode))
    sys.exit(process.returncode)


def main(argv=None):
    # TODO: consider requiring configargparse (https://pypi.org/project/ConfigArgParse/)
    # - makes it easier to handle config files, arguments, env vars, etc

    # Do argv default this way, as doing it in the functional
    # declaration sets it at compile time.
    if argv is None:
        argv = sys.argv

    # Parse any conf_file specification
    # We make this parser with add_help=False so that
    # it doesn't parse -h and print help.
    conf_parser = argparse.ArgumentParser(
        description=__doc__,  # printed with -h/--help
        # Don't mess with format of description
        formatter_class=argparse.RawDescriptionHelpFormatter,
        # Turn off help, so we print all options in response to -h
        add_help=False,
    )
    # fully hidden with argparse.SUPPRESS
    conf_parser.add_argument(
        "--conf_file",
        # help="The config file to use.",
        help=argparse.SUPPRESS,
        default=".ci-run-filter.cfg",
        metavar="FILE",
    )
    args, remaining_argv = conf_parser.parse_known_args()

    defaults = {  # "option":"default",
        "force-run": "CI_FORCE_RUN",
        "force-skip": "CI_FORCE_SKIP",
    }

    if os.path.exists(args.conf_file):
        config = configparser.ConfigParser()
        try:
            config.read([args.conf_file])
            defaults.update(dict(config.items("main")))
        except configparser.NoSectionError:
            pass
        # TODO: handle loading filters (manually)
        # print({section: dict(config[section]) for section in config.sections()})

    # Parse rest of arguments
    # Don't suppress add_help here so it will handle -h
    parser = argparse.ArgumentParser(
        # Inherit options from config_parser
        parents=[conf_parser]
    )
    parser.set_defaults(**defaults)
    parser.add_argument("--verbose", "-v", action="store_true")

    main_group = parser.add_argument_group("main")
    secondary_group = parser.add_argument_group("advanced")
    # parser.add_argument("--option")  # test option
    main_group.add_argument("--command", "-c", required=True)
    main_group.add_argument(
        "--substring_to_match",
        "-s",
        dest="match_strings",
        action="append",
        required=True,
    )
    # TODO: add filter_set argument
    # - filter sets loaded from config
    # - would merge with existing match_strings
    # TODO: add option to diff against base of PR and look for matches (vs just head)?
    # - describe  the need better... what case would we use this? seems annoying.
    # - gh: diff between GITHUB_HEAD_REF and GITHUB_BASE_REF
    secondary_group.add_argument(
        "--git-ref",
        dest="git_ref",
        default="HEAD",
        help="For testing, use a commit other than HEAD.",
    )
    secondary_group.add_argument(
        "--force-run",
        default=defaults["force-run"],
        help="String that forces a run of the command if found in the commit message.",
    )
    secondary_group.add_argument(
        "--force-skip",
        default=defaults["force-skip"],
        help="String that force skips a run of the command if found in the commit message.",
    )

    args = parser.parse_args(remaining_argv)
    # print(args)
    # print("Option is \"{}\"".format(args.option))
    # return(0)
    # print(args.force_skip)
    # sys.exit(1)

    run_test_if_matches(
        args.match_strings,
        args.command,
        args.git_ref,
        args.force_run,
        args.force_skip,
        verbose=args.verbose,
    )

    # shouldn't be here, throw error if we are
    return 1


if __name__ == "__main__":
    sys.exit(main())
