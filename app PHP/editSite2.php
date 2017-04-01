<?php
    
    include('./constants.php');
    
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    $old_site_id = mysqli_real_escape_string($conn, $_POST['old_site_id']);
    // Create connection
    $query = "SELECT SITE_ID FROM SITE_INFORMATION WHERE SITE_ID = '".$old_site_id."'";
    
    $result = $conn->query($query);
    
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
    //   $date = date("Y-m-d H:i:s");
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
    //$email = $_SESSION['user_id'];
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    
    
    $row = $result->fetch_assoc();
    //if($row['SITE_ID'] != false){
    
    $conn = new mysqli($servername, $username, $password, $dbname); //note: these variables are stored in ../constants.php
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    //sql for the site information table
    $site_info_query = "UPDATE SITE_INFORMATION SET UMBRELLA_AGENCY = '".$umbrella_agency."', REGIONAL_ADMIN = '".$regional_admin."' , LOCAL_ADMIN = '".$local_admin."', ROAD_TRAIL_NO = '".$road_trail_number."', ROAD_TRAIL_CLASS = '".$road_trail_class."', BEGIN_MILE_MARKER = '".$begin_mile_marker."', END_MILE_MARKER = '".$end_mile_marker."', ROAD_OR_TRAIL = '".$road_or_trail."', SIDE = '".$side."', RATER = '".$rater."', WEATHER = '".$weather."', DATE = '".$date."' , BEGIN_COORDINATE_LAT = '".$begin_coordinate_lat."' , BEGIN_COORDINATE_LONG ='".$begin_coordinate_long."',END_COORDINATE_LAT = '".$end_coordinate_latitude."', END_COORDINATE_LONG = '".$end_coordinate_longitude."', DATUM = '".$datum."', AADT = '".$aadt."', LENGTH_AFFECTED = '".$length_affected."', SLOPE_HT_AXIAL_LENGTH = '".$slope_height_axial_length."', SLOPE_ANGLE = '".$slope_angle."', SIGHT_DISTANCE = '".$sight_distance."', ROAD_TRAIL_WIDTH = '".$road_trail_width."', SPEED_LIMIT = '".$speed_limit."', MINIMUM_DITCH_WIDTH = '".$minimum_ditch_width."' , MAXIMUM_DITCH_WIDTH = '".$maximum_ditch_width."', MINIMUM_DITCH_DEPTH = '".$minimum_ditch_depth."', MAXIMUM_DITCH_DEPTH = '".$maximum_ditch_depth."' , MINIMUM_DITCH_SLOPE_FIRST = '".$first_begin_ditch_slope."' , MAXIMUM_DITCH_SLOPE_FIRST = '".$first_end_ditch_slope."', MINIMUM_DITCH_SLOPE_SECOND = '".$second_begin_ditch_slope."' , MAXIMUM_DITCH_SLOPE_SECOND = '".$second_end_ditch_slope."' , BLK_SIZE = '".$blk_size."' , VOLUME = '".$volume."' , BEGIN_ANNUAL_RAINFALL = '".$start_annual_rainfall."', END_ANNUAL_RAINFALL = '".$end_annual_rainfall."' ,SOLE_ACCESS_ROUTE = '".$sole_access_route."', FIXES_PRESENT = '".$fixes_present."', PRELIMINARY_RATING_IMPACT_ON_USE = '".$prelim_rating_impact_on_use."' , PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX = '".strtoupper($prelim_rating_aadt_usage_calc_checkbox)."', PRELIMINARY_RATING_ADDT_USAGE = '".$prelim_rating_aadt_usage."', PRELIMINARY_RATING = '".$prelim_rating."', HAZARD_RATING_SLOPE_DRAINAGE = '".$hazard_rating_slope_drainage."', HAZARD_RATING_ANNUAL_RAINFALL = '".$hazard_rating_annual_rainfall."' , HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH = '".$hazard_rating_slope_height_axial_length."', RISK_RATING_ROUTE_TRAIL = '". $risk_rating_route_trail_width."' , RISK_RATING_HUMAN_EX_FACTOR = '".$risk_rating_human_ex_factor."', RISK_RATING_PERCENT_DSD = '".$risk_rating_percent_dsd."' , RISK_RATING_R_W_IMPACTS = '".$risk_rating_r_w_impacts."' , RISK_RATING_ENVIRO_CULT_IMPACTS = '".$risk_rating_enviro_cult_impacts."', RISK_RATING_MAINT_COMPLEXITY = '".$risk_rating_maint_complexity."' , RISK_RATING_EVENT_COST = '".$risk_rating_event_cost."', HAZARD_TOTAL = '".$hazard_total."' , RISK_TOTAL = '".$risk_total."', TOTAL_SCORE = '".$total_score."', EMAIL ='".$email."' WHERE SITE_ID = '".$old_site_id."'";
    
    //   echo $site_info_query;
    if (!mysqli_query($conn, $site_info_query)) {
        printf("Errormessage: %s\n", mysqli_error($conn));
    }
    else{
        echo "good job";
    }
    
    //}
    //                                                                           else
    //                                                                           {
    //                                                                           echo "You do not have permissions to edit this site.";
    //                                                                           echo "<br \>Go back to the <a href='http://nl.cs.montana.edu/usmp/web/client/map.php'>map</a> or the <a href='http://nl.cs.montana.edu/usmp/web/online/client/new_site.php'>new site page</a>";
    //                                                                           }
    ?>
