//
//  LandslideModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/2/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation
class LandslideModel: NSObject{
    var id: String?
    var site_id: String?
    var mgmt_area: String?
    var umbrella_agency: String?
    var regiona_admin: String?
    var local_admin: String?
    var date: String?               //??
    var road_trail_no: String?
    var road_trail_class: String?
    var begin_mile_marker: String?
    var end_mile_marker: String?
    var road_or_trail: String?
    var side: String?
    var rater: String?
    var weather: String?
    var begin_coordinate_lat: String?
    var begin_coordinate_long: String?
    var end_coordinate_lat: String?
    var end_coordinate_long: String?
    var datum: String?
    var aadt: String?
    var hazard_type: String?
    var length_affected: String?
    var slope_ht_axial_length: String?
    var slope_angle: String?
    var sight_distance: String?
    var road_trail_width: String?
    var speed_limit: String?
    var minimum_ditch_width: String?
    var maximum_ditch_width: String?
    var minimum_ditch_depth: String?
    var maximum_ditch_depth: String?
    var minimum_ditch_slope_first: String?
    var maximum_ditch_slope_first: String?
    var minimum_ditch_slope_second: String?
    var maximum_ditch_slope_second: String?
    var begin_annual_rainfall: String?
    var end_annual_rainfall: String?
    var sole_access_route: String?
    var fixes_present: String?
    //blk size/vol for rockfall
    var flma_id: String?
    var flma_name: String?
    var flma_description: String?
    var comments: String?
    
    //Prelim Landslide Only
    var prelim_landslide_road_width_affected: String?
    var prelim_landslide_slide_erosion_effects: String?
    var prelim_landslide_length_affected: String?

    //Prelim All
    var impact_on_use: String?
    var aadt_usage_calc_checkbox: String?
    var aadt_usage: String?
    var prelim_rating: String?
    
    //Hazard Rating All
    var slope_drainage: String?
    var hazard_rating_annual_rainfall: String?
    var hazard_rating_slope_height_axial_length: String?
    var hazard_total: String?

    //Hazard Rating Landslide
    var hazard_landslide_thaw_stability: String?
    var hazard_landslide_maint_frequency: String?
    var hazard_landslide_movement_history: String?
    
    //Risk Ratings-All
    var route_trail_width: String?
    var human_ex_factor: String?
    var percent_dsd: String?
    var r_w_impacts: String?
    var enviro_cult_impacts: String?
    var maint_complexity: String?
    var event_cost: String?
    var risk_total: String?
    
    var total_score: String?

    override init(){
        
    }
    
