require('ds18b20')

port = 80

-- pins
dht22Pin, ds18b20Pin = 4,5
-- ESP-01 GPIO Mapping

ds18b20.setup(ds18b20Pin)

srv=net.createServer(net.TCP)
srv:listen(port,
     function(conn)
     soilMoist = 100-100/421*(adc.read(0)-9)    
     status,dht22Temp,dht22Humidity = dht.read(dht22Pin)
          conn:send("HTTP/1.1 200 OK\nContent-Type: text/html\nRefresh: 5\n\n" ..
              "<!DOCTYPE HTML>" ..
              "<html><body>" ..
              "<b>ESP8266</b></br>" ..
              "Temperature from ds18b20: " .. ds18b20.read() .. "<br><br>" ..
	      "Status dht22: " .. status .. "<br>" ..
	      "Temperature from dht22: " .. dht22Temp .. "<br>" ..
	      "Humidity from dht22: " .. dht22Humidity .. "<br>" ..
	      "Soil moist: " .. soilMoist .. "<br>" ..

              "Node ChipID : " .. node.chipid() .. "<br>" ..
              "Node MAC : " .. wifi.sta.getmac() .. "<br>" ..
              "Node Heap : " .. node.heap() .. "<br>" ..
              "Timer Ticks : " .. tmr.now() .. "<br>" ..
              "</html></body>")          
          conn:on("sent",function(conn) conn:close() end)
     end
)