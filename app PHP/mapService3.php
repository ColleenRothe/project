<?php
    
    
    include('./constants.php');
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
    
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    $sql = "SELECT * FROM SITE_INFORMATION ORDER BY DATE DESC";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $data = array();
    //data[0] holds the site_information table data
    //$data[0] = $id;
    $data[0] = array(
                     "ID"                                      => $row['ID'],
                     "SITE_ID"                                 => $row['SITE_ID'],
                     "MGMT_AREA"                       	      => $row['MGMT_AREA'],
                     "UMBRELLA_AGENCY"                         => $row['UMBRELLA_AGENCY'],
                     "REGIONAL_ADMIN"                          => $row['REGIONAL_ADMIN'],
                     "LOCAL_ADMIN"                             => $row['LOCAL_ADMIN'],
                     "ROAD_TRAIL_NO"                    		  => $row['ROAD_TRAIL_NO'],
                     "ROAD_TRAIL_CLASS"                 		  => $row['ROAD_TRAIL_CLASS'],
                     "BEGIN_MILE_MARKER"             	      => $row['BEGIN_MILE_MARKER'],
                     "END_MILE_MARKER"                   	  => $row['END_MILE_MARKER'],
                     "ROAD_OR_TRAIL"                    	      => $row['ROAD_OR_TRAIL'],
                     "SIDE"                             		  => $row['SIDE'],
                     "RATER"                        		      => $row['RATER'],
                     "WEATHER"                        		  => $row['WEATHER'],
                     "DATE"                           	      => $row['DATE'],
                     "BEGIN_COORDINATE_LAT"         		      => $row['BEGIN_COORDINATE_LAT'],
                     "BEGIN_COORDINATE_LONG"        		      => $row['BEGIN_COORDINATE_LONG'],
                     "END_COORDINATE_LAT"                	  => $row['END_COORDINATE_LAT'],
                     "END_COORDINATE_LONG"             	      => $row['END_COORDINATE_LONG'],
                     "DATUM"                            	      => $row['DATUM'],
                     "AADT"                           	      => $row['AADT'],
                     "LENGTH_AFFECTED"                    	  => $row['LENGTH_AFFECTED'],
                     "SLOPE_HT_AXIAL_LENGTH"           	      => $row['SLOPE_HT_AXIAL_LENGTH'],
                     "SLOPE_ANGLE"                    	      => $row['SLOPE_ANGLE'],
                     "SIGHT_DISTANCE"                    	  => $row['SIGHT_DISTANCE'],
                     "ROAD_TRAIL_WIDTH"                   	  => $row['ROAD_TRAIL_WIDTH'],
                     "SPEED_LIMIT"                        	  => $row['SPEED_LIMIT'],
                     "MINIMUM_DITCH_WIDTH"                	  => $row['MINIMUM_DITCH_WIDTH'],
                     "MAXIMUM_DITCH_WIDTH"                	  => $row['MAXIMUM_DITCH_WIDTH'],
                     "MINIMUM_DITCH_DEPTH"                	  => $row['MINIMUM_DITCH_DEPTH'],
                     "MAXIMUM_DITCH_DEPTH"                	  => $row['MAXIMUM_DITCH_DEPTH'],
                     "MINIMUM_DITCH_SLOPE_FIRST"          	  => $row['MINIMUM_DITCH_SLOPE_FIRST'],
                     "MAXIMUM_DITCH_SLOPE_FIRST"          	  => $row['MAXIMUM_DITCH_SLOPE_FIRST'],
                     "MINIMUM_DITCH_SLOPE_SECOND"         	  => $row['MINIMUM_DITCH_SLOPE_SECOND'],
                     "MAXIMUM_DITCH_SLOPE_SECOND"         	  => $row['MAXIMUM_DITCH_SLOPE_SECOND'],
                     "BLK_SIZE"                                => $row['BLK_SIZE'],
                     "VOLUME"                                  => $row['VOLUME'],
                     "BEGIN_ANNUAL_RAINFALL"              	  => $row['BEGIN_ANNUAL_RAINFALL'],
                     "END_ANNUAL_RAINFALL"                	  => $row['END_ANNUAL_RAINFALL'],
                     "SOLE_ACCESS_ROUTE"                       => $row['SOLE_ACCESS_ROUTE'],
                     "FIXES_PRESENT"                           => $row['FIXES_PRESENT'],
                     "PRELIMINARY_RATING_IMPACT_ON_USE"   	  => $row['PRELIMINARY_RATING_IMPACT_ON_USE'],
                     "PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX"      	  => $row['PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX'],
                     "PRELIMINARY_RATING_ADDT_USAGE"      	  => $row['PRELIMINARY_RATING_ADDT_USAGE'],
                     "PRELIMINARY_RATING"                	  => $row['PRELIMINARY_RATING'],
                     "HAZARD_RATING_SLOPE_DRAINAGE"            => $row['HAZARD_RATING_SLOPE_DRAINAGE'],
                     "HAZARD_RATING_ANNUAL_RAINFALL"           => $row['HAZARD_RATING_ANNUAL_RAINFALL'],
                     "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH" => $row['HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH'],
                     "RISK_RATING_ROUTE_TRAIL"                 => $row['RISK_RATING_ROUTE_TRAIL'],
                     "RISK_RATING_HUMAN_EX_FACTOR"             => $row['RISK_RATING_HUMAN_EX_FACTOR'],
                     "RISK_RATING_PERCENT_DSD"                 => $row['RISK_RATING_PERCENT_DSD'],
                     "RISK_RATING_R_W_IMPACTS"                 => $row['RISK_RATING_R_W_IMPACTS'],
                     "RISK_RATING_ENVIRO_CULT_IMPACTS"         => $row['RISK_RATING_ENVIRO_CULT_IMPACTS'],
                     "RISK_RATING_MAINT_COMPLEXITY"            => $row['RISK_RATING_MAINT_COMPLEXITY'],
                     "RISK_RATING_EVENT_COST"                  => $row['RISK_RATING_EVENT_COST'],
                     "HAZARD_TOTAL"                            => $row['HAZARD_TOTAL'],
                     "RISK_TOTAL"                              => $row['RISK_TOTAL'],
                     "TOTAL_SCORE"                             => $row['TOTAL_SCORE'],
                     "EMAIL"                                   => $row['EMAIL'],
                     "PRELIMINARY_RATING_LANDSLIDE_ID"                                   => $row['PRELIMINARY_RATING_LANDSLIDE_ID'],
                     "PRELIMINARY_RATING_ROCKFALL_ID"                                   => $row['PRELIMINARY_RATING_ROCKFALL_ID'],
                     "HAZARD_RATING_ROCKFALL_ID"                                   => $row['HAZARD_RATING_ROCKFALL_ID'],
                     "HAZARD_RATING_LANDSLIDE_ID"                                   => $row['HAZARD_RATING_LANDSLIDE_ID']
                     );
    
    //IDs of other tables holding data
    $id = $row['ID'];
    $site_id = $row['SITE_ID'];
    $hazard_type = $row['HAZARD_TYPE']; //holds the id of the hazard type table
    $road = $row['ROAD'];   //will be 0 if it's a trail
    $trail = $row['TRAIL']; //will be 0 if it's a road
    // $weather = $row['WEATHER'];
    $preliminary_rating_landslide_id = $row['PRELIMINARY_RATING_LANDSLIDE_ID']; //will be 0 if it's a rockfall
    $preliminary_rating_rockfall_id = $row['PRELIMINARY_RATING_ROCKFALL_ID'];   //will be 0 if it's a landslide
    $hazard_rating_rockfall_id = $row['HAZARD_RATING_ROCKFALL_ID'];   //will be 0 if it's a landslide
    $hazard_rating_landslide_id = $row['HAZARD_RATING_LANDSLIDE_ID']; //will be 0 if it's a rockfall
    
    //COMMENT
    $sql = "SELECT COMMENT FROM COMMENTS WHERE SI_ID = '".$id."'";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    
    //data[1] stores the comment
    $data[1] = array("COMMENT" => $row['COMMENT']);
    
    //HAZARD TYPE
    $sql = "SELECT HAZARD_TYPE FROM HAZARD_TYPE WHERE ID = '".$hazard_type."'";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    
    //data[2] stores the hazard type
    $data[2] = array("HAZARD_TYPE" => $row['HAZARD_TYPE']);
    
    // //WEATHER
    // $sql = "SELECT WEATHER_TYPE FROM WEATHER WHERE ID = '".$weather."'";
    // $result = $conn->query($sql);
    // $row = $result->fetch_assoc();
    
    // //data[3] stores the weather
    // $data[3] = array("WEATHER" => $row['WEATHER_TYPE']);
    
    //PRELIM DATA
    $data[3] = array();
    if($preliminary_rating_landslide_id > 0) //it must be a landslide
    {
        $sql = "SELECT * FROM LANDSLIDE_PRELIMINARY_RATING WHERE ID = '".$preliminary_rating_landslide_id."'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $data[3] = array(
                         "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED" => $row['ROAD_WIDTH_AFFECTED'],
                         "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS" => $row['SLIDE_EROSION_EFFECTS'],
                         "LANDSLIDE_PRELIM_LENGTH_AFFECTED" => $row['LENGTH_AFFECTED'],
                         "ROCKFALL_PRELIM_DITCH_EFF" => 0,
                         "ROCKFALL_PRELIM_ROCKFALL_HISTORY" => 0,
                         "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL" => 0
                         );
    }
    else //it must be a rockfall
    {
        $sql = "SELECT * FROM ROCKFALL_PRELIMINARY_RATING WHERE ID = '".$preliminary_rating_rockfall_id."'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $data[3] = array(
                         "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED" => 0,
                         "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS" => 0,
                         "LANDSLIDE_PRELIM_LENGTH_AFFECTED" => 0,
                         "ROCKFALL_PRELIM_DITCH_EFF" => $row['DITCH_EFF'],
                         "ROCKFALL_PRELIM_ROCKFALL_HISTORY" => $row['ROCKFALL_HISTORY'],
                         "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL" => $row['BLOCK_SIZE_EVENT_VOL']
                         );
    }
    
    //HAZARD RATING DATA
    $data[4] = array();
    if($hazard_rating_landslide_id > 0) //it must be a landslide
    {
        $sql = "SELECT * FROM LANDSLIDE_HAZARD_RATING WHERE ID = '".$hazard_rating_landslide_id."'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $data[4] = array(
                         "LANDSLIDE_HAZARD_RATING_THAW_STABILITY" => $row['THAW_STABILITY'],
                         "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY" => $row['MAINT_FREQUENCY'],
                         "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY" => $row['MOVEMENT_HISTORY'],
                         "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY" => 0,
                         "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION" => 0,
                         "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION" => 0,
                         "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION" => 0,
                         "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION" => 0
                         ,
                         "LANDSLIDE_HAZARD_RATING_ID" => $hazard_rating_landslide_id,
                         "ROCKFALL_HAZARD_RATING_ID" => $hazard_rating_rockfall_id
                         );
    }
    else //it must be a rockfall
    {
        $sql = "SELECT * FROM ROCKFALL_HAZARD_RATING WHERE ID = '".$hazard_rating_rockfall_id."'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $data[4] = array(
                         "LANDSLIDE_HAZARD_RATING_THAW_STABILITY" => 0,
                         "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY" => 0,
                         "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY" => 0,
                         "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY" => $row['MAINT_FREQUENCY'],
                         "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION" => $row['CASE_ONE_STRUC_CONDITION'],
                         "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION" => $row['CASE_ONE_ROCK_FRICTION'],
                         "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION" => $row['CASE_TWO_STRUC_CONDITION'],
                         "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION" => $row['CASE_TWO_DIFF_EROSION']
                         ,
                         "LANDSLIDE_HAZARD_RATING_ID" => $hazard_rating_landslide_id,
                         "ROCKFALL_HAZARD_RATING_ID" => $hazard_rating_rockfall_id
                         );
    }
    
    //SELECT * FROM FMLA_LINK WHERE SI_ID = '".$row['SITE_ID']."'";
    //SELECT * FROM FMLA_LINK INNER JOIN SITE_INFORMATION ON FMLA_LINK.SI_ID = SITE_INFORMATION.SITE_ID;
    
    $sql = "SELECT * FROM FMLA_LINK WHERE SI_ID = '".$site_id."'";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    
    $data[5] = array(
                     "FMLA_ID" => $row['FMLA_ID'],
                     "FMLA_NAME" => $row['FMLA_NAME'],
                     "FMLA_DESCRIPTION" => $row['FMLA_DESCRIPTION']
                     );
    
    
    
    
    $conn->close();
    //echo json_encode(array('foo' => 'bar'));
    echo json_encode($data);
    ?>




