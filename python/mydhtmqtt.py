#!/usr/bin/env python3
"""
Python3 utility to broadcast data received from a DHT22 to AM2302 sensor over MQTT.
The sensor driver is based on example code from the pigpio project upon which this utility relies.
Depends on pigpio daemon running and on paho-mqtt 
"""
__author__ = "Guixf"

import sys
import Adafruit_DHT
import argparse
import time
import json
import paho.mqtt.client as mqtt

def runService(sensor, client, topic_stem, interval):
    "Runs the DHT2MQTT service, broadcasting data at the requested interval"
    tempTopic = topic_stem + '/temperature'
    humTopic  = topic_stem + '/humidity'
    while True:
        ts = time.time()
        #sensor.trigger()
        humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
        time.sleep(2)
        THchart = '{\"temperature\":\"'+str(temperature)+'\",\"humidity\":\"'+str(humidity)+'\"}'
        #if (sensor.staleness < interval): # Actually have a new sensor reading to publish
        #client.publish(tempTopic, json.dumps(temperature), qos=0, retain=True)
        #client.publish(tempTopic, json.dumps(temperature), qos=0, retain=True)
        client.publish(topic_stem, THchart,    qos=0, retain=True)
        print(json.dumps(temperature))
        time.sleep(interval - (time.time()-ts))

if __name__ == "__main__":
    #parser = argparse.ArgumentParser()
    #parser.add_argument("pin", type=int, help="The GPIO pin connected to the sensor's data pin")
    #parser.add_argument("topic", type=str, help="The topic stem, data will be broadcast as topic/temperature and topic/humidity")
    #parser.add_argument('-i', "--interval", type=int, default=30, help="Number of seconds between sensor samples")
    #parser.add_argument('-r', "--power", type=int, help="Optional GPIO pin controlling sensor power, useful for resetting the sensor")
    #parser.add_argument('-l', "--LED", type=int, help="Optional GPIO pin to blink an LED every time the sensor is sampled")
    #parser.add_argument("-c", "--clientID", type=str, default="", help="MQTT client ID for the counter node")
    #parser.add_argument("-b", "--brokerHost", type=str, default="localhost", help="MQTT Broker hostname or IP address")
    #parser.add_argument('-p', "--brokerPort", type=int, help="MQTT Broker port")
    #parser.add_argument('-u', "--user", type=int, help="MQTT client username")
    #parser.add_argument('-P', "--password", type=int, help="MQTT client password")
    #parser.add_argument('-v', "--verbose", action="count", help="Increase debugging verbosity")
    #args = parser.parse_args()

    #brokerConnect = [args.brokerHost]
    brokerConnect = "localhost"
    #if args.brokerPort: brokerConnect.append(args.brokerPort)
    #if args.brokerKeepAlive: brokerConnect.append(args.brokerKeepAlive)
    #if args.bind: brokerConnect.append(args.bind)
    
    #pi = pigpio.pi()
    # Default MQTT server to connect to
    SERVER = "127.0.0.1"
    CLIENT_ID = "Raspi-1"
    TOPIC = "office/sensor1"
    username='xxxxx'
    password='xxxxxxx'
    state = 0
    interval = 30

    sensor = Adafruit_DHT.DHT22
    pin = 27
    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
    c = mqtt.Client()
    c.username_pw_set(username, password)
    c.loop_start()
    c.connect(SERVER,1883,60)
    
    runService(sensor, c, TOPIC, interval)
    
    c.loop_stop()
    
