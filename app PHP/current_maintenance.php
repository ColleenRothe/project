<?php
    include('./constants.php');

//edited from get_current_maintenance_form_information.php
     $conn = new mysqli($servername, $username, $password, $dbname);
//$conn = new mysqli("localhost", "usmp", "Just4Mickq!9", "usmp_wittie");
// Check connection
if ($conn->connect_error) {
 die("Connection failed: " . $conn->connect_error);
} 
$id = mysqli_real_escape_string($conn, $_POST['id']);
$sql = "SELECT * FROM MAINTENANCE_FORM WHERE ID = '".$id."'";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
$data = array();
//data[0] holds the site_information table data
//$data[0] = $id;
 
$data[0] = array(
	"ID"                              => $row['ID'],
  "SITE_ID"                         => $row['SITE_ID'],
  "CODE_RELATION"                   => $row['CODE_RELATION'],
	"MAINTENANCE_TYPE"                => $row['MAINTENANCE_TYPE'],
    "ROAD_TRAIL_NO"                   => $row['ROAD_TRAIL_NO'],
    "BEGIN_MILE_MARKER"               => $row['BEGIN_MILE_MARKER'],
    "END_MILE_MARKER"                 => $row['END_MILE_MARKER'],
    "UMBRELLA_AGENCY"                 => $row['UMBRELLA_AGENCY'],
    "REGIONAL_ADMIN"                  => $row['REGIONAL_ADMIN'],
    "LOCAL_ADMIN"                     => $row['LOCAL_ADMIN'],
	"US_EVENT"                        => $row['US_EVENT'],
	"EVENT_DESC"                      => $row['EVENT_DESC'],
	"DESIGN_PSE"             	        => $row['DESIGN_PSE'],
	"REMOVE_DITCH"                    => $row['REMOVE_DITCH'],
	"REMOVE_ROAD_TRAIL"               => $row['REMOVE_ROAD_TRAIL'],
	"RELEVEL_AGGREGATE"               => $row['RELEVEL_AGGREGATE'],
	"RELEVEL_PATCH"                   => $row['RELEVEL_PATCH'],
	"DRAINAGE_IMPROVEMENT"            => $row['DRAINAGE_IMPROVEMENT'],
	"DEEP_PATCH"                      => $row['DEEP_PATCH'],
	"HAUL_DEBRIS"         	          => $row['HAUL_DEBRIS'],
	"SCALING_ROCK_SLOPES"        		  => $row['SCALING_ROCK_SLOPES'],
	"ROAD_TRAIL_ALIGNMENT"            => $row['ROAD_TRAIL_ALIGNMENT'],
	"REPAIR_ROCKFALL_BARRIER"         => $row['REPAIR_ROCKFALL_BARRIER'],
	"REPAIR_ROCKFALL_NETTING"         => $row['REPAIR_ROCKFALL_NETTING'],
	"SEALING_CRACKS"                  => $row['SEALING_CRACKS'],
	"GUARDRAIL"                       => $row['GUARDRAIL'],
	"CLEANING_DRAINS"           	    => $row['CLEANING_DRAINS'],
	"FLAGGING_SIGNING"                => $row['FLAGGING_SIGNING'],
	"OTHERS1_DESC"                    => $row['OTHERS1_DESC'],
	"OTHERS1"                         => $row['OTHERS1'],
  "OTHERS2_DESC"                    => $row['OTHERS2_DESC'],
  "OTHERS2"                	        => $row['OTHERS2'],
  "OTHERS3_DESC"                    => $row['OTHERS3_DESC'],
  "OTHERS3"                         => $row['OTHERS3'],
  "OTHERS4_DESC"                    => $row['OTHERS4_DESC'],
  "OTHERS4"                         => $row['OTHERS4'],
  "OTHERS5_DESC"                    => $row['OTHERS5_DESC'],
  "OTHERS5"                         => $row['OTHERS5'],
  "TOTAL"                           => $row['TOTAL'],
  "TOTAL_PERCENT"                   => $row['TOTAL_PERCENT'],
  "DESIGN_PSE_VAL"                  => $row['DESIGN_PSE_VAL'],
  "REMOVE_DITCH_VAL"                => $row['REMOVE_DITCH_VAL'],
  "REMOVE_ROAD_TRAIL_VAL"           => $row['REMOVE_ROAD_TRAIL_VAL'],
  "RELEVEL_AGGREGATE_VAL"           => $row['RELEVEL_AGGREGATE_VAL'],
  "RELEVEL_PATCH_VAL"               => $row['RELEVEL_PATCH_VAL'],
  "DRAINAGE_IMPROVEMENT_VAL"        => $row['DRAINAGE_IMPROVEMENT_VAL'],
  "DEEP_PATCH_VAL"                  => $row['DEEP_PATCH_VAL'],
  "HAUL_DEBRIS_VAL"                 => $row['HAUL_DEBRIS_VAL'],
  "SCALING_ROCK_SLOPES_VAL"         => $row['SCALING_ROCK_SLOPES_VAL'],
  "ROAD_TRAIL_ALIGNMENT_VAL"        => $row['ROAD_TRAIL_ALIGNMENT_VAL'],
  "REPAIR_ROCKFALL_BARRIER_VAL"     => $row['REPAIR_ROCKFALL_BARRIER_VAL'],
  "REPAIR_ROCKFALL_NETTING_VAL"     => $row['REPAIR_ROCKFALL_NETTING_VAL'],
  "SEALING_CRACKS_VAL"              => $row['SEALING_CRACKS_VAL'],
  "GUARDRAIL_VAL"                   => $row['GUARDRAIL_VAL'],
  "CLEANING_DRAINS_VAL"             => $row['CLEANING_DRAINS_VAL'],
  "FLAGGING_SIGNING_VAL"            => $row['FLAGGING_SIGNING_VAL'],
  "OTHERS1_VAL"                     => $row['OTHERS1_VAL'],
  "OTHERS2_VAL"                     => $row['OTHERS2_VAL'],
  "OTHERS3_VAL"                     => $row['OTHERS3_VAL'],
  "OTHERS4_VAL"                     => $row['OTHERS4_VAL'],
  "OTHERS5_VAL"                     => $row['OTHERS5_VAL']      
	);
$conn->close();
//echo json_encode(array('foo' => 'bar'));
echo json_encode($data);
?>
