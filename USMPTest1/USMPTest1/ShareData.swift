//
//  ShareData.swift
//  USMPTest1
//
//  Singleton for the app
//
//  Created by Colleen Rothe on 12/30/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

import Foundation

//CREDITS:

//sharedata adapted from:
//http://stackoverflow.com/questions/25215476/how-do-you-pass-data-between-view-controllers-in-swift

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static let instance: ShareData = ShareData()
        }
        return Static.instance
    }

    var pageIndex : Int!   //might be able to get rid of this....depends on later implementations
    
    //to get correct annotation page
    var current_site_id : String = ""
    var photo_string : String = ""
    
    //login info
    var email : String = ""
    var password : String = ""
    
    //offline...
    var offIds: [String] = []
    var offline = false
    var OfflineType = "landslide" //landslide, rockfall, slopeEvent, maintenance
    var selectedForm = 0
    var load = false
    
    var editType = "" //to tell if you are editing a landslide or rockfall form...
    
    //device
    var device = "other"
    
    //maintenanceMap
    var fillMaintenance = false
    var maintenance_site = "0"
    
    //edit site
    var edit_site = false
    var current_clicked_id = ""
    var offline_edit = false
    var offline_edit_site_id = ""
    
    //login permissions
        //0=root, 1=level1, 2=level2
            //level 2 is read-only
    var level = 4;
    
    //slope rating
    var form = "landslide"  //or rockfall
    
    //when creating a new maintenance pin
    var maintenance_lat = ""
    var maintenance_long = ""
    
    
}