    init(id: String, site_id: String, mgmt_area: String,umbrella_agency: String, regional_admin: String, local_admin: String, date: String, road_trail_no: String, road_trail_class: String, begin_mile_marker: String, end_mile_marker: String, road_or_trail: String, side: String, rater: String, weather: String, begin_coordinate_lat: String,begin_coordinate_long: String,end_coordinate_lat: String,end_coordinate_long: String,datum: String,aadt: String,hazard_type: String, length_affected: String, slope_ht_axial_length: String,slope_angle: String, sight_distance: String, road_trail_width: String, speed_limit: String, minimum_ditch_width: String, maximum_ditch_width: String, minimum_ditch_depth: String, maximum_ditch_depth: String, minimum_ditch_slope_first: String, maximum_ditch_slope_first: String,minimum_ditch_slope_second: String,maximum_ditch_slope_second: String,begin_annual_rainfall: String,end_annual_rainfall: String,sole_access_route: String,fixes_present: String,flma_id: String, flma_name: String,flma_description: String, comments: String,prelim_landslide_road_width_affected: String,prelim_landslide_slide_erosion_effects: String,prelim_landslide_length_affected: String,impact_on_use: String,aadt_usage_calc_checkbox: String,aadt_usage: String, prelim_rating: String,slope_drainage: String,hazard_rating_annual_rainfall: String,hazard_rating_slope_height_axial_length: String,hazard_total: String,hazard_landslide_thaw_stability: String,hazard_landslide_maint_frequency: String,hazard_landslide_movement_history: String,route_trail_width: String,human_ex_factor: String,percent_dsd: String,r_w_impacts: String,enviro_cult_impacts: String,maint_complexity: String,event_cost: String,risk_total: String,total_score: String ){
        
        self.id = id
        self.site_id=site_id
        self.mgmt_area=mgmt_area
        self.umbrella_agency = umbrella_agency
        self.regiona_admin = regional_admin
        self.local_admin = local_admin
        self.date = date
        self.road_trail_no = road_trail_no
        self.road_trail_class = road_trail_class
        self.begin_mile_marker = begin_mile_marker
        self.end_mile_marker = end_mile_marker
        self.road_or_trail = road_or_trail
        self.side = side
        self.rater = rater
        self.weather = weather
        self.begin_coordinate_lat = begin_coordinate_lat
        self.begin_coordinate_long = begin_coordinate_long
        self.end_coordinate_lat = end_coordinate_lat
        self.end_coordinate_long = end_coordinate_long
        self.datum = datum
        self.aadt = aadt
        self.hazard_type = hazard_type
        self.length_affected = length_affected
        self.slope_ht_axial_length = slope_ht_axial_length
        self.slope_angle = slope_angle
        self.sight_distance = sight_distance
        self.road_trail_width = road_trail_width
        self.speed_limit = speed_limit
        self.minimum_ditch_width = minimum_ditch_width
        self.maximum_ditch_width = maximum_ditch_width
        self.minimum_ditch_depth = minimum_ditch_depth
        self.maximum_ditch_depth = maximum_ditch_depth
        self.minimum_ditch_slope_first = minimum_ditch_slope_first
        self.maximum_ditch_slope_first = maximum_ditch_slope_first
        self.minimum_ditch_slope_second = minimum_ditch_slope_second
        self.maximum_ditch_slope_second = maximum_ditch_slope_second
        self.begin_annual_rainfall = begin_annual_rainfall
        self.end_annual_rainfall = end_annual_rainfall
        self.sole_access_route = sole_access_route
        self.fixes_present = fixes_present
        self.flma_id = flma_id
        self.flma_name = flma_name
        self.flma_description = flma_description
        self.comments = comments
        
        //Prelim Landslide onlly
        self.prelim_landslide_road_width_affected = prelim_landslide_road_width_affected
        self.prelim_landslide_slide_erosion_effects = prelim_landslide_slide_erosion_effects
        self.prelim_landslide_length_affected = prelim_landslide_length_affected
        
        //Prelim All
        self.impact_on_use = impact_on_use
        self.aadt_usage_calc_checkbox = aadt_usage_calc_checkbox
        self.aadt_usage = aadt_usage
        self.prelim_rating = prelim_rating
        
        //Hazard all
        self.slope_drainage = slope_drainage
        self.hazard_rating_annual_rainfall = hazard_rating_annual_rainfall
        self.hazard_rating_slope_height_axial_length = hazard_rating_slope_height_axial_length
        self.hazard_total = hazard_total
        
        //Hazard Landslide only
        self.hazard_landslide_thaw_stability = hazard_landslide_thaw_stability
        self.hazard_landslide_maint_frequency = hazard_landslide_maint_frequency
        self.hazard_landslide_movement_history = hazard_landslide_movement_history
        
        //Risk Ratings- All
        self.route_trail_width = route_trail_width
        self.human_ex_factor = human_ex_factor
        self.percent_dsd = percent_dsd
        self.r_w_impacts = r_w_impacts
        self.enviro_cult_impacts = enviro_cult_impacts
        self.maint_complexity = maint_complexity
        self.event_cost = event_cost
        self.risk_total = risk_total
        
        self.total_score = total_score
        
        
    }
}
