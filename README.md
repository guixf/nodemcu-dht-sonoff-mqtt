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


安装homeassistant和homebridge
注意：homebridge配置文件在var目录中


sudo nano /etc/apt/sources.list

deb http://mirrors.aliyun.com/raspbian/raspbian/ jessie main non-free contrib
deb-src http://mirrors.aliyun.com/raspbian/raspbian/ jessie main non-free contrib

sudo apt-get update

sudo apt-get install -y samba screen git

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo apt-get -y install libavahi-compat-libdnssd-dev

sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp

cd /usr/lib/node_modules/homebridge/

sudo npm install --unsafe-perm bignum

cd /usr/lib/node_modules/hap-nodejs/node_modules/mdns

sudo node-gyp BUILDTYPE=Release rebuild

cd /

sudo npm install -g homebridge-homeassistant

homebridge           #####杩欓噷鍏堣繍琛屼竴娆＄▼搴�######

######閿洏杈撳叆Ctrl+C鍋滄homebridge杩愯锛屽皢鍐嶆鍑虹幇鍛戒护鎻愮ず绗�######

cd /home/pi/.homebridge

###########閿洏杈撳叆Ctrl+C鍋滄锛岀劧鍚庡缓绔媍onfig.json閰嶇疆鏂囦欢########

sudo nano config.json

################榧犳爣鍙抽敭绮樿创濡備笅鍐呭######################

{
    "bridge": {
        "name": "Homebridge",
        "username": "CC:22:3D:E3:CE:30",
        "port": 51826,
        "pin": "123-45-678"
    },
    
    "platforms": [
  {
    "platform": "HomeAssistant",
    "name": "HomeAssistant",
    "host": "http://192.168.1.200:8123",
    "password": "raspberry",
    "supported_types": ["fan", "garage_door", "input_boolean", "light", "lock", "media_player", "rollershutter", "scene", "switch"]
  }
    ]
}

###################鍒嗙晫绾�#####################################
涓婇潰鐨勫唴瀹癸紝娉ㄦ剰鏍煎紡锛岀矘璐村畬姣曞悗锛屾寜閿洏涓婄殑Ctrl+X閿紝杈撳叆 Y锛屼繚瀛橀€€鍑恒€�


鍙﹀锛氳娉ㄦ剰杩欏嚑娈垫浠ｇ爜
   "username": "CC:22:3D:E3:CE:30",   ###杩欎釜MAC鍦板潃锛屽彲浠ヤ慨鏀规垚鑷繁鏍戣帗娲剧殑MAC鍦板潃###
   "port": 51826,                     ###閫氳绔彛锛屽彲浠ヤ慨鏀癸紝浣嗘垜瑙夊緱涓嶇敤淇敼### 
   "pin": "123-45-678"                ###PIN鐮侊紝浠绘剰淇敼锛屾牸寮忔槸XXX-XX-XXX锛屽彧鑳芥槸鏁板瓧####

"host": "http://192.168.1.200:8123",      
###鍏朵腑鐨�192.168.1.200鏄綘鐨勬爲鑾撴淳鐨勫眬鍩熺綉IP鍦板潃####

 "password": "raspberry",
###杩欎釜鏄瘑鐮侊紝鍥犱负鎴戜滑娌℃湁淇敼鏍戣帗娲剧殑鐧诲綍瀵嗙爜锛屾墍浠ヨ繖閲屾槸raspberry#### 


##############鍐嶆杈撳叆homebridge  鍥炶溅锛屾鏌ヨ繍琛屾湁娌℃湁閿欒########


####灏唄omebridge璁剧疆鎴愰殢绯荤粺鍚姩######
cd /

sudo useradd --system homebridge

sudo mkdir /var/homebridge

sudo cp ~/.homebridge/config.json /var/homebridge/

sudo cp -r ~/.homebridge/persist /var/homebridge

sudo chmod -R 0777 /var/homebridge

cd /etc/default

sudo nano homebridge

#########灏嗕笅闈㈢殑鍐呭澶嶅埗绮樿创杩涘幓锛岀劧鍚嶤trl+X锛岀劧鍚嶻锛屽洖杞︼紝淇濆瓨閫€鍑�####

# Defaults / Configuration options for homebridge
# The following settings tells homebridge where to find the config.json file and where to persist the data (i.e. pairing and others)
HOMEBRIDGE_OPTS=-U /var/homebridge

# If you uncomment the following line, homebridge will log more 
# You can display this via systemd's journalctl: journalctl -f -u homebridge
# DEBUG=*

####鍒嗙晫绾�#####################################

cd /etc/systemd/system

sudo nano homebridge.service

#########灏嗕笅闈㈢殑鍐呭澶嶅埗绮樿创杩涘幓锛岀劧鍚嶤trl+X锛岀劧鍚嶻锛屽洖杞︼紝淇濆瓨閫€鍑�####

[Unit]
Description=Node.js HomeKit Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=homebridge
EnvironmentFile=/etc/default/homebridge
ExecStart=/usr/lib/node_modules/homebridge/bin/homebridge $HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target

####鍒嗙晫绾�#####################################

cd /

sudo systemctl daemon-reload

sudo systemctl enable homebridge

sudo systemctl start homebridge

sudo systemctl status homebridge

sudo reboot      ####閲嶅惎鏍戣帗娲�####

###鏈€鍚庯紝浣犳兂杩斿洖鍘讳慨鏀筆IN鐮侊紝MAC鍦板潃绛夌瓑鍙傛暟锛屽彲浠ユ寜浠ヤ笅鍛戒护琛屾潵鍋�####

sudo systemctl stop homebridge         ###鍋滄homebridge杩愯###

cd /var/homebridge                     ###杩涘叆鐩綍###   

sudo nano config.json                  ###缂栬緫閰嶇疆鏂囦欢###                 

sudo reboot                            ###閲嶅惎鏍戣帗娲�#### 

