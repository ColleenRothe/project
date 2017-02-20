//
//  MaintenanceInfoModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

protocol MaintenanceInfoModelHelperProtocol: class{
    func itemsDownloadedI (_ items: NSArray)
}

let shareData = ShareData.sharedInstance
var responseString = ""
var JSONDictionary = NSDictionary()


class MaintenanceInfoModelHelper: NSObject, URLSessionDataDelegate{

    func helper(){
        print("Helper")
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/currentMaintenance.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "id=\(shareData.current_site_id)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            
            //print("responseString = \(responseString)")
            
            responseString = responseString.replacingOccurrences(of: "[", with: "")
            responseString = responseString.replacingOccurrences(of: "]", with: "")
            //problem if there are commas in any of the strings people type in
            
            if let data2 = responseString.data(using: .utf8){
                
                do {
                    JSONDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
                } catch let error as NSError {
                    print("error: \(error.localizedDescription)")
                }
            }
            
            
            //responseString = responseString.replacingOccurrences(of: "\"", with: "~!~")
            print("new string is" + responseString)
            self.parseJSON()
            
            
            
        }
        task.resume()
        
        
    }

    weak var delegate: MaintenanceInfoModelHelperProtocol?
    
    func downloadItems(){
        helper()

        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
       

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){

    }
    
    func parseJSON(){
        let comments : NSMutableArray = NSMutableArray()
        let thing = MaintenanceInfoModel() //instantiate object to hold each element in the spec. JSON obj.
        
        if(JSONDictionary.value(forKey:"ID") as? String != nil){
            thing.id = JSONDictionary.value(forKey: "ID")! as? String}
        else{
            thing.id = ""
        }
        
        if(JSONDictionary.value(forKey:"SITE_ID") as? String != nil){
            thing.site_id = JSONDictionary.value(forKey: "SITE_ID")! as? String}
        else{
            thing.site_id = ""
        }
        
        if(JSONDictionary.value(forKey:"CODE_RELATION") as? String != nil){
            thing.code_relation = JSONDictionary.value(forKey: "CODE_RELATION")! as? String}
        else{
            thing.code_relation = ""
        }
        
        if(JSONDictionary.value(forKey:"MAINTENANCE_TYPE") as? String != nil){
            thing.maintenance_type = JSONDictionary.value(forKey: "MAINTENANCE_TYPE")! as? String}
        else{
            thing.maintenance_type = ""
        }
        
        if(JSONDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
            thing.rtNum = JSONDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String}
        else{
            thing.rtNum = ""
        }
        
        if(JSONDictionary.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
            thing.beginMile = JSONDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String}
        else{
            thing.beginMile = ""
        }
        
        if(JSONDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
            thing.endMile = JSONDictionary.value(forKey: "END_MILE_MARKER")! as? String}
        else{
            thing.endMile = ""
        }
        
        if(JSONDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
            thing.agency = JSONDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String}
        else{
            thing.agency = ""
        }
        
        if(JSONDictionary.value(forKey:"REGIONAL_ADMIN") as? String != nil){
            thing.regional = JSONDictionary.value(forKey: "REGIONAL_ADMIN")! as? String}
        else{
            thing.regional = ""
        }
        
        if(JSONDictionary.value(forKey:"LOCAL_ADMIN") as? String != nil){
            thing.local = JSONDictionary.value(forKey: "LOCAL_ADMIN")! as? String}
        else{
            thing.local = ""
        }
        
        if(JSONDictionary.value(forKey:"US_EVENT") as? String != nil){
            thing.us_event = JSONDictionary.value(forKey: "US_EVENT")! as? String}
        else{
            thing.us_event = ""
        }
        
        if(JSONDictionary.value(forKey:"EVENT_DESC") as? String != nil){
            thing.event_desc = JSONDictionary.value(forKey: "EVENT_DESC")! as? String}
        else{
            thing.event_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"DESIGN_PSE") as? String != nil){
            thing.design_pse = JSONDictionary.value(forKey: "DESIGN_PSE")! as? String}
        else{
            thing.design_pse = ""
        }
        
        if(JSONDictionary.value(forKey:"REMOVE_DITCH") as? String != nil){
            thing.remove_ditch = JSONDictionary.value(forKey: "REMOVE_DITCH")! as? String}
        else{
            thing.remove_ditch = ""
        }
        
        if(JSONDictionary.value(forKey:"REMOVE_ROAD_TRAIL") as? String != nil){
            thing.remove_road_trail = JSONDictionary.value(forKey: "REMOVE_ROAD_TRAIL")! as? String}
        else{
            thing.remove_road_trail = ""
        }
        
        if(JSONDictionary.value(forKey:"RELEVEL_AGGREGATE") as? String != nil){
            thing.relevel_aggregate = JSONDictionary.value(forKey: "RELEVEL_AGGREGATE")! as? String}
        else{
            thing.relevel_aggregate = ""
        }
        
        if(JSONDictionary.value(forKey:"RELEVEL_PATCH") as? String != nil){
            thing.relevel_patch = JSONDictionary.value(forKey: "RELEVEL_PATCH")! as? String}
        else{
            thing.relevel_patch = ""
        }
        
        if(JSONDictionary.value(forKey:"DRAINAGE_IMPROVEMENT") as? String != nil){
            thing.drainage_improvement = JSONDictionary.value(forKey: "DRAINAGE_IMPROVEMENT")! as? String}
        else{
            thing.drainage_improvement = ""
        }
        
        if(JSONDictionary.value(forKey:"DEEP_PATCH") as? String != nil){
            thing.deep_patch = JSONDictionary.value(forKey: "DEEP_PATCH")! as? String}
        else{
            thing.deep_patch = ""
        }
        
        if(JSONDictionary.value(forKey:"HAUL_DEBRIS") as? String != nil){
            thing.haul_debris = JSONDictionary.value(forKey: "HAUL_DEBRIS")! as? String}
        else{
            thing.haul_debris = ""
        }
        
        if(JSONDictionary.value(forKey:"SCALING_ROCK_SLOPES") as? String != nil){
            thing.scaling_rock_slopes = JSONDictionary.value(forKey: "SCALING_ROCK_SLOPES")! as? String}
        else{
            thing.scaling_rock_slopes = ""
        }
        
        if(JSONDictionary.value(forKey:"ROAD_TRAIL_ALIGNMENT") as? String != nil){
            thing.road_trail_alignment = JSONDictionary.value(forKey: "ROAD_TRAIL_ALIGNMENT")! as? String}
        else{
            thing.road_trail_alignment = ""
        }
        
        if(JSONDictionary.value(forKey:"REPAIR_ROCKFALL_BARRIER") as? String != nil){
            thing.repair_rockfall_barrier = JSONDictionary.value(forKey: "REPAIR_ROCKFALL_BARRIER")! as? String}
        else{
            thing.repair_rockfall_barrier = ""
        }
        
        if(JSONDictionary.value(forKey:"REPAIR_ROCKFALL_NETTING") as? String != nil){
            thing.repair_rockfall_netting = JSONDictionary.value(forKey: "REPAIR_ROCKFALL_NETTING")! as? String}
        else{
            thing.repair_rockfall_netting = ""
        }
        
        if(JSONDictionary.value(forKey:"SEALING_CRACKS") as? String != nil){
            thing.sealing_cracks = JSONDictionary.value(forKey: "SEALING_CRACKS")! as? String}
        else{
            thing.sealing_cracks = ""
        }
        
        if(JSONDictionary.value(forKey:"GUARDRAIL") as? String != nil){
            thing.guardrail = JSONDictionary.value(forKey: "GUARDRAIL")! as? String}
        else{
            thing.guardrail = ""
        }
        
        if(JSONDictionary.value(forKey:"CLEANING_DRAINS") as? String != nil){
            thing.cleaning_drains = JSONDictionary.value(forKey: "CLEANING_DRAINS")! as? String}
        else{
            thing.cleaning_drains = ""
        }
        
        if(JSONDictionary.value(forKey:"FLAGGING_SIGNING") as? String != nil){
            thing.flagging_signing = JSONDictionary.value(forKey: "FLAGGING_SIGNING")! as? String}
        else{
            thing.flagging_signing = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS1_DESC") as? String != nil){
            thing.others1_desc = JSONDictionary.value(forKey: "OTHERS1_DESC")! as? String}
        else{
            thing.others1_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS1") as? String != nil){
            thing.others1 = JSONDictionary.value(forKey: "OTHERS1")! as? String}
        else{
            thing.others1 = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS2_DESC") as? String != nil){
            thing.others2_desc = JSONDictionary.value(forKey: "OTHERS2_DESC")! as? String}
        else{
            thing.others2_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS2") as? String != nil){
            thing.others2 = JSONDictionary.value(forKey: "OTHERS2")! as? String}
        else{
            thing.others2 = ""
        }

        
        if(JSONDictionary.value(forKey:"OTHERS3_DESC") as? String != nil){
            thing.others3_desc = JSONDictionary.value(forKey: "OTHERS3_DESC")! as? String}
        else{
            thing.others3_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS3") as? String != nil){
            thing.others3 = JSONDictionary.value(forKey: "OTHERS3")! as? String}
        else{
            thing.others3 = ""
        }

        
        if(JSONDictionary.value(forKey:"OTHERS4_DESC") as? String != nil){
            thing.others4_desc = JSONDictionary.value(forKey: "OTHERS4_DESC")! as? String}
        else{
            thing.others4_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS4") as? String != nil){
            thing.others4 = JSONDictionary.value(forKey: "OTHERS4")! as? String}
        else{
            thing.others4 = ""
        }

        
        if(JSONDictionary.value(forKey:"OTHERS5_DESC") as? String != nil){
            thing.others5_desc = JSONDictionary.value(forKey: "OTHERS5_DESC")! as? String}
        else{
            thing.others5_desc = ""
        }
        
        if(JSONDictionary.value(forKey:"OTHERS5") as? String != nil){
            thing.others5 = JSONDictionary.value(forKey: "OTHERS5")! as? String}
        else{
            thing.others5 = ""
        }
        
        if(JSONDictionary.value(forKey:"TOTAL") as? String != nil){
            thing.total = JSONDictionary.value(forKey: "TOTAL")! as? String}
        else{
            thing.total = ""
        }
        
        if(JSONDictionary.value(forKey:"TOTAL_PERCENT") as? String != nil){
            thing.total_percent = JSONDictionary.value(forKey: "TOTAL_PERCENT")! as? String}
        else{
            thing.total_percent = ""
        }

        

        
        //problem if there are commas in any of the strings people type in
        //let answer = responseString.components(separatedBy: ",~!~")
        
