<?php


    include('./constants.php');
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php

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
            
            //get hazard type info
            $hazard_type_query = "SELECT HAZARD_TYPE FROM HAZARD_TYPE WHERE ID = '".$row['HAZARD_TYPE']."'";
            $hazard_type_result = $conn->query($hazard_type_query);  
            $hazard_row = $hazard_type_result->fetch_assoc();  
			
			//get comments info
            $comments_query = "SELECT COMMENT FROM COMMENTS WHERE SI_ID = '".$row['ID']."'";
            $comments_result = $conn->query($comments_query);  
            $comments_row = $comments_result->fetch_assoc(); 
			
			//get slope status info
            $slope_status_query = "SELECT SLOPE_STATUS FROM SLOPE_STATUS WHERE ID = '".$row['SLOPE_STATUS']."'";
            $slope_status_result = $conn->query($slope_status_query);  
            $slope_status_row = $slope_status_result->fetch_assoc(); 
			
			//get photos info
            $photos_query = "SELECT * FROM PHOTOS WHERE SITE_ID = '".$row['SITE_ID']."' ORDER BY SI_ID DESC LIMIT 5";
            $photos_result = $conn->query($photos_query);
            $photos_list = array();
            $i = 0;
            while($photo_row = $photos_result->fetch_assoc())
            {
                $photos_list[$i] = $photo_row['PHOTO'];
                $i++;
            }
			
			//get date
            $dates_query = "SELECT ID, DATE FROM SITE_INFORMATION WHERE SITE_ID = '".$row['SITE_ID']."' ORDER BY DATE ASC";
            $dates_result = $conn->query($dates_query);
            $dates_list = array();
            $i = 0;
            while($date_row = $dates_result->fetch_assoc())
            {
                $number_of_photos_query = "SELECT ID FROM PHOTOS WHERE SI_ID = '".$date_row['ID']."'";
                $number_of_photos_result = $conn->query($number_of_photos_query);
                $number_of_photos = 0;
                while($more_photos = $number_of_photos_result -> fetch_assoc())
                {
                    $number_of_photos++;
                }

                $number_of_documents_query = "SELECT ID FROM DOCUMENTS WHERE SI_ID = '".$date_row['ID']."'";
                $number_of_documents_result = $conn->query($number_of_documents_query);
                $number_of_documents = 0;
                while($more_documents = $number_of_documents_result -> fetch_assoc())
                {
                    $number_of_documents++;
                }

                $dates_list[$i] = $date_row['ID'].".".$date_row['DATE']."  Photos Added: ".$number_of_photos. " Documents Added: ".$number_of_documents;
                $i++;
            }
			
			//array of arrays
            $data[$count] = array(
             	"ID" => $row['ID'],
                "SITE_ID" => $row['SITE_ID'],
             	"COORDINATES"=>$row['BEGIN_COORDINATE_LAT'].",".$row['BEGIN_COORDINATE_LONG'],
             	"DATE" => implode(",", $dates_list),
                "SLOPE_STATUS" => $slope_status_row['SLOPE_STATUS'],
                "MANAGEMENT_AREA" => $row['MGMT_AREA'],
                "ROAD_TRAIL_NO" => $row['ROAD_TRAIL_NO'],
                "BEGIN_MILE_MARKER" => $row['BEGIN_MILE_MARKER'],
                "END_MILE_MARKER" => $row['END_MILE_MARKER'],
                "SIDE" => $row['SIDE'],
                "HAZARD_TYPE" => $hazard_row['HAZARD_TYPE'],
                "PRELIM_RATING" => $row['PRELIMINARY_RATING'],
             	"TOTAL_SCORE" => $row['TOTAL_SCORE'],
                "PHOTOS" => implode(",", $photos_list),
                "COMMENTS" => $comments_row['COMMENT'],
                "HAZARD_RATING_ROCKFALL_ID" => $row['HAZARD_RATING_ROCKFALL_ID'],
                "HAZARD_RATING_LANDSLIDE_ID" => $row['HAZARD_RATING_LANDSLIDE_ID']
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
