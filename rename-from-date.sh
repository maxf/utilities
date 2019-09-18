#!/bin/bash

# Read all the files in the current directory. If it's an image or a video that has a CreateDate,
# Then rename it to have the date in the name. E.g. 2019:07:31-19:29.jpg

NEWDIR=renamed_files
rm -rf $NEWDIR
mkdir $NEWDIR

for file in *.*; do
    if [ -f "$file" ]; then
        extension=`echo "${file##*.}" | tr '[:upper:]' '[:lower:]'`
        createDate=`exiftool -CreateDate -d "%Y%m%d-%TZ" "$file" | cut -b 35-500`
        if [ -n "$createDate" ]; then
            newFilename=$createDate-00000.$extension
            if [ -f $NEWDIR/$newFilename ]; then
                x=1
                extx=`printf "%05d\n" $x`
                while [ -f $NEWDIR/$createDate-$extx.$extension ]; do
                    x=$(( $x + 1 ))
                    extx=`printf "%05d\n" $x`
                done
                newFilename=$createDate-$extx.$extension
            fi
            cp -v "$file" "$NEWDIR/$newFilename"
        else
            echo "Can't find date info in $file. Not renaming."
        fi
    else
        echo "\"$file\" is not a file. Skipping"
    fi
done
