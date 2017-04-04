//
//  SiteListModelHelper.swift
//  USMPTest1
//
//  Downloads the list of site ids for the maintenance forms
//
//  Created by Colleen Rothe on 12/1/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//CREDITS:
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

//MaintenanceForm.swift implements this
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

    //save the information in a site list model
    func parseJSON(){
        var jsonResult: NSArray = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print("SITE ERROR")  //PROBLEM!!
            print(error)
            
        }
                
        var jsonElement: NSArray = NSArray()
        let comments : NSMutableArray = NSMutableArray()
        
        jsonElement = jsonResult[0] as! NSArray

        let thing = SiteListModel()
        let ids = jsonElement

            thing.ids = ids 
        
            comments.add(thing) //add current object to mutable array, ready to be sent to VC via protocol
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedSL(comments)
        })
        
    }
}

