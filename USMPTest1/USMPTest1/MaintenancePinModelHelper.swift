//
//  MaintenancePinModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

protocol MaintenancePinModelHelperProtocol: class{
    func itemsDownloaded (_ items: NSArray)
}

class MaintenancePinModelHelper: NSObject, URLSessionDataDelegate{
    weak var delegate: MaintenancePinModelHelperProtocol?

    var data: NSMutableData = NSMutableData()
    
    //or wherever the php service lives...
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/maintenanceMap.php"
    
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
        //var jsonResult: NSMutableArray = NSMutableArray()
        var jsonResult: NSArray = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
            
        }
        
        //jsonResult = NSMutableArray(array: jsonResult)
        
        var jsonElement: NSArray = NSArray()
        let comments : NSMutableArray = NSMutableArray()
        
        print("COUNT IS")
        print(jsonResult.count)
        
        //loop through JSON objects, store them in NSDictionary object to split into key-val pairs
        //for(var i=0; i<jsonResult.count; i += 1)
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSArray
            let thing = MaintenancePinModel() //instantiate object to hold each element in the spec. JSON obj.
            
            if let id = jsonElement[0] as? String, let site_id = jsonElement[1] as? String, let coordinate1 = jsonElement[2] as? String, let coordinate2 = jsonElement[3] as? String, let code_relation = jsonElement[4] as? String, let maintenance_type = jsonElement[5] as? String, let us_event = jsonElement[6] as? String, let event_desc = jsonElement[7] as? String, let total = jsonElement[8] as? String, let total_percent = jsonElement[9] as? String{
                
                
                
                thing.id = id
                thing.site_id = site_id
                thing.latitude = coordinate1
                thing.longitude = coordinate2
                thing.code_relation = code_relation
                thing.maintenance_type = maintenance_type
                thing.us_event = us_event
                thing.event_desc = event_desc
                thing.total = total
                thing.total_percent = total_percent
                
                
            }
            
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            
            
        }
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloaded(comments)
        })
        
    }
    
    
    
}




