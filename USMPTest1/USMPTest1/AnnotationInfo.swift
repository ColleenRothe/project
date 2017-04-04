//
//  AnnotationInfo.swift
//  USMPTest1
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


    
    
    @IBOutlet weak var site_idLabel: UILabel!
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var slope_statusLabel: UILabel!
    
    @IBOutlet weak var management_areaLabel: UILabel!
    
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
    
    @IBOutlet weak var hazard_rating_rockfall_idLabel: UILabel!
    
    @IBOutlet weak var hazard_rating_landslide_idLabel: UILabel!
    
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
        
        
        
        //delegates and initialize homeModel
        ///
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        
        
        print("offline/onlinestatus...")
        if(shareData.offline == true){
            print("true....offline")
            makeTableOffline()

        }
        if(shareData.offline == false){
            print("false....online")
            homeModel.downloadItems()
        }
        
        let font = UIFont(name: "Times New Roman", size: 10)
        
        //fixes the alert controllers resizing the nav bar when dismissed
        
        mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloadedH(_ items: NSArray){
        feedItems = items
        self.listTableView.reloadData()
        makeTableOnline()
       
        
        
    }
    
    
    
    
    func makeTableOnline(){
        shareData.offline_edit = false
        
        let selectedLocation = feedItems.object(at: 0) as! AnnotationModel
        
            site_idLabel.text = "Site ID: \(selectedLocation.site_id!)"
        
            coordinatesLabel.text = "Coordinates: \(selectedLocation.coordinates!)"
        
            dateLabel.text = "Date: \(selectedLocation.date!)"
        
            //slope_statusLabel.text = "Slope Status: \(selectedLocation.slope_status!)"
        
            management_areaLabel.text = "Agency: \(selectedLocation.umbrella_agency!)"
        
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
        
        
        
        }
    
    func makeTableOffline(){
        shareData.offline_edit = true
        print("makeTableOffline1 site count")
        print(site.count)
        //need to delete from "site"?
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSite")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            site = results as! [NSManagedObject]
            
            print("makeTableOffline2 site count")
            print(site.count)
            
            for pz in 0 ..< site.count{
                print("pz value")
                print(pz)
                print(site[pz].value(forKey: "siteID"))
                
                //check if they match..when you click on a point saves the title to share/current id
                if site[pz].value(forKey: "siteID") as? String == shareData.current_site_id{
                    print("match")
                    
                  
                    
                    site_idLabel.text = "Site ID: \((site[pz].value(forKey: "siteID")! as? String)!)"
                    
                    coordinatesLabel.text = "Coordinates: \((site[pz].value(forKey: "coordinates") as? String)!)"
                    
                    dateLabel.text = "Date: \((site[pz].value(forKey: "date") as? String)!)"
                    
                    //slope_statusLabel.text = "Slope Status: \((site[pz].value(forKey: "slopeStatus") as? String)!)"
                    
                    management_areaLabel.text = "Agency: \((site[pz].value(forKey: "umbrella_agency") as? String)!)"
                    
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
                
                    
                    shareData.offline_edit_site_id = (site[pz].value(forKey: "siteID")! as? String)!

                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
    }
    
   
    
    @IBAction func editSite(_ sender: AnyObject) {
        print("CLICK EDIT")
        if(shareData.editType == "landslide"){
            shareData.edit_site = true
            self.performSegue(withIdentifier: "editLandslide", sender: self)
            
        }
        if(shareData.editType == "rockfall"){
            shareData.edit_site = true
            self.performSegue(withIdentifier: "editRockfall", sender: self)
            
        }
    }
    
        
}
