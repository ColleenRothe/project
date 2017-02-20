//
//  MaintenanceForm.swift
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

//floating
//http://stackoverflow.com/questions/11272847/make-uiview-in-uiscrollview-stick-to-the-top-when-scrolled-up

//internet connectivity
//http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10

import Foundation
import UIKit
import CoreData
import SystemConfiguration

class MaintenanceForm: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, MaintenanceInfoModelHelperProtocol, SiteListModelHelperProtocol{
    //nav bar
    
    let shareData = ShareData.sharedInstance
    var feedItems: NSArray = NSArray()          //feed for pin info
    var feedItemsList: NSArray = NSArray()      //feed for list of site ids


    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var accountButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var manualButton: UIBarButtonItem!
    
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    let maintenanceTypeOptions = ["New Maintenance", "Repeat Maintenance"]
    
    @IBOutlet weak var maintenancePicker: UIPickerView!
    
    let eventTypeOptions = ["Recent Unstable Slope Event", "Routine Maintenance", "Slope Mitigation/Repair"]
    
    @IBOutlet weak var eventPicker: UIPickerView!
    
    @IBOutlet weak var totalCostText: UITextField!
    
    @IBOutlet weak var percent0Text: UITextField!
    
    @IBOutlet weak var percent1Text: UITextField!
    
    @IBOutlet weak var percent2Text: UITextField!
    
    @IBOutlet weak var percent3Text: UITextField!
    
    @IBOutlet weak var percent4Text: UITextField!
    
    @IBOutlet weak var percent5Text: UITextField!
    
    @IBOutlet weak var percent6Text: UITextField!
    
    @IBOutlet weak var percent7Text: UITextField!
    
    @IBOutlet weak var percent8Text: UITextField!
    
    @IBOutlet weak var percent9Text: UITextField!
    
    @IBOutlet weak var percent10Text: UITextField!
    
    @IBOutlet weak var percent11Text: UITextField!
    
    @IBOutlet weak var percent12Text: UITextField!
    
    @IBOutlet weak var percent13Text: UITextField!
    
    @IBOutlet weak var percent14Text: UITextField!
    
    @IBOutlet weak var percent15Text: UITextField!
    
    @IBOutlet weak var percent16Text: UITextField!
    
    @IBOutlet weak var percent17Text: UITextField!
    
    @IBOutlet weak var percent18Text: UITextField!
    
    @IBOutlet weak var percent19Text: UITextField!
    
    @IBOutlet weak var percent20Text: UITextField!
    
    @IBOutlet weak var codeText: UITextField!
    
    @IBOutlet weak var eventDescriptionText: UITextView!
    
    @IBOutlet weak var other1Text: UITextField!
    
    @IBOutlet weak var other2Text: UITextField!
    
    @IBOutlet weak var other3Text: UITextField!
    
    @IBOutlet weak var other4Text: UITextField!
    
    @IBOutlet weak var other5Text: UITextField!
    
    @IBOutlet weak var percentagesTotalText: UITextField!
    
   
    @IBOutlet weak var rtNum: UITextField!
    
    @IBOutlet weak var beginMile: UITextField!
    
    @IBOutlet weak var endMile: UITextField!
    
    @IBOutlet weak var agency: UIPickerView!
    
    @IBOutlet weak var regional: UIPickerView!
    
    @IBOutlet weak var local: UIPickerView!
    
    let agencyOptions = ["Select Agency Option",  "FS", "NPS", "BLM", "BIA"]
    var regionalOptions = ["Select Regional Option"]
    var localOptions = ["Select Local Option"]
    //FS>>>>>>>>>>>>>>>>>>>>
    let FSRegionalOptions = ["Select Regional Option", "Northern Region", "Rocky Mountain Region", "Southwestern Region", "Intermountain Region", "Pacific Southwest Region","Pacific Northwest Region", "Southern Region", "Eastern Region", "Alaska Region"]
    //northern
    let FSLocal1Options = ["Select Local Option","Beaverhead-Deerlodge National Forest", "Bitterroot National Forest", "Dakota Prairie National Grasslands", "Flathead National Forest", "Custer Gallatin National Forest", "Helena National Forest", "Idaho Panhandle National Forests", "Kootenai National Forest", "Lewis & Clark National Forest", "Lolo National Forest", "Nex Perce-Clearwater National Forests" ]
    //rocky mountain 
    let FSLocal2Options = ["Select Local Option", "Arapaho and Roosevelt National Forests and Pawnee National Grassland", "Bighorn National Forest", "Black Hills National Forest", "Grand Mesa, Uncompahgre and Gunnison National Forests", "Mecine Bow-Routt National Forests and Thunder Basin National Grassland", "Nebraska National Forests and Grasslands", "Pike and San Isabel National Forests Cimarron and Comanche National Grasslands", "Rio Grande National Forest", "San Juan National Forest", "Shoshone National Forest", "White River National Forest"]
    //southwestern 
    let FSLocal3Options = ["Select Local Option", "Apache-Sitgreaves National Forests", "Carson National Forest", "Cibola National Forest","Coconino National Forest", "Coronado National Forest", "Gila National Forest", "Kaibab National Forest", "Lincoln National Forest", "Prescott National Forest", "Sante Fe National Forest", "Tonto National Forest"]
    //intermountain
    let FSLocal4Options = ["Select Local Option", "Ashley National Forest", "Boise National Forest", "Bridger-Teton National Forest", "Caribou-Targhee National Forest", "Dixie National Forest", "Fishlake National Forest", "Humboldt-Toiyabe National Forest", "Manti-LaSal National Forest", "Payette National Forest", "Salmon-Challis National Forest", "Sawtooth National Forest", "Uinta-Wasatch-Cache National Forest"]
    //pacific southwest
    let FSLocal5Options = ["Select Local Option", "Angeles National Forest", "Cleveland National Forest", "Eldorado National Forest", "Inyo National Forest", "Klamath NAtional Forest", "Lake Tahoe Basin Management Unit", "Lassen National Forest", "Los Padres National Forest", "Mendocino National Forest", "Modoc National Forest", "Plumas National Forest", "San Bernardino National Forest", "Sequoia National Forest", "Shasta-Trinity National Forest", "Sierra National Forest", "Six Rivers National Forest", "Stanislaus National Forest", "Tahoe National Forest"]
    //pacific northwest
    let FSLocal6Options = ["Select Local Option", "Columbia River Gorge National Scenic Area", "Colville National Forest", "Crooked River National Grassland", "Deschutes National Forest", "Fremont-Winema National Forest", "Gifford Pinchot National Forest", "Malheur National Forest", "Mt. Baker-Snoqualmie NAtional Forest", "Mt. Hood National Forest", "Ochoco National Forest", "Okanogan-Wenatchee National Forest", "Olympic National Forest", "Siuslaw National Forest", "Rogue River-Siskiyou National Forest", "Umatilla National Forest", "Umpqua National Forest", "Wallowa-Whitma National Forest", "Willamette National Forest"]
    //southern
    let FSLocal7Options = ["Select Local Option", "Chattahoochee-Oconee National Forest", "Cherokee NAtional Forest", "Daniel Boone National Forest", "El Yunque National Forest", "Francis Marion and Sumter National Forests", "George Washington and Jefferson National Forests", "Kisatchie NAtional Forest", "Land Between the Lakes Recreation Area", "National Forests and Grasslands in Texas", "National Forests in Alabama", "National Forests in Florida", "National Forests in Mississippi", "National Forests in North Carolina", "Ouachita National Forest", "Ozark-St. Francis National Forest", "Savannah River Site"]
    //eastern
    let FSLocal8Options = ["Select Local Option", "Allegheny National Forest", "Chequamegon-Nicolet National Forest", "Chippewa National Forest", "Green Mountain & Finger Lakes National Forests", "Hiawatha National Forest", "Hoosier National Forest", "Huron-Manistee National Forests", "Mark Twain National Forest", "Midewin NAtional Tallgrass Prairie", "Monongahela National Forest", "Ottawa National Forest", "Shawnee National Forest", "Superior National Forest", "Wayne National Forest", "White Mountain National Forest"]
    //alaska
    let FSLocal9Options = ["Select Local Option", "Chugach National Forest", "Tongass National Forest"]
    
