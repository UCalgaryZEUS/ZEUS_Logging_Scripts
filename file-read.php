<?php

include_once 'dataQuery.php';

ini_set('auto_detect_line_endings',TRUE); //deals with differing line ending  
														// </n> in  linux and </lf /cr> in windows
												

$db;

$dir    = getcwd();

$files = scandir($dir,1);



$files =  preg_grep("/^.*\.csv$/",$files); //removes all files from the array that do not end in *.csv

//print_r($files);

//echo pos($files);

if (($handle = fopen(pos($files), "r")) !== FALSE) { //file exists
   
  $db = new Db();
  $unixTime = time() . " Drystan Testing"; //crappy but for testing it works
  
  $sql = "INSERT INTO `DataSet`(`dataID`, `addedBy`, `raceID`, `datasetname`) VALUES ('NULL','1','3','$unixTime');";
 
  $result = $db->query($sql);
  
 // echo $result."\n";
  
  $sql = "SELECT MAX(dataID) FROM DataSet;";
  
  $result = $db->query($sql);
  
  $maxId = mysqli_fetch_assoc($result);
  
  $max = $maxId["MAX(dataID)"];
  
   
    while (($data = fgetcsv($handle, 500, ",")) !== FALSE) {    
    
    /* echo "Time is ".$data[0]."\n";          
       echo "Acceleration is ". $data[1] ." M/s^2 \n";
       echo "Velocity is " .$data[2]." M/s \n";
       echo "Latitude is ".$data[3]."\n";
       echo "Longitude is ".$data[4]."\n";
       echo "Altitude is ".$data[5]."\n \n"; */
           
        $sql = "INSERT INTO `DataPoint` (`pointID`, `dataID`, `time`, `acceleration`, `velocity`, `latitude`, `longitude`,`altitude`) 
        VALUES (NULL, '$max', '$data[0]', '$data[1]', '$data[2]', '$data[3]', '$data[4]', '$data[5]');";
        
        
      $result = $db->query($sql);

		if($result){echo "Record added "."\n" ;
		
		}else {echo "Error in record sql return ".$result."\n ";}
        

    }
    fclose($handle);

}else {echo " \n File not found \n";}





?>
