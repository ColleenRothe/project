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
    //photos for the site
    var photo_string : String = ""
    
    //login info
    var email : String = ""
    var password : String = ""
    
    //offline...
    
    //list of offline ids
    var offIds: [String] = []
    //are you offline? t/f
    var offline = false
    //type of offline form
    var OfflineType = "landslide" //landslide, rockfall, slopeEvent, maintenance
    //selected form #
    var selectedForm = 0
    //are you loading a form?
    var load = false
    
    //are you editing a rockfall or landslide form?
    var editType = ""
    
    //device type
    var device = "other"
    
    //maintenanceMap
    
    //are you filling a maintenance form, or creating new?
    var fillMaintenance = false
    //site id of maintenance form
    var maintenance_site = "0"
    
    //edit site
    
    //editing a site?
    var edit_site = false
    //current site clicked on
    var current_clicked_id = ""
    //editing offline?
    var offline_edit = false
    //site id of form editing offline
    var offline_edit_site_id = ""
    
    //login permissions
        //0=root, 1=level1, 2=level2
            //level 2 is read-only
    var level = 4;
    
    //slope rating
        //what type?
    var form = "landslide"  //or rockfall
    
    //when creating a new maintenance pin
    var maintenance_lat = ""
    var maintenance_long = ""
    
    //press submit button from the list
    var off_submit = false
    
    
}
