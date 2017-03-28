//
//  LandslideModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/2/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

protocol LandslideModelHelperProtocol: class{
    func itemsDownloadedL (_ items: NSArray)
}

//let shareDatas = ShareData.sharedInstance
var response = ""
var JDictionary = NSDictionary()

class LandslideModelHelper: NSObject, URLSessionDataDelegate{
    
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
            
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            responseString = responseString.replacingOccurrences(of: "[", with: "")
            responseString = responseString.replacingOccurrences(of: "]", with: "")
            responseString = responseString.replacingOccurrences(of: "{", with: "")
            responseString = responseString.replacingOccurrences(of: "}", with: "")
            var finalString = "{"
            finalString = finalString.appending(responseString)
            
            finalString = finalString.appending("}")
            print("FINAL STRING IS")
            print(finalString)

            
            if let data2 = finalString.data(using: .utf8){
                
                do {
                    JDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("DICTIONARY ERROR")
                    print("error: \(error.localizedDescription)")
                }
            }

            self.parseJSON()
            
            
            
        }
        task.resume()
        

    }
    weak var delegate: LandslideModelHelperProtocol?
    
    func downloadItems(){
        print("landslide helper")
        helper()
        
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
    }
    
    func parseJSON(){
        
        let comments : NSMutableArray = NSMutableArray()
        let thing = LandslideModel()//instantiate object to hold each element in the spec. JSON obj.
        
        if(JDictionary.value(forKey:"ID") as? String != nil){
            thing.id = JDictionary.value(forKey: "ID")! as? String}
        else{
            thing.id = ""
        }
        
        if(JDictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = JDictionary.value(forKey: "SITE_ID")! as? String}
        else{
            thing.site_id = ""
        }
        
        if(JDictionary.value(forKey:"MGMT_AREA") as? String != nil){
            thing.mgmt_area = JDictionary.value(forKey: "MGMT_AREA")! as? String}
        else{
            thing.mgmt_area = ""
        }
        
        if(JDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            thing.umbrella_agency = JDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.umbrella_agency = ""
        }
        
        if(JDictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            thing.regiona_admin = JDictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            thing.regiona_admin = ""
        }
        
        if(JDictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            thing.local_admin = JDictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            thing.local_admin = ""
        }
        
        if(JDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            thing.road_trail_no = JDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            thing.road_trail_no = ""
        }
        
        if(JDictionary.value(forKey:"ROAD_TRAIL_CLASS") as? String != nil){
            thing.road_trail_class = JDictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String}
        else{
            thing.road_trail_class = ""
        }
        
        if(JDictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            thing.begin_mile_marker = JDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            thing.begin_mile_marker = ""
        }
        
        if(JDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            thing.end_mile_marker = JDictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            thing.end_mile_marker = ""
        }
        
        if(JDictionary.value(forKey:"ROAD_OR_TRAIL") as? String != nil){
            thing.road_or_trail = JDictionary.value(forKey: "ROAD_OR_TRAIL")! as? String}
        else{
            thing.road_or_trail = ""
        }
        
        if(JDictionary.value(forKey:"SIDE") as? String != nil){
            thing.side = JDictionary.value(forKey: "SIDE")! as? String}
        else{
            thing.side = ""
        }
        
        if(JDictionary.value(forKey:"RATER") as? String != nil){
            thing.rater = JDictionary.value(forKey: "RATER")! as? String}
        else{
            thing.rater = ""
        }
        
        if(JDictionary.value(forKey:"WEATHER") as? String != nil){
            thing.weather = JDictionary.value(forKey: "WEATHER")! as? String}
        else{
            thing.weather = ""
        }
        
        if(JDictionary.value(forKey:"DATE") as? String != nil){
            thing.date = JDictionary.value(forKey: "DATE")! as? String}
        else{
            thing.date = ""
        }
        
        if(JDictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            thing.begin_coordinate_lat = JDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String}
        else{
            thing.begin_coordinate_lat = ""
        }
        
        if(JDictionary.value(forKey:"BEGIN_COORDINATE_LONG") as? String != nil){
            thing.begin_coordinate_long = JDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String}
        else{
            thing.begin_coordinate_long = ""
        }
        
        if(JDictionary.value(forKey:"END_COORDINATE_LAT") as? String != nil){
            thing.end_coordinate_lat = JDictionary.value(forKey: "END_COORDINATE_LAT")! as? String}
        else{
            thing.end_coordinate_lat = ""
        }
        
        if(JDictionary.value(forKey:"END_COORDINATE_LONG") as? String != nil){
            thing.end_coordinate_long = JDictionary.value(forKey: "END_COORDINATE_LONG")! as? String}
        else{
            thing.end_coordinate_long = ""
        }
        
        if(JDictionary.value(forKey:"DATUM") as? String != nil){
            thing.datum = JDictionary.value(forKey: "DATUM")! as? String}
        else{
            thing.datum = ""
        }
        
        if(JDictionary.value(forKey:"AADT") as? String != nil){
            thing.aadt = JDictionary.value(forKey: "AADT")! as? String}
        else{
            thing.aadt = ""
        }
        
        if(JDictionary.value(forKey:"LENGTH_AFFECTED") as? String != nil){
            thing.length_affected = JDictionary.value(forKey: "LENGTH_AFFECTED")! as? String}
        else{
            thing.length_affected = ""
        }
        
        if(JDictionary.value(forKey:"SLOPE_HT_AXIAL_LENGTH") as? String != nil){
            thing.slope_ht_axial_length = JDictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String}
        else{
            thing.slope_ht_axial_length = ""
        }
        
        if(JDictionary.value(forKey:"SLOPE_ANGLE") as? String != nil){
            thing.slope_angle = JDictionary.value(forKey: "SLOPE_ANGLE")! as? String}
        else{
            thing.slope_angle = ""
        }
        
        if(JDictionary.value(forKey:"SIGHT_DISTANCE") as? String != nil){
            thing.sight_distance = JDictionary.value(forKey: "SIGHT_DISTANCE")! as? String}
        else{
            thing.sight_distance = ""
        }
        
        if(JDictionary.value(forKey:"ROAD_TRAIL_WIDTH") as? String != nil){
            thing.road_trail_width = JDictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String}
        else{
            thing.road_trail_width = ""
        }
        
        if(JDictionary.value(forKey:"SPEED_LIMIT") as? String != nil){
            thing.speed_limit = JDictionary.value(forKey: "SPEED_LIMIT")! as? String}
        else{
            thing.speed_limit = ""
        }
        
        if(JDictionary.value(forKey:"MINIMUM_DITCH_WIDTH") as? String != nil){
            thing.minimum_ditch_width = JDictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.minimum_ditch_width = ""
        }
        
        if(JDictionary.value(forKey:"MAXIMUM_DITCH_WIDTH") as? String != nil){
            thing.maximum_ditch_width = JDictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.maximum_ditch_width = ""
        }
        
        if(JDictionary.value(forKey:"MINIMUM_DITCH_DEPTH") as? String != nil){
            thing.minimum_ditch_depth = JDictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.minimum_ditch_depth = ""
        }
        
        if(JDictionary.value(forKey:"MAXIMUM_DITCH_DEPTH") as? String != nil){
            thing.maximum_ditch_depth = JDictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.maximum_ditch_depth = ""
        }
        
        if(JDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.minimum_ditch_slope_first = JDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.minimum_ditch_slope_first = ""
        }
        
        if(JDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.maximum_ditch_slope_first = JDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.maximum_ditch_slope_first = ""
        }
        
        if(JDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.minimum_ditch_slope_second = JDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.minimum_ditch_slope_second = ""
        }
        
        if(JDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.maximum_ditch_slope_second = JDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.maximum_ditch_slope_second = ""
        }
        
        //BLK SIZE
        //VOLUME
        
        if(JDictionary.value(forKey:"BEGIN_ANNUAL_RAINFALL") as? String != nil){
            thing.begin_annual_rainfall = JDictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String}
        else{
            thing.begin_annual_rainfall = ""
        }
        
        if(JDictionary.value(forKey:"END_ANNUAL_RAINFALL") as? String != nil){
            thing.end_annual_rainfall = JDictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String}
        else{
            thing.end_annual_rainfall = ""
        }
        
        if(JDictionary.value(forKey:"SOLE_ACCESS_ROUTE") as? String != nil){
            thing.sole_access_route = JDictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String}
        else{
            thing.sole_access_route = ""
        }
        
        if(JDictionary.value(forKey:"FIXES_PRESENT") as? String != nil){
            thing.fixes_present = JDictionary.value(forKey: "FIXES_PRESENT")! as? String}
        else{
            thing.fixes_present = ""
        }
        
        //PRELIM RATINGS ALL
        
        if(JDictionary.value(forKey:"PRELIMINARY_RATING_IMPACT_ON_USE") as? String != nil){
            thing.impact_on_use = JDictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String}
        else{
            thing.impact_on_use = ""
        }
        
        if(JDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX") as? String != nil){
            thing.aadt_usage_calc_checkbox = JDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String}
        else{
            thing.aadt_usage_calc_checkbox = ""
        }
        
        if(JDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE") as? String != nil){
            thing.aadt_usage = JDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String}
        else{
            thing.aadt_usage = ""
        }
        
        if(JDictionary.value(forKey:"PRELIMINARY_RATING") as? String != nil){
            thing.prelim_rating = JDictionary.value(forKey: "PRELIMINARY_RATING")! as? String}
        else{
            thing.prelim_rating = ""
        }
        
        //HAZARD RATINGS ALL
        if(JDictionary.value(forKey:"HAZARD_RATING_SLOPE_DRAINAGE") as? String != nil){
            thing.slope_drainage = JDictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String}
        else{
            thing.slope_drainage = ""
        }
        
        if(JDictionary.value(forKey:"HAZARD_RATING_ANNUAL_RAINFALL") as? String != nil){
            thing.hazard_rating_annual_rainfall = JDictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String}
        else{
            thing.hazard_rating_annual_rainfall = ""
        }
        
        if(JDictionary.value(forKey:"HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH") as? String != nil){
            thing.hazard_rating_slope_height_axial_length = JDictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String}
        else{
            thing.hazard_rating_slope_height_axial_length = ""
        }
        
        //RISK RATINGS ALL
        
        if(JDictionary.value(forKey:"RISK_RATING_ROUTE_TRAIL") as? String != nil){
            thing.route_trail_width = JDictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String}
        else{
            thing.route_trail_width = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_HUMAN_EX_FACTOR") as? String != nil){
            thing.human_ex_factor = JDictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String}
        else{
            thing.human_ex_factor = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_PERCENT_DSD") as? String != nil){
            thing.percent_dsd = JDictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String}
        else{
            thing.percent_dsd = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_R_W_IMPACTS") as? String != nil){
            thing.r_w_impacts = JDictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String}
        else{
            thing.r_w_impacts = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_ENVIRO_CULT_IMPACTS") as? String != nil){
            thing.enviro_cult_impacts = JDictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String}
        else{
            thing.enviro_cult_impacts = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_MAINT_COMPLEXITY") as? String != nil){
            thing.maint_complexity = JDictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String}
        else{
            thing.maint_complexity = ""
        }
        
        if(JDictionary.value(forKey:"RISK_RATING_EVENT_COST") as? String != nil){
            thing.event_cost = JDictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String}
        else{
            thing.event_cost = ""
        }
        
        //TOTALS-ALL
        if(JDictionary.value(forKey:"HAZARD_TOTAL") as? String != nil){
            thing.hazard_total = JDictionary.value(forKey: "HAZARD_TOTAL")! as? String}
        else{
            thing.hazard_total = ""
        }
        
        if(JDictionary.value(forKey:"RISK_TOTAL") as? String != nil){
            thing.risk_total = JDictionary.value(forKey: "RISK_TOTAL")! as? String}
        else{
            thing.risk_total = ""
        }
        
        if(JDictionary.value(forKey:"TOTAL_SCORE") as? String != nil){
            thing.total_score = JDictionary.value(forKey: "TOTAL_SCORE")! as? String}
        else{
            thing.total_score = ""
        }
        
        //email??
        
        //prelim and hazard ratings rockfall/landslide ids
        
        if(JDictionary.value(forKey:"HAZARD_TYPE") as? String != nil){
            thing.hazard_type = JDictionary.value(forKey: "HAZARD_TYPE")! as? String}
        else{
            thing.hazard_type = ""
        }
        
        //PRELIM RATING LANDSLIDE ONLY
        if(JDictionary.value(forKey:"LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_road_width_affected = JDictionary.value(forKey: "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_road_width_affected = ""
        }
        
        if(JDictionary.value(forKey:"LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS") as? String != nil){
            thing.prelim_landslide_slide_erosion_effects = JDictionary.value(forKey: "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS")! as? String}
        else{
            thing.prelim_landslide_slide_erosion_effects = ""
        }
        
        if(JDictionary.value(forKey:"LANDSLIDE_PRELIM_LENGTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_length_affected = JDictionary.value(forKey: "LANDSLIDE_PRELIM_LENGTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_length_affected = ""
        }
        
        //HAZARD RATING LANDSLIDE ONLY
        if(JDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_THAW_STABILITY") as? String != nil){
            thing.hazard_landslide_thaw_stability = JDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_THAW_STABILITY")! as? String}
        else{
            thing.hazard_landslide_thaw_stability = ""
        }
        
        if(JDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_landslide_maint_frequency = JDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_landslide_maint_frequency = ""
        }
        
        if(JDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY") as? String != nil){
            thing.hazard_landslide_movement_history = JDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY")! as? String}
        else{
            thing.hazard_landslide_movement_history = ""
        }
        
        //FLMA LINK
        
        if(JDictionary.value(forKey:"FLMA_ID") as? String != nil){
            thing.flma_id = JDictionary.value(forKey: "FLMA_ID")! as? String}
        else{
            thing.flma_id = ""
        }
        
        if(JDictionary.value(forKey:"FLMA_NAME") as? String != nil){
            thing.flma_name = JDictionary.value(forKey: "FLMA_NAME")! as? String}
        else{
            thing.flma_name = ""
        }
        
        if(JDictionary.value(forKey:"FLMA_DESCRIPTION") as? String != nil){
            thing.flma_description = JDictionary.value(forKey: "FLMA_DESCRIPTION")! as? String}
        else{
            thing.flma_description = ""
        }
        
        if(JDictionary.value(forKey:"COMMENT") as? String != nil){
            thing.comments = JDictionary.value(forKey: "COMMENT")! as? String}
        else{
            thing.comments = ""
        }
        
        

        
         comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedL(comments)
        })
        
    }
    
    
    
    
}
