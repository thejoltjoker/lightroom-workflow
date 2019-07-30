#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Rename existing presets folder in case something goes wrong
mv ~/Library/Application\ Support/Adobe/Lightroom ~/Library/Application\ Support/Adobe/Lightroom_BAK

# Create symlink to Lightroom folder in repo
ln -s $DIR/Lightroom ~/Library/Application\ Support/Adobe/Lightroom