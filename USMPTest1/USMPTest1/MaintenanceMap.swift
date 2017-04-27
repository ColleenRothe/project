//
//  MaintenanceMap.swift
//  USMPTest1
//

//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//sources: https://www.mapbox.com/ios-sdk/examples/point-conversion

import Foundation
import UIKit
import Mapbox


class MaintenanceMap: UIViewController, MGLMapViewDelegate, MaintenancePinModelHelperProtocol {
    //map view
    @IBOutlet weak var mapView: MGLMapView!
    //feed for pin info
    var feedItems: NSArray = NSArray()
    let maintenancePinModel = MaintenancePinModel()
    let shareData = ShareData.sharedInstance
    var current_id = 0
    //for the long press to create new sites
    var pressNew = UILongPressGestureRecognizer(target: self, action: #selector(MaintenanceMap.newForm))
    //used to set image of each pin when online
    var imagename = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //not offline, not editing
        shareData.edit_site = false
        shareData.offline = false
        
        //map view stuff
        mapView.maximumZoomLevel = 13  //Have to include this...pick a good number //7
        mapView.minimumZoomLevel = 3
        mapView.delegate=self
        mapView.centerCoordinate = CLLocationCoordinate2DMake(39.7392, -104.9903)
        
        //pins
        let pinmh = MaintenancePinModelHelper()
        pinmh.delegate = self
        pinmh.downloadItems()
        
        //create new pin
        pressNew = UILongPressGestureRecognizer(target: self, action: #selector(MaintenanceMap.newForm))

        pressNew.minimumPressDuration = 1
        mapView.addGestureRecognizer(pressNew)
        
    }
    
    //create a new pin
    func newForm(tap: UILongPressGestureRecognizer){
        let location: CLLocationCoordinate2D = mapView.convert(pressNew.location(in: mapView), toCoordinateFrom: mapView)
        
        let pin: MGLPointAnnotation = MGLPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        shareData.maintenance_lat = String(location.latitude)
        shareData.maintenance_long = String(location.longitude)
        mapView.addAnnotation(pin) //add pin to the map
        pin.title = "New Maintenance Form"
        pin.subtitle = "Click to Add"
        
    }
    
    //maintenance pin model helper protocol
    func itemsDownloaded(_ items: NSArray){
        feedItems = items
    }
    
    override func viewDidAppear(_ animated: Bool){
        //make some more pins...
        for i in 0 ..< feedItems.count {
            //get maintenance pin model at feed item index
            let selectedLocation = feedItems.object(at: i) as! MaintenancePinModel
            //get the coordinates
            var poiCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
            poiCoordinates.latitude = CDouble(selectedLocation.latitude!)!
            poiCoordinates.longitude = CDouble(selectedLocation.longitude!)!
            
            //connected to a slope rating
            if(selectedLocation.site_id != "0"){
                imagename = "mmblue"

            }
            //not connected to a slope rating
            else{
                imagename = "mmwhite"
            }
            
            //make a new pin
            let pin: MGLPointAnnotation = MGLPointAnnotation()
            pin.coordinate = poiCoordinates
            mapView.addAnnotation(pin) //add pin to the map
            pin.title = selectedLocation.site_id
            pin.subtitle = selectedLocation.id
        }
        
    }
    
    //add the extra info button
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    //tapped the info button...
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        print("Tapped the button")
        if(((annotation.title)!) != "New Maintenance Form"){
            //set that you need to load the information
        shareData.fillMaintenance = true
        }
        shareData.current_site_id = (annotation.subtitle)!!
        shareData.maintenance_site = (annotation.title)!!
        //open up the maintenance form
        self.performSegue(withIdentifier: "goMaintenance", sender: self)

    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing annotation image, if it exists
       var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: imagename)
    
        if annotationImage == nil {
            var image = UIImage(named: imagename)!
    
           image = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
    
            // Initialize the  annotation image with the UIImage just loaded
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imagename)
        }
    
        return annotationImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pull up the legend
    @IBAction func clickLegend(_ sender: Any) {
        let alert = UIAlertController(title: "Legend", message: "\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        let framed = CGRect(x: 40, y: 50, width: 200, height: 100)
        
        let imageView = UIImageView(frame: framed)
        imageView.image = UIImage(named: "maintenanceLegend")
        alert.view.addSubview(imageView)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}