    //NPS>>>>>>>>>>>>>>
    let NPSRegionalOptions = ["Select Regional Option", "AKR", "IMR", "MWR", "NCR","NER","PWR", "SER"]
    //AKR
    let NPSLocal1Options = ["Select Local Option", "Klondike Gold Rush", "Sitka", "Cape Krusenstern", "Aniakchak", "Kenai Fjords", "Kobuk Valley", "Denali", "Gates of the Arctic", "Glacier Bay", "Katmai", "Lake Clark", "Wrangell-St.Elias", "Bering Land Bridge", "Noatak", "Yukon-Charley Rivers"]
    //IMR
    let NPSLocal2Options = ["Select Local Option", "John D. Rockefeller, JR.", "Chaco Culture", "Lyndon B. Johnson", "Manhattan Project", "Palo Alto", "Pecos", "San Antonia Missions", "Tumacacori", "Bents Old Fort", "Fort Bowie", "Fort Davis", "Fort Laramie", "Golden Spike", "Grant-Kohrs Ranch", "Hubbell Trading Post", "Sand Creek Massacre", "Washita", "Alibates-Flint Quarries", "Aztec Ruins", "Bandelier", "Canyon De Chelly", "Capulin Volcano", "Case Grande Ruins", "Cedar Breaks", "Chiricahua", "Colorado", "Devils Tower", "Dinosaur", "El Malpais", "El Morro", "Florissant Fossil Beds", "Fort Union", "Fossil Butte", "Gila Cliff Dwellings", "Hohokam Pima", "Hovenweep", "Little Bighorn", "Montezuma Castle", "Natural Bridges", "Navajo", "Organ Pipe Cactus", "Petroglyph", "Pipe Spring", "Rainbow Bridge", "Salinas Pueblo Missions", "Sunset Crater Volcano", "Timpanogos Cave", "Tonto", "Tuzigoot", "Waco Mammoth", "Walnut Canyon", "White Sands", "Wupatki", "Yucca House", "Chamizal", "Coronado", "Arches", "Big Bend", "Black Canyon of the Gunnison", "Bryce Canyon", "Canyonlands", "Capitol Reef", "Carlsbad Caverns", "Glacier", "Grand Canyon", "Grand Teton", "Guadalupe Mountains", "Mesa Verde", "Petrified Forest","Rocky Mountain", "Saguaro", "Yellowstone", "Zion", "Big Thicket", "Great Sand Dunes", "Valles Caldera", "Amistad", "Bighorn Canyon", "Chickasaw", "Curecanti","Glen Canyon", "Lake Meredith", "Padre Island", "Rio Grande"]
    //MWR
    let NPSLocal3Options = ["Select Local Options", "Jefferson National Expansion", "Wilson's Creek", "River Raisin", "Dayton Aviation Heritage", "George Rogers Clark", "Hopewell Culture", "Keweenaw", "Brown V. Board of Education", "First Ladies'", "Fort Larned", "Fort Scott","Forst Smith", "Forst Union Trading Post", "Harry S Truman", "Herbert Hoover", "James A. Garfield", "Knife River Indian Villages", "Lincoln Home", "Little Rock Central High School", "Minuteman Missile", "Nicodemus", "President William Jefferson Clinton Birthplace", "Ulysses S. Grant", "William Howard Taft", "Apostle Islands", "Indiana Dunes", "Pictured Rocks", "Sleeping Bear Dunes", "Agate Fossil Beds", "Charles Young Buffalo Soldiers", "Effigy Mounds", "George Washington Carver", "Grand Portage", "Homestead", "Jewel Cave", "Pipestone", "Pullman", "Scotts Bluff", "Arkansas Post", "Lincoln Boyhood", "Mount Rushmore", "Perry's Victory and International Peace Memorial", "Pea Ridge", "Badlands", "Cuyahoga Valley", "Hot Springs", "Isle Royale", "Theodore Roosevelt", "Voyageurs", "Wind Cave", "Tallgrass Prairie", "Buffalo", "Mississippi National River and Recreation Area", "Niobrara", "Ozark National Scenic Riverway", "Saint Croix", "Missouri National REcreational River"]
    //NCR
    let NPSLocal4Options = ["Select Local Options", "Lincoln", "Thomas Jefferson", "Vietnam Veterans", "World War II", "George Washington Memorial Parkway", "Antietam", "Monocacy", "Manassas", "Chesapeake and Ohio Canal", "Harpers Ferry", "Carter G. Woodson Home", "Clara Barton", "Ford's Theatre", "Frederick Douglass", "Mary McLeod Bethune Council House", "Pennsylvania Avenue", "Belmont-Paul Women's Equality", "Arlington House- Robert E. Lee Memorial", "Franklin Delano Roosevelt", "Korean War Veterans", "Lyndon Baines Johnson Memorial Grove on the Potomac", "Martin Luther King, Jr.", "Theodore Roosevelt Island", "World War I", "Potomac Heritage", "Constitution Gardens", "National Capital Parks-East", "National Mall", "Prince William Forest Park", "Washington Monument", "White House Presidents Park", "Wolf Trap Park for the Performing Arts", "Catoctin Mountain", "Fort Washington", "Green Belt", "Piscataway", "Rock Creek"]
    //NER
    let NPSLocal5Options = ["Select Local Options", "Forst Necessity", "Petersburg", "Richmond", "Adams", "Appomattox Court House", "Blackstone River Valley", "Boston", "Cedar Creek & Belle Grove", "Colonial", "First State", "Harriet Tubman Underground Railroad", "Independence", "Lowell", "Marsh-Billings-Rockefeller", "Minute Man", "Morristown", "New Bedord Whaling", "Paterson Great Falls", "Saratoga", "Thomas Edison", "Valley Forge", "Women's Rights", "Allegheny Portage Railroad", "Boston African American", "Edgar Allan Poe", "Eisenhower", "Eleanor Roosevelt", "Frederick Law Olmsted", "Friendship Hill", "Hampton", "Home of Franklin D. Roosevelt", "Hopewell Furnace", "John Fitzgerald Kennedy", "Longfellow House-Washington's Headwuarters", "Maggie L. Walker", "Martin Van Buren", "Sagamore Hill", "Saint Paul's Church", "Saint-Gaudens", "Salem Maritime", "Saugus Iron Works", "Springfield Armory", "Steamtown", "Theodore Roosevelt Birthplace", "Thomas Stone", "Vanderbilt Mansion", "Weir Farm", "African Burial Ground", "Booker T. Washington NM", "Castle Clinton", "Fort Monroe", "Fort Stanwix", "George Washington Birthplace", "Governors Island", "Katahdin Woods and Waters", "Statue of Liberty and Ellis Island", "Stonewall", "Federal Hall", "Flight 93", "General Grant", "Hamilton Grange NM", "Johnstown Flood NM", "Roger Williams", "Thaddeus Kosciuszko", "Fredericksburg & Spotsylvania", "Gettysburg", "Acadia", "Shenandoah", "New River Gorge", "Boston Harbor Islands", "Delaware Water Gap", "Gateway", "Gauley", "Assateague Islands NS", "Cape Cod", "Fire ISland", "Bluestone", "Fort McHEnry National Monument And Historic Shrine", "Saint Croix Island INternational Historic Site", "Great Egg Harbor", "Uppder Delaware", "Appalachian"]
    //pwr
    let NPSLocal6Options = ["Select Local Options", "Big Hole", "Kalaupapa", "Kaloko-Honokohau", "Klondike Gold Rush", "Lewis and Clark", "Nez Perce", "Pu'Uhonua O Honaunau", "Rosie The Riverter/WWII Home Front", "San Francisco Maritime", "War in the Pacific", "Eugene O'Neill", "Fort Point", "Fort Vancouver", "John Muir", "Manzanar", "Minidoka", "Pu'Ukohola Heiau", "San Juan Island", "Whitman Misson", "Cabrillo", "Castle Mountain", "Cesar E. Chavez", "Devils Postpile", "Hagerman Fossil Beds", "Honouliuli", "John Day Fossil Beds", "Lava Beds", "Muir Woods", "Port Chicago Naval Magazine", "Tule Springs Fossil Beds", "World War II Valor in the Pacific", "Oregon Caves", "Craters of the Moon", "Channel Islands", "Crater Lake", "Death Valley", "Great Basin", "Haleakala", "Hawaii Volcanoes", "Joshua Tree", "Kings Canyon", "Lassen Volcanic", "Mount Rainier", "National Park of American Samoa", "North Cascades", "Olympic", "Pinnacles", "Redwood", "Sequoia", "Yosemite", "Mojave", "Golden Gate", "Lake Chelan", "Lake Mead", "Lake Roosevelt", "Ross Lake", "Santa Montica Mountains", "Whiskeytown", "Point Reyes", "American Memorial Park", "City Of Rocks National Reserve", "Ebey's Landing National Historical Reserve"]
    //ser
    let NPSLocal7Options = ["Select Local Options", "Cowpens", "Forst Donelson", "Moores Creek", "Stones River", "Tupelo", "Kennesaw Mountain", "Abraham Lincoln Birthplace", "Cumberland Gap", "Natchez", "New Orleans Jazz", "Andersonville", "Andrew Johnson", "Carl Sandburg Home", "Charles Pinckney", "Christiansted", "Fort Raleigh", "Jimmy Carter", "Martin Luther King, JR.", "Ninety Six", "San Juan", "Tuskegee Airmen", "Tuskegee Institue", "Buck Island reef", "Castillo de San Marcos", "Fort Frederica", "Fort Matanzas" ,"Fort Pulaski", "Forst Sumter", "Ocmulgee", "Poverty Point State", "Russell Cave", "Virgin Islands Coral Reef", "De Soto", "Fort Caroline", "Wright Brothers", "Chickamauga and Chattanooga", "Guilford Courthouse", "Horseshoe Bend", "Kings Mountain", "Shiloh, Vicksburg", "Biscayne", "Congaree", "Dry Tortugas", "Everglades", "Great Smoky Mountains", "Mammoth Cave", "Virgin Islands", "Little River Canyon", "Big South Fork", "Chattahoochee", "Canaveral", "Cape Hatteras", "Cape Lookout","Cumberland Island", "Gulf Islands", "Appalachian", "Natchez Trace", "Brices Cross Roads National Battlefield Site", "Cane River Creole National HIstorical Park & Heritage Area", "Jean Lafitte National Historical Park & Preserve", "Salt River Bay National HIstorical Park & Ecological Preserve", "Timucuan Ecological", "Blue Ridge Parkway"]
    
    
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
    
