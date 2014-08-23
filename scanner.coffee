fs = require 'fs'
noble = require 'noble'
Client = require('node-rest-client').Client
dateFormat = require('date-utils')

client = new Client()

FIELDS = 'DATE;UUID;LOCALNAME;SERVICEUUIDS;TXPOWERLEVEL;RSSI;MANUFACTURERDATA\n'
PATH = 'scan.csv'

logEntries = []

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
  obj = {}
  obj.date = new Date().toUTCFormat('DD/MMM/YYYY:HH:MI:SS')
  obj.uuid = peripheral.uuid
  obj.localName = peripheral.advertisement.localName
  obj.serviceUuids = JSON.stringify(peripheral.advertisement.serviceUuids)
  obj.txPowerLevel = peripheral.advertisement.txPowerLevel
  obj.rssi = peripheral.rssi
  obj.manufacturerData = peripheral.advertisement.manufacturerData.toString('hex') if peripheral.advertisement.manufacturerData
  # logEntries.push obj
  appendix = ''
  console.log peripheral
  for key in Object.keys(obj)
    appendix += obj[key] + ';'
  fs.appendFile PATH, appendix + '\n', (err) ->
    throw err if err
    console.log appendix

  # if logEntries.length > 100
  #   postEntries()


postEntries = ->
  tmp = logEntries
  logEntries = []
  args = {
    data: { entries: tmp },
    headers: { 'Content-Type': 'application/json' }
  }

  client.post 'http://requestb.in/18gc4kl1', args, (data, res) ->
    console.log 'Push'
