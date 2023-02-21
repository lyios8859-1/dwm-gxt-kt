#!/usr/bin/env python

import os
import sys
import subprocess
import re
import time
from typing import Tuple
import common

import psutil

icon_color="^c#333333^^b#ee82ee0x88^"
text_color="^c#333333^^b#ee82ee0x99^"
DELAY_TIME=1

filename= os.path.basename(__file__)
name=re.sub("\..*",'',filename)


def get_speed(val:int)->str:
  ret="0"
  if(val<1024) :
    ret="{:^8}".format(str(val)+"B")
  elif val<1048576 :
    ret="{:^8}".format("{:.1f}".format(val/1024)+"KB")
  else :
    ret="{:^8}".format("{:.1f}".format(val/1048576)+"MB")
  return ret

def getnet()->Tuple[str,str]:
    send_before = psutil.net_io_counters().bytes_sent  # 已发送的流量
    recv_before = psutil.net_io_counters().bytes_recv  # 已接收的流量
    time.sleep(DELAY_TIME)
    send_now = psutil.net_io_counters().bytes_sent
    recv_now = psutil.net_io_counters().bytes_recv
    send = (send_now - send_before)
    recv = (recv_now - recv_before)
    send_string=str(get_speed(send))
    recv_string=str(get_speed(recv))
    return (" "+send_string,""+recv_string)

def update(loop=False):
  while True :
    icon=""
    text=""
    for string in getnet():
      text+=string
    txt="^s"+str(name)+"^"+str(icon_color)+str(icon)+str(text_color)+str(text)
    common.write_to_file(txt+"\n",str(name))
    if loop == False : 
      os.system("xsetroot -name '"+str(txt)+"'")
      break
    # time.sleep(DELAY_TIME)


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
      pass
    else :
      click(sys.argv[1])
  else :
    update()
   
