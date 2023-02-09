#! /bin/sh
#
source ~/.profile
killall statusbar.sh
${DWM}/statusbar/statusbar.sh cron &> ${DWM}/statusbar/logfile
picom --experimental-backends&

# If you find fcitx5 icon is located at the most left of the straybar, please increase the delay value
sleep 0 # need to wait dwm start complete and fcitx5 start complete

cfw &
crow &
blueman-manager &
copyq &

libinput-gestures-setup start # touchpad open gesture
xinput --set-prop 15 'libinput Accel Speed' 0.4 # set touchpad sensitivity
