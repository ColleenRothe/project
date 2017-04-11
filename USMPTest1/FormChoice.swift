//
//  FormChoice.swift
//  USMPTest1
//
//  Corresponds to ViewController that lets you pick between landslide and rockfall forms
//
//  Created by Colleen Rothe on 4/15/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class FormChoice: UIViewController{

    let shareData = ShareData.sharedInstance

    //two main buttons to pick between forms
    @IBOutlet weak var landslidebutton: UIButton!
    
    @IBOutlet weak var rockfallButton: UIButton!
    
    //nav bar
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtons() //buttons style
        
        //not coming from the map, so can't be editing
        shareData.edit_site = false
        
        //nav bar button sizing based on ipad vs iphone
        if(shareData.device == "iPad"){
            let font = UIFont(name: "Times New Roman", size: 15)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            
        }else{
            
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
    
    //button styles
    func makeButtons(){
        
       //rockfall
        rockfallButton.layer.cornerRadius = 5
        rockfallButton.layer.borderWidth = 1
        rockfallButton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 1).cgColor
        
        //landslide
        landslidebutton.layer.cornerRadius = 5
        landslidebutton.layer.borderWidth = 1
        landslidebutton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 1).cgColor
        
    }
    
    @IBAction func goLandslide(_ sender: Any) {
        shareData.form = "landslide"
        
    }
    
    @IBAction func goRockfall(_ sender: Any) {
        shareData.form = "rockfall"
    }
    
    
}
