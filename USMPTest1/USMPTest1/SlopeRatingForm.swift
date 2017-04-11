//
//  SlopeRatingForm.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 4/6/17.
//  Copyright © 2017 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AssetsLibrary
import CoreData
import Photos
import SystemConfiguration
import BSImagePicker


class SlopeRatingForm: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate, UITextFieldDelegate, HazardTypeHelperProtocol{
    //singleton
    let shareData = ShareData.sharedInstance
    //feed from db/helper
    var feedItems: NSArray = NSArray()
    //hazard type
    var hazardItems: NSArray = NSArray()
    //location manager
    var locationManager = CLLocationManager()
    
    //UI>>>>>>>>>>>>>>>>>>
    @IBOutlet var agency: UIPickerView!
    var agencyOptions = ["Select Agency option", "FS", "NPS", "BLM", "BIA"]
    
    @IBOutlet var regional: UIPickerView!
    var regionalOptions = ["Select Regional option"]
    
    var FSRegionalOptions = ["Select Regional option" ,"Northern_Region", "Rocky_Mountain_Region", "Southwestern_Region", "Intermountain_Region",
                             "Pacific_Southwest_Region","Pacific_Northwest_Region","Southern_Region","Eastern_Region","Alaska_Region"]
    
    var NPSRegionalOptions = ["Select Regional option","AKR","IMR","MWR","NCR","NER","PWR","SER"]
    
    @IBOutlet var local: UIPickerView!
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
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var hazardType1: UIPickerView!
    
    @IBOutlet var hazardType2: UIPickerView!
    
    @IBOutlet var hazardType3: UIPickerView!
    
    var hazardOptions = ["","Planar", "Wedge", "Toppling", "Raveling/Undermining", "Rock Avalanche", "Indeterminate Rock Failures", "Diff. Erosion"]
    
    @IBOutlet weak var roadTrailNoText: UITextField!
    
    @IBOutlet var rtPicker: UIPickerView!
    
    var rtOptions = ["Road", "Trail"]
    
    @IBOutlet weak var roadTrailClassText: UITextField!
    
    @IBOutlet weak var rater: UITextField!
    
    @IBOutlet weak var beginMileText: UITextField!
    
    @IBOutlet weak var endMileText: UITextField!
    
    @IBOutlet var sidePicker: UIPickerView!
    
    var sideOptions = ["L - For use with roads with mile markers","R - For use with roads with mile markers",
                       "N - if road direction not specified with mile mark", "NE - if road direction not specified with mile mark", "E - if road direction not specified with mile mark","SE - if road direction not specified with mile mark", "S - if road direction not specified with mile mark", "SW - if road direction not specified with mile mark", "W - if road direction not specified with mile mark", "NW - if road direction not specified with mile mark"]
    
    @IBOutlet var weatherPicker: UIPickerView!
    
    var weatherOptions = ["Clear","Clear and Breezy","A Few Clouds","A Few Clouds and Breezy","Partly Cloudy","Partly Cloudy and Breezy","Mostly Cloudy","Mostly Cloudy and Breezy","Overcast","Overcast and Breezy","Fog","Partial Fog","Freezing Fog","Light Rain","Rain","Heavy Rain","Freezing Rain","Thunderstorms","Snow","Smoky\\/Haze","Unknown"]
    
    @IBOutlet weak var lat1Text: UITextField!
    
    @IBOutlet weak var lat2Text: UITextField!
    
    @IBOutlet weak var long1Text: UITextField!
    
    @IBOutlet weak var long2Text: UITextField!
    
    //buttons to autofill coordinates
    
    @IBOutlet weak var beginCoordButton: UIButton!
    
    @IBOutlet weak var endCoordButton: UIButton!
    
    var beginOrEnd = "begin"
    

    @IBOutlet weak var datumText: UITextField!
    
    @IBOutlet weak var aadtText: UITextField!

    @IBOutlet weak var lengthAffectedText: UITextField!
    
    @IBOutlet weak var slopeHText: UITextField!
    
    @IBOutlet weak var slopeAngleText: UITextField!
    
    @IBOutlet weak var sightDText: UITextField!
    
    @IBOutlet weak var roadwayTWText: UITextField!
    
    //new
    @IBOutlet weak var speedText: UITextField!
    
    @IBOutlet weak var ditchWidth1Text: UITextField!
    
    @IBOutlet weak var ditchWidth2Text: UITextField!
    
    @IBOutlet weak var ditchDepth1Text: UITextField!
    
    @IBOutlet weak var ditchDepth2Text: UITextField!
    
    @IBOutlet weak var ditchSlope1beginText: UITextField!
    
    @IBOutlet weak var ditchSlope1endText: UITextField!
    
    @IBOutlet weak var ditchSlope2beginText: UITextField!
    
    @IBOutlet weak var ditchSlope2endText: UITextField!

    @IBOutlet weak var blkSizeText: UITextField!
    
    @IBOutlet weak var volumeText: UITextField!
    
    @IBOutlet weak var beginRainText: UITextField!
    
    @IBOutlet weak var endRainText: UITextField!
    
    @IBOutlet var accessPicker: UIPickerView!
    
    var accessOptions = ["Yes", "No"]
    
    @IBOutlet weak var fixesPicker: UIPickerView!
    
    var fixesOptions = ["Yes", "No"]
    
    //image stuff
    var images = [PHAsset]()
    
    
    @IBOutlet weak var commentsText: UITextView!
    
    @IBOutlet weak var flmaNameText: UITextField!
    
