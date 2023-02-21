#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


icon_color="^c#3B001B^^b#ffb6c10x88^"
text_color="^c#3B001B^^b#ffb6c10x99^"
DELAY_TIME=5

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def update(loop=False,exec=True):
  while True :
    icon="󰒭 "
    text=""
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      if exec==True :
        os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(DELAY_TIME)


def click(str='') :
  match str:
    case 'L':
      os.system("playerctl next")
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
      pass
    else :
      click(sys.argv[1])
      update(exec=False)
  else :
    update()
   
