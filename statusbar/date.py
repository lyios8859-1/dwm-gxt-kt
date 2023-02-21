#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common

text_color="^c#000000^^b#ffffff0x99^"
icon_color="^c#000000^^b#ffffff0x99^"

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)



def update(loop=False):
  while True :
    icon=""
    text=time.strftime(" %H:%M:%S ", time.localtime())
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(1)

def click(str='') :
  match str:
    case 'L':
      pass
    case 'M':
      pass
    case 'R':
      pass
    case 'U':
      pass
    case 'D':
      pass
    case  _: pass

def notify(str='') :
  pass

if __name__ == "__main__":
  if len(sys.argv) > 1:
    if(sys.argv[1]=="update") :
      pass
    else :
      click(sys.argv[1])
  else :
    update()
   
