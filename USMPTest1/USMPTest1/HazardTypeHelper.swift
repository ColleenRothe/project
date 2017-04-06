//
//  HazardTypeHelper.swift
//  USMPTest1
//
//  Gets list of possible hazard type options from the db
//
//  Created by Colleen Rothe on 4/5/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

import Foundation
import Foundation

protocol HazardTypeHelperProtocol: class{
    func itemsDownloadedH (_ items: NSArray)
}

class HazardTypeHelper: NSObject, URLSessionDataDelegate{
    
    weak var delegate: HazardTypeHelperProtocol?
    
    var data: NSMutableData = NSMutableData()
    
    //or wherever the php service lives...
    let urlPath: String = "http://nl.cs.montana.edu/usmp/server/shared/get_hazard_type_dropdown_options.php"
    
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
            print("Failed to download Hazard Type")
        } else {
            print("Hazard Type Data Downloaded")
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
        print("Hazard JSON RESULT IS")
        print(jsonResult)

        //add current object to mutable array, ready to be sent to VC via protocol
        
        //pass comments array to protocol method, make available for VC use
        DispatchQueue.main.async(execute: { ()->Void in self.delegate!.itemsDownloadedH(jsonResult)
        })
    }
}

