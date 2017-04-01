<?php
    /************
     This file takes in any changes to a site and updates the database
     
     Called from usmp/client/edit_site.html onsubmit
     
     -S.A.M.
     ************/
    ?>

<?php
    
    
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
    
    
    /*******
     This file recieves data from new_site.html (USMP/client/new_site.html) and puts it in the database as a new site
     *******/
    
    include('./../constants.php');
    /**********
     Collect POST data from new site form
     **********/
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    $old_site_id = mysqli_real_escape_string($conn, $_POST['old_site_id']);
    
    // Create connection
    
    
    $query = "SELECT SITE_ID FROM SITE_INFORMATION WHERE ID='$old_site_id'";
    
    $result = $conn->query($query);
    
    
    $row = $result->fetch_assoc();
    
    debugPrint("POST data: ".print_r($_POST, true));
    
    if($row['SITE_ID'] != false){
        
        //if($row['EMAIL'] == $_SESSION['user_id'] || $_SESSION['permissions'] == 0){
        // $old_site_id = $_POST['old_site_id'];
        
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
        //   $date = mysqli_real_escape_string($conn, $_POST['date']);
        $date = date("Y-m-d H:i:s");
        $begin_coordinate_lat = mysqli_real_escape_string($conn, $_POST['begin_coordinate_latitude']);
        $begin_coordinate_long = mysqli_real_escape_string($conn, $_POST['begin_coordinate_longitude']);
        $end_coordinate_latitude = mysqli_real_escape_string($conn, $_POST['end_coordinate_latitude']);
        $end_coordinate_longitude = mysqli_real_escape_string($conn, $_POST['end_coordinate_longitude']);
        $datum = mysqli_real_escape_string($conn, $_POST['datum']);
        $aadt = mysqli_real_escape_string($conn, $_POST['aadt']);
        $hazard_type = mysqli_real_escape_string($conn, $_POST['hazard_type']);
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
        
        $email = "";
        
        
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
        
        //echo "<br \><br \>Connected to USMP_BETA DB";
        
        $site_id_query = "SELECT SITE_ID FROM SITE_INFORMATION WHERE ID = '".$old_site_id."'";
        
        
        $site_id_result = $conn->query($site_id_query);
        $site_id_value = $site_id_result->fetch_assoc();
        //sql for the site information table
        $site_info_query = "UPDATE SITE_INFORMATION SET SITE_ID = '".$site_id_value['SITE_ID']."', UMBRELLA_AGENCY = '".$umbrella_agency."' , REGIONAL_ADMIN = '".$regional_admin."' , LOCAL_ADMIN = '".$local_admin."', ROAD_TRAIL_NO = ".$road_trail_number."' , ROAD_TRAIL_CLASS = '".$road_trail_class."' , BEGIN_MILE_MARKER = '".$begin_mile_marker."', END_MILE_MARKER = '".$end_mile_marker."', ROAD_OR_TRAIL = '".$road_or_trail."',SIDE = '".$side."', RATER = '".$rater."', WEATHER = '".$weather."', DATE = '".$date."' , BEGIN_COORDINATE_LAT = '".$begin_coordinate_lat."' , BEGIN_COORDINATE_LONG ='".$begin_coordinate_long."',END_COORDINATE_LAT = '".$end_coordinate_latitude."', END_COORDINATE_LONG = '".$end_coordinate_longitude."', DATUM = '".$datum."', AADT = '".$aadt."', LENGTH_AFFECTED = '".$length_affected."', SLOPE_HT_AXIAL_LENGTH = '".$slope_height_axial_length."', SLOPE_ANGLE = '".$slope_angle."', SIGHT_DISTANCE = '".$sight_distance."', ROAD_TRAIL_WIDTH = '".$road_trail_width."', SPEED_LIMIT = '".
        $speed_limit."', MINIMUM_DITCH_WIDTH = '".$minimum_ditch_width."' , MAXIMUM_DITCH_WIDTH = '".$maximum_ditch_width."', MINIMUM_DITCH_DEPTH = '".$minimum_ditch_depth."', MAXIMUM_DITCH_DEPTH = '".$maximum_ditch_depth."' , MINIMUM_DITCH_SLOPE_FIRST = '".$first_begin_ditch_slope."' , MAXIMUM_DITCH_SLOPE_FIRST = '".$first_end_ditch_slope.
        "', MINIMUM_DITCH_SLOPE_SECOND = '".$second_begin_ditch_slope."' , MAXIMUM_DITCH_SLOPE_SECOND = '".$second_end_ditch_slope."' , BLK_SIZE = '".$blk_size."' , VOLUME = '".$volume."' , BEGIN_ANNUAL_RAINFALL = '".$start_annual_rainfall."', END_ANNUAL_RAINFALL = '".$end_annual_rainfall."' ,SOLE_ACCESS_ROUTE = '".$sole_access_route."', FIXES_PRESENT = '".$fixes_present."', PRELIMINARY_RATING_IMPACT_ON_USE = '".$prelim_rating_impact_on_use."' , PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX = ".strtoupper($prelim_rating_aadt_usage_calc_checkbox)." , PRELIMINARY_RATING_ADDT_USAGE = '".$prelim_rating_aadt_usage."' , PRELIMINARY_RATING = '".$prelim_rating."', HAZARD_RATING_SLOPE_DRAINAGE = '".$hazard_rating_slope_drainage."', HAZARD_RATING_ANNUAL_RAINFALL = '".$hazard_rating_annual_rainfall."' , HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH = '".$hazard_rating_slope_height_axial_length."', RISK_RATING_ROUTE_TRAIL = '". $risk_rating_route_trail_width."' , RISK_RATING_HUMAN_EX_FACTOR = '".$risk_rating_human_ex_factor."', RISK_RATING_PERCENT_DSD = '".$risk_rating_percent_dsd."' , RISK_RATING_R_W_IMPACTS = '".$risk_rating_r_w_impacts."' , RISK_RATING_ENVIRO_CULT_IMPACTS = '".$risk_rating_enviro_cult_impacts."', RISK_RATING_MAINT_COMPLEXITY = '".$risk_rating_maint_complexity."' , RISK_RATING_EVENT_COST = '".$risk_rating_event_cost."', HAZARD_TOTAL = '".$hazard_total."' , RISK_TOTAL = '".$risk_total."', TOTAL_SCORE = '".$total_score."' , SLOPE_STATUS = '1', EMAIL ='".$email."' WHERE ID = '".$old_site_id."');";
        
        //   echo $site_info_query;
        
        if (!mysqli_query($conn, $site_info_query)) {
            printf("Errormessage: %s\n", mysqli_error($conn));
        }
        
        $update = ""; //the update to be made for the foreign keys in SITE_INFORMATION at the end
        
        $site_info_id = "SELECT ID FROM SITE_INFORMATION ORDER BY ID DESC LIMIT 1";
        
        $site_info_id_result = $conn->query($site_info_id);
        $site_info_id_value = $site_info_id_result->fetch_assoc();
        
        //sql for the comments table
        if($comments != "None") {
            $comments_query = "UPDATE COMMENTS SET SI_ID = ".$site_info_id_value['ID'].",COMMENT = '".$comments."' WHERE ID = ."$site_info_id_value.");";
            
            if (!mysqli_query($conn, $comments_query)) {
                printf("Errormessage: %s\n", mysqli_error($conn));
            }
        }
        
        //sql for the fmla table
        if($fmla_description != "None") {
            if($debug){
                echo "<br \><br \>fmla_name: ".$fmla_name;
                echo "<br \><br \>fmla_id: ".$fmla_id;
                echo "<br \><br \>fmla_description: ".$fmla_description;
                echo "<br \><br \>site_id_value: ".$site_id_value['SITE_ID'];
            }
            $fmla_query = "UPDATE FMLA_LINK SET FMLA_NAME = '".$fmla_name."' , FMLA_ID = '".$fmla_id."' , FMLA_DESCRIPTION = '".$fmla_description."', SI_ID = ".$site_id_value['SITE_ID']." WHERE ID = ."$site_info_id_value." );";
            
            if (!mysqli_query($conn, $fmla_query)) {
                printf("Errormessage: %s\n", mysqli_error($conn));
            }
            
        }
        
        
        
                                                                                   //sql for the event table -- these won't exist with the initial data
        
                                                                                   //sql for the photo range table -- these won't exist with the initial datas
        
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
                                                                                   $road_query = "UPDATE ROAD SET DIRECTION = '".$direction."',LANDSLIDE = '".$landslide."' WHERE ID = ."$site_info_id_value.");";
        
                                                                                   if (!mysqli_query($conn, $road_query)) {
                                                                                   printf("Errormessage: %s\n", mysqli_error($conn));
                                                                                   }
                                                                                   }
                                                                                   else #it is a rockfall
                                                                                   {
                                                                                   $rock_slope = $side;
                                                                                   $road_query = "UPDATE ROAD SET DIRECTION = '".$direction."' ,ROCK_SLOPE = '".$rock_slope."' WHERE ID = ."$site_info_id_value.");";
        
                                                                                   if (!mysqli_query($conn, $road_query)) {
                                                                                   printf("Errormessage: %s\n", mysqli_error($conn));
                                                                                   }
                                                                                   }
        
                                                                                   $road_id_query = "SELECT ID FROM ROAD ORDER BY ID DESC LIMIT 1";
        
                                                                                   $road_id_result = $conn->query($road_id_query);
                                                                                   $road_id = $road_id_result->fetch_assoc();
                                                                                   $update .= "ROAD = '".$road_id['ID']."'";
                                                                                   }
        
                                                                                    //to here
        
                                                                                   //sql for the trail table
                                                                                   else //trail: insert data into the trail table
                                                                                   {
                                                                                   $direction = "D";
                                                                                   if($begin_mile_marker <= $end_mile_marker)
                                                                                   $direction = "U";
                                                                                   $trail_query = "UPDATE TRAIL SET DIRECTION = '".$direction."' ,SIDE = '".$side."' WHERE ID = ."$road_id.");";
                                                                                   if (!mysqli_query($conn, $trail_query)) {
                                                                                   printf("Errormessage: %s\n", mysqli_error($conn));
                                                                                   }
                                                                                   $trail_id_query = "SELECT ID FROM TRAIL ORDER BY ID DESC LIMIT 1";
                                                                                   $trail_id_result = $conn->query($trail_id_query);
                                                                                   $trail_id = $trail_id_result->fetch_assoc();
                                                                                   $update .= "TRAIL = '".$trail_id['ID']."'";
                                                                                   }
        
        
                                                                                   $hazard_type_id_query = "SELECT ID FROM HAZARD_TYPE WHERE HAZARD_TYPE= '".$hazard_type."'";//ORDER BY ID DESC LIMIT 1";
                                                                                   $hazard_type_id_result = $conn->query($hazard_type_id_query);
                                                                                   $hazard_type_id = $hazard_type_id_result->fetch_assoc();
                                                                                   $update .= ", HAZARD_TYPE = '".$hazard_type_id['ID']."'";
        
                                                                                   //sql for the landslide preliminary rating
                                                                                   if($prelim_rating_landslide_road_width_affected > 0) //then it is a landslide
                                                                                   {
                                                                                   $landslide_prelim_query = "UPDATE LANDSLIDE_PRELIMINARY_RATING SET ROAD_WIDTH_AFFECTED = '".$prelim_rating_landslide_road_width_affected."' , SLIDE_EROSION_EFFECTS = '".$prelim_rating_landslide_slide_erosion_effects."' , LENGTH_AFFECTED = '".$prelim_rating_landslide_length_affected."');";
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
                                                                                   $rockfall_prelim_query = "UPDATE ROCKFALL_PRELIMINARY_RATING SET DITCH_EFF = '".$prelim_rating_rockfall_ditch_eff."' , ROCKFALL_HISTORY = '".$prelim_rating_rockfall_rockfall_history."' , BLOCK_SIZE_EVENT_VOL = '".$prelim_rating_rockfall_block_size_event_vol."');";
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
                                                                                   $rockfall_hazard_query = "UPDATE ROCKFALL_HAZARD_RATING SET MAINT_FREQUENCY = '".$hazard_rating_rockfall_maint_frequency."' , CASE_ONE_STRUC_CONDITION = '".$hazard_rating_rockfall_case_one_struc_condition."' , CASE_ONE_ROCK_FRICTION = '".$hazard_rating_rockfall_case_one_rock_friction."' , CASE_TWO_STRUC_CONDITION = '".$hazard_rating_rockfall_case_two_struc_condition."' , CASE_TWO_DIFF_EROSION = '".$hazard_rating_rockfall_case_two_diff_erosion."');";
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
                                                                                   $landslide_hazard_query = "UPDATE LANDSLIDE_HAZARD_RATING THAW_STABILITY = '".$hazard_rating_landslide_thaw_stability."' , MAINT_FREQUENCY = '".$hazard_rating_landslide_maint_frequency."', MOVEMENT_HISTORY =  '".$hazard_rating_landslide_movement_history."');";
                                                                                   if (!mysqli_query($conn, $landslide_hazard_query)) {
                                                                                   printf("Errormessage: %s\n", mysqli_error($conn));
                                                                                   }
                                                                                   $landslide_hazard_id_query = "SELECT ID FROM LANDSLIDE_HAZARD_RATING ORDER BY ID DESC LIMIT 1";
                                                                                   $landslide_hazard_id_result = $conn->query($landslide_hazard_id_query);
                                                                                   $landslide_hazard_id = $landslide_hazard_id_result->fetch_assoc();
                                                                                   $update .= ", HAZARD_RATING_LANDSLIDE_ID = '".$landslide_hazard_id['ID']."'";
                                                                                   $update .= ", HAZARD_RATING_ROCKFALL_ID = '0'";
                                                                                   }
        
        //                                                                           //update the site information table with the new foreign key ids
        //                                                                           if(strlen($update) > 0) { //if we have an update to be made then we need to add it
        //                                                                           $site_info_update_query = "UPDATE SITE_INFORMATION SET ".$update." WHERE ID = '".$site_info_id_value['ID']."';";
        //                                                                           if (!mysqli_query($conn, $site_info_update_query)) {
        //                                                                           //echo $site_info_update_query;
        //                                                                           printf("Errormessage: %s\n", mysqli_error($conn));
        //                                                                           }
        //                                                                           }
        
                                                                                   /************* FILE UPLOAD ****************/
                                                                                   //echo "starting photos";
                                                                                   $j = 0;     // Variable for indexing uploaded image.
                                                                                   $target_path = $media_path."photo_thumbnails/";     // Declaring Path for uploaded images.
                                                                                   foreach($_FILES as $fname=>$file){
                                                                                   $is_document = 0;
                                                                                   $image_extensions = array("jpeg", "jpg", "png", "JPEG", "JPG", "PNG");      // Extensions which are allowed.
        
                                                                                   $file_name = substr($fname, 0, strrpos($fname, "_"));
                                                                                   $file_extension = end((explode("_", $fname))); # extra () to prevent notice
                                                                                   $corrected_fname = $file_name.".".$file_extension;
        
        
        
                                                                                   if($_FILES[$fname]["size"] < 1000000000000000){
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
                                                                                   $doc_query = "UPDATE DOCUMENTS SI_ID = '".$site_info_id_value['ID']."' ,SITE_ID = '".$site_id_value['SITE_ID']."',DOCUMENT = '".$corrected_fname."');";
                                                                                   if (!mysqli_query($conn, $doc_query)) {
                                                                                   printf("Error inserting documents <br />");
                                                                                   $success = false;
                                                                                   }
                                                                                   }
                                                                                   else
                                                                                   {
                                                                                   $photo_query = "UPDATE PHOTOS SI_ID = '".$site_info_id_value['ID']."',SITE_ID = '".$site_id_value['SITE_ID']."',PHOTO = '".$corrected_fname."');";
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
        
        
        }  //this one?
        
        echo "Successfully edited site ".$site_id_value['SITE_ID']." in the database. You will now be redirected back to the map page.";
        //   echo "<br \> <br \>SQL was successful. The site has been updated.";
        //   echo "<br \>Go back to the <a href='http://nl.cs.montana.edu/usmp/web/client/map.php'>map</a> or the <a href='http://nl.cs.montana.edu/usmp/web/online/client/new_site.php'>new site page</a>";
        //}//here?
        else
        {
            echo "You do not have permissions to edit this site.";
            echo "<br \>Go back to the <a href='http://nl.cs.montana.edu/usmp/web/client/map.php'>map</a> or the <a href='http://nl.cs.montana.edu/usmp/web/online/client/new_site.php'>new site page</a>";
        }
        
        
        
        
        ?>




