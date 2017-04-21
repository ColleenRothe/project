package teammsu.colleenrothe.usmp;

/*
    Class represents an object holding all of the information on a new slope event form
 */

public class NewSlopeEvent extends Object {
    private int id;

    private String observer_name;
    private String email;
    private String phone_no;
    private String comments;
    private String date; //? DATE
    private int date_approximator;
    private String dateinput; //? DATE
    private int hazard_type;
    private int state;
    private String photos;
    private String road_trail_number;
    private int rt_type;
    private String begin_mile_marker;
    private String end_mile_marker;
    private String datum;
    private String coordinate_latitude;
    private String coordinate_longitude;
    private int condition;
    private String affected_length;
    private int size_rock;
    private int num_fallen_rocks;
    private int vol_debris;
    //description of event location
    private int above_road;
    private int below_road;
    private int at_culvert;
    private int above_river;
    private int above_coast;
    private int burned_area;
    private int deforested_slope;
    private int urban;
    private int mine;
    private int retaining_wall;
    private int natural_slope;
    private int engineered_slope;
    private int unknown;
    private int other;
    //possible cause of event
    private int rain_checkbox;
    private int thunder_checkbox;
    private int cont_rain_checkbox;
    private int hurricane_checkbox;
    private int flood_checkbox;
    private int snowfall_checkbox;
    private int freezing_checkbox;
    private int high_temp_checkbox;
    private int earthquake_checkbox;
    private int volcano_checkbox;
    private int leaky_pipe_checkbox;
    private int mining_checkbox;
    private int construction_checkbox;
    private int dam_embankment_collapse_checkbox;
    private int not_obvious_checkbox;
    private int unknown_checkbox;
    private int other_checkbox;

    private int damages_y_n;
    private String damages;


    public NewSlopeEvent(){

    }

