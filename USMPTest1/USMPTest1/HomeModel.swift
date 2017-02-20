//
//  HomeModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/22/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//homeModel adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

protocol HomeModelProtocol: class{
    func itemsDownloadedH (_ items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate{
    
    weak var delegate: HomeModelProtocol?
    var data: NSMutableData = NSMutableData()
    let shareData = ShareData.sharedInstance
    var responseString = ""
    var JSONDictionary = NSDictionary()

    

    
    
    //or wherever the php service lives...
    //let urlPath: String = "http://nl.cs.montana.edu/usmp/colleen/mapService.php"
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/mapService.php"

    func helper(){
        print("Helper")
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/mapService2.php")! as URL)
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
            
            self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            

            
            

            //print("responseString = \(responseString)")
            
            self.responseString = self.responseString.replacingOccurrences(of: "[", with: "")
            self.responseString = self.responseString.replacingOccurrences(of: "]", with: "")
            //problem if there are commas in any of the strings people type in
            
            if let data2 = self.responseString.data(using: .utf8){
            
            do {
                self.JSONDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            }
            
            
            self.parseJSON()
        
            
            
        }
        task.resume()
        

    }
    
    
    func downloadItems(){
       helper()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
       
    }
    
    func parseJSON(){
        print("Response string is"+responseString)
        let comments : NSMutableArray = NSMutableArray()
        let thing = AnnotationModel() //instantiate object to hold each element in the spec. JSON obj.
        
        if(self.JSONDictionary.value(forKey:"ID") as? String != nil){
            thing.id = self.JSONDictionary.value(forKey: "ID")! as? String}
        else{
            thing.id = ""
        }
        if(self.JSONDictionary.value(forKey:"SITE_ID") as? String != nil){
        thing.site_id = self.JSONDictionary.value(forKey: "SITE_ID")! as? String
        }
        else{
            thing.site_id=""
        }
        if(self.JSONDictionary.value(forKey:"COORDINATES") as? String != nil){
        thing.coordinates = self.JSONDictionary.value(forKey: "COORDINATES")! as? String
        }
        else{
            thing.coordinates=""
        }
        if(self.JSONDictionary.value(forKey:"DATE") as? String != nil){
            thing.date = self.JSONDictionary.value(forKey: "DATE")! as? String
        }
        else{
            thing.date = ""
        }
        if(self.JSONDictionary.value(forKey:"SLOPE_STATUS") as? String != nil){
        thing.slope_status = self.JSONDictionary.value(forKey: "SLOPE_STATUS")! as? String
        }
        else{
            thing.slope_status=""
        }
        if(self.JSONDictionary.value(forKey:"MANAGEMENT_AREA") as? String != nil){
        thing.management_area = self.JSONDictionary.value(forKey: "MANAGEMENT_AREA")! as? String
        }else{
            thing.management_area=""
        }
        
        if(self.JSONDictionary.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
        thing.road_trail_no = self.JSONDictionary.value(forKey: "ROAD_TRAIL_NO")! as? String
        }
        else{
            thing.road_trail_no = ""
        }
        if(self.JSONDictionary.value(forKey:"BEGIN_MILE_MARKER")as? String != nil){
        thing.begin_mile_marker = self.JSONDictionary.value(forKey: "BEGIN_MILE_MARKER")! as? String
        }else{
            thing.begin_mile_marker = ""
        }
        if(self.JSONDictionary.value(forKey:"END_MILE_MARKER") as? String != nil){
        thing.end_mile_marker = self.JSONDictionary.value(forKey: "END_MILE_MARKER")! as? String
        }else{
            thing.end_mile_marker = ""
        }
        if(self.JSONDictionary.value(forKey:"SIDE") as? String != nil){
        thing.side = self.JSONDictionary.value(forKey: "SIDE")! as? String
        }else{
            thing.side = ""
        }
        if(self.JSONDictionary.value(forKey:"HAZARD_TYPE")as? String != nil){
        thing.hazard_type = self.JSONDictionary.value(forKey: "HAZARD_TYPE")! as? String
        }
        else{
            thing.hazard_type = ""
        }
        if(self.JSONDictionary.value(forKey:"PRELIM_RATING")as? String != nil){
        thing.prelim_rating = self.JSONDictionary.value(forKey: "PRELIM_RATING")! as? String
        }else{
            thing.prelim_rating=""
        }
        if(self.JSONDictionary.value(forKey:"TOTAL_SCORE")as? String != nil){
        thing.total_score = self.JSONDictionary.value(forKey: "TOTAL_SCORE")! as? String
        }else{
            thing.total_score = ""
        }
        if(self.JSONDictionary.value(forKey:"PHOTOS")as? String != nil){
        thing.photos = self.JSONDictionary.value(forKey: "PHOTOS")! as? String
        }else{
            thing.photos=""
        }
        if(self.JSONDictionary.value(forKey:"COMMENTS")as? String != nil){
        thing.comments = self.JSONDictionary.value(forKey: "COMMENTS")! as? String
        }else{
            thing.comments=""
        }


    
            //print(thing.id)
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            
            
        


        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedH(comments)
        })
        
    }
}
    
    
    



    
    
