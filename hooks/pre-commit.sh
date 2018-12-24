#!/bin/sh

# This is the pre-commit hook that runs each time with `git commit`
# and checks syntax of the playbooks
# To install run
#   ln -s ../../hooks/pre-commit.sh .git/hooks/pre-commit

echo "Running pre-commit hook"

STASH_NAME="pre-commit-$(date +%s)"
git stash save -q --keep-index $STASH_NAME

echo "Checking the playbook syntax"
ansible-playbook -i none site.yml --syntax-check
RESULT=$?

if [[ $RESULT == 0 ]]; then
	echo "Running Ansible linter"
	ansible-lint site.yml
	RESULT=$?
fi

STASHES=$(git stash list)

if [[ $STASHES =~ .*$STASH_NAME ]]; then
  git stash pop -q
fi

[ $RESULT -ne 0 ] && exit 1
exit 0