    //constructor w/ id
    public NewSlopeEvent(int id, String observer_name, String email, String phone_no, String date,
                         int date_approximator, String dateinput, int hazard_type, int state, String photos, String road_trail_number,
                         int rt_type, String begin_mile_marker, String end_mile_marker, String datum,
                         String coordinate_latitude, String coordinate_longitude, int condition, String affected_length,
                         int size_rock, int num_fallen_rocks, int vol_debris,  int above_road, int below_road,
                         int at_culvert, int above_river, int above_coast, int burned_area, int deforested_slope,
                         int urban, int mine, int retaining_wall, int natural_slope, int engineered_slope,
                         int unknown, int other, int rain_checkbox, int thunder_checkbox, int cont_rain_checkbox,
                         int hurricane_checkbox, int flood_checkbox, int snowfall_checkbox, int freezing_checkbox,
                         int high_temp_checkbox, int earthquake_checkbox, int volcano_checkbox, int leaky_pipe_checkbox,
                         int mining_checkbox, int construction_checkbox, int dam_embankment_collapse_checkbox, int
                         not_obvious_checkbox, int unknown_checkbox, int other_checkbox, int damages_y_n, String damages, String comments){
        this.id = id;
        this.observer_name = observer_name;
        this.email = email;
        this.phone_no = phone_no;
        this.comments = comments;
        this.date = date;
        this.date_approximator = date_approximator;
        this.dateinput = dateinput;
        this.hazard_type = hazard_type;
        this.state = state;
        this.photos=photos;
        this.road_trail_number = road_trail_number;
        this.rt_type = rt_type;
        this.begin_mile_marker = begin_mile_marker;
        this.end_mile_marker = end_mile_marker;
        this.datum = datum;
        this.coordinate_latitude = coordinate_latitude;
        this.coordinate_longitude = coordinate_longitude;
        this.condition = condition;
        this.affected_length = affected_length;
        this.size_rock = size_rock;
        this.num_fallen_rocks = num_fallen_rocks;
        this.vol_debris = vol_debris;
        this.above_road=above_road;
        this.below_road = below_road;
        this.at_culvert = at_culvert;
        this.above_river = above_river;
        this.above_coast = above_coast;
        this.burned_area = burned_area;
        this.deforested_slope = deforested_slope;
        this.urban = urban;
        this.mine = mine;
        this.retaining_wall = retaining_wall;
        this.natural_slope = natural_slope;
        this.engineered_slope = engineered_slope;
        this.unknown = unknown;
        this.other = other;
        this.rain_checkbox = rain_checkbox;
        this.thunder_checkbox = thunder_checkbox;
        this.cont_rain_checkbox = cont_rain_checkbox;
        this.hurricane_checkbox = hurricane_checkbox;
        this.flood_checkbox = flood_checkbox;
        this.snowfall_checkbox = snowfall_checkbox;
        this.freezing_checkbox = freezing_checkbox;
        this.high_temp_checkbox = high_temp_checkbox;
        this.earthquake_checkbox = earthquake_checkbox;
        this.volcano_checkbox = volcano_checkbox;
        this.leaky_pipe_checkbox = leaky_pipe_checkbox;
        this.mining_checkbox = mining_checkbox;
        this.construction_checkbox = construction_checkbox;
        this.dam_embankment_collapse_checkbox = dam_embankment_collapse_checkbox;
        this.not_obvious_checkbox = not_obvious_checkbox;
        this.unknown_checkbox = unknown_checkbox;
        this.other_checkbox = other_checkbox;
        this.damages_y_n = damages_y_n;
        this.damages = damages;

    }
    //constructor no id
    public NewSlopeEvent(String observer_name, String email, String phone_no, String date,
                         int date_approximator, String dateinput, int hazard_type, int state, String photos, String road_trail_number,
                         int rt_type, String begin_mile_marker, String end_mile_marker, String datum,
                         String coordinate_latitude, String coordinate_longitude, int condition, String affected_length,
                         int size_rock, int num_fallen_rocks, int vol_debris, int above_road, int below_road,
                         int at_culvert, int above_river, int above_coast, int burned_area, int deforested_slope,
                         int urban, int mine, int retaining_wall, int natural_slope, int engineered_slope,
                         int unknown, int other, int rain_checkbox, int thunder_checkbox, int cont_rain_checkbox,
                         int hurricane_checkbox, int flood_checkbox, int snowfall_checkbox, int freezing_checkbox,
                         int high_temp_checkbox, int earthquake_checkbox, int volcano_checkbox, int leaky_pipe_checkbox,
                         int mining_checkbox, int construction_checkbox, int dam_embankment_collapse_checkbox, int
                                 not_obvious_checkbox, int unknown_checkbox, int other_checkbox, int damages_y_n, String damages, String comments){

        this.observer_name = observer_name;
        this.email = email;
        this.phone_no = phone_no;
        this.comments = comments;
        this.date = date;
        this.date_approximator = date_approximator;
        this.dateinput = dateinput;
        this.hazard_type = hazard_type;
        this.state = state;
        this.photos=photos;
        this.road_trail_number = road_trail_number;
        this.rt_type = rt_type;
        this.begin_mile_marker = begin_mile_marker;
        this.end_mile_marker = end_mile_marker;
        this.datum = datum;
        this.coordinate_latitude = coordinate_latitude;
        this.coordinate_longitude = coordinate_longitude;
        this.condition = condition;
        this.affected_length = affected_length;
        this.size_rock = size_rock;
        this.num_fallen_rocks = num_fallen_rocks;
        this.vol_debris = vol_debris;
        this.above_road=above_road;
        this.below_road = below_road;
        this.at_culvert = at_culvert;
        this.above_river = above_river;
        this.above_coast = above_coast;
        this.burned_area = burned_area;
        this.deforested_slope = deforested_slope;
        this.urban = urban;
        this.mine = mine;
        this.retaining_wall = retaining_wall;
        this.natural_slope = natural_slope;
        this.engineered_slope = engineered_slope;
        this.unknown = unknown;
        this.other = other;
        this.rain_checkbox = rain_checkbox;
        this.thunder_checkbox = thunder_checkbox;
        this.cont_rain_checkbox = cont_rain_checkbox;
        this.hurricane_checkbox = hurricane_checkbox;
        this.flood_checkbox = flood_checkbox;
        this.snowfall_checkbox = snowfall_checkbox;
        this.freezing_checkbox = freezing_checkbox;
        this.high_temp_checkbox = high_temp_checkbox;
        this.earthquake_checkbox = earthquake_checkbox;
        this.volcano_checkbox = volcano_checkbox;
        this.leaky_pipe_checkbox = leaky_pipe_checkbox;
        this.mining_checkbox = mining_checkbox;
        this.construction_checkbox = construction_checkbox;
        this.dam_embankment_collapse_checkbox = dam_embankment_collapse_checkbox;
        this.not_obvious_checkbox = not_obvious_checkbox;
        this.unknown_checkbox = unknown_checkbox;
        this.other_checkbox = other_checkbox;
        this.damages_y_n = damages_y_n;
        this.damages = damages;

    }
    //getter and setter methods

