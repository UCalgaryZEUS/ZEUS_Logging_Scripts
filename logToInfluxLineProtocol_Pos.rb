#!/usr/bin/env ruby

=begin
This Ruby script will be used to convert the cleaned position logs with
no header into the Line Protocol format that InfluxDB accepts as input.
This script can be applied to only the position files.
=end

logFile = ARGV[0]
posFields = []
File.read('posFieldNames.txt').each_line do |line|
    posFields << line.chomp
end
logData = []
File.readlines(logFile).each do |line|
    line.gsub!(/\"/, 'NULL')
    logData = line.chomp.split(',')
    logData.map! { |x| "\"" + x + "\""}
    combined = logData.map.with_index{ |x, i| posFields.at(i) + "=" + x }
    logInLP = combined.join(",").prepend("LocationReading ")
    File.open("FieldsAdded_Pos.txt", "a+") {|file| file.puts(logInLP) }
end

