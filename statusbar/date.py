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
      os.system("echo 'LLL' >> python_debug")
    case 'M':
      os.system("echo 'MMM' >> python_debug")
    case 'R':
      os.system("echo 'RRR' >> python_debug")
    case 'U':
      os.system("echo 'UUU' >> python_debug")
    case 'D':
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
   
