//
//  HomeModel.swift
//  USMPTest1
//
//  Gets info from DB for AnnotationInfo.swift and saves in AnnotationModel
//
//  Created by Colleen Rothe on 2/22/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//homeModel adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

//protocol that AnnotationInfo.swift will follow
protocol HomeModelProtocol: class{
    func itemsDownloadedH (_ items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate{
    weak var delegate: HomeModelProtocol?
    var data: NSMutableData = NSMutableData()
    let shareData = ShareData.sharedInstance
    var responseString = ""
    var JSONDictionary = NSDictionary()


    func helper(){
        //where the php is
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/get_current_site.php")! as URL)
        
        request.httpMethod = "POST"
        
        //send the site_id
        let postString = "id=\(shareData.current_site_id)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            //print("response = \(String(describing: response))")
            
            self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            
            //parse the response string, because it comes back in several {} blocks
            self.responseString = self.responseString.replacingOccurrences(of: "[", with: "")
            self.responseString = self.responseString.replacingOccurrences(of: "]", with: "")
            
            let someIndex = self.responseString.index(self.responseString.startIndex,
                                           offsetBy: 1)
            
            
                if(self.responseString[someIndex] != "I"){
                self.responseString = self.responseString.replacingOccurrences(of: "\"0\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"1\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"2\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"3\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"4\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"5\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"6\":", with: "")
                self.responseString = self.responseString.replacingOccurrences(of: "\"7\":", with: "")
                
                self.responseString = self.responseString.replacingOccurrences(of: ",,", with: ",")

            }
            
            
            
            self.responseString = self.responseString.replacingOccurrences(of: "{", with: "")
            self.responseString = self.responseString.replacingOccurrences(of: "}", with: "")
            var tempString = "{"
            tempString = tempString.appending(self.responseString)
            tempString.append("}")
            self.responseString = tempString
            
            
            if let data2 = self.responseString.data(using: .utf8){
            
            //save as a dictionary
            do {
                self.JSONDictionary =  try JSONSerialization.jsonObject(with: data2, options: []) as! NSDictionary
            } catch let error as NSError {
                print("error here")
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
    
    //save data into the AnnotationModel
    func parseJSON(){
        print("Response string is"+responseString)
        let comments : NSMutableArray = NSMutableArray()
        let thing = AnnotationModel() //instantiate object to hold each element in the spec. JSON obj.
        
        //put info from the dictionary into the model
        
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
        if(self.JSONDictionary.value(forKey:"BEGIN_COORDINATE_LAT") as? String != nil){
            var coordinateString = self.JSONDictionary.value(forKey: "BEGIN_COORDINATE_LAT")! as? String
            coordinateString = coordinateString?.appending((self.JSONDictionary.value(forKey: "BEGIN_COORDINATE_LONG")! as? String)!)
        thing.coordinates = coordinateString
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
        if(self.JSONDictionary.value(forKey:"UMBRELLA_AGENCY") as? String != nil){
        thing.umbrella_agency = self.JSONDictionary.value(forKey: "UMBRELLA_AGENCY")! as? String
        }else{
            thing.umbrella_agency=""
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
        if(self.JSONDictionary.value(forKey:"HAZARD_TYPE2")as? String != nil){
        thing.hazard_type = self.JSONDictionary.value(forKey: "HAZARD_TYPE2")! as? String
        print("test hazard type:")
        print(thing.hazard_type!)
        }
        else{
            thing.hazard_type = ""
        }
        if(self.JSONDictionary.value(forKey:"PRELIMINARY_RATING")as? String != nil){
        thing.prelim_rating = self.JSONDictionary.value(forKey: "PRELIMINARY_RATING")! as? String
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
        
        print("test home model (current site) photos")
        print(thing.photos)
        
        
        if(self.JSONDictionary.value(forKey:"COMMENT")as? String != nil){
        thing.comments = self.JSONDictionary.value(forKey: "COMMENT")! as? String
        }else{
            thing.comments=""
        }
        
        

        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedH(comments)
        })
        
    }
}
