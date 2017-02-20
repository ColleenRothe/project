//
//  RockfallModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/7/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/


import Foundation

protocol RockfallModelHelperProtocol: class{
    func itemsDownloadedR (_ items: NSArray)
    
}

    var responseR = ""
    var RDictionary = NSDictionary()

class RockfallModelHelper: NSObject, URLSessionDataDelegate{
    
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
            
            
            responseR = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            
            responseR = responseR.replacingOccurrences(of: "[", with: "")
            responseR = responseR.replacingOccurrences(of: "]", with: "")
            responseR = responseR.replacingOccurrences(of: "{", with: "")
            responseR = responseR.replacingOccurrences(of: "}", with: "")
            var finalString = "{"
            finalString = finalString.appending(responseR)
            
            finalString = finalString.appending("}")
            print("FINAL STRING IS")
            print(finalString)
            
            if let data2 = finalString.data(using: .utf8){
                
                do {
                    RDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("DICTIONARY ERROR")
                    print("error: \(error.localizedDescription)")
                }
            }
            
            self.parseJSON()
            
            
            
        }
        task.resume()

        
        
    }
    
    weak var delegate: RockfallModelHelperProtocol?
    
    func downloadItems(){
        helper()
        
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
    }
    
    func parseJSON(){
        
        let comments : NSMutableArray = NSMutableArray()
        let thing = RockfallModel()//instantiate object to hold each element in the spec. JSON obj.
        
        if(RDictionary.value(forKey:"ID") as? String != nil){
            thing.id = RDictionary.value(forKey: "ID")! as? String}
        else{
            thing.id = ""
        }
        
        if(RDictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = RDictionary.value(forKey: "SITE_ID")! as? String}
        else{
            thing.site_id = ""
        }
        
        if(RDictionary.value(forKey:"MGMT_AREA") as? String != nil){
            thing.mgmt_area = RDictionary.value(forKey: "MGMT_AREA")! as? String}
        else{
            thing.mgmt_area = ""
        }
        
        if(RDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            thing.umbrella_agency = RDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.umbrella_agency = ""
        }
        
        if(RDictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            thing.regiona_admin = RDictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            thing.regiona_admin = ""
        }
        
        if(RDictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            thing.local_admin = RDictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            thing.local_admin = ""
        }
        
        if(RDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            thing.road_trail_no = RDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            thing.road_trail_no = ""
        }
        
        if(RDictionary.value(forKey:"ROAD_TRAIL_CLASS") as? String != nil){
            thing.road_trail_class = RDictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String}
        else{
            thing.road_trail_class = ""
        }
        
        if(RDictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            thing.begin_mile_marker = RDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            thing.begin_mile_marker = ""
        }
        
        if(RDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            thing.end_mile_marker = RDictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            thing.end_mile_marker = ""
        }
        
        if(RDictionary.value(forKey:"ROAD_OR_TRAIL") as? String != nil){
            thing.road_or_trail = RDictionary.value(forKey: "ROAD_OR_TRAIL")! as? String}
        else{
            thing.road_or_trail = ""
        }
        
        if(RDictionary.value(forKey:"SIDE") as? String != nil){
            thing.side = RDictionary.value(forKey: "SIDE")! as? String}
        else{
            thing.side = ""
        }
        
        if(RDictionary.value(forKey:"RATER") as? String != nil){
            thing.rater = RDictionary.value(forKey: "RATER")! as? String}
        else{
            thing.rater = ""
        }
        
        if(RDictionary.value(forKey:"WEATHER") as? String != nil){
            thing.weather = RDictionary.value(forKey: "WEATHER")! as? String}
        else{
            thing.weather = ""
        }
        
        if(RDictionary.value(forKey:"DATE") as? String != nil){
            thing.date = RDictionary.value(forKey: "DATE")! as? String}
        else{
            thing.date = ""
        }
        
        if(RDictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            thing.begin_coordinate_lat = RDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String}
        else{
            thing.begin_coordinate_lat = ""
        }
        
        if(RDictionary.value(forKey:"BEGIN_COORDINATE_LONG") as? String != nil){
            thing.begin_coordinate_long = RDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String}
        else{
            thing.begin_coordinate_long = ""
        }
        
        if(RDictionary.value(forKey:"END_COORDINATE_LAT") as? String != nil){
            thing.end_coordinate_lat = RDictionary.value(forKey: "END_COORDINATE_LAT")! as? String}
        else{
            thing.end_coordinate_lat = ""
        }
        
        if(RDictionary.value(forKey:"END_COORDINATE_LONG") as? String != nil){
            thing.end_coordinate_long = RDictionary.value(forKey: "END_COORDINATE_LONG")! as? String}
        else{
            thing.end_coordinate_long = ""
        }
        
        if(RDictionary.value(forKey:"DATUM") as? String != nil){
            thing.datum = RDictionary.value(forKey: "DATUM")! as? String}
        else{
            thing.datum = ""
        }
        
        if(RDictionary.value(forKey:"AADT") as? String != nil){
            thing.aadt = RDictionary.value(forKey: "AADT")! as? String}
        else{
            thing.aadt = ""
        }
        
        if(RDictionary.value(forKey:"LENGTH_AFFECTED") as? String != nil){
            thing.length_affected = RDictionary.value(forKey: "LENGTH_AFFECTED")! as? String}
        else{
            thing.length_affected = ""
        }
        
        if(RDictionary.value(forKey:"SLOPE_HT_AXIAL_LENGTH") as? String != nil){
            thing.slope_ht_axial_length = RDictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String}
        else{
            thing.slope_ht_axial_length = ""
        }
        
        if(RDictionary.value(forKey:"SLOPE_ANGLE") as? String != nil){
            thing.slope_angle = RDictionary.value(forKey: "SLOPE_ANGLE")! as? String}
        else{
            thing.slope_angle = ""
        }
        
        if(RDictionary.value(forKey:"SIGHT_DISTANCE") as? String != nil){
            thing.sight_distance = RDictionary.value(forKey: "SIGHT_DISTANCE")! as? String}
        else{
            thing.sight_distance = ""
        }
        
        if(RDictionary.value(forKey:"ROAD_TRAIL_WIDTH") as? String != nil){
            thing.road_trail_width = RDictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String}
        else{
            thing.road_trail_width = ""
        }
        
        if(RDictionary.value(forKey:"SPEED_LIMIT") as? String != nil){
            thing.speed_limit = RDictionary.value(forKey: "SPEED_LIMIT")! as? String}
        else{
            thing.speed_limit = ""
        }
        
        if(RDictionary.value(forKey:"MINIMUM_DITCH_WIDTH") as? String != nil){
            thing.minimum_ditch_width = RDictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.minimum_ditch_width = ""
        }
        
        if(RDictionary.value(forKey:"MAXIMUM_DITCH_WIDTH") as? String != nil){
            thing.maximum_ditch_width = RDictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.maximum_ditch_width = ""
        }
        
        if(RDictionary.value(forKey:"MINIMUM_DITCH_DEPTH") as? String != nil){
            thing.minimum_ditch_depth = RDictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.minimum_ditch_depth = ""
        }
        
        if(RDictionary.value(forKey:"MAXIMUM_DITCH_DEPTH") as? String != nil){
            thing.maximum_ditch_depth = RDictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.maximum_ditch_depth = ""
        }
        
        if(RDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.minimum_ditch_slope_first = RDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.minimum_ditch_slope_first = ""
        }
        
        if(RDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.maximum_ditch_slope_first = RDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.maximum_ditch_slope_first = ""
        }
        
        if(RDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.minimum_ditch_slope_second = RDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.minimum_ditch_slope_second = ""
        }
        
        if(RDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.maximum_ditch_slope_second = RDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.maximum_ditch_slope_second = ""
        }
        
        if(RDictionary.value(forKey:"BLK_SIZE") as? String != nil){
            thing.blk_size = RDictionary.value(forKey: "BLK_SIZE")! as? String}
        else{
            thing.blk_size = ""
        }
        
        if(RDictionary.value(forKey:"VOLUME") as? String != nil){
            thing.volume = RDictionary.value(forKey: "VOLUME")! as? String}
        else{
            thing.volume = ""
        }
        
        
        if(RDictionary.value(forKey:"BEGIN_ANNUAL_RAINFALL") as? String != nil){
            thing.begin_annual_rainfall = RDictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String}
        else{
            thing.begin_annual_rainfall = ""
        }
        
        if(RDictionary.value(forKey:"END_ANNUAL_RAINFALL") as? String != nil){
            thing.end_annual_rainfall = RDictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String}
        else{
            thing.end_annual_rainfall = ""
        }
        
        if(RDictionary.value(forKey:"SOLE_ACCESS_ROUTE") as? String != nil){
            thing.sole_access_route = RDictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String}
        else{
            thing.sole_access_route = ""
        }
        
        if(RDictionary.value(forKey:"FIXES_PRESENT") as? String != nil){
            thing.fixes_present = RDictionary.value(forKey: "FIXES_PRESENT")! as? String}
        else{
            thing.fixes_present = ""
        }
        
        //PRELIM RATINGS ALL
        
        if(RDictionary.value(forKey:"PRELIMINARY_RATING_IMPACT_ON_USE") as? String != nil){
            thing.impact_on_use = RDictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String}
        else{
            thing.impact_on_use = ""
        }
        
        if(RDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX") as? String != nil){
            thing.aadt_usage_calc_checkbox = RDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String}
        else{
            thing.aadt_usage_calc_checkbox = ""
        }
        
        if(RDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE") as? String != nil){
            thing.aadt_usage = RDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String}
        else{
            thing.aadt_usage = ""
        }
        
        if(RDictionary.value(forKey:"PRELIMINARY_RATING") as? String != nil){
            thing.prelim_rating = RDictionary.value(forKey: "PRELIMINARY_RATING")! as? String}
        else{
            thing.prelim_rating = ""
        }
        
        //HAZARD RATINGS ALL
        if(RDictionary.value(forKey:"HAZARD_RATING_SLOPE_DRAINAGE") as? String != nil){
            thing.slope_drainage = RDictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String}
        else{
            thing.slope_drainage = ""
        }
        
        if(RDictionary.value(forKey:"HAZARD_RATING_ANNUAL_RAINFALL") as? String != nil){
            thing.hazard_rating_annual_rainfall = RDictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String}
        else{
            thing.hazard_rating_annual_rainfall = ""
        }
        
        if(RDictionary.value(forKey:"HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH") as? String != nil){
            thing.hazard_rating_slope_height_axial_length = RDictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String}
        else{
            thing.hazard_rating_slope_height_axial_length = ""
        }
        
        //RISK RATINGS ALL
        
        if(RDictionary.value(forKey:"RISK_RATING_ROUTE_TRAIL") as? String != nil){
            thing.route_trail_width = RDictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String}
        else{
            thing.route_trail_width = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_HUMAN_EX_FACTOR") as? String != nil){
            thing.human_ex_factor = RDictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String}
        else{
            thing.human_ex_factor = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_PERCENT_DSD") as? String != nil){
            thing.percent_dsd = RDictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String}
        else{
            thing.percent_dsd = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_R_W_IMPACTS") as? String != nil){
            thing.r_w_impacts = RDictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String}
        else{
            thing.r_w_impacts = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_ENVIRO_CULT_IMPACTS") as? String != nil){
            thing.enviro_cult_impacts = RDictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String}
        else{
            thing.enviro_cult_impacts = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_MAINT_COMPLEXITY") as? String != nil){
            thing.maint_complexity = RDictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String}
        else{
            thing.maint_complexity = ""
        }
        
        if(RDictionary.value(forKey:"RISK_RATING_EVENT_COST") as? String != nil){
            thing.event_cost = RDictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String}
        else{
            thing.event_cost = ""
        }
        
        //TOTALS-ALL
        if(RDictionary.value(forKey:"HAZARD_TOTAL") as? String != nil){
            thing.hazard_total = RDictionary.value(forKey: "HAZARD_TOTAL")! as? String}
        else{
            thing.hazard_total = ""
        }
        
        if(RDictionary.value(forKey:"RISK_TOTAL") as? String != nil){
            thing.risk_total = RDictionary.value(forKey: "RISK_TOTAL")! as? String}
        else{
            thing.risk_total = ""
        }
        
        if(RDictionary.value(forKey:"TOTAL_SCORE") as? String != nil){
            thing.total_score = RDictionary.value(forKey: "TOTAL_SCORE")! as? String}
        else{
            thing.total_score = ""
        }
        
        //email??
        
        //prelim and hazard ratings rockfall/landslide ids
        
        if(RDictionary.value(forKey:"HAZARD_TYPE") as? String != nil){
            thing.hazard_type = RDictionary.value(forKey: "HAZARD_TYPE")! as? String}
        else{
            thing.hazard_type = ""
        }
        
        //PRELIM RATING ROCKFALL ONLY
       
        if(RDictionary.value(forKey:"ROCKFALL_PRELIM_DITCH_EFF") as? String != nil){
            thing.prelim_rockfall_ditch_eff = RDictionary.value(forKey: "ROCKFALL_PRELIM_DITCH_EFF")! as? String}
        else{
            thing.prelim_rockfall_ditch_eff = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_PRELIM_ROCKFALL_HISTORY") as? String != nil){
            thing.prelim_rockfall_rockfall_history = RDictionary.value(forKey: "ROCKFALL_PRELIM_ROCKFALL_HISTORY")! as? String}
        else{
            thing.prelim_rockfall_rockfall_history = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL") as? String != nil){
            thing.prelim_rockfall_block_size_event_vol = RDictionary.value(forKey: "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL")! as? String}
        else{
            thing.prelim_rockfall_block_size_event_vol = ""
        }
        
        
        //HAZARD RATING ROCKFALL ONLY
        if(RDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_rockfall_maint_frequency = RDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_rockfall_maint_frequency = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION") as? String != nil){
            thing.case_one_struc_cond = RDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION")! as? String}
        else{
            thing.case_one_struc_cond = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION") as? String != nil){
            thing.case_one_rock_friction = RDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION")! as? String}
        else{
            thing.case_one_rock_friction = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION") as? String != nil){
            thing.case_two_struc_cond = RDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION")! as? String}
        else{
            thing.case_two_struc_cond = ""
        }
        
        if(RDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION") as? String != nil){
            thing.case_two_diff_erosion = RDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION")! as? String}
        else{
            thing.case_two_diff_erosion = ""
        }
        
        //FLMA LINK
        
        if(RDictionary.value(forKey:"FLMA_ID") as? String != nil){
            thing.flma_id = RDictionary.value(forKey: "FLMA_ID")! as? String}
        else{
            thing.flma_id = ""
        }
        
        if(RDictionary.value(forKey:"FLMA_NAME") as? String != nil){
            thing.flma_name = RDictionary.value(forKey: "FLMA_NAME")! as? String}
        else{
            thing.flma_name = ""
        }
        
        if(RDictionary.value(forKey:"FLMA_DESCRIPTION") as? String != nil){
            thing.flma_description = RDictionary.value(forKey: "FLMA_DESCRIPTION")! as? String}
        else{
            thing.flma_description = ""
        }
        
        if(RDictionary.value(forKey:"COMMENT") as? String != nil){
            thing.comments = RDictionary.value(forKey: "COMMENT")! as? String}
        else{
            thing.comments = ""
        }
        
        
        
        
        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedR(comments)
        })
        
    }
    


    
    
    
}

