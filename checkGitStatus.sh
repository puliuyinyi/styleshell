#!/bin/bash -e

checkStatus() {
	project=$1
	checkStatus=`git status`
	if [[ $(echo $checkStatus | grep "Changes not staged for commit:") ]]
	then
		echo "$project Not clean"
	elif [[ $(echo $checkStatus | grep "Untracked files:") ]]
	then
		echo "$project Not clean"
	elif [[ $(echo $checkStatus | grep "Changes to be committed:") ]]
	then
		echo "$project Not clean"
	fi
}

PROJECTS="java2"

main() {
	projectArr=(${PROJECTS//,/ })
	for project in ${projectArr[*]}
	do
		echo "Check status for $project"
		cd $project
		checkStatus $project
		cd ..
		echo "Check status for $project finished"
	done
}

main
