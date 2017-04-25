//
//  MaintenanceForm.swift
//  USMPTest1
//
//  Corresponds to View Controller for Maintenance Form
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

//image picker library
//https://github.com/mikaoj/BSImagePicker

import Foundation
import UIKit
import CoreData
import SystemConfiguration

class MaintenanceForm: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, MaintenanceInfoModelHelperProtocol, SiteListModelHelperProtocol{
    //nav bar
    
    let shareData = ShareData.sharedInstance
    var feedItems: NSArray = NSArray()          //feed for pin info
    var feedItemsList: NSArray = NSArray()      //feed for list of site ids

    //nav bar
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
        
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var manualButton: UIBarButtonItem!
    
    //UI connection
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
    
    @IBOutlet weak var dateText: UITextField!
   
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
    let FSRegionalOptions = ["Select Regional option" ,"Northern_Region", "Rocky_Mountain_Region", "Southwestern_Region", "Intermountain_Region", "Pacific_Southwest_Region","Pacific_Northwest_Region","Southern_Region","Eastern_Region","Alaska_Region"]
    //northern
    let FSLocal1Options = ["Select Local option","Beaverhead-Deerlodge_National_Forest","Bitterroot_National_Forest",
                           "Dakota_Prairie_National_Grasslands","Flathead_National_Forest","Custer_Gallatin_National_Forest",
                           "Helena_National_Forest","Idaho_Panhandle_National_Forests","Kootenai_National_Forest",
                           "Lewis_&_Clark_National_Forest","Lolo_National_Forest","Nez_Perce-Clearwater_National_Forests"]
    //rocky mountain 
    let FSLocal2Options = ["Select Local option","Arapaho_and_Roosevelt_National_Forests_and_Pawnee_National_Grassland","Bighorn_National_Forest",
                           "Black_Hills_National_Forest","Grand_Mesa,Uncompahgre_and_Gunnison_National_Forests",
                           "Medicine_Bow-Routt_National_Forests_and_Thunder_Basin_National_Grassland","Nebraska_ National_Forests_and_Grasslands",
                           "Pike_and_San_Isabel_National_Forests_Cimarron_and_Comanche_National_Grasslands","Rio_Grande_National_Forest",
                           "San_Juan_National_Forest","Shoshone_National_Forest","White_River_National_Forest"]
    //southwestern
    let FSLocal3Options = ["Select Local option","Apache-Sitgreaves_National_Forests","Carson_National_Forest","Cibola_National_Forest",
                           "Coconino_National_Forest","Coronado_National_Forest","Gila_National_Forest",
                           "Kaibab_National_Forest","Lincoln_National_Forest","Prescott_National_Forest",
                           "Santa_Fe_National_Forest","Tonto_National_Forest"]
    //intermountain
    let FSLocal4Options = ["Select Local option","Ashley_National_Forest","Boise_National_Forest","Bridger-Teton_National_Forest",
                           "Caribou-Targhee_National_Forest","Dixie_National_Forest","Fishlake_National_Forest",
                           "Humboldt-Toiyabe_National_Forest","Manti-LaSal_National_Forest","Payette_National_Forest",
                           "Salmon-Challis_National_Forest","Sawtooth_National_Forest","Uinta-Wasatch-Cache_National_Forest"]
    //pacific southwest
    let FSLocal5Options = ["Select Local option","Angeles_National_Forest","Cleveland_National_Forest","Eldorado_National_Forest",
                           "Inyo_National_Forest","Klamath_National_Forest","Lake_Tahoe_Basin_Management_Unit",
                           "Lassen_National_Forest","Los_Padres_National_Forest","Mendocino_National_Forest",
                           "Modoc_National_Forest","Plumas_National_Forest","San_Bernardino_National_Forest",
                           "Sequoia_National_Forest","Shasta-Trinity_National_Forest","Sierra_National_Forest",
                           "Six_Rivers_National_Forest","Stanislaus_National_Forest","Tahoe_National_Forest"]
    //pacific northwest
    let FSLocal6Options = ["Select Local option","Columbia_River_Gorge_National_Scenic_Area","Colville_National_Forest",
                           "Crooked_River_National_Grassland","Deschutes_National_Forest",
                           "Fremont-Winema_National_Forest","Gifford_Pinchot_National_Forest",
                           "Malheur_National_Forest","Mt._Baker-Snoqualmie_National_Forest",
                           "Mt._Hood_National_Forest","Ochoco_National_Forest","Okanogan-Wenatchee_National_Forest",
                           "Olympic_National_Forest","Siuslaw_National_Forest","Rogue_River-Siskiyou_National_Forest",
                           "Umatilla_National_Forest","Umpqua_National_Forest",
                           "Wallowa-Whitma_National_Forest","Willamette_National_Forest"]
    //southern
    let FSLocal7Options = ["Select Local option","Chattahoochee-Oconee_National_Forest","Cherokee_National_Forest","Daniel_Boone_National_Forest",
                           "El_Yunque_National_Forest","Francis_Marion_and_Sumter_National_Forests",
                           "George_Washington_and_Jefferson_National_Forests","Kisatchie_National_Forest",
                           "Land_Between_the_Lakes_Recreation_Area","National_Forests_and_Grasslands_in_Texas",
                           "National_Forests_in_Alabama","National_Forests_in_Florida","National_Forests_in_Mississippi",
                           "National_Forests_in_North_Carolina","Ouachita_National_Forest",
                           "Ozark-St._Francis_National_Forest","Savannah_River_Site"]
    //eastern
    let FSLocal8Options = ["Select Local option","Allegheny_National_Forest","Chequamegon-Nicolet_National_Forest","Chippewa_National_Forest",
                           "Green_Mountain_&_Finger_Lakes_National_Forests","Hiawatha_National_Forest","Hoosier_National_Forest",
                           "Huron-Manistee_National_Forests","Mark_Twain_National_Forest","Midewin_National_Tallgrass_Prairie",
                           "Monongahela_National_Forest","Ottawa_National_Forest","Shawnee_National_Forest",
                           "Superior_National_Forest","Wayne_National_Forest","White_Mountain_National_Forest"]
    //alaska
    let FSLocal9Options = ["Select Local option","Chugach_National_Forest","Tongass_National_Forest"]
    
