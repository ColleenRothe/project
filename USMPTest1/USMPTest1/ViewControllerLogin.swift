//
//  ViewControllerLogin.swift
//  USMPTest1
//
//  Corresponds to ViewController for the Login Page
//
//  Created by Colleen Rothe on 11/12/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

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
    
    var email = ""
    var password  = ""
    var permissionList = [String]()
    var login = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //list of available permissions options
        permissionList.append("0")
        permissionList.append("1")
        permissionList.append("2")
        
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
        //save user input
        email = usernameText.text!
        password = passwordText.text!
        
        //they must enter something to be considered
        if (email == "" || password == ""){
            welcomeLabel.text = "Please fill in username and password"
        }
        else{
            helper();
        }
        
    }
    
    //authentication code
    func helper(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/initial_login.php")! as URL)
        request.httpMethod = "POST"
        
        //post their email and password
        let postString = "email=\(email)&password=\(password)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            
            //change "2" -> 2
            responseString = responseString.replacingOccurrences(of: "\"", with:"")
            //if this a valid permission
            if(self.permissionList.contains(responseString)){
                //set permission level in singleton
                shareData.level = Int(responseString)!
                self.goLogin()
            }
            else{
                self.errorLogin()
            }
        }
        task.resume()
    }
    
    //user can login
    func goLogin(){
        OperationQueue.main.addOperation {
        //loginSegue to VConlineHome
        self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        
    }
    
    //bad login info
    func errorLogin(){
        OperationQueue.main.addOperation {
            self.welcomeLabel.text = "Error. Incorrect username or password"
        }
    }
}
