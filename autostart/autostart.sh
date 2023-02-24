#! /bin/sh
#
#
# If you find fcitx5 icon is located at the most left of the straybar, please increase the delay value
sleep 2 # need to wait dwm start complete and fcitx5 start complete

cfw &
crow &
blueman-manager &
copyq &

picom --experimental-backends&

killall statusbar.py
python3 ~/my_desktop/dwm/statusbar/statusbar.py cron &>/dev/null


~/my_desktop/dwm/autostart/autoscreen.sh&>/dev/null


libinput-gestures-setup start # touchpad open gesture
xinput --set-prop 15 'libinput Accel Speed' 0.5 # set touchpad sensitivity



cron() {
    [ $1 ] && sleep $1
    let i=1
    while true; do
        [ $((i % 3)) -eq 0 ] && ~/my_desktop/dwm/autostart/autoscreen.sh # check screen and autoset
        sleep 1; let i+=1
    done
}

cron 5&
