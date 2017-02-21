//
//  ShareData.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 12/30/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//
//  Singleton

import Foundation

//class used to share data between classes..
//ex: manipulating textfield in prelimRatings based on calculations/text in onlineNew

//sharedata adapted from:
//http://stackoverflow.com/questions/25215476/how-do-you-pass-data-between-view-controllers-in-swift

//singleton class, leave this alone...
//class ShareData{
//    
//    class var sharedInstance: ShareData{
//        struct Static{
//            static var instance: ShareData?
//            static var token: Int = 0
//            
//        }
////        dispatch_once(&Static.token) {
////            Static.instance = ShareData()
////        }
//       
//
//        //_ = ShareData.__once
//        
//        return Static.instance!
//    }

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static let instance: ShareData = ShareData()
        }
        return Static.instance
    }


    
    //VC Online New--> decide for some if string or int/double etc.
    var managementArea : String = ""
    var date : String = "" //DATE PICKER
    var roadTrailNum : String = ""
    var roadTrailChoice : String = "" //ROAD TRAIL PICKER
    var roadTrailClass : String = ""
    var rater : String = ""
    var beginMileMark : String = ""
    var endMileMark : String = ""
    var side : String = "" //SIDE PICKER
    var weather : String = ""
    var hazardType: String = ""
    var rockfallLandslideChoice : String = "" //ROCKFALL/LANDSLIDE PICKER
    var beginCoordLat : String = ""
    var beginCoordLong : String = ""
    var endCoordLat : String = ""
    var endCoordLong : String = ""
    var datum : String = ""
    var onewAadt : String = "" //aadt
    var onewLength : String = "" //length
    var lengthAffectedRoadTrail : String = ""
    var onewslopeaxHeight : String = "" //slope axial height
    var slopeAngle : String = ""
    var onewSight : String = "" //sight distance
    var onewWidth : String = "" //width
    var onewSpeed : String = "" //speed
    var ditchWidth1 : String = ""
    var ditchWidth2: String = ""
    var ditchDepth1: String = ""
    var ditchDepth2: String = ""
    var ditchSlope1 : String = ""
    var ditchSlope2 : String = ""
    var ditchSlope3 : String = ""
    var ditchSlope4 : String = ""
    var onewSize : String = "" //size
    var onewVolume : String = "" // volume
    var annualRainfall1 : String = ""
    var annualRainfall2 : String = ""
    var soleAccessRoute : String = "" //SOLE ACCESS ROUTE PICKER
    var mitigation : String = ""    //MITIGATION PICKER
    //documents..
    var comments : String = ""
    var fmlaName : String = ""
    var fmlaID : String = ""
    var fmlaDescription : String = ""
    
    
    //VC Prelim Ratings
    var prelimAString: String = "" //used for A text to set prelim rating
    var prelimBString: String = "" //used for B text to set prelim rating
    var lengthString : String = "" //used for length -->C
    var prelimDString: String = "" //used for D text to set prelim rating
    var prelimEString: String = "" //used for E text to set prelim rating
    var sizeVolumeString: String = "" //used for size/vol per event -->F
    var prelimGString: String = "" //used for G text to set prelim rating
    var prelimAadt : String = "" //used for aadt/usage --> H
    var prelimLandslideString: String = "" //used for prelim landslide rating
    var prelimRockfallString: String = "" //used for prelim rockfall rating
    var prelimRating: String = "" //used for total prelim rating
    
    //VC Hazard Ratings
    var IHazard : String = ""
    var rainfallString : String = "" //used for annual rainfall -->J
    var slopeAxialString : String = "" //used for height or length -->K
    var LHazard : String = ""
    var MHazard : String = ""
    var NHazard : String = ""
    var OHazard : String = ""
    var PHazard : String = ""
    var QHazard : String = ""
    var RHazard : String = ""
    var SHazard : String = ""
    
    var rockfallHazardTotal: String = "" //used to set  U
    var landslideHazardTotal: String = "" //used to set T
    
    var prelimRockfallHazardTotal: Double = 0.0 //used to get the values from prelim ratings vc for the slope hazard rockfall total calcs
    var prelimLandslideHazardTotal: Double = 0.0 //used to get the values from prelim ratings vc for the slope hazard landlisde total calcs
    
    
    
    //Risk Ratings
    var routeTrailWidthString : String = "" //used for route/trail width --> V
    var humanExposureString: String = "" //used for huamn exposure factor --> W
    var decisionSightDistanceString: String = "" //used for %dsd -->X
    var YRisk : String = ""
    var ZRisk : String = ""
    var AARisk : String = ""
    var BBRisk : String = ""
    var riskTotal: String = "" //used for CC risk ratings
    var finalTotal : String = ""
    

    
    //other helpers
    var pageIndex : Int!   //might be able to get rid of this....depends on later implementations
    
    //to get correct annotation page
    var current_site_id : String = ""
    var photo_string : String = ""
    
    //login info
    var email : String = ""
    var password : String = ""
    var permissions: String = ""
    
    //percentiles
    var rockfall_twenty_five = ""
    var rockfall_fifty = ""
    var rockfall_seventy_five = ""
    var landslide_twenty_five = ""
    var landslide_fifty = ""
    var landslide_seventy_five = ""
    
    //offline...
    var offIds: [String] = []
    var offline = false
    var OfflineType = "landslide" //landslide, rockfall, slopeEvent, maintenance
    var selectedForm = 0
    var load = false
    
    var editType = "" //to tell if you are editing a landslide or rockfall form...
    
    //device
    var device = "other"
    
    //maintenanceMap
    var fillMaintenance = false
    var maintenance_site = "0"
    
    //edit site
    var edit_site = false
    var current_clicked_id = ""
    var offline_edit = false
    var offline_edit_site_id = ""
    

    
    
    
}
