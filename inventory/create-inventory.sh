#!/usr/bin/env bash
set -euo pipefail

# define the associative array
declare -A ansible_groups_hosts

while read -r line; do
    # remove commas
    line=${line//,/}
    # match only relevant lines
    pattern="^-\s\S*\s\W.*"
    if [[ $line =~ $pattern ]]; then
        ansible_groups=($(awk -F"[][]" '{print $2 " "}' <<<"$line"))
        # for each group, add the host to associative array under the key of the group
        for group in "${ansible_groups[@]}"; do
            # start with an empty list for each iteration
            ansible_hosts_in_group=()
            # add the hosts to an array
            ansible_hosts_in_group+=("$(awk -F"[ ]" '{print $2 " "}' <<<"$line")")
            # append the list of hosts as a value to the relevant group (key)
            ansible_groups_hosts[$group]+=$ansible_hosts_in_group
        done
    fi
done < inventory.txt

# write associative array to file
for group in "${!ansible_groups_hosts[@]}"; do
    printf '%s\n' "[$group]" " ${ansible_groups_hosts[$group]}" | tr " " "\n" >> tmp.txt;
done

# clean hosts file if it exists
if [ -f hosts ]; then
    rm hosts
fi

# produce output
awk '/\]$/ { printf("%s\t", $0); next } 1' tmp.txt > hosts
rm tmp*

