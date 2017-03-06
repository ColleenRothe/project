//
//  AnnotationModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 2/28/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class AnnotationModel: NSObject {
    
    var id : String?
    var site_id : String?
    var coordinates : String?
    var date: String?
    var umbrella_agency: String?
    var road_trail_no : String?
    var begin_mile_marker : String?
    var end_mile_marker: String?
    var side: String?
    var hazard_type: String?
    var prelim_rating : String?
    var total_score: String?
    var photos: String?  
    var comments: String?
    var hazard_rating_rockfall_id : String?
    var hazard_rating_landslide_id : String?
    
    

    override init(){
        
    }
    
    
    init(id: String, site_id: String, coordinates: String, date: String, umbrella_agency: String, road_trail_no: String, begin_mile_marker: String, end_mile_marker: String, side: String, hazard_type: String, prelim_rating: String, total_score: String, photos: String, comments: String, hazard_rating_rockfall_id: String, hazard_rating_landslide_id: String){
     
        self.id = id
        self.site_id = site_id
        self.coordinates = coordinates
        self.date = date
        self.umbrella_agency = umbrella_agency
        self.road_trail_no = road_trail_no
        self.begin_mile_marker = begin_mile_marker
        self.end_mile_marker = end_mile_marker
        self.side = side
        self.hazard_type = hazard_type
        self.prelim_rating = prelim_rating
        self.total_score = total_score
        self.photos = photos
        self.comments = comments
        self.hazard_rating_rockfall_id = hazard_rating_rockfall_id
        self.hazard_rating_landslide_id = hazard_rating_landslide_id
        
        
    }
    
    
    
        //override var description
   
    
}