    //NPS>>>>>>>>>>>>>>
    let NPSRegionalOptions = ["Select Regional Option", "AKR", "IMR", "MWR", "NCR","NER","PWR", "SER"]
    //AKR
    let NPSLocal1Options = ["Select Local option","ANIAKCHAK","BERING_LAND_BRIDGE", "CAPE_KRUSENSTERN", "DENALI","GATES_OF_THE_ARCTIC", "GLACIER_BAY","KATMAI","KENAI_FJORDS", "KLONDIKE_GOLD_RUSH","KOBUK_VALLEY","LAKE_CLARK","NOATAK","SITKA","WRANGELL-ST._ELIAS","YUKON-CHARLEY_RIVERS"]
    //IMR
    let NPSLocal2Options = ["Select Local option","ALIBATES_FLINT_QUARRIES","AMISTAD","ARCHES","AZTEC_RUINS","BANDELIER","BENTS_OLD_FORT","BIG_BEND","BIG_THICKET","BIGHORN_CANYON","BLACK_CANYON_OF_THE_GUNNISON","BRYCE_CANYON","CANYON_DE_CHELLY","CANYONLANDS","CAPITOL_REEF","CAPULIN_VOLCANO","CARLSBAD_CAVERNS","CASA_GRANDE_RUINS","CEDAR_BREAKS","CHACO_CULTURE","CHAMIZAL","CHICKASAW","CHIRICAHUA","COLORADO","CORONADO","CURECANTI","DEVILS_TOWER","DINOSAUR","EL_MALPAIS","EL_MORRO","FLORISSANT_FOSSIL_BEDS","FORT_BOWIE","FORT_DAVIS","FORT_LARAMIE","FORT_UNION","FOSSIL_BUTTE","GILA_CLIFF_DWELLINGS","GLACIER","GLEN_CANYON","GOLDEN_SPIKE","GRAND_CANYON","GRAND_TETON","GRANT-KOHRS_RANCH","GREAT_SAND_DUNES","GUADALUPE_MOUNTAINS","HOHOKAM_PIMA","HOVENWEEP","HUBBELL_TRADING_POST","JOHN_D._ROCKEFELLER,_JR.","LAKE_MEREDITH","LITTLE_BIGHORN","LYNDON_B._JOHNSON","MANHATTAN_PROJECT","MESA_VERDE","MONTEZUMA_CASTLE","NATURAL_BRIDGES","NAVAJO","ORGAN_PIPE_CACTUS","PADRE_ISLAND","PALO_ALTO","PECOS","PETRIFIED_FOREST","PETROGLYPH","PIPE_SPRING","RAINBOW_BRIDGE","RIO_GRANDE","ROCKY_MOUNTAIN","SAGUARO","SALINAS_PUEBLO_MISSIONS","SAN_ANTONIO_MISSIONS","SAND_CREEK_MASSACRE","SUNSET_CRATER_VOLCANO","TIMPANOGOS_CAVE","TONTO","TUMACACORI","TUZIGOOT","VALLES_CALDERA","WACO_MAMMOTH","WALNUT_CANYON","WASHITA","WHITE_SANDS","WUPATKI","YELLOWSTONE","YUCCA_HOUSE","ZION"]
    //MWR
    let NPSLocal3Options = ["Select Local option","AGATE_FOSSIL_BEDS","APOSTLE_ISLANDS","ARKANSAS_POST","BADLANDS","BROWN_V._BOARD_OF_EDUCATION","BUFFALO","CHARLES_YOUNG_BUFFALO_SOLDIERS","CUYAHOGA_VALLEY","DAYTON_AVIATION_HERITAGE","EFFIGY_MOUNDS","FIRST_LADIES'","FORT_LARNED","FORT_SCOTT","FORT_SMITH","FORT_UNION_TRADING_POST","GEORGE_ROGERS_CLARK","GEORGE_WASHINGTON_CARVER","GRAND_PORTAGE","HARRY_S_TRUMAN","HERBERT_HOOVER","HOMESTEAD","HOPEWELL_CULTURE","HOT_SPRINGS","INDIANA_DUNES","ISLE_ROYALE","JAMES_A._GARFIELD","JEFFERSON_NATIONAL_EXPANSION","JEWEL_CAVE","KEWEENAW","KNIFE_RIVER_INDIAN_VILLAGES","LINCOLN_BOYHOOD","LINCOLN_HOME","LITTLE_ROCK_CENTRAL_HIGH_SCHOOL","MINUTEMAN_MISSILE","MISSISSIPPI_NATIONAL_RIVER_AND_RECREATION_AREA","MISSOURI_NATIONAL_RECREATIONAL_RIVER","MOUNT_RUSHMORE","NICODEMUS","NIOBRARA","OZARK_NATIONAL_SCENIC_RIVERWAY","PEA_RIDGE","PERRY’S_VICTORY_AND_INTERNATIONAL_PEACE_MEMORIAL","PICTURED_ROCKS","PIPESTONE","PRESIDENT_WILLIAM_JEFFERSON_CLINTON_BIRTHPLACE_HOME","PULLMAN","RIVER_RAISIN","SAINT_CROIX","SCOTTS_BLUFF","SLEEPING_BEAR_DUNES","TALLGRASS_PRAIRIE","THEODORE_ROOSEVELT","ULYSSES_S._GRANT","VOYAGEURS","WILLIAM_HOWARD_TAFT","WILSON’S_CREEK","WIND_CAVE"]
    //NCR
    let NPSLocal4Options = ["Select Local option","ANTIETAM","ARLINGTON_HOUSE_-_ROBERT_E._LEE_MEMORIAL","BELMONT-PAUL_WOMEN'S_EQUALITY","CARTER_G._WOODSON_HOME","CATOCTIN_MOUNTAIN","CHESAPEAKE_AND_OHIO_CANAL","CLARA_BARTON","CONSTITUTION_GARDENS","FORD'S_THEATRE","FORT_WASHINGTON","FRANKLIN_DELANO_ROOSEVELT","FREDERICK_DOUGLASS","GEORGE_WASHINGTON_MEMORIAL_PARKWAY","GREEN_BELT","HARPERS_FERRY","KOREAN_WAR_VETERANS","LINCOLN","LYNDON_BAINES_JOHNSON_MEMORIAL_GROVE_ON_THE_POTOMAC","MANASSAS","MARTIN_LUTHER_KING,_JR.","MARY_MCLEOD_BETHUNE_COUNCIL_HOUSE","MONOCACY","NATIONAL_CAPITAL_PARKS_-_EAST","NATIONAL_MALL","PENNSYLVANIA_AVENUE","PISCATAWAY","POTOMAC_HERITAGE","PRINCE_WILLIAM_FOREST_PARK","ROCK_CREEK","THEODORE_ROOSEVELT_ISLAND","THOMAS_JEFFERSON","VIETNAM_VETERANS","WASHINGTON_MONUMENT","WHITE_HOUSE_PRESIDENTS_PARK","WOLF_TRAP_PARK_FOR_THE_PERFORMING_ARTS","WORLD_WAR_I","WORLD_WAR_II"]
    //NER
    let NPSLocal5Options = ["Select Local option", "ACADIA","ADAMS","AFRICAN_BURIAL_GROUND","ALLEGHENY_PORTAGE_RAILROAD","APPALACHIAN","APPOMATTOX_COURT_HOUSE","ASSATEAGUE_ISLAND_NS","BLACKSTONE_RIVER_VALLEY","BLUESTONE","BOOKER_T._WASHINGTON_NM","BOSTON","BOSTON_AFRICAN_AMERICAN","BOSTON_HARBOR_ISLANDS","CAPE_COD","CASTLE_CLINTON","CEDAR_CREEK_&_BELLE_GROVE","COLONIAL","DELAWARE_WATER_GAP","EDGAR_ALLAN_POE","EISENHOWER","ELEANOR_ROOSEVELT","FEDERAL_HALL","FIRE_ISLAND","FIRST_STATE","FLIGHT_93","FORT_MCHENRY_NATIONAL_MONUMENT_AND_HISTORIC_SHRINE","FORT_MONROE","FORT_NECESSITY","FORT_STANWIX","FREDRICK_LAW_OLMSTED","FREDRICKSBURG_&_SPOTSYLVANIA","FRIENDSHIP_HILL","GATEWAY","GAULEY","GENERAL_GRANT","GEORGE_WASHINGTON_BIRTHPLACE","GETTYSBURG","GOVERNORS_ISLAND","GREAT_EGG_HARBOR","HAMILTON_GRANGE_NM","HAMPTON","HARRIET_TUBMAN_UNDERGROUND_RAILROAD","HOME_OF_FRANKLIN_D._ROOSEVELT","HOPEWELL_FURNACE","INDEPENDENCE","JOHN_FITZGERALD_KENNEDY","JOHNSTOWN_FLOOD_NM","KATAHDIN_WOODS_AND_WATERS","LONGFELLOW_HOUSE_-WASHINGTON'S_HEADQUARTERS","LOWELL","MAGGIE_L._WALKER","MARSH-BILLINGS-ROCKEFELLER","MARTIN_VAN_BUREN","MINUTE_MAN","MORRISTOWN","NEW_BEDFORD_WHALING","NEW_RIVER_GORGE","PATERSON_GREAT_FALLS","PETERSBURG","RICHMOND","ROGER_WILLIAMS","SAGAMORE_HILL","SAINT-GAUDENS","SAINT_CROIX_ISLAND_INTERNATIONAL_HISTORIC_SITE","SAINT_PAUL'S_CHURCH","SALEM_MARITIME","SARATOGA","SAUGUS_IRON_WORKS","SHENANDOAH","SPRINGFIELD_ARMORY","STATUE_OF_LIBERTY_AND_ELLIS_ISLAND","STEAMTOWN","STONEWALL","THADDEUS_KOSCIUSZKO","THEODORE_ROOSEVELT_BIRTHPLACE","THOMAS_EDISON","THOMAS_STONE","UPPER_DELAWARE","VALLEY_FORGE","VANDERBILT_MANSION","WEIR_FARM","WOMEN'S_RIGHTS"]
    //pwr
    let NPSLocal6Options = ["Select Local option","AMERICAN_MEMORIAL_PARK","BIG_HOLE","CABRILLO","CASTLE_MOUNTAIN","CESAR_E._CHAVEZ","CHANNEL_ISLANDS","CITY_OF_ROCKS_NATIONAL_RESERVE","CRATER_LAKE","CRATERS_OF_THE_MOON","DEATH_VALLEY","DEVILS_POSTPILE","EBEY'S_LANDING_NATIONAL_HISTORICAL_RESERVE","EUGENE_O'NEILL","FORT_POINT","FORT_VANCOUVER","GOLDEN_GATE","GREAT_BASIN","HAGERMAN_FOSSIL_BEDS","HALEAKALA","HAWAII_VOLCANOES","HONOULIULI","JOHN_DAY_FOSSIL_BEDS","JOHN_MUIR","JOSHUA_TREE","KALAUPAPA","KALOKO-HONOKOHAU","KINGS_CANYON","KLONDIKE_GOLD_RUSH","LAKE_CHELAN","LAKE_MEAD","LAKE_ROOSEVELT","LASSEN_VOLCANIC","LAVA_BEDS","LEWIS_AND_CLARK","MANZANAR","MINIDOKA","MOJAVE","MOUNT_RAINIER","MUIR_WOODS","NATIONAL_PARK_OF_AMERICAN_SAMOA","NEZ_PERCE","NORTH_CASCADES","OLYMPIC","OREGON_CAVES","PINNACLES","POINT_REYES","PORT_CHICAGO_NAVAL_MAGAZINE","PU'UHONUA_O_HONAUNAU","PU'UKOHOLA_HEIAU","REDWOOD","ROSIE_THE_RIVETER/WWII_HOME_FRONT","ROSS_LAKE","SAN_FRANCISCO_MARITIME","SAN_JUAN_ISLAND","SANTA_MONICA_MOUNTAINS","SEQUOIA","TULE_SPRINGS_FOSSIL_BEDS","WAR_IN_THE_PACIFIC","WHISKEYTOWN","WHITMAN_MISSION","WORLD_WAR_II_VALOR_IN_THE_PACIFIC","YOSEMITE"]
    //ser
    let NPSLocal7Options = ["Select Local option","ABRAHAM_LINCOLN_BIRTHPLACE","ANDERSONVILLE","ANDREW_JOHNSON","APPALACHIAN","BIG_SOUTH_FORK ","BISCAYNE","BLUE_RIDGE_PARKWAY","BRICES_CROSS_ROADS_NATIONAL_BATTLEFIELD_SITE","BUCK_ISLAND_REEF","CANAVERAL","CANE_RIVER_CREOLE_NATIONAL_HISTORICAL_PARK_&_HERITAGE_AREA","CAPE_HATTERAS","CAPE_LOOKOUT","CARL_SANDBURG_HOME","CASTILLO_de_SAN_MARCOS","CHARLES_PINCKNEY","CHATTAHOOCHEE","CHICKAMAUGA_AND_CHATTANOOGA","CHRISTIANSTED","CONGAREE","COWPENS","CUMBERLAND_GAP","CUMBERLAND_ISLAND","DE_SOTO","DRY_TORTUGAS","EVERGLADES","FORT_CAROLINE","FORT_DONELSON","FORT_FREDERICA","FORT_MATANZAS","FORT_PULASKI","FORT_RALEIGH","FORT_SUMTER","GREAT_SMOKY_MOUNTAINS","GUILFORD_COURTHOUSE","GULF_ISLANDS","HORSESHOE_BEND","JEAN_LAFITTE_NATIONAL_HISTORICAL_PARK_&_PRESERVE","JIMMY_CARTER","KENNESAW_MOUNTAIN","KINGS_MOUNTAIN","LITTLE_RIVER_CANYON","MAMMOTH_CAVE","MARTIN_LUTHER_KING,_JR.","MOORES_CREEK","NATCHEZ","NATCHEZ_TRACE","NEW_ORLEANS_JAZZ","NINETY_SIX","OBED","OCMULGEE","POVERTY_POINT_STATE","RUSSELL_CAVE","SALT_RIVER_BAY_NATIONAL_HISTORICAL_PARK_&_ECOLOGICAL_PRESERVE","SAN_JUAN","SHILOH","STONES_RIVER","TIMUCUAN_ECOLOGICAL","TUPELO","TUSKEGEE_AIRMEN","TUSKEGEE_INSTITUTE","VICKSBURG","VIRGIN_ISLANDS","VIRGIN_ISLANDS_CORAL_REEF","WRIGHT_BROTHERS"]
    
