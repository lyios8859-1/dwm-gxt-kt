#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


icon_color="^c#222222^^b#ffff000x88^"
text_color="^c#222222^^b#ffff000x99^"
DELAY_TIME=1

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def connect_status():
  ret=-1
  cmd ="cat /sys/class/net/w*/operstate"
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
  connect=str(result.stdout.decode('utf-8').replace('\n',''))
  match connect:
    case "up": ret=1;
    case "down": ret=0;
    case _: ret=-1;
  return ret


def get_wifi_icon():
    icon="󱛏"
    connect_status_=connect_status()
    match connect_status_:
      case 0:
        cmd ="cat /sys/class/net/w*/flags"
        result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        flags=str(result.stdout.decode('utf-8').replace('\n',''))
        if(str(flags)=="0x1003") : icon="睊"
        else : icon = "󰤬"
        pass
      case 1:
        cmd = "echo $(awk '/^\s*w/ { print int($3 * 100 / 70)}' /proc/net/wireless)"
        result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        wifi_signal=int(result.stdout.decode('utf-8').replace('\n',''))
        if(wifi_signal>=80) : icon="󰤨"
        elif(wifi_signal>=60) : icon="󰤥"
        elif(wifi_signal>=40) : icon="󰤢"
        elif(wifi_signal>=20) : icon="󰤟"
        else : icon="󰤯"
      case _: icon="󱛏"
    return icon


def update(loop=False):
  while True :
    icon="󱛏"
    icon=" "+get_wifi_icon()+" "
    text=""
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(DELAY_TIME)

def notify(string='') :
  connect_status_=connect_status()
  match int(connect_status_):
    case 1:
      cmd="echo $(awk '/^\s*w/ { print int($3 * 100 / 70)}' /proc/net/wireless)"
      result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
      wifi_signal=int(result.stdout.decode('utf-8').replace('\n',''))
      cmd="echo $(nmcli -t -f name,device connection show --active | grep wlan0 | cut -d\: -f1)"
      result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
      wifi_name=result.stdout.decode('utf-8').replace('\n','')
      cmd="notify-send 'Wifi connected' "+"'Wifi name : "+str(wifi_name)+"\nSignal strength : "+str(wifi_signal)+"'"+" -r 1025"
      os.system(cmd)
    case -1:
      os.system("notify-send 'Wifi no connected' 'Press right buttom to open wifi connect tool.(nmtui)' -r 1024")
      pass
    case _:
      os.system("notify-send 'The wifi device is disable, please cheack your wifi device' 'Press right buttom to open wifi connect tool.(nmtui)' -r 1024")
      pass



def click(string='') :
  match string:
    case 'L':
      notify()
      os.system("echo 'LLL' >> python_debug")
    case 'M':
      os.system("nm-connection-editor")
      pass
      os.system("echo 'MMM' >> python_debug")
    case 'R':
      os.system("alacritty -t nmtui --class floatingTerminal -e nmtui ")
      os.system("echo 'RRR' >> python_debug")
    case 'U':
      pass
      os.system("echo 'UUU' >> python_debug")
    case 'D':
      pass
      os.system("echo 'DDD' >> python_debug")
    case  _: pass


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
   
