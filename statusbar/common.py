#!/usr/bin/env python

import os
import fcntl
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
    fcntl.flock(f.fileno(), fcntl.LOCK_EX) 
    lines=f.readlines()
  with open(TEMP_FILE, 'w+') as f:
    fcntl.flock(f.fileno(), fcntl.LOCK_EX) 
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

if __name__ == "__main__":
  pass
   
