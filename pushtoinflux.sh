#!/bin/bash
# Perform cURL request to move cleaned data files to InfluxDB

curl -i -XPOST 'http://localhost:8086/write?db=zeus_logs&precision=ms' --data-binary @/opt/ZEUS/parsed_datalogs/influx_parsed/positionlogs.txt

curl -i -XPOST 'http://localhost:8086/write?db=zeus_logs&precision=ms' --data-binary @/opt/ZEUS/parsed_datalogs/influx_parsed/velocitylogs.txt

mv /opt/ZEUS/parsed_datalogs/influx_parsed/positionlogs.txt /opt/ZEUS/parsed_datalogs/influx_parsed/positionlogs_$(date +%F-%T).txt

mv /opt/ZEUS/parsed_datalogs/influx_parsed/velocitylogs.txt /opt/ZEUS/parsed_datalogs/influx_parsed/velocitylogs_$(date +%F-%T).txt
