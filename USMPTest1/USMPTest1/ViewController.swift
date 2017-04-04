//
//  ViewController.swift
//  USMPTest1
//
//  Opening Page of the App
//
//  Created by Colleen Rothe on 11/12/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

//CREDITS:
//detecting device type
//http://stackoverflow.com/questions/24059327/detect-current-device-with-ui-user-interface-idiom-in-swift


import UIKit

class ViewController: UIViewController {
    
    //USMP title
    @IBOutlet weak var headerButton: UIButton!
    
    //online
    @IBOutlet weak var onlineButton: UIButton!
  
    //rating manual
    @IBOutlet weak var manualButton: UIButton!
    
    //credits
    @IBOutlet weak var creditsButton: UIButton!
    
    let sharedData = ShareData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtons() //buttons style
        
        //doesn't get into the specifics, just if iphone vs. ipad
      
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            sharedData.device = "iPad"
        case .phone:
            print("iPhone and iPod touch style UI")
            sharedData.device = "iPhone"
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeButtons (){
        //make rounded, with edge
        
        //online button
        onlineButton.layer.cornerRadius = 5
        onlineButton.layer.borderWidth = 1
        onlineButton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 1).cgColor
        
        //rating manual button
        manualButton.layer.cornerRadius = 5
        manualButton.layer.borderWidth = 1
        manualButton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 1).cgColor
        
        //credits button
        creditsButton.layer.cornerRadius = 5
        creditsButton.layer.borderWidth = 1
        creditsButton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 1).cgColor
    }
}

