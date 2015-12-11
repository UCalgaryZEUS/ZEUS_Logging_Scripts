#!/usr/bin/env ruby

=begin
This Ruby script will be used to clean the raw data files.
It outputs two separate files, one for velocity and the other for position.
=end

dirtyFile = ARGV[0]
dirtyData = File.read(dirtyFile)
cleanVelData = dirtyData.scan(/(^.*#BESTVELA.*SOL_COMPUTED.*$)/)
cleanPosData = dirtyData.scan(/(^.*#BESTPOSA.*SOL_COMPUTED.*$)/)
File.open("cleanVelData.gps", "w+") {|file| file.puts(cleanVelData) }
File.open("cleanPosData.gps", "w+") {|file| file.puts(cleanPosData) }

