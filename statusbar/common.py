#!/usr/bin/env python

import os
# import sys
# import subprocess
import re
# import time

PACKAGES_PATH="/home/gxt_kt/my_desktop/dwm/statusbar/"
TEMP_FILE="/home/gxt_kt/python_tmp"

def write_to_file(string,package_name):
  if (os.path.exists(TEMP_FILE)==False):
    os.system("touch "+TEMP_FILE)
  with open(TEMP_FILE, 'r+') as f:
    lines=f.readlines()
  with open(TEMP_FILE, 'w+') as f:
    find=False
    for line in lines :
      flag=re.match("\^s"+package_name,line)
      if flag==None :
        f.write(line)
      else :
        f.write(string)
        find=True
    if find==False :
      f.write(string)


# def click(str='') :
#   match str:
#     case 'L':
#       os.system("echo 'LLL' >> python_debug")
#     case 'M':
#       os.system("echo 'MMM' >> python_debug")
#     case 'R':
#       os.system("echo 'RRR' >> python_debug")
#     case 'U':
#       os.system("echo 'UUU' >> python_debug")
#     case 'D':
#       os.system("echo 'DDD' >> python_debug")
#     case  _: pass

# def notify(str='') :
#   pass

if __name__ == "__main__":
  pass
   
