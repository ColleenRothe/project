//
//  MapboxOnline.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 4/3/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//getting data form homeModel:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

//mapbox help:
//https://www.mapbox.com/ios-sdk/examples/marker/
//https://www.mapbox.com/ios-sdk/examples/annotation-views/
//https://www.mapbox.com/ios-sdk/examples/marker-image/

//mapbox offline functionality:
//https://www.mapbox.com/ios-sdk/examples/offline-pack/


//core data:
//https://www.raywenderlich.com/115695/getting-started-with-core-data-tutorial



import Foundation
import UIKit
import Mapbox
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}



class MapboxOnline: ViewController, pinModelHelperProtocol, getPercentilesProtocol, HomeModel2Protocol, MGLMapViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    var feedItems: NSArray = NSArray()          //feed for pin info
    var otherFeed: NSArray = NSArray()          //feed for percentiles
    var offFeed: NSArray = NSArray()            //feed for offline site info
    let shareData = ShareData.sharedInstance
    var imagename = ""                          //used to set image of each pin when online
    var tf: UITextField = UITextField()         //text fields for user coord. input
    var tf2: UITextField = UITextField()
    var tf3: UITextField = UITextField()
    var tf4: UITextField = UITextField()
    var nelat = 0.00000                         //values for user coord. input
    var nelong = 0.0000
    var swlat = 0.00000
    var swlong = 0.0000
    var count = 0;                              //count of how many pins in the offline section
    var sites = [NSManagedObject]()             //core data sites
    let homeModel = HomeModel2()                 //new home model....pin info for offline save
    var ids : [String] = []
    
    //nav bar...for sizing
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    @IBOutlet weak var cacheMapButton: UIBarButtonItem!
    
    
    @IBOutlet weak var clearCacheButton: UIBarButtonItem!
    
    @IBOutlet weak var cacheStatusButton: UIBarButtonItem!
    
    @IBOutlet weak var loadOfflineButton: UIBarButtonItem!
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    
    //var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    //check progress of downloading cache
    var progressView = UIProgressView(progressViewStyle: .default)
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        //edit site?
        shareData.edit_site = false
        
        let frames = CGRect(x: 20, y:100, width: (view.frame.size.width-100), height: 50)
        progressView.frame = frames
        progressView.setProgress(0, animated: true)
        
        //activityIndicator.hidesWhenStopped = true
        //activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        //activityIndicator.center = view.center
        
        //offline or online?
        shareData.offline = false
        shareData.offline_edit = false
        
        //pins
        let pinmh = pinModelHelper()
        pinmh.delegate = self
        pinmh.downloadItems()
        
        //percentiles
        let percentiles = getPercentiles()
        percentiles.delegate = self
        percentiles.downloadItems()
        
        //offline pin info
        homeModel.delegate = self
        
        //offline functionality
        mapView.maximumZoomLevel = 15  //Have to include this...pick a good number //7
        mapView.minimumZoomLevel = 3
        
        mapView.delegate=self
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(39.7392, -104.9903)
        
        //register for download progress updates by observing offline pack notifications that come from NSNotification Center
        NotificationCenter.default.addObserver(self, selector: #selector(MapboxOnline.offlinePackProgressDidChange(_:)), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapboxOnline.offlinePackDidReceiveError(_:)), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapboxOnline.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
    }
    
    //pin model helper protocol
    func itemsDownloaded(_ items: NSArray){
        feedItems = items

    }
    
    //percentiles protocol
    func itemsDownloaded1(_ items: NSArray) {
        otherFeed = items
        shareData.rockfall_twenty_five = (otherFeed.object(at: 0) as! percentilesModel).rockfall_twenty_five!
        shareData.rockfall_fifty = (otherFeed.object(at: 0) as! percentilesModel).rockfall_fifty!
        shareData.rockfall_seventy_five = (otherFeed.object(at: 0) as! percentilesModel).rockfall_seventy_five!
        
        shareData.landslide_twenty_five = (otherFeed.object(at: 0) as! percentilesModel).landslide_twenty_five!
        shareData.landslide_fifty = (otherFeed.object(at: 0) as! percentilesModel).landslide_fifty!
        shareData.landslide_seventy_five = (otherFeed.object(at: 0) as! percentilesModel).landslide_seventy_five!
        
    }
    
    //annotation...
    func itemsDownloaded2(_ items: NSArray) {
        offFeed = items
        print("OffFeed")
        print(offFeed.count)
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        //sizing based on screensize...
        if shareData.device == "iPad"{
            let font = UIFont(name: "Times New Roman", size: 15)
            
            homeButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            cacheMapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            clearCacheButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            cacheStatusButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            loadOfflineButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            infoButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
   
        }
        else{ //phone
            let font = UIFont(name: "Times New Roman", size: 9)
            
            homeButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            cacheMapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            clearCacheButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            cacheStatusButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            loadOfflineButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            infoButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())

            
        }
        
        //for all of the pins....
        for i in 0 ..< feedItems.count {
            var tempTotal = 0
            imagename = ""
            //get the pin model at the feed item index
            let selectedLocation = feedItems.object(at: i) as! pinModel
            var poiCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
            //get the coordinates
            poiCoordinates.latitude = CDouble(selectedLocation.coordinate1!)!
            poiCoordinates.longitude = CDouble(selectedLocation.coordinate2!)!
            //get the total
            tempTotal = Int(selectedLocation.total!)!
            //It's a landslide
            if Int(selectedLocation.hazard_rating_landslide_id!)! > 0{
                if tempTotal <= Int(shareData.landslide_twenty_five){
                    imagename = "GreenLandslide"
                }else if tempTotal <= Int(shareData.landslide_fifty){
                    imagename = "YellowLandslide"
                }else if tempTotal <= Int(shareData.landslide_seventy_five){
                    imagename = "OrangeLandslide"
                }else{
                    imagename = "RedLandslide"
                }
                
            }else{ //it's a rockfall
                if tempTotal <= Int(shareData.rockfall_twenty_five){
                    imagename = "GreenRockfall"
                }else if tempTotal <= Int(shareData.rockfall_fifty){
                    imagename = "YellowRockfall"
                }else if tempTotal <= Int(shareData.rockfall_seventy_five){
                    imagename = "OrangeRockfall"
                }else{
                    imagename = "RedRockfall"
                }
                
            }
            
            //make a new pin
            let pin: MGLPointAnnotation = MGLPointAnnotation()
            pin.coordinate = poiCoordinates
            mapView.addAnnotation(pin) //add pin to the map
            pin.title = selectedLocation.site_id
            pin.subtitle = selectedLocation.id! + "\n" + imagename
            //pin.subtitle = "Total Score:" + selectedLocation.total! + "\n" + imagename
            count = count + 1 //try to reduce crashes?
            
        }
    }
    
    //add the extra info button
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    //tapped the info button...
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        print("description is")
        print(annotation.description)
        //set the current side id
        shareData.current_site_id = (annotation.title)!!
        //set the current id
        var string = annotation.subtitle
        //offline vs. online
        if((string??.characters.count)! > 5){
        let finding: Character =  "\n"
        let found = string??.characters.index(of: finding)
        let pos = string??.characters.distance(from: (string??.startIndex)!, to: found!)
        //pos = pos!-1
        let index = string??.index((string??.startIndex)!, offsetBy: pos!)
        string = string??.substring(to:index!)
        }
        print("STRING SHOULD BE")
        print(string!!)
        shareData.current_clicked_id = string!!
        //it's a rockfall...know what type of form to pull up
        if(annotation.description.contains("Rockfall")){
            shareData.editType = "rockfall"

        }
        //its a landslide...know what type of form to pull up
        else if(annotation.description.contains("Landslide")){
            shareData.editType = "landslide"
        }
        
        //go to the right form
        self.performSegue(withIdentifier: "getInfo2", sender: self)
        
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing annotation image, if it exists
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: imagename)
        
        if annotationImage == nil {
            var image = UIImage(named: imagename)! //problem happens here!!
            image = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the  annotation image with the UIImage just loaded
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imagename)
        }
        
        return annotationImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Always try to show a callout when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    //MARK: Offline Functionality
    
    @IBAction func saveMap(_ sender: AnyObject) {
        //only can save the map if they are zoomed-in pretty far relative to the maximum zoom level
        if(mapView.zoomLevel >= 13){ //set close to the maximum zoom level
            offline1()
        }else{
            let alertController = UIAlertController(title: "Warning", message: "Please zoom-in farther before saving map tiles", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func clearCache(_ sender: AnyObject) {
        offline5()

    }
    
  @IBAction func getStatus(_ sender: AnyObject) {
        offline3()
 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    func offlinePackProgressDidChange(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            //number of resources completely downloaded and are ready to use offline.
            let completed = progress.countOfResourcesCompleted
            //At the beginning of a download, this count is a lower bound; the number of expected resources may increase as the download progresses.
            let expected = progress.countOfResourcesExpected
            print("Offline pack “\(userInfo["name"])” has downloaded \(completed) of \(expected) resources.")
            
            //for the progress bar
            if(completed < expected/4){
                progressView.setProgress(30, animated: true)
            }
            else if(completed < (expected/2)){
                progressView.setProgress(50, animated: true)
            }
            else if(completed < (expected / (4/3))){
            progressView.setProgress(70, animated: true)
            }
            
            else if expected == completed{
                progressView.setProgress(100, animated: true)
                
                //call function that handles core data implementation for save
                offline1Helper()
                print("done!")
                //message to tell user that th download is complete
                let alertController = UIAlertController(title: "Complete", message: "Map Downloaded", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    //offline pack funcs
    func offlinePackDidReceiveError(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = (notification as NSNotification).userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }
    
    func offlinePackDidReceiveMaximumAllowedMapboxTiles(_ notification: Notification) {
        print("max tile error")
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = ((notification as NSNotification).userInfo?[MGLOfflinePackMaximumCountUserInfoKey] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }
    
    //text fields for user to enter coordinates
    func configurationTextField(_ textField: UITextField!){
        textField.placeholder = "NE corner lat. ##.#####)"
        tf = textField
        tf.text = String(mapView.visibleCoordinateBounds.ne.latitude)
    }
    
    func configurationTextField2(_ textField: UITextField!){
        textField.placeholder = "NE corner long. -###.##### "
        tf2 = textField
        tf2.text = String(mapView.visibleCoordinateBounds.ne.longitude)

    }
    
    func configurationTextField3(_ textField: UITextField!){
        textField.placeholder = "SW corner lat. ##.#####)"
        tf3 = textField
        tf3.text = String(mapView.visibleCoordinateBounds.sw.latitude)

    }
    
    func configurationTextField4(_ textField: UITextField!){
        textField.placeholder = "SW corner long. -###.#####"
        tf4 = textField
        tf4.text = String(mapView.visibleCoordinateBounds.sw.longitude)

    }
    
    //save map...core data implementation in helper
    func offline1(){
        //if they press the cancel button...do nothing
        func handleCancel(_ alertView: UIAlertAction!)
        {
            print("Cancelled !!")
        }
        
        //if they press done...process the input
        func handleDone(_ alertView:UIAlertAction!){
           
            
            nelat = Double(tf.text!)!
            nelong = Double(tf2.text!)!
            swlat = Double(tf3.text!)!
            swlong = Double(tf4.text!)!
         
            //create the two coordinates
            let neCorner = CLLocationCoordinate2D(latitude: nelat, longitude: nelong)
            let swCorner = CLLocationCoordinate2D(latitude: swlat, longitude: swlong)
            let bounds = MGLCoordinateBounds(sw: swCorner, ne: neCorner)
          
            //if the point is in the offline box....
            print("count is")
            print(count)
            for p in 0...(count - 1) {
                
                if((mapView.annotations![p].coordinate.latitude > swlat) && (mapView.annotations![p].coordinate.latitude < nelat) && (mapView.annotations![p].coordinate.longitude > swlong) && (mapView.annotations![p].coordinate.longitude < nelong)){
                    
                    //download for this specific site...
                    shareData.current_site_id = (mapView.annotations![p].title!)!
                    //add it to the list of ids in the box
                    ids.append(shareData.current_site_id)
                    shareData.offIds.append(shareData.current_site_id)
                    
                } //end if
                
            }//end for...
            
            
            homeModel.downloadItems()
          
            self.view.addSubview(progressView)

            //let the user know that download is in progress
            let alertController = UIAlertController(title: "In Progress", message: "Download Beginning", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil) //may be an issue?
            
            //create region based on what the user inputs....
            let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: bounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: mapView.maximumZoomLevel)
            
            
            // Store some data for identification purposes alongside the downloaded resources.
            let userInfo = ["name": "My New Offline Pack"]
            let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
            
            // Create and register an offline pack with the shared offline storage object.
            MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
                guard error == nil else {
                    // The pack couldn’t be created for some reason.
                    //self.activityIndicator.stopAnimating()
                    self.progressView.progress = 0

                    return
                }
                
                // Start downloading.
                pack!.resume()
                                        }
        }
        
        //alert for user input....
        let alert = UIAlertController(title: "Coordinates", message: "Corner coordinates for saved map area", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addTextField(configurationHandler: configurationTextField2)
        alert.addTextField(configurationHandler: configurationTextField3)
        alert.addTextField(configurationHandler: configurationTextField4)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: handleDone))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    //core data implementation for save
    func offline1Helper(){
        print("helper 1")
        var z = 0; //increment for the core data pull
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "OfflineSite", in:managedContext)
  
        //random crash point....
        if(count > 0){
        
        //problem when sometimes count is 0....error message to redo
        for p in 0...(count - 1) {
            if((mapView.annotations![p].coordinate.latitude > swlat) && (mapView.annotations![p].coordinate.latitude < nelat) && (mapView.annotations![p].coordinate.longitude > swlong) && (mapView.annotations![p].coordinate.longitude < nelong)){
        
                //if a pin is in the box...save it
                let site = NSManagedObject(entity: entity!, insertInto: managedContext)
               
                let selectedLocation = offFeed.object(at: z) as! OfflineModel //0
                z=z+1
        
                site.setValue(selectedLocation.site_id, forKey: "siteID")
                site.setValue(selectedLocation.id, forKey: "id")
                site.setValue(mapView.annotations![p].coordinate.latitude, forKey: "latitude")
                site.setValue(mapView.annotations![p].coordinate.longitude, forKey: "longitude")
                
                //to get correct pin image when offline
                var imageString = ""
                if((mapView.annotations![p].subtitle!! as String).contains("RedRockfall")){
                    imageString = "RedRockfall"
                }else  if((mapView.annotations![p].subtitle!! as String).contains("YellowRockfall")){
                    imageString = "YellowRockfall"
                }else  if((mapView.annotations![p].subtitle!! as String).contains("OrangeRockfall")){
                    imageString = "OrangeRockfall"
                }else  if((mapView.annotations![p].subtitle!! as String).contains("GreenRockfall")){
                    imageString = "GreenRockfall"
                }else  if((mapView.annotations![p].subtitle!! as String).contains("RedLandslide")){
                    imageString = "RedLandslide"
                }else if((mapView.annotations![p].subtitle!! as String).contains("YellowLandslide")){
                    imageString = "YellowLandslide"
                } else if((mapView.annotations![p].subtitle!! as String).contains("OrangeLandslide")){
                    imageString = "OrangeLandslide"
                }else{
                    imageString = "GreenLandslide"
                }
                
                site.setValue((imageString), forKey: "imagename")
                
                //rest of core data stuff loaded from database for each point...
                
                
//                print("selected location site id")
//                print(selectedLocation.site_id)
              
                
                site.setValue(selectedLocation.date, forKey:"date")
                //site.setValue(selectedLocation.slope_status, forKey:"slopeStatus")
                site.setValue(selectedLocation.mgmt_area, forKey:"managementArea")
                site.setValue(selectedLocation.road_trail_no, forKey: "roadTrailNo")
                site.setValue(selectedLocation.begin_mile_marker, forKey: "beginMile")
                site.setValue(selectedLocation.end_mile_marker, forKey: "endMile")
                site.setValue(selectedLocation.side, forKey: "side")
                site.setValue(selectedLocation.hazard_type, forKey: "hazardType")
                site.setValue(selectedLocation.prelim_rating, forKey: "prelimRating")
                site.setValue(selectedLocation.photos, forKey: "photos")
                site.setValue(selectedLocation.comments, forKey: "comments")
                site.setValue(selectedLocation.total_score, forKey: "totalScore")
                site.setValue(selectedLocation.coordinates, forKey:"coordinates")
               
                //deal with images...
              
                let photo_string = selectedLocation.photos
                var pics: [String] = []
                
                let fullArray = photo_string!.components(separatedBy: ",")
                
                for j in 0 ..< fullArray.count{
                    let mid = fullArray[j]
                    pics.append(mid )
                }
             
                //crashes if no pictures...
                var max = 10  //only 10 image attributes in the core data model
                if(pics.count<10){
                    max = pics.count
                }
                
                for p in 0 ..< max{
                if(pics[p] != ""){
                        let path = pics[p]
                        let urlPath: String = "http://nl.cs.montana.edu/usmp_media/photo_thumbnails/\(path)"
                        let url: URL = URL(string: urlPath)!
                        let data = try? Data(contentsOf: url)
                        let num = p+1
                        site.setValue(data, forKey: "image\(num)")
                    
                    
                }
                }
                
                
                do {
                    try managedContext.save()
                    progressView.setProgress(100, animated: true)

                    //5
                    sites.append(site)
                } catch let error as NSError  {
                    progressView.setProgress (0, animated: true)


                    print("Could not save \(error), \(error.userInfo)")
                }
                
                
                
            }
        }
        }//end if >0
        else{
            let alertController = UIAlertController(title: "Error", message: "Problem with download. Please clear and retry", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }
        
    }
    
    
    //In the iOS SDK, the MGLOfflineStorage’s packs property contains a canonical list of valid offline packs:
    //check the status
    func offline3(){
        var messageString = "Nothing Saved"
        
        for pack in MGLOfflineStorage.shared().packs! {
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as! [String: String]
            print("\(userInfo["name"])")
            print("state is")
            print(pack.state.rawValue)
            
            if(pack.state.rawValue == 1){
                messageString = "Inactive. Clearing, then you can resave"
                offline5()
            }
            else if(pack.state.rawValue == 2){
                messageString = "Active...download in progress"
            }
            else if(pack.state.rawValue == 3){
                messageString = "Download Complete"
            }
            else if(pack.state.rawValue == 4 || pack.state.rawValue == 0){
                messageString = "Invalid. Clearing, then you can resave"
                offline5()
            }
            
        }
        //let the user know the status
        let alertController = UIAlertController(title: "Status", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil) //may be an issue?
        
    }
    
    
    //remove offline pack
    func offline5(){
        //let user know the removal is beginning
        let alertController1 = UIAlertController(title: "Status", message: "Beginning Removal", preferredStyle: UIAlertControllerStyle.alert)
        alertController1.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController1, animated: true, completion: nil) //may be an issue?
        
        
        //CORE DATA STUFF
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        sites.removeAll()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSite")
        
        do {
            let fetched =
                try managedContext.fetch(fetchRequest)
           
            for entity in fetched{
                managedContext.delete(entity as! NSManagedObject)
            }
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        do{
            try managedContext.save()
        } catch{
            //error
        }
        
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSiteFull")
        
        do {
            let fetched2 =
                try managedContext.fetch(fetchRequest2)
            
            for entity2 in fetched2{
                managedContext.delete(entity2 as! NSManagedObject)
            }
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        do{
            try managedContext.save()
        } catch{
            //error
        }
        
        

        
        for pack in MGLOfflineStorage.shared().packs!{
            MGLOfflineStorage.shared().removePack(pack) { (error) in
                guard error == nil else {
                    // The pack couldn’t be removed for some reason.
                    let alertController = UIAlertController(title: "Error", message: "Unsuccessful Removal", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil) //may be an issue?
                    
                    
                    return
                }
                
                // The pack has been removed successfully.
                print("the pack has been removed successfully")
                let alertController = UIAlertController(title: "Complete", message: "Successful Removal", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil) //may be an issue?
                
                
            }
            //if no packs...
            
        }
        
        
    }
    
    @IBAction func loadOffline(_ sender: AnyObject) {
   
        var messageString = ""
        //offline or online?

        shareData.offline = true
        
        for pack in MGLOfflineStorage.shared().packs! {
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as! [String: String]
            print("\(userInfo["name"])")
            print("state is")
            print(pack.state.rawValue)
            
            //not a complete pack...can't load
            if(pack.state.rawValue != 3){
                //message to user
                messageString = "Invalid or Empty Download. Clear Cache and Redo"
                let alertController = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil) //may be an issue?
            }
            
        }//end for pack...
        if MGLOfflineStorage.shared().packs?.count == 0 {
            //messaeg to user
            messageString = "Invalid or Empty Download. Clear Cache and Redo"
            let alertController = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil) //may be an issue?
            
        }
        
        //CORE DATA STUFF...add pins/data to the map
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSite")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            
            print("load offline count is")
            print(sites.count)
            
            for pz in 0 ..< sites.count{
                
                let pp: MGLPointAnnotation = MGLPointAnnotation() //make a new point
 
                
                //set lat/long
                pp.coordinate.latitude = sites[pz].value(forKey: "latitude")! as! Double
                pp.coordinate.longitude = sites[pz].value(forKey: "longitude")! as! Double
                //set title
                pp.title = sites[pz].value(forKey: "siteID")! as? String
                //set the subtitle to have the id and the image name (helps with type)
                var subtitleString = sites[pz].value(forKey: "id")! as? String
                subtitleString = subtitleString?.appending("\n")
                subtitleString = subtitleString?.appending((sites[pz].value(forKey: "imagename")! as? String)!)
                pp.subtitle = subtitleString
                //set the imagename
                imagename = (sites[pz].value(forKey: "imagename")! as? String)!
                
                //add to the map
                mapView.addAnnotation(pp)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
}

