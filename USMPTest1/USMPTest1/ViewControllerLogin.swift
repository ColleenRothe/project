//
//  ViewControllerLogin.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/12/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//
//Login Page

import UIKit

class ViewControllerLogin: UIViewController, UITextFieldDelegate {
    //title
    @IBOutlet weak var headerButton: UIButton!
    //welcome message
    @IBOutlet weak var welcomeLabel: UILabel!
    //ask for username
    @IBOutlet weak var usernameLabel: UILabel!
    //container to hold everything
    @IBOutlet weak var containerView: UIView!
    //username textfield
    @IBOutlet weak var usernameText: UITextField!
    //password textfield
    @IBOutlet weak var passwordText: UITextField!
    //button to submit ->authenticate
    @IBOutlet weak var submitButton: UIButton!
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //submit button design
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 0).cgColor //none
        
        //container design
        containerView.layer.cornerRadius = 5
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.init(red: 0, green: 0.35, blue: 0.19, alpha: 0).cgColor //none
        
        //handle input thru delegate callbacks (self is class)
        usernameText.delegate = self
        passwordText.delegate = self
        
       

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    
    @IBAction func submitTap(_ sender: UIButton) {
        //authentication code
        
        //save user input
        let username = usernameText.text
        let password = passwordText.text
        
        if (username == "" || password == ""){
            welcomeLabel.text = "Incorrect username or password. Please try again."
        }
        
        //set if root, level1, or level2
        
        shareData.level = 2;
        
    }
    


}
