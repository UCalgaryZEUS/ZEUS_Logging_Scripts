#!/usr/bin/env ruby

=begin
This Ruby script will be used to remove the log header.
This script can be applied to both the velocity and position files.
=end

logFile = ARGV[0]
logData = File.read(logFile)
dataNoHeader = logData.scan(/(SOL_COMPUTED.*$)/)
File.open("NoHeader_" + logFile, "w+") {|file| file.puts(dataNoHeader) }

