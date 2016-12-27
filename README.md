# nodemcu-dht-sonoff-mqtt
About

用于sonoff的开关，
将sonoff开关上的5个接口焊上针，方块为vcc，第2、3分别为tx、rx，第4为gnd，第5为dht接口
刷新为nodemcu-float-0.9.6.bin，写入上述程序，连接树莓派(192.168.11.249)。
树莓派上安装homebridge和 homeassistant就可以实现homekit功能。
Some nodemcu based code to run sonoff wifi enabled plugs through MQTT
config.lua : as its name implies
init.lua : runs the wifi connection and launches ota and broker modules
broker.lua ：用于mqtt订阅和发送消息，/为服务器端命令（on，off字符串）
，/stat为sonoff响应结果（on，off字符串）,/sensor为传感器定时反馈的值（json格式）
