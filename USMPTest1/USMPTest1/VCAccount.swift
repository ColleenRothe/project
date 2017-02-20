//
//  VCAccount.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 5/27/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation

import UIKit



class VCAccount: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var permissionsPicker: UIPickerView!
    let permissionsOptions = ["Root", "Normal User", "Read Only"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareData.edit_site = false
        
        permissionsPicker.delegate = self
        permissionsPicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Picker Delegate Functions
    
    //one component each row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var components = 0
        
        if(pickerView .isEqual(permissionsPicker)){
            components = permissionsOptions.count;
        }
        return components
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView .isEqual(permissionsPicker)){
            return permissionsOptions[row]
        }
        
        else{
            return "error";
        }
        
        
        
    }


    
    @IBAction func changePassword(_ sender: AnyObject) {
    }
    
    @IBAction func addUser(_ sender: AnyObject) {
    }

    
    
}