    //offline func.
    var sites = [NSManagedObject]()             //core data
    
    //help keep track of how many of that type of form are saved
    var counted = [NSManagedObject]()             //core data sites
    var saved = 0
    
    @IBOutlet weak var submitButton: UIButton!
    
    //text fields for alerts
    var clearNum: UITextField = UITextField()
    var loadNum: UITextField = UITextField()
    var savedNum: UITextField = UITextField()
    var clearString = ""
    var loadString = ""
    var savedString = ""
    
    //floating percentage
    var originalOffset : CGFloat?
    
    @IBOutlet weak var float: UIView!
    
    @IBOutlet weak var floatLabel: UILabel!
    
    //load list of sites
    var siteList: [String] = [String]()
    
    @IBOutlet weak var siteIDPicker: UIPickerView!
    var siteIDOptions = ["---"] //initially isn't associated w/ any site id
    
    var site_id = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //permissions!
        if(shareData.level == 2){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.gray
        }
        
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
        rtNum.delegate = self
        
        //keyboards
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
        
        //date
        dateText.delegate = self
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let currDate = format.string(from: date)
        dateText.text = currDate
        
        //Scroller
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 600, height: 4700) //set content size (= to view)
        scrollView.delegate = self
        
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

        //dismiss keyboard...
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MaintenanceForm.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if shareData.fillMaintenance == true {
        //load form stuff....
            shareData.fillMaintenance = false
            let mimh = MaintenanceInfoModelHelper()
            mimh.delegate = self
            mimh.downloadItems()
            //get list of site ids
            let slmh = SiteListModelHelper()
            slmh.delegate = self
            slmh.downloadItems()
        }
        
        if(!isInternetAvailable()){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.darkGray
        }
    }
    
    //try here
    override func viewDidAppear(_ animated: Bool) {
        if(shareData.off_submit == true){
            shareData.off_submit = false
            submitButton.sendActions(for: .touchUpInside)
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
    
    
    //get maintenance form info out of the MaintenanceInfoModel
    func loadSiteInformation(){
        //fill in the UI
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
        
        let rtNumS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).rtNum)
        rtNum.text = rtNumS
        let beginMileS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).beginMile)
        beginMile.text = beginMileS
        let endMileS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).endMile)
        endMile.text = endMileS
        
        //agency, regional, local
        let agencyS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).agency)
        let regionS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).regional)
        let localS = ((feedItems.object(at: 0) as! MaintenanceInfoModel).local)
        
        //fix, based on it being like "NPS_SER_BITTERROOT"....
        
        if(agencyS == "FS"){
            agency.selectRow(1, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 1, inComponent: 0)
            
            //To get the region
            for i in 0 ... (FSRegionalOptions.count - 1){
                if(regionS?.range(of: FSRegionalOptions[i]) != nil){
                    regional.selectRow(i, inComponent: 0, animated: true)
                    self.regional.delegate?.pickerView!(regional, didSelectRow: i, inComponent: 0)
                }
            }
            
            var localB = false
            
            
            for i in 0 ... (FSLocal1Options.count - 1){
                if(localS?.range(of: FSLocal1Options[i]) != nil){
                    local.selectRow(i, inComponent: 0, animated: true)
                    localB = true
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal2Options.count - 1){
                    if(localS?.range(of: FSLocal2Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal3Options.count  - 1){
                    if(localS?.range(of: FSLocal3Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal4Options.count  - 1){
                    if(localS?.range(of: FSLocal4Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal5Options.count  - 1){
                    if(localS?.range(of: FSLocal5Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal6Options.count  - 1){
                    if(localS?.range(of: FSLocal6Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal7Options.count  - 1){
                    if(localS?.range(of: FSLocal7Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal8Options.count  - 1){
                    if(localS?.range(of: FSLocal8Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (FSLocal9Options.count  - 1){
                    if(localS?.range(of: FSLocal9Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            
        }else if(agencyS == "NPS"){
            agency.selectRow(2, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 2, inComponent: 0)
            
            //To get the region
            for i in 0 ... (NPSRegionalOptions.count - 1){
                if(regionS?.range(of: NPSRegionalOptions[i]) != nil){
                    regional.selectRow(i, inComponent: 0, animated: true)
                    self.regional.delegate?.pickerView!(regional, didSelectRow: i, inComponent: 0)
                }
            }
            
            var localB = false
            if(localB != true){
                for i in 0 ... (NPSLocal1Options.count  - 1){
                    if(localS?.range(of: NPSLocal1Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal2Options.count  - 1){
                    if(localS?.range(of: NPSLocal2Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal3Options.count  - 1){
                    if(localS?.range(of: NPSLocal3Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal4Options.count  - 1){
                    if(localS?.range(of: NPSLocal4Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal5Options.count  - 1){
                    if(localS?.range(of: NPSLocal5Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal6Options.count  - 1){
                    if(localS?.range(of: NPSLocal6Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            if(localB != true){
                for i in 0 ... (NPSLocal7Options.count  - 1){
                    if(localS?.range(of: NPSLocal7Options[i]) != nil){
                        local.selectRow(i, inComponent: 0, animated: true)
                        localB = true
                    }
                }
            }
            
            
            
        }else if(agencyS == "BLM"){
            agency.selectRow(3, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 3, inComponent: 0)
            
            
        }else if(agencyS == "BIA"){
            agency.selectRow(4, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 4, inComponent: 0)
        }

        
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
    
    //load list of site ids
    func loadSiteList(){
        let listed = ((feedItemsList.object(at: 0) as! SiteListModel))
        //First Item is them All
        for i in 0..<listed.ids.count{
            siteIDOptions.append(listed.ids[i] as! String)
        }
        
        //add them to the picker
        siteIDPicker.reloadAllComponents()
        var index = 0
        //load the correct one
        if(siteIDOptions.contains(shareData.maintenance_site)){
            index = siteIDOptions.index(of: shareData.maintenance_site)!
        }
        siteIDPicker.selectRow(index, inComponent: 0, animated: true)
    }
    
    
    //maintenance info feed
    func itemsDownloadedI(_ items: NSArray) {
        feedItems = items
        loadSiteInformation()
    }
    
    //site list feed
    func itemsDownloadedSL(_ items: NSArray) {
        feedItemsList = items
        loadSiteList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //to place the floating thing
    override func viewWillAppear(_ animated: Bool) {
        originalOffset = float.frame.origin.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        float.frame.origin.y = max(originalOffset!,scrollView.contentOffset.y)
        
    }
    

    //text field delegate func
    func textFieldDidEndEditing(_ textField: UITextField) {
        percentagesTotalText.text = String(calcPercentages())
        floatLabel.text = percentagesTotalText.text
        //check if total percent >100
        if(textField == totalCostText){
            if(Int(totalCostText.text!) == nil){
                totalCostText.backgroundColor = UIColor.red
            }
            else{
                totalCostText.backgroundColor = UIColor.white
            }
        }

    }
    
    //press the return button, what text field is next?
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
    
    
    //calculate percentages
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
    
    //Required picker delegate functions
    
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
       
        let rtNumString = rtNum.text!
        let beginMileString = beginMile.text!
        let endMileString = endMile.text!
        
        //agency
        let agencyS = agencyOptions[agency.selectedRow(inComponent: 0)]
        if(agencyS == "FS"){
            agency.selectRow(1, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 1, inComponent: 0)
            
        }else if(agencyS == "NPS"){
            agency.selectRow(2, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 2, inComponent: 0)
            
            
        }else if(agencyS == "BLM"){
            agency.selectRow(3, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 3, inComponent: 0)
            
            
        }else if(agencyS == "BIA"){
            agency.selectRow(4, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: 4, inComponent: 0)
        }
        //regional
        var regionalS = ""
        if(agency.selectedRow(inComponent: 0) == 1){ //fs
            regionalS = FSRegionalOptions[regional.selectedRow(inComponent: 0)]
        }
        if(agency.selectedRow(inComponent: 0) == 2){ //fs
            regionalS = NPSRegionalOptions[regional.selectedRow(inComponent: 0)]
        }
        //local
        var localS = ""
        if(agency.selectedRow(inComponent: 0) == 1){ //FS
            if(regional.selectedRow(inComponent: 0) == 1){  //NORTHERN
                localS = FSLocal1Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 2){  //Rocky MTN
                localS = FSLocal2Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 3){  //Southwestern
                localS = FSLocal3Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 4){  //Intermountain
                localS = FSLocal4Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 5){  //Pacific Southwest
                localS = FSLocal5Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 6){  //Pacific Northwest
                localS = FSLocal6Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 7){  //Southern
                localS = FSLocal7Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 8){  //Eastern
                localS = FSLocal8Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 9){  //Alaska
                localS = FSLocal9Options[local.selectedRow(inComponent: 0)]
            }
        }
        
        if(agency.selectedRow(inComponent: 0) == 2){ //NPS
            if(regional.selectedRow(inComponent: 0) == 1){  //Akr
                localS = NPSLocal1Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 2){  //Imr
                localS = NPSLocal2Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 3){  //Mwr
                localS = NPSLocal3Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 4){  //Ncr
                localS = NPSLocal4Options[local.selectedRow(inComponent: 0)]
            }
            
            if(regional.selectedRow(inComponent: 0) == 5){  //Ner
                localS = NPSLocal5Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 6){  //pwr
                localS = NPSLocal6Options[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 7){  //ser
                localS = NPSLocal7Options[local.selectedRow(inComponent: 0)]
            }
            
        }
        
        //different way for the website ex: NPS_SER_BITTERROOT
        if(agencyS != ""){
            var temp = agencyS
            if(regionalS != ""){
                temp = temp.appending("_")
                temp = temp.appending(regionalS)
                regionalS = temp
            }
            if(localS != ""){
                temp = regionalS
                temp = temp.appending("_")
                temp = temp.appending(localS)
                localS = temp
            }
        }
        
        
        var percent0 = 0
        if(percent0Text.text != ""){
         percent0 = Int(percent0Text.text!)!
        }
        var percent1 = 0
        if(percent1Text.text != ""){
            percent1 = Int(percent1Text.text!)!
        }
        var percent2 = 0
        if(percent2Text.text != ""){
            percent2 = Int(percent2Text.text!)!
        }
        var percent3 = 0
        if(percent3Text.text != ""){
            percent3 = Int(percent3Text.text!)!
        }
        var percent4 = 0
        if(percent4Text.text != ""){
            percent4 = Int(percent4Text.text!)!
        }
        var percent5 = 0
        if(percent5Text.text != ""){
            percent5 = Int(percent5Text.text!)!
        }
        var percent6 = 0
        if(percent6Text.text != ""){
            percent6 = Int(percent6Text.text!)!
        }
        var percent7 = 0
        if(percent7Text.text != ""){
            percent7 = Int(percent7Text.text!)!
        }
        var percent8 = 0
        if(percent8Text.text != ""){
            percent8 = Int(percent8Text.text!)!
        }
        var percent9 = 0
        if(percent9Text.text != ""){
            percent9 = Int(percent9Text.text!)!
        }
        var percent10 = 0
        if(percent10Text.text != ""){
            percent10 = Int(percent10Text.text!)!
        }
        var percent11 = 0
        if(percent11Text.text != ""){
            percent11 = Int(percent11Text.text!)!
        }
        var percent12 = 0
        if(percent12Text.text != ""){
            percent12 = Int(percent12Text.text!)!
        }
        var percent13 = 0
        if(percent13Text.text != ""){
            percent13 = Int(percent13Text.text!)!
        }
        var percent14 = 0
        if(percent14Text.text != ""){
            percent14 = Int(percent14Text.text!)!
        }
        var percent15 = 0
        if(percent15Text.text != ""){
            percent15 = Int(percent15Text.text!)!
        }
        var percent16 = 0
        if(percent16Text.text != ""){
            percent16 = Int(percent16Text.text!)!
        }
        var percent17 = 0
        if(percent17Text.text != ""){
            percent17 = Int(percent17Text.text!)!
        }
        var percent18 = 0
        if(percent18Text.text != ""){
            percent18 = Int(percent18Text.text!)!
        }
        var percent19 = 0
        if(percent19Text.text != ""){
            percent19 = Int(percent19Text.text!)!
        }
        var percent20 = 0
        if(percent20Text.text != ""){
            percent20 = Int(percent20Text.text!)!
        }
    
        let total = totalCostText.text!
        
        
        let postString = "site_id=0&code_relation=\(codeText.text!)&maintenance_type=\(maintenance_type)&road_trail_no=\(rtNumString)&begin_mile_marker=\(beginMileString)&end_mile_marker=\(endMileString)&umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&us_event=\(us_event)&event_desc=\(eventDescriptionText.text!)&design_pse=\(percent0)&remove_ditch_debris=\(percent1)&remove_road_trail_debris=\(percent2)&relevel_aggregate=\(percent3)&relevel_patch=\(percent4)&drainage_improvement=\(percent5)&deep_patch=\(percent6)&haul_debris=\(percent7)&scaling_rock_slopes=\(percent8)&road_trail_alignment=\(percent9)&repair_rockfall_barrier=\(percent10)&repair_rockfall_netting=\(percent11)&sealing_cracks=\(percent12)&guardrail=\(percent13)&cleaning_drains=\(percent14)&flagging_signing=\(percent15)&other1_desc=\(other1Text.text!)&other1=\(percent16)&other2_desc=\(other2Text.text!)&other2=\(percent17)&other3_desc=\(other3Text.text!)&other3=\(percent18)&other4_desc=\(other4Text.text!)&other4=\(percent19)&other5_desc=\(other5Text.text!)&other5=\(percent20)&maintenance_lat=\(shareData.maintenance_lat)&maintenance_long=\(shareData.maintenance_long)&total=\(total)"

            request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                print("error=\(String(describing: error))")
                DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Error", message: "There was an error submitting your information", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                })
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            //user message confirming submit
            DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Success", message: "Information Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            })

        }
        task.resume()

    }
    
    //user clarification message
    @IBAction func submit(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)

    }
    
    //MARK: save offline sites
    
    @IBAction func save(_ sender: AnyObject) {
   
        //core data
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
        
        //latitude/longitude
        site.setValue(shareData.maintenance_lat, forKey: "latitude")
        site.setValue(shareData.maintenance_long, forKey: "longitude")

        
        //success/failure messages to user
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
        
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineMaintenance")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            
            
                    let number = shareData.selectedForm
                    
                    //fill UI with data from saved offline site
            
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
            
                    percent0Text.text = sites[number].value(forKey: "designPSE")! as? String
                    
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
            
                    //latitude & longitude
                    shareData.maintenance_lat = (sites[number].value(forKey: "latitude")! as? String)!
                    shareData.maintenance_long = (sites[number].value(forKey: "longitude")! as? String)!


            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }
    }
    
    //help message
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
