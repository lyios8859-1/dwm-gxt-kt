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


# ref: https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level
# Bug need Install : pip3 install git+https://github.com/pybluez/pybluez@master
def GetBluetoothBattery():
    from bluetooth_battery import BatteryStateQuerier, BatteryQueryError, BluetoothError
    try:
        # Autodetects SPP port
        # query = BatteryStateQuerier( "11:22:33:44:55:66")  # Can raise BluetoothError when autodetecting port
        query = BatteryStateQuerier("94:37:F7:73:DB:03")
        # # or with given port
        # query = BatteryStateQuerier("11:22:33:44:55:66", "4")
        # result = int(query)  # returns integer between 0 and 100
        # or
        # result = str(query)  # returns "0%".."100%"
        icon="󰥊"
        result =int(query)
        if(result>=95) : icon="󰥈"
        elif(result>=90) : icon="󰥆"
        elif(result>=80) : icon="󰥅"
        elif(result>=70) : icon="󰥄"
        elif(result>=60) : icon="󰥃"
        elif(result>=50) : icon="󰥂"
        elif(result>=40) : icon="󰥁"
        elif(result>=30) : icon="󰥀"
        elif(result>=20) : icon="󰤿"
        elif(result>=10) : icon="󰤾"
        else : icon="󰥇"

        # print(result)
        # result = str(query)  # Can raise BluetoothError when device is down or port is wrong
        # print(result)
        # return str("󰥰"+result)
        return str(icon)
        # Can raise BatteryQueryError when the device is unsupported
    except BluetoothError as e:
        # Handle device is offline
        # print("Handle device is offline")
        return "󱔑"
        ...
    except BatteryQueryError as e:
        # Handle device is unsupported
        # print("Handle device is unsupported")
        return "󱃓"
        ...

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
        case "bluetooth_battery" :
            print(GetBluetoothBattery())
