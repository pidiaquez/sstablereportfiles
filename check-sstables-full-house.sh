#!/bin/bash
# Validate the directory argument
if [ -z "$1" ]; then
    echo "Directory is the actual KEYSPACE folder and this argument is required."
    echo "this script will report if any sstable file has less than 9 files per id"
    echo "Usage: $0 <directory>"
    exit 1
fi


directory=$1

echo $1

# Check each immediate subdirectory of the provided directory
for subdir in "$directory"/*/; do
    if [ -d "$subdir" ]; then
        #echo "table $subdir"
        cd $subdir
        uuids=$(ls *.db *.txt *.crc32 | cut -d '-' -f 2 | sort | uniq)
        for uuid in $uuids; do
                count=$(ls  | grep "$uuid" | wc -l)
                if (($count <9)); then
                        echo "table $subdir"
                        echo $uuid $count
                fi
        done
        #check_missing_toc "$subdir" "$create_files"
        fi
    done
