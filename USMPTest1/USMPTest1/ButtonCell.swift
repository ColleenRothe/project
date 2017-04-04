//
//  ButtonCell.swift
//  USMPTest1
//
//  Represents the top "navigation" buttons on the OfflineList.swift that
//  lets you select what type of saved forms you want to see listed
//
//  Created by Colleen Rothe on 6/7/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit

class ButtonCell: UITableViewCell{
    
    @IBOutlet weak var landslideButton: UIButton!
    
    @IBOutlet weak var rockfallButton: UIButton!
  
    @IBOutlet weak var slopeEventButton: UIButton!
    
    @IBOutlet weak var maintenanceButton: UIButton!
    
    let shareData = ShareData.sharedInstance

    //know what page you came from
    override func awakeFromNib() {
        if shareData.OfflineType == "landslide"{
        landslideButton.backgroundColor = UIColor.lightGray
        }
        
        if shareData.OfflineType == "rockfall"{
            rockfallButton.backgroundColor = UIColor.lightGray
        }
        
        if shareData.OfflineType == "slopeEvent"{
            slopeEventButton.backgroundColor = UIColor.lightGray
        }
        
        if shareData.OfflineType == "maintenance"{
            maintenanceButton.backgroundColor = UIColor.lightGray
        }
    }
    
    //know which page to go back to...based on where you came from
    @IBAction func goLandslide(_ sender: AnyObject) {
        shareData.OfflineType = "landslide"
    }
    
    @IBAction func goRockfall(_ sender: AnyObject) {
        shareData.OfflineType = "rockfall"
    }
    
    @IBAction func goNewSlope(_ sender: AnyObject) {
        shareData.OfflineType = "slopeEvent"
    }
    
    @IBAction func goMaintenance(_ sender: AnyObject) {
        shareData.OfflineType = "maintenance"
    }
  
}
