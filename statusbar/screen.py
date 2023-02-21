#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
import common


icon_color="^c#ffffff^^b#7b68ee0x88^"
text_color="^c#ffffff^^b#7b78ee0x99^"
DELAY_TIME=3

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)

def update(loop=False):
  while True :
    icon=" 󰹑"

    cmd="echo $(xrandr | grep -w 'connected' | awk '{print $1}' | wc -l)"
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    connected_ports=result.stdout.decode('utf-8').replace('\n','')
    # print(connected_ports)

    cmd="echo $(xrandr --listmonitors | sed 1d | awk '{print $4}' | wc -l)"
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    connected_monitors=result.stdout.decode('utf-8').replace('\n','')
    # print(connected_monitors)

    text=" "+str(connected_monitors)+"/"+str(connected_ports)+" "
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    time.sleep(DELAY_TIME)

def get_all_screen_status() :
    eDP=""
    HDMI=""
    DP=""

    cmd='xrandr | rg "\\beDP.*? .*? " -o'
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    eDP=result.stdout.decode('utf-8')

    cmd='xrandr | rg "\\bHDMI.*? .*? " -o'
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    HDMI=result.stdout.decode('utf-8')

    cmd='xrandr | rg "\\bDP.*? .*? " -o'
    result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    DP=result.stdout.decode('utf-8')

    return (eDP,HDMI,DP)

def Set_4k_L____2k_P_R_2_0():
  os.system("\
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 2.0x2.0 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal \
  ")
  pass
def Set_4k_L____2k_P_R_1_75():
  os.system("\
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 1.75x1.75 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal \
  ")
  pass
def Set_4k_L____2k_P_R_1_5():
  os.system("\
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 1.5x1.5 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal \
  ")
  pass
def Set_4k_S___1k_S_2_0():
  os.system("\
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 1920x1080 --rate 60 --scale 2x2 --pos 0x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal \
  ")
  pass
def Set_4k_Single():
  os.system("\
  xrandr  --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output eDP-1-0 --mode 3840x2160   --rate 60 --dpi 192 \
  ")
  pass

def screen_rofi_set() :
    #      key:display information   value:function
    choose={"4k(L)+2k(P)(R)(2.0)":"Set_4k_L____2k_P_R_2_0",
            "4k(L)+2k(P)(R)(1.75)":"Set_4k_L____2k_P_R_1_75",
            "4k(L)+2k(P)(R)(1.5)":"Set_4k_L____2k_P_R_1_5",
            "4k(S)+1k(S)(2)":"Set_4k_S___1k_S_2_0",
            "4k_Single":"Set_4k_Single",
            }
    cmd="echo $(echo -e '"
    for choose_string in choose.keys():
      cmd+=choose_string+"\\n"
    cmd=cmd[:-2]
    cmd+="' | rofi -dmenu -window-title Screen)"
    print(cmd)
    result = subprocess.run(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    choose_ret=result.stdout.decode('utf-8').replace("\n","")
    print(choose_ret)
    match_function=choose[choose_ret]
    try:
      exec(str(match_function)+"()")
    except Exception:
      pass

def notify(str='') :
    send_string=""
    for string in get_all_screen_status():
      send_string+=string
    os.system("notify-send "+" '󰹑 Screen Info' "+"'"+send_string+"'")
    pass

def click(str='') :
  match str:
    case 'L':
      notify()
      screen_rofi_set()
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
