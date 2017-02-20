
//
//  getPercentiles.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 3/20/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

protocol getPercentilesProtocol: class{
    func itemsDownloaded1 (_ items: NSArray)
}

class getPercentiles: NSObject, URLSessionDataDelegate{
    
    weak var delegate: getPercentilesProtocol?
    
    var data: NSMutableData = NSMutableData()
    
    //or wherever the php service lives...
    //let urlPath: String = "http://nl.cs.montana.edu/usmp/colleen/percentiles.php"
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/percentiles.php"
    
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
            print("Percentiles Data Downloaded")
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
        let comments : NSMutableArray = NSMutableArray()
        
        //loop through JSON objects, store them in NSDictionary object to split into key-val pairs
                
        let thing = percentilesModel() //instantiate object to hold each element in the spec. JSON obj.
            
            if let rockfall_twenty_five = jsonResult[0] as? String, let rockfall_fifty = jsonResult[1] as? String, let rockfall_seventy_five = jsonResult[2] as? String, let landslide_twenty_five = jsonResult[3] as? String, let landslide_fifty = jsonResult[4] as? String, let landslide_seventy_five = jsonResult[5] as? String {
                
                
                
                thing.rockfall_twenty_five = rockfall_twenty_five
                thing.rockfall_fifty = rockfall_fifty
                thing.rockfall_seventy_five = rockfall_seventy_five
                
                thing.landslide_twenty_five = landslide_twenty_five
                thing.landslide_fifty = landslide_fifty
                thing.landslide_seventy_five = landslide_seventy_five
                
            }
            
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            
        
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloaded1(comments)
        })
        
    }
    
    
    
}

