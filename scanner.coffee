fs = require 'fs'
noble = require 'noble'

FIELDS = 'DATE;UUID;LOCALNAME;SERVICEUUIDS;TXPOWERLEVEL;RSSI;MANUFACTURERDATA\n'
PATH = 'scan.csv'

fs.exists PATH, (exists) ->
  unless exists
    fs.writeFile PATH, FIELDS, (err) ->
      throw err if err
      console.log 'File created'


noble.on 'stateChange', (state) ->
  if state == 'poweredOn'
    noble.startScanning [], true
  else
    noble.stopScanning


noble.on 'discover', (peripheral) ->
  arr = []
  arr.push new Date().toString()
  arr.push peripheral.uuid
  arr.push peripheral.advertisement.localName
  arr.push JSON.stringify(peripheral.advertisement.serviceUuids)
  arr.push peripheral.advertisement.txPowerLevel
  arr.push peripheral.rssi
  arr.push peripheral.advertisement.manufacturerData.toString('hex')
  fs.appendFile PATH, arr.join(';') + '\n', (err) ->
    throw err if err
    console.log arr.join(';')
