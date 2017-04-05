//
//  MaintenancePinModel.swift
//  USMPTest1
//
//  Object holds info from database used to place the maintenance form pins. Used by MaintenancePinModelHelper
//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class MaintenancePinModel: NSObject {
    
    var id: String?
    var site_id: String?
    var latitude: String?
    var longitude: String?
    var code_relation: String?
    var maintenance_type: String?
    var us_event : String?
    var event_desc: String?
    var total: String?
    var total_percent: String?
    
    override init(){
        
    }
    
    init(id: String, site_id: String, latitude: String, longitude: String, code_relation: String, maintenance_type: String, us_event: String, event_desc: String, total: String, total_percent: String){
        
        self.id = id
        self.site_id = site_id
        self.latitude = latitude
        self.longitude = longitude
        self.code_relation = code_relation
        self.maintenance_type = maintenance_type
        self.us_event = us_event
        self.event_desc = event_desc
        self.total = total
        self.total_percent = total_percent
        
    }
}
