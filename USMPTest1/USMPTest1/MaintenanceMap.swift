//
//  MaintenanceMap.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//sources: https://www.mapbox.com/ios-sdk/examples/point-conversion

import Foundation
import UIKit
import Mapbox


class MaintenanceMap: UIViewController, MGLMapViewDelegate, MaintenancePinModelHelperProtocol {
    
   
    @IBOutlet weak var mapView: MGLMapView!
    var feedItems: NSArray = NSArray() //feed for pin info
    let maintenancePinModel = MaintenancePinModel()
    let shareData = ShareData.sharedInstance
    var current_id = 0 //where to set??
    var pressNew = UILongPressGestureRecognizer(target: self, action: #selector(MaintenanceMap.newForm))

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareData.edit_site = false
        
        //map view stuff
        mapView.maximumZoomLevel = 13  //Have to include this...pick a good number //7
        mapView.minimumZoomLevel = 3
        
        mapView.delegate=self
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(39.7392, -104.9903)
        
        shareData.offline = false
        
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
        print("long press")
        let location: CLLocationCoordinate2D = mapView.convert(pressNew.location(in: mapView), toCoordinateFrom: mapView)
        
        let pin: MGLPointAnnotation = MGLPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        mapView.addAnnotation(pin) //add pin to the map
        pin.title = "New Maintenance Form"
        pin.subtitle = "Click to Add"
        
    }
    
    //maintenance pin model helper protocol
    func itemsDownloaded(_ items: NSArray){
        feedItems = items
        print("Feed Count is")
        print(feedItems.count)
        
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
        shareData.fillMaintenance = true
        }
        shareData.current_site_id = (annotation.subtitle)!!
        shareData.maintenance_site = (annotation.title)!!
        self.performSegue(withIdentifier: "goMaintenance", sender: self)

    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }

    
//    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
//        //print("adding images")
//        // Try to reuse the existing annotation image, if it exists
////        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: imagename)
////        
////        if annotationImage == nil {
////            var image = UIImage(named: imagename)!
////            
////            
////            image = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
////            
////            // Initialize the  annotation image with the UIImage just loaded
////            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imagename)
////            print("HERE IT GOES")
//        }
//        
//        //return annotationImage
//    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}

