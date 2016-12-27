-- init all globals
function load_lib(fname)
    if file.open(fname .. ".lc") then
        file.close()
        dofile(fname .. ".lc")
    else
        dofile(fname .. ".lua")
    end
end

load_lib("config")

local wifiReady = 0
local firstPass = 0
ledOn = false

function configureWiFi()
    gpio.mode(GPIO_LED, gpio.OUTPUT)
	gpio.mode(GPIO_BUTTON, gpio.INPUT)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(WIFI_SSID, WIFI_PASS)
	turnWiFiLedOn()
    tmr.alarm(WIFI_ALARM_ID, 2000, 1, wifi_watch)
end

function wifi_watch() 
    status = wifi.sta.status()
    -- only do something if the status actually changed (5: STATION_GOT_IP.)
    if status == 5 and wifiReady == 0 then
        wifiReady = 1
        print("WiFi: connected with " .. wifi.sta.getip())
		turnWiFiLedOff()
		gpio.write(GPIO_SWITCH,gpio.LOW)
		--tmr.alarm(BUTTON_ID,1000,1,button_press)
		gpio.trig(GPIO_BUTTON, "down", button_press )
        load_lib("broker")
    elseif status == 5 and wifiReady == 1 then
        if firstPass == 0 then
            --load_lib("ota")
            --firstPass = 1
           -- tmr.stop(WIFI_LED_BLINK_ALARM_ID)
            --turnWiFiLedOn()
        end
    else
        wifiReady = 0
        turnWiFiLedOnOff()
        print("WiFi: (re-)connecting")

    end
end

function turnWiFiLedOnOff()
    tmr.alarm(WIFI_LED_BLINK_ALARM_ID, 200, 0, function()
        if ledOn then
            turnWiFiLedOff()
        else
            turnWiFiLedOn()
        end
    end)
end


function turnWiFiLedOn()
    gpio.write(GPIO_LED, gpio.LOW)
    ledOn = true
end
function turnWiFiLedOff()
    gpio.write(GPIO_LED, gpio.HIGH)
    ledOn = false
end

function button_press()
        if ledOn then
            turnWiFiLedOff()
			gpio.write(GPIO_SWITCH,gpio.LOW)
			ledOn = false
			print("button turn to OFF")
        else
            turnWiFiLedOn()
			gpio.write(GPIO_SWITCH,gpio.HIGH)
			ledOn = true
			print("button turn to ON")
        end

end

-- Configure
configureWiFi()