    @IBOutlet weak var flmaIdText: UITextField!
    
    @IBOutlet weak var flmaDescriptionText: UITextField!
    
    //PRELIMINARY RATINGS
    
    @IBOutlet var roadwayWAPicker: UIPickerView!
    
    @IBOutlet var slideEEPicker: UIPickerView!
    
    @IBOutlet weak var roadwayLAText: UITextField!
    
    @IBOutlet weak var ditchEPicker: UIPickerView!
    
    @IBOutlet weak var rockfallHPicker: UIPickerView!
    
    @IBOutlet weak var bsPerEventText: UITextField!
    
    @IBOutlet var impactOUPicker: UIPickerView!
    
    @IBOutlet weak var aadtButton: UIButton!
    
    @IBOutlet weak var aadtEtcText: UITextField!

    
    var selectedAadt = false
    
    @IBOutlet weak var preliminaryRatingText: UITextField!
    
    //SLOPE HAZARD RATINGS
    @IBOutlet var slopeDPicker: UIPickerView!
    
    @IBOutlet weak var annualRText: UITextField!
    
    @IBOutlet weak var slopeHeightCalcText: UITextField!
    
    @IBOutlet var thawSPicker: UIPickerView!
    
    @IBOutlet var instabilityRMFPicker: UIPickerView!
    
    @IBOutlet var movementHPicker: UIPickerView!
    
    @IBOutlet var rockfallRMFPicker: UIPickerView!
    
    @IBOutlet var structuralC1Picker: UIPickerView!
    
    @IBOutlet var rockF1Picker: UIPickerView!
    
    @IBOutlet var structuralC2Picker: UIPickerView!
    
    @IBOutlet var rockF2Picker: UIPickerView!
    
   //new/different
    @IBOutlet weak var hazardTotalText: UITextField!
    
    //RISK RATINGS
    @IBOutlet weak var routeTWText: UITextField!
    
    @IBOutlet weak var humanEFText: UITextField!
    
    @IBOutlet weak var percentDSDText: UITextField!
    
    @IBOutlet var rightOWIPicker: UIPickerView!
    
    @IBOutlet var environCIPicker: UIPickerView!
    
    @IBOutlet var maintCPicker: UIPickerView!
    
    @IBOutlet var eventCPicker: UIPickerView!
    
    @IBOutlet weak var riskTotalsText: UITextField!
    
    //TOTAL SCORE
    
    @IBOutlet weak var totalScoreText: UITextField!
    
    var ratingOptions = ["3", "9", "27", "81"]
    
    var specialOptions = ["0", "3", "9", "27", "81"] //to use for geo chars.

    //Buttons
    @IBOutlet weak var submitButton: UIButton!

    
    //text fields for alerts
    var clearNum: UITextField = UITextField()
    var loadNum: UITextField = UITextField()
    var savedNum: UITextField = UITextField()
    var clearString = ""
    var loadString = ""
    var savedString = ""
    
    //autocomplete
    
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

    //Permissions
    if(shareData.level == 2){
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor.gray
    }
    
    //border around comments text view, otherwise hard to tell it's there
    commentsText.layer.borderWidth = 3
    commentsText.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor

    //cal autocomplete stuff
    //autocompleteStuff()
    
    //LOCATION
    //set the type of form
    shareData.OfflineType = "landslide"
    //get the user's current location
    self.locationManager = CLLocationManager()
    self.locationManager.requestWhenInUseAuthorization()
    //self.locationManager.requestAlwaysAuthorization()
    locationManager.delegate=self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    //call delegates
    delegates()
    
    //download hazard type list
    if(isInternetAvailable()){
        //hazard type options
        let hth = HazardTypeHelper()
        hth.delegate = self
        hth.downloadItems()
    }
    
    //load from core data
    if(shareData.load == true){
        //call special load method
        loadFromList()
    }
    //edit form offline
    if(shareData.offline_edit == true){
        shareData.offline_edit = false
        offlineEdit()
    }
        //edit form online
    else if(shareData.edit_site == true){
        //shareData.edit_site = false; //? problem
        edit()
    }
    
    //if there is internet connection
    if(!isInternetAvailable()){
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor.darkGray
    }
    
