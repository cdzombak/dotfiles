#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2016
defaults write com.apple.dt.Xcode NSUserKeyEquivalents '{
    "Jump to Generated Interface" = "@^$i";
    "Print…" = "@~^$p";
}'
# See http://merowing.info/2015/12/little-things-that-can-make-your-life-easier-in-2016/
# Show how long it takes to build your project:
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
# Enable faster build times by leveraging multi-core CPU:
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $(sysctl -n hw.ncpu)
defaults write com.apple.dt.Xcode IDEFileExtensionDisplayMode 1
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar 1
defaults write com.apple.dt.Xcode DVTTextOverscrollAmount "0.5"