    //floating
    var originalOffset : CGFloat?
    
    @IBOutlet weak var float: UIView!
    
    @IBOutlet weak var floatLabel: UILabel!
    
    //load list of sites
    var siteList: [String] = [String]()
    
    @IBOutlet weak var siteIDPicker: UIPickerView!
    var siteIDOptions = ["---"]
    
    var site_id = "0"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareData.OfflineType = "maintenance"
        

        
        //picker delegates
        maintenancePicker.delegate = self
        maintenancePicker.dataSource = self
        
        eventPicker.delegate = self
        eventPicker.dataSource = self
        
        siteIDPicker.delegate = self
        siteIDPicker.dataSource = self
        
        agency.delegate=self
        agency.dataSource = self
        
        
                
        regional.delegate=self
        regional.dataSource=self
        
        local.delegate=self
        local.dataSource=self
        
        //text delegates
        rtNum.delegate=self
        beginMile.delegate=self
        endMile.delegate=self
        totalCostText.delegate = self
        percent0Text.delegate = self
        percent1Text.delegate = self
        percent2Text.delegate = self
        percent3Text.delegate = self
        percent4Text.delegate = self
        percent5Text.delegate = self
        percent6Text.delegate = self
        percent7Text.delegate = self
        percent8Text.delegate = self
        percent9Text.delegate = self
        percent10Text.delegate = self
        percent11Text.delegate = self
        percent12Text.delegate = self
        percent13Text.delegate = self
        percent14Text.delegate = self
        percent15Text.delegate = self
        percent16Text.delegate = self
        percent17Text.delegate = self
        percent18Text.delegate = self
        percent19Text.delegate = self
        percent20Text.delegate = self
        percentagesTotalText.delegate = self
        other1Text.delegate = self
        other2Text.delegate = self
        other3Text.delegate = self
        other4Text.delegate = self
        other5Text.delegate = self
        
        
        //rtnum
        beginMile.keyboardType = .numberPad
        endMile.keyboardType = .numberPad
        totalCostText.keyboardType = .numberPad
        percent0Text.keyboardType = .numberPad
        percent1Text.keyboardType = .numberPad
        percent2Text.keyboardType = .numberPad
        percent3Text.keyboardType = .numberPad
        percent4Text.keyboardType = .numberPad
        percent5Text.keyboardType = .numberPad
        percent6Text.keyboardType = .numberPad
        percent7Text.keyboardType = .numberPad
        percent8Text.keyboardType = .numberPad
        percent9Text.keyboardType = .numberPad
        percent10Text.keyboardType = .numberPad
        percent11Text.keyboardType = .numberPad
        percent12Text.keyboardType = .numberPad
        percent13Text.keyboardType = .numberPad
        percent14Text.keyboardType = .numberPad
        percent15Text.keyboardType = .numberPad
        percent16Text.keyboardType = .numberPad
        percent17Text.keyboardType = .numberPad
        percent18Text.keyboardType = .numberPad
        percent19Text.keyboardType = .numberPad
        percent20Text.keyboardType = .numberPad
        percentagesTotalText.keyboardType = .numberPad


