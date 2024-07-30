#!/bin/bash
# Validate the directory argument
if [ -z "$1" ]; then
    echo "Directory is the actual Keyspace folder and this argument is required."
    echo "This script will report sstables having only 2 files the  Data.db and the Index.db"
    echo "========  output file  is /tmp/sstables-to-move.txt ==============="
    echo "Usage: $0  <directory>"
    exit 1
fi

files_to_move=/tmp/sstables-to-move.txt
rm -f $files_to_move
directory=$1

echo "cheking keyspace folder $1"

# Check each immediate subdirectory of the provided directory
for subdir in "$directory"/*/; do
    if [ -d "$subdir" ]; then
        #echo "for table $subdir"
        cd $subdir
        uuids=$(ls *.db *.txt *.crc32 | cut -d '-' -f 2 | sort | uniq)
        for uuid in $uuids; do
                count=$(ls  | grep "$uuid" | wc -l)
        #echo $uuid $count
        if (($count < 3)); then
                # checking only 2 files are Index and Data?"
                ls $subdir*$uuid*Data.db && ls $subdir*$uuid*Index.db 2>/dev/null
                if [ $? -eq 0 ] ; then
                      ls $subdir*$uuid*Data.db  >> $files_to_move
                      ls $subdir*$uuid*Index.db >> $files_to_move
                else
                      echo ""
                fi
        fi
done
    fi
    done
