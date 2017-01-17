#!/usr/bin/env ruby
require 'xcprofiler'
require 'influxdb'

username       = ENV['INFLUXDB_USERNAME']
password       = ENV['INFLUXDB_PASSWORD']
database       = ENV['INFLUXDB_DB_NAME']
name           = 'testtest'
time_precision = 's'

# either in the client initialization:
influxdb = InfluxDB::Client.new database,
  username: username,
  password: password,
  time_precision: time_precision

data = {
  values: { value: 0,aaaaa: "testtest" },
  timestamp: Time.now.to_i # timestamp is optional, if not provided point will be saved with current time
}

influxdb.write_point(name, data)

# or in a method call:
influxdb.write_point(name, data, time_precision)
