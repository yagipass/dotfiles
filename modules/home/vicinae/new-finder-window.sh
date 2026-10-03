#!/bin/sh
# @vicinae.schemaVersion 1
# @vicinae.title New Finder Window
# @vicinae.mode silent
# @vicinae.icon /System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns

osascript \
  -e 'tell application "Finder"' \
  -e 'make new Finder window to (path to desktop folder)' \
  -e 'activate' \
  -e 'end tell'
