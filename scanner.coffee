fs = require 'fs'
noble = require 'noble'

FIELDS = 'DATE;UUID;LOCALNAME;SERVICEUUIDS;TXPOWERLEVEL;RSSI;MANUFACTURERDATA\n'
PATH = 'scan.log'

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
  s = new Date().toString() + ';'
  s += peripheral.uuid + ';'
  s += peripheral.advertisement.localName + ';'
  s += JSON.stringify(peripheral.advertisement.serviceUuids) + ';'
  s += peripheral.advertisement.txPowerLevel + ';'
  s += peripheral.rssi + ';'
  s += peripheral.advertisement.manufacturerData.toString('hex') + '\n'
  fs.appendFile PATH, s, (err) ->
    throw err if err
    console.log s
