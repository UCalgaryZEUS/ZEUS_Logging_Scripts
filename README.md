# ZEUS Logging Scripts
This repo holds a collection of scripts for parsing raw log data to a variety of formats


### Converting to SQL Consumable Format
The script rawToSQL.rb takes a raw data file (usually .gps) as a command line argument.
After running the script a unique (using the time the script is run) file is created containing the necessary data to be put into the SQL DB.

Usage:
```sh
./rawToSQL.rb RAW_DATA.gps
```

### Converting to InfluxDB Line Protocol
The script rawToInflux.rb takes a raw data file (usually .gps) as a command line argument.
After running the script two files are created, one for position and the other for velocity.

Usage:
```sh
./rawToInflux.rb RAW_DATA.gps
```
