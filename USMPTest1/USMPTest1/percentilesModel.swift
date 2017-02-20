//
//  percentilesModel.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 3/20/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class percentilesModel: NSObject {
    
    var rockfall_twenty_five: String?
    var rockfall_fifty: String?
    var rockfall_seventy_five: String?
    var landslide_twenty_five: String?
    var landslide_fifty: String?
    var landslide_seventy_five: String?
    
    
    
    override init(){
        
    }
    
    
    init(rockfall_twenty_five: String, rockfall_fifty: String, rockfall_seventy_five: String, landslide_twenty_five: String, landslide_fifty: String, landslide_seventy_five: String ){
        
        self.rockfall_twenty_five = rockfall_twenty_five
        self.rockfall_fifty = rockfall_fifty
        self.rockfall_seventy_five = rockfall_seventy_five
        self.landslide_twenty_five = landslide_twenty_five
        self.landslide_fifty = landslide_fifty
        self.landslide_seventy_five = landslide_seventy_five
        
        
}
}