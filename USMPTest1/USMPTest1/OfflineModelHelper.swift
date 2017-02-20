//
//  OfflineModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/20/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

import Foundation


//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/



protocol OfflineModelHelperProtocol: class{
    func itemsDownloadedO (_ items: NSArray)
    
}

var responseO = ""
var ODictionary = NSDictionary()

class OfflineModelHelper: NSObject, URLSessionDataDelegate{
    
    func helper(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/getLandslide.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "id=\(shareData.current_clicked_id)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            
            responseO = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            
            responseO = responseO.replacingOccurrences(of: "[", with: "")
            responseO = responseO.replacingOccurrences(of: "]", with: "")
            responseO = responseO.replacingOccurrences(of: "{", with: "")
            responseO = responseO.replacingOccurrences(of: "}", with: "")
            var finalString = "{"
            finalString = finalString.appending(responseO)
            
            finalString = finalString.appending("}")
            print("FINAL STRING IS")
            print(finalString)
            
            if let data2 = finalString.data(using: .utf8){
                
                do {
                    ODictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("DICTIONARY ERROR")
                    print("error: \(error.localizedDescription)")
                }
            }
            
            self.parseJSON()
            
            
            
        }
        task.resume()
        
        
        
    }
    
    weak var delegate: OfflineModelHelperProtocol?
    
    func downloadItems(){
        helper()
        
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
    }
    
    func parseJSON(){
        
        let comments : NSMutableArray = NSMutableArray()
        let thing = OfflineModel()//instantiate object to hold each element in the spec. JSON obj.
        
        if(ODictionary.value(forKey:"ID") as? String != nil){
            thing.id = ODictionary.value(forKey: "ID")! as? String}
        else{
            thing.id = ""
        }
        
        if(ODictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = ODictionary.value(forKey: "SITE_ID")! as? String}
        else{
            thing.site_id = ""
        }
        
        if(ODictionary.value(forKey:"MGMT_AREA") as? String != nil){
            thing.mgmt_area = ODictionary.value(forKey: "MGMT_AREA")! as? String}
        else{
            thing.mgmt_area = ""
        }
        
        if(ODictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            thing.umbrella_agency = ODictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.umbrella_agency = ""
        }
        
        if(ODictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            thing.regiona_admin = ODictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            thing.regiona_admin = ""
        }
        
        if(ODictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            thing.local_admin = ODictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            thing.local_admin = ""
        }
        
        if(ODictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            thing.road_trail_no = ODictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            thing.road_trail_no = ""
        }
        
        if(ODictionary.value(forKey:"ROAD_TRAIL_CLASS") as? String != nil){
            thing.road_trail_class = ODictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String}
        else{
            thing.road_trail_class = ""
        }
        
        if(ODictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            thing.begin_mile_marker = ODictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            thing.begin_mile_marker = ""
        }
        
        if(ODictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            thing.end_mile_marker = ODictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            thing.end_mile_marker = ""
        }
        
        if(ODictionary.value(forKey:"ROAD_OR_TRAIL") as? String != nil){
            thing.road_or_trail = ODictionary.value(forKey: "ROAD_OR_TRAIL")! as? String}
        else{
            thing.road_or_trail = ""
        }
        
        if(ODictionary.value(forKey:"SIDE") as? String != nil){
            thing.side = ODictionary.value(forKey: "SIDE")! as? String}
        else{
            thing.side = ""
        }
        
        if(ODictionary.value(forKey:"RATER") as? String != nil){
            thing.rater = ODictionary.value(forKey: "RATER")! as? String}
        else{
            thing.rater = ""
        }
        
        if(ODictionary.value(forKey:"WEATHER") as? String != nil){
            thing.weather = ODictionary.value(forKey: "WEATHER")! as? String}
        else{
            thing.weather = ""
        }
        
        if(ODictionary.value(forKey:"DATE") as? String != nil){
            thing.date = ODictionary.value(forKey: "DATE")! as? String}
        else{
            thing.date = ""
        }
        
        if(ODictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            thing.begin_coordinate_lat = ODictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String}
        else{
            thing.begin_coordinate_lat = ""
        }
        
        if(ODictionary.value(forKey:"BEGIN_COORDINATE_LONG") as? String != nil){
            thing.begin_coordinate_long = ODictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String}
        else{
            thing.begin_coordinate_long = ""
        }
        
        if(ODictionary.value(forKey:"END_COORDINATE_LAT") as? String != nil){
            thing.end_coordinate_lat = ODictionary.value(forKey: "END_COORDINATE_LAT")! as? String}
        else{
            thing.end_coordinate_lat = ""
        }
        
        if(ODictionary.value(forKey:"END_COORDINATE_LONG") as? String != nil){
            thing.end_coordinate_long = ODictionary.value(forKey: "END_COORDINATE_LONG")! as? String}
        else{
            thing.end_coordinate_long = ""
        }
        
        if(ODictionary.value(forKey:"DATUM") as? String != nil){
            thing.datum = ODictionary.value(forKey: "DATUM")! as? String}
        else{
            thing.datum = ""
        }
        
        if(ODictionary.value(forKey:"AADT") as? String != nil){
            thing.aadt = ODictionary.value(forKey: "AADT")! as? String}
        else{
            thing.aadt = ""
        }
        
        if(ODictionary.value(forKey:"LENGTH_AFFECTED") as? String != nil){
            thing.length_affected = ODictionary.value(forKey: "LENGTH_AFFECTED")! as? String}
        else{
            thing.length_affected = ""
        }
        
        if(ODictionary.value(forKey:"SLOPE_HT_AXIAL_LENGTH") as? String != nil){
            thing.slope_ht_axial_length = ODictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String}
        else{
            thing.slope_ht_axial_length = ""
        }
        
        if(ODictionary.value(forKey:"SLOPE_ANGLE") as? String != nil){
            thing.slope_angle = ODictionary.value(forKey: "SLOPE_ANGLE")! as? String}
        else{
            thing.slope_angle = ""
        }
        
        if(ODictionary.value(forKey:"SIGHT_DISTANCE") as? String != nil){
            thing.sight_distance = ODictionary.value(forKey: "SIGHT_DISTANCE")! as? String}
        else{
            thing.sight_distance = ""
        }
        
        if(ODictionary.value(forKey:"ROAD_TRAIL_WIDTH") as? String != nil){
            thing.road_trail_width = ODictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String}
        else{
            thing.road_trail_width = ""
        }
        
        if(ODictionary.value(forKey:"SPEED_LIMIT") as? String != nil){
            thing.speed_limit = ODictionary.value(forKey: "SPEED_LIMIT")! as? String}
        else{
            thing.speed_limit = ""
        }
        
        if(ODictionary.value(forKey:"MINIMUM_DITCH_WIDTH") as? String != nil){
            thing.minimum_ditch_width = ODictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.minimum_ditch_width = ""
        }
        
        if(ODictionary.value(forKey:"MAXIMUM_DITCH_WIDTH") as? String != nil){
            thing.maximum_ditch_width = ODictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.maximum_ditch_width = ""
        }
        
        if(ODictionary.value(forKey:"MINIMUM_DITCH_DEPTH") as? String != nil){
            thing.minimum_ditch_depth = ODictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.minimum_ditch_depth = ""
        }
        
        if(ODictionary.value(forKey:"MAXIMUM_DITCH_DEPTH") as? String != nil){
            thing.maximum_ditch_depth = ODictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.maximum_ditch_depth = ""
        }
        
        if(ODictionary.value(forKey:"MINIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.minimum_ditch_slope_first = ODictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.minimum_ditch_slope_first = ""
        }
        
        if(ODictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.maximum_ditch_slope_first = ODictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.maximum_ditch_slope_first = ""
        }
        
        if(ODictionary.value(forKey:"MINIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.minimum_ditch_slope_second = ODictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.minimum_ditch_slope_second = ""
        }
        
        if(ODictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.maximum_ditch_slope_second = ODictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.maximum_ditch_slope_second = ""
        }
        
        if(ODictionary.value(forKey:"BLK_SIZE") as? String != nil){
            thing.blk_size = ODictionary.value(forKey: "BLK_SIZE")! as? String}
        else{
            thing.blk_size = ""
        }
        
        if(ODictionary.value(forKey:"VOLUME") as? String != nil){
            thing.volume = ODictionary.value(forKey: "VOLUME")! as? String}
        else{
            thing.volume = ""
        }
        
        
        if(ODictionary.value(forKey:"BEGIN_ANNUAL_RAINFALL") as? String != nil){
            thing.begin_annual_rainfall = ODictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String}
        else{
            thing.begin_annual_rainfall = ""
        }
        
        if(ODictionary.value(forKey:"END_ANNUAL_RAINFALL") as? String != nil){
            thing.end_annual_rainfall = ODictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String}
        else{
            thing.end_annual_rainfall = ""
        }
        
        if(ODictionary.value(forKey:"SOLE_ACCESS_ROUTE") as? String != nil){
            thing.sole_access_route = ODictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String}
        else{
            thing.sole_access_route = ""
        }
        
        if(ODictionary.value(forKey:"FIXES_PRESENT") as? String != nil){
            thing.fixes_present = ODictionary.value(forKey: "FIXES_PRESENT")! as? String}
        else{
            thing.fixes_present = ""
        }
        
        //PRELIM RATINGS ALL
        
        if(ODictionary.value(forKey:"PRELIMINARY_RATING_IMPACT_ON_USE") as? String != nil){
            thing.impact_on_use = ODictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String}
        else{
            thing.impact_on_use = ""
        }
        
        if(ODictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX") as? String != nil){
            thing.aadt_usage_calc_checkbox = ODictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String}
        else{
            thing.aadt_usage_calc_checkbox = ""
        }
        
        if(ODictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE") as? String != nil){
            thing.aadt_usage = ODictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String}
        else{
            thing.aadt_usage = ""
        }
        
        if(ODictionary.value(forKey:"PRELIMINARY_RATING") as? String != nil){
            thing.prelim_rating = ODictionary.value(forKey: "PRELIMINARY_RATING")! as? String}
        else{
            thing.prelim_rating = ""
        }
        
        //HAZARD RATINGS ALL
        if(ODictionary.value(forKey:"HAZARD_RATING_SLOPE_DRAINAGE") as? String != nil){
            thing.slope_drainage = ODictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String}
        else{
            thing.slope_drainage = ""
        }
        
        if(ODictionary.value(forKey:"HAZARD_RATING_ANNUAL_RAINFALL") as? String != nil){
            thing.hazard_rating_annual_rainfall = ODictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String}
        else{
            thing.hazard_rating_annual_rainfall = ""
        }
        
        if(ODictionary.value(forKey:"HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH") as? String != nil){
            thing.hazard_rating_slope_height_axial_length = ODictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String}
        else{
            thing.hazard_rating_slope_height_axial_length = ""
        }
        
        //RISK RATINGS ALL
        
        if(ODictionary.value(forKey:"RISK_RATING_ROUTE_TRAIL") as? String != nil){
            thing.route_trail_width = ODictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String}
        else{
            thing.route_trail_width = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_HUMAN_EX_FACTOR") as? String != nil){
            thing.human_ex_factor = ODictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String}
        else{
            thing.human_ex_factor = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_PERCENT_DSD") as? String != nil){
            thing.percent_dsd = ODictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String}
        else{
            thing.percent_dsd = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_R_W_IMPACTS") as? String != nil){
            thing.r_w_impacts = ODictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String}
        else{
            thing.r_w_impacts = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_ENVIRO_CULT_IMPACTS") as? String != nil){
            thing.enviro_cult_impacts = ODictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String}
        else{
            thing.enviro_cult_impacts = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_MAINT_COMPLEXITY") as? String != nil){
            thing.maint_complexity = ODictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String}
        else{
            thing.maint_complexity = ""
        }
        
        if(ODictionary.value(forKey:"RISK_RATING_EVENT_COST") as? String != nil){
            thing.event_cost = ODictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String}
        else{
            thing.event_cost = ""
        }
        
        //TOTALS-ALL
        if(ODictionary.value(forKey:"HAZARD_TOTAL") as? String != nil){
            thing.hazard_total = ODictionary.value(forKey: "HAZARD_TOTAL")! as? String}
        else{
            thing.hazard_total = ""
        }
        
        if(ODictionary.value(forKey:"RISK_TOTAL") as? String != nil){
            thing.risk_total = ODictionary.value(forKey: "RISK_TOTAL")! as? String}
        else{
            thing.risk_total = ""
        }
        
        if(ODictionary.value(forKey:"TOTAL_SCORE") as? String != nil){
            thing.total_score = ODictionary.value(forKey: "TOTAL_SCORE")! as? String}
        else{
            thing.total_score = ""
        }
        
        //email??
        
        //prelim and hazard ratings rockfall/landslide ids
        
        if(ODictionary.value(forKey:"HAZARD_TYPE") as? String != nil){
            thing.hazard_type = ODictionary.value(forKey: "HAZARD_TYPE")! as? String}
        else{
            thing.hazard_type = ""
        }
        
        //PRELIM RATING ROCKFALL ONLY
        
        if(ODictionary.value(forKey:"ROCKFALL_PRELIM_DITCH_EFF") as? String != nil){
            thing.prelim_rockfall_ditch_eff = ODictionary.value(forKey: "ROCKFALL_PRELIM_DITCH_EFF")! as? String}
        else{
            thing.prelim_rockfall_ditch_eff = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_PRELIM_ROCKFALL_HISTORY") as? String != nil){
            thing.prelim_rockfall_rockfall_history = ODictionary.value(forKey: "ROCKFALL_PRELIM_ROCKFALL_HISTORY")! as? String}
        else{
            thing.prelim_rockfall_rockfall_history = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL") as? String != nil){
            thing.prelim_rockfall_block_size_event_vol = ODictionary.value(forKey: "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL")! as? String}
        else{
            thing.prelim_rockfall_block_size_event_vol = ""
        }
        
        
        //HAZARD RATING ROCKFALL ONLY
        if(ODictionary.value(forKey:"ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_rockfall_maint_frequency = ODictionary.value(forKey: "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_rockfall_maint_frequency = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION") as? String != nil){
            thing.case_one_struc_cond = ODictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION")! as? String}
        else{
            thing.case_one_struc_cond = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION") as? String != nil){
            thing.case_one_rock_friction = ODictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION")! as? String}
        else{
            thing.case_one_rock_friction = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION") as? String != nil){
            thing.case_two_struc_cond = ODictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION")! as? String}
        else{
            thing.case_two_struc_cond = ""
        }
        
        if(ODictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION") as? String != nil){
            thing.case_two_diff_erosion = ODictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION")! as? String}
        else{
            thing.case_two_diff_erosion = ""
        }
        
        //PRELIM RATING LANDSLIDE ONLY
        if(ODictionary.value(forKey:"LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_road_width_affected = ODictionary.value(forKey: "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_road_width_affected = ""
        }
        
        if(ODictionary.value(forKey:"LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS") as? String != nil){
            thing.prelim_landslide_slide_erosion_effects = ODictionary.value(forKey: "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS")! as? String}
        else{
            thing.prelim_landslide_slide_erosion_effects = ""
        }
        
        if(ODictionary.value(forKey:"LANDSLIDE_PRELIM_LENGTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_length_affected = ODictionary.value(forKey: "LANDSLIDE_PRELIM_LENGTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_length_affected = ""
        }
        
        //HAZARD RATING LANDSLIDE ONLY
        if(ODictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_THAW_STABILITY") as? String != nil){
            thing.hazard_landslide_thaw_stability = ODictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_THAW_STABILITY")! as? String}
        else{
            thing.hazard_landslide_thaw_stability = ""
        }
        
        if(ODictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_landslide_maint_frequency = ODictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_landslide_maint_frequency = ""
        }
        
        if(ODictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY") as? String != nil){
            thing.hazard_landslide_movement_history = ODictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY")! as? String}
        else{
            thing.hazard_landslide_movement_history = ""
        }

        
        //FLMA LINK
        
        if(ODictionary.value(forKey:"FLMA_ID") as? String != nil){
            thing.flma_id = ODictionary.value(forKey: "FLMA_ID")! as? String}
        else{
            thing.flma_id = ""
        }
        
        if(ODictionary.value(forKey:"FLMA_NAME") as? String != nil){
            thing.flma_name = ODictionary.value(forKey: "FLMA_NAME")! as? String}
        else{
            thing.flma_name = ""
        }
        
        if(ODictionary.value(forKey:"FLMA_DESCRIPTION") as? String != nil){
            thing.flma_description = ODictionary.value(forKey: "FLMA_DESCRIPTION")! as? String}
        else{
            thing.flma_description = ""
        }
        
        if(ODictionary.value(forKey:"COMMENT") as? String != nil){
            thing.comments = ODictionary.value(forKey: "COMMENT")! as? String}
        else{
            thing.comments = ""
        }
        
        
        
        
        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedO(comments)
        })
        
    }
    
    
    
    
    
    
}