    public int getId(){return id;}
    public void setId(int id){this.id=id;}

    public String getObserver_name(){return observer_name;}
    public void setObserver_name(String observer_name){this.observer_name=observer_name;}

    public String getEmail(){return email;}
    public void setEmail(String email){this.email=email;}

    public String getPhone_no(){return phone_no;}
    public void setPhone_no(String phone_no){this.phone_no=phone_no;}

    public String getDate(){return date;}
    public void setDate(String date){this.date=date;}

    public String getComments(){return comments;}
    public void setComments(String comments){this.comments=comments;}

    public int getDate_approximator(){return date_approximator;}
    public void setDate_approximator(int date_approximator){this.date_approximator=date_approximator;}

    public String getDateinput(){return dateinput;}
    public void setDateinput(String dateinput){this.dateinput=dateinput;}

    public int getHazard_type(){return hazard_type;}
    public void setHazard_type(int hazard_type){this.hazard_type=hazard_type;}

    public int getState(){return state;}
    public void setState(int state){this.state=state;}

    public String getPhotos(){return photos;}
    public void setPhotos(String photos){this.photos=photos;}

    public String getRoad_trail_number(){return road_trail_number;}
    public void setRoad_trail_number(String road_trail_number){this.road_trail_number=road_trail_number;}

    public int getRt_type(){return rt_type;}
    public void setRt_type(int rt_type){this.rt_type=rt_type;}

    public String getBegin_mile_marker(){return begin_mile_marker;}
    public void setBegin_mile_marker(String begin_mile_marker){this.begin_mile_marker=begin_mile_marker;}

    public String getEnd_mile_marker(){return end_mile_marker;}
    public void setEnd_mile_marker(String end_mile_marker){this.end_mile_marker=end_mile_marker;}

    public String getDatum(){return datum;}
    public void setDatum(String datum){this.datum=datum;}

    public String getCoordinate_latitude(){return coordinate_latitude;}
    public void setCoordinate_latitude(String coordinate_latitude){this.coordinate_latitude=coordinate_latitude;}

    public String getCoordinate_longitude(){return coordinate_longitude;}
    public void setCoordinate_longitude(String coordinate_longitude){this.coordinate_longitude=coordinate_longitude;}

    public int getCondition(){return condition;}
    public void setCondition(int condition){this.condition=condition;}

    public String getAffected_length(){return affected_length;}
    public void setAffected_length(String affected_length){this.affected_length=affected_length;}

    public int getSize_rock(){return size_rock;}
    public void setSize_rock(int size_rock){this.size_rock=size_rock;}

    public int getNum_fallen_rocks(){return num_fallen_rocks;}
    public void setNum_fallen_rocks(int num_fallen_rocks){this.num_fallen_rocks=num_fallen_rocks;}

    public int getVol_debris(){return vol_debris;}
    public void setVol_debris(int vol_debris){this.vol_debris=vol_debris;}

    public int getAbove_road(){return above_road;}
    public void setAbove_road(int above_road){this.above_road=above_road;}

    public int getBelow_road(){return below_road;}
    public void setBelow_road(int below_road){this.below_road=below_road;}

    public int getAt_culvert(){return at_culvert;}
    public void setAt_culvert(int at_culvert){this.at_culvert=at_culvert;}

    public int getAbove_river(){return above_river;}
    public void setAbove_river(int above_river){this.above_river=above_river;}

    public int getAbove_coast(){return above_coast;}
    public void setAbove_coast(int above_coast){this.above_coast=above_coast;}

    public int getBurned_area(){return burned_area;}
    public void setBurned_area(int burned_area){this.burned_area=burned_area;}

    public int getDeforested_slope(){return deforested_slope;}
    public void setDeforested_slope(int deforested_slope){this.deforested_slope=deforested_slope;}

    public int getUrban(){return urban;}
    public void setUrban(int urban){this.urban=urban;}

