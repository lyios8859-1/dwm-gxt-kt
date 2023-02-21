#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


text_color="^c#4169e1^^b#7fffd40x99^"
icon_color="^c#4169e1^^b#7fffd40x99^"
DELAY_TIME=3000

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def get_update_packages_nums():
  num=0
  os.system("notify-send 'Updating... ... ...' -r 1011")
  os.system("sudo pacman -Sy")
  os.system("notify-send 'Updating completed !' -r 1011")
  cmd="echo $(pacman -Qu | grep -Fcv '[ignored]' )"
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
  num=int(result.stdout.decode('utf-8').replace('\n',''))
  os.system("notify-send 'Totally "+str(num)+" packages need to update' -r 1011")
  return str(num)


def update(loop=False,exec=True):
  while True :
    icon=" "
    text=str(get_update_packages_nums())+" "
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      if exec==True :
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
    case 'M':
      pass
    case 'R':
      pass
    case 'U':
      pass
    case 'D':
      pass
    case  _: pass


if __name__ == "__main__":
  if len(sys.argv) > 1:
    if(sys.argv[1]=="update") :
      pass
    else :
      click(sys.argv[1])
      update(exec=False)
  else :
    update()
 
