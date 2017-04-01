<?php
//modified from get_percentiles.php
// Create connection
    include('./constants.php');
    $conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
$sql = "SELECT HAZARD_RATING_LANDSLIDE_ID, HAZARD_RATING_ROCKFALL_ID, TOTAL_SCORE FROM SITE_INFORMATION";
$result = $conn->query($sql);
$conn->close();
$rockfall_scores = array();
$landslide_scores = array();
while($row = $result->fetch_assoc()) {
	if($row['HAZARD_RATING_LANDSLIDE_ID'] > 0) //it's a landslide
	{
		array_push($landslide_scores, $row['TOTAL_SCORE']);
	}
	else 									   //it's a rockfall
	{
		array_push($rockfall_scores, $row['TOTAL_SCORE']);
	}
}
sort($rockfall_scores);
sort($landslide_scores);
$rockfall_twenty_five = $rockfall_scores[(count($rockfall_scores)/4)];
$rockfall_fifty = $rockfall_scores[(count($rockfall_scores)/2)];
$rockfall_seventy_five = $rockfall_scores[(count($rockfall_scores) - (count($rockfall_scores)/4))];
$landslide_twenty_five = $landslide_scores[(count($landslide_scores)/4)];
$landslide_fifty = $landslide_scores[(count($landslide_scores)/2)];
$landslide_seventy_five = $landslide_scores[(count($landslide_scores) - (count($landslide_scores)/4))];
$data = array(
	$rockfall_twenty_five,
	$rockfall_fifty,
	$rockfall_seventy_five,
	$landslide_twenty_five,
	$landslide_fifty,
	$landslide_seventy_five
	);

echo json_encode($data);
?>
