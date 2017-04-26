//
//  AnnotationInfo.swift
//  USMPTest1
//
//  Corresponds for the View Controller shown when a user clicks on a
//  slope rating form on the main map. Shows selected rating info that
//  clients requested before going to the full form
//
//  Created by Colleen Rothe on 2/2/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import UIKit
import CoreData


class AnnotationInfo: UITableViewController, HomeModelProtocol  {
    //listTableView
    var feedItems: NSArray = NSArray()
    let shareData = ShareData.sharedInstance
    var sites = [NSManagedObject]()             //core data sites
    
    //UI Connections
    @IBOutlet weak var site_idLabel: UILabel!
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var road_trail_noLabel: UILabel!
    
    @IBOutlet var listTableView: UITableView!
    
    @IBOutlet weak var begin_mile_markerLabel: UILabel!
    
    @IBOutlet weak var end_mile_markerLabel: UILabel!
    
    @IBOutlet weak var sideLabel: UILabel!
    
    @IBOutlet weak var hazard_typeLabel: UILabel!
    
    @IBOutlet weak var prelim_ratingLabel: UILabel!
    
    @IBOutlet weak var total_scoreLabel: UILabel!
    
    @IBOutlet weak var photosLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var editSiteButton: UIButton!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    //offline func.
    var site = [NSManagedObject]()             //core data sites
    
    //nav bar
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        //create home model to hold information from db
        let homeModel = HomeModel()
        homeModel.delegate = self
        
        //if they are accessing the form while online
        if(shareData.offline == true){
            makeTableOffline()
        }
        //if they are accessing the form while offline
        if(shareData.offline == false){
            homeModel.downloadItems()
        }
        
        //resizing
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
    
    //catch info downloaded from the db (HomeModel.swift)
    func itemsDownloadedH(_ items: NSArray){
        feedItems = items
        self.listTableView.reloadData()
        //call make table online version
        makeTableOnline()
    }
    
    //fill table with info when user is online
    func makeTableOnline(){
        //they are online....
        shareData.offline_edit = false
        //annotation model holds the information saved from the db
        let selectedLocation = feedItems.object(at: 0) as! AnnotationModel
        
        //set the labels with the appropriate information downloaded
        
        print("selected site_id:")
        print(selectedLocation.site_id!)
        
        site_idLabel.text = "Site ID: \(selectedLocation.site_id!)"
        
        coordinatesLabel.text = "Coordinates: \(selectedLocation.coordinates!)"
        
        dateLabel.text = "Date: \(selectedLocation.date!)"
        
        road_trail_noLabel.text = "Road/Trail No: \(selectedLocation.road_trail_no!)"
        
        begin_mile_markerLabel.text = "Begin Mile Mark: \(selectedLocation.begin_mile_marker!)"
        
        end_mile_markerLabel.text = "End Mile Mark: \(selectedLocation.end_mile_marker!)"
        
        sideLabel.text = "Side: \(selectedLocation.side!)"
        
        hazard_typeLabel.text = "Hazard Type: \(selectedLocation.hazard_type!)"
        
        prelim_ratingLabel.text = "Prelim Rating: \(selectedLocation.prelim_rating!)"
        
        total_scoreLabel.text = "Total Score: \(selectedLocation.total_score!)"
        
        photosLabel.text = "Photos: \(selectedLocation.photos!)"
        
        commentsLabel.text = "Comments: \(selectedLocation.comments!)"
        
        shareData.photo_string = selectedLocation.photos!
        
        shareData.maintenance_site = selectedLocation.site_id!

    }
    
    //fill table when user is offline
    func makeTableOffline(){
        //edit is in offline mode
        shareData.offline_edit = true
        
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSite")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            site = results as! [NSManagedObject]
            
            
            for pz in 0 ..< site.count{
                
                //check if they match..when you click on a point saves the title to share/current id
                if site[pz].value(forKey: "siteID") as? String == shareData.current_site_id{
                    
                    //fill in labels with data saved in core data framework as type "OfflineSite"
                    
                    site_idLabel.text = "Site ID: \((site[pz].value(forKey: "siteID")! as? String)!)"
                    
                    coordinatesLabel.text = "Coordinates: \((site[pz].value(forKey: "coordinates") as? String)!)"
                    
                    dateLabel.text = "Date: \((site[pz].value(forKey: "date") as? String)!)"
                    
                    road_trail_noLabel.text = "Road/Trail No: \((site[pz].value(forKey: "roadTrailNo") as? String)!)"
                    
                    begin_mile_markerLabel.text = "Begin Mile Mark: \((site[pz].value(forKey: "beginMile") as? String)!)"
                    
                    end_mile_markerLabel.text = "End Mile Mark: \((site[pz].value(forKey: "endMile") as? String)!)"
                    
                    sideLabel.text = "Side: \((site[pz].value(forKey: "side") as? String)!)"
                    
                    hazard_typeLabel.text = "Hazard Type: \((site[pz].value(forKey: "hazardType") as? String)!)"
                    
                    prelim_ratingLabel.text = "Prelim Rating: \((site[pz].value(forKey: "prelimRating") as? String)!)"
                    
                    total_scoreLabel.text = "Total Score: \((site[pz].value(forKey: "totalScore") as? String)!)"
                    
                    photosLabel.text = "Photos: \((site[pz].value(forKey: "photos") as? String)!)"
                    
                    commentsLabel.text = "Comments: \((site[pz].value(forKey: "comments") as? String)!)"
                    
                    shareData.photo_string = (site[pz].value(forKey: "photos") as? String)!
                    
                    //id of the site you are editing
                    shareData.offline_edit_site_id = (site[pz].value(forKey: "siteID")! as? String)!
                    
                    shareData.maintenance_site = (site[pz].value(forKey: "siteID")! as? String)!
                    
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    //when you click to edit a site
    @IBAction func editSite(_ sender: AnyObject) {
        //it's a landslide form
        if(shareData.editType == "landslide"){
            shareData.edit_site = true
            shareData.form = "landslide"
            
        }
        //it's a rockfall form
        if(shareData.editType == "rockfall"){
            shareData.edit_site = true
            shareData.form = "rockfall"
            
        }
    }
    
    
}
