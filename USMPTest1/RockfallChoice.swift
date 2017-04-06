//
//  RockfallChoice.swift
//  USMPTest1
//
//  ViewController for Rockfall Slope Rating Form
//
//  Created by Colleen Rothe on 5/2/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//infix operator from:
//http://stackoverflow.com/questions/29784447/swift-regex-does-a-string-match-a-pattern

//autocomplete:
//http://stackoverflow.com/questions/26885438/getting-autocomplete-to-work-in-swift

//core location:
//http://nshipster.com/core-location-in-ios-8/

//picking image from library
//http://stackoverflow.com/questions/4314405/how-can-i-get-the-name-of-image-picked-through-photo-library-in-iphone

//core data
//https://www.raywenderlich.com/115695/getting-started-with-core-data-tutorial

//TO CHECK CONNECTIVITY
//http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10

//image picker library
//https://github.com/mikaoj/BSImagePicker

import Foundation
import UIKit
import MapKit
import AssetsLibrary
import CoreData
import Photos
import SystemConfiguration
import BSImagePicker

//regex stuff
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

infix operator =~

func =~(string:String, regex:String) -> Bool {
    return string.range(of: regex, options: .regularExpression) != nil
}


class RockfallChoice: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate,RockfallModelHelperProtocol, HazardTypeHelperProtocol {
    
    let shareData = ShareData.sharedInstance
    var feedItems: NSArray = NSArray()
    //for hazard type options
    var hazardItems: NSArray = NSArray()
    var locationManager = CLLocationManager()
    
    //UI Connections
    @IBOutlet weak var agency: UIPickerView!
    var agencyOptions = ["Select Agency option", "FS", "NPS", "BLM", "BIA"]

    
    @IBOutlet weak var regional: UIPickerView!
    var regionalOptions = ["Select Regional option"]
    
    var FSRegionalOptions = ["Select Regional option" ,"Northern_Region", "Rocky_Mountain_Region", "Southwestern_Region", "Intermountain_Region",
                             "Pacific_Southwest_Region","Pacific_Northwest_Region","Southern_Region","Eastern_Region","Alaska_Region"]
    
    var NPSRegionalOptions = ["Select Regional option","AKR","IMR","MWR","NCR","NER","PWR","SER"]

    @IBOutlet weak var local: UIPickerView!
    var localOptions = ["Select Local option"]
    
    var FSNorthernLocal = ["Select Local option","Beaverhead-Deerlodge_National_Forest","Bitterroot_National_Forest",
                           "Dakota_Prairie_National_Grasslands","Flathead_National_Forest","Custer_Gallatin_National_Forest",
                           "Helena_National_Forest","Idaho_Panhandle_National_Forests","Kootenai_National_Forest",
                           "Lewis_&_Clark_National_Forest","Lolo_National_Forest","Nez_Perce-Clearwater_National_Forests"]
    
    var FSRockyMountainLocal = ["Select Local option","Arapaho_and_Roosevelt_National_Forests_and_Pawnee_National_Grassland","Bighorn_National_Forest",
                                "Black_Hills_National_Forest","Grand_Mesa,Uncompahgre_and_Gunnison_National_Forests",
                                "Medicine_Bow-Routt_National_Forests_and_Thunder_Basin_National_Grassland","Nebraska_ National_Forests_and_Grasslands",
                                "Pike_and_San_Isabel_National_Forests_Cimarron_and_Comanche_National_Grasslands","Rio_Grande_National_Forest",
                                "San_Juan_National_Forest","Shoshone_National_Forest","White_River_National_Forest"]
    
    var FSSouthwesternLocal = ["Select Local option","Apache-Sitgreaves_National_Forests","Carson_National_Forest","Cibola_National_Forest",
                               "Coconino_National_Forest","Coronado_National_Forest","Gila_National_Forest",
                               "Kaibab_National_Forest","Lincoln_National_Forest","Prescott_National_Forest",
                               "Santa_Fe_National_Forest","Tonto_National_Forest"]
    
    var FSIntermountainLocal = ["Select Local option","Ashley_National_Forest","Boise_National_Forest","Bridger-Teton_National_Forest",
                                "Caribou-Targhee_National_Forest","Dixie_National_Forest","Fishlake_National_Forest",
                                "Humboldt-Toiyabe_National_Forest","Manti-LaSal_National_Forest","Payette_National_Forest",
                                "Salmon-Challis_National_Forest","Sawtooth_National_Forest","Uinta-Wasatch-Cache_National_Forest"]
    
    var FSPacificSouthwestLocal = ["Select Local option","Angeles_National_Forest","Cleveland_National_Forest","Eldorado_National_Forest",
                                   "Inyo_National_Forest","Klamath_National_Forest","Lake_Tahoe_Basin_Management_Unit",
                                   "Lassen_National_Forest","Los_Padres_National_Forest","Mendocino_National_Forest",
                                   "Modoc_National_Forest","Plumas_National_Forest","San_Bernardino_National_Forest",
                                   "Sequoia_National_Forest","Shasta-Trinity_National_Forest","Sierra_National_Forest",
                                   "Six_Rivers_National_Forest","Stanislaus_National_Forest","Tahoe_National_Forest"]
    
    var FSPacificNorthwestLocal = ["Select Local option","Columbia_River_Gorge_National_Scenic_Area","Colville_National_Forest",
                                   "Crooked_River_National_Grassland","Deschutes_National_Forest",
                                   "Fremont-Winema_National_Forest","Gifford_Pinchot_National_Forest",
                                   "Malheur_National_Forest","Mt._Baker-Snoqualmie_National_Forest",
                                   "Mt._Hood_National_Forest","Ochoco_National_Forest","Okanogan-Wenatchee_National_Forest",
                                   "Olympic_National_Forest","Siuslaw_National_Forest","Rogue_River-Siskiyou_National_Forest",
                                   "Umatilla_National_Forest","Umpqua_National_Forest",
                                   "Wallowa-Whitma_National_Forest","Willamette_National_Forest"]
    
    var FSSouthernLocal = ["Select Local option","Chattahoochee-Oconee_National_Forest","Cherokee_National_Forest","Daniel_Boone_National_Forest",
                           "El_Yunque_National_Forest","Francis_Marion_and_Sumter_National_Forests",
                           "George_Washington_and_Jefferson_National_Forests","Kisatchie_National_Forest",
                           "Land_Between_the_Lakes_Recreation_Area","National_Forests_and_Grasslands_in_Texas",
                           "National_Forests_in_Alabama","National_Forests_in_Florida","National_Forests_in_Mississippi",
                           "National_Forests_in_North_Carolina","Ouachita_National_Forest",
                           "Ozark-St._Francis_National_Forest","Savannah_River_Site"]
    
    var FSEasternLocal = ["Select Local option","Allegheny_National_Forest","Chequamegon-Nicolet_National_Forest","Chippewa_National_Forest",
                          "Green_Mountain_&_Finger_Lakes_National_Forests","Hiawatha_National_Forest","Hoosier_National_Forest",
                          "Huron-Manistee_National_Forests","Mark_Twain_National_Forest","Midewin_National_Tallgrass_Prairie",
                          "Monongahela_National_Forest","Ottawa_National_Forest","Shawnee_National_Forest",
                          "Superior_National_Forest","Wayne_National_Forest","White_Mountain_National_Forest"]
    
    var FSAlaskaLocal = ["Select Local option","Chugach National Forest","Tongass National Forest"]
    
    var NPSAkrLocal = ["Select Local option","KLONDIKE_GOLD_RUSH","SITKA","CAPE_KRUSENSTERN","ANIAKCHAK","KENAI_FJORDS",
                       "KOBUK_VALLEY","DENALI","GATES_OF_THE_ARCTIC","GLACIER_BAY","KATMAI",
                       "LAKE_CLARK","WRANGELL-ST._ELIAS","BERING_LAND_BRIDGE","NOATAK",
                       "YUKON-CHARLEY_RIVERS"]
    
    var NPSImrLocal = ["Select Local option","JOHN_D._ROCKEFELLER,_JR.,","CHACO_CULTURE","LYNDON_B._JOHNSON",
                       "MANHATTAN_PROJECT","PALO_ALTO","PECOS","SAN_ANTONIO_MISSIONS","TUMACACORI",
                       "BENTS_OLD_FORT","FORT_BOWIE","FORT_DAVIS","FORT_LARAMIE","GOLDEN_SPIKE",
                       "GRANT-KOHRS_RANCH","HUBBELL_TRADING_POST","SAND_CREEK_MASSACRE","WASHITA",
                       "ALIBATES_FLINT_QUARRIES","AZTEC_RUINS","BANDELIER","CANYON_DE_CHELLY",
                       "CAPULIN_VOLCANO","CASA_GRANDE_RUINS","CEDAR_BREAKS","CHIRICAHUA","COLORADO",
                       "DEVILS_TOWER","DINOSAUR","EL_MALPAIS","EL_MORRO","FLORISSANT_FOSSIL_BEDS",
                       "FORT_UNION","FOSSIL_BUTTE","GILA_CLIFF_DWELLINGS","HOHOKAM_PIMA","HOVENWEEP",
                       "LITTLE_BIGHORN","MONTEZUMA_CASTLE","NATURAL_BRIDGES","NAVAJO","ORGAN_PIPE_CACTUS",
                       "PETROGLYPH","PIPE_SPRING","RAINBOW_BRIDGE","SALINAS_PUEBLO_MISSIONS",
                       "SUNSET_CRATER_VOLCANO","TIMPANOGOS_CAVE","TONTO","TUZIGOOT","WACO_MAMMOTH",
                       "WALNUT_CANYON","WHITE_SANDS","WUPATKI","YUCCA_HOUSE","CHAMIZAL",
                       "CORONADO","ARCHES","BIG_BEND","BLACK_CANYON_OF_THE_GUNNISON","BRYCE_CANYON",
                       "CANYONLANDS","CAPITOL_REEF","CARLSBAD_CAVERNS","GLACIER","GRAND_CANYON",
                       "GRAND_TETON","GUADALUPE_MOUNTAINS","MESA_VERDE","PETRIFIED_FOREST",
                       "ROCKY_MOUNTAIN","SAGUARO","YELLOWSTONE","ZION","BIG_THICKET",
                       "GREAT_SAND_DUNES","VALLES_CALDERA","AMISTAD","BIGHORN_CANYON ","CHICKASAW",
                       "CURECANTI","GLEN_CANYON","LAKE_MEREDITH","PADRE_ISLAND","RIO_GRANDE"]
    
    var NPSMwrLocal = ["Select Local option","JEFFERSON_NATIONAL_EXPANSION","WILSON’S_CREEK","RIVER_RAISIN","DAYTON_AVIATION_HERITAGE",
                       "GEORGE_ROGERS_CLARK","HOPEWELL_CULTURE","KEWEENAW","BROWN_V._BOARD_OF_EDUCATION",
                       "FIRST_LADIES'","FORT_LARNED","FORT_SCOTT","FORT_SMITH","FORT_UNION_TRADING_POST",
                       "HARRY_S_TRUMAN","HERBERT_HOOVER","JAMES_A._GARFIELD","KNIFE_RIVER_INDIAN_VILLAGES",
                       "LINCOLN_HOME","LITTLE_ROCK_CENTRAL_HIGH_SCHOOL","MINUTEMAN_MISSILE","NICODEMUS",
                       "PRESIDENT_WILLIAM_JEFFERSON_CLINTON_BIRTHPLACE_HOME","ULYSSES_S._GRANT","WILLIAM_HOWARD_TAFT",
                       "APOSTLE_ISLANDS","INDIANA_DUNES","PICTURED_ROCKS","SLEEPING_BEAR_DUNES",
                       "AGATE_FOSSIL_BEDS","CHARLES_YOUNG_BUFFALO_SOLDIERS","EFFIGY_MOUNDS",
                       "GEORGE_WASHINGTON_CARVER","GRAND_PORTAGE","HOMESTEAD","JEWEL_CAVE","PIPESTONE",
                       "PULLMAN","SCOTTS_BLUFF","ARKANSAS_POST","LINCOLN_BOYHOOD","MOUNT_RUSHMORE",
                       "PERRY’S_VICTORY_AND_INTERNATIONAL_PEACE_MEMORIAL","PEA_RIDGE","BADLANDS",
                       "CUYAHOGA_VALLEY","HOT_SPRINGS","ISLE_ROYALE","THEODORE_ROOSEVELT","VOYAGEURS",
                       "WIND_CAVE","TALLGRASS_PRAIRIE","BUFFALO","MISSISSIPPI_NATIONAL_RIVER_AND_RECREATION_AREA",
                       "NIOBRARA","OZARK_NATIONAL_SCENIC_RIVERWAY","SAINT_CROIX","MISSOURI_NATIONAL_RECREATIONAL_RIVER"]
    
    var NPSNcrLocal = ["Select Local option","LINCOLN","THOMAS_JEFFERSON","VIETNAM_VETERANS","WORLD_WAR_II",
                       "GEORGE_WASHINGTON_MEMORIAL_PARKWAY","ANTIETAM","MONOCACY","MANASSAS",
                       "CHESAPEAKE_AND_OHIO_CANAL","HARPERS_FERRY","CARTER_G._WOODSON_HOME","CLARA_BARTON",
                       "FORD'S_THEATRE","FREDERICK_DOUGLASS","MARY_MCLEOD_BETHUNE_COUNCIL_HOUSE",
                       "PENNSYLVANIA_AVENUE","BELMONT-PAUL_WOMEN'S_EQUALITY","ARLINGTON_HOUSE_-_ROBERT_E._LEE_MEMORIAL",
                       "FRANKLIN_DELANO_ROOSEVELT","KOREAN_WAR_VETERANS",
                       "LYNDON_BAINES_JOHNSON_MEMORIAL_GROVE_ON_THE_POTOMAC","MARTIN_LUTHER_KING,_JR.",
                       "THEODORE_ROOSEVELT_ISLAND","WORLD_WAR_I","POTOMAC_HERITAGE","CONSTITUTION_GARDENS",
                       "NATIONAL_CAPITAL_PARKS_-_EAST","NATIONAL_MALL","PRINCE_WILLIAM_FOREST_PARK",
                       "WASHINGTON_MONUMENT","WHITE_HOUSE_PRESIDENTS_PARK","WOLF_TRAP_PARK_FOR_THE_PERFORMING_ARTS",
                       "CATOCTIN_MOUNTAIN","FORT_WASHINGTON","GREEN_BELT","PISCATAWAY","ROCK_CREEK"]
    
    var NPSNerLocal = ["Select Local option","FORT_NECESSITY","PETERSBURG","RICHMOND","ADAMS","APPOMATTOX_COURT_HOUSE",
                       "BLACKSTONE_RIVER_VALLEY","BOSTON","CEDAR_CREEK_&_BELLE_GROVE","COLONIAL",
                       "FIRST_STATE","HARRIET_TUBMAN_UNDERGROUND_RAILROAD","INDEPENDENCE","LOWELL",
                       "MARSH-BILLINGS-ROCKEFELLER","MINUTE_MAN","MORRISTOWN","NEW_BEDFORD_WHALING",
                       "PATERSON_GREAT_FALLS","SARATOGA","THOMAS_EDISON","VALLEY_FORGE","WOMEN'S_RIGHTS",
                       "ALLEGHENY_PORTAGE_RAILROAD","BOSTON_AFRICAN_AMERICAN","EDGAR_ALLAN_POE","EISENHOWER",
                       "ELEANOR_ROOSEVELT","FREDRICK_LAW_OLMSTED","FRIENDSHIP_HILL","HAMPTON",
                       "HOME_OF_FRANKLIN_D._ROOSEVELT","HOPEWELL_FURNACE","JOHN_FITZGERALD_KENNEDY",
                       "LONGFELLOW_HOUSE_-WASHINGTON'S_HEADQUARTERS","MAGGIE_L._WALKER","MARTIN_VAN_BUREN",
                       "SAGAMORE_HILL","SAINT_PAUL'S_CHURCH","SAINT-GAUDENS","SALEM_MARITIME",
                       "SAUGUS_IRON_WORKS","SPRINGFIELD_ARMORY","STEAMTOWN","THEODORE_ROOSEVELT_BIRTHPLACE",
                       "THOMAS_STONE","VANDERBILT_MANSION","WEIR_FARM","AFRICAN_BURIAL_GROUND",
                       "BOOKER_T._WASHINGTON_NM","CASTLE_CLINTON","FORT_MONROE","FORT_STANWIX",
                       "GEORGE_WASHINGTON_BIRTHPLACE","GOVERNORS_ISLAND","KATAHDIN_WOODS_AND_WATERS",
                       "STATUE_OF_LIBERTY_AND_ELLIS_ISLAND","STONEWALL","FEDERAL_HALL","FLIGHT_93",
                       "GENERAL_GRANT","HAMILTON_GRANGE_NM","JOHNSTOWN_FLOOD_NM","ROGER_WILLIAMS",
                       "THADDEUS_KOSCIUSZKO","FREDRICKSBURG_&_SPOTSYLVANIA","GETTYSBURG","ACADIA",
                       "SHENANDOAH","NEW_RIVER_GORGE","BOSTON_HARBOR_ISLANDS","DELAWARE_WATER_GAP",
                       "GATEWAY","GAULEY","ASSATEAGUE_ISLAND_NS","CAPE_COD","FIRE_ISLAND",
                       "BLUESTONE","FORT_MCHENRY_NATIONAL_MONUMENT_AND_HISTORIC_SHRINE",
                       "SAINT_CROIX_ISLAND_INTERNATIONAL_HISTORIC_SITE","GREAT_EGG_HARBOR","UPPER_DELAWARE",
                       "APPALACHIAN"]
    
    var NPSPwrLocal = ["Select Local option","BIG_HOLE","KALAUPAPA","KALOKO-HONOKOHAU","KLONDIKE_GOLD_RUSH",
                       "LEWIS_AND_CLARK","NEZ_PERCE","PU'UHONUA_O_HONAUNAU","ROSIE_THE_RIVETER/WWII_HOME_FRONT",
                       "SAN_FRANCISCO_MARITIME","WAR_IN_THE_PACIFIC","EUGENE_O'NEILL","FORT_POINT",
                       "FORT_VANCOUVER","JOHN_MUIR","MANZANAR","MINIDOKA","PU'UKOHOLA_HEIAU",
                       "SAN_JUAN_ISLAND","WHITMAN_MISSION","CABRILLO","CASTLE_MOUNTAIN",
                       "CESAR_E._CHAVEZ","DEVILS_POSTPILE","HAGERMAN_FOSSIL_BEDS","HONOULIULI",
                       "JOHN_DAY_FOSSIL_BEDS","LAVA_BEDS","MUIR_WOODS","PORT_CHICAGO_NAVAL_MAGAZINE",
                       "TULE_SPRINGS_FOSSIL_BEDS","WORLD_WAR_II_VALOR_IN_THE_PACIFIC","OREGON_CAVES",
                       "CRATERS_OF_THE_MOON","CHANNEL_ISLANDS","CRATER_LAKE","DEATH_VALLEY",
                       "GREAT_BASIN","HALEAKALA","HAWAII_VOLCANOES","JOSHUA_TREE","KINGS_CANYON",
                       "LASSEN_VOLCANIC","MOUNT_RAINIER","NATIONAL_PARK_OF_AMERICAN_SAMOA","NORTH_CASCADES",
                       "OLYMPIC","PINNACLES","REDWOOD","SEQUOIA","YOSEMITE","MOJAVE",
                       "GOLDEN_GATE","LAKE_CHELAN","LAKE_MEAD","LAKE_ROOSEVELT","ROSS_LAKE",
                       "SANTA_MONICA_MOUNTAINS","WHISKEYTOWN","POINT_REYES","AMERICAN_MEMORIAL_PARK",
                       "CITY_OF_ROCKS_NATIONAL_RESERVE","EBEY'S_LANDING_NATIONAL_HISTORICAL_RESERVE"]
    
