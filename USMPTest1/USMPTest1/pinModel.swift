//
//  pinModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/28/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//


//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class pinModel: NSObject {
    
    var id : String?
    var site_id : String?
    var coordinate1: String?
    var coordinate2: String?
    var total: String?
    var hazard_rating_rockfall_id : String?
    var hazard_rating_landslide_id : String?
    var imageName = "YellowLandslide"
    var prelimRating : String?
    
    override init(){
        
    }
    
    
    init(id: String, site_id: String, coordinate1: String, coordinate2: String, total:String, hazard_rating_rockfall_id: String, hazard_rating_landslide_id: String, prelimRating: String){
        
        self.id = id
        self.site_id = site_id
        self.coordinate1 = coordinate1
        self.coordinate2 = coordinate2
        self.total = total
        self.hazard_rating_rockfall_id = hazard_rating_rockfall_id
        self.hazard_rating_landslide_id = hazard_rating_landslide_id
        self.prelimRating = prelimRating
                
    }
    
    
    
    //prints object's current state
    
//    override var description: String {
//        return "id: \(id), site_id: \(site_id), latitude: \(coordinate1), longitude: \(coordinate2)"
//        
//    }
    
}
