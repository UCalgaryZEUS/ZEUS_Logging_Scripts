#!/bin/bash
ruby /opt/ZEUS/logger_scripts/rawToSQL.rb /opt/ZEUS/raw_datalogs/raw_datalog.gps
php -f /opt/ZEUS/logger_scripts/file-read.php
ruby /opt/ZEUS/logger_scripts/rawToInflux.rb /opt/ZEUS/raw_datalogs/raw_datalog.gps
mv /opt/ZEUS/raw_datalogs/raw_datalog.gps /opt/ZEUS/raw_datalogs/raw_datalogs_$(date +%F-%T).gps
