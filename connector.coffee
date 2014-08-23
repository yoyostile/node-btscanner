noble = require 'noble'

noble.on 'stateChange', (state) ->
  if state == 'poweredOn'
    noble.startScanning [], true
  else
    noble.stopScanning


noble.on 'discover', (peripheral) ->
  if peripheral.advertisement.manufacturerData.toString('hex') == '4c000906007bc0a8006f'
      console.log 'found'
      peripheral.connect (err) ->
        peripheral.discoverAllServicesAndCharacteristics (error, services, characteristics) ->
          # console.log services
