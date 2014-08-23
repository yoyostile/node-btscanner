noble = require 'noble'
async = require 'async'

noble.on 'stateChange', (state) ->
  if state == 'poweredOn'
    noble.startScanning(['180d'], false)
  else
    noble.stopScanning()


noble.on 'discover', (peripheral) ->
  console.log 'Heartrate found'
  noble.stopScanning()
  connectHeartRate(peripheral)

connectHeartRate = (peripheral) ->
  peripheral.connect (error) ->
    throw error if error
    console.log 'Heartrate connected'
    console.log peripheral.advertisement.localName
    peripheral.discoverServices ['180d'], (error, services) ->
      throw error if error
      for service in services
        service.discoverCharacteristics [], (error, chars) ->
          console.log chars
          chars[0].on 'notify', (state) ->
            console.log state
          chars[0].notify true
    # peripheral.disconnect()
