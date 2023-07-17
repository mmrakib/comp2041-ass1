#!/bin/dash

get_pig_directory() {
    local slashes=$(printf '%s' "$PWD" | tr -c '/' '/')
    local directory="$PWD"

    n=${#slashes}
    while [ $n -gt 0 ]; do
        test -e "$directory/.pig" && pig_directory="$directory/.pig" && return
        directory="$directory/.."
        n=$(( n - 1 ))
    done
}

get_working_directory() {
    working_directory=$(grep -E "working_dir" "$pig_directory/status.txt" | cut -d' ' -f 2)
}

get_pig_directory
get_working_directory

while getopts "m:" var;
do
    case "$var" in
        m)
            message="$OPTARG"
            ;;
    esac
done

if [ -z ${message+x} ]; then
    echo "$0: error: 'message' variable does not exist"
    exit 1
fi

sed "/^$/d" "$pig_directory/commits.txt" > "$pig_directory/commits.txt"
sort "$pig_directory/commits.txt" > "$pig_directory/commits.txt"

commit_number=$(wc -l "$pig_directory/commits.txt" | cut -d' ' -f 1)
echo "$commit_number"
commit_number=$(( commit_number + 1 ))


echo "$commit_number|$message" >> "$pig_directory/commits.txt"
mkdir -p "$pig_directory/repo/$commit_number/"
cp -r "$working_directory/.*" "$pig_directory/repo/$commit_number"
