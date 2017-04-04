//
//  NewSlopeEventForm.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 5/7/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//autocomplete:
//http://stackoverflow.com/questions/26885438/getting-autocomplete-to-work-in-swift

//core location:
//http://nshipster.com/core-location-in-ios-8/

//picking image from library
//http://stackoverflow.com/questions/4314405/how-can-i-get-the-name-of-image-picked-through-photo-library-in-iphone

//core data
//https://www.raywenderlich.com/115695/getting-started-with-core-data-tutorial

//internet connectivity
//http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10



import Foundation
import UIKit
import MapKit
import AssetsLibrary
import Photos
import CoreData
import SystemConfiguration
//import Pods_USMPTest1
import BSImagePicker


class NewSlopeEventForm: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate  {
    
    let shareData = ShareData.sharedInstance

    
    //nav bar
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var manualButton: UIBarButtonItem!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var todaysDateLabel: UILabel!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateTypePicker: UIPickerView!
    
    let dateTypeOptions = ["Known", "Approximately", "Unknown"]
    
    let hazardOptions = ["Rockfall", "Landslide", "Debris Flow", "Snow Avalanche"]
    
    @IBOutlet weak var hazardTypePicker: UIPickerView!
    
    let stateOptions = ["Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Deleware", "Dist. of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Marianas Islands", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virgin Islands", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming" ]
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    let rtOptions = ["Road", "Trail"]
    
    @IBOutlet weak var rtPicker: UIPickerView!
    
    let largestRockOptions = ["<3in. (baseball)", "<1ft. (basketbal)", "1-3ft (fits thru doorway)", ">3ft(thousands of lbs)"]
    
    @IBOutlet weak var largestRockPicker: UIPickerView!
    
    let estimatedVolumeOptions = ["<5ft^3(wheelbarrow)", "<2.5yd^3(pickup truck)", "<10yd^3(dump truck)", ">10yd^3(several dumptrucks"]
    
    @IBOutlet weak var estimatedVolumePicker: UIPickerView!
    
    //Description of event location
    
    @IBOutlet weak var aboveRoadTrailButton: UIButton!
    var checkedAboveRoadTrail = false
    
    @IBOutlet weak var belowRoadTrailButton: UIButton!
    var checkedBelowRoadTrail = false
    
    @IBOutlet weak var atCulvertButton: UIButton!
    var checkedAtCulvert = false
    
    @IBOutlet weak var aboveRiverButton: UIButton!
    var checkedAboveRiver = false
    
    @IBOutlet weak var aboveCoastButton: UIButton!
    var checkedAboveCoast = false
    
    @IBOutlet weak var burnedAreaButton: UIButton!
    var checkedBurnedArea = false
    
    @IBOutlet weak var deforestedSlopeButton: UIButton!
    var checkedDeforestedSlope = false
    
    @IBOutlet weak var urbanButton: UIButton!
    var checkedUrban = false
    
    @IBOutlet weak var mineButton: UIButton!
    var checkedMine = false
    
    @IBOutlet weak var retainingWallButton: UIButton!
    var checkedRetainingWall = false
    
    @IBOutlet weak var naturalSlopeButton: UIButton!
    var checkedNaturalSlope = false
    
    @IBOutlet weak var engineeredSlopeButton: UIButton!
    var checkedEngineeredSlope = false
    
    @IBOutlet weak var unknownButton: UIButton!
    var checkedUnknown = false
    
    @IBOutlet weak var otherButton: UIButton!
    var checkedOther = false
    
    //Possible cause of event
    @IBOutlet weak var rainButton: UIButton!
    var checkedRain = false
    
    @IBOutlet weak var thunderstormButton: UIButton!
    var checkedThunderstorm = false
    
    @IBOutlet weak var continuousRainButton: UIButton!
    var checkedContinuousRain = false
    
    @IBOutlet weak var hurricaneButton: UIButton!
    var checkedHurricane = false
    
    @IBOutlet weak var floodingButton: UIButton!
    var checkedFlooding = false
    
    @IBOutlet weak var snowfallButton: UIButton!
    var checkedSnowfall = false
    
    @IBOutlet weak var prolongedFreezingButton: UIButton!
    var checkedProlongedFreezing = false
    
    @IBOutlet weak var highTemperaturesButton: UIButton!
    var checkedHighTemperatures = false
    
    @IBOutlet weak var earthquakeButton: UIButton!
    var checkedEarthquake = false
    
    @IBOutlet weak var volcanicActivityButton: UIButton!
    var checkedVolcanicActivity = false
    
    @IBOutlet weak var leakingPipeButton: UIButton!
    var checkedLeakingPipe = false
    
    @IBOutlet weak var miningButton: UIButton!
    var checkedMining = false
    
    @IBOutlet weak var constructionButton: UIButton!
    var checkedConstruction = false
    
    @IBOutlet weak var damButton: UIButton!
    var checkedDam = false
    
    @IBOutlet weak var noObviousButton: UIButton!
    var checkedNoObvious = false
    
    @IBOutlet weak var unknownCuaseButton: UIButton!
    var checkedUnknownCause = false
    
    @IBOutlet weak var secondOtherButton: UIButton!
    var checkedSecondOther = false
    
    //other stuff
    
    @IBOutlet weak var latitudeText: UITextField!
    
    @IBOutlet weak var longitudeText: UITextField!
    
    let afterFailureOptions = ["Blocked", "Blocked, detours exist around failure", "Partially blocked, passable", "Ditch full of debris", "Route threatened by unstable slope"]
    
    @IBOutlet weak var afterFailurePicker: UIPickerView!
    
    let damagesOptions = ["No", "Yes"]
    
    @IBOutlet weak var damagesPicker: UIPickerView!
    
    let fallenRocksOptions = ["1", "2", "3-5", "5-10", "10+"]
    
    @IBOutlet weak var fallenRocksPicker: UIPickerView!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var imagesLabel: UILabel!
    
    @IBOutlet weak var observerNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var observerCommentsText: UITextView!
    
    @IBOutlet weak var roadTrailNoText: UITextField!
    
    @IBOutlet weak var beginMileText: UITextField!
    
    @IBOutlet weak var endMileText: UITextField!
    
    @IBOutlet weak var datumText: UITextField!
    
    @IBOutlet weak var lengthAffectedText: UITextField!
    
    @IBOutlet weak var damagesCommentsText: UITextView!
    
    //Images
    var images = [PHAsset]()

    
    
    
    
    //offline func.
    var sites = [NSManagedObject]()             //core data
    
    //help keep track of how many of that type of form are saved
    var counted = [NSManagedObject]()             //core data sites
    var saved = 0
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var submitSavedButton: UIButton!

    
    //text fields for alerts
    var clearNum: UITextField = UITextField()
    var loadNum: UITextField = UITextField()
    var savedNum: UITextField = UITextField()
    var clearString = ""
    var loadString = ""
    var savedString = ""

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //permissions!
        if(shareData.level == 2){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.gray
        }
        
        shareData.edit_site = false
        
