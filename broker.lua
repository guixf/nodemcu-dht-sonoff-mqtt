local dispatcher = {}


function sendData()
	local temp, humi = getTempHumi()
		tempjson="{\"temperature\":\""..temp.."\",\"humidity\":\""..humi.."\"}"
		print("send .." .. tempjson)
		m:publish(MQTT_MAINTOPIC .."/sensor",tempjson,0,0)
		if ledOn then 
			m:publish(MQTT_MAINTOPIC .."/stat","on",0,0)
			print("send .." .. "on")
		else
			m:publish(MQTT_MAINTOPIC .."/stat","off",0,0)
			print("send .." .. "off")
		end
end

function getTempHumi()
  local status,temp,humi,temp_decimial,humi_decimial = dht.read(GPIO_DHT)
  if( status == dht.OK ) then
    -- Float firmware using this example
    --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
  elseif( status == dht.ERROR_CHECKSUM ) then
    print( "DHT Checksum error." );
  elseif( status == dht.ERROR_TIMEOUT ) then
    print( "DHT Time out." );
  end
  return temp, humi
end

-- client activation
m = mqtt.Client(MQTT_CLIENTID, 60, MQTT_USERNAME,MQTT_PASSWORD) -- no pass !

-- actions
function switch_power(m, pl)
	if pl == "on" then
		gpio.write(GPIO_SWITCH, gpio.HIGH)
		gpio.write(GPIO_LED,gpio.LOW)
		ledOn = true
		m:publish(MQTT_MAINTOPIC.."/stat","on",0,0)
		print("MQTT : plug ON for ", MQTT_CLIENTID)
	elseif( pl == "off") then 
		gpio.write(GPIO_SWITCH, gpio.LOW)
		gpio.write(GPIO_LED,gpio.HIGH)
		ledOn = false
		m:publish(MQTT_MAINTOPIC.."/stat","off",0,0)
		print("MQTT : plug OFF for ", MQTT_CLIENTID)

	end
end


-- events
m:lwt('/lwt', MQTT_CLIENTID .. " died !", 0, 0)

m:on('connect', function(m)
	print('MQTT : ' .. MQTT_CLIENTID .. " connected to : " .. MQTT_HOST .. " on port : " .. MQTT_PORT)
	m:subscribe(MQTT_MAINTOPIC..'/', 0, function (m)
		print('MQTT : subscribed to ', MQTT_MAINTOPIC) 
		if GPIO_DHT~=nil then 
			tmr.alarm(3,5000,1,sendData)
		end
	end)
end)

m:on('offline', function(m)
	print('MQTT : disconnected from ', MQTT_HOST)
end)

m:on('message', function(m, topic, pl)
	print('MQTT : Topic ', topic, ' with payload ', pl)
		switch_power(m,pl)

end)


-- Start
gpio.mode(GPIO_SWITCH, gpio.OUTPUT)
gpio.mode(GPIO_LED, gpio.OUTPUT)
dispatcher[MQTT_MAINTOPIC] = switch_power
m:connect(MQTT_HOST, MQTT_PORT, 0, 1)