    var NPSSerLocal = ["Select Local option","COWPENS",
                       "FORT_DONELSON","MOORES_CREEK","STONES_RIVER","TUPELO","KENNESAW_MOUNTAIN",
                       "ABRAHAM_LINCOLN_BIRTHPLACE","CUMBERLAND_GAP","NATCHEZ","NEW_ORLEANS_JAZZ",
                       "ANDERSONVILLE","ANDREW_JOHNSON","CARL_SANDBURG_HOME","CHARLES_PINCKNEY",
                       "CHRISTIANSTED","FORT_RALEIGH","JIMMY_CARTER","MARTIN_LUTHER_KING,_JR.",
                       "NINETY_SIX","SAN_JUAN","TUSKEGEE_AIRMEN","TUSKEGEE_INSTITUTE","BUCK_ISLAND_REEF",
                       "CASTILLO_de_SAN_MARCOS","FORT_FREDERICA","FORT_MATANZAS","FORT_PULASKI",
                       "FORT_SUMTER","OCMULGEE","POVERTY_POINT_STATE","RUSSELL_CAVE",
                       "VIRGIN_ISLANDS_CORAL_REEF","DE_SOTO","FORT_CAROLINE","WRIGHT_BROTHERS",
                       "CHICKAMAUGA_AND_CHATTANOOGA","GUILFORD_COURTHOUSE","HORSESHOE_BEND","KINGS_MOUNTAIN",
                       "SHILOH","VICKSBURG","BISCAYNE","CONGAREE","DRY_TORTUGAS","EVERGLADES",
                       "GREAT_SMOKY_MOUNTAINS","MAMMOTH_CAVE","VIRGIN_ISLANDS","LITTLE_RIVER_CANYON",
                       "BIG_SOUTH_FORK ","CHATTAHOOCHEE","CANAVERAL","CAPE_HATTERAS","CAPE_LOOKOUT",
                       "CUMBERLAND_ISLAND","GULF_ISLANDS","APPALACHIAN","NATCHEZ_TRACE",
                       "BRICES_CROSS_ROADS_NATIONAL_BATTLEFIELD_SITE","CANE_RIVER_CREOLE_NATIONAL_HISTORICAL_PARK_&_HERITAGE_AREA",
                       "JEAN_LAFITTE_NATIONAL_HISTORICAL_PARK_&_PRESERVE","SALT_RIVER_BAY_NATIONAL_HISTORICAL_PARK_&_ECOLOGICAL_PRESERVE",
                       "TIMUCUAN_ECOLOGICAL","BLUE_RIDGE_PARKWAY","OBED"]

    
    @IBOutlet weak var datePicker: UIDatePicker!
    //nav bar
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var slopeRatingFormButton: UIBarButtonItem!
    
    @IBOutlet weak var newSlopeEventButton: UIBarButtonItem!
    
    @IBOutlet weak var maintenanceFormButton: UIBarButtonItem!
        
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var manualButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var speedPicker: UIPickerView!
    
    var speedOptions = ["25 mph", "30 mph", "35 mph", "40 mph", "45 mph", "50 mph", "55 mph", "60 mph", "65 mph", "70 mph"]
    
    @IBOutlet weak var sidePicker: UIPickerView!
    
    var sideOptions = ["L - For use with roads with mile markers","R - For use with roads with mile markers",
                       "N - if road direction not specified with mile mark", "NE - if road direction not specified with mile mark", "E - if road direction not specified with mile mark","SE - if road direction not specified with mile mark", "S - if road direction not specified with mile mark", "SW - if road direction not specified with mile mark", "W - if road direction not specified with mile mark", "NW - if road direction not specified with mile mark"]
    
    @IBOutlet weak var accessPicker: UIPickerView!
    
    var accessOptions = ["Yes", "No"]
    
    @IBOutlet weak var fixesPicker: UIPickerView!
    
    var fixesOptions = ["Yes", "No"]
    
    @IBOutlet weak var rtPicker: UIPickerView!
    
    var rtOptions = ["Road", "Trail"]
    
    @IBOutlet weak var ditchEPicker: UIPickerView!
    
    @IBOutlet weak var rockfallHPicker: UIPickerView!
    
    @IBOutlet weak var impactOUPicker: UIPickerView!
    
    @IBOutlet weak var slopeDPicker: UIPickerView!
    
    @IBOutlet weak var rockfallRMFPicker: UIPickerView!
    
    @IBOutlet weak var structuralC1Picker: UIPickerView!
    
    @IBOutlet weak var rockF1Picker: UIPickerView!
    
    @IBOutlet weak var structuralC2Picker: UIPickerView!
    
    @IBOutlet weak var rockF2Picker: UIPickerView!
    
    @IBOutlet weak var rightOWIPicker: UIPickerView!
    
    @IBOutlet weak var ecImpactsPicker: UIPickerView!
    
    @IBOutlet weak var maintenanceCPicker: UIPickerView!
    
    @IBOutlet weak var eventCPicker: UIPickerView!
    
    var ratingOptions = ["3", "9", "27", "81"]
    
    var specialOptions = ["0", "3", "9", "27", "81"] //to use for geo chars.
    
    //use to calculate F
    
    @IBOutlet weak var blkSizeText: UITextField!
    
    @IBOutlet weak var volumeText: UITextField!
    
    @IBOutlet weak var bsPerEventText: UITextField!
    
    //use to calculate H aadt ETC
    
    @IBOutlet weak var aadtText: UITextField!
    
    @IBOutlet weak var aadtEtcText: UITextField!
    
    //use to calculate J annual rainfall
    
    @IBOutlet weak var beginRainText: UITextField!
    
    @IBOutlet weak var endRainText: UITextField!
    
    @IBOutlet weak var annualRText: UITextField!
    
    //use to calculate K slope height
    
    @IBOutlet weak var slopeHText: UITextField!
    
    @IBOutlet weak var slopeHeightCalcText: UITextField!
    
    //use to calculate V- route trail width
    
    @IBOutlet weak var roadwayTWText: UITextField!
    
    @IBOutlet weak var routeTWText: UITextField!
    
    //use to calculate W- human exposure factor
    
    @IBOutlet weak var humanEFText: UITextField!
    
    //use to calculate X- percent DSD
    
    @IBOutlet weak var percentDSDText: UITextField!
    
    @IBOutlet weak var sightDText: UITextField!
    
    //TOTALS
    
    @IBOutlet weak var preliminaryRatingText: UITextField!
    
    @IBOutlet weak var rockfallHazardTotalText: UITextField!
    
    @IBOutlet weak var riskTotalText: UITextField!
    
    @IBOutlet weak var totalScoreText: UITextField!
    
    //Use to autofill coordinates
    var beginOrEnd = "begin"
    
    @IBOutlet weak var lat1Text: UITextField!
    
    @IBOutlet weak var lat2Text: UITextField!
    
    @IBOutlet weak var long1Text: UITextField!
    
    @IBOutlet weak var long2Text: UITextField!
    
    //site information validations
    
    @IBOutlet weak var roadTrailNoText: UITextField!
    
    @IBOutlet weak var roadTrailClassText: UITextField!
    
    @IBOutlet weak var rater: UITextField!
    
    @IBOutlet weak var beginMileText: UITextField!
    
    @IBOutlet weak var endMileText: UITextField!
    
    @IBOutlet weak var lengthAffectedText: UITextField!
    
    @IBOutlet weak var slopeAngleText: UITextField!
    
    @IBOutlet weak var ditchWidth1Text: UITextField!
    
    @IBOutlet weak var ditchWidth2Text: UITextField!
    
    @IBOutlet weak var ditchDepth1Text: UITextField!
    
    @IBOutlet weak var ditchDepth2Text: UITextField!
    
    @IBOutlet weak var ditchSlope1beginText: UITextField!
    
    @IBOutlet weak var ditchSlope1endText: UITextField!
    
    @IBOutlet weak var ditchSlope2beginText: UITextField!
    
    @IBOutlet weak var ditchSlope2endText: UITextField!
    
    @IBOutlet weak var datumText: UITextField!
    
    @IBOutlet weak var commentsText: UITextView!
    
    @IBOutlet weak var flmaNameText: UITextField!
    
    @IBOutlet weak var flmaIdText: UITextField!
    
    @IBOutlet weak var flmaDescriptionText: UITextField!
    
    //Choosing Images
    
    @IBOutlet weak var imagesLabel: UILabel!
    
    //Images
    var images = [PHAsset]()

    //to load offline site...
    var sites = [NSManagedObject]()             //core data sites
    
    //help keep track of how many of that type of form are saved
    var counted = [NSManagedObject]()             //core data sites
    var saved = 0
    
    var clearNum: UITextField = UITextField()
    var loadNum: UITextField = UITextField()
    var savedNum: UITextField = UITextField()
    var clearString = ""
    var loadString = ""
    var savedString = ""
    
    @IBOutlet weak var submitButton: UIButton!
    
    //aadt
    
    @IBOutlet weak var aadtButton: UIButton!
    
    var selectedAadt = false
    
    @IBOutlet weak var weatherPicker: UIPickerView!
    
     var weatherOptions = ["Clear","Clear and Breezy","A Few Clouds","A Few Clouds and Breezy","Partly Cloudy","Partly Cloudy and Breezy","Mostly Cloudy","Mostly Cloudy and Breezy","Overcast","Overcast and Breezy","Fog","Partial Fog","Freezing Fog","Light Rain","Rain","Heavy Rain","Freezing Rain","Thunderstorms","Snow","Smoky\\/Haze","Unknown"]
    
    @IBOutlet weak var hazardType1: UIPickerView!
    
    @IBOutlet weak var hazardType2: UIPickerView!
    
    @IBOutlet weak var hazardType3: UIPickerView!
    
      var hazardOptions = ["","Planar", "Wedge", "Toppling", "Raveling/Undermining", "Rock Avalanche", "Indeterminate Rock Failures", "Diff. Erosion"]
    
    //autocomplete
    let autoTableMA = UITableView(frame: CGRect(x: 10,y: 200,width: 300,height: 120), style: UITableViewStyle.plain)
    var pastMA = [NSString]()
    var autocompMA = [String]()
    var wordsMA = [NSManagedObject]()
    
    //Rater
    let autoTableR = UITableView(frame: CGRect(x: 10,y: 20,width: 300,height: 120), style: UITableViewStyle.plain)
    var pastR = [NSString]()
    var autocompR = [String]()
    var wordsR = [NSManagedObject]()
    
    //Longitude
    let autoTableLong = UITableView(frame: CGRect(x: 10,y: 20,width: 300,height: 120), style: UITableViewStyle.plain)
    var pastLong = [NSString]()
    var autocompLong = [String]()
    var wordsLong = [NSManagedObject]()
    var long = "one"
    
    //latitude
    let autoTableLat = UITableView(frame: CGRect(x: 10,y: 20,width: 300,height: 120), style: UITableViewStyle.plain)
    var pastLat = [NSString]()
    var autocompLat = [String]()
    var wordsLat = [NSManagedObject]()
    var lat = "one"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //permissions!
        if(shareData.level == 2){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.gray
        }
        
        shareData.OfflineType = "rockfall"
        
        //AUTOCOMPLETE STUFF
        