        //fill in today's date
        let date1 = Date()
        let date = DateFormatter.localizedString(from: date1, dateStyle: .medium, timeStyle: .medium)
        todaysDateLabel.text = date
        
        shareData.OfflineType = "slopeEvent"

        
        //get user's current location
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        dateTypePicker.delegate = self
        dateTypePicker.dataSource = self
        
        hazardTypePicker.delegate = self
        hazardTypePicker.dataSource = self
        
        statePicker.delegate = self
        statePicker.dataSource = self
        
        rtPicker.delegate = self
        rtPicker.dataSource = self
        
        afterFailurePicker.delegate = self
        afterFailurePicker.dataSource = self
        
        damagesPicker.delegate = self
        damagesPicker.dataSource = self
        
        fallenRocksPicker.delegate = self
        fallenRocksPicker.dataSource = self
        
        largestRockPicker.delegate = self
        largestRockPicker.dataSource = self
        
        estimatedVolumePicker.dataSource = self
        estimatedVolumePicker.delegate = self
        
        roadTrailNoText.keyboardType = .decimalPad
        beginMileText.keyboardType = .decimalPad
        endMileText.keyboardType = .decimalPad
        lengthAffectedText.keyboardType = .numberPad
        phoneText.keyboardType = .phonePad
        emailText.keyboardType = .emailAddress
        
