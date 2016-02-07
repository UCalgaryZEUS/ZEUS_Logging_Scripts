<?php

class Db {
	// The database connection
	protected static $connection;

	/**
	 * Connect to the database
	 *
	 * @return bool false on failure / mysqli MySQLi object instance on success
	 */
	public function connect() {
		// Try and connect to the database
		if(!isset(self::$connection)) {
			// Load configuration as an array. Use the actual location of your configuration file
			$config = parse_ini_file('config.ini');
			self::$connection = new mysqli('localhost',$config['username'],$config['password'],$config['dbname']);
			echo "connected";

		}

		// If connection was not successful, handle the error
		if(self::$connection === false) {
			// Handle error - notify administrator, log to a file, show an error screen, etc.
			echo "Connection failed";

			return false;
		}
		return self::$connection;
	}

	/**
	 * Query the database
	 *
	 * @param $query The query string
	 * @return mixed The result of the mysqli::query() function
	 */
	public function query($query) {

	//	echo "Here in qurey";
	//	echo $query;
		// Connect to the database
		$connection = $this -> connect();

		// Query the database
		$result = $connection -> query($query);

		if (!$result) {

      echo "Error in query";
		echo "<br>";
      echo $query."<br>";

       $message  = 'Invalid query: ' . $connection->error. "\n";

    	 $message .= 'Whole query: ' . $query;

        die('Invalid query: ' . mysqli_error($connection));


			}





		return $result;
	}

	/**
	 * Fetch rows from the database (SELECT query)
	 *
	 * @param $query The query string
	 * @return bool False on failure / array Database rows on success
	 */
	public function select($query) {
		$rows = array();
		$result = $this -> query($query);
		if($result === false) {
			echo $false;
			return false;
		}
		while ($row = $result -> fetch_assoc()) {
			$rows[] = $row;
			echo $row;

		}
		return $rows;
	}

	/**
	 * Fetch the last error from the database
	 *
	 * @return string Database error message
	 */
	public function error() {
		$connection = $this -> connect();
		return $connection -> error;
	}

	/**
	 * Quote and escape value for use in a database query
	 *
	 * @param string $value The value to be quoted and escaped
	 * @return string The quoted and escaped string
	 */
	public function quote($value) {

		echo "in quute";

		$connection = $this -> connect();
		return "'" . $connection -> real_escape_string($value) . "'";
	}


   public function build_table($array){
    // start table
    $html = '<table>';
    // header row
    $html .= '<tr>';
    foreach($array[0] as $key=>$value){
            $html .= '<th>' . $key . '</th>';
        }
    $html .= '</tr>';

    // data rows
    foreach( $array as $key=>$value){
        $html .= '<tr>';
        foreach($value as $key2=>$value2){
            $html .= '<td>' . $value2 . '</td>';
        }
        $html .= '</tr>';
    }

    // finish table and return it

    $html .= '</table>';
    return $html;
}





}
?>