        //management area
        self.view.addSubview(self.autoTableMA)
        autoTableMA.register(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ACManagement")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            wordsMA = results as! [NSManagedObject] //
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        //do once at beginning to keep it up to date
        for i in 0 ..< wordsMA.count {
            pastMA.append(wordsMA[i].value(forKey: "word") as! NSString)
        }
        
        
        //Management Area
        autoTableMA.delegate = self
        autoTableMA.dataSource = self
        autoTableMA.isScrollEnabled = true
        autoTableMA.isUserInteractionEnabled = true
        autoTableMA.allowsSelectionDuringEditing = true
        autoTableMA.allowsSelection = true
        autoTableMA.isHidden = true  //true
        
        //Rater
        self.view.addSubview(self.autoTableR)
        autoTableR.register(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
        
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ACRater")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest2)
            wordsR = results as! [NSManagedObject] //
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        //do once at beginning to keep it up to date
        for i in 0 ..< wordsR.count {
            print(wordsR[i].value(forKey: "word")!)
            pastR.append((wordsR[i].value(forKey: "word") as! NSString!))
        }
        
        autoTableR.delegate = self
        autoTableR.dataSource = self
        autoTableR.isScrollEnabled = true
        autoTableR.isUserInteractionEnabled = true
        autoTableR.allowsSelectionDuringEditing = true
        autoTableR.allowsSelection = true
        autoTableR.isHidden = true  //true
        
        //Longitude
        self.view.addSubview(self.autoTableLong)
        autoTableLong.register(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
        
        let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: "ACLongitude")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest3)
            wordsLong = results as! [NSManagedObject] //
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        //do once at beginning to keep it up to date
        for i in 0 ..< wordsLong.count {
            print(wordsLong[i].value(forKey: "word")!)
            pastLong.append((wordsLong[i].value(forKey: "word") as! NSString!))
        }
        
        autoTableLong.delegate = self
        autoTableLong.dataSource = self
        autoTableLong.isScrollEnabled = true
        autoTableLong.isUserInteractionEnabled = true
        autoTableLong.allowsSelectionDuringEditing = true
        autoTableLong.allowsSelection = true
        autoTableLong.isHidden = true  //true
        
        //Latitude
        self.view.addSubview(self.autoTableLat)
        autoTableLat.register(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteRowIdentifier")
        
        let fetchRequest4 = NSFetchRequest<NSFetchRequestResult>(entityName: "ACLatitude")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest4)
            wordsLat = results as! [NSManagedObject] //
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        //do once at beginning to keep it up to date
        for i in 0 ..< wordsLat.count {
            print(wordsLat[i].value(forKey: "word")!)
            pastLat.append((wordsLat[i].value(forKey: "word") as! NSString))
        }
        
        autoTableLat.delegate = self
        autoTableLat.dataSource = self
        autoTableLat.isScrollEnabled = true
        autoTableLat.isUserInteractionEnabled = true
        autoTableLat.allowsSelectionDuringEditing = true
        autoTableLat.allowsSelection = true
        autoTableLat.isHidden = true  //true
        
        //Pickers
        agency.delegate = self
        agency.dataSource = self
        
        regional.delegate = self
        regional.dataSource = self
        
        local.delegate = self
        local.dataSource = self
        
        rtPicker.delegate = self
        rtPicker.dataSource = self
        
        sidePicker.delegate = self
        sidePicker.dataSource = self
        
        speedPicker.delegate = self
        speedPicker.dataSource = self
        
        accessPicker.delegate = self
        accessPicker.dataSource = self
        
        fixesPicker.delegate = self
        fixesPicker.dataSource = self
        
        ditchEPicker.dataSource = self
        ditchEPicker.delegate = self
        
        rockfallHPicker.delegate = self
        rockfallHPicker.dataSource = self
        
        impactOUPicker.delegate = self
        impactOUPicker.dataSource = self
        
        rockfallRMFPicker.delegate = self
        rockfallRMFPicker.dataSource = self
        
        structuralC1Picker.delegate = self
        structuralC1Picker.dataSource = self
        
        rockF1Picker.delegate = self
        rockF1Picker.dataSource = self
        
        structuralC2Picker.delegate = self
        structuralC2Picker.dataSource = self
        
        rockF2Picker.delegate = self
        rockF2Picker.dataSource = self
        
        rightOWIPicker.delegate = self
        rightOWIPicker.dataSource = self
        
        ecImpactsPicker.delegate = self
        ecImpactsPicker.dataSource = self
        
        maintenanceCPicker.delegate = self
        maintenanceCPicker.dataSource = self
        
        eventCPicker.delegate = self
        eventCPicker.dataSource = self
        
        slopeDPicker.delegate = self
        slopeDPicker.dataSource = self
        
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
        
        //text field delegates
        bsPerEventText.delegate = self
        aadtEtcText.delegate = self
        annualRText.delegate = self
        slopeHeightCalcText.delegate = self
        routeTWText.delegate = self
        humanEFText.delegate = self
        percentDSDText.delegate = self
        preliminaryRatingText.delegate = self
        rockfallHazardTotalText.delegate = self
        riskTotalText.delegate = self
        totalScoreText.delegate = self
        
        lat1Text.delegate = self
        lat2Text.delegate = self
        long1Text.delegate = self
        long2Text.delegate = self
        
        sightDText.delegate = self
        roadwayTWText.delegate = self
        slopeHText.delegate = self
        beginRainText.delegate = self
        endRainText.delegate = self
        aadtText.delegate = self
        blkSizeText.delegate = self
        volumeText.delegate = self
        datumText.delegate = self
        flmaNameText.delegate = self
        flmaIdText.delegate = self
        flmaDescriptionText.delegate = self
        
        hazardType1.delegate = self
        hazardType1.dataSource = self
        
        hazardType2.delegate = self
        hazardType2.dataSource = self
        
        hazardType3.delegate = self
        hazardType3.dataSource = self
        
        roadTrailNoText.delegate = self
        
        roadTrailClassText.delegate = self
        
        rater.delegate = self
        
        beginMileText.delegate = self
        beginMileText.keyboardType = .decimalPad //keyboard w/ numbers and a decimal point
        
        endMileText.delegate = self
        endMileText.keyboardType = .decimalPad //keyboard w/ numbers and a decimal point
        
        aadtText.keyboardType = .numberPad
        
        lengthAffectedText.delegate = self
        lengthAffectedText.keyboardType = .decimalPad
        
        slopeHText.keyboardType = .decimalPad
        
        slopeAngleText.delegate = self
        slopeAngleText.keyboardType = .numberPad
        
        sightDText.keyboardType = .decimalPad
        
        roadwayTWText.keyboardType = .decimalPad
        
        ditchWidth1Text.delegate = self
        ditchWidth2Text.delegate = self
        ditchWidth1Text.keyboardType = .decimalPad
        ditchWidth2Text.keyboardType = .decimalPad
        
        ditchDepth1Text.delegate = self
        ditchDepth2Text.delegate = self
        ditchDepth1Text.keyboardType = .decimalPad
        ditchDepth2Text.keyboardType = .decimalPad
        
        ditchSlope1endText.delegate = self
        ditchSlope1beginText.delegate = self
        ditchSlope2endText.delegate = self
        ditchSlope2beginText.delegate = self
        ditchSlope1beginText.keyboardType = .numberPad
        ditchSlope1endText.keyboardType = .numberPad
        ditchSlope2beginText.keyboardType = .numberPad
        ditchSlope2endText.keyboardType = .numberPad
        
        blkSizeText.keyboardType = .decimalPad
        volumeText.keyboardType = .decimalPad
        
        beginRainText.keyboardType = .decimalPad
        endRainText.keyboardType = .decimalPad
        
        bsPerEventText.keyboardType = .numberPad
        aadtEtcText.keyboardType = .numberPad
        
        annualRText.keyboardType = .numberPad
        slopeHText.keyboardType = .numberPad
        
        //risk ratings
        routeTWText.keyboardType = .numberPad
        humanEFText.keyboardType = .numberPad
        percentDSDText.keyboardType = .numberPad
        
        //always 1?
        humanEFText.text = "1"
        
        lat1Text.delegate = self
        lat2Text.delegate = self
        long1Text.delegate = self
        long2Text.delegate = self

        //Scroller
        scrollView.isScrollEnabled = true
       
        scrollView.contentSize = CGSize(width: 600, height: 9000) //set content size (= to view)
        
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
        
        //autofill coordinates of user's location
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //download hazard type list
        if(isInternetAvailable()){
            //hazard type options
            let hth = HazardTypeHelper()
            hth.delegate = self
            hth.downloadItems()
        }
        
        if(shareData.load == true){
            //call special load method
            loadFromList()
        }
        //editing offline
        if(shareData.offline_edit == true){
            shareData.offline_edit = false
            offlineEdit()
        }
        //editing site online
        else if(shareData.edit_site == true){
            shareData.edit_site = false; //??
            edit()
        }
        //internet available?
        if(!isInternetAvailable()){
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.darkGray
        }
        
        //dismiss keyboard...
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RockfallChoice.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false //for the autocomplete

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
    
    //call rockfall model helper to get data on the site
    func edit(){
        let rimh = RockfallModelHelper()
        rimh.delegate = self
        rimh.downloadItems()
        
    }
    
    //data downloaded, call to fill form
    func itemsDownloadedR(_ items: NSArray) {
        feedItems = items
        fillToEdit()
    }
    
    //get the info from the db call - HazardTypeHelper.swift
    func itemsDownloadedH(_ items: NSArray) {
        hazardItems = items
    }
    
    //fill form with rockfall site information, from RockfallModel
    func fillToEdit(){
        let selectedLocation = feedItems.object(at: 0) as! RockfallModel
        
        let agencyS = selectedLocation.umbrella_agency
        let regionS = selectedLocation.regiona_admin
        let localS = selectedLocation.local_admin
        
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
        
        if(FSRegionalOptions.contains(regionS!)){
            regional.selectRow(FSRegionalOptions.index(of: regionS!)!, inComponent: 0, animated: true)
            self.regional.delegate?.pickerView!(regional, didSelectRow: FSRegionalOptions.index(of: regionS!)!, inComponent: 0)
            if(FSNorthernLocal.contains(localS!)){
                local.selectRow(FSNorthernLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSRockyMountainLocal.contains(localS!)){
                local.selectRow(FSRockyMountainLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSSouthwesternLocal.contains(localS!)){
                local.selectRow(FSSouthwesternLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSIntermountainLocal.contains(localS!)){
                local.selectRow(FSIntermountainLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSPacificSouthwestLocal.contains(localS!)){
                local.selectRow(FSPacificSouthwestLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSPacificNorthwestLocal.contains(localS!)){
                local.selectRow(FSPacificNorthwestLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSSouthernLocal.contains(localS!)){
                local.selectRow(FSSouthernLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSEasternLocal.contains(localS!)){
                local.selectRow(FSEasternLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(FSAlaskaLocal.contains(localS!)){
                local.selectRow(FSAlaskaLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }
        
        }
        
        else if(NPSRegionalOptions.contains(regionS!)){
            regional.selectRow(NPSRegionalOptions.index(of: regionS!)!, inComponent: 0, animated: true)
            self.regional.delegate?.pickerView!(regional, didSelectRow: NPSRegionalOptions.index(of: regionS!)!, inComponent: 0)
            
            if(NPSAkrLocal.contains(localS!)){
                local.selectRow(NPSAkrLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSImrLocal.contains(localS!)){
                local.selectRow(NPSImrLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSMwrLocal.contains(localS!)){
                local.selectRow(NPSMwrLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSNcrLocal.contains(localS!)){
                local.selectRow(NPSNcrLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSNerLocal.contains(localS!)){
                local.selectRow(NPSNerLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSPwrLocal.contains(localS!)){
                local.selectRow(NPSPwrLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }else if(NPSSerLocal.contains(localS!)){
                local.selectRow(NPSSerLocal.index(of: localS!)!, inComponent: 0, animated: true)
            }
            
        }
        
        //date?
        let road_or_trail = selectedLocation.road_or_trail
        if(road_or_trail == "T"){
            rtPicker.selectRow(1, inComponent: 0, animated: true)
        }
        else{
            rtPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        //FORMAT DATE FOR THE DATE PICKER
        var dateString = "2017-12-01"
        dateString = selectedLocation.date!
        let dateIndex = dateString.index(dateString.startIndex, offsetBy: 10)
        dateString = dateString.substring(to: dateIndex)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.date(from: dateString)
        datePicker.setDate(dateFromString!, animated: true)
        
        roadTrailNoText.text = selectedLocation.road_trail_no
        roadTrailClassText.text = selectedLocation.road_trail_class
        rater.text = selectedLocation.rater
        beginMileText.text = selectedLocation.begin_mile_marker
        endMileText.text = selectedLocation.end_mile_marker
        
        let side = selectedLocation.side as String!
        if(sideOptions.contains(side!)){
            let temp = sideOptions.index(of: side!)
            sidePicker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        let weather = selectedLocation.weather as String!
        if (weatherOptions.contains(weather!)){
            let temp = weatherOptions.index(of: weather!)
            weatherPicker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        //TODO: Hazard Type (1)
        var hazardString = ""
        hazardString = selectedLocation.hazard_type!
        let hazardA = hazardString.components(separatedBy: ",")
        if(hazardA.count > 0){
            for i in 0 ... (hazardA.count - 1){
                if i == 0 {
                    if hazardOptions.contains(hazardA[i]){
                        hazardType1.selectRow(hazardOptions.index(of: hazardA[i])!, inComponent: 0, animated: true)
                    } //end if
                } //end if i
                else if i == 1 {
                    if hazardOptions.contains(hazardA[i]){
                        hazardType2.selectRow(hazardOptions.index(of: hazardA[i])!, inComponent: 0, animated: true)
                    } //end if
                } //end if i
                else if i == 2 {
                    if hazardOptions.contains(hazardA[i]){
                        hazardType3.selectRow(hazardOptions.index(of: hazardA[i])!, inComponent: 0, animated: true)
                    } //end if
                } //end if i
            }
        }
        
        lat1Text.text = selectedLocation.begin_coordinate_lat
        lat2Text.text = selectedLocation.end_coordinate_lat
        long1Text.text = selectedLocation.begin_coordinate_long
        long2Text.text = selectedLocation.end_coordinate_long
        datumText.text = selectedLocation.datum
        aadtText.text = selectedLocation.aadt
        lengthAffectedText.text = selectedLocation.length_affected
        slopeHText.text = selectedLocation.slope_ht_axial_length
        slopeAngleText.text = selectedLocation.slope_angle
        sightDText.text = selectedLocation.sight_distance
        roadwayTWText.text = selectedLocation.road_trail_width
        //come back to this...need to increase options??
        //let speed_limit = selectedLocation.speed_limit
        
        ditchWidth1Text.text = selectedLocation.minimum_ditch_width
        ditchWidth2Text.text = selectedLocation.maximum_ditch_width
        ditchDepth1Text.text = selectedLocation.minimum_ditch_depth
        ditchDepth2Text.text = selectedLocation.maximum_ditch_depth
        ditchSlope1beginText.text = selectedLocation.minimum_ditch_slope_first
        ditchSlope1endText.text = selectedLocation.maximum_ditch_slope_first
        ditchSlope2beginText.text = selectedLocation.minimum_ditch_slope_second
        ditchSlope2endText.text = selectedLocation.maximum_ditch_slope_second
        beginRainText.text = selectedLocation.begin_annual_rainfall
        endRainText.text = selectedLocation.end_annual_rainfall
        let sole_access_route = selectedLocation.sole_access_route
        if(sole_access_route == "No"){
            accessPicker.selectRow(1, inComponent: 0, animated: true)
        }
        else{
            accessPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        let mitigation_present = selectedLocation.fixes_present
        if(mitigation_present == "No"){
            fixesPicker.selectRow(1, inComponent: 0, animated: true)
        }
        else{
            fixesPicker.selectRow(0, inComponent: 0, animated: true)
        }
        //photos???
        
        commentsText.text = selectedLocation.comments
        flmaNameText.text = selectedLocation.flma_name
        flmaIdText.text = selectedLocation.flma_id
        flmaDescriptionText.text = selectedLocation.flma_description
        
        //Prelim Ratings...Rockfall Only
        let ditch_effectiveness = selectedLocation.prelim_rockfall_ditch_eff as String!
        if(ratingOptions.contains(ditch_effectiveness!)){
            let tempDitch = ratingOptions.index(of: ditch_effectiveness!)
            ditchEPicker.selectRow(tempDitch!, inComponent: 0, animated: true)
        }
        
        let rockfall_history = selectedLocation.prelim_rockfall_rockfall_history as String!
        if(ratingOptions.contains(rockfall_history!)){
            let temp_history = ratingOptions.index(of: rockfall_history!)
            rockfallHPicker.selectRow(temp_history!, inComponent: 0, animated: true)
        }
        
        let bsv = selectedLocation.prelim_rockfall_block_size_event_vol as String!
        if(ratingOptions.contains(bsv!)){
            let temp_bsv = ratingOptions.index(of: bsv!)
            rockfallHPicker.selectRow(temp_bsv!, inComponent: 0, animated: true)
        }
        
        //Prelim Ratings...all
        let impact_on_use = selectedLocation.impact_on_use
        if(impact_on_use == "81"){
            impactOUPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(impact_on_use == "27"){
            impactOUPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(impact_on_use == "9"){
            impactOUPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            impactOUPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        //1 is true, 0 is false
        let aadt_usage_checked = selectedLocation.aadt_usage_calc_checkbox
        if(aadt_usage_checked == "1"){
            let image = UIImage(named: "checkmark")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = true
        }else{
            let image = UIImage(named: "unchecked")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = false
        }
        
        aadtEtcText.text = selectedLocation.aadt_usage
        preliminaryRatingText.text = selectedLocation.prelim_rating
        
        //Slope Hazard Rating-All
        let slope_drainage = selectedLocation.slope_drainage
        if(slope_drainage == "81"){
            slopeDPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(slope_drainage == "27"){
            slopeDPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(slope_drainage == "9"){
            slopeDPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            slopeDPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        annualRText.text = selectedLocation.hazard_rating_annual_rainfall
        slopeHeightCalcText.text = selectedLocation.hazard_rating_slope_height_axial_length
        rockfallHazardTotalText.text = selectedLocation.hazard_total
        
        //Hazard Rating - Rockfall Only
        let rrmf = selectedLocation.hazard_rockfall_maint_frequency
        if(ratingOptions.contains(rrmf!)){
            let temp = ratingOptions.index(of: rrmf!)
            rockfallRMFPicker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        let struct1 = selectedLocation.case_one_struc_cond
        if(ratingOptions.contains(struct1!)){
            let temp = ratingOptions.index(of: struct1!)
            structuralC1Picker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        let rockf1 = selectedLocation.case_one_rock_friction
        if(ratingOptions.contains(rockf1!)){
            let temp = ratingOptions.index(of: rockf1!)
            rockF1Picker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        let struct2 = selectedLocation.case_two_struc_cond
        if(ratingOptions.contains(struct2!)){
            let temp = ratingOptions.index(of: struct2!)
            structuralC2Picker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        let diff2 = selectedLocation.case_two_diff_erosion
        if(ratingOptions.contains(diff2!)){
            let temp = ratingOptions.index(of: diff2!)
            rockF2Picker.selectRow(temp!, inComponent: 0, animated: true)
        }
        
        //Risk Ratings -All
        routeTWText.text = selectedLocation.route_trail_width
        humanEFText.text = selectedLocation.human_ex_factor
        percentDSDText.text = selectedLocation.percent_dsd
        let r_w_impact = selectedLocation.r_w_impacts
        if(r_w_impact == "81"){
            rightOWIPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(r_w_impact == "27"){
            rightOWIPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(r_w_impact == "9"){
            rightOWIPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            rightOWIPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        let ec_impact = selectedLocation.enviro_cult_impacts
        if(ec_impact == "81"){
            ecImpactsPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(ec_impact == "27"){
            ecImpactsPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(ec_impact == "9"){
            ecImpactsPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            ecImpactsPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        let maint_complexity = selectedLocation.maint_complexity
        if(maint_complexity == "81"){
            maintenanceCPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(maint_complexity == "27"){
            maintenanceCPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(maint_complexity == "9"){
            maintenanceCPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            maintenanceCPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        let event_cost = selectedLocation.event_cost
        if(event_cost == "81"){
            eventCPicker.selectRow(3, inComponent: 0, animated: true)
        }else if(event_cost == "27"){
            eventCPicker.selectRow(2, inComponent: 0, animated: true)
        }else if(event_cost == "9"){
            eventCPicker.selectRow(1, inComponent: 0, animated: true)
        }else{
            eventCPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        riskTotalText.text = selectedLocation.risk_total
        
        //total score
        totalScoreText.text = selectedLocation.total_score
    }
    
    //edit form in offline mode
    func offlineEdit(){
        //get the site from core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSiteFull")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            var number = 0;
            let wanted = shareData.offline_edit_site_id
            for i in 0 ... sites.count-1{
                if( wanted ==  sites[i].value(forKey: "site_id") as? String){
                    number = i
                }
            }
            
            //fill in the UI
            let agencyS = sites[number].value(forKey: "umbrella_agency")! as? String
            
            for i in 0 ... (agencyOptions.count - 1){
                if (agencyOptions[i] == agencyS){
                    agency.selectRow(agencyOptions.index(of: agencyS!)!, inComponent: 0, animated: true)
                }
            }
            
            let regional_admin = sites[number].value(forKey: "regional_admin")! as? String
            let local_admin = sites[number].value(forKey: "local_admin")! as? String
            
            //FS
            if(agency.selectedRow(inComponent: 0) == 1){
                if(FSRegionalOptions.contains(regional_admin!)){
                   regional.selectRow(FSRegionalOptions.index(of: regional_admin!)!, inComponent: 0, animated: true)
                    
                    if(FSNorthernLocal.contains(local_admin!)){
                        local.selectRow(FSNorthernLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSRockyMountainLocal.contains(local_admin!)){
                        local.selectRow(FSRockyMountainLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSSouthwesternLocal.contains(local_admin!)){
                        local.selectRow(FSSouthwesternLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSIntermountainLocal.contains(local_admin!)){
                        local.selectRow(FSIntermountainLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSPacificSouthwestLocal.contains(local_admin!)){
                        local.selectRow(FSPacificSouthwestLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSPacificNorthwestLocal.contains(local_admin!)){
                        local.selectRow(FSSouthwesternLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSSouthernLocal.contains(local_admin!)){
                        local.selectRow(FSSouthernLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSEasternLocal.contains(local_admin!)){
                        local.selectRow(FSEasternLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                    else if(FSAlaskaLocal.contains(local_admin!)){
                        local.selectRow(FSAlaskaLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                    }
                }
            }
            
            //NPS
            if(agency.selectedRow(inComponent: 0) == 2){
                    if(NPSRegionalOptions.contains(regional_admin!)){
                        regional.selectRow(NPSRegionalOptions.index(of: regional_admin!)!, inComponent: 0, animated: true)
                        
                        if(NPSAkrLocal.contains(local_admin!)){
                            local.selectRow(NPSAkrLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSImrLocal.contains(local_admin!)){
                            local.selectRow(NPSImrLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSMwrLocal.contains(local_admin!)){
                            local.selectRow(NPSMwrLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSNcrLocal.contains(local_admin!)){
                            local.selectRow(NPSNcrLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSNerLocal.contains(local_admin!)){
                            local.selectRow(NPSNerLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSPwrLocal.contains(local_admin!)){
                            local.selectRow(NPSPwrLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                        else if(NPSSerLocal.contains(local_admin!)){
                            local.selectRow(NPSSerLocal.index(of: local_admin!)!, inComponent: 0, animated: true)
                        }
                    }
                }
            
            roadTrailNoText.text = sites[number].value(forKey: "road_trail_no")! as? String
            roadTrailClassText.text = sites[number].value(forKey: "road_trail_class")! as? String
            beginMileText.text = sites[number].value(forKey: "begin_mile_marker")! as? String
            endMileText.text = sites[number].value(forKey: "end_mile_marker")! as? String
            let road_or_trail = sites[number].value(forKey: "road_or_trail")! as? String
            if(road_or_trail == "T"){
                rtPicker.selectRow(1, inComponent: 0, animated: true)
            }
            let side = sites[number].value(forKey: "side")! as? String
            
            if(sideOptions.contains(side!)){
                let sideNum = sideOptions.index(of: side!)
                sidePicker.selectRow(sideNum!, inComponent: 0, animated: true)
            }
            
            rater.text = sites[number].value(forKey: "rater")! as? String
            let weather = sites[number].value(forKey: "weather")! as? String
            if(weatherOptions.contains(weather!)){
                let weatherNum = weatherOptions.index(of: weather!)
                weatherPicker.selectRow(weatherNum!, inComponent: 0, animated: true)
            }
            let date = sites[number].value(forKey: "date")! as? Date
            //datePicker.setDate(date!, animated: true)
            
            lat1Text.text = sites[number].value(forKey: "begin_coordinate_lat")! as? String
            lat2Text.text = sites[number].value(forKey: "end_coordinate_lat")! as? String
            long1Text.text = sites[number].value(forKey: "begin_coordinate_long")! as? String
            long2Text.text = sites[number].value(forKey: "end_coordinate_long")! as? String
            datumText.text = sites[number].value(forKey: "datum")! as? String
            aadtText.text = sites[number].value(forKey: "aadt")! as? String
            lengthAffectedText.text = sites[number].value(forKey: "length_affected")! as? String
            slopeHText.text = sites[number].value(forKey: "slope_ht_axial_length")! as? String
            slopeAngleText.text = sites[number].value(forKey: "slope_angle")! as? String
            sightDText.text = sites[number].value(forKey: "sight_distance")! as? String
            roadwayTWText.text = sites[number].value(forKey: "road_trail_width")! as? String
            let speedLimit = sites[number].value(forKey: "speed_limit")! as? String
            if(speedOptions.contains(speedLimit!)){
                let speedNum = speedOptions.index(of: speedLimit!)
                speedPicker.selectRow(speedNum!, inComponent: 0, animated: true)
            }
            ditchWidth1Text.text = sites[number].value(forKey: "minimum_ditch_width")! as? String
            ditchWidth2Text.text = sites[number].value(forKey: "maximum_ditch_width")! as? String
            ditchDepth1Text.text = sites[number].value(forKey: "minimum_ditch_depth")! as? String
            ditchDepth2Text.text = sites[number].value(forKey: "maximum_ditch_depth")! as? String
            ditchSlope1beginText.text = sites[number].value(forKey: "minimum_ditch_slope_first")! as? String
            ditchSlope1endText.text = sites[number].value(forKey: "maximum_ditch_slope_first")! as? String
            ditchSlope2beginText.text = sites[number].value(forKey: "minimum_ditch_slope_second")! as? String
            ditchSlope2endText.text = sites[number].value(forKey: "maximum_ditch_slope_second")! as? String
            blkSizeText.text = sites[number].value(forKey: "blk_size")! as? String
            volumeText.text = sites[number].value(forKey: "volume")! as? String
            beginRainText.text = sites[number].value(forKey: "begin_annual_rainfall")! as? String
            endRainText.text = sites[number].value(forKey: "end_annual_rainfall")! as? String
            let sole_access_route = sites[number].value(forKey: "sole_access_route")! as? String
            if(sole_access_route == "N"){
                accessPicker.selectRow(1, inComponent: 0, animated: true)
            }else{
                accessPicker.selectRow(0, inComponent: 0, animated: true)
            }
            let fixes_present = sites[number].value(forKey: "fixes_present")! as? String
            if(fixes_present == "N"){
                fixesPicker.selectRow(1, inComponent: 0, animated: true)
            }
            
            let preliminary_rating_impact_on_use = sites[number].value(forKey: "preliminary_rating_impact_on_use")! as? String
            if(ratingOptions.contains(preliminary_rating_impact_on_use!)){
                impactOUPicker.selectRow(ratingOptions.index(of: preliminary_rating_impact_on_use!)!, inComponent: 0, animated: true)
            }
            //1 true, 0 false
            let preliminary_rating_aadt_usage_calc_checkbox = sites[number].value(forKey: "preliminary_rating_aadt_usage_calc_checkbox")! as? String
            
            if(preliminary_rating_aadt_usage_calc_checkbox == "1"){
                let image = UIImage(named: "checkmark")
                aadtButton.setImage(image, for: UIControlState())
                selectedAadt = true
            }else{
                let image = UIImage(named: "unchecked")
                aadtButton.setImage(image, for: UIControlState())
                selectedAadt = false
            }
            
            aadtEtcText.text = sites[number].value(forKey: "preliminary_rating_aadt_usage")! as? String
            preliminaryRatingText.text = sites[number].value(forKey: "preliminary_rating")! as? String
            let hazard_rating_slope_drainage = sites[number].value(forKey: "hazard_rating_slope_drainage")! as? String
            if(ratingOptions.contains(hazard_rating_slope_drainage!)){
                slopeDPicker.selectRow(ratingOptions.index(of: hazard_rating_slope_drainage!)!, inComponent: 0, animated: true)
            }
            
            annualRText.text = sites[number].value(forKey: "hazard_rating_annual_rainfall")! as? String
            slopeHeightCalcText.text = sites[number].value(forKey: "hazard_rating_slope_height_axial_length")! as? String
            routeTWText.text = sites[number].value(forKey: "risk_rating_route_trail")! as? String
            humanEFText.text = sites[number].value(forKey: "risk_rating_human_ex_factor")! as? String
            percentDSDText.text = sites[number].value(forKey: "risk_rating_percent_dsd")! as? String
            let risk_rating_r_w_impacts = sites[number].value(forKey: "risk_rating_r_w_impacts")! as? String
            if(ratingOptions.contains(risk_rating_r_w_impacts!)){
                rightOWIPicker.selectRow(ratingOptions.index(of: risk_rating_r_w_impacts!)!, inComponent: 0, animated: true)
            }
            let risk_rating_enviro_cult_impacts = sites[number].value(forKey: "risk_rating_enviro_cult_impacts")! as? String
            if(ratingOptions.contains(risk_rating_enviro_cult_impacts!)){
                ecImpactsPicker.selectRow(ratingOptions.index(of: risk_rating_enviro_cult_impacts!)!, inComponent: 0, animated: true)
            }
            let risk_rating_maint_complexity = sites[number].value(forKey: "risk_rating_maint_complexity")! as? String
            if(ratingOptions.contains(risk_rating_maint_complexity!)){
                maintenanceCPicker.selectRow(ratingOptions.index(of: risk_rating_maint_complexity!)!, inComponent: 0, animated: true)
            }
            let risk_rating_event_cost = sites[number].value(forKey: "risk_rating_event_cost")! as? String
            if(ratingOptions.contains(risk_rating_event_cost!)){
                eventCPicker.selectRow(ratingOptions.index(of: risk_rating_event_cost!)!, inComponent: 0, animated: true)
            }
            
            rockfallHazardTotalText.text = sites[number].value(forKey: "hazard_total")! as? String
            totalScoreText.text = sites[number].value(forKey: "total_score")! as? String
            commentsText.text = sites[number].value(forKey: "comment")! as? String
            //TODO: hazard type (2)
            //hazardTypeText.text = sites[number].value(forKey: "hazard_type")! as? String
            
            //ROCKFALL ONLY
            let rockfall_prelim_ditch_eff = sites[number].value(forKey: "rockfall_prelim_ditch_eff")! as? String
            if(ratingOptions.contains(rockfall_prelim_ditch_eff!)){
                ditchEPicker.selectRow(ratingOptions.index(of: rockfall_prelim_ditch_eff!)!, inComponent: 0, animated: true)
            }
            
            let rockfall_prelim_rockfall_history = sites[number].value(forKey: "rockfall_prelim_rockfall_history")! as? String
            if(ratingOptions.contains(rockfall_prelim_rockfall_history!)){
                rockfallHPicker.selectRow(ratingOptions.index(of: rockfall_prelim_rockfall_history!)!, inComponent: 0, animated: true)
            }
            
            bsPerEventText.text = sites[number].value(forKey: "rockfall_prelim_block_size_event_vol")! as? String
            
            let rockfall_hazard_rating_maint_frequency = sites[number].value(forKey: "rockfall_hazard_rating_maint_frequency")! as? String
            if(ratingOptions.contains(rockfall_hazard_rating_maint_frequency!)){
                rockfallRMFPicker.selectRow(ratingOptions.index(of: rockfall_hazard_rating_maint_frequency!)!, inComponent: 0, animated: true)
            }
            
            let rockfall_hazard_rating_case_one_struc_condition = sites[number].value(forKey: "rockfall_hazard_rating_case_one_struc_condition")! as? String
            if(specialOptions.contains(rockfall_hazard_rating_case_one_struc_condition!)){
                structuralC1Picker.selectRow(specialOptions.index(of: rockfall_hazard_rating_case_one_struc_condition!)!, inComponent: 0, animated: true)
            }
            
            let rockfall_hazard_rating_case_one_rock_friction = sites[number].value(forKey: "rockfall_hazard_rating_case_one_rock_friction")! as? String
            if(specialOptions.contains(rockfall_hazard_rating_case_one_rock_friction!)){
                rockF1Picker.selectRow(specialOptions.index(of: rockfall_hazard_rating_case_one_rock_friction!)!, inComponent: 0, animated: true)
            }
            
            let rockfall_hazard_rating_case_two_struc_condition = sites[number].value(forKey: "rockfall_hazard_rating_case_two_struc_condition")! as? String
            if(specialOptions.contains(rockfall_hazard_rating_case_two_struc_condition!)){
                structuralC2Picker.selectRow(specialOptions.index(of: rockfall_hazard_rating_case_two_struc_condition!)!, inComponent: 0, animated: true)
            }
            
            let rockfall_hazard_rating_case_two_diff_erosion = sites[number].value(forKey: "rockfall_hazard_rating_case_two_diff_erosion")! as? String
            if(specialOptions.contains(rockfall_hazard_rating_case_two_diff_erosion!)){
                rockF2Picker.selectRow(specialOptions.index(of: rockfall_hazard_rating_case_two_diff_erosion!)!, inComponent: 0, animated: true)
            }
            
            //flma link
            flmaIdText.text = sites[number].value(forKey: "flma_id")! as? String
            flmaNameText.text = sites[number].value(forKey: "flma_name")! as? String
            flmaDescriptionText.text = sites[number].value(forKey: "flma_description")! as? String
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: location manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //limit to 6 significant digits based on stakeholder feedback
        
        if(beginOrEnd == "begin"){
            lat1Text.text = String(format: "%f",locValue.latitude)
            long1Text.text = String(format: "%f",locValue.longitude)
        }
        if(beginOrEnd == "end"){
            lat2Text.text = String(format: "%f",locValue.latitude)
            long2Text.text = String(format: "%f",locValue.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
        print(error)
        
        let messageString = "Unable to retrieve location information. Error : \(error)"
        
        let alertController = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: Automplete Stuff
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == rater){
            let substring2 = (rater.text! as NSString).replacingCharacters(in: range, with: string)
            autocompleteR(substring2)
        }else if (textField == long1Text){
            let substring3 = (long1Text.text! as NSString).replacingCharacters(in: range, with: string)
            autocompleteLong(substring3)
            
        }else if (textField == long2Text){
            let substring3 = (long2Text.text! as NSString).replacingCharacters(in: range, with: string)
            autocompleteLong(substring3)
            
        }else if (textField == lat1Text){
            let substring4 = (lat1Text.text! as NSString).replacingCharacters(in: range, with: string)
            autocompleteLat(substring4)
            
        }else if (textField == lat2Text){
            let substring4 = (lat2Text.text! as NSString).replacingCharacters(in: range, with: string)
            autocompleteLat(substring4)
        }
        
        return true
    }

    func autocompleteMA(_ substring: String)
    {
        if(autocompMA.count != 0){ //so it doesn't show up when nothing is there and then you're stuck
            autoTableMA.isHidden = false
        }
        else{
            autoTableMA.isHidden = true
        }
        autocompMA.removeAll(keepingCapacity: false)
        
        for curString in pastMA
        {
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring, options: .caseInsensitive)
            
            if (substringRange.location  == 0)
            {
                autocompMA.append(curString as String)
            }
        }
        
        autoTableMA.reloadData()
    }
    
    func autocompleteR(_ substring: String)
    {
        if(autocompR.count != 0){ //so it doesn't show up when nothing is there and then you're stuck
            autoTableR.isHidden = false
        }
        else{
            autoTableR.isHidden = true
        }
        
        autocompR.removeAll(keepingCapacity: false)
        print(substring)
        
        
        for curString in pastR
        {
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring, options: .caseInsensitive)
            
            if (substringRange.location  == 0)
            {
                autocompR.append(curString as String)
            }
        }
        
        autoTableR.reloadData()
    }
    func autocompleteLong(_ substring: String)
    {
        if(autocompLong.count != 0){ //so it doesn't show up when nothing is there and then you're stuck
            autoTableLong.isHidden = false
        }
        else{
            autoTableLong.isHidden = true
        }
        
        autocompLong.removeAll(keepingCapacity: false)
        print(substring)
        
        
        for curString in pastLong
        {
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring, options: .caseInsensitive)
            
            if (substringRange.location  == 0)
            {
                autocompLong.append(curString as String)
            }
        }
        
        autoTableLong.reloadData()
    }
    func autocompleteLat(_ substring: String)
    {
        if(autocompLat.count != 0){ //so it doesn't show up when nothing is there and then you're stuck
            autoTableLat.isHidden = false
        }else{
            autoTableLat.isHidden = true
        }
        
        autocompLat.removeAll(keepingCapacity: false)
        print(substring)
        
        
        for curString in pastLat
        {
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring, options: .caseInsensitive)
            
            if (substringRange.location  == 0)
            {
                autocompLat.append(curString as String)
            }
        }
        
        autoTableLat.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == autoTableMA){
            return autocompMA.count
        }
        else if(tableView == autoTableR){ //if...
            return autocompR.count
        }
        else if (tableView == autoTableLong){
            return autocompLong.count
        }else{
            return autocompLat.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == autoTableMA){
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = (indexPath as NSIndexPath).row as Int
            
            cell.textLabel!.text = autocompMA[index]
            return cell
        }
        else if (tableView == autoTableR) {
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = (indexPath as NSIndexPath).row as Int
            
            cell.textLabel!.text = autocompR[index]
            return cell
            
        }else if (tableView == autoTableLong){
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = (indexPath as NSIndexPath).row as Int
            
            cell.textLabel!.text = autocompLong[index]
            return cell
            
        }else{
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
            let index = (indexPath as NSIndexPath).row as Int
            
            cell.textLabel!.text = autocompLat[index]
            return cell
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == autoTableR){
            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            autoTableR.isHidden = true
            rater.text = selectedCell.textLabel!.text
            
        }else if (tableView == autoTableLong){
            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            autoTableLong.isHidden = true
            if(long == "one") {
                long1Text.text = selectedCell.textLabel!.text
            }
            else if (long == "two"){
                
                long2Text.text = selectedCell.textLabel!.text
                
            }
        }else if (tableView == autoTableLat){
            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            autoTableLat.isHidden = true
            if(lat == "one") {
                lat1Text.text = selectedCell.textLabel!.text
            }
            else if (lat == "two"){
                
                lat2Text.text = selectedCell.textLabel!.text
                
            }
            
        }
    }
    
    //click enter, which text field is next?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //management area -> date picker
        //date picker -> r/t picker
        if textField == roadTrailNoText {
            textField.resignFirstResponder()
            roadTrailClassText.becomeFirstResponder()
            return false
        }
        if textField == roadTrailClassText {
            textField.resignFirstResponder()
            rater.becomeFirstResponder()
            return false
        }
        if textField == rater {
            textField.resignFirstResponder()
            beginMileText.becomeFirstResponder()
            return false
        }
        if textField == beginMileText {
            textField.resignFirstResponder()
            endMileText.becomeFirstResponder()
            return false
        }
        //end mile marker -> side picker
        //side picker-> weather
        
        if textField == lat1Text {
            textField.resignFirstResponder()
            lat2Text.becomeFirstResponder()
            return false
        }
        if textField == lat2Text {
            textField.resignFirstResponder()
            long1Text.becomeFirstResponder()
            return false
        }
        if textField == long1Text {
            textField.resignFirstResponder()
            long2Text.becomeFirstResponder()
            return false
        }
        if textField == long2Text {
            textField.resignFirstResponder()
            datumText.becomeFirstResponder()
            return false
        }
        if textField == datumText {
            textField.resignFirstResponder()
            aadtText.becomeFirstResponder()
            return false
        }
        if textField == aadtText {
            textField.resignFirstResponder()
            lengthAffectedText.becomeFirstResponder()
            return false
        }
        if textField == lengthAffectedText {
            textField.resignFirstResponder()
            slopeHText.becomeFirstResponder()
            return false
        }
        if textField == slopeHText {
            textField.resignFirstResponder()
            slopeAngleText.becomeFirstResponder()
            return false
        }
        if textField == slopeAngleText {
            textField.resignFirstResponder()
            sightDText.becomeFirstResponder()
            return false
        }
        if textField == sightDText {
            textField.resignFirstResponder()
            roadwayTWText.becomeFirstResponder()
            return false
        }
        //roadway trail width -> speed limit
        //speed limit-> ditch width
        
        if textField == ditchWidth1Text {
            textField.resignFirstResponder()
            ditchWidth2Text.becomeFirstResponder()
            return false
        }
        if textField == ditchWidth2Text {
            textField.resignFirstResponder()
            ditchDepth1Text.becomeFirstResponder()
            return false
        }
        if textField == ditchDepth1Text {
            textField.resignFirstResponder()
            ditchDepth2Text.becomeFirstResponder()
            return false
        }
        if textField == ditchDepth2Text {
            textField.resignFirstResponder()
            ditchSlope1beginText.becomeFirstResponder()
            return false
        }
        if textField == ditchSlope1beginText {
            textField.resignFirstResponder()
            ditchSlope1endText.becomeFirstResponder()
            return false
        }
        if textField == ditchSlope1endText {
            textField.resignFirstResponder()
            ditchSlope2beginText.becomeFirstResponder()
            return false
        }
        if textField == ditchSlope2beginText {
            textField.resignFirstResponder()
            ditchSlope2endText.becomeFirstResponder()
            return false
        }
        if textField == ditchSlope2endText {
            textField.resignFirstResponder()
            blkSizeText.becomeFirstResponder()
            return false
        }
        if textField == blkSizeText {
            textField.resignFirstResponder()
            volumeText.becomeFirstResponder()
            return false
        }
        if textField == volumeText {
            textField.resignFirstResponder()
            beginRainText.becomeFirstResponder()
            return false
        }
        
        if textField == beginRainText {
            textField.resignFirstResponder()
            endRainText.becomeFirstResponder()
            return false
        }
        //end rain -> sole access picker
        //sole access picker -> fixes present
        //fixes present -> images
        //images -> comments
        if textField == commentsText {
            textField.resignFirstResponder()
            flmaNameText.becomeFirstResponder()
            return false
        }
        if textField == flmaNameText {
            textField.resignFirstResponder()
            flmaIdText.becomeFirstResponder()
            return false
        }
        if textField == flmaIdText {
            textField.resignFirstResponder()
            flmaDescriptionText.becomeFirstResponder()
            return false
        }
        
        if textField == aadtEtcText {
            textField.resignFirstResponder()
            preliminaryRatingText.becomeFirstResponder()
            return false
        }
        
        if textField == annualRText {
            textField.resignFirstResponder()
            slopeHText.becomeFirstResponder()
            return false
        }
 
        if textField == rockfallHazardTotalText {
            textField.resignFirstResponder()
            routeTWText.becomeFirstResponder()
            return false
        }
        if textField == routeTWText {
            textField.resignFirstResponder()
            humanEFText.becomeFirstResponder()
            return false
        }
        if textField == humanEFText {
            textField.resignFirstResponder()
            percentDSDText.becomeFirstResponder()
            return false
        }
        if textField == riskTotalText {
            textField.resignFirstResponder()
            totalScoreText.becomeFirstResponder()
            return false
        }

        return true
    }
    //MARK: Autofill for calculations
    
    //auto-update when you click out of text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        //MARK: Calculation Calls
        //calc F
        bsPerEventText.text = String(calculateF())
        
        //calc H
        if(selectedAadt == true){
            aadtEtcText.text = String(calculateH())
        }
        
        //calc J
        annualRText.text = String(calculateJ())
        
        //calc K
        slopeHeightCalcText.text = String(calculateK())
        
        //calc V
        routeTWText.text = String(calculateV())
        
        //calc w
        //humanEFText.text = String(calculateW())
        
        //calc X
        percentDSDText.text = String(calculateX())
        
        //calc prelim total
        preliminaryRatingText.text = String(calcPrelimTotal())
        
        //calc hazard total
        rockfallHazardTotalText.text = String(calcHazardTotal())
        
        //calc risk total
        riskTotalText.text = String(calcRiskTotals())
        
        //calc overall total
        totalScoreText.text = String(calcTotalScore())
        
        //MARK: Validation
        
        if(textField == roadTrailNoText){
            if(roadTrailNoText.text == ""){
                roadTrailNoText.backgroundColor = UIColor.red
                let messageString = "Road/Trail No. must have a value."
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                roadTrailNoText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == roadTrailClassText){
            if(roadTrailClassText.text == ""){
                roadTrailClassText.backgroundColor = UIColor.red
                let messageString = "Road/Trail Class must have a value."
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            else{
                roadTrailClassText.backgroundColor = UIColor.white
            }
        }
        
        if(textField == rater){
            //autoTableR.hidden = true
            if(rater.text == "" || rater.text?.characters.count >= 30){
                rater.backgroundColor = UIColor.red
                let messageString = "Rater cannot be empty and must be shorter than 30 characters."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            
            }
            else{
                rater.backgroundColor = UIColor.white
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "ACRater", in:managedContext)
            let site = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            site.setValue(rater.text, forKey: "word")
            if(pastR.contains(rater.text! as NSString)){
                
            }else{
                pastR.append(rater.text! as NSString)
                
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }
            
        }
        
        if(textField == beginMileText){
            if(beginMileText.text == "" || (beginMileText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                beginMileText.backgroundColor = UIColor.red
                let messageString = "Beginning Mile Marker must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                beginMileText.backgroundColor = UIColor.white
            }
        }
        
        if(textField == endMileText){
            if(endMileText.text == "" || (endMileText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                endMileText.backgroundColor = UIColor.red
                let messageString = "Ending Mile Marker must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            else{
                endMileText.backgroundColor = UIColor.white
            }
        }

        //lat/long pattern matching
        if(textField == lat1Text){
            //autoTableLat.hidden = true
            lat = "one"
            if(lat1Text.text == "" || (lat1Text.text! =~ "[0-9]{2}\\.[0-9]+") == false){
                lat1Text.backgroundColor = UIColor.red
                let messageString = "Begin Latitude must have a value with the appropriate format ##.#####"
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }else{
                lat1Text.backgroundColor = UIColor.white
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "ACLatitude", in:managedContext)
            let site = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            site.setValue(lat1Text.text, forKey: "word")
            if(pastLat.contains(lat1Text.text! as NSString)){
                
            }else{
                pastLat.append(lat1Text.text! as NSString)
                
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }

        }
        
        if(textField == lat2Text){
            //autoTableLat.hidden = true
            lat = "two"
            if(lat2Text.text == "" || (lat2Text.text! =~ "[0-9]{2}\\.[0-9]+") == false){
                lat2Text.backgroundColor = UIColor.red
                let messageString = "End Latitude must have a value with the appropriate format ##.#####"
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }else{
                lat2Text.backgroundColor = UIColor.white
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "ACLatitude", in:managedContext)
            let site = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            site.setValue(lat2Text.text, forKey: "word")
            if(pastLat.contains(lat2Text.text! as NSString)){
                
            }else{
                pastLat.append(lat2Text.text! as NSString)
                
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }
   
        }
        
        if(textField == long1Text){
            //autoTableLong.hidden = true
            long = "one"
            if(long1Text.text == "" || (long1Text.text! =~ "\\-[0-9]{3}\\.[0-9]+") == false){
                long1Text.backgroundColor = UIColor.red
                let messageString = "Begin Longitude must have a value with the appropriate format -###.#####"
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }else{
                long1Text.backgroundColor = UIColor.white
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "ACLongitude", in:managedContext)
            let site = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            site.setValue(long1Text.text, forKey: "word")
            if(pastLong.contains(long1Text.text! as NSString)){
                
            }else{
                pastLong.append(long1Text.text! as NSString)
            }
    
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }
        }
        
        if(textField == long2Text){
            //autoTableLong.hidden = true
            long = "two"
            if(long2Text.text == "" || (long2Text.text! =~ "\\-[0-9]{3}\\.[0-9]+") == false){
                long2Text.backgroundColor = UIColor.red
                let messageString = "End Longitude must have a value with the appropriate format -###.#####"
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }else{
                long2Text.backgroundColor = UIColor.white
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "ACLongitude", in:managedContext)
            let site = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            site.setValue(long2Text.text, forKey: "word")
            if(pastLong.contains(long2Text.text! as NSString)){
                
            }else{
                pastLong.append(long2Text.text! as NSString)
                
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }
  
        }

        if(textField == aadtText){
            if(aadtText.text == "" || Int(aadtText.text!) == nil){
                aadtText.backgroundColor = UIColor.red
                let messageString = "AADT must have an integer value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
     
            }
            else{
                aadtText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == lengthAffectedText){
            if(lengthAffectedText.text == "" || (lengthAffectedText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                lengthAffectedText.backgroundColor = UIColor.red
                let messageString = "Length of Affected Road/Trail must have a decimal value." //decimal pad
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
       
            }
            else{
                lengthAffectedText.backgroundColor = UIColor.white
            }
            
        }
        if(textField == slopeHText){
            if(slopeHText.text == "" || (slopeHText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                slopeHText.backgroundColor = UIColor.red
                let messageString = "Slope Height (rock)/Axial Length (slide) must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                slopeHText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == slopeAngleText){
            if(slopeAngleText.text == "" || Double(slopeAngleText.text!) > 90 || Double(slopeAngleText.text!) < 0 || Int(slopeAngleText.text!) == nil  ){
                slopeAngleText.backgroundColor = UIColor.red
                let messageString = "Slope Angle must have an integer value between 0 and 90 degrees"
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                slopeAngleText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == sightDText){
            if(sightDText.text == "" || (sightDText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                sightDText.backgroundColor = UIColor.red
                let messageString = "Sight Distance must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            else{
                sightDText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == roadwayTWText){
            if(roadwayTWText.text == "" || (roadwayTWText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                roadwayTWText.backgroundColor = UIColor.red
                let messageString = "Roadway/Trail width must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                roadwayTWText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == blkSizeText){
            if(blkSizeText.text == "" || (blkSizeText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                blkSizeText.backgroundColor = UIColor.red
                let messageString = "Blk Size must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                blkSizeText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == volumeText){
            if(volumeText.text == "" || (volumeText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                volumeText.backgroundColor = UIColor.red
                let messageString = "Volume must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                volumeText.backgroundColor = UIColor.white
            }
        }
        
        if(textField == beginRainText){
            if(beginRainText.text == "" || (beginRainText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                beginRainText.backgroundColor = UIColor.red
                let messageString = "Annual Rainfall minimum must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                beginRainText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == endRainText){
            if(endRainText.text == "" || (endRainText.text! =~ "[0-9]+\\.*[0-9]*") == false){
                endRainText.backgroundColor = UIColor.red
                let messageString = "Annual Rainfall maximum must have a decimal value."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            else{
                endRainText.backgroundColor = UIColor.white
            }
            
        }
        
        //preliminary ratings
        
        if(textField == bsPerEventText){
            if(bsPerEventText.text == "" || Double(bsPerEventText.text!) < 0 || Double(bsPerEventText.text!) > 100 || Int(bsPerEventText.text!) == nil){
                bsPerEventText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                bsPerEventText.backgroundColor = UIColor.white
            }
            
        }
        
        
        if(textField == aadtEtcText){
            if(aadtEtcText.text == "" || Double(aadtEtcText.text!) < 0 || Double(aadtEtcText.text!) > 100 || Int(aadtEtcText.text!) == nil){
                aadtEtcText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                aadtEtcText.backgroundColor = UIColor.white
            }
            
        }
        
        //slope hazard ratings
        
        if(textField == annualRText){
            if(annualRText.text == "" || Double(annualRText.text!) < 0 || Double(annualRText.text!) > 100 || Int(annualRText.text!) == nil){
                annualRText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                annualRText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == slopeHeightCalcText){
            if(slopeHeightCalcText.text == "" || Double(slopeHeightCalcText.text!) < 0 || Double(slopeHeightCalcText.text!) > 100 || Int(slopeHeightCalcText.text!) == nil){
                slopeHeightCalcText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                slopeHeightCalcText.backgroundColor = UIColor.white
            }
            
        }
        
        //Risk Ratings
        
        if(textField == routeTWText){
            if(routeTWText.text == "" || Double(routeTWText.text!) < 0 || Double(routeTWText.text!) > 100 || Int(routeTWText.text!) == nil){
                routeTWText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                routeTWText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == humanEFText){
            if(humanEFText.text == "" || Double(humanEFText.text!) < 0 || Double(humanEFText.text!) > 100 || Int(humanEFText.text!) == nil){
                humanEFText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                humanEFText.backgroundColor = UIColor.white
            }
            
        }
        
        if(textField == percentDSDText){
            if(percentDSDText.text == "" || Double(percentDSDText.text!) < 0 || Double(percentDSDText.text!) > 100 || Int(percentDSDText.text!) == nil){
                percentDSDText.backgroundColor = UIColor.red
                let messageString = "Field must have an integer value between 0 and 100."
                
                let alertController = UIAlertController(title: "USMP Says:", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
            else{
                percentDSDText.backgroundColor = UIColor.white
            }
            
        }
    
    }
    
    //auto-update when you change picker value
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int){
        
        if(pickerView.isEqual(agency)){
            //"select", "FS","NPS","BLM","BIA"
            if(agency.selectedRow(inComponent: 0) == 0){
                regionalOptions.removeAll()
                regionalOptions.append("Select Regional option")
                regional.reloadAllComponents()
            }
            if(agency.selectedRow(inComponent: 0) == 1){ //fs
                regionalOptions.removeAll()
                regionalOptions.append(contentsOf: FSRegionalOptions)
                regional.reloadAllComponents()
            }
            if(agency.selectedRow(inComponent: 0) == 2){ //nps
                regionalOptions.removeAll()
                regionalOptions.append(contentsOf: NPSRegionalOptions)
                regional.reloadAllComponents()
            }
        }
        
        if(pickerView.isEqual(regional)){
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 0){
                localOptions.removeAll()
                localOptions.append("Select Local option")
                local.reloadAllComponents()
            }
            //FS North
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 1){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSNorthernLocal)
                local.reloadAllComponents()
            }
            //FS Rocky
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 2){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSRockyMountainLocal)
                local.reloadAllComponents()
            }
            //FS Southwestern
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 3){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSSouthwesternLocal)
                local.reloadAllComponents()
            }
            //FS Intermountain
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 4){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSIntermountainLocal)
                local.reloadAllComponents()
            }
            //FS Pacific Southwestern
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 5){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSPacificSouthwestLocal)
                local.reloadAllComponents()
            }
            //FS Pacific Northwestern
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 6){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSPacificNorthwestLocal)
                local.reloadAllComponents()
            }
            //FS South
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 7){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSSouthernLocal)
                local.reloadAllComponents()
            }
            //FS Eastern
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 8){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSEasternLocal)
                local.reloadAllComponents()
            }
            //FS North
            if(agency.selectedRow(inComponent: 0) == 1 && regional.selectedRow(inComponent: 0) == 9){
                localOptions.removeAll()
                localOptions.append(contentsOf: FSAlaskaLocal)
                local.reloadAllComponents()
            }
            
            if(agency.selectedRow(inComponent: 0) == 2){
                if(regional.selectedRow(inComponent: 0) == 0){
                    localOptions.removeAll()
                    localOptions.append("Select Local option")
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 1){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSAkrLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 2){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSImrLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 3){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSMwrLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 4){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSNcrLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 5){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSNerLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 6){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSPwrLocal)
                    local.reloadAllComponents()
                }
                if(regional.selectedRow(inComponent: 0) == 7){
                    localOptions.removeAll()
                    localOptions.append(contentsOf: NPSSerLocal)
                    local.reloadAllComponents()
                }
            }
        }
        
        //calc F
        bsPerEventText.text = String(calculateF())
        
        //calc H
        if(selectedAadt == true){
            aadtEtcText.text = String(calculateH())
        }
        
        //calc J
        annualRText.text = String(calculateJ())
        
        //calc K
        slopeHeightCalcText.text = String(calculateK())
        
        //calc V
        routeTWText.text = String(calculateV())
        
        //calc w
        //humanEFText.text = String(calculateW())
        
        //calc X
        percentDSDText.text = String(calculateX())
        
        //calc prelim total
        preliminaryRatingText.text = String(calcPrelimTotal())
        
        //calc hazard total
        rockfallHazardTotalText.text = String(calcHazardTotal())
        
        //calc risk total
        riskTotalText.text = String(calcRiskTotals())
        
        //calc overall total
        totalScoreText.text = String(calcTotalScore())
        
    }
    
    //MARK: Picker Delegate Functions
    
    //one component each row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var components = 0
        if(pickerView .isEqual(hazardType1)){
            components = hazardOptions.count;
        }
        if(pickerView .isEqual(hazardType2)){
            components = hazardOptions.count;
        }
        if(pickerView .isEqual(hazardType3)){
            components = hazardOptions.count;
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
        
        if(pickerView .isEqual(rtPicker)){
            components = rtOptions.count;
        }
        if(pickerView .isEqual(sidePicker)){
            components = sideOptions.count;
        }
        
        if(pickerView .isEqual(speedPicker)){
            components = speedOptions.count;
        }
        if(pickerView .isEqual(accessPicker)){
            components = accessOptions.count;
        }
        if(pickerView .isEqual(fixesPicker)){
            components = fixesOptions.count;
        }
        if(pickerView .isEqual(ditchEPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(rockfallHPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(impactOUPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(slopeDPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(rockfallRMFPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(structuralC1Picker)){
            components = specialOptions.count;
        }
        if(pickerView .isEqual(rockF1Picker)){
            components = specialOptions.count;
        }
        if(pickerView .isEqual(structuralC2Picker)){
            components = specialOptions.count;
        }
        if(pickerView .isEqual(rockF2Picker)){
            components = specialOptions.count;
        }
        if(pickerView .isEqual(rightOWIPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(ecImpactsPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(maintenanceCPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(eventCPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(weatherPicker)){
            components = weatherOptions.count;
        }

        return components
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView .isEqual(hazardType1)){
            return hazardOptions[row]
        }
        if(pickerView .isEqual(hazardType2)){
            return hazardOptions[row]
        }
        if(pickerView .isEqual(hazardType3)){
            return hazardOptions[row]
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
        
        if(pickerView .isEqual(rtPicker)){
            return rtOptions[row]
        }
        if(pickerView .isEqual(sidePicker)){
            return sideOptions[row]
        }
  
        if(pickerView .isEqual(speedPicker)){
            return speedOptions[row]
        }
        if(pickerView .isEqual(accessPicker)){
            return accessOptions[row]
        }
        if(pickerView .isEqual(fixesPicker)){
            return fixesOptions[row]
        }
        if(pickerView .isEqual(ditchEPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(rockfallHPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(impactOUPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(slopeDPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(rockfallRMFPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(structuralC1Picker)){
            return specialOptions[row]
        }
        if(pickerView .isEqual(rockF1Picker)){
            return specialOptions[row]
        }
        if(pickerView .isEqual(structuralC2Picker)){
            return specialOptions[row]
        }
        if(pickerView .isEqual(rockF2Picker)){
            return specialOptions[row]
        }
        if(pickerView .isEqual(rightOWIPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(ecImpactsPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(maintenanceCPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(eventCPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(weatherPicker)){
            return weatherOptions[row]
        }
 
        else{
            return "error";
        }
    
    }
    
    //MARK: Info Buttons
    
    //Site Information...
    
    @IBAction func getFLMAInfo(_ sender: AnyObject) {
        let messageString = "FLMA stands for Federal Land Management Agency"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //Preliminary Ratings...
    
    
    @IBAction func getDitchEInfo(_ sender: AnyObject) {
        let messageString = "3: Good \n 9: Moderate \n 27: Limited \n 81: No Catchment"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func getRockfallHInfo(_ sender: AnyObject) {
        let messageString = "3: Few Falls \n 9: Occasional Falls \n 27: Many Falls \n 81: Constant Falls"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func getBSVPEInfo(_ sender: AnyObject) {
        let messageString = "3: 1ft or 3yd^3 \n 9: 2ft or 6yd^3 \n 27: 3ft or 9yd^3 \n 81: 4ft or 12yd^3"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getImpactOUInfo(_ sender: AnyObject) {
        let messageString = "3: Full use continues with minor delays \n 9: Partial use remains. Use modification required, short (3mi/30min) detour available \n 27: Use is blocked- long(>30 min) detour available or less than 1 day closure \n 81: Use is blocked- no detour available or closure longer than 1 week"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getAadtInfo(_ sender: AnyObject) {
        let messageString = "3: 50 rarely used insignificant economic/ rec. importance \n 9: 200 occasionally used minor economic/recreational importance \n 27: 450 frequently used moerate economic/rec. importance \n 81: 800 constantly used significant economic/rec. importance"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getPrelimRatingInfo(_ sender: AnyObject) {
        let messageString = "Good(15-21 pts) \n Fair(22-161 pts) \n Poor(>161 pts)"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    //Slope Hazard Ratings
    
    @IBAction func getSlopeDInfo(_ sender: AnyObject) {
        let messageString = "3: Slope appears dry or well drained; surface runoff well controlled \n 9: Intermittent water on slope; mod. not well drained; or surface runoff moderately controlled \n 27: Water usually on slope; poorly drained; or surface runoff poorly controlled \n 81: Water always on slope; very poorly drained; or surface water runoff control not present"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getAnnualRInfo(_ sender: AnyObject) {
        let messageString = "3: 0-10\" \n 9: 10-30\" \n 27: 30-60\" \n 81: 60\"+ "
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getSlopeHInfo(_ sender: AnyObject) {
        let messageString = "3: 25ft \n 9: 50ft \n 27: 75ft \n 81: 100 ft"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func getRockfallRMFInfo(_ sender: AnyObject) {
        let messageString = "3: Normal, scheduled maintenance \n 9: Patrols after every storm event \n 27: Routine seasonal patrols \n 81: Year round patrols"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getStrucC1Info(_ sender: AnyObject) {
        let messageString = "3: Discontinuous favorable \n 9: Discontinuous random \n 27: Discontinuous adverse \n 81: Continuous Adverse"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getRockF1Info(_ sender: AnyObject) {
        let messageString = "3: Rough Irregular \n 9: Undulating \n 27: Planar \n 81: Clay infilled/Slickensided"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getStrucC2Info(_ sender: AnyObject) {
        let messageString = "3: Few differential erosion features \n 9: Occasional differential erosion features \n 27: Many differential erosion features \n 81: Major differential erosional features"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getRockF2Info(_ sender: AnyObject) {
        let messageString = "3: Small Difference \n 9: Moderate Difference \n 27: Large Difference \n 81: Extreme Difference"
        
        let alertController = UIAlertController(title: "Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //Risk Ratings
    
    @IBAction func getRouteTWInfo(_ sender: AnyObject) {
        let messageString = "3: 36ft \n 14ft \n 9: 28ft \n 10ft \n 27: 20ft \n 6ft \n 81: 12ft \n 2ft"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getHumanEFInfo(_ sender: AnyObject) {
        let messageString = "3: 12.5% of the time \n 9: 25% of the time \n 27: 37.5% of the time \n 50% of the time"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getPercentDSDInfo(_ sender: AnyObject) {
        let messageString = "3: Adequate, 100% of the low design value \n 9: Moderate, 80% of the low design value \n 27: Limited, 60% of the low design value \n 81: Very limited, 40% of the low design value"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getRightOWIInfo(_ sender: AnyObject) {
        let messageString = "3: No R/W implications \n 9: Minor effects beyond R/W \n 27: Private property, no structures affected \n 81: Structures, roads, RR, utilities, or parks affected"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getECImpactInfo(_ sender: AnyObject) {
        let messageString = "3: None/no potential to cuase effects \n 9: Likely to effect/No His. prop. affected \n 27: Likely to adversely affect/finding of no adverse affect \n 81: current adverse effects/ adverse effect"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func getMaintenanceCInfo(_ sender: AnyObject) {
        let messageString = "3: routine effort/ in-house \n 9: In-house maint./ special project \n 27: Specialized equip. / contract \n 81: Complex/ dangerous effort/ location /contract"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getEventCInfo(_ sender: AnyObject) {
        let messageString = "3: $0-2k \n 9: $2-25k \n 27: $25-100k \n 81: >$100k "
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Calculations
    //need to "round" or Int does not calc correctly (always rounds down)
    
    //prelim ratings
    
    //block size/vol per event??
    func calculateF()->Int{
        var blockVal = 0.0
        var volumeVal = 0.0
        
        if(blkSizeText.text != ""){
            let blkX = Double(blkSizeText.text!)
            blockVal = pow(3, blkX!)
            if(blockVal >= 100){
                blockVal = 100
            }
            
        }
        
        if(volumeText.text != ""){
            let volumeX = (Double(volumeText.text!)!/3.0)
            volumeVal = pow(3, volumeX)
            if(volumeVal >= 100){
                volumeVal = 100
            }
        }
        
        if(blockVal >= volumeVal){
            blockVal = round(blockVal)
            let tempBlock = Int(blockVal)
            return tempBlock
        }
        else{
            volumeVal = round(volumeVal)
            let tempVol = Int(volumeVal)
            return tempVol
        }
    }
    
    //aadt checkmark
    @IBAction func selectAadt(_ sender: AnyObject) {
        if(selectedAadt == false){
            let image = UIImage.init(named: "checkmark")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = true
            aadtEtcText.text = String(calculateH())
        }
        else{
            let image = UIImage.init(named: "unchecked")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = false
            
        }
    }
    
    //use value from aadt text to set aadtEtcText
    func calculateH()->Int{
        var aadt = 1.0
        if(aadtText.text != ""){
            aadt = Double(aadtText.text!)! //convert string to Double
            
            aadt = aadt/50 //aadt/50
            aadt = sqrt(aadt) //take square root
            aadt = pow(3, aadt) //3^aadt
            aadt = (round(aadt*10))/10 //rounding
            
            //if too big
            if(aadt>100){
                aadt = 100
            }
        }
        aadt = round(aadt)
        let tempInt = Int(aadt)
        return tempInt
        
    }
    
    //Slope Hazard Ratings
    
    //use rainfall begin and end to calculate j annual rainfall
    func calculateJ()->Int{
        var rating = 1
        if(beginRainText.text != "" && endRainText.text != ""){
            rating = 3
            let begin = Double(beginRainText.text!) //string to double
            let end = Double(endRainText.text!) //string to double
            let avg = (begin!+end!)/2.0
            
            //what about if = ?...
            if(avg>10 && avg<30){
                rating = 9
            }
            else if(avg>30 && avg<60){
                rating = 27
            }
            else if(avg>60){
                rating = 81
            }
        }
        
        return rating
    }
    
    //use value from slope height to set slope height
    func calculateK()->Int{
        var val = 1.0
        if(slopeHText.text != ""){
            val = Double(slopeHText.text!)!
            
            val = val/25 //divide by 25
            val = pow(3, val) //3^val
            
            if(val>100){  //if it's bigger than 100...set it to 100
                val = 100
            }
            
            val = round(val)
        }
        val = round(val)
        let tempInt = Int(val)
        return tempInt
        
    }

    //Risk Ratings
    
    //use road/trail picker and roadwayTWText (ste info) to set routeTWText
    func calculateV()->Int{
        var value = 0.0
        
        if(roadwayTWText.text != ""){
            var val = Double(roadwayTWText.text!)
            let selectedVal = rtPicker.selectedRow(inComponent: 0)
            
            //if >100, set = 100
            if(val>100){
                val=100
            }
            
            //ROAD
            if(selectedVal == 0){
                value = (44-val!)/8
                
            }
                
                //TRAIL
            else{
                value = (18-val!)/4
            }
        }
        value = pow(3,value)
        
        value = round(value)
        let tempInt = Int(value)
        
        return tempInt //return value...dif. based on if road or trail
        
    }
    
    //always 1??
    
//    func calculateW()->Double{
//        var val = 0.0
//
//        if(aadtEtcText.text != "" && roadwayLAText.text != ""){
//            let aadtUsage = Double(aadtEtcText.text!)
//            let lengthAffected = Double(roadwayLAText.text!)  //WHAT IS "SLOPE LENGTH"
//            var speed = 0.0
//
//            let selectedVal = speedPicker.selectedRowInComponent(0)
//
//            if(selectedVal == 0){
//                speed = 25
//            }
//            else if(selectedVal == 1){
//                speed = 30
//            }
//            else if(selectedVal == 2){
//                speed = 35
//            }
//            else if(selectedVal == 3){
//                speed = 40
//            }
//            else if(selectedVal == 4){
//                speed = 45
//            }
//            else if(selectedVal == 5){
//                speed = 50
//            }
//            else if(selectedVal == 6){
//                speed = 55
//            }
//            else if(selectedVal == 7){
//                speed = 60
//            }
//            else if(selectedVal == 8){
//                speed = 65
//            }
//            else if(selectedVal == 9){
//                speed = 70
//            }
//
//
//
//
//            val = aadtUsage!/24.0  //divide by 24
//            val = val*lengthAffected! //multiply by length
//            val = val*100 //?...
//            val = val/speed
//            val = val/12.5
//            val = pow(3, val)
//
//            val = round(val)
//
//        }
//
//
//        return val
//    }
//
    
    func calculateX()->Int{
        var speed = 0.0
        var value = 0.0
        
        if(sightDText.text != ""){
            let sightDist = Double(sightDText.text!)
            
            let selectedVal = speedPicker.selectedRow(inComponent: 0)
            
            if(selectedVal == 0){
                speed = 25
                value = sightDist!/375.0
            }
            else if(selectedVal == 1){
                speed = 30
                value = sightDist!/450.0
            }
            else if(selectedVal == 2){
                speed = 35
                value = sightDist!/525.0
            }
            else if(selectedVal == 3){
                speed = 40
                value = sightDist!/600.0
            }
            else if(selectedVal == 4){
                speed = 45
                value = sightDist!/675.0
            }
            else if(selectedVal == 5){
                speed = 50
                value = sightDist!/750.0
            }
            else if(selectedVal == 6){
                speed = 55
                value = sightDist!/875.0
            }
            else if(selectedVal == 7){
                speed = 60
                value = sightDist!/1000.0
                
            }
            else if(selectedVal == 8){
                speed = 65
                value = sightDist!/1050.0
                
            }
            else if(selectedVal == 9){
                speed = 70
            }
            
            value = (120-(value*100))
            value = value/20
            
            value = pow(3, value)
            
            if(value > 100){
                value = 100
            }
            
            value = round(value)
        }
        
        let tempInt = Int(value)
        
        return tempInt
        
    }
    
    //TOTALS
    //D+ E +F +G +H
    func calcPrelimTotal()->Int{
        var total = 0.0
        
        //D
        let selectedVal = ditchEPicker.selectedRow(inComponent: 0)
        if(selectedVal == 0){
            total = total + 3
        }
        if(selectedVal == 1){
            total = total + 9
        }
        if(selectedVal == 2){
            total = total + 27
        }
        if(selectedVal == 3){
            total = total + 81
        }
        
        //E
        let selectedVal2 = rockfallHPicker.selectedRow(inComponent: 0)
        if(selectedVal2 == 0){
            total = total + 3
        }
        if(selectedVal2 == 1){
            total = total + 9
        }
        if(selectedVal2 == 2){
            total = total + 27
        }
        if(selectedVal2 == 3){
            total = total + 81
        }
        
        //F->calculated...
        if(bsPerEventText.text != ""){
            total = total + Double(bsPerEventText.text!)!
        }
        
        //G
        let selectedVal3 = impactOUPicker.selectedRow(inComponent: 0)
        if(selectedVal3 == 0){
            total = total + 3
        }
        if(selectedVal3 == 1){
            total = total + 9
        }
        if(selectedVal3 == 2){
            total = total + 27
        }
        if(selectedVal3 == 3){
            total = total + 81
        }
        
        //H->calculated...
        if(aadtEtcText.text != ""){
            total = total + Double(aadtEtcText.text!)!
        }
        
        total = round(total)
        let tempInt = Int(total)
        return tempInt
        
    }
    
    //(D+E+F+I+J+K+O+(greatest of P+Q or R+S)):
    func calcHazardTotal()->Int{
        var total = 0.0
        
        //D
        let selectedVal = ditchEPicker.selectedRow(inComponent: 0)
        if(selectedVal == 0){
            total = total + 3
        }
        if(selectedVal == 1){
            total = total + 9
        }
        if(selectedVal == 2){
            total = total + 27
        }
        if(selectedVal == 3){
            total = total + 81
        }
        
        //E
        let selectedVal2 = rockfallHPicker.selectedRow(inComponent: 0)
        if(selectedVal2 == 0){
            total = total + 3
        }
        if(selectedVal2 == 1){
            total = total + 9
        }
        if(selectedVal2 == 2){
            total = total + 27
        }
        if(selectedVal2 == 3){
            total = total + 81
        }
        
        //F->calculated...
        if(bsPerEventText.text != ""){
            total = total + Double(bsPerEventText.text!)!
        }
        
        //I slope drainage
        let selectedVal3 = slopeDPicker.selectedRow(inComponent: 0)
        if(selectedVal3 == 0){
            total = total + 3
        }
        if(selectedVal3 == 1){
            total = total + 9
        }
        if(selectedVal3 == 2){
            total = total + 27
        }
        if(selectedVal3 == 3){
            total = total + 81
        }
        
        //J annual rainfall
        //J = annual rainfall
        if(annualRText.text != ""){
            total = total + Double(annualRText.text!)!
        }
        
        //K = calculated... axialLength of slide
        if(slopeHeightCalcText.text != ""){
            total = total + Double(slopeHeightCalcText.text!)!
        }
        
        //O Rockfall related maint frequency
        let selectedVal4 = rockfallRMFPicker.selectedRow(inComponent: 0)
        if(selectedVal4 == 0){
            total = total + 3
        }
        if(selectedVal4 == 1){
            total = total + 9
        }
        if(selectedVal4 == 2){
            total = total + 27
        }
        if(selectedVal4 == 3){
            total = total + 81
        }

        //Greatest of P+Q or R+S
        
        var pqTotal = 0.0
        
        let selectedVal5 = structuralC1Picker.selectedRow(inComponent: 0)
        //0 = 0
        if(selectedVal5 == 1){
            pqTotal = pqTotal + 3
        }
        if(selectedVal5 == 2){
            pqTotal = pqTotal + 9
        }
        if(selectedVal5 == 3){
            pqTotal = pqTotal + 27
        }
        if(selectedVal5 == 4){
            pqTotal = pqTotal + 81
        }
        
        let selectedVal6 = rockF1Picker.selectedRow(inComponent: 0)
        //0=0
        if(selectedVal6 == 1){
            pqTotal = pqTotal + 3
        }
        if(selectedVal6 == 2){
            pqTotal = pqTotal + 9
        }
        if(selectedVal6 == 3){
            pqTotal = pqTotal + 27
        }
        if(selectedVal6 == 4){
            pqTotal = pqTotal + 81
        }
        
        var rsTotal = 0.0
        
        let selectedVal7 = structuralC2Picker.selectedRow(inComponent: 0)
        //0=0
        if(selectedVal7 == 1){
            rsTotal = rsTotal + 3
        }
        if(selectedVal7 == 2){
            rsTotal = rsTotal + 9
        }
        if(selectedVal7 == 3){
            rsTotal = rsTotal + 27
        }
        if(selectedVal7 == 4){
            rsTotal = rsTotal + 81
        }
        
        let selectedVal8 = rockF2Picker.selectedRow(inComponent: 0)
        //0=0
        if(selectedVal8 == 1){
            rsTotal = rsTotal + 3
        }
        if(selectedVal8 == 2){
            rsTotal = rsTotal + 9
        }
        if(selectedVal8 == 3){
            rsTotal = rsTotal + 27
        }
        if(selectedVal8 == 4){
            rsTotal = rsTotal + 81
        }
        
        if(pqTotal >= rsTotal){
            total = total + pqTotal
        }
        else{
            total = total + rsTotal
        }

        total = round(total)
        let tempInt = Int(total)
        
        return tempInt
        
    }
    
    //(G+H+V+W+X+Y+Z+AA+BB):
    func calcRiskTotals()->Int{
        var total = 0.0
       // G: impact on use
        let selectedImpact = impactOUPicker.selectedRow(inComponent: 0)
        if(selectedImpact == 0){
            total = total + 3
        }
        if(selectedImpact == 1){
            total = total + 9
        }
        if(selectedImpact == 2){
            total = total + 27
        }
        if(selectedImpact == 3){
            total = total + 81
        }
        
        //H: calculated... AADT etc
        if(aadtEtcText.text != ""){
            total = total + Double(aadtEtcText.text!)!
                }
        
        //V: Calculated...route/trail width
        if(routeTWText.text != ""){
            total = total + Double(routeTWText.text!)!
        }
        
        //W: calculated...human ex.
        if(humanEFText.text != ""){
            total = total + Double(humanEFText.text!)!
        }
        
        //X: calculated...dsd
        if(percentDSDText.text != ""){
            total = total + Double(percentDSDText.text!)!
        }
        
        //Y: r/w impacts
        let selectedVal = rightOWIPicker.selectedRow(inComponent: 0)
        if(selectedVal == 0){
            total = total + 3
        }
        if(selectedVal == 1){
            total = total + 9
        }
        if(selectedVal == 2){
            total = total + 27
        }
        if(selectedVal == 3){
            total = total + 81
        }
        
        //Z: enviro/cult impacts
        let selectedVal2 = ecImpactsPicker.selectedRow(inComponent: 0)
        if(selectedVal2 == 0){
            total = total + 3
        }
        if(selectedVal2 == 1){
            total = total + 9
        }
        if(selectedVal2 == 2){
            total = total + 27
        }
        if(selectedVal2 == 3){
            total = total + 81
        }
        
        //A: maint complexity
        let selectedVal3 = maintenanceCPicker.selectedRow(inComponent: 0)
        if(selectedVal3 == 0){
            total = total + 3
        }
        if(selectedVal3 == 1){
            total = total + 9
        }
        if(selectedVal3 == 2){
            total = total + 27
        }
        if(selectedVal3 == 3){
            total = total + 81
        }
        
        //B: event cost
        let selectedVal4 = eventCPicker.selectedRow(inComponent: 0)
        if(selectedVal4 == 0){
            total = total + 3
        }
        if(selectedVal4 == 1){
            total = total + 9
        }
        if(selectedVal4 == 2){
            total = total + 27
        }
        if(selectedVal4 == 3){
            total = total + 81
        }
        
        total = round(total)
        let tempInt = Int(total)
        return tempInt
    }
    
    //U+CC... hazard total + risk total
    func calcTotalScore() -> Int{
        var total = 0.0
        if(rockfallHazardTotalText.text != ""){
            total = total + Double(rockfallHazardTotalText.text!)!
        }
        if(riskTotalText.text != ""){
            total = total + Double(riskTotalText.text!)!
        }
        
        total = round(total)
        let tempInt = Int(total)
        return tempInt
    }
    
    //MARK: Autofill coordinates...
        @IBAction func fillBegin(_ sender: AnyObject) {
        beginOrEnd = "begin"
        if CLLocationManager.authorizationStatus() == .denied {
            print("denied")
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
    
    @IBAction func fillEnd(_ sender: AnyObject) {
        beginOrEnd = "end"
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
    
    //MARK: Choose Images
    @IBAction func selectImages(_ sender: AnyObject) {
        let vc = BSImagePickerViewController()
        var defaultAssetIds = [String]()
        //all your photos
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        //enumerate
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
        //set default selected to previously selected images
        vc.defaultSelections = defaultSelected
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
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
    
    //image upload
    func UploadRequest()
    {
        if(images.count != 0){
            for i in 0 ... (images.count-1){
                let url = NSURL(string: "http://nl.cs.montana.edu/usmp/server/new_site_php/add_new_site.php")
                
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

    //MARK: Submit form online
    
    func handleSubmit(_ alertView:UIAlertAction!){
        //add message confirming submission...
        if(shareData.edit_site == true){
            editSubmit()
        }else{
        
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
                    localS = FSNorthernLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 2){  //Rocky MTN
                    localS = FSRockyMountainLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 3){  //Southwestern
                    localS = FSSouthwesternLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 4){  //Intermountain
                    localS = FSIntermountainLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 5){  //Pacific Southwest
                    localS = FSPacificSouthwestLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 6){  //Pacific Northwest
                    localS = FSPacificNorthwestLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 7){  //Southern
                    localS = FSSouthernLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 8){  //Eastern
                    localS = FSEasternLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 9){  //Alaska
                    localS = FSAlaskaLocal[local.selectedRow(inComponent: 0)]
                }
            }
            
            if(agency.selectedRow(inComponent: 0) == 2){ //NPS
                if(regional.selectedRow(inComponent: 0) == 1){  //Akr
                    localS = NPSAkrLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 2){  //Imr
                    localS = NPSImrLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 3){  //Mwr
                    localS = NPSMwrLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 4){  //Ncr
                    localS = NPSNcrLocal[local.selectedRow(inComponent: 0)]
                }
                
                if(regional.selectedRow(inComponent: 0) == 5){  //Ner
                    localS = NPSNerLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 6){  //pwr
                    localS = NPSPwrLocal[local.selectedRow(inComponent: 0)]
                }
                if(regional.selectedRow(inComponent: 0) == 7){  //ser
                    localS = NPSSerLocal[local.selectedRow(inComponent: 0)]
                }
                
            }

            
        //road/trail?
        var road_or_trail="R"
        let selected =  rtPicker.selectedRow(inComponent: 0)
        if(selected == 1){
            road_or_trail="T"
        }
        
        let tempSide = sidePicker.selectedRow(inComponent: 0)
        let side = sideOptions[tempSide]
        
        //how to do enum?
        let tempWeather = weatherPicker.selectedRow(inComponent: 0)
        let weather = weatherOptions[tempWeather]
        
            var hazard = ""
            
            //get the selected hazards
            let hazard1S = hazardOptions[hazardType1.selectedRow(inComponent: 0)]
            let hazard2S = hazardOptions[hazardType2.selectedRow(inComponent: 0)]
            let hazard3S = hazardOptions[hazardType3.selectedRow(inComponent: 0)]
            
            //problem if not in order
            for j in 0 ... (hazardItems.count-1){
                let temp = hazardItems[j] as! NSDictionary
                if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard1S){
                    hazard.append(temp.value(forKey: "ID") as! String)
                }
                if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard2S){
                    hazard.append(",")
                    hazard.append(temp.value(forKey: "ID") as! String)
                }
                if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard3S){
                    hazard.append(",")
                    hazard.append(temp.value(forKey: "ID") as! String)
                }
            }

        
        //speed
        var speed = 0
        let selectedSpeed = speedPicker.selectedRow(inComponent:0)
        if(selectedSpeed == 0){
            speed = 25
        }
        else if(selectedSpeed == 1){
            speed = 30
        }
        else if(selectedSpeed == 2){
            speed = 35
        }
        else if(selectedSpeed == 3){
            speed = 40
        }
        else if(selectedSpeed == 4){
            speed = 45
        }
        else if(selectedSpeed == 5){
            speed = 50
        }
        else if(selectedSpeed == 6){
            speed = 55
        }
        else if(selectedSpeed == 7){
            speed = 60
        }
        else if(selectedSpeed == 8){
            speed = 65
        }
        else{
            speed = 70
        }
        
        var sole_access="Y"
        let selected_access = accessPicker.selectedRow(inComponent: 0)
        if(selected_access == 1){
            sole_access = "N"
        }
        
        var fixes_present="Y"
        let selected_fixes = fixesPicker.selectedRow(inComponent: 0)
        if(selected_fixes == 1){
            fixes_present = "N"
        }
        
        var prelim_ditch_effectiveness = 3
        let selected_pde=ditchEPicker.selectedRow(inComponent: 0)
        if(selected_pde == 1){
            prelim_ditch_effectiveness = 9
        }
        else if(selected_pde == 2){
            prelim_ditch_effectiveness = 27
        }
        else if(selected_pde == 3){
            prelim_ditch_effectiveness = 81
        }
        
        var prelim_rockfall_history = 3
        let selected_prh = rockfallHPicker.selectedRow(inComponent: 0)
        if(selected_prh == 1){
            prelim_rockfall_history = 9
        }
        else if (selected_prh == 2){
            prelim_rockfall_history = 27
        }
        else if (selected_prh == 3){
            prelim_rockfall_history = 81
        }
        
        
        var impact_on_use = 3
        let selected_iou = impactOUPicker.selectedRow(inComponent: 0)
        if(selected_iou == 1){
            impact_on_use = 9
        }
        else if(selected_iou == 2){
            impact_on_use = 27
        }
        else if(selected_iou == 3){
            impact_on_use = 81
        }
        
        //slope hazard
        var slope_drainage = 3
        let selected_sd = slopeDPicker.selectedRow(inComponent: 0)
        if(selected_sd == 1){
            slope_drainage = 9
        }
        else if(selected_sd == 2){
            slope_drainage = 27
        }
        else if(selected_sd == 3){
            slope_drainage = 81
        }
        
        var hazard_rr_maint_freq = 3
        let selected_hrrmf = rockfallRMFPicker.selectedRow(inComponent: 0)
        if(selected_hrrmf == 1){
            hazard_rr_maint_freq = 9
        }
        else  if(selected_hrrmf == 2){
            hazard_rr_maint_freq = 27
        }
        else if(selected_hrrmf == 3){
            hazard_rr_maint_freq = 81
        }
        
        var struct_c1 = 3
        let selected_sc1=structuralC1Picker.selectedRow(inComponent: 0)
        if(selected_sc1 == 1){
            struct_c1 = 9
        }
        else if(selected_sc1 == 2){
            struct_c1 = 27
        }
        else if(selected_sc1 == 3){
            struct_c1 = 81
        }
        
        var rock_f1 = 3
        let selected_rf1 = rockF1Picker.selectedRow(inComponent: 0 )
        if(selected_rf1 == 1){
            rock_f1 = 9
        }
        else if(selected_rf1 == 2){
            rock_f1 = 9
        }
        else if(selected_rf1 == 3){
            rock_f1 = 9
        }
        
        var struct_c2 = 3
        let selected_sc2=structuralC1Picker.selectedRow(inComponent: 0)
        if(selected_sc2 == 1){
            struct_c2 = 9
        }
        else if(selected_sc2 == 2){
            struct_c2 = 27
        }
        else if(selected_sc2 == 3){
            struct_c2 = 81
        }
        
        var rock_f2 = 3
        let selected_rf2 = rockF1Picker.selectedRow(inComponent: 0 )
        if(selected_rf2 == 1){
            rock_f2 = 9
        }
        else if(selected_rf2 == 2){
            rock_f2 = 9
        }
        else if(selected_rf2 == 3){
            rock_f2 = 9
        }
        
        
        //Risk Ratings
        var r_w_impacts = 3
        let selected_rwi = rightOWIPicker.selectedRow(inComponent: 0)
        if(selected_rwi == 1){
            r_w_impacts = 9
        }
        else if(selected_rwi == 2){
            r_w_impacts = 27
        }
        else if(selected_rwi == 3){
            r_w_impacts = 81
        }
        
        var enviro_cult_impacts = 3
        let selected_eci = ecImpactsPicker.selectedRow(inComponent: 0)
        if(selected_eci == 1){
            enviro_cult_impacts = 9
        }
        else if(selected_eci == 2){
            enviro_cult_impacts = 27
        }
        else if(selected_eci == 3){
            enviro_cult_impacts = 81
        }
        var maint_complexity = 3
        let selected_mc = maintenanceCPicker.selectedRow(inComponent: 0)
        if(selected_mc == 1){
        maint_complexity = 9
        }
        else if(selected_mc == 2){
                maint_complexity = 27
        }
        else if(selected_mc == 3){
                maint_complexity = 81
        }
        var event_cost = 3
            let selected_ec = eventCPicker.selectedRow(inComponent: 0)
        if(selected_ec == 1){
                event_cost = 9
            }
  
        else if(selected_ec == 2){
            event_cost = 27
        }
        else if(selected_ec == 3){
            event_cost = 81
        }
        
        //delete site from core data if submitted successfully...
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/add_new_site.php")! as URL)
        request.httpMethod = "POST"
        
        //agencyS? or agency?
        let postString = "umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&volume=\(volumeText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&prelim_landslide_road_width_affected=0&prelim_landslide_slide_erosion_effects=0&prelim_landslide_length_affected=0&prelim_rockfall_ditch_eff=\(prelim_ditch_effectiveness)&prelim_rockfall_rockfall_history=\(prelim_rockfall_history)&prelim_rockfall_block_size_event_vol=\(bsPerEventText.text!)&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=0&hazard_landslide_maint_frequency=0&hazard_landslide_movement_history=0&hazard_rockfall_maint_frequency=\(hazard_rr_maint_freq)&case_one_struc_cond=\(struct_c1)&case_one_rock_friction=\(rock_f1)&case_two_struc_condition=\(struct_c2)&case_two_diff_erosion=\(rock_f2)&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(rockfallHazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            //success and failure messages
            if error != nil {
                print("error=\(String(describing: error))")
                let alertController = UIAlertController(title: "Error", message: "There was an error submitting your information", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            print("response = \(String(describing: response))")
            print("error=\(String(describing: error))")
            let alertController = UIAlertController(title: "Success", message: "Information Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            return
            
        }
        task.resume()

        }
    }

    //submit clarification
    @IBAction func submit(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func editSubmit(){
        
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
                localS = FSNorthernLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 2){  //Rocky MTN
                localS = FSRockyMountainLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 3){  //Southwestern
                localS = FSSouthwesternLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 4){  //Intermountain
                localS = FSIntermountainLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 5){  //Pacific Southwest
                localS = FSPacificSouthwestLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 6){  //Pacific Northwest
                localS = FSPacificNorthwestLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 7){  //Southern
                localS = FSSouthernLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 8){  //Eastern
                localS = FSEasternLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 9){  //Alaska
                localS = FSAlaskaLocal[local.selectedRow(inComponent: 0)]
            }
        }
        
        if(agency.selectedRow(inComponent: 0) == 2){ //NPS
            if(regional.selectedRow(inComponent: 0) == 1){  //Akr
                localS = NPSAkrLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 2){  //Imr
                localS = NPSImrLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 3){  //Mwr
                localS = NPSMwrLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 4){  //Ncr
                localS = NPSNcrLocal[local.selectedRow(inComponent: 0)]
            }
            
            if(regional.selectedRow(inComponent: 0) == 5){  //Ner
                localS = NPSNerLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 6){  //pwr
                localS = NPSPwrLocal[local.selectedRow(inComponent: 0)]
            }
            if(regional.selectedRow(inComponent: 0) == 7){  //ser
                localS = NPSSerLocal[local.selectedRow(inComponent: 0)]
            }
            
            
        }
        
        //road/trail?
        var road_or_trail="R"
        let selected =  rtPicker.selectedRow(inComponent: 0)
        if(selected == 1){
            road_or_trail="T"
        }
        
        let tempSide = sidePicker.selectedRow(inComponent: 0)
        let side = sideOptions[tempSide]
        
        //how to do enum?
        let tempWeather = weatherPicker.selectedRow(inComponent: 0)
        let weather = weatherOptions[tempWeather]
        
        //hazard type
        var hazard = ""
        
        //get the selected hazards
        let hazard1S = hazardOptions[hazardType1.selectedRow(inComponent: 0)]
        let hazard2S = hazardOptions[hazardType2.selectedRow(inComponent: 0)]
        let hazard3S = hazardOptions[hazardType3.selectedRow(inComponent: 0)]
        
        //problem if not in order
        for j in 0 ... (hazardItems.count-1){
            let temp = hazardItems[j] as! NSDictionary
            if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard1S){
                hazard.append(temp.value(forKey: "ID") as! String)
            }
            if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard2S){
                hazard.append(",")
                hazard.append(temp.value(forKey: "ID") as! String)
            }
            if((temp.value(forKey: "HAZARD_TYPE")as! String) == hazard3S){
                hazard.append(",")
                hazard.append(temp.value(forKey: "ID") as! String)
            }
        }

        
        //speed
        var speed = 0
        let selectedSpeed = speedPicker.selectedRow(inComponent:0)
        if(selectedSpeed == 0){
            speed = 25
        }
        else if(selectedSpeed == 1){
            speed = 30
        }
        else if(selectedSpeed == 2){
            speed = 35
        }
        else if(selectedSpeed == 3){
            speed = 40
        }
        else if(selectedSpeed == 4){
            speed = 45
        }
        else if(selectedSpeed == 5){
            speed = 50
        }
        else if(selectedSpeed == 6){
            speed = 55
        }
        else if(selectedSpeed == 7){
            speed = 60
        }
        else if(selectedSpeed == 8){
            speed = 65
        }
        else{
            speed = 70
        }
        
        var sole_access="Y"
        let selected_access = accessPicker.selectedRow(inComponent: 0)
        if(selected_access == 1){
            sole_access = "N"
        }
        
        var fixes_present="Y"
        let selected_fixes = fixesPicker.selectedRow(inComponent: 0)
        if(selected_fixes == 1){
            fixes_present = "N"
        }
        
        var prelim_ditch_effectiveness = 3
        let selected_pde=ditchEPicker.selectedRow(inComponent: 0)
        if(selected_pde == 1){
            prelim_ditch_effectiveness = 9
        }
        else if(selected_pde == 2){
            prelim_ditch_effectiveness = 27
        }
        else if(selected_pde == 3){
            prelim_ditch_effectiveness = 81
        }
        
        var prelim_rockfall_history = 3
        let selected_prh = rockfallHPicker.selectedRow(inComponent: 0)
        if(selected_prh == 1){
            prelim_rockfall_history = 9
        }
        else if (selected_prh == 2){
            prelim_rockfall_history = 27
        }
        else if (selected_prh == 3){
            prelim_rockfall_history = 81
        }
        
        
        var impact_on_use = 3
        let selected_iou = impactOUPicker.selectedRow(inComponent: 0)
        if(selected_iou == 1){
            impact_on_use = 9
        }
        else if(selected_iou == 2){
            impact_on_use = 27
        }
        else if(selected_iou == 3){
            impact_on_use = 81
        }
        
        //slope hazard
        var slope_drainage = 3
        let selected_sd = slopeDPicker.selectedRow(inComponent: 0)
        if(selected_sd == 1){
            slope_drainage = 9
        }
        else if(selected_sd == 2){
            slope_drainage = 27
        }
        else if(selected_sd == 3){
            slope_drainage = 81
        }
        
        var hazard_rr_maint_freq = 3
        let selected_hrrmf = rockfallRMFPicker.selectedRow(inComponent: 0)
        if(selected_hrrmf == 1){
            hazard_rr_maint_freq = 9
        }
        else  if(selected_hrrmf == 2){
            hazard_rr_maint_freq = 27
        }
        else if(selected_hrrmf == 3){
            hazard_rr_maint_freq = 81
        }
        
        var struct_c1 = 3
        let selected_sc1=structuralC1Picker.selectedRow(inComponent: 0)
        if(selected_sc1 == 1){
            struct_c1 = 9
        }
        else if(selected_sc1 == 2){
            struct_c1 = 27
        }
        else if(selected_sc1 == 3){
            struct_c1 = 81
        }
        
        var rock_f1 = 3
        let selected_rf1 = rockF1Picker.selectedRow(inComponent: 0 )
        if(selected_rf1 == 1){
            rock_f1 = 9
        }
        else if(selected_rf1 == 2){
            rock_f1 = 9
        }
        else if(selected_rf1 == 3){
            rock_f1 = 9
        }
        
        var struct_c2 = 3
        let selected_sc2=structuralC1Picker.selectedRow(inComponent: 0)
        if(selected_sc2 == 1){
            struct_c2 = 9
        }
        else if(selected_sc2 == 2){
            struct_c2 = 27
        }
        else if(selected_sc2 == 3){
            struct_c2 = 81
        }
        
        var rock_f2 = 3
        let selected_rf2 = rockF1Picker.selectedRow(inComponent: 0 )
        if(selected_rf2 == 1){
            rock_f2 = 9
        }
        else if(selected_rf2 == 2){
            rock_f2 = 9
        }
        else if(selected_rf2 == 3){
            rock_f2 = 9
        }
        
        //Risk Ratings
        var r_w_impacts = 3
        let selected_rwi = rightOWIPicker.selectedRow(inComponent: 0)
        if(selected_rwi == 1){
            r_w_impacts = 9
        }
        else if(selected_rwi == 2){
            r_w_impacts = 27
        }
        else if(selected_rwi == 3){
            r_w_impacts = 81
        }
        
        var enviro_cult_impacts = 3
        let selected_eci = ecImpactsPicker.selectedRow(inComponent: 0)
        if(selected_eci == 1){
            enviro_cult_impacts = 9
        }
        else if(selected_eci == 2){
            enviro_cult_impacts = 27
        }
        else if(selected_eci == 3){
            enviro_cult_impacts = 81
        }
        
        var maint_complexity = 3
        let selected_mc = maintenanceCPicker.selectedRow(inComponent: 0)
        if(selected_mc == 1){
            maint_complexity = 9
        }
        else if(selected_mc == 2){
            maint_complexity = 27
        }
        else if(selected_mc == 3){
            maint_complexity = 81
        }
        
        var event_cost = 3
        let selected_ec = eventCPicker.selectedRow(inComponent: 0)
        if(selected_ec == 1){
            event_cost = 9
        }
        else if(selected_ec == 2){
            event_cost = 27
        }
        else if(selected_ec == 3){
            event_cost = 81
        }
        
        let email = ""
        
        //delete site from core data if submitted successfully...
        let request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/usmp/server/new_site_php/add_new_site.php")! as URL)
        request.httpMethod = "POST"
        
        //agencyS?
        let postString = "old_site_id=\(shareData.current_site_id)&umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&volume=\(volumeText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&prelim_landslide_road_width_affected=0&prelim_landslide_slide_erosion_effects=0&prelim_landslide_length_affected=0&prelim_rockfall_ditch_eff=\(prelim_ditch_effectiveness)&prelim_rockfall_rockfall_history=\(prelim_rockfall_history)&prelim_rockfall_block_size_event_vol=\(bsPerEventText.text!)&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=0&hazard_landslide_maint_frequency=0&hazard_landslide_movement_history=0&hazard_rockfall_maint_frequency=\(hazard_rr_maint_freq)&case_one_struc_cond=\(struct_c1)&case_one_rock_friction=\(rock_f1)&case_two_struc_condition=\(struct_c2)&case_two_diff_erosion=\(rock_f2)&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(rockfallHazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)&email=\(email)"

        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                let alertController = UIAlertController(title: "Error", message: "There was an error submitting your information", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            print("response = \(String(describing: response))")
            print("error=\(String(describing: error))")
            let alertController = UIAlertController(title: "Success", message: "Information Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            return
            
        }
        task.resume()
        
        }

    //Mark: save offline sites
    @IBAction func saveOffline(_ sender: AnyObject) {
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "NewOfflineRockfall", in:managedContext)
        let site = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
        let selectedAgency = agency.selectedRow(inComponent: 0)
        let selectedRegional = regional.selectedRow(inComponent: 0)
        let selectedLocal = local.selectedRow(inComponent: 0)
        
        site.setValue(selectedAgency, forKey: "agency")
        site.setValue(selectedRegional, forKey: "regional")
        site.setValue(selectedLocal, forKey: "local")
        
        //date
        site.setValue(datePicker.date, forKey: "date")
        
        //road or trail? - 2 options
        let selectedRT = rtPicker.selectedRow(inComponent: 0)
        site.setValue(selectedRT, forKey: "roadOrTrail")

        site.setValue(roadTrailNoText.text, forKey: "roadTrailNo")
        site.setValue(roadTrailClassText.text, forKey: "roadTrailClass")
        site.setValue(rater.text, forKey: "rater")
        site.setValue(beginMileText.text, forKey: "beginMile")
        site.setValue(endMileText.text, forKey: "endMile")
        
        //side- 10 options
        //change side core data to integer...can pull what the text option should be based on order in picker
        let selectedSide = sidePicker.selectedRow(inComponent: 0)
        site.setValue(selectedSide, forKey: "side")
        
        let selectedWeather = weatherPicker.selectedRow(inComponent: 0)
        
        site.setValue(selectedWeather, forKey: "weather")
        
        //TODO: Hazard Type 6
        var hazardString = ""
        //must select the first one if they are going to select the second or third
        if(hazardType1.selectedRow(inComponent: 0) != 0){
            let temp = hazardOptions[hazardType1.selectedRow(inComponent: 0)]
            hazardString.append(temp)
            if(hazardType2.selectedRow(inComponent: 0) != 0){
                let temp = hazardOptions[hazardType2.selectedRow(inComponent: 0)]
                hazardString.append(",")
                hazardString.append(temp)
            }
            if(hazardType3.selectedRow(inComponent: 0) != 0){
                let temp = hazardOptions[hazardType3.selectedRow(inComponent: 0)]
                hazardString.append(",")
                hazardString.append(temp)
            }
        }
        
        site.setValue(hazardString, forKey: "hazardType")
        
        site.setValue(lat1Text.text, forKey: "lat1")
        site.setValue(lat2Text.text, forKey: "lat2")
        site.setValue(long1Text.text, forKey: "long1")
        site.setValue(long2Text.text, forKey: "long2")
        site.setValue(datumText.text, forKey: "datum")
        site.setValue(aadtText.text, forKey: "aadt")
        site.setValue(lengthAffectedText.text, forKey: "lengthAffected")
        site.setValue(slopeHText.text, forKey: "slopeHeight")
        site.setValue(slopeAngleText.text, forKey: "slopeAngle")
        site.setValue(sightDText.text, forKey: "sightDistance")
        site.setValue(roadwayTWText.text, forKey: "rtWidth")
        
        //speed-10 options
        let selectedSpeed = speedPicker.selectedRow(inComponent: 0)
        site.setValue(selectedSpeed, forKey: "speed")
        
        site.setValue(ditchWidth1Text.text, forKey: "ditchWidth1")
        site.setValue(ditchWidth2Text.text, forKey: "ditchWidth2")
        site.setValue(ditchDepth1Text.text, forKey: "ditchDepth1")
        site.setValue(ditchDepth2Text.text, forKey: "ditchDepth2")
        site.setValue(ditchSlope1beginText.text, forKey: "ditchSlope1")
        site.setValue(ditchSlope1endText.text, forKey: "ditchSlope2")
        site.setValue(ditchSlope2beginText.text, forKey: "ditchSlope3")
        site.setValue(ditchSlope2endText.text, forKey: "ditchSlope4")
        site.setValue(blkSizeText.text, forKey: "blockSize")
        site.setValue(volumeText.text, forKey: "volume")
        site.setValue(beginRainText.text, forKey: "beginRain")
        site.setValue(endRainText.text, forKey: "endRain")
        
        //sole access-2 options
        let selectedAccess = accessPicker.selectedRow(inComponent: 0)
        site.setValue(selectedAccess, forKey:"soleAccess")
        
        //fixes present- 2 options
        let selectedFixes = fixesPicker.selectedRow(inComponent: 0)
        site.setValue(selectedFixes, forKey: "fixesPresent")
        
        //PHOTOS!!!
        //site.setValue(imagesLabel.text, forKey: "photos")
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

        site.setValue(commentsText.text, forKey: "comments")
        site.setValue(flmaNameText.text, forKey: "flmaName")
        site.setValue(flmaIdText.text, forKey: "flmaId")
        site.setValue(flmaDescriptionText.text, forKey: "flmaDescription")
        
        //MARK: Preliminary Ratings
        
        //ditch effectiveness - 4 options
        let selectedDitch = ditchEPicker.selectedRow(inComponent: 0)
        site.setValue(selectedDitch, forKey: "prDitch")

        //rockfall history - 4 options
        let selectedHistory = rockfallHPicker.selectedRow(inComponent: 0)
        site.setValue(selectedHistory, forKey: "prHistory")

        site.setValue(bsPerEventText.text, forKey: "prBvEvent")
        
        //impact on use - 4 options
        let selectedImpact = impactOUPicker.selectedRow(inComponent: 0)
        site.setValue(selectedImpact, forKey: "prImpact")
        
        //aadt
        if(selectedAadt == true){
            site.setValue(true, forKey: "aadtCheck")
        }
        else{
            site.setValue(false, forKey: "aadtCheck")
        }
        
        site.setValue(aadtEtcText.text, forKey: "prAadt")
        site.setValue(preliminaryRatingText.text, forKey: "prTotal")
        
        //MARK: Slope Hazard Ratings
        
        //slope drainage- 4 rating options
        let selectedDrainage = slopeDPicker.selectedRow(inComponent: 0)
        site.setValue(selectedDrainage, forKey: "shDrainage")
        
        site.setValue(annualRText.text, forKey: "shAnnualRain")
        site.setValue(slopeHText.text, forKey: "shSlopeHeight")
        
        //rockfall related maintenance frequency- 4 options
        let selectedMFrequency = rockfallRMFPicker.selectedRow(inComponent: 0)
        site.setValue(selectedMFrequency, forKey: "shMaintFreq")

    //Geological Character Case 1...GEO CHARACTERS HAVE SPECIAL RATINGS(include 0)
        
        //structural condition - 5 options
        let selectedSCond1 = structuralC1Picker.selectedRow(inComponent: 0)
        site.setValue(selectedSCond1, forKey: "shStructural1")

        //rock friction - 5 options
        let selectedRFriction = rockF1Picker.selectedRow(inComponent: 0)
        site.setValue(selectedRFriction, forKey: "shFriction1")

    //Geological Character Case 2
        //structural condition - 5 options
        let selectedSCond2 = structuralC2Picker.selectedRow(inComponent: 0)
        site.setValue(selectedSCond2, forKey: "shStructural2")

        //rock friction - 5 options
        let selectedRFriction2 = rockF2Picker.selectedRow(inComponent: 0)
        site.setValue(selectedRFriction2, forKey: "shFriction2")

        site.setValue(rockfallHazardTotalText.text, forKey: "shTotal")
        
        //MARK: Risk Ratings
        site.setValue(routeTWText.text, forKey: "rrWidth")
        site.setValue(humanEFText.text, forKey: "rrHumanExposure")
        site.setValue(percentDSDText.text, forKey: "rrDsd")
        
        //right of way impacts - 4 rating options
        let selectedRow = rightOWIPicker.selectedRow(inComponent: 0)
        site.setValue(selectedRow, forKey: "rrRight")
        
        //environmental/cultural impacts - 4 rating options
        let selectedEnvironmental = ecImpactsPicker.selectedRow(inComponent: 0)
        site.setValue(selectedEnvironmental, forKey: "rrEnviron")

        
        //maintenance complexity - 4 rating options
        let selectedMaintenance = maintenanceCPicker.selectedRow(inComponent: 0)
        site.setValue(selectedMaintenance, forKey: "rrMaintenance")

        
        //event cost - 4 rating options
        let selectedEventCost = eventCPicker.selectedRow(inComponent: 0)
        site.setValue(selectedEventCost, forKey: "rrEvent")

        site.setValue(riskTotalText.text, forKey: "rrTotal")
        site.setValue(totalScoreText.text, forKey: "total")
        

        //save in core data
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
    
    //MARK:LOAD offline site
    
    //load offline site from list
    func loadFromList(){
        shareData.load = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewOfflineRockfall")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sites.removeAll() //need to re-clear??
            
            sites = results as! [NSManagedObject] //shows up twice cuz they were appended earlier?
            
             let number = shareData.selectedForm
            
            let agencyI = sites[number].value(forKey: "agency")! as! NSObject as! Int
            let regionalI = sites[number].value(forKey: "regional")! as! NSObject as! Int
            let localI = sites[number].value(forKey: "local")! as! NSObject as! Int
            
            //need to manually call didSelectRow to load lists correctly
            agency.selectRow(agencyI, inComponent: 0, animated: true)
            self.agency.delegate?.pickerView!(agency, didSelectRow: agencyI, inComponent: 0)
            
            regional.selectRow(regionalI, inComponent: 0, animated: true)
            self.regional.delegate?.pickerView!(regional, didSelectRow: regionalI, inComponent: 0)
            
            local.selectRow(localI, inComponent: 0, animated: true)

                    //Date
                    datePicker.date = (sites[number].value(forKey: "date")! as? Date)!
                    
                    //road or trail?
                    let rt = sites[number].value(forKey: "roadOrTrail")! as! NSObject as! Int
                    rtPicker.selectRow(rt, inComponent: 0, animated: true)
            
                    roadTrailNoText.text = sites[number].value(forKey: "roadTrailNo")! as? String
                    roadTrailClassText.text = sites[number].value(forKey: "roadTrailClass")! as? String
                    rater.text = sites[number].value(forKey: "rater")! as? String
                    beginMileText.text = sites[number].value(forKey: "beginMile")! as? String
                    endMileText.text = sites[number].value(forKey: "endMile")! as? String
                    
                    //side-10 options...
                    let side = sites[number].value(forKey: "side")! as! NSObject as! Int
                    sidePicker.selectRow(side, inComponent: 0, animated: true)
            
                    let weatherVal = sites[number].value(forKey: "weather")! as! Int
                    weatherPicker.selectRow(weatherVal, inComponent: 0, animated: true)
                    
                    //TODO: Hazard Type7
                    var hazardString = ""
                    hazardString = (sites[number].value(forKey: "HazardType")! as? String)!
            let hazards = hazardString.components(separatedBy: ",")
            
            for i in 0 ... ((hazards.count) - 1){
                if(hazardOptions.contains((hazards[i]))){
                    let index = hazardOptions.index(of: hazards[i])
                    if(i == 0){
                        hazardType1.selectRow(index!, inComponent: 0, animated: true)
                    }else if (i == 1){
                        hazardType2.selectRow(index!, inComponent: 0, animated: true)
                        
                    }else{
                        hazardType3.selectRow(index!, inComponent: 0, animated: true)
                        
                    }
                }
            }
            
                    lat1Text.text = sites[number].value(forKey: "lat1")! as? String
                    lat2Text.text = sites[number].value(forKey: "lat2")! as? String
                    long1Text.text = sites[number].value(forKey: "long1")! as? String
                    long2Text.text = sites[number].value(forKey: "long2")! as? String
                    datumText.text = sites[number].value(forKey: "datum")! as? String
                    aadtText.text = sites[number].value(forKey: "aadt")! as? String
                    lengthAffectedText.text = sites[number].value(forKey: "lengthAffected")! as? String
                    slopeHText.text = sites[number].value(forKey: "slopeHeight")! as? String
                    slopeAngleText.text = sites[number].value(forKey: "slopeAngle")! as? String
                    sightDText.text = sites[number].value(forKey: "sightDistance")! as? String
                    roadwayTWText.text = sites[number].value(forKey: "rtWidth")! as? String
                    
                    //speed - 10 options
                    let speed = sites[number].value(forKey: "speed")! as! NSObject as! Int
                    speedPicker.selectRow(speed, inComponent: 0, animated: true)
            
                    ditchWidth1Text.text = sites[number].value(forKey: "ditchWidth1")! as? String
                    ditchWidth2Text.text = sites[number].value(forKey: "ditchWidth2")! as? String
                    ditchDepth1Text.text = sites[number].value(forKey: "ditchDepth1")! as? String
                    ditchDepth2Text.text = sites[number].value(forKey: "ditchDepth2")! as? String
                    ditchSlope1beginText.text = sites[number].value(forKey: "ditchSlope1")! as? String
                    ditchSlope1endText.text = sites[number].value(forKey: "ditchSlope2")! as? String
                    ditchSlope2beginText.text = sites[number].value(forKey: "ditchSlope3")! as? String
                    ditchSlope2endText.text = sites[number].value(forKey: "ditchSlope4")! as? String
                    blkSizeText.text = sites[number].value(forKey: "blockSize")! as? String
                    volumeText.text = sites[number].value(forKey: "volume")! as? String
                    beginRainText.text = sites[number].value(forKey: "beginRain")! as? String
                    endRainText.text = sites[number].value(forKey: "endRain")! as? String
                    
                    //sole access route- 2 options
                    let soleAccess = sites[number].value(forKey: "soleAccess")! as! NSObject as! Int
                    accessPicker.selectRow(soleAccess, inComponent: 0, animated: true)
            
                    //fixes present- 2 options
                    let fixes = sites[number].value(forKey: "fixesPresent")! as! NSObject as! Int
                    fixesPicker.selectRow(fixes, inComponent: 0, animated: true)
            
                    //PHOTOS
                    //imagesLabel.text = sites[number].value(forKey: "photos")! as? String
            
                    let photos = sites[number].value(forKey: "photos")! as! [String]
            
                    let photoResults = PHAsset.fetchAssets(withLocalIdentifiers: photos, options: nil)
            
            if(photoResults.count != 0){
                    for i in 0 ... photoResults.count-1{
                            images.append(photoResults.object(at: i))
                    }
            }
            
                    commentsText.text = sites[number].value(forKey: "comments")! as? String
                    flmaNameText.text = sites[number].value(forKey: "flmaName")! as? String
                    flmaIdText.text = sites[number].value(forKey: "flmaId")! as? String
                    flmaDescriptionText.text = sites[number].value(forKey: "flmaDescription")! as? String
                    
                    //Mark: Preliminary Ratings
                    
                    //ditch effectiveness - 4 options
                    let ditchE = sites[number].value(forKey: "prDitch")! as! NSObject as! Int
                    ditchEPicker.selectRow(ditchE, inComponent: 0, animated: true)

            
                    //rockfall history - 4 options
                    let rockfallH = sites[number].value(forKey: "prHistory")! as! NSObject as! Int
                    rockfallHPicker.selectRow(rockfallH, inComponent: 0, animated: true)

            
                    bsPerEventText.text = sites[number].value(forKey: "prBvEvent")! as? String
                    
                    //impact on use - 4 options
                    let impactOU = sites[number].value(forKey: "prImpact")! as! NSObject as! Int
                    impactOUPicker.selectRow(impactOU, inComponent: 0, animated: true)
            
                    if((sites[number].value(forKey: "aadtCheck")! as! NSObject) as! Bool == true){ //ERROR HERE
                        let image = UIImage(named: "checkmark")
                        aadtButton.setImage(image, for: UIControlState())
                        selectedAadt = true
                    }
                    else{
                        let image = UIImage(named: "unchecked")
                        aadtButton.setImage(image, for: UIControlState())
                        selectedAadt = false
                        
                    }
                    
                    aadtEtcText.text = sites[number].value(forKey: "prAadt")! as? String
            
                    preliminaryRatingText.text = sites[number].value(forKey: "prTotal")! as? String
                    
                    //MARK: Slope Hazard Ratings
                    
                    //slope drainage - 4 options
                    let slopeD = sites[number].value(forKey: "shDrainage")! as! NSObject as! Int
                    slopeDPicker.selectRow(slopeD, inComponent: 0, animated: true)
            
                    annualRText.text = sites[number].value(forKey: "shAnnualRain")! as? String
                    slopeHText.text = sites[number].value(forKey: "shSlopeHeight")! as? String
                    
                    //rockfall related maintenance frequency - 4 options
                    let rockfallRMF = sites[number].value(forKey: "shMaintFreq")! as! NSObject as! Int
                    rockfallRMFPicker.selectRow(rockfallRMF, inComponent: 0, animated: true)

                    //Geological Character Case 1....special w/ o option
                    
                    //structural condition- 5 options
                    let structuralC1 = sites[number].value(forKey: "shStructural1")! as! NSObject as! Int
                    structuralC1Picker.selectRow(structuralC1, inComponent: 0, animated: true)

                    //rock friction - 5 options
                    let rockF1 = sites[number].value(forKey: "shFriction1")! as! NSObject as! Int
                    rockF1Picker.selectRow(rockF1, inComponent: 0, animated: true)

                    //Geological Character Case 2...special case w/ 0 option
                    //structural condition- 5 options
                    let structuralC2 = sites[number].value(forKey: "shStructural2")! as! NSObject as! Int
                    structuralC2Picker.selectRow(structuralC2, inComponent: 0, animated: true)

                    //rock friction - 5 options
                    let rockF2 = sites[number].value(forKey: "shFriction2")! as! NSObject as! Int
                    rockF2Picker.selectRow(rockF2, inComponent: 0, animated: true)

                    rockfallHazardTotalText.text = sites[number].value(forKey: "shTotal")! as? String
                    
                    //MARK: Risk Ratings
                    routeTWText.text = sites[number].value(forKey: "rrWidth")! as? String
                    humanEFText.text = sites[number].value(forKey: "rrHumanExposure")! as? String
                    percentDSDText.text = sites[number].value(forKey: "rrDsd")! as? String
                    
                    //right of way impacts - 4 options
                    let rightOWI = sites[number].value(forKey: "rrRight")! as! NSObject as! Int
                    rightOWIPicker.selectRow(rightOWI, inComponent: 0, animated: true)
            
                    //environmental/cutural impacts - 4 options
                    let environCI = sites[number].value(forKey: "rrEnviron")! as! NSObject as! Int
                    ecImpactsPicker.selectRow(environCI, inComponent: 0, animated: true)

                    //maintenance complexity - 4 options
                    let maintC = sites[number].value(forKey: "rrMaintenance")! as! NSObject as! Int
                    maintenanceCPicker.selectRow(maintC, inComponent: 0, animated: true)
                        
                    //event cost - 4 options
                    let eventC = sites[number].value(forKey: "rrEvent")! as! NSObject as! Int
                    eventCPicker.selectRow(eventC, inComponent: 0, animated: true)
            
                    riskTotalText.text = sites[number].value(forKey: "rrTotal")! as? String
                    totalScoreText.text = sites[number].value(forKey: "total")! as? String
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            let alertController = UIAlertController(title: "Error", message: "Could not fetch \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil) //may be an issue?
        }

    }
    
    
    //message for offline help

    @IBAction func getOfflineHelp(_ sender: AnyObject) {
        let messageString = "Save forms while offline. See what forms you have saved on the list. Clear a form when it isn't needed or load a form to double-check the information. Submit form(s) once you are back online."
        let alertController = UIAlertController(title: "Help", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: false, completion: nil) //may be an issue?
    }
    
    //present manual
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue2" {
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewOfflineRockfall")
        
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
