//
//  ViewController.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/12/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//
//First page


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
    
    @IBOutlet weak var creditsButton: UIButton!
    
    let sharedData = ShareData.sharedInstance

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtons() //buttons style
        
        //option one...gets specific with which iphone/ipad and version 
        enum UIUserInterfaceIdiom : Int
        {
            case unspecified
            case phone
            case pad
        }
        
        struct ScreenSize
        {
            static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
            static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
            static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
            static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        }
        
        struct DeviceType
        {
            static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
            static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
            static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
            static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
            static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
            static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
        }
        
        struct Version{
            static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
            static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
            static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
            static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
        }
      
       

        if DeviceType.IS_IPHONE_6P {
            print("IS_IPHONE_6P")
        }
            //....
        else if DeviceType.IS_IPHONE_5{
            print("IS_IPHONE_5")
        }
        
        
        //option two...doesn't get into the specifics, just if iphone vs. ipad
      
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

