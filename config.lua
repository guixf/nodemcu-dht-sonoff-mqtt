-- GPIOS
GPIO_LED = 7  --sonoff is 7
GPIO_SWITCH = 6  --sonoff is 6
GPIO_DHT = 5 --sonoff is 5
GPIO_BUTTON = 3  --sonoff is 3

-- WiFi
WIFI_SSID = ""
WIFI_PASS = ""

-- Alarms
WIFI_ALARM_ID = 0
WIFI_LED_BLINK_ALARM_ID = 1
BUTTON_ID = 2

-- MQTT
MQTT_CLIENTID = node.chipid()
MQTT_HOST = "192.168.11.249"
MQTT_PORT = 1883
MQTT_MAINTOPIC = "home/Bed_room/" .. MQTT_CLIENTID
MQTT_USERNAME = ""
MQTT_PASSWORD = ""

-- Confirmation message
print("\nGlobal variables loaded...\n")
