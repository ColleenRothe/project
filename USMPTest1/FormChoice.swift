//
//  FormChoice.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 4/15/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//
// Choose between Landslide and Rockfall Form

//TO CHECK CONNECTIVITY
//http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10

import Foundation
import UIKit
import SystemConfiguration

class FormChoice: UIViewController{

    let shareData = ShareData.sharedInstance

    
    @IBOutlet weak var landslidebutton: UIButton!
    
    @IBOutlet weak var rockfallButton: UIButton!
    
    //nav bar
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    @IBOutlet weak var accountButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtons() //buttons style
        
        shareData.edit_site = false
        
        if(shareData.device == "iPad"){
            let font = UIFont(name: "Times New Roman", size: 15)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            accountButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            
        }else{
            
            let font = UIFont(name: "Times New Roman", size: 9)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            accountButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
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
    
    func handleSubmit(_ alertView:UIAlertAction!){
        print("SUBMITTING NOW")
    }

    //message to user confirming submit
    @IBAction func submitAll(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit All?", message: "Are you sure you want to submit ALL saved Rockfall & Landslide forms?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)
    }
}
