//
//  FullSiteModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 4/10/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AssetsLibrary

protocol FullSiteModelHelperProtocol: class{
    func itemsDownloadedF (_ items: NSArray)
    
}

var data: NSMutableData = NSMutableData()
var responseF = ""
var FDictionary = NSDictionary()

class FullSiteModelHelper: NSObject, URLSessionDataDelegate{
    
    func helper(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/get_current_site.php")! as URL)
        request.httpMethod = "POST"
        
        //post the id
        let postString = "id=\(shareData.current_site_id)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            
            responseF = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            
            //parse to get rid of the multiple {} blocks
            responseF = responseF.replacingOccurrences(of: "[", with: "")
            responseF = responseF.replacingOccurrences(of: "]", with: "")
            responseF = responseF.replacingOccurrences(of: "{", with: "")
            responseF = responseF.replacingOccurrences(of: "}", with: "")
            var finalString = "{"
            finalString = finalString.appending(responseF)
            
            finalString.append("}")  //WHY MUST YOU NOT WORK??
            responseF = finalString
            
            print("final full site string is")
            print(responseF)
            
            //tru to put into a dictionary
            if let data2 = responseF.data(using: .utf8){
                
                do {
                    FDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("DICTIONARY ERROR FULL SITE MODEL HELPER")
                    print("error: \(error.localizedDescription)")
                }
            }
            
            self.parseJSON()
        }
        task.resume()
        
    }
    
    weak var delegate: FullSiteModelHelperProtocol?
    
    func downloadItems(){
        helper()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
    }
    
    //put dictionary data into an FullSiteModel
    func parseJSON(){
        
        let comments : NSMutableArray = NSMutableArray()
        let thing = FullSiteModel()//instantiate object to hold each element in the spec. JSON obj.
        
        if(FDictionary.value(forKey:"ID") as? String != nil){
            thing.id = FDictionary.value(forKey: "ID")! as? String
        }
            
        else{
            thing.id = ""
        }
        
        if(FDictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = FDictionary.value(forKey: "SITE_ID")! as? String
            
        }else{
            thing.site_id = ""
        }
        
        if(FDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            thing.umbrella_agency = FDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.umbrella_agency = ""
        }
        
        if(FDictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            thing.regiona_admin = FDictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            thing.regiona_admin = ""
        }
        
        if(FDictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            thing.local_admin = FDictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            thing.local_admin = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            thing.road_trail_no = FDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            thing.road_trail_no = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_CLASS") as? String != nil){
            thing.road_trail_class = FDictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String}
        else{
            thing.road_trail_class = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            thing.begin_mile_marker = FDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            thing.begin_mile_marker = ""
        }
        
        if(FDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            thing.end_mile_marker = FDictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            thing.end_mile_marker = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_OR_TRAIL") as? String != nil){
            thing.road_or_trail = FDictionary.value(forKey: "ROAD_OR_TRAIL")! as? String}
        else{
            thing.road_or_trail = ""
        }
        
        if(FDictionary.value(forKey:"SIDE") as? String != nil){
            thing.side = FDictionary.value(forKey: "SIDE")! as? String}
        else{
            thing.side = ""
        }
        
        if(FDictionary.value(forKey:"RATER") as? String != nil){
            thing.rater = FDictionary.value(forKey: "RATER")! as? String}
        else{
            thing.rater = ""
        }
        
        if(FDictionary.value(forKey:"WEATHER") as? String != nil){
            thing.weather = FDictionary.value(forKey: "WEATHER")! as? String}
        else{
            thing.weather = ""
        }
        
        if(FDictionary.value(forKey:"DATE") as? String != nil){
            thing.date = FDictionary.value(forKey: "DATE")! as? String}
        else{
            thing.date = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            thing.begin_coordinate_lat = FDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String}
        else{
            thing.begin_coordinate_lat = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_COORDINATE_LONG") as? String != nil){
            thing.begin_coordinate_long = FDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String}
        else{
            thing.begin_coordinate_long = ""
        }
        
        if(FDictionary.value(forKey:"END_COORDINATE_LAT") as? String != nil){
            thing.end_coordinate_lat = FDictionary.value(forKey: "END_COORDINATE_LAT")! as? String}
        else{
            thing.end_coordinate_lat = ""
        }
        
        if(FDictionary.value(forKey:"END_COORDINATE_LONG") as? String != nil){
            thing.end_coordinate_long = FDictionary.value(forKey: "END_COORDINATE_LONG")! as? String}
        else{
            thing.end_coordinate_long = ""
        }
        
        if(FDictionary.value(forKey:"DATUM") as? String != nil){
            thing.datum = FDictionary.value(forKey: "DATUM")! as? String}
        else{
            thing.datum = ""
        }
        
        if(FDictionary.value(forKey:"AADT") as? String != nil){
            thing.aadt = FDictionary.value(forKey: "AADT")! as? String}
        else{
            thing.aadt = ""
        }
        
        if(FDictionary.value(forKey:"LENGTH_AFFECTED") as? String != nil){
            thing.length_affected = FDictionary.value(forKey: "LENGTH_AFFECTED")! as? String}
        else{
            thing.length_affected = ""
        }
        
        if(FDictionary.value(forKey:"SLOPE_HT_AXIAL_LENGTH") as? String != nil){
            thing.slope_ht_axial_length = FDictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String}
        else{
            thing.slope_ht_axial_length = ""
        }
        
        if(FDictionary.value(forKey:"SLOPE_ANGLE") as? String != nil){
            thing.slope_angle = FDictionary.value(forKey: "SLOPE_ANGLE")! as? String}
        else{
            thing.slope_angle = ""
        }
        
        if(FDictionary.value(forKey:"SIGHT_DISTANCE") as? String != nil){
            thing.sight_distance = FDictionary.value(forKey: "SIGHT_DISTANCE")! as? String}
        else{
            thing.sight_distance = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_WIDTH") as? String != nil){
            thing.road_trail_width = FDictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String}
        else{
            thing.road_trail_width = ""
        }
        
        if(FDictionary.value(forKey:"SPEED_LIMIT") as? String != nil){
            thing.speed_limit = FDictionary.value(forKey: "SPEED_LIMIT")! as? String}
        else{
            thing.speed_limit = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_WIDTH") as? String != nil){
            thing.minimum_ditch_width = FDictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.minimum_ditch_width = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_WIDTH") as? String != nil){
            thing.maximum_ditch_width = FDictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String}
        else{
            thing.maximum_ditch_width = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_DEPTH") as? String != nil){
            thing.minimum_ditch_depth = FDictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.minimum_ditch_depth = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_DEPTH") as? String != nil){
            thing.maximum_ditch_depth = FDictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String}
        else{
            thing.maximum_ditch_depth = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.minimum_ditch_slope_first = FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.minimum_ditch_slope_first = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            thing.maximum_ditch_slope_first = FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            thing.maximum_ditch_slope_first = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.minimum_ditch_slope_second = FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.minimum_ditch_slope_second = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            thing.maximum_ditch_slope_second = FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            thing.maximum_ditch_slope_second = ""
        }
        
        if(FDictionary.value(forKey:"BLK_SIZE") as? String != nil){
            thing.blk_size = FDictionary.value(forKey: "BLK_SIZE")! as? String}
        else{
            thing.blk_size = ""
        }
        
        if(FDictionary.value(forKey:"VOLUME") as? String != nil){
            thing.volume = FDictionary.value(forKey: "VOLUME")! as? String}
        else{
            thing.volume = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_ANNUAL_RAINFALL") as? String != nil){
            thing.begin_annual_rainfall = FDictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String}
        else{
            thing.begin_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"END_ANNUAL_RAINFALL") as? String != nil){
            thing.end_annual_rainfall = FDictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String}
        else{
            thing.end_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"SOLE_ACCESS_ROUTE") as? String != nil){
            thing.sole_access_route = FDictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String}
        else{
            thing.sole_access_route = ""
        }
        
        if(FDictionary.value(forKey:"FIXES_PRESENT") as? String != nil){
            print("NOT NIL")
            thing.fixes_present = FDictionary.value(forKey: "FIXES_PRESENT")! as? String}
        else{
            thing.fixes_present = ""
        }
        
        //PRELIM RATINGS ALL
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_IMPACT_ON_USE") as? String != nil){
            thing.impact_on_use = FDictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String}
        else{
            thing.impact_on_use = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX") as? String != nil){
            thing.aadt_usage_calc_checkbox = FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String}
        else{
            thing.aadt_usage_calc_checkbox = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE") as? String != nil){
            thing.aadt_usage = FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String}
        else{
            thing.aadt_usage = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING") as? String != nil){
            thing.prelim_rating = FDictionary.value(forKey: "PRELIMINARY_RATING")! as? String}
        else{
            thing.prelim_rating = ""
        }
        
        //HAZARD RATINGS ALL
        if(FDictionary.value(forKey:"HAZARD_RATING_SLOPE_DRAINAGE") as? String != nil){
            thing.slope_drainage = FDictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String}
        else{
            thing.slope_drainage = ""
        }
        
        if(FDictionary.value(forKey:"HAZARD_RATING_ANNUAL_RAINFALL") as? String != nil){
            thing.hazard_rating_annual_rainfall = FDictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String}
        else{
            thing.hazard_rating_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH") as? String != nil){
            thing.hazard_rating_slope_height_axial_length = FDictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String}
        else{
            thing.hazard_rating_slope_height_axial_length = ""
        }
        
        //RISK RATINGS ALL
        if(FDictionary.value(forKey:"RISK_RATING_ROUTE_TRAIL") as? String != nil){
            thing.route_trail_width = FDictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String}
        else{
            thing.route_trail_width = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_HUMAN_EX_FACTOR") as? String != nil){
            thing.human_ex_factor = FDictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String}
        else{
            thing.human_ex_factor = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_PERCENT_DSD") as? String != nil){
            thing.percent_dsd = FDictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String}
        else{
            thing.percent_dsd = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_R_W_IMPACTS") as? String != nil){
            thing.r_w_impacts = FDictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String}
        else{
            thing.r_w_impacts = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_ENVIRO_CULT_IMPACTS") as? String != nil){
            thing.enviro_cult_impacts = FDictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String}
        else{
            thing.enviro_cult_impacts = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_MAINT_COMPLEXITY") as? String != nil){
            thing.maint_complexity = FDictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String}
        else{
            thing.maint_complexity = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_EVENT_COST") as? String != nil){
            thing.event_cost = FDictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String}
        else{
            thing.event_cost = ""
        }
        
        //TOTALS-ALL
        if(FDictionary.value(forKey:"HAZARD_TOTAL") as? String != nil){
            thing.hazard_total = FDictionary.value(forKey: "HAZARD_TOTAL")! as? String}
        else{
            thing.hazard_total = ""
        }
        
        if(FDictionary.value(forKey:"RISK_TOTAL") as? String != nil){
            thing.risk_total = FDictionary.value(forKey: "RISK_TOTAL")! as? String}
        else{
            thing.risk_total = ""
        }
        
        if(FDictionary.value(forKey:"TOTAL_SCORE") as? String != nil){
            thing.total_score = FDictionary.value(forKey: "TOTAL_SCORE")! as? String}
        else{
            thing.total_score = ""
        }
        
        //email??
        
        //prelim and hazard ratings rockfall/landslide ids
        
        if(FDictionary.value(forKey:"HAZARD_TYPE2") as? String != nil){
            thing.hazard_type = FDictionary.value(forKey: "HAZARD_TYPE2")! as? String}
        else{
            thing.hazard_type = ""
        }
                
        //PRELIM RATING ROCKFALL ONLY
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_DITCH_EFF") as? String != nil){
            thing.prelim_rockfall_ditch_eff = FDictionary.value(forKey: "ROCKFALL_PRELIM_DITCH_EFF")! as? String}
        else{
            thing.prelim_rockfall_ditch_eff = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_ROCKFALL_HISTORY") as? String != nil){
            thing.prelim_rockfall_rockfall_history = FDictionary.value(forKey: "ROCKFALL_PRELIM_ROCKFALL_HISTORY")! as? String}
        else{
            thing.prelim_rockfall_rockfall_history = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL") as? String != nil){
            thing.prelim_rockfall_block_size_event_vol = FDictionary.value(forKey: "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL")! as? String}
        else{
            thing.prelim_rockfall_block_size_event_vol = ""
        }
        
        //HAZARD RATING ROCKFALL ONLY
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_rockfall_maint_frequency = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_rockfall_maint_frequency = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION") as? String != nil){
            thing.case_one_struc_cond = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION")! as? String}
        else{
            thing.case_one_struc_cond = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION") as? String != nil){
            thing.case_one_rock_friction = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION")! as? String}
        else{
            thing.case_one_rock_friction = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION") as? String != nil){
            thing.case_two_struc_cond = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION")! as? String}
        else{
            thing.case_two_struc_cond = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION") as? String != nil){
            thing.case_two_diff_erosion = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION")! as? String}
        else{
            thing.case_two_diff_erosion = ""
        }
        
        //PRELIM RATING LANDSLIDE ONLY
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_road_width_affected = FDictionary.value(forKey: "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_road_width_affected = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS") as? String != nil){
            thing.prelim_landslide_slide_erosion_effects = FDictionary.value(forKey: "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS")! as? String}
        else{
            thing.prelim_landslide_slide_erosion_effects = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_LENGTH_AFFECTED") as? String != nil){
            thing.prelim_landslide_length_affected = FDictionary.value(forKey: "LANDSLIDE_PRELIM_LENGTH_AFFECTED")! as? String}
        else{
            thing.prelim_landslide_length_affected = ""
        }
        
        //HAZARD RATING LANDSLIDE ONLY
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_THAW_STABILITY") as? String != nil){
            thing.hazard_landslide_thaw_stability = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_THAW_STABILITY")! as? String}
        else{
            thing.hazard_landslide_thaw_stability = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            thing.hazard_landslide_maint_frequency = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            thing.hazard_landslide_maint_frequency = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY") as? String != nil){
            thing.hazard_landslide_movement_history = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY")! as? String}
        else{
            thing.hazard_landslide_movement_history = ""
        }
        
        
        //FLMA LINK (spelled wrong - FMLA in DB)
        if(FDictionary.value(forKey:"FLMA_ID") as? String != nil){
            thing.flma_id = FDictionary.value(forKey: "FLMA_ID")! as? String}
        else{
            thing.flma_id = ""
        }
        
        if(FDictionary.value(forKey:"FLMA_NAME") as? String != nil){
            thing.flma_name = FDictionary.value(forKey: "FLMA_NAME")! as? String}
        else{
            thing.flma_name = ""
        }
        
        
        if(FDictionary.value(forKey:"FLMA_DESCRIPTION") as? String != nil){
            thing.flma_description = FDictionary.value(forKey: "FLMA_DESCRIPTION")! as? String}
        else{
            thing.flma_description = ""
        }
        
        if(FDictionary.value(forKey:"COMMENT") as? String != nil){
            thing.comments = FDictionary.value(forKey: "COMMENT")! as? String}
        else{
            thing.comments = ""
        }
        
        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
            
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedF(comments)
        })
    }
}
