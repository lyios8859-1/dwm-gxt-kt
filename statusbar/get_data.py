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

# def getNet():
#     time.sleep(1)
#     sent_now = psutil.net_io_counters().bytes_sent
#     recv_now = psutil.net_io_counters().bytes_recv
#     sent = (sent_now - sent_before)/1024  # 算出1秒后的差值
#     recv = (recv_now - recv_before)/1024
#     print(time.strftime(" [%Y-%m-%d %H:%M:%S] ", time.localtime()))
#     print("上传：{0}KB/s".format("%.2f"%sent))
#     print("下载：{0}KB/s".format("%.2f"%recv))

if __name__=='__main__':
    match sys.argv[1] :
        case "cpu_temp" : 
            print(GetCpuTemp())
        case "cpu_usage" : 
            #print(GetCpuUsage())
            print(str(int(psutil.cpu_percent(0.2))))
        case "ram_usage" : 
            print(GetRamUsage())
        # case "upload" : 
        #     print(getNet())
        # case "download" : 
        #     print(GetRamUsage())

