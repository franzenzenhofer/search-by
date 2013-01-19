#! /bin/bash

osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' -e 'tell application "Terminal" to do script "subl -n ." in the last tab of window 1'

osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' -e 'tell application "Terminal" to do script "grunt watch" in the last tab of window 1'


coffee --watch --compile --output js/src/ js/coffee/