//        thing.id = answer[0].replacingOccurrences(of: "~!~", with: "")
//        thing.site_id = answer[1].replacingOccurrences(of: "~!~", with: "")
//        thing.code_relation = answer[2].replacingOccurrences(of: "~!~", with: "")
//        thing.maintenance_type = answer[3].replacingOccurrences(of: "~!~", with: "")
//        thing.rtNum = answer[4].replacingOccurrences(of: "~!~", with: "")
//        thing.beginMile = answer[5].replacingOccurrences(of: "~!~", with: "")
//        thing.endMile = answer[6].replacingOccurrences(of: "~!~", with: "")
//        thing.agency = answer[7].replacingOccurrences(of: "~!~", with: "")
//        thing.regional = answer[8].replacingOccurrences(of: "~!~", with: "")
//        thing.local = answer[9].replacingOccurrences(of: "~!~", with: "")
//
//        
//        
//        thing.us_event = answer[10].replacingOccurrences(of: "~!~", with: "")
//        thing.event_desc = answer[11].replacingOccurrences(of: "~!~", with: "")
//        thing.design_pse = answer[12].replacingOccurrences(of: "~!~", with: "")
//        thing.remove_ditch = answer[13].replacingOccurrences(of: "~!~", with: "")
//        thing.remove_road_trail = answer[14].replacingOccurrences(of: "~!~", with: "")
//        thing.relevel_aggregate = answer[15].replacingOccurrences(of: "~!~", with: "")
//        thing.relevel_patch = answer[16].replacingOccurrences(of: "~!~", with: "")
//        thing.drainage_improvement = answer[17].replacingOccurrences(of: "~!~", with: "")
//        thing.deep_patch = answer[18].replacingOccurrences(of: "~!~", with: "")
//        thing.haul_debris = answer[19].replacingOccurrences(of: "~!~", with: "")
//        thing.scaling_rock_slopes = answer[20].replacingOccurrences(of: "~!~", with: "")
//        thing.road_trail_alignment = answer[21].replacingOccurrences(of: "~!~", with: "")
//        thing.repair_rockfall_barrier = answer[22].replacingOccurrences(of: "~!~", with: "")
//        thing.repair_rockfall_netting = answer[23].replacingOccurrences(of: "~!~", with: "")
//        thing.sealing_cracks = answer[24].replacingOccurrences(of: "~!~", with: "")
//        thing.guardrail = answer[25].replacingOccurrences(of: "~!~", with: "")
//        thing.cleaning_drains = answer[26].replacingOccurrences(of: "~!~", with: "")
//        thing.flagging_signing = answer[27].replacingOccurrences(of: "~!~", with: "")
//        thing.others1_desc = answer[28].replacingOccurrences(of: "~!~", with: "")
//        thing.others1 = answer[29].replacingOccurrences(of: "~!~", with: "")
//        thing.others2_desc = answer[30].replacingOccurrences(of: "~!~", with: "")
//        thing.others2 = answer[31].replacingOccurrences(of: "~!~", with: "")
//        thing.others3_desc = answer[32].replacingOccurrences(of: "~!~", with: "")
//        thing.others3 = answer[33].replacingOccurrences(of: "~!~", with: "")
//        thing.others4_desc = answer[34].replacingOccurrences(of: "~!~", with: "")
//        thing.others4 = answer[35].replacingOccurrences(of: "~!~", with: "")
//        thing.others5_desc = answer[36].replacingOccurrences(of: "~!~", with: "")
//        thing.others5 = answer[37].replacingOccurrences(of: "~!~", with: "")
//        thing.total = answer[38].replacingOccurrences(of: "~!~", with: "")
//        thing.total_percent = answer[39].replacingOccurrences(of: "~!~", with: "")
//        thing.design_pse_val = answer[40].replacingOccurrences(of: "~!~", with: "")
//        thing.remove_ditch_val = answer[41].replacingOccurrences(of: "~!~", with: "")
//        thing.remove_road_trail_val = answer[42].replacingOccurrences(of: "~!~", with: "")
//        thing.relevel_aggregate_val = answer[43].replacingOccurrences(of: "~!~", with: "")
//        thing.relevel_patch_val = answer[44].replacingOccurrences(of: "~!~", with: "")
//        thing.drainage_improvement_val = answer[45].replacingOccurrences(of: "~!~", with: "")
//        thing.deep_patch_val = answer[46].replacingOccurrences(of: "~!~", with: "")
//        thing.haul_debris_val = answer[47].replacingOccurrences(of: "~!~", with: "")
//        thing.scaling_rock_slopes_val = answer[48].replacingOccurrences(of: "~!~", with: "")
//        thing.road_trail_alignment_val = answer[49].replacingOccurrences(of: "~!~", with: "")
//        thing.repair_rockfall_barrier_val = answer[50].replacingOccurrences(of: "~!~", with: "")
//        thing.repair_rockfall_netting_val = answer[51].replacingOccurrences(of: "~!~", with: "")
//        thing.sealing_cracks_val = answer[52].replacingOccurrences(of: "~!~", with: "")
//        thing.guardrail_val = answer[53].replacingOccurrences(of: "~!~", with: "")
//        thing.cleaning_drains_val = answer[54].replacingOccurrences(of: "~!~", with: "")
//        thing.flagging_signing_val = answer[55].replacingOccurrences(of: "~!~", with: "")
//        thing.others1_val = answer[56].replacingOccurrences(of: "~!~", with: "")
//        thing.others2_val = answer[57].replacingOccurrences(of: "~!~", with: "")
//        thing.others3_val = answer[58].replacingOccurrences(of: "~!~", with: "")
//        thing.others4_val = answer[59].replacingOccurrences(of: "~!~", with: "")
//        thing.others5_val = answer[60].replacingOccurrences(of: "~!~", with: "")

        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            
            
        //}
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedI(comments)
        })
        
    }
    
    


}
