//
//  SiteListModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 12/2/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

class SiteListModel: NSObject {
    
    
    var ids = NSArray()
    
    override init(){
        
    }
    
    
    init(ids: NSArray){
        
        self.ids = ids
    }
    
    
    
}
