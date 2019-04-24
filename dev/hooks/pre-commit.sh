#!/usr/bin/env bash
#### $$VERSION$$ v0.70-dev2-16-gc6d4086

# magic to ensure that we're always inside the root of our application,
# no matter from which directory we'll run script
GIT_DIR=$(git rev-parse --git-dir)
cd "$GIT_DIR/.." || exit 1

export HOOKDIR="dev/hooks"


# if any command inside script returns error, exit and return that error 
set -e

echo "Running pre-commit hook"
echo "............................" 

unset IFS; set -f

# check for shellcheck
if which shellcheck >/dev/null 2>&1; then
	echo "  Test all scripts with shellcheck ..."
else
	echo "Error: shellcheck is not installed. Install shellcheck or delete $0"
	exit 1
fi

# run shellcheck before commit
set +f
FILES="$(find ./* -name '*.sh' | grep -v 'dist\/' )"
set -f
FILES="${FILES} $(sed '/^#/d' <"dev/shellcheck.files")"
if [ "$FILES" != "" ]; then
	# shellcheck disable=SC2086
	shellcheck -x ${FILES} || exit 1
	echo "    OK"
else
	# something went wrong
	exit 1
fi
