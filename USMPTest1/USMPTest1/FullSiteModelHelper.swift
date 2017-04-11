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

var responseF = ""
var FDictionary = NSDictionary()

class FullSiteModelHelper: NSObject, URLSessionDataDelegate{
    
    func helper(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/getLandslide.php")! as URL)
        request.httpMethod = "POST"
        
        //post the id
        let postString = "id=\(shareData.current_clicked_id)"
        
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
            
            finalString = finalString.appending("}")
            
            //tru to put into a dictionary
            if let data2 = finalString.data(using: .utf8){
                
                do {
                    FDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("DICTIONARY ERROR")
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
    
    //put dictionary data into an OfflineModel
    func parseJSON(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "OfflineSiteFull", in:managedContext)
        let site = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let comments : NSMutableArray = NSMutableArray()
        let thing = OfflineModel()//instantiate object to hold each element in the spec. JSON obj.
        
        if(FDictionary.value(forKey:"ID") as? String != nil){
            thing.id = FDictionary.value(forKey: "ID")! as? String
            site.setValue(FDictionary.value(forKey: "ID")! as? String, forKey: "id")
        }
            
        else{
            site.setValue("", forKey: "id")
            thing.id = ""
        }
        
        if(FDictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = FDictionary.value(forKey: "SITE_ID")! as? String
            site.setValue(FDictionary.value(forKey: "SITE_ID")! as? String, forKey: "site_id")}
            
        else{
            thing.site_id = ""
            site.setValue("", forKey: "site_id")
        }
        
        if(FDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String, forKey: "umbrella_agency")
            thing.umbrella_agency = FDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.umbrella_agency = ""
            site.setValue("", forKey: "umbrella_agency")
        }
        
        if(FDictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            site.setValue(FDictionary.value(forKey: "REGIONAL_ADMIN")! as? String, forKey: "regional_admin")
            thing.regiona_admin = FDictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            site.setValue("", forKey: "regional_admin")
            thing.regiona_admin = ""
        }
        
        if(FDictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LOCAL_ADMIN")! as? String, forKey: "local_admin")
            thing.local_admin = FDictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            site.setValue("", forKey: "local_admin")
            thing.local_admin = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String, forKey: "road_trail_no")
            
            thing.road_trail_no = FDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            site.setValue("", forKey: "road_trail_no")
            thing.road_trail_no = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_CLASS") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String, forKey: "road_trail_class")
            thing.road_trail_class = FDictionary.value(forKey: "ROAD_TRAIL_CLASS")! as? String}
        else{
            site.setValue("", forKey: "road_trail_class")
            thing.road_trail_class = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            site.setValue(FDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String, forKey: "begin_mile_marker")
            thing.begin_mile_marker = FDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            site.setValue("", forKey: "begin_mile_marker")
            thing.begin_mile_marker = ""
        }
        
        if(FDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            site.setValue(FDictionary.value(forKey: "END_MILE_MARKER")! as? String, forKey: "end_mile_marker")
            thing.end_mile_marker = FDictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            site.setValue("", forKey: "end_mile_marker")
            thing.end_mile_marker = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_OR_TRAIL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROAD_OR_TRAIL")! as? String, forKey: "road_or_trail")
            thing.road_or_trail = FDictionary.value(forKey: "ROAD_OR_TRAIL")! as? String}
        else{
            site.setValue("", forKey: "road_or_trail")
            thing.road_or_trail = ""
        }
        
        if(FDictionary.value(forKey:"SIDE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SIDE")! as? String, forKey: "side")
            thing.side = FDictionary.value(forKey: "SIDE")! as? String}
        else{
            site.setValue("", forKey: "side")
            thing.side = ""
        }
        
        if(FDictionary.value(forKey:"RATER") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RATER")! as? String, forKey: "rater")
            thing.rater = FDictionary.value(forKey: "RATER")! as? String}
        else{
            site.setValue("", forKey: "rater")
            thing.rater = ""
        }
        
        if(FDictionary.value(forKey:"WEATHER") as? String != nil){
            site.setValue(FDictionary.value(forKey: "WEATHER")! as? String, forKey: "weather")
            thing.weather = FDictionary.value(forKey: "WEATHER")! as? String}
        else{
            site.setValue(FDictionary.value(forKey: "WEATHER")! as? String, forKey: "weather")
            thing.weather = ""
        }
        
