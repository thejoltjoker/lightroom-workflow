#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR

# Rename existing presets folder in case something goes wrong
mv ~/Library/Application\ Support/Adobe/Lightroom ~/Library/Application\ Support/Adobe/Lightroom_BAK

# Create symlinks for develop presets
for D in $DIR/Settings/*; do
    ln -s -v -f ${D} ~/Library/Application\ Support/Adobe/CameraRaw/Settings${D##*}
    # echo ~/Library/Application\ Support/Adobe/CameraRaw/Settings/${D##*/}
done

# Create symlink for other presets
ln -s -v -f ${DIR}/Lightroom ~/Library/Application\ Support/Adobe/Lightroom