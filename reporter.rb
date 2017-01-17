#!/usr/bin/env ruby
require 'xcprofiler'
require 'influxdb'
include Xcprofiler

INFLUX_DB_TABLE_NAME = 'hiratsukatest2'

class InfluxDBReporter < AbstractReporter
  def report!(executions)
    client ||= InfluxDB::Client.new(
      ENV['INFLUXDB_DB_NAME'],
      host: ENV['INFLUXDB_HOST'],
      port: ENV['INFLUXDB_PORT'],
      username: ENV['INFLUXDB_USERNAME'],
      password: ENV['INFLUXDB_PASSWORD'],
    )

    print(executions)
    print("\n------------------------\n")
    payload = executions.map { |e|
      print(e.filename)
      print("\n------------------------\n")
      print(e.method_name)
      print("\n------------------------\n")
      print(e.time)
      key = "#{e.filename}:#{e.line}:#{e.column} #{e.method_name}"
      Hash[*[key, e.time]]
    }.reduce(&:merge)
    print("\n------------------------\n")
    print(payload)
    client.write_point(INFLUX_DB_TABLE_NAME, {values: payload})
  end
end

profiler = Profiler.by_product_name('FinalStudyEnglish')
profiler.reporters = [
  StandardOutputReporter.new(limit: 20, order: :time),
  InfluxDBReporter.new(limit: 20),
]
profiler.report!
