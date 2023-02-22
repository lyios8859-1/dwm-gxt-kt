#!/usr/bin/env python

import os
import sys
import fcntl
import subprocess
import _thread
import time
import re
import common

packages_list=[
               'music_title',
               'music_pre',
               'music_play',
               'music_next',
               'icon',
               'screen',
               # 'pacman',
               # 'net',
               # 'cpu',
               # 'memory',
               # 'wifi',
               # 'vol',
               # 'battery',
               'date',
               ]


# import packages
for name in packages_list:
  exec('import ' + str(name))


def ExecOtherFile():
  cmd='python3 '+ common.PACKAGES_PATH + str(sys.argv[1]) + '.py '
  for string in sys.argv[2:]:
    cmd=cmd+string+' '
  result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)


def Run() :
  tmp=""
  i=0
  # add new thread
  for name in packages_list:
    exec("_thread.start_new_thread("+str(name)+".update,(True,))")

  while True :
    common.threadLock.acquire()
    tmp=""
    if (os.path.exists(common.TEMP_FILE)==False):
      os.system("touch "+common.TEMP_FILE)
    with open(common.TEMP_FILE, 'r+') as f:
      lines=f.readlines()
      while i<len(packages_list) :
        name=packages_list[i]
        i=i+1
        match_string="^\^s"+str(name)
        for line in lines :
          flag=re.match(str(match_string),line)
          if flag!=None :
            exec(str(name)+"_txt"+"=line.encode('utf-8').decode('utf-8').replace('\\n','')")
            tmp+=locals()[str(name)+"_txt"]
            break
      i=0
    common.threadLock.release()
    os.system("xsetroot -name '"+str(tmp)+"'")
    time.sleep(1)



if __name__ == "__main__":
  if len(sys.argv) > 1:
    if(sys.argv[1]=="cron") :
      Run()
      pass
    elif(sys.argv[1]=="update") :
      pass
    else :
      # for string in sys.argv :
      #   print(string)
      #   # cmd="echo '" +str(string) + "'" + ">> python_debug"
      #   cmd="echo '" +str(string) + "'"
      #   # cmd = "echo '123' >> python_debug"
      #   result = subprocess.run(cmd, shell=True, timeout=3, stderr=subprocess.PIPE, stdout=subprocess.PIPE)

      ExecOtherFile()
  # Run()
   
