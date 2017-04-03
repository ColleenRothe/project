<?php
    /*******
     This file recieves data from new_site.html (USMP/client/new_site.html) and puts it in the database as a new site
     *******/
    
    //mwittie 3/24/16: added code to configure debug output
    $debug = false;
    if($debug){
        ini_set('display_errors',1);
        error_reporting(E_ALL);
    }
    function debugPrint($str){
        if ($GLOBALS['debug']){
            echo"<p>".$str."<\p>";
        }
    }
    
    session_start();
    if($_SESSION['permissions'] > 1)
    {
        header("Location: ../../client/deny.php"); /* user is not logged in, send them back to log in page */
        exit();
    }
    
    include('./constants.php');
    ini_set('display_errors',1);
    ini_set('display_startup_errors',1);
    error_reporting(-1);
    /**********
     Collect POST data from new site form
     **********/
    //$name = $_POST['name'];
    $email = $_SESSION['user_id'];
    
    /********************
     SQL TO INSERT THE DATA INTO DB
     ********************/
    //echo "<br \><br \>Starting SQL\n";
    
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    debugPrint("POST data: ".print_r($_POST, true));
    
    //general data
    //$mgmt_area = mysqli_real_escape_string($conn, $_POST['mgmt_area']);
    $umbrella_agency = mysqli_real_escape_string($conn, $_POST['umbrella_agency']);
    $regional_admin = mysqli_real_escape_string($conn, $_POST['regional_admin']);
    $local_admin = mysqli_real_escape_string($conn, $_POST['local_admin']);
    $road_trail_number = mysqli_real_escape_string($conn, $_POST['road_trail_number']);
    $road_trail_class = mysqli_real_escape_string($conn, $_POST['road_trail_class']);
    $begin_mile_marker = mysqli_real_escape_string($conn, $_POST['begin_mile_marker']);
    $end_mile_marker = mysqli_real_escape_string($conn, $_POST['end_mile_marker']);
    $road_or_trail = mysqli_real_escape_string($conn, $_POST['road_or_trail']);
    $side = mysqli_real_escape_string($conn, $_POST['side']);
    $rater = mysqli_real_escape_string($conn, $_POST['rater']);
    $weather = mysqli_real_escape_string($conn, $_POST['weather']);
    $date = mysqli_real_escape_string($conn, $_POST['date']);
    // $date = date("Y-m-d", strtotime($date)));
    $begin_coordinate_lat = mysqli_real_escape_string($conn, $_POST['begin_coordinate_latitude']);
    $begin_coordinate_long = mysqli_real_escape_string($conn, $_POST['begin_coordinate_longitude']);
    $end_coordinate_latitude = mysqli_real_escape_string($conn, $_POST['end_coordinate_latitude']);
    $end_coordinate_longitude = mysqli_real_escape_string($conn, $_POST['end_coordinate_longitude']);
    $datum = mysqli_real_escape_string($conn, $_POST['datum']);
    $aadt = mysqli_real_escape_string($conn, $_POST['aadt']);
    $hazard_type =  $_POST['hazard_type'];
    $length_affected = mysqli_real_escape_string($conn, $_POST['length_affected']);
    $slope_height_axial_length = mysqli_real_escape_string($conn, $_POST['slope_height_axial_length']);
    $slope_angle = mysqli_real_escape_string($conn, $_POST['slope_angle']);
    $sight_distance = mysqli_real_escape_string($conn, $_POST['sight_distance']);
    $road_trail_width = mysqli_real_escape_string($conn, $_POST['road_trail_width']);
    $speed_limit = mysqli_real_escape_string($conn, $_POST['speed_limit']);
    $minimum_ditch_width = mysqli_real_escape_string($conn, $_POST['minimum_ditch_width']);
    $maximum_ditch_width = mysqli_real_escape_string($conn, $_POST['maximum_ditch_width']);
    $minimum_ditch_depth = mysqli_real_escape_string($conn, $_POST['minimum_ditch_depth']);
    $maximum_ditch_depth = mysqli_real_escape_string($conn, $_POST['maximum_ditch_depth']);
    $first_begin_ditch_slope = mysqli_real_escape_string($conn, $_POST['first_begin_ditch_slope']);
    $first_end_ditch_slope = mysqli_real_escape_string($conn, $_POST['first_end_ditch_slope']);
    $second_begin_ditch_slope = mysqli_real_escape_string($conn, $_POST['second_begin_ditch_slope']);
    $second_end_ditch_slope = mysqli_real_escape_string($conn, $_POST['second_end_ditch_slope']);
    $start_annual_rainfall = mysqli_real_escape_string($conn, $_POST['start_annual_rainfall']);
    $end_annual_rainfall = mysqli_real_escape_string($conn, $_POST['end_annual_rainfall']);
    $sole_access_route = mysqli_real_escape_string($conn, $_POST['sole_access_route']);
    $fixes_present = mysqli_real_escape_string($conn, $_POST['fixes_present']);
    $blk_size = mysqli_real_escape_string($conn, $_POST['blk_size']);
    $volume = mysqli_real_escape_string($conn, $_POST['volume']);
    //$sole_access = mysqli_real_escape_string($conn, $_POST['sole_access']);
    
    //prelim landslide data
    $prelim_rating_landslide_road_width_affected = mysqli_real_escape_string($conn, $_POST['prelim_landslide_road_width_affected']);
    $prelim_rating_landslide_slide_erosion_effects = mysqli_real_escape_string($conn, $_POST['prelim_landslide_slide_erosion_effects']);
    $prelim_rating_landslide_length_affected = mysqli_real_escape_string($conn, $_POST['prelim_landslide_length_affected']);
    
    //prelim rockfall data
    $prelim_rating_rockfall_ditch_eff = mysqli_real_escape_string($conn, $_POST['prelim_rockfall_ditch_eff']);
    $prelim_rating_rockfall_rockfall_history = mysqli_real_escape_string($conn, $_POST['prelim_rockfall_rockfall_history']);
    $prelim_rating_rockfall_block_size_event_vol = mysqli_real_escape_string($conn, $_POST['prelim_rockfall_block_size_event_vol']);
    
    //prelim rating for all
    $prelim_rating_impact_on_use = mysqli_real_escape_string($conn, $_POST['impact_on_use']);
    $prelim_rating_aadt_usage_calc_checkbox = mysqli_real_escape_string($conn, $_POST['aadt_usage_calc_checkbox']);
    $prelim_rating_aadt_usage = mysqli_real_escape_string($conn, $_POST['aadt_usage']);
    $prelim_rating = mysqli_real_escape_string($conn, $_POST['prelim_rating']);
    
    //hazard rating for all
    $hazard_rating_slope_drainage = mysqli_real_escape_string($conn, $_POST['slope_drainage']);
    $hazard_rating_annual_rainfall = mysqli_real_escape_string($conn, $_POST['hazard_rating_annual_rainfall']);
    $hazard_rating_slope_height_axial_length = mysqli_real_escape_string($conn, $_POST['hazard_rating_slope_height_axial_length']);
    
    //hazard rating landslide fields
    $hazard_rating_landslide_thaw_stability = mysqli_real_escape_string($conn, $_POST['hazard_landslide_thaw_stability']);
    $hazard_rating_landslide_maint_frequency = mysqli_real_escape_string($conn, $_POST['hazard_landslide_maint_frequency']);
    $hazard_rating_landslide_movement_history = mysqli_real_escape_string($conn, $_POST['hazard_landslide_movement_history']);
    
    //hazard rating rockfall fields
    $hazard_rating_rockfall_maint_frequency = mysqli_real_escape_string($conn, $_POST['hazard_rockfall_maint_frequency']);
    $hazard_rating_rockfall_case_one_struc_condition = mysqli_real_escape_string($conn, $_POST['case_one_struc_cond']);
    $hazard_rating_rockfall_case_one_rock_friction = mysqli_real_escape_string($conn, $_POST['case_one_rock_friction']);
    $hazard_rating_rockfall_case_two_struc_condition = mysqli_real_escape_string($conn, $_POST['case_two_struc_condition']);
    $hazard_rating_rockfall_case_two_diff_erosion = mysqli_real_escape_string($conn, $_POST['case_two_diff_erosion']);
    
    //risk ratings
    $risk_rating_route_trail_width = mysqli_real_escape_string($conn, $_POST['route_trail_width']);
    $risk_rating_human_ex_factor = mysqli_real_escape_string($conn, $_POST['human_ex_factor']);
    $risk_rating_percent_dsd = mysqli_real_escape_string($conn, $_POST['percent_dsd']);
    $risk_rating_r_w_impacts = mysqli_real_escape_string($conn, $_POST['r_w_impacts']);
    $risk_rating_enviro_cult_impacts = mysqli_real_escape_string($conn, $_POST['enviro_cult_impacts']);
    $risk_rating_maint_complexity = mysqli_real_escape_string($conn, $_POST['maint_complexity']);
    $risk_rating_event_cost = mysqli_real_escape_string($conn, $_POST['event_cost']);
    
    //hazard totals
    $hazard_total = mysqli_real_escape_string($conn, $_POST['hazard_rating_landslide_total']);
    if($_POST['hazard_rating_rockfall_total'] > $hazard_total)
    $hazard_total = mysqli_real_escape_string($conn, $_POST['hazard_rating_rockfall_total']);
    $risk_total = mysqli_real_escape_string($conn, $_POST['risk_total']);
    $total_score = mysqli_real_escape_string($conn, $_POST['total_score']);
    
    //comments
    $comments = mysqli_real_escape_string($conn, $_POST['comments']);
    
    //fmla
    $fmla_id = mysqli_real_escape_string($conn, $_POST['fmla_id']);
    $fmla_name = mysqli_real_escape_string($conn, $_POST['fmla_name']);
    $fmla_description = mysqli_real_escape_string($conn, $_POST['fmla_description']);
    
    //echo "<br \><br \>Connected to USMP_BETA DB";
    
    
    //sql for the site information table
    $site_info_query = "INSERT INTO SITE_INFORMATION(ID, SITE_ID, UMBRELLA_AGENCY, REGIONAL_ADMIN, LOCAL_ADMIN, ROAD_TRAIL_NO,
    ROAD_TRAIL_CLASS, BEGIN_MILE_MARKER, END_MILE_MARKER, ROAD_OR_TRAIL,
    SIDE, RATER, WEATHER, DATE, BEGIN_COORDINATE_LAT, BEGIN_COORDINATE_LONG,
    END_COORDINATE_LAT, END_COORDINATE_LONG, DATUM, AADT, LENGTH_AFFECTED,
    SLOPE_HT_AXIAL_LENGTH, SLOPE_ANGLE, SIGHT_DISTANCE, ROAD_TRAIL_WIDTH,
    SPEED_LIMIT, MINIMUM_DITCH_WIDTH, MAXIMUM_DITCH_WIDTH, MINIMUM_DITCH_DEPTH, MAXIMUM_DITCH_DEPTH,
    MINIMUM_DITCH_SLOPE_FIRST, MAXIMUM_DITCH_SLOPE_FIRST, MINIMUM_DITCH_SLOPE_SECOND,
    MAXIMUM_DITCH_SLOPE_SECOND, BLK_SIZE, VOLUME, BEGIN_ANNUAL_RAINFALL, END_ANNUAL_RAINFALL,
    SOLE_ACCESS_ROUTE, FIXES_PRESENT,
    PRELIMINARY_RATING_IMPACT_ON_USE, PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX, PRELIMINARY_RATING_ADDT_USAGE,
    PRELIMINARY_RATING, HAZARD_RATING_SLOPE_DRAINAGE, HAZARD_RATING_ANNUAL_RAINFALL,
    HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH, RISK_RATING_ROUTE_TRAIL,
    RISK_RATING_HUMAN_EX_FACTOR, RISK_RATING_PERCENT_DSD, RISK_RATING_R_W_IMPACTS,
    RISK_RATING_ENVIRO_CULT_IMPACTS, RISK_RATING_MAINT_COMPLEXITY, RISK_RATING_EVENT_COST,
    HAZARD_TOTAL, RISK_TOTAL, TOTAL_SCORE, SLOPE_STATUS, EMAIL) VALUES(NULL, '0', '".$umbrella_agency."','".$regional_admin."','".$local_admin."', '".$road_trail_number.
                                                                       "', '".$road_trail_class."', '".$begin_mile_marker."', '".$end_mile_marker."', '".
                                                                       $road_or_trail."', '".$side."', '".$rater."', '".$weather."', NOW(), '".$begin_coordinate_lat.
                                                                       "', '".$begin_coordinate_long."', '".$end_coordinate_latitude."', '".$end_coordinate_longitude.
                                                                       "', '".$datum."', '".$aadt."', '".$length_affected."', '".$slope_height_axial_length.
                                                                       "', '".$slope_angle."', '".$sight_distance."', '".$road_trail_width."', '".
                                                                       $speed_limit."', '".$minimum_ditch_width."', '".$maximum_ditch_width."', '".
                                                                       $minimum_ditch_depth."', '".$maximum_ditch_depth."', '".$first_begin_ditch_slope."', '".$first_end_ditch_slope.
                                                                       "', '".$second_begin_ditch_slope."', '".$second_end_ditch_slope."', '".$blk_size."', '".$volume."', '".
                                                                       $start_annual_rainfall."', '".$end_annual_rainfall."', '".$sole_access_route."', '".$fixes_present.
                                                                       "', '".$prelim_rating_impact_on_use.
                                                                       "', ".strtoupper($prelim_rating_aadt_usage_calc_checkbox).", '".$prelim_rating_aadt_usage."', '".
                                                                       $prelim_rating."', '".$hazard_rating_slope_drainage.
                                                                       "', '".$hazard_rating_annual_rainfall."', '".$hazard_rating_slope_height_axial_length."', '".
                                                                       $risk_rating_route_trail_width."', '".$risk_rating_human_ex_factor."', '".
                                                                       $risk_rating_percent_dsd."', '".$risk_rating_r_w_impacts."', '".$risk_rating_enviro_cult_impacts.
                                                                       "', '".$risk_rating_maint_complexity."', '".$risk_rating_event_cost."', '".$hazard_total."', '".
                                                                       $risk_total."', '".$total_score."', '1', '".$email."');";
                                                                       
                                                                       if (!mysqli_query($conn, $site_info_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       
                                                                       $update = ""; //the update to be made for the foreign keys in SITE_INFORMATION at the end
                                                                       
                                                                       $site_info_id = "SELECT ID FROM SITE_INFORMATION ORDER BY ID DESC LIMIT 1";
                                                                       $site_info_id_result = $conn->query($site_info_id);
                                                                       $site_info_id_value = $site_info_id_result->fetch_assoc();
                                                                       
                                                                       
                                                                       //update the site_id
                                                                       if (!mysqli_query($conn, "UPDATE SITE_INFORMATION SET SITE_ID = '".$site_info_id_value['ID']."' WHERE ID = '".$site_info_id_value['ID']."'")){
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       
                                                                       //sql for the comments table
                                                                       if($comments != "None") {
                                                                       $comments_query = "INSERT INTO COMMENTS(ID,SI_ID,COMMENT) VALUES(NULL, ".$site_info_id_value['ID'].", '".$comments."');";
                                                                       if (!mysqli_query($conn, $comments_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       }
                                                                       
                                                                       //sql for the fmla table
                                                                       if($fmla_description != "None"){
                                                                       $fmla_query = "INSERT INTO FMLA_LINK(ID, FMLA_NAME, FMLA_ID, FMLA_DESCRIPTION, SI_ID) VALUES(NULL, '".$fmla_name."', '".$fmla_id."', '".$fmla_description."', ".$site_info_id_value['ID'].");";
                                                                       if (!mysqli_query($conn, $fmla_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       }
                                                                       
                                                                       
                                                                       //sql for the event table -- these won't exist with the initial data
                                                                       
                                                                       //sql for the photo range table -- these won't exist with the initial data
                                                                       
                                                                       //sql for the road table
                                                                       if($road_or_trail == "R" or $road_or_trail == "r") //road: insert data into the road table
                                                                       {
                                                                       $direction = "D";
                                                                       if($begin_mile_marker <= $end_mile_marker)
                                                                       {
                                                                       $direction = "U";
                                                                       }
                                                                       $rock_slope = "";
                                                                       $landslide = "";
                                                                       if($prelim_rating_landslide_road_width_affected != "None") //then it is a landslide
                                                                       {
                                                                       $landslide = $side;
                                                                       $road_query = "INSERT INTO ROAD(ID,DIRECTION,LANDSLIDE) VALUES(NULL, '".$direction."', '".$landslide."');";
                                                                       if (!mysqli_query($conn, $road_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       }
                                                                       else #it is a rockfall
                                                                       {
                                                                       $rock_slope = $side;
                                                                       $road_query = "INSERT INTO ROAD(ID,DIRECTION,ROCK_SLOPE) VALUES(NULL, '".$direction."', '".$rock_slope."');";
                                                                       if (!mysqli_query($conn, $road_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       }
                                                                       
                                                                       $road_id_query = "SELECT ID FROM ROAD ORDER BY ID DESC LIMIT 1";
                                                                       $road_id_result = $conn->query($road_id_query);
                                                                       $road_id = $road_id_result->fetch_assoc();
                                                                       $update .= "ROAD = '".$road_id['ID']."'";
                                                                       }
                                                                       
                                                                       
                                                                       //sql for the trail table
                                                                       else //trail: insert data into the trail table
                                                                       {
                                                                       $direction = "D";
                                                                       if($begin_mile_marker <= $end_mile_marker)
                                                                       $direction = "U";
                                                                       $trail_query = "INSERT INTO TRAIL(ID,DIRECTION,SIDE) VALUES(NULL, '".$direction."', '".$side."');";
                                                                       if (!mysqli_query($conn, $trail_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       $trail_id_query = "SELECT ID FROM TRAIL ORDER BY ID DESC LIMIT 1";
                                                                       $trail_id_result = $conn->query($trail_id_query);
                                                                       $trail_id = $trail_id_result->fetch_assoc();
                                                                       $update .= "TRAIL = '".$trail_id['ID']."'";
                                                                       }
                                                                       
                                                                       // //sql for the weather table
                                                                       // $weather_query = "INSERT INTO WEATHER(ID, WEATHER_TYPE) VALUES(NULL, '".$weather."');";
                                                                       // if (!mysqli_query($conn, $weather_query)) {
                                                                       //   printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       // }
                                                                       // $weather_id_query = "SELECT ID FROM WEATHER ORDER BY ID DESC LIMIT 1";
                                                                       // $weather_id_result = $conn->query($weather_id_query);
                                                                       // $weather_id = $weather_id_result->fetch_assoc();
                                                                       // $update .= ", WEATHER = '".$weather_id['ID']."'";
                                                                       
                                                                       //sql for the hazard type table
    /*$hazard_type_query = "INSERT INTO HAZARD_TYPE(ID, HAZARD_TYPE) VALUES(NULL, '".$hazard_type."');";
     if (!mysqli_query($conn, $hazard_type_query)) {
     printf("Errormessage: %s\n", mysqli_error($conn));
     }*/
    /*$hazard_type_id_query = "SELECT ID FROM HAZARD_TYPE WHERE HAZARD_TYPE= '".$hazard_type."'";//ORDER BY ID DESC LIMIT 1";
     $hazard_type_id_result = $conn->query($hazard_type_id_query);
     $hazard_type_id = $hazard_type_id_result->fetch_assoc();
     $update .= ", HAZARD_TYPE = '".$hazard_type_id['ID']."'";*/
                                                                       
                                                                       $max_hazard_type ="SELECT ID FROM HAZARD_LINK ORDER BY ID DESC LIMIT 1";
                                                                       $max_hazard_type_result = $conn->query($max_hazard_type);
                                                                       $max_hazard_type_value = $max_hazard_type_result->fetch_assoc();
                                                                       $max_hazard_type_value['ID'] = $max_hazard_type_value['ID'] +1;
                                                                       
                                                                       for($i=0;$i<count($hazard_type);$i++){
                                                                       echo "thing is";
                                                                       echo $hazard_type[2];
                                                                       
                                                                    
                                                                       $hazard_link_query = "INSERT INTO HAZARD_LINK(ID,HAZARD_TYPE) VALUES('".$max_hazard_type_value['ID']."', '".$hazard_type[$i]."');";
                                                                       if (!mysqli_query($conn, $hazard_link_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       
                                                                       }
                                                                       $update .= ", HAZARD_TYPE = '".$max_hazard_type_value['ID']."'";
                                                                       
                                                                       //sql for the landslide preliminary rating
                                                                       if($prelim_rating_landslide_road_width_affected > 0) //then it is a landslide
                                                                       {
                                                                       $landslide_prelim_query = "INSERT INTO LANDSLIDE_PRELIMINARY_RATING(ID, ROAD_WIDTH_AFFECTED, SLIDE_EROSION_EFFECTS, LENGTH_AFFECTED) VALUES(NULL, '".$prelim_rating_landslide_road_width_affected."', '".$prelim_rating_landslide_slide_erosion_effects."', '".$prelim_rating_landslide_length_affected."');";
                                                                       if (!mysqli_query($conn, $landslide_prelim_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       $landslide_prelim_id_query = "SELECT ID FROM LANDSLIDE_PRELIMINARY_RATING ORDER BY ID DESC LIMIT 1";
                                                                       $landslide_prelim_id_result = $conn->query($landslide_prelim_id_query);  
                                                                       $landslide_prelim_id = $landslide_prelim_id_result->fetch_assoc(); 
                                                                       $update .= ", PRELIMINARY_RATING_LANDSLIDE_ID = '".$landslide_prelim_id['ID']."'";
                                                                       $update .= ", PRELIMINARY_RATING_ROCKFALL_ID = '0'";
                                                                       }
                                                                       
                                                                       //sql for the rockfall preliminary rating
                                                                       if($prelim_rating_rockfall_ditch_eff > 0) //then it is a rockfall
                                                                       {
                                                                       $rockfall_prelim_query = "INSERT INTO ROCKFALL_PRELIMINARY_RATING(ID, DITCH_EFF, ROCKFALL_HISTORY, BLOCK_SIZE_EVENT_VOL) VALUES(NULL, '".$prelim_rating_rockfall_ditch_eff."', '".$prelim_rating_rockfall_rockfall_history."', '".$prelim_rating_rockfall_block_size_event_vol."');";
                                                                       if (!mysqli_query($conn, $rockfall_prelim_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       $rockfall_prelim_id_query = "SELECT ID FROM ROCKFALL_PRELIMINARY_RATING ORDER BY ID DESC LIMIT 1";
                                                                       $rockfall_prelim_id_result = $conn->query($rockfall_prelim_id_query);  
                                                                       $rockfall_prelim_id = $rockfall_prelim_id_result->fetch_assoc(); 
                                                                       $update .= ", PRELIMINARY_RATING_ROCKFALL_ID = '".$rockfall_prelim_id['ID']."'";
                                                                       $update .= ", PRELIMINARY_RATING_LANDSLIDE_ID = '0'";
                                                                       }
                                                                       
                                                                       //sql for the rockfall hazard rating
                                                                       if($hazard_rating_rockfall_maint_frequency > 0) //then it is a rockfall
                                                                       {
                                                                       $rockfall_hazard_query = "INSERT INTO ROCKFALL_HAZARD_RATING(ID, MAINT_FREQUENCY, CASE_ONE_STRUC_CONDITION, CASE_ONE_ROCK_FRICTION, CASE_TWO_STRUC_CONDITION, CASE_TWO_DIFF_EROSION) VALUES(NULL, '".$hazard_rating_rockfall_maint_frequency."', '".$hazard_rating_rockfall_case_one_struc_condition."', '".$hazard_rating_rockfall_case_one_rock_friction."', '".$hazard_rating_rockfall_case_two_struc_condition."', '".$hazard_rating_rockfall_case_two_diff_erosion."');";
                                                                       if (!mysqli_query($conn, $rockfall_hazard_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }    
                                                                       $rockfall_hazard_id_query = "SELECT ID FROM ROCKFALL_HAZARD_RATING ORDER BY ID DESC LIMIT 1";
                                                                       $rockfall_hazard_id_result = $conn->query($rockfall_hazard_id_query);  
                                                                       $rockfall_hazard_id = $rockfall_hazard_id_result->fetch_assoc(); 
                                                                       $update .= ", HAZARD_RATING_ROCKFALL_ID = '".$rockfall_hazard_id['ID']."'";
                                                                       $update .= ", HAZARD_RATING_LANDSLIDE_ID = '0'";
                                                                       }
                                                                       
                                                                       //sql for the landslide hazard rating
                                                                       if($hazard_rating_landslide_thaw_stability > 0) //then it is a rockfall
                                                                       {
                                                                       $landslide_hazard_query = "INSERT INTO LANDSLIDE_HAZARD_RATING(ID, THAW_STABILITY, MAINT_FREQUENCY, MOVEMENT_HISTORY) VALUES(NULL, '".$hazard_rating_landslide_thaw_stability."', '".$hazard_rating_landslide_maint_frequency."', '".$hazard_rating_landslide_movement_history."');";
                                                                       if (!mysqli_query($conn, $landslide_hazard_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }    
                                                                       $landslide_hazard_id_query = "SELECT ID FROM LANDSLIDE_HAZARD_RATING ORDER BY ID DESC LIMIT 1";
                                                                       $landslide_hazard_id_result = $conn->query($landslide_hazard_id_query);  
                                                                       $landslide_hazard_id = $landslide_hazard_id_result->fetch_assoc();     
                                                                       $update .= ", HAZARD_RATING_LANDSLIDE_ID = '".$landslide_hazard_id['ID']."'";
                                                                       $update .= ", HAZARD_RATING_ROCKFALL_ID = '0'";
                                                                       }
                                                                       
                                                                       //update the site information table with the new foreign key ids
                                                                       if(strlen($update) > 0) { //if we have an update to be made then we need to add it
                                                                       $site_info_update_query = "UPDATE SITE_INFORMATION SET ".$update." WHERE ID = '".$site_info_id_value['ID']."';";
                                                                       if (!mysqli_query($conn, $site_info_update_query)) {
                                                                       printf("Errormessage: %s\n", mysqli_error($conn));
                                                                       }
                                                                       }
                                                                       
                                                                       /************* FILE UPLOAD ****************/
                                                                       // echo "starting photos";
                                                                       $j = 0;     // Variable for indexing uploaded image.
                                                                       $target_path = $media_path."photo_thumbnails/";     // Declaring Path for uploaded images.
                                                                       
                                                                       foreach($_FILES as $fname=>$file){
                                                                       $is_document = 0;
                                                                       $image_extensions = array("jpeg", "jpg", "png", "JPEG", "JPG", "PNG");      // Extensions which are allowed.
                                                                       
                                                                       $file_name = substr($fname, 0, strrpos($fname, "_"));
                                                                       $file_extension = end((explode("_", $fname))); # extra () to prevent notice
                                                                       $corrected_fname = $file_name.".".$file_extension;
                                                                       
                                                                       
                                                                       
                                                                       if($_FILES[$fname]["size"] <= 10485760){ //limit file size up to 10MB
                                                                       //echo " FILEEXT: ( ".$file_extension." )";
                                                                       if(in_array($file_extension, $image_extensions))//change the target path because it is a document
                                                                       {
                                                                       $target_path = $media_path."photo_thumbnails/";     // Declaring Path for uploaded images.
                                                                       }
                                                                       else
                                                                       {
                                                                       $target_path = $media_path."documents/";     // Declaring Path for uploaded documents.
                                                                       $is_document = 1;
                                                                       }
                                                                       //echo $target_path;
                                                                       
                                                                       if (move_uploaded_file($_FILES[$fname]['tmp_name'], $target_path . $corrected_fname)) {
                                                                       // If file moved to uploads folder.
                                                                       //echo $j. ').<span id="noerror">Image uploaded successfully!.</span><br/><br/>';
                                                                       if($is_document == 1)
                                                                       {
                                                                       $doc_query = "INSERT INTO DOCUMENTS(ID,SI_ID,SITE_ID,DOCUMENT) VALUES(NULL, '".$site_info_id_value['ID']."', '".$site_info_id_value['ID']."', '".$corrected_fname."');";
                                                                       if (!mysqli_query($conn, $doc_query)) {
                                                                       printf("Error inserting documents <br />");
                                                                       $success = false;
                                                                       }
                                                                       }
                                                                       else
                                                                       {
                                                                       $photo_query = "INSERT INTO PHOTOS(ID,SI_ID,SITE_ID,PHOTO) VALUES(NULL, '".$site_info_id_value['ID']."', '".$site_info_id_value['ID']."', '".$corrected_fname."');";
                                                                       //echo "\n\n.$photo_query.";
                                                                       if (!mysqli_query($conn, $photo_query)) {
                                                                       printf("Error inserting photos <br />");
                                                                       $success = false;
                                                                       }
                                                                       }
                                                                       
                                                                       } else {     //  If File Was Not Moved.
                                                                       //echo "\n\nERROR: ".$j. ") ". $_FILES['file_'.$i]['tmp_name']. " " . $target_path . $_FILES['file_'.$i]['name']."\n";
                                                                       }
                                                                       } else {     //   If File Size And File Type Was Incorrect.
                                                                       //echo $j. ').<span id="error">***Invalid file Size or Type***</span><br/><br/>';
                                                                       }
                                                                       
                                                                       
                                                                       }
                                                                       /*
                                                                        for ($i = 0; $i < count($_FILES); $i++) {
                                                                        $is_document = 0;
                                                                        // Loop to get individual element from the array
                                                                        $validextensions = array("jpeg", "jpg", "png", "JPEG", "JPG", "PNG");      // Extensions which are allowed.
                                                                        // $ext = explode('.', basename($_FILES['file_'.$i]['name'][$i]));   // Explode file name from dot(.)
                                                                        // $file_extension = end($ext); // Store extensions in the variable.
                                                                        $fname = $_FILES["file_".$i]["name"];
                                                                        $file_extension = end((explode(".", $fname))); # extra () to prevent notice
                                                                        //$target_path = $target_path . md5(uniqid()) . "." . $ext[count($ext) - 1];     // Set the target path with a new name of image.
                                                                        $j = $j + 1;      // Increment the number of uploaded images according to the files in array.
                                                                        if (($_FILES["file_".$i]["size"][$i] < 1000000000000000))     // Approx. 100kb files can be uploaded.
                                                                        //&& in_array($file_extension, $validextensions)) {
                                                                        {
                                                                        //echo " FILEEXT: ( ".$file_extension." )";
                                                                        if(in_array($file_extension, $validextensions))//change the target path because it is a document
                                                                        {
                                                                        $target_path = $media_path."photo_thumbnails/";     // Declaring Path for uploaded images.
                                                                        }
                                                                        else
                                                                        {
                                                                        $target_path = $media_path."documents/";     // Declaring Path for uploaded documents.
                                                                        $is_document = 1;
                                                                        }
                                                                        //echo $target_path;
                                                                        
                                                                        if (move_uploaded_file($_FILES['file_'.$i]['tmp_name'], $target_path . $_FILES['file_'.$i]['name'])) {
                                                                        // If file moved to uploads folder.
                                                                        //echo $j. ').<span id="noerror">Image uploaded successfully!.</span><br/><br/>';
                                                                        if($is_document == 1)
                                                                        {
                                                                        $doc_query = "INSERT INTO DOCUMENTS(ID,SI_ID,SITE_ID,DOCUMENT) VALUES(NULL, '".$site_info_id_value['ID']."', '".$site_info_id_value['ID']."', '".$_FILES['file_'.$i]['name']."');";
                                                                        if (!mysqli_query($conn, $doc_query)) {
                                                                        printf("Error inserting documents <br />");
                                                                        $success = false;
                                                                        }
                                                                        }
                                                                        else
                                                                        {
                                                                        $photo_query = "INSERT INTO PHOTOS(ID,SI_ID,SITE_ID,PHOTO) VALUES(NULL, '".$site_info_id_value['ID']."', '".$site_info_id_value['ID']."', '".$_FILES['file_'.$i]['name']."');";
                                                                        echo "\n\n.$photo_query.";
                                                                        if (!mysqli_query($conn, $photo_query)) {
                                                                        printf("Error inserting photos <br />");
                                                                        $success = false;
                                                                        }
                                                                        }
                                                                        
                                                                        } else {     //  If File Was Not Moved.
                                                                        //echo "\n\nERROR: ".$j. ") ". $_FILES['file_'.$i]['tmp_name']. " " . $target_path . $_FILES['file_'.$i]['name']."\n";
                                                                        }
                                                                        } else {     //   If File Size And File Type Was Incorrect.
                                                                        //echo $j. ').<span id="error">***Invalid file Size or Type***</span><br/><br/>';
                                                                        }
                                                                        }
                                                                        */
                                                                       //echo "<br \> <br \>SQL was successful. Site has been added to map.";
                                                                       //echo "<br \>Go back to the <a href='http://nl.cs.montana.edu/usmp/web/online/client/save_map.php'>map</a> or the <a href='http://nl.cs.montana.edu/usmp/web/online/client/new_site.php'>new site page</a>";
                                                                       echo "Successfully added site with ID ".$site_info_id_value['ID'].". You will now be redirected to the map page.";
    ?>



