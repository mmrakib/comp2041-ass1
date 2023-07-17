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

get_current_branch() {
    current_branch=$(grep -E "current_branch" "$pig_directory/status.txt" | cut -d' ' -f 2)
}

get_path_relative_to_working() {
    relative_path=$(realpath --relative-to="$working_directory" "$PWD")
}

get_pig_directory
get_working_directory
get_current_branch
get_path_relative_to_working

root_folder="$pig_directory/index/$current_branch/"

for filename in "$@"; do
    if [ -f "$filename" ]; then
        IFS="/" printf '%s\n' "$relative_path" | while IFS= read -r dir; do
            current_path="$root_folder/$dir"
            mkdir -p "$current_path"
            root_folder="$current_path"
        done

        cp "$filename" "$root_folder/$relative_path/$filename"
    else
        echo "$0: error: '$filename' does not exist"
    fi
done
