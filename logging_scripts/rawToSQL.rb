#!/usr/bin/env ruby


=begin
This Ruby script will be used to clean the raw data files.
It outputs a single file, containing velocity and position data
necessary for use in a MYSQL DB.
=end

GPS_EPOCH = Time.new(1980,1,6,0,0,0,"-07:00")
UNIX_EPOCH_OFFSET = 315964800 # seconds between Jan 1 1970 and Jan 6 1980
INITIAL_TIME = 0
INITIAL_SPEED = 0
FILE_NAME = Time.now.strftime("%Y-%m-%d_%H-%M-%S")


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


dirtyFile = ARGV[0]
dirtyData = File.read(dirtyFile)
cleanPairData = dirtyData.scan(/(#BESTPOSA.*SOL_COMPUTED.*$|#BESTVELA.*SOL_COMPUTED.*$|#BESTXYZA.*SOL_COMPUTED.*$)/)

=begin rough work for robust error-checking/ordering
puts cleanPairData.to_s
puts cleanPairData.at(0).to_s
cleanPairData.at(1).grep(/.*BESTVELA.*/) { |match| puts true }
=end

cleanPairData = cleanPairData.flatten.each_slice(3).to_a

#Sanitize the data: Remove "pairs" that are only a single pos or vel reading
cleanPairData.delete_if { |a| a.count == 1 }

=begin
1. Take valid reading pairs
2. Extract the following:
    a) "timestamp" grabbed either from pos or vel reading,
    both should have the same time if they are a proper pair
    b) time, acceleration [derived], velocity [derived using: vertical speed,
    horizontal speed, direction], lat, long, altitude
3. Print that extracted information on a single line
=end

prevTime = INITIAL_TIME
prevVel = INITIAL_SPEED

cleanPairData.each do |pair|
    singlePair = pair.flatten.join(', ').split(", ")
    # Index 0 should be pos data, 1 should be vel, 2 should be xyz
    posChunk = singlePair.at(0).split(",")
    velChunk = singlePair.at(1).split(",")
    xyzChunk = singlePair.at(2).split(",")
    # Shouldn't matter whether the time is taken from pos/vel/xyz, provided the
    # grouping logic is sufficient (This is a WIP - TODO)
    gpsWeek = posChunk.at(5).to_i
    gpsSec = posChunk.at(6).to_f
    humanTime = gpsTimetoHR(gpsWeek, gpsSec)
    #puts humanTime.to_f # seconds since Unix Epoch
    #puts humanTime.to_f - 315964800 # seconds since GPS epoch

    timeElapsed = gpsSec - prevTime
    prevTime = gpsSec

    vertSpd = velChunk.at(13).to_f
    direction = velChunk.at(14).to_f #in degrees with respect to True North
    horiSpd = velChunk.at(15).to_f
    velocity = Math.sqrt(vertSpd**2 + horiSpd**2) # Probably not accurate at all

    acceleration = (velocity - prevVel)/(timeElapsed)
    prevVel = velocity
    velocity = velocity.round(5)
    acceleration = acceleration.round(5)

    lat = posChunk.at(11).to_f
    long = posChunk.at(12).to_f
    altitude = posChunk.at(13).to_f
    #TODO: Determine what information to extract from XYZ logs

    dataForSQLDB = humanTime.strftime("%Y-%m-%d %H:%M:%S.%L") + "," + acceleration.to_s + "," + velocity.to_s + "," + lat.to_s + "," + long.to_s + "," + altitude.to_s
    File.open("/opt/ZEUS/parsed_datalogs/sql_parsed/#{FILE_NAME}.csv", "a+") {|file| file.puts(dataForSQLDB) }
end
