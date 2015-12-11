#!/usr/bin/env ruby

=begin
This Ruby script will be used to convert the cleaned velocity logs with
no header into the Line Protocol format that InfluxDB accepts as input.
This script can be applied to only the velocity files.
=end

logFile = ARGV[0]
posFields = []
File.read('velFieldNames.txt').each_line do |line|
    posFields << line.chomp
end
logData = []
File.readlines(logFile).each do |line|
    line.gsub!(/\"/, 'NULL')
    logData = line.chomp.split(',')
    logData.map! { |x| "\"" + x + "\""}
    combined = logData.map.with_index{ |x, i| posFields.at(i) + "=" + x }
    logInLP = combined.join(",").prepend("VelocityReading ")
    File.open("FieldsAdded_Vel.txt", "a+") {|file| file.puts(logInLP) }
end

