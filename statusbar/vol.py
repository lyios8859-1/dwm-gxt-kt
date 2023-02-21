#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


icon_color="^c#ffffff^^b#7b68ee0x88^"
text_color="^c#ffffff^^b#7b78ee0x99^"
DELAY_TIME=1

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def get_vol_content():
  vol_text="--"
  vol_icon="ﱝ"

  cmd="echo $(pactl info | grep 'Default Sink' | awk '{print $3}')"
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
  sink=str(result.stdout.decode('utf-8').replace('\n',''))

  cmd="echo $(pactl list sinks | grep "+str(sink)+" -A 6 | sed -n '7p' | grep 'Mute: no')"
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
  volumuted=str(result.stdout.decode('utf-8').replace('\n',''))

  cmd="echo $(pactl list sinks | grep "+str(sink)+" -A 7 | sed -n '8p' | awk '{printf int($5)}' )"
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
  vol_text=str(result.stdout.decode('utf-8').replace('\n',''))

  if volumuted=="" :
    vol_text="--"
    vol_icon="ﱝ"
  else :
    vol=int(vol_text)
    vol_text=vol_text+"%"
    if vol==0 : 
      vol_icon="婢"
      vol_text="00"
    elif vol<10 : vol_icon="奔" 
    elif vol<50 : vol_icon="奔"
    else : vol_icon="墳"
  return str(vol_icon)+str(vol_text)

def update(loop=False):
  while True :
    icon=""
    icon=" "+get_vol_content()+" "
    text=""
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(DELAY_TIME)

def notify(str='') :
  pass
  # cmd='notify-send "  CPU tops"  "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head  | '+"sed 's/$/&%/g')"+'"'+" -r 1014"
  # os.system(cmd)

def click(str='') :
  match str:
    case 'L':
      notify()
      pass
    case 'M':
      os.system("pactl set-sink-mute @DEFAULT_SINK@ toggle")
      pass
    case 'R':
      os.system("killall pavucontrol || pavucontrol --class floatingTerminal &")
      pass
    case 'U':
      pass
      os.system("pactl set-sink-volume @DEFAULT_SINK@ +5%; notify")
    case 'D':
      os.system("pactl set-sink-volume @DEFAULT_SINK@ -5%; notify")
      pass
    case  _: pass


if __name__ == "__main__":
  if len(sys.argv) > 1:
    if(sys.argv[1]=="update") :
      pass
    else :
      click(sys.argv[1])
  else :
    update()