        observerNameText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
        beginMileText.delegate = self
        endMileText.delegate = self
        datumText.delegate = self
        latitudeText.delegate = self
        longitudeText.delegate = self
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 600, height: 6100) //set content size (= to view)
        
        if(shareData.device == "iPad"){
            let font = UIFont(name: "Times New Roman", size: 15)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            manualButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())

            
        }else{
            
            let font = UIFont(name: "Times New Roman", size: 9)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            manualButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        }
        
        if(shareData.load == true){
            //call special load method
            loadFromList()
        }
        
        if(!isInternetAvailable()){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.darkGray
        }

        
        //dismiss keyboard...
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewSlopeEventForm.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == observerNameText {
            textField.resignFirstResponder()
            emailText.becomeFirstResponder()
            return false
        }
        
        if textField == emailText {
            textField.resignFirstResponder()
            phoneText.becomeFirstResponder()
            return false
        }
        
        if textField == phoneText {
            textField.resignFirstResponder()
            observerCommentsText.becomeFirstResponder()
            return false
        }
        
        if textField == beginMileText {
            textField.resignFirstResponder()
            endMileText.becomeFirstResponder()
            return false
        }
        
        if textField == datumText {
            textField.resignFirstResponder()
            latitudeText.becomeFirstResponder()
            return false
        }
        
        if textField == latitudeText {
            textField.resignFirstResponder()
            longitudeText.becomeFirstResponder()
            return false
        }
        return true
    }
    
    //text field delegate func
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailText {
            let email = emailText.text
            if email?.range(of: "@") == nil{
                emailText.backgroundColor = UIColor.red
            }
            else{
                emailText.backgroundColor = UIColor.white
            }
        }
        
    }
    
    //one component each row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var components = 0
        if(pickerView .isEqual(dateTypePicker)){
            components = dateTypeOptions.count;
        }
        if(pickerView .isEqual(hazardTypePicker)){
            components = hazardOptions.count;
        }
        if(pickerView .isEqual(statePicker)){
            components = stateOptions.count;
        }
        if(pickerView .isEqual(rtPicker)){
            components = rtOptions.count;
        }
        if(pickerView .isEqual(afterFailurePicker)){
            components = afterFailureOptions.count;
        }
        if(pickerView .isEqual(damagesPicker)){
            components = damagesOptions.count;
        }
        if(pickerView .isEqual(fallenRocksPicker)){
            components = fallenRocksOptions.count;
        }
        if(pickerView .isEqual(largestRockPicker)){
            components = largestRockOptions.count;
        }
        if(pickerView .isEqual(estimatedVolumePicker)){
            components = estimatedVolumeOptions.count;
        }
        
     return components
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView .isEqual(dateTypePicker)){
            return dateTypeOptions[row]
        }
        
        if(pickerView .isEqual(hazardTypePicker)){
            return hazardOptions[row]
        }
        if(pickerView .isEqual(statePicker)){
            return stateOptions[row]
        }
        if(pickerView .isEqual(rtPicker)){
            return rtOptions[row]
        }
        if(pickerView .isEqual(afterFailurePicker)){
            return afterFailureOptions[row]
        }
        if(pickerView .isEqual(damagesPicker)){
            return damagesOptions[row]
        }
        if(pickerView .isEqual(fallenRocksPicker)){
            return fallenRocksOptions[row]
        }
        if(pickerView .isEqual(largestRockPicker)){
            return largestRockOptions[row]
        }
        if(pickerView .isEqual(estimatedVolumePicker)){
            return estimatedVolumeOptions[row]
        }


            
            
        else{
            return "error"
        }
        
        
    }
    
    //MARK: Autofill Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //limit to 6 significant digits based on stakeholder feedback
            latitudeText.text = String(format: "%f",locValue.latitude)
            longitudeText.text = String(format: "%f",locValue.longitude)
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
        print(error)
        
        let messageString = "Unable to retrieve location information. Error : \(error)"
        
        let alertController = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func getLocation(_ sender: AnyObject) {
        if CLLocationManager.authorizationStatus() == .denied {
            //print("denied")
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to auto-fill coordinates, please change your location services settings.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            //print("location!!")
            locationManager.requestLocation()
            
            
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //print("location!!")
            locationManager.requestLocation()
        }
        
    }
    

    
    //MARK: Description of event locations

    @IBAction func aboveRoadTrail(_ sender: AnyObject) {
        if checkedAboveRoadTrail == false{
            let image = UIImage(named: "checkmark")! as UIImage
            aboveRoadTrailButton.setImage(image, for: UIControlState())
            checkedAboveRoadTrail = true
          
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            aboveRoadTrailButton.setImage(image, for: UIControlState())
            checkedAboveRoadTrail = false

            
        }
    }
    
    @IBAction func belowRoadTrail(_ sender: AnyObject) {
        if checkedBelowRoadTrail == false{
            let image = UIImage(named: "checkmark")! as UIImage
            belowRoadTrailButton.setImage(image, for: UIControlState())
            checkedBelowRoadTrail = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            belowRoadTrailButton.setImage(image, for: UIControlState())
            checkedBelowRoadTrail = false
            
            
        }

    }
    
    @IBAction func atCulvert(_ sender: AnyObject) {
        if checkedAtCulvert == false{
            let image = UIImage(named: "checkmark")! as UIImage
            atCulvertButton.setImage(image, for: UIControlState())
            checkedAtCulvert = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            atCulvertButton.setImage(image, for: UIControlState())
            checkedAtCulvert = false
            
            
        }
        
        
    }
    
    @IBAction func aboveRiver(_ sender: AnyObject) {
        if checkedAboveRiver == false{
            let image = UIImage(named: "checkmark")! as UIImage
            aboveRiverButton.setImage(image, for: UIControlState())
            checkedAboveRiver = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            aboveRiverButton.setImage(image, for: UIControlState())
            checkedAboveRiver = false
            
            
        }
        
    }
    
    
    @IBAction func aboveCoast(_ sender: AnyObject) {
        if checkedAboveCoast == false{
            let image = UIImage(named: "checkmark")! as UIImage
            aboveCoastButton.setImage(image, for: UIControlState())
            checkedAboveCoast = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            aboveCoastButton.setImage(image, for: UIControlState())
            checkedAboveCoast = false
            
            
        }
        
        
    }
    
    @IBAction func burnedArea(_ sender: AnyObject) {
        if checkedBurnedArea == false{
            let image = UIImage(named: "checkmark")! as UIImage
            burnedAreaButton.setImage(image, for: UIControlState())
            checkedBurnedArea = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            burnedAreaButton.setImage(image, for: UIControlState())
            checkedBurnedArea = false
            
            
        }
        
        
    }
    
    
    @IBAction func deforestedSlope(_ sender: AnyObject) {
        if checkedDeforestedSlope == false{
            let image = UIImage(named: "checkmark")! as UIImage
            deforestedSlopeButton.setImage(image, for: UIControlState())
            checkedDeforestedSlope = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            deforestedSlopeButton.setImage(image, for: UIControlState())
            checkedDeforestedSlope = false
            
            
        }
        
        
    }
    
    @IBAction func urban(_ sender: AnyObject) {
        if checkedUrban == false{
            let image = UIImage(named: "checkmark")! as UIImage
            urbanButton.setImage(image, for: UIControlState())
            checkedUrban = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            urbanButton.setImage(image, for: UIControlState())
            checkedUrban = false
            
            
        }
        
        
    }
    
    @IBAction func mine(_ sender: AnyObject) {
        if checkedMine == false{
            let image = UIImage(named: "checkmark")! as UIImage
            mineButton.setImage(image, for: UIControlState())
            checkedMine = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            mineButton.setImage(image, for: UIControlState())
            checkedMine = false
            
            
        }
        
    }
    
    @IBAction func retainingWall(_ sender: AnyObject) {
        if checkedRetainingWall == false{
            let image = UIImage(named: "checkmark")! as UIImage
            retainingWallButton.setImage(image, for: UIControlState())
            checkedRetainingWall = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            retainingWallButton.setImage(image, for: UIControlState())
            checkedRetainingWall = false
            
            
        }
        
        
    }
    
    @IBAction func naturalSlope(_ sender: AnyObject) {
        if checkedNaturalSlope == false{
            let image = UIImage(named: "checkmark")! as UIImage
            naturalSlopeButton.setImage(image, for: UIControlState())
            checkedNaturalSlope = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            naturalSlopeButton.setImage(image, for: UIControlState())
            checkedNaturalSlope = false
            
            
        }
    }
    
    @IBAction func engineeredSlope(_ sender: AnyObject) {
        if checkedEngineeredSlope == false{
            let image = UIImage(named: "checkmark")! as UIImage
            engineeredSlopeButton.setImage(image, for: UIControlState())
            checkedEngineeredSlope = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            engineeredSlopeButton.setImage(image, for: UIControlState())
            checkedEngineeredSlope = false
            
            
        }

    }
    
    @IBAction func unknown(_ sender: AnyObject) {
        if checkedUnknown == false{
            let image = UIImage(named: "checkmark")! as UIImage
            unknownButton.setImage(image, for: UIControlState())
            checkedUnknown = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            unknownButton.setImage(image, for: UIControlState())
            checkedUnknown = false
            
            
        }
    }
    
    @IBAction func other(_ sender: AnyObject) {
        if checkedOther == false{
            let image = UIImage(named: "checkmark")! as UIImage
            otherButton.setImage(image, for: UIControlState())
            checkedOther = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            otherButton.setImage(image, for: UIControlState())
            checkedOther = false
            
            
        }
    }
    
    //MARK: Possible Cause of Event
    
    @IBAction func rain(_ sender: AnyObject) {
        if checkedRain == false{
            let image = UIImage(named: "checkmark")! as UIImage
            rainButton.setImage(image, for: UIControlState())
            checkedRain = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            rainButton.setImage(image, for: UIControlState())
            checkedRain = false
            
            
        }

        
    }
    
    
    @IBAction func thunderstorm(_ sender: AnyObject) {
        if checkedThunderstorm == false{
            let image = UIImage(named: "checkmark")! as UIImage
            thunderstormButton.setImage(image, for: UIControlState())
            checkedThunderstorm = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            thunderstormButton.setImage(image, for: UIControlState())
            checkedThunderstorm = false
            
            
        }

    }
    
    @IBAction func continuousRain(_ sender: AnyObject) {
        if checkedContinuousRain == false{
            let image = UIImage(named: "checkmark")! as UIImage
            continuousRainButton.setImage(image, for: UIControlState())
            checkedContinuousRain = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            continuousRainButton.setImage(image, for: UIControlState())
            checkedContinuousRain = false
            
            
        }

    }
    
    @IBAction func hurricane(_ sender: AnyObject) {
        if checkedHurricane == false{
            let image = UIImage(named: "checkmark")! as UIImage
            hurricaneButton.setImage(image, for: UIControlState())
            checkedHurricane = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            hurricaneButton.setImage(image, for: UIControlState())
            checkedHurricane = false
            
            
        }

    }
    
    @IBAction func flooding(_ sender: AnyObject) {
        if checkedFlooding == false{
            let image = UIImage(named: "checkmark")! as UIImage
            floodingButton.setImage(image, for: UIControlState())
            checkedFlooding = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            floodingButton.setImage(image, for: UIControlState())
            checkedFlooding = false
            
            
        }

    }
    
    @IBAction func snowfall(_ sender: AnyObject) {
        if checkedSnowfall == false{
            let image = UIImage(named: "checkmark")! as UIImage
            snowfallButton.setImage(image, for: UIControlState())
            checkedSnowfall = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            snowfallButton.setImage(image, for: UIControlState())
            checkedSnowfall = false
            
            
        }

    }
    
    @IBAction func prolongedFreezing(_ sender: AnyObject) {
        if checkedProlongedFreezing == false{
            let image = UIImage(named: "checkmark")! as UIImage
            prolongedFreezingButton.setImage(image, for: UIControlState())
            checkedSnowfall = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            prolongedFreezingButton.setImage(image, for: UIControlState())
            checkedProlongedFreezing = false
            
            
        }
        
    }
    
    @IBAction func highTemperatures(_ sender: AnyObject) {
        if checkedHighTemperatures == false{
            let image = UIImage(named: "checkmark")! as UIImage
            highTemperaturesButton.setImage(image, for: UIControlState())
            checkedHighTemperatures = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            highTemperaturesButton.setImage(image, for: UIControlState())
            checkedHighTemperatures = false
            
            
        }
    }
    
    @IBAction func earthquake(_ sender: AnyObject) {
        if checkedEarthquake == false{
            let image = UIImage(named: "checkmark")! as UIImage
            earthquakeButton.setImage(image, for: UIControlState())
            checkedEarthquake = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            earthquakeButton.setImage(image, for: UIControlState())
            checkedEarthquake = false
            
            
        }
    }
    
    @IBAction func volcanicActivity(_ sender: AnyObject) {
        if checkedVolcanicActivity == false{
            let image = UIImage(named: "checkmark")! as UIImage
            volcanicActivityButton.setImage(image, for: UIControlState())
            checkedVolcanicActivity = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            volcanicActivityButton.setImage(image, for: UIControlState())
            checkedVolcanicActivity = false
            
            
        }
    }
    
    @IBAction func leakingPipe(_ sender: AnyObject) {
        if checkedLeakingPipe == false{
            let image = UIImage(named: "checkmark")! as UIImage
            leakingPipeButton.setImage(image, for: UIControlState())
            checkedLeakingPipe = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            leakingPipeButton.setImage(image, for: UIControlState())
            checkedLeakingPipe = false
            
            
        }
    }
    
    @IBAction func mining(_ sender: AnyObject) {
        if checkedMining == false{
            let image = UIImage(named: "checkmark")! as UIImage
            miningButton.setImage(image, for: UIControlState())
            checkedMining = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            miningButton.setImage(image, for: UIControlState())
            checkedMining = false
            
            
        }
    }
    
    @IBAction func construction(_ sender: AnyObject) {
        if checkedConstruction == false{
            let image = UIImage(named: "checkmark")! as UIImage
            constructionButton.setImage(image, for: UIControlState())
            checkedConstruction = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            constructionButton.setImage(image, for: UIControlState())
            checkedConstruction = false
            
            
        }
    }
    
    @IBAction func dam(_ sender: AnyObject) {
        if checkedDam == false{
            let image = UIImage(named: "checkmark")! as UIImage
            damButton.setImage(image, for: UIControlState())
            checkedDam = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            damButton.setImage(image, for: UIControlState())
            checkedDam = false
            
            
        }
    }
    
    @IBAction func noObvious(_ sender: AnyObject) {
        if checkedNoObvious == false{
            let image = UIImage(named: "checkmark")! as UIImage
            noObviousButton.setImage(image, for: UIControlState())
            checkedNoObvious = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            noObviousButton.setImage(image, for: UIControlState())
            checkedNoObvious = false
            
            
        }
    }
    
    @IBAction func unknownCause(_ sender: AnyObject) {
        if checkedUnknownCause == false{
            let image = UIImage(named: "checkmark")! as UIImage
            unknownCuaseButton.setImage(image, for: UIControlState())
            checkedUnknownCause = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            unknownCuaseButton.setImage(image, for: UIControlState())
            checkedUnknownCause = false
            
            
        }
    }
    
    @IBAction func secondOther(_ sender: AnyObject) {
        if checkedSecondOther == false{
            let image = UIImage(named: "checkmark")! as UIImage
            secondOtherButton.setImage(image, for: UIControlState())
            checkedSecondOther = true
            
            
        }
        else{
            let image = UIImage(named: "unchecked")! as UIImage
            secondOtherButton.setImage(image, for: UIControlState())
            checkedSecondOther = false
            
            
        }
    }
    
    //MARK: Choose Images
    
    @IBAction func chooseImages(_ sender: AnyObject) {

        let vc = BSImagePickerViewController()
        var defaultAssetIds = [String]()

        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
            
            
        })
        
        //if there are some images saved...
        if(self.images.count != 0){
            for i in 0 ... self.images.count-1{
                if allAssets.contains(self.images[i]){ //if the images is one of all the assets
                    let index = allAssets.index(of: self.images[i]) //gets its index
                    defaultAssetIds.append(allAssets[index].localIdentifier) //add its identifier to the defaults
                    print("appending!")
                } //if
            } //for
        } //if
        
        
        let defaultSelected = PHAsset.fetchAssets(withLocalIdentifiers: defaultAssetIds, options: nil)
        vc.defaultSelections = defaultSelected
    
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
                                            //print("Selected: \(asset)")
                                            self.images.append(asset)
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
            let index = self.images.index(of: asset)
            self.images.remove(at: index!)
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
            self.images.removeAll()
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0 ... self.images.count-1{
                print(self.images[i])
            }
        }, completion: nil)
        
        
    }
    //image upload?
    func UploadRequest()
    {
        if(images.count != 0){
            for i in 0 ... (images.count-1){
                let url = NSURL(string: "http://nl.cs.montana.edu/usmp/server/new_slope_event/add_new_slope_event.php")
                
                let request = NSMutableURLRequest(url: url! as URL)
                request.httpMethod = "POST"
                
                let boundary = generateBoundaryString()
                
                //define the multipart request type
                
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: images[i], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                let imageData = thumbnail.lowQualityJPEGNSData
                thumbnail = UIImage(data: imageData as Data)!
                
                let image_data = UIImagePNGRepresentation(thumbnail)
                
                
                if(image_data == nil)
                {
                    return
                }
                
                
                let body = NSMutableData()
                
                var fname = images[i].localIdentifier //how to name?
                fname = fname.replacingOccurrences(of: "/", with: "")
                fname.append(".jpg")
                print("fname test")
                print(fname)
                let mimetype = "image/jpg"
                
                //define the data post parameter
                
                //if name is "file", will add as a document
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(fname)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(image_data!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                
                
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                
                
                
                request.httpBody = body as Data
                
                
                
                let session = URLSession.shared
                
                
                let task = session.dataTask(with: request as URLRequest) {
                    (
                    data, response, error) in
                    
                    guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                        print("error")
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(dataString)
                    
                }
                
                task.resume()
            }
            
        }
        
        
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }

    
 

    //MARK: Submit Form Online
    
    func handleSubmit(_ alertView:UIAlertAction!){
        //delete site from core data if submitted successfully...
        //let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8080/usmp/server/new_slope_event/add_new_slope_event.php")! as URL)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/usmp/server/new_slope_event/add_new_slope_event.php")! as URL)
        request.httpMethod = "POST"
        
        //new slope event
        //date_approximator
        var dateApproximatorS = ""
        if(dateTypePicker.selectedRow(inComponent: 0) == 1){
            dateApproximatorS = "Approximately"
        }
        else if (dateTypePicker.selectedRow(inComponent: 0) == 2){
            dateApproximatorS = "Unknown"
        }else{
            dateApproximatorS = "Known"
        }
        
        let dateFormatter = DateFormatter()
        let dateInput = dateFormatter.string(from: datePicker.date)
        let hazardI = hazardTypePicker.selectedRow(inComponent: 0)
        let hazardType = hazardOptions[hazardI]
        
        let state = stateOptions[statePicker.selectedRow(inComponent: 0)]
        var rt_type = "R"
        if(rtPicker.selectedRow(inComponent: 0)==1){
            rt_type = "T"
        }
        
        let condition = afterFailureOptions[afterFailurePicker.selectedRow(inComponent: 0)]
        let size_rock = largestRockOptions[largestRockPicker.selectedRow(inComponent: 0)]
        let num_fallen = fallenRocksOptions[fallenRocksPicker.selectedRow(inComponent: 0)]
        let estimated_volume = estimatedVolumeOptions[estimatedVolumePicker.selectedRow(inComponent: 0)]
        let damages = damagesOptions[damagesPicker.selectedRow(inComponent: 0)]

    
        //0=false, 1 = true
        //description of event location
        var c1 = 0
        var c2 = 0
        var c3 = 0
        var c4 = 0
        var c5 = 0
        var c6 = 0
        var c7 = 0
        var c8 = 0
        var c9 = 0
        var c10 = 0
        var c11 = 0
        var c12 = 0
        var c13 = 0
        var c14 = 0
        //possible cause of event
        var cc1 = 0
        var cc2 = 0
        var cc3 = 0
        var cc4 = 0
        var cc5 = 0
        var cc6 = 0
        var cc7 = 0
        var cc8 = 0
        var cc9 = 0
        var cc10 = 0
        var cc11 = 0
        var cc12 = 0
        var cc13 = 0
        var cc14 = 0
        var cc15 = 0
        var cc16 = 0
        var cc17 = 0
        
        if(checkedAboveRoadTrail == true){
            c1 = 1
        }
        if(checkedBelowRoadTrail == true){
            c2 = 1
        }
        if(checkedAtCulvert == true){
            c3 = 1
        }
        if(checkedAboveRiver == true){
            c4 = 1
        }
        if(checkedAboveCoast == true){
            c5 = 1
        }
        if(checkedBurnedArea == true){
            c6 = 1
        }
        if(checkedDeforestedSlope == true){
            c7 = 1
        }
        if(checkedUrban == true){
            c8 = 1
        }
        if(checkedMine == true){
            c9 = 1
        }
        if(checkedRetainingWall == true){
            c10 = 1
        }
        if(checkedNaturalSlope == true){
            c11 = 1
        }
        if(checkedEngineeredSlope == true){
            c12 = 1
        }
        if(checkedUnknown  == true){
            c13 = 1
        }
        if(checkedOther  == true){
            c14 = 1
        }
        
        if(checkedRain  == true){
            cc1 = 1
        }
        if(checkedThunderstorm == true){
            cc2 = 1
        }
        if(checkedContinuousRain  == true){
            cc3 = 1
        }
        if(checkedHurricane == true){
            cc4 = 1
        }
        if(checkedFlooding  == true){
            cc5 = 1
        }
        if(checkedSnowfall == true){
            cc6 = 1
        }
        if(checkedProlongedFreezing  == true){
            cc7 = 1
        }
        if(checkedHighTemperatures == true){
            cc8 = 1
        }
        if(checkedEarthquake == true){
            cc9 = 1
        }
        if(checkedVolcanicActivity == true){
            cc10 = 1
        }
        if(checkedLeakingPipe  == true){
            cc11 = 1
        }
        if(checkedMining == true){
            cc12 = 1
        }
        if(checkedConstruction  == true){
            cc13 = 1
        }
        if(checkedDam  == true){
            cc14 = 1
        }
        if(checkedNoObvious == true){
            cc15 = 1
        }
        if(checkedUnknownCause  == true){
            cc16 = 1
        }
        if(checkedSecondOther == true){
            cc17 = 1
        }
        
        
        
        let postString = "observer_name=\(observerNameText.text!)&email=\(emailText.text!)&phone_no=\(phoneText.text!)&observer_comments=\(observerCommentsText.text!)&date_approximator=\(dateApproximatorS)&dateinput=\(dateInput)&hazard_type=\(hazardType)&state=\(state)&rt_type=\(rt_type)&road_trail_number=\(roadTrailNoText.text!)&begin_mile_marker\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&datum=\(datumText.text!)&begin_coordinate_latitude=\(latitudeText.text!)&begin_coordinate_longitude=\(longitudeText.text!)&condition=\(condition)&affected_length=\(lengthAffectedText.text!)&size_rock=\(size_rock)&num_fallen_rocks=\(num_fallen)&vol_debris=\(estimated_volume)&above_road=\(c1)&below_road=\(c2)&at_culvert=\(c3)&above_river=\(c4)&above_coast=\(c5)&burned_area=\(c6)&deforested_slope=\(c7)&urban=\(c8)&mine=\(c9)&retaining_wall=\(c10)&natural_slope=\(c11)&engineered_slope=\(c12)&unknown=\(c13)&other=\(c14)&rain_checkbox=\(cc1)&thunder_checkbox=\(cc2)&cont_rain_checkbox=\(cc3)&hurricane_checkbox=\(cc4)&flood_checkbox=\(cc5)&snowfall_checkbox=\(cc6)&freezing_checkbox=\(cc7)&high_temp_checkbox=\(cc8)&earthquake_checkbox=\(cc9)&volcano_checkbox=\(cc10)&leaky_pipe_checkbox=\(cc11)&mining_checkbox=\(cc12)&construction_checkbox=\(cc13)&dam_embankment_checkbox=\(cc14)&not_obvious_checkbox=\(cc15)&unknown_checkbox=\(cc16)&other_checkbox=\(cc17)&damages_y_n=\(damages)&damages=\(damagesCommentsText.text!)"
        
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
        }
        task.resume()

        
        //add message confirming submission...
        UploadRequest()
        
    }
    
    
    @IBAction func submit(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)
        

    }
    
    //MARK: submit saved form(s)
    
    func configurationSavedTextField(_ textField: UITextField!){
        textField.placeholder = "0"
        savedNum = textField
    }
    
    func handleSaved(_ alertView:UIAlertAction!){
        //delete site from core data if submitted successfully...
        //add message confirming submission...
        savedString = savedNum.text!
        if((savedNum.text! =~ "(?:6[0-4]|[1-5]\\d|[1-9])(?: *- *(?:6[0-4]|[1-5]\\d|[1-9]))?(?: *, *(?:6[0-4]|[1-5]\\d|[1-9])(?: *- *(?:6[0-4]|[1-5]\\d|[1-9]))?)*$") == false){
            submitSaved(submitSavedButton)
        }
        
    }
    
    @IBAction func submitSaved(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit Saved Form(s)", message: "Enter Form Numbers Seperated by Comma (Ex: 1,3,5-8,10)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: configurationSavedTextField)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSaved))
        
        present(alertController, animated: true, completion: nil) //may be an issue?
        

    }
    
    //MARK: save offline sites
    
    @IBAction func saveOffline(_ sender: AnyObject) {
        print("save offline")
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "OfflineSlopeEvent", in:managedContext)
        let site = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        site.setValue(observerNameText.text, forKey: "observerName")
        site.setValue(emailText.text, forKey: "email")
        site.setValue(phoneText.text, forKey: "phone")
        site.setValue(observerCommentsText.text, forKey: "observerComments")
        site.setValue(todaysDateLabel.text, forKey: "todaysDate")
        //EVENT DATE
        site.setValue(datePicker.date, forKey: "eventDate")
            
        //3 options
        let selectedDateType = dateTypePicker.selectedRow(inComponent: 0)
        site.setValue(selectedDateType, forKey: "dateType")

        //hazard type - 4 options
        let selectedHazard = hazardTypePicker.selectedRow(inComponent: 0)
        site.setValue(selectedHazard, forKey: "hazardType")
        
        //state - 56 options
        let selectedState = statePicker.selectedRow(inComponent: 0)
        site.setValue(selectedState, forKey: "state")
    
        //pictures
        
        var defaultAssetIds = [String]()
        
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
            
            
        })
        
        //if there are some images saved...
        if(self.images.count != 0){
            for i in 0 ... self.images.count-1{
                if allAssets.contains(self.images[i]){ //if the images is one of all the assets
                    let index = allAssets.index(of: self.images[i]) //gets its index
                    defaultAssetIds.append(allAssets[index].localIdentifier) //add its identifier to the defaults
                    print("appending!")
                } //if
            } //for
        } //if
        
        
        site.setValue(defaultAssetIds, forKey:"photos")
       
        
        //site.setValue(imagesLabel.text, forKey:"photos")
        
        site.setValue(roadTrailNoText.text, forKey: "roadTrailNo")

        //road or trail? - 2 options
        let selectedRT = rtPicker.selectedRow(inComponent: 0)
        site.setValue(selectedRT, forKey: "roadOrTrail")

        site.setValue(beginMileText.text, forKey: "beginMile")
        site.setValue(endMileText.text, forKey: "endMile")
        
        //size of largest fallen rock - 4 options
        let selectedLargest = largestRockPicker.selectedRow(inComponent: 0)
        site.setValue(selectedLargest, forKey: "largestRock")

        //estimated volume of debris - 4 options
        let selectedVolume = estimatedVolumePicker.selectedRow(inComponent: 0)
        site.setValue(selectedVolume, forKey: "debrisVolume")

        //MARK: Description of Event Location
        
        if(checkedAboveRoadTrail == true){
            site.setValue(true, forKey: "lAbove")
        }
        else{
            site.setValue(false, forKey: "lAbove")
        }
        
        if(checkedBelowRoadTrail == true){
            site.setValue(true, forKey: "lBelow")
        }
        else{
            site.setValue(false, forKey: "lBelow")
        }
        if(checkedAtCulvert == true){
            site.setValue(true, forKey: "lCulvert")
        }
        else{
            site.setValue(false, forKey: "lCulvert")
        }
        if(checkedAboveRiver == true){
            site.setValue(true, forKey: "lRiver")
        }
        else{
            site.setValue(false, forKey: "lRiver")
        }
        if(checkedAboveCoast == true){
            site.setValue(true, forKey: "lCoast")
        }
        else{
            site.setValue(false, forKey: "lCoast")
        }
        if(checkedBurnedArea == true){
            site.setValue(true, forKey: "lBurned")
        }
        else{
            site.setValue(false, forKey: "lBurned")
        }
        if(checkedDeforestedSlope == true){
            site.setValue(true, forKey: "lDeforested")
        }
        else{
            site.setValue(false, forKey: "lDeforested")
        }
        if(checkedUrban == true){
            site.setValue(true, forKey: "lUrban")
        }
        else{
            site.setValue(false, forKey: "lUrban")
        }
        if(checkedMine == true){
            site.setValue(true, forKey: "lMine")
        }
        else{
            site.setValue(false, forKey: "lMine")
        }
        if(checkedRetainingWall == true){
            site.setValue(true, forKey: "lRetaining")
        }
        else{
            site.setValue(false, forKey: "lRetaining")
        }
        if(checkedNaturalSlope == true){
            site.setValue(true, forKey: "lNatural")
        }
        else{
            site.setValue(false, forKey: "lNatural")
        }
        if(checkedEngineeredSlope == true){
            site.setValue(true, forKey: "lEngineered")
        }
        else{
            site.setValue(false, forKey: "lEngineered")
        }
        if(checkedUnknown == true){
            site.setValue(true, forKey: "lUnknown")
        }
        else{
            site.setValue(false, forKey: "lUnknown")
        }
        if(checkedOther == true){
            site.setValue(true, forKey: "lOther")
        }
        else{
            site.setValue(false, forKey: "lOther")
        }
        
        //MARK: Possible Cause of Event
        if(checkedRain == true){
            site.setValue(true, forKey: "cRain")
        }
        else{
            site.setValue(false, forKey: "cRain")
        }
        if(checkedThunderstorm == true){
            site.setValue(true, forKey: "cThunderstorm")
        }
        else{
            site.setValue(false, forKey: "cThunderstorm")
        }
        if(checkedContinuousRain == true){
            site.setValue(true, forKey: "cContinuous")
        }
        else{
            site.setValue(false, forKey: "cContinuous")
        }
        if(checkedHurricane == true){
            site.setValue(true, forKey: "cHurricane")
        }
        else{
            site.setValue(false, forKey: "cHurricane")
        }
        if(checkedFlooding == true){
            site.setValue(true, forKey: "cFlooding")
        }
        else{
            site.setValue(false, forKey: "cFlooding")
        }
        if(checkedSnowfall == true){
            site.setValue(true, forKey: "cSnowfall")
        }
        else{
            site.setValue(false, forKey: "cSnowfall")
        }
        if(checkedProlongedFreezing == true){
            site.setValue(true, forKey: "cProlonged")
        }
        else{
            site.setValue(false, forKey: "cProlonged")
        }
        if(checkedHighTemperatures == true){
            site.setValue(true, forKey: "cHigh")
        }
        else{
            site.setValue(false, forKey: "cHigh")
        }
        if(checkedEarthquake == true){
            site.setValue(true, forKey: "cEarthquake")
        }
        else{
            site.setValue(false, forKey: "cEarthquake")
        }
        if(checkedVolcanicActivity == true){
            site.setValue(true, forKey: "cVolcanic")
        }
        else{
            site.setValue(false, forKey: "cVolcanic")
        }
        if(checkedLeakingPipe == true){
            site.setValue(true, forKey: "cLeaking")
        }
        else{
            site.setValue(false, forKey: "cLeaking")
        }
        if(checkedMining == true){
            site.setValue(true, forKey: "cMining")
        }
        else{
            site.setValue(false, forKey: "cMining")
        }
        if(checkedConstruction == true){
            site.setValue(true, forKey: "cConstruction")
        }
        else{
            site.setValue(false, forKey: "cConstruction")
        }
        if(checkedDam == true){
            site.setValue(true, forKey: "cDam")
        }
        else{
            site.setValue(false, forKey: "cDam")
        }
        if(checkedNoObvious == true){
            site.setValue(true, forKey: "cNoObvious")
        }
        else{
            site.setValue(false, forKey: "cNoObvious")
        }
        if(checkedUnknownCause == true){
            site.setValue(true, forKey: "cUnknown")
        }
        else{
            site.setValue(false, forKey: "cUnknown")
        }
        if(checkedSecondOther == true){
            site.setValue(true, forKey: "cOther")
        }
        else{
            site.setValue(false, forKey: "cOther")
            
        }
            
        site.setValue(datumText.text, forKey: "datum")
        
        site.setValue(latitudeText.text, forKey: "lat")
        site.setValue(longitudeText.text, forKey: "long")
        
        //road trail condition after failure - 5 options
        let selectedCAFailure = afterFailurePicker.selectedRow(inComponent: 0)
        site.setValue(selectedCAFailure, forKey: "rtConditionAfter")
        
        site.setValue(lengthAffectedText.text, forKey: "lengthAffected")
        
        //damages? 2 options yes/no
        let selectedDamages = damagesPicker.selectedRow(inComponent: 0)
        site.setValue(selectedDamages, forKey: "deaths")  //no
        
        site.setValue(damagesCommentsText.text, forKey: "deathsComments")
        
        //number of fallen rocks - 5 options
        let selectedFallenRocks = fallenRocksPicker.selectedRow(inComponent: 0)
        site.setValue(selectedFallenRocks, forKey: "numFallen")

        //save to core data
        do {
            try managedContext.save()
            let alertController = UIAlertController(title: "Success", message: "Form Saved", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
            //5
            //sites.append(site)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Form Not Saved: \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?

        }
        
    }


    //MARK:LOAD offline site
    
    func loadFromList(){
        shareData.load = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSlopeEvent")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            
            let number = shareData.selectedForm
                    
                    observerNameText.text = sites[number].value(forKey: "observerName")! as? String
                    emailText.text = sites[number].value(forKey: "email")! as? String
                    phoneText.text = sites[number].value(forKey: "phone")! as? String
                    observerCommentsText.text = sites[number].value(forKey: "observerComments")! as? String
                    todaysDateLabel.text = sites[number].value(forKey: "todaysDate")! as? String
                    //DATE
                    
                    datePicker.date = (sites[number].value(forKey: "eventDate")! as? Date)!
                    
                    //date type - 3 options
                    let dateType = sites[number].value(forKey: "dateType")! as! NSObject as! Int
                    dateTypePicker.selectRow(dateType, inComponent: 0, animated: true)

                    //hazard type- 4 options
                    let hazardType = sites[number].value(forKey: "hazardType")! as! NSObject as! Int
                    hazardTypePicker.selectRow(hazardType, inComponent: 0, animated: true)

                    //state - 56 options
                    let state = sites[number].value(forKey: "state")! as! Int
                    statePicker.selectRow(state, inComponent:0, animated: true)
                    
                    //PICTURES
                    //imagesLabel.text = sites[number].value(forKey: "photos")! as? String
                    let photos = sites[number].value(forKey: "photos")! as! [String]
            
                    let photoResults = PHAsset.fetchAssets(withLocalIdentifiers: photos, options: nil)
            
                    for i in 0 ... photoResults.count-1{
                            images.append(photoResults.object(at: i))
                    }
            
                    roadTrailNoText.text = sites[number].value(forKey: "roadTrailNo")! as? String
                    
                    //road or trail? - 2 options
                    let rt = sites[number].value(forKey: "roadOrTrail")! as! NSObject as! Int
                    rtPicker.selectRow(rt, inComponent: 0, animated: true)
            
                    beginMileText.text = sites[number].value(forKey: "beginMile")! as? String
                    endMileText.text = sites[number].value(forKey: "endMile")! as? String
            
                    //size of largest fallen rock - 4 options
                    let largestRock = sites[number].value(forKey: "largestRock")! as! NSObject as! Int
                    largestRockPicker.selectRow(largestRock, inComponent: 0, animated: true)

                    //estimated volume of debris - 4 options
                    let estimatedVolume = sites[number].value(forKey: "debrisVolume")! as! NSObject as! Int
                    estimatedVolumePicker.selectRow(estimatedVolume, inComponent: 0, animated: true)

            
                    //MARK: Description of Event Locations
                    
                    if((sites[number].value(forKey: "lAbove")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        aboveRoadTrailButton.setImage(image, for: UIControlState())
                        checkedAboveRoadTrail = true
                        
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        aboveRoadTrailButton.setImage(image, for: UIControlState())
                        checkedAboveRoadTrail = false
                        
                    }
                    
                    if((sites[number].value(forKey: "lBelow")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        belowRoadTrailButton.setImage(image, for: UIControlState())
                        checkedBelowRoadTrail = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        belowRoadTrailButton.setImage(image, for: UIControlState())
                        checkedBelowRoadTrail = false
                    }
                    
                    if((sites[number].value(forKey: "lCulvert")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        atCulvertButton.setImage(image, for: UIControlState())
                        checkedAtCulvert = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        atCulvertButton.setImage(image, for: UIControlState())
                        checkedAtCulvert = false
                    }
                    
                    if((sites[number].value(forKey: "lRiver")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        aboveRiverButton.setImage(image, for: UIControlState())
                        checkedAboveRiver = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        aboveRiverButton.setImage(image, for: UIControlState())
                        checkedAboveRiver = false
                    }
                    
                    if((sites[number].value(forKey: "lCoast")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        aboveCoastButton.setImage(image, for: UIControlState())
                        checkedAboveCoast = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        aboveCoastButton.setImage(image, for: UIControlState())
                        checkedAboveCoast = false
                    }
                    if((sites[number].value(forKey: "lBurned")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        burnedAreaButton.setImage(image, for: UIControlState())
                        checkedBurnedArea = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        burnedAreaButton.setImage(image, for: UIControlState())
                        checkedBurnedArea = false
                    }
                    if((sites[number].value(forKey: "lDeforested")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        deforestedSlopeButton.setImage(image, for: UIControlState())
                        checkedDeforestedSlope = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        deforestedSlopeButton.setImage(image, for: UIControlState())
                        checkedDeforestedSlope = false
                    }
                    if((sites[number].value(forKey: "lUrban")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        urbanButton.setImage(image, for: UIControlState())
                        checkedUrban = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        urbanButton.setImage(image, for: UIControlState())
                        checkedUrban = false
                    }
                    if((sites[number].value(forKey: "lMine")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        mineButton.setImage(image, for: UIControlState())
                        checkedMine = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        mineButton.setImage(image, for: UIControlState())
                        checkedMine = false
                    }
                    if((sites[number].value(forKey: "lRetaining")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        retainingWallButton.setImage(image, for: UIControlState())
                        checkedRetainingWall = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        retainingWallButton.setImage(image, for: UIControlState())
                        checkedRetainingWall = false
                    }
                    if((sites[number].value(forKey: "lNatural")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        naturalSlopeButton.setImage(image, for: UIControlState())
                        checkedNaturalSlope = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        naturalSlopeButton.setImage(image, for: UIControlState())
                        checkedNaturalSlope = false
                    }
                    if(sites[number].value(forKey: "lEngineered")! as! Bool == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        engineeredSlopeButton.setImage(image, for: UIControlState())
                        checkedEngineeredSlope = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        engineeredSlopeButton.setImage(image, for: UIControlState())
                        checkedEngineeredSlope = false
                    }
                    if((sites[number].value(forKey: "lUnknown")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        unknownButton.setImage(image, for: UIControlState())
                        checkedUnknown = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        unknownButton.setImage(image, for: UIControlState())
                        checkedUnknown = false
                    }
                    if((sites[number].value(forKey: "lOther")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        otherButton.setImage(image, for: UIControlState())
                        checkedOther = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        otherButton.setImage(image, for: UIControlState())
                        checkedOther = false
                    }
                    
                    //MARK: Possible Cause of Event
                    
                    if((sites[number].value(forKey: "cRain")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        rainButton.setImage(image, for: UIControlState())
                        checkedRain = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        rainButton.setImage(image, for: UIControlState())
                        checkedRain = false
                    }
                    if((sites[number].value(forKey: "cThunderstorm")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        thunderstormButton.setImage(image, for: UIControlState())
                        checkedThunderstorm = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        thunderstormButton.setImage(image, for: UIControlState())
                        checkedThunderstorm = false
                    }
                    if((sites[number].value(forKey: "cContinuous")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        continuousRainButton.setImage(image, for: UIControlState())
                        checkedContinuousRain = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        continuousRainButton.setImage(image, for: UIControlState())
                        checkedContinuousRain = false
                    }
                    if((sites[number].value(forKey: "cHurricane")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        hurricaneButton.setImage(image, for: UIControlState())
                        checkedHurricane = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        hurricaneButton.setImage(image, for: UIControlState())
                        checkedHurricane = false
                    }
                    if((sites[number].value(forKey: "cFlooding")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        floodingButton.setImage(image, for: UIControlState())
                        checkedFlooding = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        floodingButton.setImage(image, for: UIControlState())
                        checkedFlooding = false
                    }
                    if((sites[number].value(forKey: "cSnowfall")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        snowfallButton.setImage(image, for: UIControlState())
                        checkedSnowfall = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        snowfallButton.setImage(image, for: UIControlState())
                        checkedSnowfall = false
                    }
                    if((sites[number].value(forKey: "cProlonged")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        prolongedFreezingButton.setImage(image, for: UIControlState())
                        checkedProlongedFreezing = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        prolongedFreezingButton.setImage(image, for: UIControlState())
                        checkedProlongedFreezing = false
                    }
                    if((sites[number].value(forKey: "cHigh")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        highTemperaturesButton.setImage(image, for: UIControlState())
                        checkedHighTemperatures = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        highTemperaturesButton.setImage(image, for: UIControlState())
                        checkedHighTemperatures = false
                    }
                    if((sites[number].value(forKey: "cEarthquake")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        earthquakeButton.setImage(image, for: UIControlState())
                        checkedEarthquake = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        earthquakeButton.setImage(image, for: UIControlState())
                        checkedEarthquake = false
                    }
                    if((sites[number].value(forKey: "cVolcanic")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        volcanicActivityButton.setImage(image, for: UIControlState())
                        checkedVolcanicActivity = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        volcanicActivityButton.setImage(image, for: UIControlState())
                        checkedVolcanicActivity = false
                    }
                    if((sites[number].value(forKey: "cLeaking")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        leakingPipeButton.setImage(image, for: UIControlState())
                        checkedLeakingPipe = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        leakingPipeButton.setImage(image, for: UIControlState())
                        checkedLeakingPipe = false
                    }
                    if((sites[number].value(forKey: "cMining")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        miningButton.setImage(image, for: UIControlState())
                        checkedMining = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        miningButton.setImage(image, for: UIControlState())
                        checkedMining = false
                    }
                    if((sites[number].value(forKey: "cConstruction")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        constructionButton.setImage(image, for: UIControlState())
                        checkedConstruction = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        constructionButton.setImage(image, for: UIControlState())
                        checkedConstruction = false
                    }
                    if((sites[number].value(forKey: "cDam")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        damButton.setImage(image, for: UIControlState())
                        checkedDam = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        damButton.setImage(image, for: UIControlState())
                        checkedDam = false
                    }
                    if((sites[number].value(forKey: "cNoObvious")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        noObviousButton.setImage(image, for: UIControlState())
                        checkedNoObvious = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        noObviousButton.setImage(image, for: UIControlState())
                        checkedNoObvious = false
                    }
                    if((sites[number].value(forKey: "cUnknown")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        unknownCuaseButton.setImage(image, for: UIControlState())
                        checkedUnknownCause = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        unknownCuaseButton.setImage(image, for: UIControlState())
                        checkedUnknownCause = false
                    }
                    if((sites[number].value(forKey: "cOther")! as! Bool) == true){
                        let image = UIImage(named: "checkmark")! as UIImage
                        secondOtherButton.setImage(image, for: UIControlState())
                        checkedSecondOther = true
                    }else{
                        let image = UIImage(named: "unchecked")! as UIImage
                        secondOtherButton.setImage(image, for: UIControlState())
                        checkedSecondOther = false
                    }
                    //MoreForm
                    datumText.text = sites[number].value(forKey: "datum")! as? String
                    latitudeText.text = sites[number].value(forKey: "lat")! as? String
                    longitudeText.text = sites[number].value(forKey: "long")! as? String
                    
                    //road/trail conditions after failure- 5 options
                    let afterFailure = sites[number].value(forKey: "rtConditionAfter")! as! NSObject as! Int
                    afterFailurePicker.selectRow(afterFailure, inComponent: 0, animated: true)

                    lengthAffectedText.text = sites[number].value(forKey: "lengthAffected")! as? String
                    
                    //damages? - 2 options
                    let damages = sites[number].value(forKey: "deaths")! as! NSObject as! Int
                    damagesPicker.selectRow(damages, inComponent: 0, animated: true)

                    damagesCommentsText.text = sites[number].value(forKey: "deathsComments")! as? String
                    
                    //number of fallen rocks - 5 options
                    let fallenRocks = sites[number].value(forKey: "numFallen")! as! NSObject as! Int
                    fallenRocksPicker.selectRow(fallenRocks, inComponent: 0, animated: true)

            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
            
        }

        
    }
        
    @IBAction func getOfflineHelp(_ sender: AnyObject) {
        let messageString = "Save forms while offline. See what forms you have saved on the list. Clear a form when it isn't needed or load a form to double-check the information. Submit form(s) once you are back online."
        let alertController = UIAlertController(title: "Help", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //present manual
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue1" {
            let popoverViewController = segue.destination 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            if(shareData.device == "iPad"){ //By Device Type
                popoverViewController.preferredContentSize = CGSize(width: 600, height: 600)
            }
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    //get the number of saved forms so you don't go out of bounds when entering the number
    func getNumForms(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSlopeEvent")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            counted.removeAll() //need to re-clear??
            counted = results as! [NSManagedObject] //
            saved = counted.count
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }
        
        
        
        
        
    }
    

    
}
