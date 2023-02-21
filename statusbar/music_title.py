#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


icon_color="^c#3B001B^^b#ffb6c10x88^"
text_color="^c#3B001B^^b#ffb6c10x99^"
DELAY_TIME=1

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def get_music_title():
    cmd="echo $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.yesplaymusic /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' "+"| cut -d '"+'"'+"' -f 2) 2>/dev/null"
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    title=result.stdout.decode('utf-8').replace('\n','')
    title=title.replace("'","") # 解决一些歌曲带'的问题
    return (title)

def update(loop=False):
  while True :
    icon="🎵"
    text=get_music_title()
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(DELAY_TIME)


def click(str='') :
  match str:
    case 'L':
      os.system("xdotool keydown Super m keyup m Super")
      os.system("echo 'LLL' >> python_debug")
    case 'M':
      pass
      os.system("echo 'MMM' >> python_debug")
    case 'R':
      pass
      os.system("echo 'RRR' >> python_debug")
    case 'U':
      pass
      os.system("echo 'UUU' >> python_debug")
    case 'D':
      pass
      os.system("echo 'DDD' >> python_debug")
    case  _: pass

def notify(str='') :
  pass

if __name__ == "__main__":
  if len(sys.argv) > 1:
    if(sys.argv[1]=="update") :
      print("update")
      os.system("echo 'update' >> python_debug")
      pass
    else :
      print("else")
      click(sys.argv[1])
  else :
    update()
   
