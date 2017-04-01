<?php
    include('./constants.php');


// Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

//check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$sql = "SELECT * FROM SITE_INFORMATION ORDER BY DATE DESC";
$result = $conn->query($sql);

$visited_sites = array(); //holds id's that have been used
$data = array();
//if there is at least one row
if ($result->num_rows > 0) {
    // output data of each row
    $count = 0;
    while($row = $result->fetch_assoc()) {
    	//if site id has not yet been used
        if(!in_array($row['SITE_ID'], $visited_sites))
        {
        	//add it to the list of used
            array_push($visited_sites, $row['SITE_ID']);
            
 
			
			//array of arrays
            $data[$count] = array(
             	 $row['ID'],
                 $row['SITE_ID'],
             	 $row['BEGIN_COORDINATE_LAT'],
                 $row['BEGIN_COORDINATE_LONG'],
                 $row['TOTAL_SCORE'],
                 $row['HAZARD_RATING_ROCKFALL_ID'],
                 $row['HAZARD_RATING_LANDSLIDE_ID'],
                 $row['PRELIMINARY_RATING']
             	
             	);
            $count++;
        }
    }
} else {
    echo "0 results";
}
$conn->close();
//echo json_encode(array('foo' => 'bar'));asfdf
echo json_encode($data);
?>
