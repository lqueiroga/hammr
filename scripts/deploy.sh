#!/bin/bash

usage () {
    echo "Options: $0"
    echo "-b : The branch name"
    echo "-t : The GitHub API token"
}

while getopts b:g: opt; do
    case $opt in
        b)      BRANCH="$OPTARG"
                ;;
        t)      TOKEN="$OPTARG"
                ;;
        \?|h|H) usage
                exit 1
                ;;
    esac
done

if [ -z "$BRANCH" ]; then
    echo "Please give the branch name via -b option"
    exit 1
fi
if [ -z "$TOKEN" ]; then
    echo "Please give the GitHub API Token via -g option"
    exit 1
fi
echo $BRANCH
echo $TOKEN
lastCommitMsg=`git log -1 --pretty=%B`

if [[ $lastCommitMsg == $"Hammr release"* ]]; then
	echo create release
    TAG=`sed -ne 's/.*VERSION=//p' hammr/utils/constants.py  | tr -d \"`
	curl --data-binary '{"tag_name": "'$TAG'", "target_commitish": "'$BRANCH'", "name": "Create release hammr '$TAG'", "draft": false, "prerelease": false}' https://api.github.com/repos/lqueiroga/hammr/releases?access_token=$TOKEN -X POST
else
	echo don\'t create release
fi