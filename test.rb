#!/usr/bin/env ruby
require 'xcprofiler'
require 'influxdb'
include Xcprofiler

INFLUX_DB_TABLE_NAME = 'test4'

class InfluxDBReporter < AbstractReporter
  def report!(executions)
    client ||= InfluxDB::Client.new(
      ENV['INFLUXDB_DB_NAME'],
      host: ENV['INFLUXDB_HOST'],
      port: ENV['INFLUXDB_PORT'],
      username: ENV['INFLUXDB_USERNAME'],
      password: ENV['INFLUXDB_PASSWORD'],
    )

    # print(executions)
    # print("\n------------------------\n")
    # payload = executions.map { |e|
    #   print(e.filename)
    #   print("\n------------------------\n")
    #   print(e.method_name)
    #   print("\n------------------------\n")
    #   print(e.time)
    #   key = "#{e.filename}:#{e.line}:#{e.column} #{e.method_name}"
    #   Hash[*[key, e.time]]
    # }.reduce(&:merge)
    # print("\n------------------------\n")
    # print(payload)
    # client.write_point(INFLUX_DB_TABLE_NAME, {values: payload})

    # data = {
    #   :value => rand(10000) + 1,
    #   :time => Time.now.to_i
    # }
    # print(data)
    # client.write_point(INFLUX_DB_TABLE_NAME, data)

    executions.each do |e|

      data = {
        values: { filename: e.filename,line: e.line,column:e.column,method_name:e.method_name,how_long:e.time },
        tags:   { file_point: e.filename + '_' + e.line.to_s} # tags are optional
      }

      print(data)
      client.write_point(INFLUX_DB_TABLE_NAME, data)
    end


  end
end

profiler = Profiler.by_product_name('FinalStudyEnglish')
profiler.reporters = [
  StandardOutputReporter.new(limit: 20, order: :time),
  InfluxDBReporter.new(limit: 20),
]
profiler.report!
