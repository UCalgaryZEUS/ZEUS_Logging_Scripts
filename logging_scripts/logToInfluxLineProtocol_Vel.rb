#!/usr/bin/env ruby

=begin
This Ruby script will be used to convert the cleaned velocity logs with
no header into the Line Protocol format that InfluxDB accepts as input.
This script can be applied to only the velocity files.
=end

class String
  def quote_strings
     self if Float self rescue "\"" + self + "\""
  end
end

logFile = ARGV[0]
velFields = []
File.read('velFieldNames.txt').each_line do |line|
    velFields << line.chomp
end
logData = []
dummyTime = 1450733657000 # Sunday Dec 27 ~3PM GMT
File.readlines(logFile).each do |line|
    line.gsub!(/\"\"/, 'NULL')
    logData = line.chomp.split(',')
    combined = logData.map.with_index{ |x, i| velFields.at(i) + "=" + x.quote_strings }
    dummyTime += 300000 # Add ~5min
    logInLP = combined.join(",").prepend("VelocityReading ") << " " + dummyTime.floor.to_s
    File.open("FieldsAdded_Vel.txt", "a+") {|file| file.puts(logInLP) }
end