    //dismiss keyboard...
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandslideChoice.dismissKeyboard))
    view.addGestureRecognizer(tap)
    tap.cancelsTouchesInView = false //for the autocomplete
    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(shareData.form == "landslide"){
            //Landslide!!
            let notLandslide = ["blkSize", "volume", "ditchEffectiveness", "rockfallHistory", "bsvPerEvent", "rockfallRMF",  "structCond1", "rockFriction1", "structCond2", "rockFriction2"]
            if(cell.reuseIdentifier != nil){
                    if(notLandslide.contains(cell.reuseIdentifier!)){
                        cell.backgroundColor = UIColor.darkGray
                        cell.isUserInteractionEnabled = false
                    }
            }
        }
            
        if(shareData.form == "rockfall"){
        //Rockfall!
            let notRockfall = ["roadwayWidthAffected", "slideErosionEffects", "roadwayLengthAffected", "thawStability", "instabilityRMF", "movementHistory"]
            if(cell.reuseIdentifier != nil){
                if(notRockfall.contains(cell.reuseIdentifier!)){
                    cell.backgroundColor = UIColor.darkGray
                    cell.isUserInteractionEnabled = false
                }
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func autocompleteStuff(){
        //AUTOCOMPLETE
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
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
            pastR.append((wordsR[i].value(forKey: "word") as? NSString)!)
        }
        
        autoTableR.delegate = self
        autoTableR.dataSource = self
        autoTableR.isScrollEnabled = true
        autoTableR.isUserInteractionEnabled = true
        autoTableR.allowsSelectionDuringEditing = true
        autoTableR.allowsSelection = true
        autoTableR.isHidden = true
        
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
            pastLong.append((wordsLong[i].value(forKey: "word") as? NSString)!)
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
            pastLat.append((wordsLat[i].value(forKey: "word") as? NSString)!)
        }
        
        autoTableLat.delegate = self
        autoTableLat.dataSource = self
        autoTableLat.isScrollEnabled = true
        autoTableLat.isUserInteractionEnabled = true
        autoTableLat.allowsSelectionDuringEditing = true
        autoTableLat.allowsSelection = true
        autoTableLat.isHidden = true  //true
    }
    
    func delegates(){
        //PICKER DELEGATES
        agency.delegate = self
        agency.dataSource = self
        
        regional.delegate = self
        regional.dataSource = self
        
        local.delegate = self
        local.dataSource = self
        
        sidePicker.delegate = self
        sidePicker.dataSource = self
        
        accessPicker.delegate = self
        accessPicker.dataSource = self
        
        fixesPicker.delegate = self
        fixesPicker.dataSource = self
        
        rtPicker.delegate = self
        rtPicker.dataSource = self
        
        roadwayWAPicker.delegate = self
        roadwayWAPicker.dataSource = self
        
        slideEEPicker.delegate = self
        slideEEPicker.dataSource = self
        
        slopeDPicker.delegate = self
        slopeDPicker.dataSource = self
        
        thawSPicker.delegate = self
        thawSPicker.dataSource = self
        
        instabilityRMFPicker.delegate = self
        instabilityRMFPicker.dataSource = self
        
        movementHPicker.delegate = self
        movementHPicker.dataSource = self
        
        rightOWIPicker.delegate = self
        rightOWIPicker.dataSource = self
        
        environCIPicker.delegate = self
        environCIPicker.dataSource = self
        
        maintCPicker.delegate = self
        maintCPicker.dataSource = self
        
        eventCPicker.delegate = self
        eventCPicker.dataSource = self
        
        impactOUPicker.delegate = self
        impactOUPicker.dataSource = self
        
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
        
        hazardType1.delegate = self
        hazardType1.dataSource = self
        
        hazardType2.delegate = self
        hazardType2.dataSource = self
        
        hazardType3.delegate = self
        hazardType3.dataSource = self
        
        ditchEPicker.dataSource = self
        ditchEPicker.delegate = self
        
        rockfallHPicker.delegate = self
        rockfallHPicker.dataSource = self
        
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
        
        //TEXT FIELD DELEGATES
        bsPerEventText.delegate = self
        aadtEtcText.delegate = self
        annualRText.delegate = self
        slopeHeightCalcText.delegate = self
        routeTWText.delegate = self
        humanEFText.delegate = self
        percentDSDText.delegate = self
        preliminaryRatingText.delegate = self
        hazardTotalText.delegate = self
        riskTotalsText.delegate = self
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
        
        
    }
    
    //PICKER DELEGATE FUNCTIONS
    
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
        if(pickerView .isEqual(sidePicker)){
            components = sideOptions.count;
        }
        if(pickerView .isEqual(accessPicker)){
            components = accessOptions.count;
        }
        if(pickerView .isEqual(fixesPicker)){
            components = fixesOptions.count;
        }
        if(pickerView .isEqual(rtPicker)){
            components = rtOptions.count;
        }
        if(pickerView .isEqual(roadwayWAPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(slideEEPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(slopeDPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(thawSPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(movementHPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(rightOWIPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(environCIPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(maintCPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(eventCPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(impactOUPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(instabilityRMFPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(weatherPicker)){
            components = weatherOptions.count;
        }
        if(pickerView .isEqual(ditchEPicker)){
            components = ratingOptions.count;
        }
        if(pickerView .isEqual(rockfallHPicker)){
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

        if(pickerView .isEqual(sidePicker)){
            return sideOptions[row]
        }
        if(pickerView .isEqual(accessPicker)){
            return accessOptions[row]
        }
        if(pickerView .isEqual(fixesPicker)){
            return fixesOptions[row]
        }
        if(pickerView .isEqual(rtPicker)){
            return rtOptions[row]
        }
        if(pickerView .isEqual(roadwayWAPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(slideEEPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(slopeDPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(thawSPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(movementHPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(rightOWIPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(environCIPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(maintCPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(eventCPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(impactOUPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(instabilityRMFPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(weatherPicker)){
            return weatherOptions[row]
        }
        if(pickerView .isEqual(ditchEPicker)){
            return ratingOptions[row]
        }
        if(pickerView .isEqual(rockfallHPicker)){
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
            
        else{
            return "error";
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
        
        //calc C
        roadwayLAText.text = String(calculateC())
        
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
        humanEFText.text = String(calculateW())
        
        //calc X
        percentDSDText.text = String(calculateX())
        
        //calc prelim total
        preliminaryRatingText.text = String(calcPrelimTotal())
        
        //calc hazard total
        hazardTotalText.text = String(calcHazardTotal())
        
        //calc risk total
        riskTotalsText.text = String(calcRiskTotals())
        
        //calc overall total
        totalScoreText.text = String(calcTotalScore())
        
    }
    
    //click on the view, keyboard disappears
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    //get the info from the db call - HazardTypeHelper.swift
    func itemsDownloadedH(_ items: NSArray) {
        hazardItems = items
    }
    
    //CREDITS(5)
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
    
    //GET LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        //limit significant digits to 6 based on stakeholder feedback
        if(beginOrEnd == "begin"){
            lat1Text.text = String(format: "%f", locValue.latitude)
            long1Text.text = String(format: "%f", locValue.longitude)
        }
        if(beginOrEnd == "end"){
            lat2Text.text = String(format: "%f",locValue.latitude)
            long2Text.text = String(format: "%f",locValue.longitude)
        }
    }
    
    //error message to user
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
    
    
    func autocompleteR(_ substring: String)
    {
        if(autocompR.count != 0){ //so it doesn't show up when nothing is there and then you're stuck
            autoTableR.isHidden = false
        }else{
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
    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if(tableView == autoTableR){ //if...
//            return autocompR.count
//        }
//        else if (tableView == autoTableLong){
//            return autocompLong.count
//        }else{
//            return autocompLat.count
//        }
//        
//        
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        if (tableView == autoTableR) {
//            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
//            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
//            let index = (indexPath as NSIndexPath).row as Int
//            
//            cell.textLabel!.text = autocompR[index]
//            return cell
//            
//        }else if (tableView == autoTableLong){
//            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
//            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
//            let index = (indexPath as NSIndexPath).row as Int
//            
//            cell.textLabel!.text = autocompLong[index]
//            return cell
//            
//        }else{
//            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
//            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
//            let index = (indexPath as NSIndexPath).row as Int
//            
//            cell.textLabel!.text = autocompLat[index]
//            return cell
//            
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if (tableView == autoTableR){
//            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
//            autoTableR.isHidden = true
//            rater.text = selectedCell.textLabel!.text
//            
//        }else if (tableView == autoTableLong){
//            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
//            autoTableLong.isHidden = true
//            if(long == "one") {
//                long1Text.text = selectedCell.textLabel!.text
//            }
//            else if (long == "two"){
//                
//                long2Text.text = selectedCell.textLabel!.text
//                
//            }
//        }else if (tableView == autoTableLat){
//            let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
//            autoTableLat.isHidden = true
//            if(lat == "one") {
//                lat1Text.text = selectedCell.textLabel!.text
//            }
//            else if (lat == "two"){
//                
//                lat2Text.text = selectedCell.textLabel!.text
//                
//            }
//            
//        }
//        
//    }
    //auto-update when you click out of text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        //MARK: Calculation Calls
        
        //calc C
        roadwayLAText.text = String(calculateC())
        
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
        humanEFText.text = String(calculateW())
        
        //calc X
        percentDSDText.text = String(calculateX())
        
        //calc prelim total
        preliminaryRatingText.text = String(calcPrelimTotal())
        
        //calc hazard total
        hazardTotalText.text = String(calcHazardTotal())
        
        //calc risk total
        riskTotalsText.text = String(calcRiskTotals())
        
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
            if(rater.text! == "" || (rater.text?.characters.count)! >= 30){
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
            if(slopeAngleText.text! == "" || Int(slopeAngleText.text!)! > 90 || Int(slopeAngleText.text!)! < 0 || Int(slopeAngleText.text!) == nil  ){
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
            if(bsPerEventText.text! == "" || Int(bsPerEventText.text!)! < 0 || Int(bsPerEventText.text!)! > 100 || Int(bsPerEventText.text!) == nil){
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
            if(aadtEtcText.text! == "" || Int(aadtEtcText.text!)! < 0 || Int(aadtEtcText.text!)! > 100 || Int(aadtEtcText.text!) == nil){
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
            if(annualRText.text! == "" || Int(annualRText.text!)! < 0 || Int(annualRText.text!)! > 100 || Int(annualRText.text!) == nil){
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
            if(slopeHeightCalcText.text! == "" || Int(slopeHeightCalcText.text!)! < 0 || Int(slopeHeightCalcText.text!)! > 100 || Int(slopeHeightCalcText.text!) == nil){
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
            if(routeTWText.text! == "" || Int(routeTWText.text!)! < 0 || Int(routeTWText.text!)! > 100 || Int(routeTWText.text!) == nil){
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
            if(humanEFText.text! == "" || Int(humanEFText.text!)! < 0 || Int(humanEFText.text!)! > 100 || Int(humanEFText.text!) == nil){
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
            if(percentDSDText.text! == "" || Int(percentDSDText.text!)! < 0 || Int(percentDSDText.text!)! > 100 || Int(percentDSDText.text!) == nil){
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
    
    //MARK: Info Buttons
    
    //preliminary ratings
    @IBAction func getroadwayWAInfo(_ sender: AnyObject) {
        let messageString = "3: 0-5% \n 9: 6-25% \n 27: 26-50% \n 81: 51-100%"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getSlideEEInfo(_ sender: AnyObject) {
        let messageString = "3: Visible crack or slight deposit of material/minor erosion \n 9: 1 in. offset or 6 in. deposit of material/major erosion will affect travel in <5 years \n 27: 2 in. offset or 12 in. deposit/mod. erosion impacting travel annually \n 81: 4 in. offset or 24 in. deposit/severe erosion impacting travel consistently"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getRoadwayLAInfo(_ sender: AnyObject) {
        let messageString = "3: 25ft \n 9: 100ft \n 27: 225ft \n 81: 400ft"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
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
    
    @IBAction func getThawSInfo(_ sender: AnyObject) {
        let messageString = "3: Unfrozen/thaw stable \n 9: Slightly thaw unstable \n 27: Moderately thaw unstable \n 81: Highly thaw unstable"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getInstabilityRMFInfo(_ sender: AnyObject) {
        let messageString = "3: Every 10 years \n 9: Every 5 years \n 27: Every 2 years \n 81: Every year"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getMovementHInfo(_ sender: AnyObject) {
        let messageString = "3: Minor movement or sporadic creep \n 9: Up to 1 in. annually or steady annual creep \n 27: Up to 3 in. per event, one event per year \n 81: >3\" per event, >6\" annually, more than 1 event per year (includes all debris flows"
        
        let alertController = UIAlertController(title: "Rating Info", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
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
    
    //MARK: AUTOFILL COORDINATES
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
    
    //MARK: CHOOOSE IMAGES
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
    

    
    //aadt checkmark
    @IBAction func selectAadt(_ sender: AnyObject) {
        if(selectedAadt == false){
            let image = UIImage.init(named: "checkmark")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = true
            aadtEtcText.text = String(calculateH())
            preliminaryRatingText.text = String(calcPrelimTotal())
        }
        else{
            let image = UIImage.init(named: "unchecked")
            aadtButton.setImage(image, for: UIControlState())
            selectedAadt = false
            preliminaryRatingText.text = String(calcPrelimTotal())
            
        }
    }
    
    //LANDSLIDE CALCULATIONS
    
    
    //Calculate C: Roadway Length Affected
    func calculateC() ->Int{
        var temp = 1.0
        if(lengthAffectedText.text != ""){
            let value = Double(lengthAffectedText.text!)
            
            temp = value!/25 //divide input by 25
            temp = sqrt(temp) //take the square root
            temp = pow(3.0, temp) //3^
            
            temp = (round(temp*10))/10 //rounding
            
            if(temp>100){ //if > 100, set = 100
                temp = 100
            }
        }
        temp = round(temp)
        let tempInt = Int(temp)
        
        return tempInt
    }
    
    
    //ROCKFALL CALCULATIONS
    
    //Calculate F: BlkSize/Volume
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
    
    
    //CALCULATIONS FOR BOTH
    
    //Calculate H: Aadt/Etc
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
    
    //Calculate J: Annual Rainfall
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
    
    
    //Calculate K: Slope Height/Axial Length of Slide
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
    
    //(ALL) Risk Ratings
    //use road/trail picker and roadwayTWText to set routeTWText
    func calculateV()->Int{
        var value = 0.0
        var compare = 100.0
        
        if(roadwayTWText.text != ""){
            var val = Double(roadwayTWText.text!)
            let selectedVal = rtPicker.selectedRow(inComponent: 0)
            
            //if >100, set = 100
            if(val!>compare){
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
    
    func calculateW()->Int{
        var value = 0.0
        
        if(aadtEtcText.text != "" && roadwayLAText.text != "" && speedText.text != ""){
            value = Double(aadtEtcText.text!)! / 24
            value = value * Double(lengthAffectedText.text!)!
            value = value / Double(speedText.text!)!
            value = value / 12.5
            value = pow(3, value)
            
            value = min(value, 100)
            value = max(value, 0)
            
        }
        
        value = round(value)
        let tempInt = Int(value)
        
        return tempInt
        
        
    }
    
    func calculateX()->Int{
        var speed = 0.0
        var value = 0.0
        
        if(sightDText.text != ""){
            let sightDist = Double(sightDText.text!)
            
            let selectedVal = Double(speedText.text!)
            
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
    
    func calcPrelimTotal()->Int{
        var total = 0.0
        
        //G
        let valueG = impactOUPicker.selectedRow(inComponent: 0)
        let numG = Double(ratingOptions[valueG])
        total = total + numG!
        
        //H
        if(aadtEtcText.text != ""){
        let valueH = Double(aadtEtcText.text!)
        total = total + valueH!
        }
        
        //Landslide
        //A+B+C+G+H
        if(shareData.form == "landslide"){
            
            //A
            let valueA = roadwayWAPicker.selectedRow(inComponent: 0)
            let numA = Double(ratingOptions[valueA])
            total = total + numA!
            
            //B
            let valueB = slideEEPicker.selectedRow(inComponent: 0)
            let numB = Double(ratingOptions[valueB])
            total = total + numB!
            
            //C
            if(roadwayLAText.text != ""){
            let valueC = Double(roadwayLAText.text!)
            total = total + valueC!
            }
            
            
        }
        //Rockfall
        //D+E+F+G+H
        else if(shareData.form == "rockfall"){
            
            //D
            let valueD = ditchEPicker.selectedRow(inComponent: 0)
            let numD = Double(ratingOptions[valueD])
            total = total + numD!
            
            //E
            let valueE = rockfallHPicker.selectedRow(inComponent: 0)
            let numE = Double(ratingOptions[valueE])
            total = total + numE!
            
            //F
            if(bsPerEventText.text != ""){
                let valueF = Double(bsPerEventText.text!)
                total = total + valueF!
            }
        }
        
        total = round(total)
        let tempInt = Int(total)
        
        return tempInt
        
    }
    
    func calcHazardTotal()->Int{
        var total = 0.0
        
        //I
        let valueI = slopeDPicker.selectedRow(inComponent: 0)
        let numI = Double(ratingOptions[valueI])
        total = total + numI!
        
        //J
        if(annualRText.text != ""){
        let valueJ = Double(annualRText.text!)
        total = total + valueJ!
        }
        
        //K
        if(slopeHeightCalcText.text != ""){
        let valueK = Double(slopeHeightCalcText.text!)
        total = total + valueK!
        }

        
        //Landslide
        //A+B+C+I+J+K+L+M+N
        
        if(shareData.form == "landslide"){
            
            //A
            let valueA = roadwayWAPicker.selectedRow(inComponent: 0)
            let numA = Double(ratingOptions[valueA])
            total = total + numA!
            
            //B
            let valueB = slideEEPicker.selectedRow(inComponent: 0)
            let numB = Double(ratingOptions[valueB])
            total = total + numB!
            
            //C
            if(roadwayLAText.text != ""){
            let valueC = Double(roadwayLAText.text!)
            total = total + valueC!
            }
            
            //L
            let valueL = thawSPicker.selectedRow(inComponent: 0)
            let numL = Double(ratingOptions[valueL])
            total = total + numL!
            
            //M
            let valueM = instabilityRMFPicker.selectedRow(inComponent: 0)
            let numM = Double(ratingOptions[valueM])
            total = total + numM!
            
            //N
            let valueN = movementHPicker.selectedRow(inComponent: 0)
            let numN = Double(ratingOptions[valueN])
            total = total + numN!
            
        }
            //Rockfall
            //D+E+F+I+J+K+O+(greater of P+Q or R+S)
        else if(shareData.form == "rockfall"){
            
            //D
            let valueD = ditchEPicker.selectedRow(inComponent: 0)
            let numD = Double(ratingOptions[valueD])
            total = total + numD!
            
            //E
            let valueE = rockfallHPicker.selectedRow(inComponent: 0)
            let numE = Double(ratingOptions[valueE])
            total = total + numE!
            
            //F
            if(bsPerEventText.text != ""){
            let valueF = Double(bsPerEventText.text!)
            total = total + valueF!
            }
            
            //O
            let valueO = rockfallRMFPicker.selectedRow(inComponent: 0)
            let numO = Double(ratingOptions[valueO])
            total = total + numO!
            
            var pq = 0.0
            
            //P
            let valueP = structuralC1Picker.selectedRow(inComponent: 0)
            let numP = Double(specialOptions[valueP])
            pq = pq + numP!
            
            //Q
            let valueQ = rockF1Picker.selectedRow(inComponent: 0)
            let numQ = Double(specialOptions[valueQ])
            pq = pq + numQ!
            
            var rs = 0.0
            
            //R
            let valueR = structuralC2Picker.selectedRow(inComponent: 0)
            let numR = Double(specialOptions[valueR])
            rs = rs + numR!
            
            //S
            let valueS = rockF2Picker.selectedRow(inComponent: 0)
            let numS = Double(specialOptions[valueS])
            rs = rs + numS!
            
            if(pq >= rs){
                total = total+pq
            }
            else{
                total = total + rs
            }
        }
        
        total = round(total)
        let tempInt = Int(total)
        
        return tempInt
        
    }
    
    
    //G+H+V+W+X+Y+Z+AA+BB
    func calcRiskTotals()->Int{
        var total = 0.0
        
        //G
        let valueG = impactOUPicker.selectedRow(inComponent: 0)
        let numG = Double(ratingOptions[valueG])
        total = total + numG!
        
        //H
        if(aadtEtcText.text != ""){
        let valueH = Double(aadtEtcText.text!)
        total = total + valueH!
        }
        
        //V
        if(routeTWText.text != ""){
        let valueV = Double(routeTWText.text!)
        total = total + valueV!
        }
        
        //W
        if(humanEFText.text != ""){
        let valueW = Double(humanEFText.text!)
        total = total + valueW!
        }
        
        //X
        if(percentDSDText.text != ""){
        let valueX = Double(percentDSDText.text!)
        total = total + valueX!
        }
        
        //Y
        let valueY = rightOWIPicker.selectedRow(inComponent: 0)
        let numY = Double(ratingOptions[valueY])
        total = total + numY!
        
        //Z
        let valueZ = environCIPicker.selectedRow(inComponent: 0)
        let numZ = Double(ratingOptions[valueZ])
        total = total + numZ!
        
        //AA
        let valueAA = maintCPicker.selectedRow(inComponent: 0)
        let numAA = Double(ratingOptions[valueAA])
        total = total + numAA!
        
        //BB
        let valueBB = eventCPicker.selectedRow(inComponent: 0)
        let numBB = Double(ratingOptions[valueBB])
        total = total + numBB!
        
        total = round(total)
        let tempInt = Int(total)
        
        return tempInt
        
    }
    
    func calcTotalScore()->Int{
        var total = 0.0
        
        if(hazardTotalText.text != ""){
            total = total + Double(hazardTotalText.text!)!
        }
        if(riskTotalsText.text != ""){
            total = total + Double(riskTotalsText.text!)!
        }
        
        
        total = round(total)
        let tempInt = Int(total)
        return tempInt
        
    }
    

    
    //fill me in later
    func loadFromList(){
        
    }
    
    func offlineEdit(){
        
    }
    
    func edit(){
        
        
        
    }
    
 
    func UploadRequest(){
        
    }
    
    //MARK: SUBMIT
    
    @IBAction func submit(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Submit", message: "Are you sure you want to submit the form?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: handleSubmit))
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    //Yes, they want to submit the form
    func handleSubmit(_ alertView:UIAlertAction!){
        
            //site information all:
            
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
            var speed = 0.0
            if(speedText.text != ""){
            speed = Double(speedText.text!)!
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
            
            //Prelim Ratings-All:
            var impact_on_use = "3"
            let selected_iou = impactOUPicker.selectedRow(inComponent: 0)
            impact_on_use = ratingOptions[selected_iou]
            
            //Slope Hazard - All:
            var slope_drainage = "3"
            let selected_sd = slopeDPicker.selectedRow(inComponent: 0)
            slope_drainage = ratingOptions[selected_sd]
            
            //Risk Ratings - ALL:
            var r_w_impacts = "3"
            let selected_rwi = rightOWIPicker.selectedRow(inComponent: 0)
            r_w_impacts = ratingOptions[selected_rwi]
            
            var enviro_cult_impacts = "3"
            let selected_eci = environCIPicker.selectedRow(inComponent: 0)
            enviro_cult_impacts = ratingOptions[selected_eci]
            
            var maint_complexity = "3"
            let selected_mc = maintCPicker.selectedRow(inComponent: 0)
            maint_complexity = ratingOptions[selected_mc]
            
            var event_cost = "3"
            let selected_ec = eventCPicker.selectedRow(inComponent: 0)
            event_cost = ratingOptions[selected_ec]
            
            let email = ""
            
            //rockfall only:
            var prelim_ditch_effectiveness = "3"
            let selected_pde=ditchEPicker.selectedRow(inComponent: 0)
            prelim_ditch_effectiveness = ratingOptions[selected_pde]
            
            var prelim_rockfall_history = "3"
            let selected_prh = rockfallHPicker.selectedRow(inComponent: 0)
            prelim_rockfall_history = ratingOptions[selected_prh]
            
            var hazard_rr_maint_freq = "3"
            let selected_hrrmf = rockfallRMFPicker.selectedRow(inComponent: 0)
            hazard_rr_maint_freq = ratingOptions[selected_hrrmf]
            
            var struct_c1 = "3"
            let selected_sc1=structuralC1Picker.selectedRow(inComponent: 0)
            struct_c1 = specialOptions[selected_sc1]
            
            var rock_f1 = "3"
            let selected_rf1 = rockF1Picker.selectedRow(inComponent: 0 )
            rock_f1 = specialOptions[selected_rf1]
            
            var struct_c2 = "3"
            let selected_sc2=structuralC1Picker.selectedRow(inComponent: 0)
            struct_c2 = specialOptions[selected_sc2]
            
            var rock_f2 = "3"
            let selected_rf2 = rockF1Picker.selectedRow(inComponent: 0 )
            rock_f2 = specialOptions[selected_rf2]
            
            //landslide only:
            var prelim_landslide_road_width_affected = "3"
            let selected_plrwa = roadwayWAPicker.selectedRow(inComponent: 0)
            prelim_landslide_road_width_affected = ratingOptions[selected_plrwa]
            
            var prelim_landslide_slide_erosion_effects = "3"
            let selected_plsee = slideEEPicker.selectedRow(inComponent: 0)
            prelim_landslide_slide_erosion_effects = ratingOptions[selected_plsee]
            
            var hazard_landslide_thaw_stability = "3"
            let selected_hlts = thawSPicker.selectedRow(inComponent: 0)
            hazard_landslide_thaw_stability = ratingOptions[selected_hlts]
            
            var hazard_landslide_maint_frequency = "3"
            let selected_hlmf = instabilityRMFPicker.selectedRow(inComponent: 0)
            hazard_landslide_maint_frequency = ratingOptions[selected_hlmf]
            
            var hazard_landslide_movement_history = "3"
            let selected_hlmh = movementHPicker.selectedRow(inComponent: 0)
            hazard_landslide_movement_history = ratingOptions[selected_hlmh]
        
         var request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/editSite.php")! as URL)
            
        //editing a form
        if(shareData.edit_site == true){
            
            //landslide
            if(shareData.form == "landslide"){
                
                request.httpMethod = "POST"
              
                let postString = "old_site_id=\(shareData.current_site_id)&umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text!)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&volume=0&prelim_landslide_road_width_affected=\(prelim_landslide_road_width_affected)&prelim_landslide_slide_erosion_effects=\(prelim_landslide_slide_erosion_effects) &prelim_landslide_length_affected=\(roadwayLAText.text!)&prelim_rockfall_ditch_eff=0&prelim_rockfall_rockfall_history=0&prelim_rockfall_block_size_event_vol=0&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=\(hazard_landslide_thaw_stability)&hazard_landslide_maint_frequency=\(hazard_landslide_maint_frequency)&hazard_landslide_movement_history=\(hazard_landslide_movement_history)&hazard_rockfall_maint_frequency=0&case_one_struc_cond=0&case_one_rock_friction=0&case_two_struc_condition=0&case_two_diff_erosion=0&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(hazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalsText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)&email=\(email)"
                request.httpBody = postString.data(using: String.Encoding.utf8)
            }
            
            //rockfall
            else{
                let postString = "old_site_id=\(shareData.current_site_id)&umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&volume=\(volumeText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&prelim_landslide_road_width_affected=0&prelim_landslide_slide_erosion_effects=0&prelim_landslide_length_affected=0&prelim_rockfall_ditch_eff=\(prelim_ditch_effectiveness)&prelim_rockfall_rockfall_history=\(prelim_rockfall_history)&prelim_rockfall_block_size_event_vol=\(bsPerEventText.text!)&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=0&hazard_landslide_maint_frequency=0&hazard_landslide_movement_history=0&hazard_rockfall_maint_frequency=\(hazard_rr_maint_freq)&case_one_struc_cond=\(struct_c1)&case_one_rock_friction=\(rock_f1)&case_two_struc_condition=\(struct_c2)&case_two_diff_erosion=\(rock_f2)&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(hazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalsText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)&email=\(email)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
    
            }
            
            
        }
            //creating a new form
        else{
            //post request, new slope rating form
            request = NSMutableURLRequest(url: NSURL(string: "http://nl.cs.montana.edu/test_sites/colleen.rothe/add_new_site.php")! as URL)
            request.httpMethod = "POST"
            
            if(shareData.form == "landslide"){
            let postString = "umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text!)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&volume=0&prelim_landslide_road_width_affected=\(prelim_landslide_road_width_affected)&prelim_landslide_slide_erosion_effects=\(prelim_landslide_slide_erosion_effects) &prelim_landslide_length_affected=\(roadwayLAText.text!)&prelim_rockfall_ditch_eff=0&prelim_rockfall_rockfall_history=0&prelim_rockfall_block_size_event_vol=0&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=\(hazard_landslide_thaw_stability)&hazard_landslide_maint_frequency=\(hazard_landslide_maint_frequency)&hazard_landslide_movement_history=\(hazard_landslide_movement_history)&hazard_rockfall_maint_frequency=0&case_one_struc_cond=0&case_one_rock_friction=0&case_two_struc_condition=0&case_two_diff_erosion=0&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(hazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalsText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)"
            request.httpBody = postString.data(using: String.Encoding.utf8)

            }
            //rockfall
            else{
                let postString = "umbrella_agency=\(agencyS)&regional_admin=\(regionalS)&local_admin=\(localS)&road_trail_number=\(roadTrailNoText.text!)&road_trail_class=\(roadTrailClassText.text!)&begin_mile_marker=\(beginMileText.text!)&end_mile_marker=\(endMileText.text!)&road_or_trail=\(road_or_trail)&side=\(side)&rater=\(rater.text!)&weather=\(weather)&begin_coordinate_latitude=\(lat1Text.text!)&begin_coordinate_longitude=\(long1Text.text!)&end_coordinate_latitude=\(lat2Text.text!)&end_coordinate_longitude=\(long2Text.text!)&datum=\(datumText.text!)&aadt=\(aadtText.text!)&hazard_type=\(hazard)&length_affected=\(lengthAffectedText.text!)&slope_height_axial_length=\(slopeHText.text!)&slope_angle=\(slopeAngleText.text!)&sight_distance=\(sightDText.text!)&road_trail_width=\(roadwayTWText.text!)&speed_limit=\(speed)&minimum_ditch_width=\(ditchWidth1Text.text!)&maximum_ditch_width=\(ditchWidth2Text.text!)&minimum_ditch_depth=\(ditchDepth1Text.text!)&maximum_ditch_depth=\(ditchDepth2Text.text!)&first_begin_ditch_slope=\(ditchSlope1beginText.text!)&first_end_ditch_slope=\(ditchSlope1endText.text!)&second_begin_ditch_slope=\(ditchSlope2beginText.text!)&second_end_ditch_slope=\(ditchSlope2endText.text!)&volume=\(volumeText.text!)&start_annual_rainfall=\(beginRainText.text!)&end_annual_rainfall=\(endRainText.text!)&sole_access_route=\(sole_access)&fixes_present=\(fixes_present)&blk_size=0&prelim_landslide_road_width_affected=0&prelim_landslide_slide_erosion_effects=0&prelim_landslide_length_affected=0&prelim_rockfall_ditch_eff=\(prelim_ditch_effectiveness)&prelim_rockfall_rockfall_history=\(prelim_rockfall_history)&prelim_rockfall_block_size_event_vol=\(bsPerEventText.text!)&impact_on_use=\(impact_on_use)&aadt_usage_calc_checkbox=0&aadt_usage=\(aadtEtcText.text!)&prelim_rating=\(preliminaryRatingText.text!)&slope_drainage=\(slope_drainage)&hazard_rating_annual_rainfall=\(annualRText.text!)&hazard_rating_slope_height_axial_length=\(slopeHeightCalcText.text!)&hazard_landslide_thaw_stability=0&hazard_landslide_maint_frequency=0&hazard_landslide_movement_history=0&hazard_rockfall_maint_frequency=\(hazard_rr_maint_freq)&case_one_struc_cond=\(struct_c1)&case_one_rock_friction=\(rock_f1)&case_two_struc_condition=\(struct_c2)&case_two_diff_erosion=\(rock_f2)&route_trail_width=\(routeTWText.text!)&human_ex_factor=\(humanEFText.text!)&percent_dsd=\(percentDSDText.text!)&r_w_impacts=\(r_w_impacts)&enviro_cult_impacts=\(enviro_cult_impacts)&maint_complexity=\(maint_complexity)&event_cost=\(event_cost)&hazard_rating_landslide_total=\(hazardTotalText.text!)&hazard_rating_rockfall_total=0&risk_total=\(riskTotalsText.text!)&total_score=\(totalScoreText.text!)&comments=\(commentsText.text!)&fmla_id=\(flmaIdText.text!)&fmla_name=\(flmaNameText.text!)&fmla_description=\(flmaDescriptionText.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
        }
        }
        
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                //print messages to the user, success/fail?
                
                if error != nil {
                    print("error=\(String(describing: error))")
                    let alertController = UIAlertController(title: "Error", message: "There was an error submitting your information", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                //user message confirming submit
                let alertController = UIAlertController(title: "Success", message: "Information Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
                return
            }
            task.resume()
        
        UploadRequest()
        
    }
}

