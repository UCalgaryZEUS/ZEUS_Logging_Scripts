#!/usr/bin/env ruby


=begin
This Ruby script will be used to clean the raw data files.
It outputs a single file, containing velocity and position data
necessary for use in a MYSQL DB.
=end

GPS_EPOCH = Time.new(1980,1,6,0,0,0,"-07:00")

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
    timeHR.utc
    puts timeHR.strftime("%c + %L")
    return timeHR
end


dirtyFile = ARGV[0]
dirtyData = File.read(dirtyFile)
cleanPairData = dirtyData.scan(/(#BESTVELA.*SOL_COMPUTED.*$|#BESTPOSA.*SOL_COMPUTED.*$)/)
cleanPairData = cleanPairData.flatten.each_slice(2).to_a

=begin
1. Take valid reading pairs
2. Extract the following:
    a) "timestamp" grabbed either from pos or vel reading, both should have the same time if they
    are a proper pair
    b) time, acceleration [derived], velocity [derived using: vertical speed, horizontal speed, direction], lat, long, altitude
3. Print that extracted information on a single line
=end

#Surround the below in a loop to iterate through each pair element in the array

singlePair = cleanPairData.at(0).flatten.join(', ').split(", ")
# Index 0 should be pos data, 1 should be vel
posChunk = singlePair.at(0).split(",")
velChunk = singlePair.at(1).split(",")
gpsWeek = posChunk.at(5).to_i
gpsSec = posChunk.at(6).to_f
humanTime = gpsTimetoHR(gpsWeek, gpsSec)
vertSpd = velChunk.at(13).to_f
direction = velChunk.at(14).to_f #in degrees with respect to True North
horiSpd = velChunk.at(15).to_f
lat = posChunk.at(11).to_f
long = posChunk.at(12).to_f
altitude = posChunk.at(13).to_f

#File.open("cleanDataForSQLDB.txt", "w+") {|file| file.puts(dataForSQLDB) }
