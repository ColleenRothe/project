<?php
//from get_sites.php
    
    include('./constants.php');
    //create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
$data = array();

    $sql = "SELECT MAINTENANCE_FORM.ID,MAINTENANCE_FORM.MAINTENANCE_TYPE,MAINTENANCE_FORM.US_EVENT,MAINTENANCE_FORM.SITE_ID,MAINTENANCE_FORM.CODE_RELATION,MAINTENANCE_FORM.EVENT_DESC,MAINTENANCE_FORM.TOTAL,MAINTENANCE_FORM.TOTAL_PERCENT,SITE_INFORMATION.BEGIN_COORDINATE_LAT,SITE_INFORMATION.BEGIN_COORDINATE_LONG FROM MAINTENANCE_FORM, SITE_INFORMATION where MAINTENANCE_FORM.SITE_ID = SITE_INFORMATION.SITE_ID
        UNION
        SELECT MAINTENANCE_FORM.ID,MAINTENANCE_FORM.MAINTENANCE_TYPE,MAINTENANCE_FORM.US_EVENT,MAINTENANCE_FORM.SITE_ID,MAINTENANCE_FORM.CODE_RELATION,MAINTENANCE_FORM.EVENT_DESC,MAINTENANCE_FORM.TOTAL,MAINTENANCE_FORM.TOTAL_PERCENT,MAINTENANCE_FORM.MAINTENANCE_LAT,MAINTENANCE_FORM.MAINTENANCE_LONG FROM MAINTENANCE_FORM WHERE MAINTENANCE_FORM.SITE_ID = 0"; 
 //echo $sql;
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    // output data of each row
    $count = 0;
    while($row = $result->fetch_assoc()) {
        $maintenance_type = "";
        $us_event = "";
                switch ($row['MAINTENANCE_TYPE']) {
                    case "N":
                        $maintenance_type = "New Maintenance";
                        break;
                    case "O":
                        $maintenance_type = "Repeat Maintenance (within 5 years)";
                        break;
                    
                }
                switch ($row['US_EVENT']) {
                    case "USE":
                        $us_event = "Recent Unstable Slope Event";
                        break;
                    case "RM":
                        $us_event = "Routine Maintenance";
                        break;
                    case "SM":
                        $us_event = "Slope Mitigation/Repair";
                        break;
                    
                }
            $data[$count] = array(
                $row['ID'],
                $row['SITE_ID'],
                $row['BEGIN_COORDINATE_LAT'],
                $row['BEGIN_COORDINATE_LONG'],
                $row['CODE_RELATION'],
                $maintenance_type,
                $us_event,
                $row['EVENT_DESC'],
                $row['TOTAL'],
                $row['TOTAL_PERCENT']
              );
            $count++;
       // }
    }
} else {
    echo "0 results";
}
$conn->close();
//echo json_encode(array('foo' => 'bar'));asfdf
echo json_encode($data);
?>
