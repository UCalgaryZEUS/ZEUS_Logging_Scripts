#!/usr/bin/env ruby

=begin
This Ruby script will be used to clean the raw data files.
It outputs a single file, containing velocity and position pairs.
=end

dirtyFile = ARGV[0]
dirtyData = File.read(dirtyFile)
cleanPairData = dirtyData.scan(/(^.*#BESTVELA.*SOL_COMPUTED.*$)|(^.*#BESTPOSA.*SOL_COMPUTED.*$)/)
File.open("cleanPairData.gps", "w+") {|file| file.puts(cleanPairData) }

