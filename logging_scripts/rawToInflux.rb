#!/usr/bin/env ruby

=begin
This Ruby script will be used to clean the raw data files.
It outputs two separate files, one for velocity and the other for position.
These files are in the necessary format for InfluxDB
=end

GPS_EPOCH = Time.new(1980,1,6,0,0,0,"-07:00")
UNIX_EPOCH_OFFSET = 315964800

# used for converting days into seconds
class Fixnum
    def days
        self * 86400
    end
end

# used for converting GPS time to a human-readable format
def gpsTimetoHR(week, seconds)
    d = week * 7
    timeHR = GPS_EPOCH + d.days + seconds
    # below line could potentially mess up time
    #timeHR.utc
    return timeHR
end

class String
  def quote_strings
     self if Float self rescue "\"" + self + "\""
  end
end

posFields = []
File.read('/opt/ZEUS/logger_scripts/posFieldNames.txt').each_line do |line|
    posFields << line.chomp
end

velFields = []
File.read('/opt/ZEUS/logger_scripts/velFieldNames.txt').each_line do |line|
    velFields << line.chomp
end

xyzFields = []
File.read('/opt/ZEUS/logger_scripts/xyzFieldNames.txt').each_line do |line|
    xyzFields << line.chomp
end

dirtyFile = ARGV[0]
dirtyData = File.read(dirtyFile)
cleanPosData = dirtyData.scan(/(^.*#BESTPOSA.*SOL_COMPUTED.*$)/)
cleanVelData = dirtyData.scan(/(^.*#BESTVELA.*SOL_COMPUTED.*$)/)
cleanXYZData = dirtyData.scan(/(^.*#BESTXYZA.*SOL_COMPUTED.*$)/)

# Could remove the header later on by splitting the array entries by a ';'
# Need the header initially in order to extract the timestamp for the log

def extractData(cleanData, fields, readingName, type)
  logData = []
  cleanData.each do |entry|
      # Perform timestamp extraction before removing header
      log = entry.join(",").split(';')
      # log[0] is the header, log[1] is the data
      header = log.at(0).split(',')
      gpsWeek = header.at(5).to_i
      gpsSec = header.at(6).to_f
      humanTime = gpsTimetoHR(gpsWeek, gpsSec)
      timestamp = humanTime.to_f * 1000 # milliseconds since Unix Epoch

      log.at(1).gsub!(/\"\"/, 'NULL')
      logData = log.at(1).chomp.split(',')
      combined = logData.map.with_index{ |x, i| fields.at(i) + "=" + x.quote_strings }

      logInLP = combined.join(",").prepend(readingName) << " " + timestamp.to_i.to_s
      File.open("/opt/ZEUS/parsed_datalogs/influx_parsed/"+ type +"logs.txt", "a+") {|file| file.puts(logInLP) }
  end
end

extractData(cleanPosData, posFields, "PositionReading", "position")
extractData(cleanVelData, velFields, "VelocityReading", "velocity")
extractData(cleanXYZData, xyzFields, "XYZReading", "xyz")
