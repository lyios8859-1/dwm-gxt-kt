#! /bin/sh
#
source ~/.profile
${DWM}/statusbar/statusbar.sh cron &> ${DWM}/statusbar/logfile
picom --experimental-backends&