    public int getMine(){return mine;}
    public void setMine(int mine){this.mine=mine;}

    public int getRetaining_wall(){return retaining_wall;}
    public void setRetaining_wall(int retaining_wall){this.retaining_wall=retaining_wall;}

    public int getNatural_slope(){return natural_slope;}
    public void setNatural_slope(int natural_slope){this.natural_slope=natural_slope;}

    public int getEngineered_slope(){return engineered_slope;}
    public void setEngineered_slope(int engineered_slope){this.engineered_slope=engineered_slope;}

    public int getUnknown(){return unknown;}
    public void setUnknown(int unknown){this.unknown=unknown;}

    public int getOther(){return other;}
    public void setOther(int other){this.other=other;}

    public int getRain_checkbox(){return rain_checkbox;}
    public void setRain_checkbox(int rain_checkbox){this.rain_checkbox=rain_checkbox;}

    public int getThunder_checkbox(){return thunder_checkbox;}
    public void setThunder_checkbox(int thunder_checkbox){this.thunder_checkbox=thunder_checkbox;}

    public int getCont_rain_checkbox(){return cont_rain_checkbox;}
    public void setCont_rain_checkbox(int cont_rain_checkbox){this.cont_rain_checkbox=cont_rain_checkbox;}

    public int getHurricane_checkbox(){return hurricane_checkbox;}
    public void setHurricane_checkbox(int hurricane_checkbox){this.hurricane_checkbox=hurricane_checkbox;}

    public int getFlood_checkbox(){return flood_checkbox;}
    public void setFlood_checkbox(int flood_checkbox){this.flood_checkbox=flood_checkbox;}

    public int getSnowfall_checkbox(){return snowfall_checkbox;}
    public void setSnowfall_checkbox(int snowfall_checkbox){this.snowfall_checkbox=snowfall_checkbox;}

    public int getFreezing_checkbox(){return freezing_checkbox;}
    public void setFreezing_checkbox(int freezing_checkbox){this.freezing_checkbox=freezing_checkbox;}

    public int getHigh_temp_checkbox(){return high_temp_checkbox;}
    public void setHigh_temp_checkbox(int high_temp_checkbox){this.high_temp_checkbox=high_temp_checkbox;}

    public int getEarthquake_checkbox(){return earthquake_checkbox;}
    public void setEarthquake_checkbox(int earthquake_checkbox){this.earthquake_checkbox=earthquake_checkbox;}

    public int getVolcano_checkbox(){return volcano_checkbox;}
    public void setVolcano_checkbox(int volcano_checkbox){this.volcano_checkbox=volcano_checkbox;}

    public int getLeaky_pipe_checkbox(){return leaky_pipe_checkbox;}
    public void setLeaky_pipe_checkbox(int leaky_pipe_checkbox){this.leaky_pipe_checkbox=leaky_pipe_checkbox;}

    public int getMining_checkbox(){return mining_checkbox;}
    public void setMining_checkbox(int mining_checkbox){this.mining_checkbox=mining_checkbox;}

    public int getConstruction_checkbox(){return construction_checkbox;}
    public void setConstruction_checkbox(int construction_checkbox){this.construction_checkbox=construction_checkbox;}

    public int getDam_embankment_collapse_checkbox(){return dam_embankment_collapse_checkbox;}
    public void setDam_embankment_collapse_checkbox(int dam_embankment_collapse_checkbox){this.dam_embankment_collapse_checkbox=dam_embankment_collapse_checkbox;}

    public int getNot_obvious_checkbox(){return not_obvious_checkbox;}
    public void setNot_obvious_checkbox(int not_obvious_checkbox){this.not_obvious_checkbox=not_obvious_checkbox;}

    public int getUnknown_checkbox(){return unknown_checkbox;}
    public void setUnknown_checkbox(int unknown_checkbox){this.unknown_checkbox=unknown_checkbox;}

    public int getOther_checkbox(){return other_checkbox;}
    public void setOther_checkbox(int other_checkbox){this.other_checkbox=other_checkbox;}

    public int getDamages_y_n(){return damages_y_n;}
    public void setDamages_y_n(int damages_y_n){this.damages_y_n=damages_y_n;}

    public String getDamages(){return  damages;}
    public void setDamages(String damages){this.damages = damages;}



}