        if(FDictionary.value(forKey:"DATE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "DATE")! as? String, forKey: "date")
            thing.date = FDictionary.value(forKey: "DATE")! as? String}
        else{
            site.setValue("", forKey: "date")
            thing.date = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String, forKey: "begin_coordinate_lat")
            thing.begin_coordinate_lat = FDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String}
        else{
            site.setValue("", forKey: "begin_coordinate_lat")
            thing.begin_coordinate_lat = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_COORDINATE_LONG") as? String != nil){
            site.setValue(FDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String, forKey: "begin_coordinate_long")
            thing.begin_coordinate_long = FDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String}
        else{
            site.setValue("", forKey: "begin_coordinate_long")
            thing.begin_coordinate_long = ""
        }
        
        if(FDictionary.value(forKey:"END_COORDINATE_LAT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "END_COORDINATE_LAT")! as? String, forKey: "end_coordinate_lat")
            thing.end_coordinate_lat = FDictionary.value(forKey: "END_COORDINATE_LAT")! as? String}
        else{
            site.setValue(FDictionary.value(forKey: "END_COORDINATE_LAT")! as? String, forKey: "end_coordinate_lat")
            thing.end_coordinate_lat = ""
        }
        
        if(FDictionary.value(forKey:"END_COORDINATE_LONG") as? String != nil){
            site.setValue(FDictionary.value(forKey: "END_COORDINATE_LONG")! as? String, forKey: "end_coordinate_long")
            thing.end_coordinate_long = FDictionary.value(forKey: "END_COORDINATE_LONG")! as? String}
        else{
            site.setValue("", forKey: "end_coordinate_long")
            thing.end_coordinate_long = ""
        }
        
        if(FDictionary.value(forKey:"DATUM") as? String != nil){
            site.setValue(FDictionary.value(forKey: "DATUM")! as? String, forKey: "datum")
            thing.datum = FDictionary.value(forKey: "DATUM")! as? String}
        else{
            site.setValue("", forKey: "datum")
            thing.datum = ""
        }
        
        if(FDictionary.value(forKey:"AADT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "AADT")! as? String, forKey: "aadt")
            thing.aadt = FDictionary.value(forKey: "AADT")! as? String}
        else{
            site.setValue("", forKey: "aadt")
            thing.aadt = ""
        }
        
        if(FDictionary.value(forKey:"LENGTH_AFFECTED") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LENGTH_AFFECTED")! as? String, forKey: "length_affected")
            thing.length_affected = FDictionary.value(forKey: "LENGTH_AFFECTED")! as? String}
        else{
            site.setValue("", forKey: "length_affected")
            thing.length_affected = ""
        }
        
        if(FDictionary.value(forKey:"SLOPE_HT_AXIAL_LENGTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String, forKey: "slope_ht_axial_length")
            thing.slope_ht_axial_length = FDictionary.value(forKey: "SLOPE_HT_AXIAL_LENGTH")! as? String}
        else{
            site.setValue("", forKey: "slope_ht_axial_length")
            thing.slope_ht_axial_length = ""
        }
        
        if(FDictionary.value(forKey:"SLOPE_ANGLE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SLOPE_ANGLE")! as? String, forKey: "slope_angle")
            thing.slope_angle = FDictionary.value(forKey: "SLOPE_ANGLE")! as? String}
        else{
            site.setValue("", forKey: "slope_angle")
            thing.slope_angle = ""
        }
        
        if(FDictionary.value(forKey:"SIGHT_DISTANCE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SIGHT_DISTANCE")! as? String, forKey: "sight_distance")
            thing.sight_distance = FDictionary.value(forKey: "SIGHT_DISTANCE")! as? String}
        else{
            site.setValue("", forKey: "sight_distance")
            thing.sight_distance = ""
        }
        
        if(FDictionary.value(forKey:"ROAD_TRAIL_WIDTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String, forKey: "road_trail_width")
            thing.road_trail_width = FDictionary.value(forKey: "ROAD_TRAIL_WIDTH")! as? String}
        else{
            site.setValue("", forKey: "road_trail_width")
            thing.road_trail_width = ""
        }
        
        if(FDictionary.value(forKey:"SPEED_LIMIT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SPEED_LIMIT")! as? String, forKey: "speed_limit")
            thing.speed_limit = FDictionary.value(forKey: "SPEED_LIMIT")! as? String}
        else{
            site.setValue("", forKey: "speed_limit")
            thing.speed_limit = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_WIDTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String, forKey: "minimum_ditch_width")
            thing.minimum_ditch_width = FDictionary.value(forKey: "MINIMUM_DITCH_WIDTH")! as? String}
        else{
            site.setValue("", forKey: "minimum_ditch_width")
            thing.minimum_ditch_width = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_WIDTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String, forKey: "maximum_ditch_width")
            thing.maximum_ditch_width = FDictionary.value(forKey: "MAXIMUM_DITCH_WIDTH")! as? String}
        else{
            site.setValue("", forKey: "maximum_ditch_width")
            thing.maximum_ditch_width = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_DEPTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String, forKey: "minimum_ditch_depth")
            thing.minimum_ditch_depth = FDictionary.value(forKey: "MINIMUM_DITCH_DEPTH")! as? String}
        else{
            site.setValue("", forKey: "minimum_ditch_depth")
            thing.minimum_ditch_depth = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_DEPTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String, forKey: "maximum_ditch_depth")
            thing.maximum_ditch_depth = FDictionary.value(forKey: "MAXIMUM_DITCH_DEPTH")! as? String}
        else{
            site.setValue("", forKey: "maximum_ditch_depth")
            thing.maximum_ditch_depth = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String, forKey: "minimum_ditch_slope_first")
            thing.minimum_ditch_slope_first = FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            site.setValue("", forKey: "minimum_ditch_slope_first")
            thing.minimum_ditch_slope_first = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_FIRST") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String, forKey: "maximum_ditch_slope_first")
            thing.maximum_ditch_slope_first = FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_FIRST")! as? String}
        else{
            site.setValue("", forKey: "maximum_ditch_slope_first")
            thing.maximum_ditch_slope_first = ""
        }
        
        if(FDictionary.value(forKey:"MINIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String, forKey: "minimum_ditch_slope_second")
            thing.minimum_ditch_slope_second = FDictionary.value(forKey: "MINIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            site.setValue("", forKey: "minimum_ditch_slope_second")
            thing.minimum_ditch_slope_second = ""
        }
        
        if(FDictionary.value(forKey:"MAXIMUM_DITCH_SLOPE_SECOND") as? String != nil){
            site.setValue(FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String, forKey: "maximum_ditch_slope_second")
            thing.maximum_ditch_slope_second = FDictionary.value(forKey: "MAXIMUM_DITCH_SLOPE_SECOND")! as? String}
        else{
            site.setValue("", forKey: "maximum_ditch_slope_second")
            thing.maximum_ditch_slope_second = ""
        }
        
        if(FDictionary.value(forKey:"BLK_SIZE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "BLK_SIZE")! as? String, forKey: "blk_size")
            thing.blk_size = FDictionary.value(forKey: "BLK_SIZE")! as? String}
        else{
            site.setValue("", forKey: "blk_size")
            thing.blk_size = ""
        }
        
        if(FDictionary.value(forKey:"VOLUME") as? String != nil){
            site.setValue(FDictionary.value(forKey: "VOLUME")! as? String, forKey: "volume")
            thing.volume = FDictionary.value(forKey: "VOLUME")! as? String}
        else{
            site.setValue("", forKey: "volume")
            thing.volume = ""
        }
        
        if(FDictionary.value(forKey:"BEGIN_ANNUAL_RAINFALL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String, forKey: "begin_annual_rainfall")
            thing.begin_annual_rainfall = FDictionary.value(forKey: "BEGIN_ANNUAL_RAINFALL")! as? String}
        else{
            site.setValue("", forKey: "begin_annual_rainfall")
            thing.begin_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"END_ANNUAL_RAINFALL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String, forKey: "end_annual_rainfall")
            thing.end_annual_rainfall = FDictionary.value(forKey: "END_ANNUAL_RAINFALL")! as? String}
        else{
            site.setValue("", forKey: "end_annual_rainfall")
            thing.end_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"SOLE_ACCESS_ROUTE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String, forKey: "sole_access_route")
            thing.sole_access_route = FDictionary.value(forKey: "SOLE_ACCESS_ROUTE")! as? String}
        else{
            site.setValue("", forKey: "sole_access_route")
            thing.sole_access_route = ""
        }
        
        if(FDictionary.value(forKey:"FIXES_PRESENT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "FIXES_PRESENT")! as? String, forKey: "fixes_present")
            thing.fixes_present = FDictionary.value(forKey: "FIXES_PRESENT")! as? String}
        else{
            site.setValue("", forKey: "fixes_present")
            thing.fixes_present = ""
        }
        
        //PRELIM RATINGS ALL
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_IMPACT_ON_USE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String, forKey: "preliminary_rating_impact_on_use")
            thing.impact_on_use = FDictionary.value(forKey: "PRELIMINARY_RATING_IMPACT_ON_USE")! as? String}
        else{
            site.setValue("", forKey: "preliminary_rating_impact_on_use")
            thing.impact_on_use = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX") as? String != nil){
            site.setValue(FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String, forKey: "preliminary_rating_aadt_usage_calc_checkbox")
            thing.aadt_usage_calc_checkbox = FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX")! as? String}
        else{
            site.setValue("", forKey: "preliminary_rating_aadt_usage_calc_checkbox")
            thing.aadt_usage_calc_checkbox = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING_AADT_USAGE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String, forKey: "preliminary_rating_aadt_usage")
            thing.aadt_usage = FDictionary.value(forKey: "PRELIMINARY_RATING_AADT_USAGE")! as? String}
        else{
            site.setValue("", forKey: "preliminary_rating_aadt_usage")
            thing.aadt_usage = ""
        }
        
        if(FDictionary.value(forKey:"PRELIMINARY_RATING") as? String != nil){
            site.setValue(FDictionary.value(forKey: "PRELIMINARY_RATING")! as? String, forKey: "preliminary_rating")
            thing.prelim_rating = FDictionary.value(forKey: "PRELIMINARY_RATING")! as? String}
        else{
            site.setValue("", forKey: "preliminary_rating")
            thing.prelim_rating = ""
        }
        
        //HAZARD RATINGS ALL
        if(FDictionary.value(forKey:"HAZARD_RATING_SLOPE_DRAINAGE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String, forKey: "hazard_rating_slope_drainage")
            thing.slope_drainage = FDictionary.value(forKey: "HAZARD_RATING_SLOPE_DRAINAGE")! as? String}
        else{
            site.setValue("", forKey: "hazard_rating_slope_drainage")
            thing.slope_drainage = ""
        }
        
        if(FDictionary.value(forKey:"HAZARD_RATING_ANNUAL_RAINFALL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String, forKey: "hazard_rating_annual_rainfall")
            thing.hazard_rating_annual_rainfall = FDictionary.value(forKey: "HAZARD_RATING_ANNUAL_RAINFALL")! as? String}
        else{
            site.setValue("", forKey: "hazard_rating_annual_rainfall")
            thing.hazard_rating_annual_rainfall = ""
        }
        
        if(FDictionary.value(forKey:"HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH") as? String != nil){
            site.setValue(FDictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String, forKey: "hazard_rating_slope_height_axial_length")
            thing.hazard_rating_slope_height_axial_length = FDictionary.value(forKey: "HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH")! as? String}
        else{
            site.setValue("", forKey: "hazard_rating_slope_height_axial_length")
            thing.hazard_rating_slope_height_axial_length = ""
        }
        
        //RISK RATINGS ALL
        if(FDictionary.value(forKey:"RISK_RATING_ROUTE_TRAIL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String, forKey: "risk_rating_route_trail")
            thing.route_trail_width = FDictionary.value(forKey: "RISK_RATING_ROUTE_TRAIL")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_route_trail")
            thing.route_trail_width = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_HUMAN_EX_FACTOR") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String, forKey: "risk_rating_human_ex_factor")
            thing.human_ex_factor = FDictionary.value(forKey: "RISK_RATING_HUMAN_EX_FACTOR")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_human_ex_factor")
            thing.human_ex_factor = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_PERCENT_DSD") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String, forKey: "risk_rating_percent_dsd")
            thing.percent_dsd = FDictionary.value(forKey: "RISK_RATING_PERCENT_DSD")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_percent_dsd")
            thing.percent_dsd = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_R_W_IMPACTS") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String, forKey: "risk_rating_r_w_impacts")
            thing.r_w_impacts = FDictionary.value(forKey: "RISK_RATING_R_W_IMPACTS")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_r_w_impacts")
            thing.r_w_impacts = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_ENVIRO_CULT_IMPACTS") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String, forKey: "risk_rating_enviro_cult_impacts")
            thing.enviro_cult_impacts = FDictionary.value(forKey: "RISK_RATING_ENVIRO_CULT_IMPACTS")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_enviro_cult_impacts")
            thing.enviro_cult_impacts = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_MAINT_COMPLEXITY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String, forKey: "risk_rating_maint_complexity")
            thing.maint_complexity = FDictionary.value(forKey: "RISK_RATING_MAINT_COMPLEXITY")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_maint_complexity")
            thing.maint_complexity = ""
        }
        
        if(FDictionary.value(forKey:"RISK_RATING_EVENT_COST") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String, forKey: "risk_rating_event_cost")
            thing.event_cost = FDictionary.value(forKey: "RISK_RATING_EVENT_COST")! as? String}
        else{
            site.setValue("", forKey: "risk_rating_event_cost")
            thing.event_cost = ""
        }
        
        //TOTALS-ALL
        if(FDictionary.value(forKey:"HAZARD_TOTAL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "HAZARD_TOTAL")! as? String, forKey: "hazard_total")
            thing.hazard_total = FDictionary.value(forKey: "HAZARD_TOTAL")! as? String}
        else{
            site.setValue("", forKey: "hazard_total")
            thing.hazard_total = ""
        }
        
        if(FDictionary.value(forKey:"RISK_TOTAL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "RISK_TOTAL")! as? String, forKey: "risk_total")
            thing.risk_total = FDictionary.value(forKey: "RISK_TOTAL")! as? String}
        else{
            site.setValue("", forKey: "risk_total")
            thing.risk_total = ""
        }
        
        if(FDictionary.value(forKey:"TOTAL_SCORE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "TOTAL_SCORE")! as? String, forKey: "total_score")
            thing.total_score = FDictionary.value(forKey: "TOTAL_SCORE")! as? String}
        else{
            site.setValue("", forKey: "total_score")
            thing.total_score = ""
        }
        
        //email??
        
        //prelim and hazard ratings rockfall/landslide ids
        
        if(FDictionary.value(forKey:"HAZARD_TYPE") as? String != nil){
            site.setValue(FDictionary.value(forKey: "HAZARD_TYPE")! as? String, forKey: "hazard_type")
            thing.hazard_type = FDictionary.value(forKey: "HAZARD_TYPE")! as? String}
        else{
            site.setValue("", forKey: "hazard_type")
            thing.hazard_type = ""
        }
        
        //PRELIM RATING ROCKFALL ONLY
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_DITCH_EFF") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_PRELIM_DITCH_EFF")! as? String, forKey: "rockfall_prelim_ditch_eff")
            thing.prelim_rockfall_ditch_eff = FDictionary.value(forKey: "ROCKFALL_PRELIM_DITCH_EFF")! as? String}
        else{
            site.setValue("", forKey: "rockfall_prelim_ditch_eff")
            thing.prelim_rockfall_ditch_eff = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_ROCKFALL_HISTORY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_PRELIM_ROCKFALL_HISTORY")! as? String, forKey: "rockfall_prelim_rockfall_history")
            thing.prelim_rockfall_rockfall_history = FDictionary.value(forKey: "ROCKFALL_PRELIM_ROCKFALL_HISTORY")! as? String}
        else{
            site.setValue("", forKey: "rockfall_prelim_rockfall_history")
            thing.prelim_rockfall_rockfall_history = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL")! as? String, forKey: "rockfall_prelim_block_size_event_vol")
            thing.prelim_rockfall_block_size_event_vol = FDictionary.value(forKey: "ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL")! as? String}
        else{
            site.setValue("", forKey: "rockfall_prelim_block_size_event_vol")
            thing.prelim_rockfall_block_size_event_vol = ""
        }
        
        //HAZARD RATING ROCKFALL ONLY
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY")! as? String, forKey: "rockfall_hazard_rating_maint_frequency")
            thing.hazard_rockfall_maint_frequency = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            site.setValue("", forKey: "rockfall_hazard_rating_maint_frequency")
            thing.hazard_rockfall_maint_frequency = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION")! as? String, forKey: "rockfall_hazard_rating_case_one_struc_condition")
            thing.case_one_struc_cond = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION")! as? String}
        else{
            site.setValue("", forKey: "rockfall_hazard_rating_case_one_struc_condition")
            thing.case_one_struc_cond = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION")! as? String, forKey: "rockfall_hazard_rating_case_one_rock_friction")
            thing.case_one_rock_friction = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION")! as? String}
        else{
            site.setValue("", forKey: "rockfall_hazard_rating_case_one_rock_friction")
            thing.case_one_rock_friction = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION")! as? String, forKey: "rockfall_hazard_rating_case_two_struc_condition")
            thing.case_two_struc_cond = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION")! as? String}
        else{
            site.setValue("", forKey: "rockfall_hazard_rating_case_two_struc_condition")
            thing.case_two_struc_cond = ""
        }
        
        if(FDictionary.value(forKey:"ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION") as? String != nil){
            site.setValue(FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION")! as? String, forKey: "rockfall_hazard_rating_case_two_diff_erosion")
            thing.case_two_diff_erosion = FDictionary.value(forKey: "ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION")! as? String}
        else{
            site.setValue("", forKey: "rockfall_hazard_rating_case_two_diff_erosion")
            thing.case_two_diff_erosion = ""
        }
        
        //PRELIM RATING LANDSLIDE ONLY
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED")! as? String, forKey: "landslide_prelim_road_width_affected")
            thing.prelim_landslide_road_width_affected = FDictionary.value(forKey: "LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED")! as? String}
        else{
            site.setValue("", forKey: "landslide_prelim_road_width_affected")
            thing.prelim_landslide_road_width_affected = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS")! as? String, forKey: "landslide_prelim_slide_erosion_effects")
            thing.prelim_landslide_slide_erosion_effects = FDictionary.value(forKey: "LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS")! as? String}
        else{
            site.setValue("", forKey: "landslide_prelim_slide_erosion_effects")
            thing.prelim_landslide_slide_erosion_effects = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_PRELIM_LENGTH_AFFECTED") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_PRELIM_LENGTH_AFFECTED")! as? String, forKey: "landslide_prelim_length_affected")
            thing.prelim_landslide_length_affected = FDictionary.value(forKey: "LANDSLIDE_PRELIM_LENGTH_AFFECTED")! as? String}
        else{
            site.setValue("", forKey: "landslide_prelim_length_affected")
            thing.prelim_landslide_length_affected = ""
        }
        
        //HAZARD RATING LANDSLIDE ONLY
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_THAW_STABILITY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_THAW_STABILITY")! as? String, forKey: "landslide_hazard_rating_thaw_stability")
            thing.hazard_landslide_thaw_stability = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_THAW_STABILITY")! as? String}
        else{
            site.setValue("", forKey: "landslide_hazard_rating_thaw_stability")
            thing.hazard_landslide_thaw_stability = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY")! as? String, forKey: "landslide_hazard_rating_maint_frequency")
            thing.hazard_landslide_maint_frequency = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY")! as? String}
        else{
            site.setValue("", forKey: "landslide_hazard_rating_maint_frequency")
            thing.hazard_landslide_maint_frequency = ""
        }
        
        if(FDictionary.value(forKey:"LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY") as? String != nil){
            site.setValue(FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY")! as? String, forKey: "landslide_hazard_rating_movement_history")
            thing.hazard_landslide_movement_history = FDictionary.value(forKey: "LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY")! as? String}
        else{
            site.setValue("", forKey: "landslide_hazard_rating_movement_history")
            thing.hazard_landslide_movement_history = ""
        }
        
        
        //FLMA LINK
        if(FDictionary.value(forKey:"FLMA_ID") as? String != nil){
            site.setValue(FDictionary.value(forKey: "FLMA_ID")! as? String, forKey: "flma_id")
            thing.flma_id = FDictionary.value(forKey: "FLMA_ID")! as? String}
        else{
            site.setValue("", forKey: "flma_id")
            thing.flma_id = ""
        }
        
        if(FDictionary.value(forKey:"FLMA_NAME") as? String != nil){
            site.setValue(FDictionary.value(forKey: "FLMA_NAME")! as? String, forKey: "flma_name")
            thing.flma_name = FDictionary.value(forKey: "FLMA_NAME")! as? String}
        else{
            site.setValue("", forKey: "flma_name")
            thing.flma_name = ""
        }
        
        if(FDictionary.value(forKey:"FLMA_DESCRIPTION") as? String != nil){
            site.setValue(FDictionary.value(forKey: "FLMA_DESCRIPTION")! as? String, forKey: "flma_description")
            thing.flma_description = FDictionary.value(forKey: "FLMA_DESCRIPTION")! as? String}
        else{
            site.setValue("", forKey: "flma_description")
            thing.flma_description = ""
        }
        
        if(FDictionary.value(forKey:"COMMENT") as? String != nil){
            site.setValue(FDictionary.value(forKey: "COMMENT")! as? String, forKey: "comment")
            thing.comments = FDictionary.value(forKey: "COMMENT")! as? String}
        else{
            site.setValue("", forKey: "comment")
            thing.comments = ""
        }
        
        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        do { //user message - form saved
            try managedContext.save()
            
            //user message- error form not saved
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedF(comments)
        })
    }
}
