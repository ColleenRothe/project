//
//  OptionCell.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 8/15/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//to allow load of the alertController
//http://stackoverflow.com/questions/30483104/presenting-uialertcontroller-from-uitableviewcell
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}


class OptionCell: UITableViewCell{
    
    let sharedData = ShareData.sharedInstance
    
    var coreType = ""

    @IBOutlet weak var clearButton: UIButton!
  
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    //type of form
    override func awakeFromNib() {
        if(sharedData.OfflineType == "landslide"){
            coreType = "NewOfflineLandslide"
        }
        if(sharedData.OfflineType == "rockfall"){
            coreType = "NewOfflineRockfall"
        }
        if(sharedData.OfflineType == "slopeEvent"){
            coreType = "OfflineSlopeEvent"
        }
        if(sharedData.OfflineType == "maintenance"){
            coreType = "OfflineMaintenance"
        }
        
    }
    
    //go back to the right page
    @IBAction func goBack(_ sender: AnyObject) {
        if(sharedData.OfflineType == "landslide"){
            parentViewController!.performSegue(withIdentifier: "loadLandslide", sender: self)
            
        }
        if(sharedData.OfflineType == "rockfall"){
            parentViewController!.performSegue(withIdentifier: "loadRockfall", sender: self)
            
        }
        if(sharedData.OfflineType == "slopeEvent"){
            parentViewController!.performSegue(withIdentifier: "loadNewSlope", sender: self)
            
        }
        if(sharedData.OfflineType == "maintenance"){
            parentViewController!.performSegue(withIdentifier: "loadMaintenance", sender: self)
            
        }
    }
    //MARK: Load the right form
    func handleLoad(_ alertView:UIAlertAction!){
        if(sharedData.OfflineType == "landslide"){
            sharedData.load = true
            parentViewController!.performSegue(withIdentifier: "loadLandslide", sender: self)
       
        }
        if(sharedData.OfflineType == "rockfall"){
            sharedData.load = true
            parentViewController!.performSegue(withIdentifier: "loadRockfall", sender: self)
            
        }
        if(sharedData.OfflineType == "slopeEvent"){
            sharedData.load = true
            parentViewController!.performSegue(withIdentifier: "loadNewSlope", sender: self)
            
        }
        if(sharedData.OfflineType == "maintenance"){
            sharedData.load = true
            parentViewController!.performSegue(withIdentifier: "loadMaintenance", sender: self)
            
        }
        
        
        
    }

    //user confirmation of load
    @IBAction func goLoad(_ sender: AnyObject) {
        if(sharedData.selectedForm < 0){ //in case they select the nav bar/option bar
            let alertController = UIAlertController(title: "Load", message: "Invalid Selection. Try Again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            parentViewController!.present(alertController, animated: false, completion: nil)
        }else{
        let alertController = UIAlertController(title: "Load", message: "Are you sure you want to load form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Load", style: UIAlertActionStyle.default, handler: handleLoad))
        parentViewController!.present(alertController, animated: true, completion: nil)
    
    }
    }
    
    //MARK: Clear form from core data
    func handleDone(_ alertView:UIAlertAction!){
        
        let number = sharedData.selectedForm
      
            //need to delete previously saved...to start a new saved site
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: coreType, in:managedContext)
            
        
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: coreType)
            
            do {
                let fetched =
                    try managedContext.fetch(fetchRequest)
                let itemToDelete = fetched[number]
                
                for entity in fetched{
                    managedContext.delete(itemToDelete as! NSManagedObject)
                }
                
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            do{ //user message
                try managedContext.save()
                let alertController = UIAlertController(title: "Status", message: "Cleared", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                parentViewController!.present(alertController, animated: false, completion: nil)
               
            } catch{
                //error
            }
    }

    //user message, confirming clear
    @IBAction func goClear(_ sender: AnyObject) {
        if(sharedData.selectedForm < 0){ //in case they select the nav bar/option bar
            let alertController = UIAlertController(title: "Clear?", message: "Invalid Selection. Try Again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            parentViewController!.present(alertController, animated: false, completion: nil) //may be an issue?
        }else{
        print("TRYING TO CLEAR")
        let alertController = UIAlertController(title: "Clear?", message: "Are you sure you want to clear the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.default, handler: handleDone))
        parentViewController!.present(alertController, animated: false, completion: nil)
        }
        
    }
    
    //MARK: Submit
    
    func handleSaved(_ alertView:UIAlertAction!){
        //clear...then submit 
        
    }
    
    func handleSubmitAll(_ alertView:UIAlertAction!){
        //clear...then submit
        
    }
    func handleAll(_ alertView:UIAlertAction!){
        //clear...then submit
        let alertController = UIAlertController(title: "Submit All?", message: "Are you sure you want to submit ALL saved forms of this type?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmitAll))
        parentViewController!.present(alertController, animated: true, completion: nil)
        
    }
    
    //user message, confirming submit
    @IBAction func goSubmit(_ sender: AnyObject) {
        if(sharedData.selectedForm < 0){ //in case they select the nav bar/option bar
            let alertController = UIAlertController(title: "Submit", message: "Invalid Selection. Try Again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            parentViewController!.present(alertController, animated: false, completion: nil) //may be an issue?
        }else{

        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit All", style: UIAlertActionStyle.default, handler: handleAll))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSaved))
        
        parentViewController!.present(alertController, animated: true, completion: nil)
        }
        
    }
}
