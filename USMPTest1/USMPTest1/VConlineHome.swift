//
//  VConlineHome.swift
//  USMPTest1
//
//  Corresponds to ViewController shown after they login
//
//  Created by Colleen Rothe on 11/23/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

import UIKit

class VConlineHome: UIViewController {
    
   //welcome message
    @IBOutlet weak var welcomeLabel: UILabel!
           
    //nav bar
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
        
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let shareData = ShareData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        //not editing(probs redundant)
        shareData.edit_site = false
        
        //iPad sizing
        if(shareData.device == "iPad"){
            let font = UIFont(name: "Times New Roman", size: 15)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())

        }else{
       //iPhone sizing
        let font = UIFont(name: "Times New Roman", size: 9)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        }
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

