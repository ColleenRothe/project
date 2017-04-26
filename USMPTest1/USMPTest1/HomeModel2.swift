//
//  HomeModel2.swift
//  USMPTest1
//
//  Gets DB pin info for offline save. Used by MapboxOnline.swift, OfflineModel
//
//  Created by Colleen Rothe on 4/27/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//homeModel adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

//use for offline site information saving
protocol HomeModel2Protocol: class{
    func itemsDownloaded2 (_ items: NSArray)
}

class HomeModel2: NSObject, URLSessionDataDelegate, OfflineModelHelperProtocol{
    
    //offline model stuff
     var OFeedItems: NSArray = NSArray()
    
    func itemsDownloadedO(_ items: NSArray) {
        OFeedItems = items
    }
    
    //Back to regular stuff...
    weak var delegate: HomeModel2Protocol?
    
    var data: NSMutableData = NSMutableData()
    let shareData = ShareData.sharedInstance
    
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/mapService.php"
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        var session: Foundation.URLSession!
        let configuration = URLSessionConfiguration.default
        
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url)
        
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        self.data.append(data);
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if (error != nil)
        {
            print("Failed to download")
        } else {
            print("Home Model Data Downloaded")
            self.parseJSON()
            
        }
    }
    
    //put info from dictionary into OfflineModel
    func parseJSON(){
        var jsonResult: NSArray = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        }catch let error as NSError{
            print("There was an error :(")
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
       
        let comments : NSMutableArray = NSMutableArray()
        
        for k in 0 ..< jsonResult.count {
        
            jsonElement = jsonResult[k] as! NSDictionary

            //if you find the one you want
            if shareData.offIds.contains((jsonElement.value(forKey:"SITE_ID") as? String)!){
                let thing = OfflineModel() //instantiate object to hold each element in the spec. JSON obj.
        
                if(jsonElement.value(forKey:"ID") as? String != nil){
                    thing.id = jsonElement.value(forKey: "ID")! as? String}
                else{
                    thing.id = ""
                }
                
                if(jsonElement.value(forKey:"SITE_ID") as? String != nil){
                    thing.site_id = jsonElement.value(forKey: "SITE_ID")! as? String}
                else{
                    thing.site_id = ""
                }
                
                if(jsonElement.value(forKey:"COORDINATES") as? String != nil){
                    thing.coordinates = jsonElement.value(forKey: "COORDINATES")! as? String}
                else{
                    thing.coordinates = ""
                }
                
                if(jsonElement.value(forKey:"DATE") as? String != nil){
                    thing.date = jsonElement.value(forKey: "DATE")! as? String}
                else{
                    thing.date = ""
                }

                
                if(jsonElement.value(forKey:"ROAD_TRAIL_NO") as? String != nil){
                    thing.road_trail_no = jsonElement.value(forKey: "ROAD_TRAIL_NO")! as? String}
                else{
                    thing.road_trail_no = ""
                }
                
                if(jsonElement.value(forKey:"BEGIN_MILE_MARKER") as? String != nil){
                    thing.begin_mile_marker = jsonElement.value(forKey: "BEGIN_MILE_MARKER")! as? String}
                else{
                    thing.begin_mile_marker = ""
                }
                
                if(jsonElement.value(forKey:"END_MILE_MARKER") as? String != nil){
                    thing.end_mile_marker = jsonElement.value(forKey: "END_MILE_MARKER")! as? String}
                else{
                    thing.end_mile_marker = ""
                }
                
                if(jsonElement.value(forKey:"SIDE") as? String != nil){
                    thing.side = jsonElement.value(forKey: "SIDE")! as? String}
                else{
                    thing.side = ""
                }
                
                if(jsonElement.value(forKey:"HAZARD_TYPE") as? String != nil){
                    thing.hazard_type = jsonElement.value(forKey: "HAZARD_TYPE")! as? String}
                else{
                    thing.hazard_type = ""
                }
                
                if(jsonElement.value(forKey:"PRELIMINARY_RATING") as? String != nil){
                    thing.prelim_rating = jsonElement.value(forKey: "PRELIMINARY_RATING")! as? String}
                else{
                    thing.prelim_rating = ""
                }
                
                if(jsonElement.value(forKey:"TOTAL_SCORE") as? String != nil){
                    thing.total_score = jsonElement.value(forKey: "TOTAL_SCORE")! as? String}
                else{
                    thing.total_score = ""
                }
                
                if(jsonElement.value(forKey:"PHOTOS") as? String != nil){
                    thing.photos = jsonElement.value(forKey: "PHOTOS")! as? String}
                else{
                    thing.photos = ""
                }
                
                
                if(jsonElement.value(forKey:"COMMENTS") as? String != nil){
                    thing.comments = jsonElement.value(forKey: "COMMENTS")! as? String}
                else{
                    thing.comments = ""
                }
                
                if(jsonElement.value(forKey:"HAZARD_RATING_ROCKFALL_ID") as? String != nil){
                    thing.hazard_rating_rockfall_id = jsonElement.value(forKey: "HAZARD_RATING_ROCKFALL_ID")! as? String}
                else{
                    thing.hazard_rating_rockfall_id = ""
                }
                
                if(jsonElement.value(forKey:"HAZARD_RATING_LANDSLIDE_ID") as? String != nil){
                    thing.hazard_rating_landslide_id = jsonElement.value(forKey: "HAZARD_RATING_LANDSLIDE_ID")! as? String}
                else{
                    thing.hazard_rating_landslide_id = ""
                }
                
                shareData.current_clicked_id = thing.id!
                //call to offline model helper for the full information
                let omh = OfflineModelHelper()
                omh.delegate = self
                omh.downloadItems()
                
        comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
            }//end if contains
        } //end for loop
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloaded2(comments)
        })
        
    }
}

