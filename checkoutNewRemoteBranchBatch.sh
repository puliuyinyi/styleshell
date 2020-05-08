#!/bin/bash -e

checkoutNewBranch() {
	remote_url=$1
	branch=$2

	existBranch="git branch"
	if [[ $($existBranch | grep $branch) ]]
	then
		echo "A branch named '$branch' already exists"
		exit 0
	fi

	remoteInfo="git remote -v"
	if [[ !($($remoteInfo | grep "upstream")) ]]
	then
		echo "No remote upstream, add it"
		git remote add upstream $remote_url
	fi

	git remote update
	#git checkout -b $branch upstream/$branch
	git branch $branch upstream/$branch
	git push -u origin $branch:$branch
}

BRANCH="test1"
PROJECTS="refactors"
URL="https://e.coding.net/puliuyinyi"

main() {
	projectArr=(${PROJECTS//,/ })
	for project in ${projectArr[*]}
	do
		echo "Checkout new branch for $project"
		cd $project
		checkoutNewBranch "${URL}/${project}.git" $BRANCH
		cd ..
		echo "Checkout new branch for $project finished"
	done
}

main
