//
//  SiteListModel.swift
//  USMPTest1
//
//  Object that holds ids for SiteListModelHelper.swift, used by MaintenanceForm.swift
//
//  Created by Colleen Rothe on 12/2/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//CREDITS:
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class SiteListModel: NSObject {
    
    //array of possible site ids
    var ids = NSArray()
    
    override init(){
        
    }
    
    init(ids: NSArray){
        
        self.ids = ids
    }
}
