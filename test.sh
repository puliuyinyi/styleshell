#!/bin/bash


existBranch="git branch"
branch="master"
if [[ $($existBranch | grep $branch) != "" ]]
then
	echo "A branch named '$branch' already exists"
else
	echo "A branch named '$branch' not exists"
fi