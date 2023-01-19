#! /bin/sh
#
source ~/.profile
${DWM}/statusbar/statusbar.sh cron &> ${DWM}/statusbar/logfile
picom --experimental-backends&

# If you find fcitx5 icon is located at the most left of the straybar, please increase the delay value
sleep 4 # need to wait dwm start complete and fcitx5 start complete

cfw &
crow &

libinput-gestures-setup start # touchpad
