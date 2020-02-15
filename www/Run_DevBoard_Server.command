#!/usr/bin/env bash
set -euo pipefail

#
# DevBoard 1.0.1 (PHP Server)
# Copyright © 2019-2020 Mohsan Khan. All rights reserved.
#
# Just double-click open in the Finder.
# The root folder will be where you run this script.
#

mCommandDir="$(dirname "$BASH_SOURCE")"
cd $mCommandDir

mHost="localhost:8888"

# open pages with examples
open "http://${mHost}/DevBoardReceiver.php?devBoard=%7B%22parameters%22%3A%5B%7B%22key%22%3A%22App%22%2C%22value%22%3A%22My+App%22%2C%22color%22%3A%22%22%2C%22actions%22%3A%5B%5D%7D%2C%7B%22key%22%3A%22Memory%22%2C%22value%22%3A%22256+%2F+1024%22%2C%22color%22%3A%22%22%2C%22actions%22%3A%5B%5D%7D%2C%7B%22key%22%3A%22Date+%26+Time%22%2C%22value%22%3A%222019-Dec-28+13%3A37%3A00%22%2C%22color%22%3A%22gray%22%2C%22actions%22%3A%5B%5D%7D%2C%7B%22key%22%3A%22Debug+Stuff%22%2C%22value%22%3A%22Hello+World%21%22%2C%22color%22%3A%22cyan%22%2C%22actions%22%3A%5B1%5D%7D%2C%7B%22key%22%3A%22isSomethingFynny%22%2C%22value%22%3A%22Yes+you+Foo+Bar+%F0%9F%98%98%22%2C%22color%22%3A%22pink%22%2C%22actions%22%3A%5B2%5D%7D%5D%7D"
open "http://${mHost}/DevBoardViewer.php?refreshTime=10&theme=dark"

php -aS $mHost

