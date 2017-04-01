//
//  OfflineList.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 6/7/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//
//Page to hold a list of forms saved offline

import Foundation
import UIKit
import CoreData

class OfflineList: UITableViewController{
    
    var sites = [NSManagedObject]()             //core data sites
    let shareData = ShareData.sharedInstance
    var selected = 0
    
     let stateOptions = ["Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Deleware", "Dist. of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virgin Islands", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming" ]

    
    override func viewDidLoad(){
      
        
        super.viewDidLoad()
        getData()
        print(shareData.OfflineType)
    }
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //pick the type of offline site
        var fetchTitle = ""
        if shareData.OfflineType == "landslide"{
            fetchTitle = "NewOfflineLandslide"
        }
        else if shareData.OfflineType == "rockfall"{
            fetchTitle = "NewOfflineRockfall"
            
        }
        else if shareData.OfflineType == "slopeEvent"{
            fetchTitle = "OfflineSlopeEvent"
            
        }
        else if shareData.OfflineType == "maintenance"{
            fetchTitle = "OfflineMaintenance"
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: fetchTitle)
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            sites = results as! [NSManagedObject] //
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }

        
        
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(sites.count > 0){
        return (sites.count + 2)
        }
        else{
            return 2 //no sites, still need the 'nav bar'
        }
    }
    
    //height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1){
            return 50
        }
        else{
            return 150
        }
    }
    
    //get the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineCell")! as! OfflineCell
        let buttonCell = tableView.dequeueReusableCell(withIdentifier: "returnToForm")
        let optionCell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")
      
        //always need this, even if no sites...for the buttons
        if((indexPath as NSIndexPath).row == 0){
            return buttonCell!
        }
        //if it's not the first row, site stuff
        else if((indexPath as NSIndexPath).row == 1){
            print("RETURN THAT OPTION CELL")
            return optionCell!
        }
        //if it's not the first row, it is a site
        else{
            
            let site = sites[(indexPath as NSIndexPath).row - 2]  //-1 because the row is +1 due to the nav bar
            
            let number = ((indexPath as NSIndexPath).row - 2)
                        cell.numLabel.text = "\(number)"
            
        //form type: Landslide and Rockfall
            //hazard type, management area, road/trail id, date of event
            if(shareData.OfflineType == "landslide" || shareData.OfflineType == "rockfall"){
                
                cell.labelOne.text = "Hazard Type:" + (site.value(forKey: "hazardType")! as! String) //as? String
                var agencyS = ""
                let agencyNum = (site.value(forKey: "agency")! as! NSObject) as! Int
                if(agencyNum  == 1){
                    agencyS = "FS"
                }else if(agencyNum == 2){
                    agencyS = "NPS"
                }else if (agencyNum == 3){
                    agencyS = "BLM"
                }else if (agencyNum == 4){
                    agencyS = "BIA"
                }
                cell.labelTwo.text = "Agency: "+agencyS
                cell.labelThree.text = "Road/Trail No:" + (site.value(forKey: "roadTrailNo")! as! String) //as? String
                
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.medium
                dateformatter.timeStyle = DateFormatter.Style.medium
                let dateVal = dateformatter.string(from: (site.value(forKey: "date")! as? Date)!)
                cell.labelFour.text = "Date:" + dateVal
            }
            //form type: New slope event form
                //hazard type, state, road/trail ID, date of event
            else if(shareData.OfflineType == "slopeEvent"){
                
                
                //hazard type
                if((site.value(forKey: "hazardType")! as! NSObject) as! Int == 3){
                    cell.labelOne.text = "Hazard Type: Snow Avalanche"
                }
                else if ((site.value(forKey: "hazardType")! as! NSObject) as! Int == 2){
                    cell.labelOne.text = "Hazard Type: Debris Flow"
                }
                else if((site.value(forKey: "hazardType")! as! NSObject) as! Int == 1){
                    cell.labelOne.text = "Hazard Type: Landslide"
                }
                else{
                    cell.labelOne.text = "Hazard Type: Rockfall"
                }
                
                let state = site.value(forKey: "state")! as! Int
                
                cell.labelTwo.text = "State:" + stateOptions[state]
                //road trail num.
                cell.labelThree.text = "Road/Trail No:" + (site.value(forKey: "roadTrailNo")! as! String) //as? String
                
                //date of event
                
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.medium
                dateformatter.timeStyle = DateFormatter.Style.none
                let dateVal = dateformatter.string(from: (site.value(forKey: "eventDate")! as? Date)!)
                cell.labelFour.text = "Event Date:" + dateVal
                
                
            }
            //form type: Maintenance Form
            //type of event, maintenance type, facility code etc.
            else if(shareData.OfflineType == "maintenance"){
                //type of event
                //if((site.value(forKey: "eventType")! as? NSObject) == 2){
                if((site.value(forKey: "eventType")! as? Int) == 2){
                    cell.labelOne.text = "Event Type:Slope Mitigation/Repair"
                }
                else if((site.value(forKey: "eventType")! as? Int) == 1){
                    cell.labelOne.text = "Event Type:Routine Maintenance"
                }
                else{
                    cell.labelOne.text = "Event Type:Recent Unstable Slope Event"
                }
                //maintenance type
                if((site.value(forKey: "maintenanceType")! as? Int) == 1){
                    cell.labelTwo.text = "Maint. Type:Repeat Maintenance(w/in 5 yrs)"
                }
                else{
                    cell.labelTwo.text = "Maint. Type:New Maintenance"
                }
                
                cell.labelThree.text = "Code:" + (site.value(forKey: "code")! as! String) //as? String
            }

            return cell
        }
    }
    
    //click on row in table to select that form for submit/load/clear
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)!")
        selected = (indexPath.row - 2)
        shareData.selectedForm = selected
    }
    
        
}
