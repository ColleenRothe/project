//
//  pinModelHelper.swift
//  USMPTest1
//
//  Gets info from the DB to place the pins
//
//  Created by Colleen Rothe on 2/28/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//CREDITS:
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

protocol pinModelHelperProtocol: class{
    func itemsDownloaded (_ items: NSArray)
}

class pinModelHelper: NSObject, URLSessionDataDelegate{
    
    weak var delegate: pinModelHelperProtocol?
    
    var data: NSMutableData = NSMutableData()
    
    //or wherever the php service lives...
    //let urlPath: String = "http://nl.cs.montana.edu/usmp/colleen/pin.php"
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/pin.php"
    
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
            print("Data Downloaded")
            self.parseJSON()
            
        }
    }
    
    func parseJSON(){
        var jsonResult: NSArray = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
            
        }
        
        var jsonElement: NSArray = NSArray()
        let comments : NSMutableArray = NSMutableArray()
        
        //loop through JSON objects, store them in NSDictionary object to split into key-val pairs
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSArray
            let thing = pinModel() //instantiate object to hold each element in the spec. JSON obj.
            
            if let id = jsonElement[0] as? String, let site_id = jsonElement[1] as? String, let coordinate1 = jsonElement[2] as? String, let coordinate2 = jsonElement[3] as? String, let total = jsonElement[4] as? String, let hazard_rating_rockfall_id = jsonElement[5] as? String, let hazard_rating_landslide_id = jsonElement[6] as? String, let prelimRating = jsonElement[7] as? String {
                
                thing.id = id
                thing.site_id = site_id
                thing.coordinate1 = coordinate1
                thing.coordinate2 = coordinate2
                thing.total = total
                thing.hazard_rating_rockfall_id = hazard_rating_rockfall_id
                thing.hazard_rating_landslide_id = hazard_rating_landslide_id
                thing.prelimRating = prelimRating
                
            }
            
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            }
            
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloaded(comments)
        })
        
    }
}

