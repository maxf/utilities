#!/bin/bash

# Read all the files in the current directory. If it's an image or a video that has a CreateDate,
# Then rename it to have the date in the name. E.g. 2019:07:31-19:29.jpg

for file in *; do
    extension=`echo "${file##*.}" | tr '[:upper:]' '[:lower:]'`
    createDate=`exiftool -CreateDate -d "%Y:%m:%d-%H:%M:%S" "$file" | cut -b 35-50`
    if [ -n "$createDate" ]; then
        newFilename=$createDate.$extension
        if [ -f $newFilename ]; then
            echo "$newFilename already exists. Not renaming $file."
        else
            echo "renaming $file to $newFilename"
            mv $file $newFilename
        fi
    else
        echo "Can't find date info in $file. Not renaming."
    fi
done
