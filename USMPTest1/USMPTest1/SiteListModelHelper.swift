//
//  SiteListModelHelper.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 12/1/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

protocol SiteListModelHelperProtocol: class{
    func itemsDownloadedSL (_ items: NSArray)
}

class SiteListModelHelper: NSObject, URLSessionDataDelegate{
    weak var delegate: SiteListModelHelperProtocol?
    
    var data: NSMutableData = NSMutableData()
    
    //or wherever the php service lives...
    let urlPath: String = "http://nl.cs.montana.edu/test_sites/colleen.rothe/get_site_ids.php"
    
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
            print("List Failed to download")
        } else {
            print("List Data Downloaded")
            self.parseJSON()
            
        }
}

    func parseJSON(){
        //var jsonResult: NSMutableArray = NSMutableArray()
        var jsonResult: NSArray = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print("SITE ERROR")  //PROBLEM!!
            print(error)
            
        }
        
        //jsonResult = NSMutableArray(array: jsonResult)
        
        var jsonElement: NSArray = NSArray()
        let comments : NSMutableArray = NSMutableArray()
        
        print("SITe LIST COUNT IS")
        print(jsonResult.count)
        
        jsonElement = jsonResult[0] as! NSArray
        //print("ELEMENT IS")
        //print(jsonElement)
        let thing = SiteListModel()
        let ids = jsonElement
        //let ids = jsonElement[0]
            
            //print("IDS ARE:")
            //print(ids)
            thing.ids = ids as! NSArray
            
            
            
        
        
        //loop through JSON objects, store them in NSDictionary object to split into key-val pairs
        //for(var i=0; i<jsonResult.count; i += 1)
//        for i in 0 .. <= jsonResult.count{
//            jsonElement = jsonResult[i] as! NSArray
//            let thing = SiteListModel() //instantiate object to hold each element in the spec. JSON obj.
//            
//            if let ids = jsonElement[0] as? [String] {
//                
//                    print("IDS ARE:")
//                    print(ids)
//                    thing.ids = ids
//           
//                
//
//            }
        
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
            
            
        //}
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedSL(comments)
        })
        
    }
    
    
    
}

