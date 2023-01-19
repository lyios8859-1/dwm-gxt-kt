import sys
import psutil


def GetCpuTemp():
    tempFile = open("/sys/class/thermal/thermal_zone0/temp")
    cpu_temp = tempFile.read()
    tempFile.close()
    return str(int(float(cpu_temp)/1000 ))

def GetCpuUsage():
    return str(int(psutil.cpu_percent(0.3)))

def GetRamUsage():
    return str(int(psutil.virtual_memory()[2]))

if __name__=='__main__':
    match sys.argv[1] :
        case "cpu_temp" : 
            print(GetCpuTemp())
        case "cpu_usage" : 
            #print(GetCpuUsage())
            print(str(int(psutil.cpu_percent(0.2))))
        case "ram_usage" : 
            print(GetRamUsage())

