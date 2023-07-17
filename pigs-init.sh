#!/bin/dash

directory='.pig'

if [ ! -d "$directory" ]; then
    mkdir -p "$directory/"
    echo "Initialized empty pigs repository in $directory"

    mkdir -p "$directory/index/"
    mkdir -p "$directory/repo/"
    touch "$directory/status.txt"
    touch "$directory/commits.txt"
    touch "$directory/branches.txt"

    echo "name: " >> "$directory/status.txt"
    path=`realpath $directory`
    echo "path: $path" >> "$directory/status.txt"
    working_dir=$(realpath "$directory/..")
    echo "working_dir: $working_dir" >> "$directory/status.txt"

    mkdir -p "$directory/index/master"
    echo "master" >> "$directory/branches.txt"
    echo "current_branch: master" >> "$directory/status.txt"
else
    echo "$0: error: '$directory' already exists"
fi