        //Scroller
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 600, height: 4700) //set content size (= to view)
        scrollView.delegate = self
        
        //float
        //percentagesTotalText.translatesAutoresizingMaskIntoConstraints = true

        
        if(shareData.device == "iPad"){
            let font = UIFont(name: "Times New Roman", size: 15)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            accountButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            manualButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())

            
        }else{
            
            let font = UIFont(name: "Times New Roman", size: 9)
            //fixes the alert controllers resizing the nav bar when dismissed
            
            mapButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            slopeRatingFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            newSlopeEventButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            maintenanceFormButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            accountButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            logoutButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            manualButton.setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())

        }
        
        if(shareData.load == true){
            //call special load method
            loadFromList()
        }

        //dismiss keyboard...
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandslideChoice.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //loadSiteInformation()
        
        if shareData.fillMaintenance == true {
        //load form stuff....
            shareData.fillMaintenance = false
            let mimh = MaintenanceInfoModelHelper()
            mimh.delegate = self
            mimh.downloadItems()
            let slmh = SiteListModelHelper()
            slmh.delegate = self
            slmh.downloadItems()
        }
        
        if(!isInternetAvailable()){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.darkGray
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    
  
    
    func loadSiteInformation(){
        print("Load site information")
        print ("count again is:")
        print(feedItems.count)
        codeText.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).code_relation)
        site_id = ((feedItems.object(at: 0) as! MaintenanceInfoModel).site_id)!
        let maintenance_type = ((feedItems.object(at: 0) as! MaintenanceInfoModel).maintenance_type)
        
        //repeat maintenance
        if(maintenance_type == "R" ){
           maintenancePicker.selectRow(1, inComponent: 0, animated: true)
        } // else new maintenance (0)
        
        let us_event = ((feedItems.object(at: 0) as! MaintenanceInfoModel).us_event)
        
        if(us_event == "RM"){
            eventPicker.selectRow(1, inComponent: 0, animated: true)
        }
        else if (us_event == "SM"){
            eventPicker.selectRow(2, inComponent: 0, animated: true)

        }//else recent unstable slope event(0)
        
        let rtNum = ((feedItems.object(at: 0) as! MaintenanceInfoModel).rtNum)
        let beginMile = ((feedItems.object(at: 0) as! MaintenanceInfoModel).beginMile)
        let endMile = ((feedItems.object(at: 0) as! MaintenanceInfoModel).endMile)

        
        //agency, regional, local
        let agency = ((feedItems.object(at: 0) as! MaintenanceInfoModel).agency)
        let regional = ((feedItems.object(at: 0) as! MaintenanceInfoModel).regional)
        let local = ((feedItems.object(at: 0) as! MaintenanceInfoModel).local)
        
        print("AGENCY IS: "+agency!)
        print("REGINONAL IS: "+regional!)
        print("LOCAL IS: "+local!)
        
        eventDescriptionText.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).event_desc)
        totalCostText.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).total)
        //....dif between just design_pse and design_pse_val etc.....??
        percent0Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).design_pse)
        percent1Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).remove_ditch)
        percent2Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).remove_road_trail)
        percent3Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).relevel_aggregate)
        percent4Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).relevel_patch)
        percent5Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).drainage_improvement)
        percent6Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).deep_patch)
        percent7Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).haul_debris)
        percent8Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).scaling_rock_slopes)
        percent9Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).road_trail_alignment)
        percent10Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).repair_rockfall_barrier)
        percent11Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).repair_rockfall_netting)
        percent12Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).sealing_cracks)
        percent13Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).guardrail)
        percent14Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).cleaning_drains)
        percent15Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).flagging_signing)
        percent16Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others1)
        percent17Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others2)
        percent18Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others3)
        percent19Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others4)
        percent20Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others5)

        
        other1Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others1_desc)
        other2Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others2_desc)
        other3Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others3_desc)
        other4Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others4_desc)
        other5Text.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).others5_desc)

        
        percentagesTotalText.text = ((feedItems.object(at: 0) as! MaintenanceInfoModel).total_percent)
    
    }
    
    func loadSiteList(){
        print("Load the site list")
        let listed = ((feedItemsList.object(at: 0) as! SiteListModel))
        //First Item is them All
        let length = listed.ids
        for i in 0..<listed.ids.count{
            siteIDOptions.append(listed.ids[i] as! String)
            print(listed.ids[i])
        }
        
        siteIDPicker.reloadAllComponents()
        var index = 0
        print("site id is")
        print(shareData.maintenance_site)
        if(siteIDOptions.contains(shareData.maintenance_site)){
            index = siteIDOptions.index(of: shareData.maintenance_site)!

        }
        siteIDPicker.selectRow(index, inComponent: 0, animated: true)
        
        
    }
    
    
    func itemsDownloadedI(_ items: NSArray) {
        feedItems = items
        print("Maintenance Info Feed Count is")
        print(feedItems.count)
        loadSiteInformation()
    }
    
    func itemsDownloadedSL(_ items: NSArray) {
        feedItemsList = items
        print("Site List feed Count on Maintenance is")
        print(feedItemsList.count)
        loadSiteList()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        originalOffset = float.frame.origin.y
        print("APPEARING")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("ORIGINAL OFFSET")
        //print(originalOffset)
        //print("CONTENT OFFSET")
        //print(scrollView.contentOffset.y)
        float.frame.origin.y = max(originalOffset!,scrollView.contentOffset.y)
        //print("FRAME")
        //print(float.frame.origin.y)
    }
    
    

    //text field delegate func
    func textFieldDidEndEditing(_ textField: UITextField) {
        percentagesTotalText.text = String(calcPercentages())
        floatLabel.text = percentagesTotalText.text
        if(textField == totalCostText){
            if(Int(totalCostText.text!) == nil){
                totalCostText.backgroundColor = UIColor.red
            }
            else{
                totalCostText.backgroundColor = UIColor.white
            }
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == totalCostText{
            textField.resignFirstResponder()
            percent0Text.becomeFirstResponder()
            return false
        }
        if textField == percent0Text{
            textField.resignFirstResponder()
            percent1Text.becomeFirstResponder()
            return false
        }
        if textField == percent1Text{
            textField.resignFirstResponder()
            percent2Text.becomeFirstResponder()
            return false
        }
        if textField == percent2Text{
            textField.resignFirstResponder()
            percent3Text.becomeFirstResponder()
            return false
        }
        if textField == percent3Text{
            textField.resignFirstResponder()
            percent4Text.becomeFirstResponder()
            return false
        }
        if textField == percent4Text{
            textField.resignFirstResponder()
            percent5Text.becomeFirstResponder()
            return false
        }
        if textField == percent5Text{
            textField.resignFirstResponder()
            percent6Text.becomeFirstResponder()
            return false
        }
        if textField == percent6Text{
            textField.resignFirstResponder()
            percent7Text.becomeFirstResponder()
            return false
        }
        if textField == percent7Text{
            textField.resignFirstResponder()
            percent8Text.becomeFirstResponder()
            return false
        }
        if textField == percent8Text{
            textField.resignFirstResponder()
            percent9Text.becomeFirstResponder()
            return false
        }
        if textField == percent9Text{
            textField.resignFirstResponder()
            percent10Text.becomeFirstResponder()
            return false
        }
        if textField == percent10Text{
            textField.resignFirstResponder()
            percent11Text.becomeFirstResponder()
            return false
        }
        if textField == percent11Text{
            textField.resignFirstResponder()
            percent12Text.becomeFirstResponder()
            return false
        }
        if textField == percent12Text{
            textField.resignFirstResponder()
            percent13Text.becomeFirstResponder()
            return false
        }
        if textField == percent13Text{
            textField.resignFirstResponder()
            percent14Text.becomeFirstResponder()
            return false
        }
        if textField == percent14Text{
            textField.resignFirstResponder()
            percent15Text.becomeFirstResponder()
            return false
        }
        if textField == percent15Text{
            textField.resignFirstResponder()
            other1Text.becomeFirstResponder()
            return false
        }
        
        if textField == other1Text{
            textField.resignFirstResponder()
            percent16Text.becomeFirstResponder()
            return false
        }
        if textField == percent16Text{
            textField.resignFirstResponder()
            other2Text.becomeFirstResponder()
            return false
        }
        if textField == other2Text{
            textField.resignFirstResponder()
            percent17Text.becomeFirstResponder()
            return false
        }
        if textField == percent17Text{
            textField.resignFirstResponder()
            other3Text.becomeFirstResponder()
            return false
        }
        if textField == other3Text{
            textField.resignFirstResponder()
            percent18Text.becomeFirstResponder()
            return false
        }
        if textField == percent18Text{
            textField.resignFirstResponder()
            other4Text.becomeFirstResponder()
           return false
        }
        if textField == other4Text{
            textField.resignFirstResponder()
            percent19Text.becomeFirstResponder()
            return false
        }
        if textField == percent19Text{
            textField.resignFirstResponder()
            other5Text.becomeFirstResponder()
            return false
        }
        if textField == other5Text{
            textField.resignFirstResponder()
            percent20Text.becomeFirstResponder()
            return false
        }
        
     return true
    }
    
    private func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(textView == totalCostText){
        let newText = (totalCostText.text! as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 7;
        }
        return true
    }
    
    
    
    func calcPercentages()->Int{
        var total = 0
        
        if(percent0Text.text != ""){
            total = total + Int(percent0Text.text!)!
        }
        if(percent1Text.text != ""){
            total = total + Int(percent1Text.text!)!
        }
        if(percent2Text.text != ""){
            total = total + Int(percent2Text.text!)!
        }
        if(percent3Text.text != ""){
            total = total + Int(percent3Text.text!)!
        }
        if(percent4Text.text != ""){
            total = total + Int(percent4Text.text!)!
        }
        if(percent5Text.text != ""){
            total = total + Int(percent5Text.text!)!
        }
        if(percent6Text.text != ""){
            total = total + Int(percent6Text.text!)!
        }
        if(percent7Text.text != ""){
            total = total + Int(percent7Text.text!)!
        }
        if(percent8Text.text != ""){
            total = total + Int(percent8Text.text!)!
        }
        if(percent9Text.text != ""){
            total = total + Int(percent9Text.text!)!
        }
        if(percent10Text.text != ""){
            total = total + Int(percent10Text.text!)!
        }
        if(percent11Text.text != ""){
            total = total + Int(percent11Text.text!)!
        }
        if(percent12Text.text != ""){
            total = total + Int(percent12Text.text!)!
        }
        if(percent13Text.text != ""){
            total = total + Int(percent13Text.text!)!
        }
        if(percent14Text.text != ""){
            total = total + Int(percent14Text.text!)!
        }
        if(percent15Text.text != ""){
            total = total + Int(percent15Text.text!)!
        }
        if(percent16Text.text != ""){
            total = total + Int(percent16Text.text!)!
        }
        if(percent17Text.text != ""){
            total = total + Int(percent17Text.text!)!
        }
        if(percent18Text.text != ""){
            total = total + Int(percent18Text.text!)!
        }
        if(percent19Text.text != ""){
            total = total + Int(percent19Text.text!)!
        }
        if(percent20Text.text != ""){
            total = total + Int(percent20Text.text!)!
        }
        
        return total
    }
    
    //picker view delegate func
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Select The Agency
        if (pickerView .isEqual(agency)){
            //0 = select option
            if(row == 0){
                regionalOptions.removeAll()
                regionalOptions.append("Select Regional Option")
                regional.reloadAllComponents()
            }
            //FS
            if (row == 1){
                regionalOptions.removeAll()
                regionalOptions.append(contentsOf: FSRegionalOptions)
                regional.reloadAllComponents()
            }
            //NPS
            if(row == 2){
                regionalOptions.removeAll()
                regionalOptions.append(contentsOf: NPSRegionalOptions)
                regional.reloadAllComponents()
            }
            //BLM
            if(row == 3){
                regionalOptions.removeAll()
                regionalOptions.append("Select Regional Option")
                regional.reloadAllComponents()
                
                localOptions.removeAll()
                localOptions.append("Select Local Option")
                local.reloadAllComponents()
            }
            //BIA
            if(row == 4){
                regionalOptions.removeAll()
                regionalOptions.append("Select Regional Option")
                regional.reloadAllComponents()
                
                localOptions.removeAll()
                localOptions.append("Select Local Option")
                local.reloadAllComponents()
            }
        }
        
        //Then select the Region
        if(pickerView .isEqual(regional)){
            //FS and No region
            if(agency.selectedRow(inComponent: 0) == 1 && row == 0 ){
                localOptions.removeAll()
                localOptions.append("Select Local Option")
                local.reloadAllComponents()
            }
            //FS & Northern
            if(agency.selectedRow(inComponent: 0) == 1 && row == 1 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal1Options)
                local.reloadAllComponents()
            }
            //FS and Rocky Mountain
            if(agency.selectedRow(inComponent: 0) == 1 && row == 2 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal2Options)
                local.reloadAllComponents()
            }
            //FS and Southwestern
            if(agency.selectedRow(inComponent: 0) == 1 && row == 3 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal3Options)
                local.reloadAllComponents()
            }
            //FS and Intermountain
            if(agency.selectedRow(inComponent: 0) == 1 && row == 4 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal4Options)
                local.reloadAllComponents()
            }
            //FS and Pacific Southwest
            if(agency.selectedRow(inComponent: 0) == 1 && row == 5 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal5Options)
                local.reloadAllComponents()
            }
            //FS and Pacific Northwest
            if(agency.selectedRow(inComponent: 0) == 1 && row == 6 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal6Options)
                local.reloadAllComponents()
            }
            //FS and Southern
            if(agency.selectedRow(inComponent: 0) == 1 && row == 7 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal7Options)
                local.reloadAllComponents()
            }
            //FS and Eastern
            if(agency.selectedRow(inComponent: 0) == 1 && row == 8 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal8Options)
                local.reloadAllComponents()
            }
            //FS and Alaska
            if(agency.selectedRow(inComponent: 0) == 1 && row == 9 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSLocal9Options)
                local.reloadAllComponents()
            }
            
            //NPS and No region
            if(agency.selectedRow(inComponent: 0) == 2 && row == 0 ){
                localOptions.removeAll()
                localOptions.append("Select Local Option")
                local.reloadAllComponents()
            }
            //NPS & AKR
            if(agency.selectedRow(inComponent: 0) == 2 && row == 1 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal1Options)
                local.reloadAllComponents()
            }
            //NPS & IMR
            if(agency.selectedRow(inComponent: 0) == 2 && row == 2 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal2Options)
                local.reloadAllComponents()
            }
            //NPS & MWR
            if(agency.selectedRow(inComponent: 0) == 2 && row == 3 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal3Options)
                local.reloadAllComponents()
            }
            //NPS & NCR
            if(agency.selectedRow(inComponent: 0) == 2 && row == 4){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal4Options)
                local.reloadAllComponents()
            }
            //NPS & NER
            if(agency.selectedRow(inComponent: 0) == 2 && row == 5){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal5Options)
                local.reloadAllComponents()
            }
            //NPS & PWR
            if(agency.selectedRow(inComponent: 0) == 2 && row == 6 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal6Options)
                local.reloadAllComponents()
            }
            //NPS & SER
            if(agency.selectedRow(inComponent: 0) == 2 && row == 7 ){
                localOptions.removeAll()
                localOptions.append(contentsOf: NPSLocal7Options)
                local.reloadAllComponents()
            }
            
        }
    }
    
    //one component each row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var components = 0
        
        if(pickerView .isEqual(maintenancePicker)){
            components = maintenanceTypeOptions.count;
        }
        if(pickerView .isEqual(eventPicker)){
            components = eventTypeOptions.count;
        }
        if(pickerView .isEqual(siteIDPicker)){
            components = siteIDOptions.count;
        }
        if(pickerView .isEqual(agency)){
            components = agencyOptions.count;
        }
        if(pickerView .isEqual(regional)){
            components = regionalOptions.count;
        }
        if(pickerView .isEqual(local)){
            components = localOptions.count;
        }


     return components
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView .isEqual(maintenancePicker)){
            return maintenanceTypeOptions[row]
        }
        if(pickerView .isEqual(eventPicker)){
            return eventTypeOptions[row]
        }
        if(pickerView .isEqual(siteIDPicker)){
            return siteIDOptions[row]
        }
        if(pickerView .isEqual(agency)){
            return agencyOptions[row]
            }
        if(pickerView .isEqual(regional)){
            return regionalOptions[row]
        }
        if(pickerView .isEqual(local)){
            return localOptions[row]
        }
        else{
            return "error"
        }
        
    }


    //MARK: submit form online
    func handleSubmit(_ alertView:UIAlertAction!){
        //delete site from core data if submitted successfully...
        
        
        //let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8080/usmp/server/maintenance/add_maintenance.php")! as URL)
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/usmp/server/maintenance/add_maintenance.php")! as URL)
        request.httpMethod = "POST"
        
        //Maintenace type?? maintenancePicker
        var maintenance_type = "New Maintenance"
        let selected_mt = maintenancePicker.selectedRow(inComponent: 0)
        if(selected_mt == 1 ){
            maintenance_type = "Repeat Maintenance"
        }
        
        //Type of Event?? eventPicker
        var us_event = "Recent Unstable Slope Event"
        let selected_ue = eventPicker.selectedRow(inComponent: 0)
        if(selected_ue == 1){
            us_event = "Routine Maintenance"
        }
        else if(selected_ue == 2){
            us_event = "Slope Mitigation/Repair"
        }
       
        let rtNumString = rtNum.text
        let beginMileString = beginMile.text
        let endMileString = endMile.text
        
        let agency = "agency"
        let regional = "regional"
        let local = "local"
        
        
        let percent0 = Int(percent0Text.text!)
        let percent1 = Int(percent1Text.text!)
        let percent2 = Int(percent2Text.text!)
        let percent3 = Int(percent3Text.text!)
        let percent4 = Int(percent4Text.text!)
        let percent5 = Int(percent5Text.text!)
        let percent6 = Int(percent6Text.text!)
        let percent7 = Int(percent7Text.text!)
        let percent8 = Int(percent8Text.text!)
        let percent9 = Int(percent9Text.text!)
        let percent10 = Int(percent10Text.text!)
        let percent11 = Int(percent11Text.text!)
        let percent12 = Int(percent12Text.text!)
        let percent13 = Int(percent13Text.text!)
        let percent14 = Int(percent14Text.text!)
        let percent15 = Int(percent15Text.text!)
        let percent16 = Int(percent16Text.text!)
        let percent17 = Int(percent17Text.text!)
        let percent18 = Int(percent18Text.text!)
        let percent19 = Int(percent19Text.text!)
        let percent20 = Int(percent20Text.text!)
        
        
        let postString = "site_id=0&code_relation=\(codeText.text!)&maintenance_type=\(maintenance_type)&road_trail_no=\(rtNumString)&begin_mile_marker=\(beginMileString)&end_mile_marker=\(endMileString)&umbrella_agency=\(agency)&regional_admin=\(regional)&local_admin=\(local)&us_event=\(us_event)&event_desc=\(eventDescriptionText.text!)&design_pse=\(percent0!)&remove_ditch_debris=\(percent1!)&remove_road_trail_debris=\(percent2!)&relevel_aggregate=\(percent3!)&relevel_patch=\(percent4!)&drainage_improvement=\(percent5!)&deep_patch=\(percent6!)&haul_debris=\(percent7!)&scaling_rock_slopes=\(percent8!)&road_trail_alignment=\(percent9!)&repair_rockfall_barrier=\(percent10!)&repair_rockfall_netting=\(percent11!)&sealing_cracks=\(percent12!)&guardrail=\(percent13!)&cleaning_drains=\(percent14!)&flagging_signing=\(percent15!)&other1_desc=\(other1Text.text!)&other1=\(percent16!)&other2_desc=\(other2Text.text!)&other2=\(percent17!)&other3_desc=\(other3Text.text!)&other3=\(percent18!)&other4_desc=\(other4Text.text!)&other4=\(percent19!)&other5_desc=\(other5Text.text!)&other5=\(percent20!)"

        
        
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
        
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)

    }
    
    //MARK: Submit saved form(s)
    
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
    
    @IBAction func save(_ sender: AnyObject) {
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "OfflineMaintenance", in:managedContext)
        let site = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        site.setValue(codeText.text, forKey: "code")
        //maintenance type- 2 options
        let selectedMaintenance = maintenancePicker.selectedRow(inComponent: 0)
        site.setValue(selectedMaintenance, forKey: "maintenanceType")

        //type of event- 3 options
        let selectedEvent = eventPicker.selectedRow(inComponent: 0)
        site.setValue(selectedEvent, forKey: "eventType")

        site.setValue(eventDescriptionText.text, forKey: "eventDescription")
        
        site.setValue(rtNum.text, forKey: "rtNum")
        site.setValue(beginMile.text, forKey: "beginMile")
        site.setValue(endMile.text, forKey: "endMile")

        let selectedAgency = agency.selectedRow(inComponent: 0)
        let selectedRegion = regional.selectedRow(inComponent: 0)
        let selectedLocal = local.selectedRow(inComponent: 0)
        
        site.setValue(selectedAgency, forKey: "agency")
        site.setValue(selectedRegion, forKey: "regional")
        site.setValue(selectedLocal, forKey: "local")
        
        //MARK: Actions and Cost
            
        site.setValue(totalCostText.text, forKey: "totalCost")
        
        site.setValue(percent0Text.text, forKey: "designPSE")
        
        site.setValue(percent1Text.text, forKey: "removeAndMaintain")
        
        site.setValue(percent2Text.text, forKey: "removeDebris")
        
        site.setValue(percent3Text.text, forKey: "relevelAggregate")
        
        site.setValue(percent4Text.text, forKey: "relevelAsphalt")
            
        site.setValue(percent5Text.text, forKey: "drainImprove")
        
        site.setValue(percent6Text.text, forKey: "deepPatch")
        
        site.setValue(percent7Text.text, forKey: "haulDebris")
        
        site.setValue(percent8Text.text, forKey: "scalingUnstable")
            
        site.setValue(percent9Text.text, forKey: "minorShifting")
     
        site.setValue(percent10Text.text, forKey: "repairBarrier")
        
        site.setValue(percent11Text.text, forKey: "repairNetting")
        
        site.setValue(percent12Text.text, forKey: "sealCracks")
            
        site.setValue(percent13Text.text, forKey: "guardrail")
        
        site.setValue(percent14Text.text, forKey: "cleanDrains")

        site.setValue(percent15Text.text, forKey: "flagging")
        
        //MARK: "Other"
            
        site.setValue(percent16Text.text, forKey: "other1")
        
        site.setValue(percent17Text.text, forKey: "other2")
        
        site.setValue(percent18Text.text, forKey: "other3")
        
        site.setValue(percent19Text.text, forKey: "other4")
        
        site.setValue(percent20Text.text, forKey: "other5")
        
        site.setValue(other1Text.text, forKey: "other1Text")
        site.setValue(other2Text.text, forKey: "other2Text")
        site.setValue(other3Text.text, forKey: "other3Text")
        site.setValue(other4Text.text, forKey: "other4Text")
        site.setValue(other5Text.text, forKey: "other5Text")

        site.setValue(percentagesTotalText.text, forKey: "percentTotal")
            
                   do {
                try managedContext.save()
                let alertController = UIAlertController(title: "Success", message: "Form Saved", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil) //may be an issue?
         
                //sites.append(site)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                let alertController = UIAlertController(title: "Error", message: "Form Not Saved: \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil) //may be an issue?
            }
            

    }
    
    //MARK: LOAD offline list
    func loadFromList(){
        shareData.load = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineMaintenance")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            
            
                    let number = shareData.selectedForm
                    
                    codeText.text = sites[number].value(forKey: "code")! as? String
                    
                    //maintenance type - 2 options
                    let maintenance = sites[number].value(forKey: "maintenanceType")! as! NSObject as! Int
                    maintenancePicker.selectRow(maintenance, inComponent: 0, animated: true)
            
            
                    rtNum.text = sites[number].value(forKey: "rtNum")! as? String
                    beginMile.text = sites[number].value(forKey: "beginMile")! as? String
                    endMile.text = sites[number].value(forKey: "endMile")! as? String
            
                    let agencySelect = sites[number].value(forKey: "agency")! as! NSObject as! Int
                    let regionSelect = sites[number].value(forKey: "regional")! as! NSObject as! Int
                    let localSelect = sites[number].value(forKey: "local")! as! NSObject as! Int
            
            
                    agency.selectRow(agencySelect, inComponent: 0, animated: true)
                    regional.selectRow(regionSelect, inComponent: 0, animated: true)
                    local.selectRow(localSelect, inComponent: 0, animated: true)

            
                    //type of event - 3 options
                    let event = sites[number].value(forKey: "eventType")! as! NSObject as! Int
                    eventPicker.selectRow(event, inComponent: 0, animated: true)
            
                    eventDescriptionText.text = sites[number].value(forKey: "eventDescription")! as? String
                    
                    //MARK: Actions and Cost
                    
                    totalCostText.text = sites[number].value(forKey: "totalCost")! as? String
                    
                    percent1Text.text = sites[number].value(forKey: "removeAndMaintain")! as? String
                    
                    percent2Text.text = sites[number].value(forKey: "removeDebris")! as? String
                    
                    percent3Text.text = sites[number].value(forKey: "relevelAggregate")! as? String
                    
                    percent4Text.text = sites[number].value(forKey: "relevelAsphalt")! as? String
                    
                    percent5Text.text = sites[number].value(forKey: "drainImprove")! as? String
                    
                    percent6Text.text = sites[number].value(forKey: "deepPatch")! as? String
                    
                    percent7Text.text = sites[number].value(forKey: "haulDebris")! as? String
                    
                    percent8Text.text = sites[number].value(forKey: "scalingUnstable")! as? String
                    
                    percent9Text.text = sites[number].value(forKey: "minorShifting")! as? String
                    
                    percent10Text.text = sites[number].value(forKey: "repairBarrier")! as? String
                    
                    percent11Text.text = sites[number].value(forKey: "repairNetting")! as? String
                    
                    percent12Text.text = sites[number].value(forKey: "sealCracks")! as? String
                    
                    percent13Text.text = sites[number].value(forKey: "guardrail")! as? String
                    
                    percent14Text.text = sites[number].value(forKey: "cleanDrains")! as? String
                    
                    percent15Text.text = sites[number].value(forKey: "flagging")! as? String
                    
                    //MARK: "Other"
                    
                    other1Text.text = sites[number].value(forKey: "other1Text")! as? String
                    
                    percent16Text.text = sites[number].value(forKey: "other1")! as? String
                    
                    other2Text.text = sites[number].value(forKey: "other2Text")! as? String
                    
                    percent17Text.text = sites[number].value(forKey: "other2")! as? String
                    
                    other3Text.text = sites[number].value(forKey: "other3Text")! as? String
                    
                    percent18Text.text = sites[number].value(forKey: "other3")! as? String
                    
                    other4Text.text = sites[number].value(forKey: "other4Text")! as? String
                    
                    percent19Text.text = sites[number].value(forKey: "other4")! as? String
                    
                    other5Text.text = sites[number].value(forKey: "other5Text")! as? String
                    
                    percent20Text.text = sites[number].value(forKey: "other5")! as? String
                    
                    
                    percentagesTotalText.text = sites[number].value(forKey: "percentTotal")! as? String
                    
           
            
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
        present(alertController, animated: true, completion: nil) //may be an issue?
    }
    
    
    //present manual
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineMaintenance")
        
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
