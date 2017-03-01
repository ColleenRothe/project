package teammsu.colleenrothe.usmp;

/**
 * Created by colleenrothe on 2/28/17.
 */

public class OfflineSite extends Object {
    private int id;
    //private String mgmt_area;
    private int agency;
    private int regional;
    private int local;
    private String date;
    private String road_trail_number;
    private int road_or_Trail;
    private String road_trail_class;
    private String rater;
    private String begin_mile_marker;
    private String end_mile_marker;
    private int side;
    private int weather;
    private String hazard_type;
    private String begin_coordinate_lat;
    private String begin_coordinate_long;
    private String end_coordinate_latitude;
    private String end_coordinate_longitude;
    private String datum;
    private String aadt;
    private String length_affected;
    private String slope_height_axial_length;
    private String slope_angle;
    private String sight_distance;
    private String road_trail_width;
    private int speed_limit;
    private String minimum_ditch_width;
    private String maximum_ditch_width;
    private String minimum_ditch_depth;
    private String maximum_ditch_depth;
    private String first_begin_ditch_slope;
    private String first_end_ditch_slope;
    private String second_begin_ditch_slope;
    private String second_end_ditch_slope;
    private String blk_size;
    private String volume;
    private String start_annual_rainfall;
    private String end_annual_rainfall;
    private int sole_access_route;
    private int fixes_Present;
    private String photos;
    private String comments;
    private String flma_name;
    private String flma_id;
    private String flma_description;

    //Preliminary Rating
        //landslide only
    private int prelim_landslide_road_width_affected;
    private int prelim_landslide_slide_erosion_effects;
    private String prelim_landslide_length_affected;
        //Rockfall only
    private int prelim_rockfall_ditch_eff;
    private int prelim_rockfall_rockfall_history;
    private  String prelim_rockfall_block_size_event_vol;
        //for all
    private int impact_on_use;
    private int aadt_usage_calc_checkbox;
    private String aadt_usage;
    private String prelim_rating;

    //Hazard Rating
        //for all
    private int slope_drainage;
    private String hazard_rating_annual_rainfall;
    private String hazard_rating_slope_height_axial_length;
    private String hazard_rating_total;
        //landslide only
    private int hazard_landslide_thaw_stability;
    private int hazard_landslide_maint_frequency;
    private int hazard_landslide_movement_history;
        //rockfall only
    private int hazard_rockfall_maint_frequency;
    private int case_one_struc_cond;
    private int case_one_rock_friction;
    private int case_two_struc_cond;
    private int case_two_diff_erosion;

    //Risk Ratings
    private String route_trail_width;
    private String human_ex_factor;
    private String percent_dsd;
    private int r_w_impacts;
    private int enviro_cult_impacts;
    private int maint_complexity;
    private int event_cost;
    private String risk_total;

    private String total_score;

    public OfflineSite(){

    }


    public OfflineSite(int id, int agency, int regional, int local, String date, String road_trail_number, int road_or_trail,
                       String road_trail_class,String rater, String begin_mile_marker, String end_mile_marker,
                       int side, int weather, String hazard_type, String begin_coordinate_lat, String begin_coordinate_long,
                       String end_coordinate_latitude, String end_coordinate_longitude, String datum, String aadt, String
                               length_affected, String slope_height_axial_length, String slope_angle, String sight_distance,
                       String road_trail_width, int speed_limit, String minimum_ditch_width, String maximum_ditch_width,
                       String minimum_ditch_depth, String maximum_ditch_depth, String first_begin_ditch_slope, String
                               first_end_ditch_slope, String second_begin_ditch_slope, String second_end_ditch_slope,String blk_size,
                       String volume, String start_annual_rainfall, String end_annual_rainfall, int sole_access_route, int fixes_Present,
                       String photos, String comments, String flma_name, String flma_id, String flma_description, int prelim_landslide_road_width_affected,
                       int prelim_landslide_slide_erosion_effects, String prelim_landslide_length_affected, int prelim_rockfall_ditch_eff,
                       int prelim_rockfall_rockfall_history, String prelim_rockfall_block_size_event_vol, int impact_on_use,
                       int aadt_usage_calc_checkbox, String aadt_usage, String prelim_rating, int slope_drainage, String hazard_rating_annual_rainfall,
                       String hazard_rating_slope_height_axial_length, String hazard_rating_total,int hazard_rockfall_maint_frequency, int case_one_struc_cond,
                       int case_one_rock_friction, int case_two_struc_cond, int case_two_diff_erosion, int hazard_landslide_thaw_stability, int hazard_landslide_maint_frequency, int
                               hazard_landslide_movement_history,
                       String route_trail_width, String human_ex_factor, String percent_dsd, int r_w_impacts, int enviro_cult_impacts,
                       int maint_complexity, int event_cost, String risk_total, String total_score){
        this.id=id;
        this.agency = agency;
        this.regional = regional;
        this.local = local;
        this.date=date;
        this.road_trail_number=road_trail_number;
        this.road_or_Trail = road_or_trail;
        this.road_trail_class=road_trail_class;
        this.rater=rater;
        this.begin_mile_marker=begin_mile_marker;
        this.end_mile_marker=end_mile_marker;
        this.side = side;
        this.weather = weather;
        this.hazard_type=hazard_type;
        this.begin_coordinate_lat=begin_coordinate_lat;
        this.begin_coordinate_long=begin_coordinate_long;
        this.end_coordinate_latitude=end_coordinate_latitude;
        this.end_coordinate_longitude=end_coordinate_longitude;
        this.datum=datum;
        this.aadt=aadt;
        this.length_affected=length_affected;
        this.slope_height_axial_length=slope_height_axial_length;
        this.slope_angle=slope_angle;
        this.sight_distance=sight_distance;
        this.road_trail_width=road_trail_width;
        this.speed_limit=speed_limit;
        this.minimum_ditch_width=minimum_ditch_width;
        this.maximum_ditch_width=maximum_ditch_width;
        this.minimum_ditch_depth=minimum_ditch_depth;
        this.maximum_ditch_depth=maximum_ditch_depth;
        this.first_begin_ditch_slope=first_begin_ditch_slope;
        this.first_end_ditch_slope=first_end_ditch_slope;
        this.second_begin_ditch_slope=second_begin_ditch_slope;
        this.second_end_ditch_slope=second_end_ditch_slope;
        this.blk_size=blk_size;
        this.volume=volume;
        this.start_annual_rainfall=start_annual_rainfall;
        this.end_annual_rainfall=end_annual_rainfall;
        this.sole_access_route=sole_access_route;
        this.fixes_Present=fixes_Present;
        this.photos=photos;
        this.comments=comments;
        this.flma_name=flma_name;
        this.flma_id=flma_id;
        this.flma_description=flma_description;


        this.prelim_landslide_road_width_affected=prelim_landslide_road_width_affected;
        this.prelim_landslide_slide_erosion_effects=prelim_landslide_slide_erosion_effects;
        this.prelim_landslide_length_affected=prelim_landslide_length_affected;
        this.prelim_rockfall_ditch_eff=prelim_rockfall_ditch_eff;
        this.prelim_rockfall_rockfall_history=prelim_rockfall_rockfall_history;
        this.prelim_rockfall_block_size_event_vol=prelim_rockfall_block_size_event_vol;
        this.impact_on_use=impact_on_use;
        this.aadt_usage_calc_checkbox=aadt_usage_calc_checkbox;
        this.aadt_usage=aadt_usage;
        this.prelim_rating=prelim_rating;

        this.slope_drainage=slope_drainage;
        this.hazard_rating_annual_rainfall=hazard_rating_annual_rainfall;
        this.hazard_rating_slope_height_axial_length=hazard_rating_slope_height_axial_length;
        this.hazard_rating_total=hazard_rating_total;
        this.hazard_landslide_thaw_stability=hazard_landslide_thaw_stability;
        this.hazard_landslide_maint_frequency=hazard_landslide_maint_frequency;
        this.hazard_landslide_movement_history=hazard_landslide_movement_history;
        this.hazard_rockfall_maint_frequency=hazard_rockfall_maint_frequency;
        this.case_one_struc_cond=case_one_struc_cond;
        this.case_one_rock_friction=case_one_rock_friction;
        this.case_two_struc_cond=case_two_struc_cond;
        this.case_two_diff_erosion=case_two_diff_erosion;

        this.route_trail_width=route_trail_width;
        this.human_ex_factor=human_ex_factor;
        this.percent_dsd=percent_dsd;
        this.r_w_impacts=r_w_impacts;
        this.enviro_cult_impacts=enviro_cult_impacts;
        this.maint_complexity=maint_complexity;
        this.event_cost=event_cost;
        this.risk_total=risk_total;
        this.total_score=total_score;

    }

    public OfflineSite(int agency, int regional, int local, String date, String road_trail_number, int road_or_trail,
                       String road_trail_class,String rater, String begin_mile_marker, String end_mile_marker,
                       int side, int weather, String hazard_type, String begin_coordinate_lat, String begin_coordinate_long,
                       String end_coordinate_latitude, String end_coordinate_longitude, String datum, String aadt, String
                               length_affected, String slope_height_axial_length, String slope_angle, String sight_distance,
                       String road_trail_width, int speed_limit, String minimum_ditch_width, String maximum_ditch_width,
                       String minimum_ditch_depth, String maximum_ditch_depth, String first_begin_ditch_slope, String
                               first_end_ditch_slope, String second_begin_ditch_slope, String second_end_ditch_slope,String blk_size,
                       String volume, String start_annual_rainfall, String end_annual_rainfall, int sole_access_route, int fixes_Present,
                       String photos, String comments, String flma_name, String flma_id, String flma_description, int prelim_landslide_road_width_affected,
                       int prelim_landslide_slide_erosion_effects, String prelim_landslide_length_affected, int prelim_rockfall_ditch_eff,
                       int prelim_rockfall_rockfall_history, String prelim_rockfall_block_size_event_vol, int impact_on_use,
                       int aadt_usage_calc_checkbox, String aadt_usage, String prelim_rating, int slope_drainage, String hazard_rating_annual_rainfall,
                       String hazard_rating_slope_height_axial_length, String hazard_rating_total, int hazard_rockfall_maint_frequency, int case_one_struc_cond,
                       int case_one_rock_friction, int case_two_struc_cond, int case_two_diff_erosion, int hazard_landslide_thaw_stability, int hazard_landslide_maint_frequency, int
                               hazard_landslide_movement_history,
                       String route_trail_width, String human_ex_factor, String percent_dsd, int r_w_impacts, int enviro_cult_impacts,
                       int maint_complexity, int event_cost, String risk_total, String total_score){
        this.agency = agency;
        this.regional = regional;
        this.local = local;
        this.date=date;
        this.road_trail_number=road_trail_number;
        this.road_or_Trail = road_or_trail;
        this.road_trail_class=road_trail_class;
        this.rater=rater;
        this.begin_mile_marker=begin_mile_marker;
        this.end_mile_marker=end_mile_marker;
        this.side = side;
        this.weather = weather;
        this.hazard_type=hazard_type;
        this.begin_coordinate_lat=begin_coordinate_lat;
        this.begin_coordinate_long=begin_coordinate_long;
        this.end_coordinate_latitude=end_coordinate_latitude;
        this.end_coordinate_longitude=end_coordinate_longitude;
        this.datum=datum;
        this.aadt=aadt;
        this.length_affected=length_affected;
        this.slope_height_axial_length=slope_height_axial_length;
        this.slope_angle=slope_angle;
        this.sight_distance=sight_distance;
        this.road_trail_width=road_trail_width;
        this.speed_limit=speed_limit;
        this.minimum_ditch_width=minimum_ditch_width;
        this.maximum_ditch_width=maximum_ditch_width;
        this.minimum_ditch_depth=minimum_ditch_depth;
        this.maximum_ditch_depth=maximum_ditch_depth;
        this.first_begin_ditch_slope=first_begin_ditch_slope;
        this.first_end_ditch_slope=first_end_ditch_slope;
        this.second_begin_ditch_slope=second_begin_ditch_slope;
        this.second_end_ditch_slope=second_end_ditch_slope;
        this.blk_size=blk_size;
        this.volume=volume;
        this.start_annual_rainfall=start_annual_rainfall;
        this.end_annual_rainfall=end_annual_rainfall;
        this.sole_access_route=sole_access_route;
        this.fixes_Present=fixes_Present;
        this.photos=photos;
        this.comments=comments;
        this.flma_name=flma_name;
        this.flma_id=flma_id;
        this.flma_description=flma_description;


        this.prelim_landslide_road_width_affected=prelim_landslide_road_width_affected;
        this.prelim_landslide_slide_erosion_effects=prelim_landslide_slide_erosion_effects;
        this.prelim_landslide_length_affected=prelim_landslide_length_affected;
        this.prelim_rockfall_ditch_eff=prelim_rockfall_ditch_eff;
        this.prelim_rockfall_rockfall_history=prelim_rockfall_rockfall_history;
        this.prelim_rockfall_block_size_event_vol=prelim_rockfall_block_size_event_vol;
        this.impact_on_use=impact_on_use;
        this.aadt_usage_calc_checkbox=aadt_usage_calc_checkbox;
        this.aadt_usage=aadt_usage;
        this.prelim_rating=prelim_rating;

        this.slope_drainage=slope_drainage;
        this.hazard_rating_annual_rainfall=hazard_rating_annual_rainfall;
        this.hazard_rating_slope_height_axial_length=hazard_rating_slope_height_axial_length;
        this.hazard_rating_total=hazard_rating_total;
        this.hazard_landslide_thaw_stability=hazard_landslide_thaw_stability;
        this.hazard_landslide_maint_frequency=hazard_landslide_maint_frequency;
        this.hazard_landslide_movement_history=hazard_landslide_movement_history;
        this.hazard_rockfall_maint_frequency=hazard_rockfall_maint_frequency;
        this.case_one_struc_cond=case_one_struc_cond;
        this.case_one_rock_friction=case_one_rock_friction;
        this.case_two_struc_cond=case_two_struc_cond;
        this.case_two_diff_erosion=case_two_diff_erosion;

        this.route_trail_width=route_trail_width;
        this.human_ex_factor=human_ex_factor;
        this.percent_dsd=percent_dsd;
        this.r_w_impacts=r_w_impacts;
        this.enviro_cult_impacts=enviro_cult_impacts;
        this.maint_complexity=maint_complexity;
        this.event_cost=event_cost;
        this.risk_total=risk_total;
        this.total_score=total_score;

    }

    //public OfflineSite(int agency, int regional, int local, String date, String road_trail_no, int road_or_trail, String road_trail_class, String rater, String begin_mile, String end_mile, int side, int weather, String hazard_type, String begin_coordinate_lat, String begin_coordinate_long, String end_coordinate_lat, String end_coordinate_long, String datum, String aadt, String length_affected, String slope_ht_axial_length, String slope_angle, String sight_distance, String road_trail_width, int speed_limit, String minimum_ditch_width, String maximum_ditch_width, String minimum_ditch_depth, String maximum_ditch_depth, String minimum_ditch_slope_first, String maximum_ditch_slope_first, String minimum_ditch_slope_second, String maximum_ditch_slope_second, String blk_size, String volume, String begin_annual_rainfall, String end_annual_rainfall, int sole_access_route, int fixes_present, String photos, String comments, String flma_name, String flma_id, String flma_description, int landslide_prelim_road_width_affected, int landslide_prelim_slide_erosion_effects, String landslide_prelim_length_affected, int rockfall_prelim_ditch_eff, int rockfall_prelim_rockfall_history, String rockfall_prelim_block_size_event_vol, int preliminary_rating_impact_on_use, int preliminary_rating_aadt_usage_calc_checkbox, String preliminary_rating_aadt_usage, String preliminary_rating, int hazard_rating_slope_drainage, String hazard_rating_annual_rainfall, String hazard_rating_slope_height_axial_length, String hazard_total, int landslide_hazard_rating_thaw_stability, int landslide_hazard_rating_maint_frequency, int landslide_hazard_rating_movement_history, int rockfall_hazard_rating_maint_frequency, int rockfall_hazard_rating_case_one_struc_condition, int rockfall_hazard_rating_case_one_rock_friction, int rockfall_hazard_rating_case_two_struc_condition, int rockfall_hazard_rating_case_two_diff_erosion, String risk_rating_route_trail, String risk_rating_human_ex_factor, String risk_rating_percent_dsd, int risk_rating_r_w_impacts, int risk_rating_enviro_cult_impacts, int risk_rating_maint_complexity, int risk_rating_event_cost, String risk_total, String total_score) {
    //}

    public int getId(){return id;}
    public void setId(int id){this.id=id;}

    public int getAgency(){return agency;}
    public void setAgency(int agency){this.agency = agency;}

    public int getRegional(){return regional;}
    public void setRegional(int regional){this.regional=regional;}

    public int getLocal(){return local;}
    public void setLocal(int local){this.local=local;}

    public String getDate(){return date;}
    public void setDate(String date){this.date=date;}

    public String getRoad_trail_number(){return road_trail_number;}
    public void setRoad_trail_number(String road_trail_number){this.road_trail_number=road_trail_number;}

    public int getRoad_or_Trail(){return road_or_Trail;}
    public void setRoad_or_Trail(int road_or_trail){this.road_or_Trail=road_or_trail;}

    public String getRoad_trail_class(){return road_trail_class;}
    public void setRoad_trail_class(String road_trail_class){this.road_trail_class=road_trail_class;}

    public String getRater(){return rater;}
    public void setRater(String rater){this.rater=rater;}

    public String getBegin_mile_marker(){return begin_mile_marker;}
    public void setBegin_mile_marker(String begin_mile_marker){this.begin_mile_marker=begin_mile_marker;}

    public String getEnd_mile_marker(){return end_mile_marker;}
    public void setEnd_mile_marker(String end_mile_marker){this.end_mile_marker=end_mile_marker;}

    public int getSide(){return side;}
    public void setSide(int side){this.side=side;}

    public int getWeather(){return weather;}
    public void setWeather(int weather){this.weather=weather;}

    public String getHazard_type(){return hazard_type;}
    public void setHazard_type(String hazard_type){this.hazard_type=hazard_type;}

    public String getBegin_coordinate_lat(){return begin_coordinate_lat;}
    public void setBegin_coordinate_lat(String begin_coordinate_lat){this.begin_coordinate_lat=begin_coordinate_lat;}

    public String getBegin_coordinate_long(){return begin_coordinate_long;}
    public void setBegin_coordinate_long(String begin_coordinate_long){this.begin_coordinate_long=begin_coordinate_long;}

    public String getEnd_coordinate_latitude(){return end_coordinate_latitude;}
    public void setEnd_coordinate_latitude(String end_coordinate_latitude){this.end_coordinate_latitude=end_coordinate_latitude;}

    public String getEnd_coordinate_longitude(){return end_coordinate_longitude;}
    public void setEnd_coordinate_longitude(String end_coordinate_longitude){this.end_coordinate_longitude=end_coordinate_longitude;}

    public String getDatum(){return datum;}
    public void setDatum(String datum){this.datum=datum;}

    public String getAadt(){return aadt;}
    public void setAadt(String aadt){this.aadt=aadt;}

    public String getLength_affected(){return length_affected;}
    public void setLength_affected(String length_affected){this.length_affected=length_affected;}

    public String getSlope_height_axial_length(){return slope_height_axial_length;}
    public void setSlope_height_axial_length(String slope_height_axial_length){this.slope_height_axial_length=slope_height_axial_length;}

    public String getSlope_angle(){return slope_angle;}
    public void setSlope_angle(String slope_angle){this.slope_angle=slope_angle;}

    public String getSight_distance(){return sight_distance;}
    public void setSight_distance(String sight_distance){this.sight_distance=sight_distance;}

    public String getRoad_trail_width(){return road_trail_width;}
    public void setRoad_trail_width(String road_trail_width){this.road_trail_width=road_trail_width;}

    public int getSpeed_limit(){return speed_limit;}
    public void setSpeed_limit(int speed_limit){this.speed_limit=speed_limit;}

    public String getMinimum_ditch_width(){return minimum_ditch_width;}
    public void setMinimum_ditch_width(String minimum_ditch_width){this.minimum_ditch_width=minimum_ditch_width;}

    public String getMaximum_ditch_width(){return maximum_ditch_width;}
    public void setMaximum_ditch_width(String maximum_ditch_width){this.maximum_ditch_width=maximum_ditch_width;}

    public String getMinimum_ditch_depth(){return minimum_ditch_depth;}
    public void setMinimum_ditch_depth(String minimum_ditch_depth){this.minimum_ditch_depth=minimum_ditch_depth;}

    public String getMaximum_ditch_depth(){return maximum_ditch_depth;}
    public void setMaximum_ditch_depth(String maximum_ditch_depth){this.maximum_ditch_depth=maximum_ditch_depth;}

    public String getFirst_begin_ditch_slope(){return first_begin_ditch_slope;}
    public void setFirst_begin_ditch_slope(String first_begin_ditch_slope){this.first_begin_ditch_slope=first_begin_ditch_slope;}

    public String getFirst_end_ditch_slope(){return first_end_ditch_slope;}
    public void setFirst_end_ditch_slope(String first_end_ditch_slope){this.first_end_ditch_slope=first_end_ditch_slope;}

    public String getSecond_begin_ditch_slope(){return second_begin_ditch_slope;}
    public void setSecond_begin_ditch_slope(String second_begin_ditch_slope){this.second_begin_ditch_slope=second_begin_ditch_slope;}

    public String getSecond_end_ditch_slope(){return second_end_ditch_slope;}
    public void setSecond_end_ditch_slope(String second_end_ditch_slope){this.second_end_ditch_slope=second_end_ditch_slope;}

    public String getBlk_size(){return blk_size;}
    public void setBlk_size(String blk_size){this.blk_size=blk_size;}

    public String getVolume(){return volume;}
    public void setVolume(String volume){this.volume=volume;}

    public String getStart_annual_rainfall(){return start_annual_rainfall;}
    public void setStart_annual_rainfall(String start_annual_rainfall){this.start_annual_rainfall=start_annual_rainfall;}

    public String getEnd_annual_rainfall(){return end_annual_rainfall;}
    public void setEnd_annual_rainfall(String end_annual_rainfall){this.end_annual_rainfall=end_annual_rainfall;}

    public int getSole_access_route(){return sole_access_route;}
    public void setSole_access_route(int sole_access_route){this.sole_access_route=sole_access_route;}

    public int getFixes_Present(){return fixes_Present;}
    public void setFixes_Present(int fixes_Present){this.fixes_Present=fixes_Present;}

    public String getphotos(){return photos;}
    public void setPhotos(String photos){this.photos=photos;}

    public String getComments(){return comments;}
    public void setComments(String comments){this.comments=comments;}

    public String getFlma_name(){return flma_name;}
    public void setFlma_name(String flma_name){this.flma_name=flma_name;}

    public String getFlma_id(){return flma_id;}
    public void setFlma_id(String flma_id){this.flma_id=flma_id;}

    public String getFlma_description(){return flma_description;}
    public void setFlma_description(String flma_description){this.flma_description=flma_description;}

    //prelim rating
    //landslide only
    public int getPrelim_landslide_road_width_affected(){return prelim_landslide_road_width_affected;}
    public void setPrelim_landslide_road_width_affected(int prelim_landslide_road_width_affected){this.prelim_landslide_road_width_affected=prelim_landslide_road_width_affected;}

    public int getPrelim_landslide_slide_erosion_effects(){return prelim_landslide_slide_erosion_effects;}
    public void setPrelim_landslide_slide_erosion_effects(int prelim_landslide_slide_erosion_effects){this.prelim_landslide_slide_erosion_effects=prelim_landslide_slide_erosion_effects;}

    public String getPrelim_landslide_length_affected(){return prelim_landslide_length_affected;}
    public void setPrelim_landslide_length_affected(String prelim_landslide_length_affected){this.prelim_landslide_length_affected=prelim_landslide_length_affected;}
    //rockfall only

    public int getPrelim_rockfall_ditch_eff(){return prelim_rockfall_ditch_eff;}
    public void setPrelim_rockfall_ditch_eff(int prelim_rockfall_ditch_eff){this.prelim_rockfall_ditch_eff=prelim_rockfall_ditch_eff;}

    public int getPrelim_rockfall_rockfall_history(){return prelim_rockfall_rockfall_history;}
    public void setPrelim_rockfall_rockfall_history(int prelim_rockfall_rockfall_history){this.prelim_rockfall_rockfall_history=prelim_rockfall_rockfall_history;}

    public String getPrelim_rockfall_block_size_event_vol() {return prelim_rockfall_block_size_event_vol;}
    public void setPrelim_rockfall_block_size_event_vol(String prelim_rockfall_block_size_event_vol){this.prelim_rockfall_block_size_event_vol=prelim_rockfall_block_size_event_vol;}

    //all
    public int getImpact_on_use(){return impact_on_use;}
    public void setImpact_on_use(int impact_on_use){this.impact_on_use=impact_on_use;}

    public int getAadt_usage_calc_checkbox(){return aadt_usage_calc_checkbox;}
    public void setAadt_usage_calc_checkbox(int aadt_usage_calc_checkbox){this.aadt_usage_calc_checkbox=aadt_usage_calc_checkbox;}

    public String getAadt_usage(){return aadt_usage;}
    public void setAadt_usage(String aadt_usage){this.aadt_usage=aadt_usage;}

    public String getPrelim_rating(){return prelim_rating;}
    public void setPrelim_rating(String prelim_rating){this.prelim_rating=prelim_rating;}

    //Hazard Rating
    //all
    public int getSlope_drainage(){return slope_drainage;}
    public void setSlope_drainage(int slope_drainage){this.slope_drainage=slope_drainage;}

    public String getHazard_rating_annual_rainfall(){return hazard_rating_annual_rainfall;}
    public void setHazard_rating_annual_rainfall(String hazard_rating_annual_rainfall){this.hazard_rating_annual_rainfall=hazard_rating_annual_rainfall;}

    public String getHazard_rating_slope_height_axial_length(){return hazard_rating_slope_height_axial_length;}
    public void setHazard_rating_slope_height_axial_length(String hazard_rating_slope_height_axial_length){this.hazard_rating_slope_height_axial_length=hazard_rating_slope_height_axial_length;}

    public String getHazard_rating_total(){return hazard_rating_total;}
    public void setHazard_rating_total(String hazard_rating_total){this.hazard_rating_total=hazard_rating_total;}

    //landslide only
    public int getHazard_landslide_thaw_stability(){return hazard_landslide_thaw_stability;}
    public void setHazard_landslide_thaw_stability(int hazard_landslide_thaw_stability){this.hazard_landslide_thaw_stability=hazard_landslide_thaw_stability;}

    public int getHazard_landslide_maint_frequency(){return hazard_landslide_maint_frequency;}
    public void setHazard_landslide_maint_frequency(int hazard_landslide_maint_frequency){this.hazard_landslide_maint_frequency=hazard_landslide_maint_frequency;}

    public int getHazard_landslide_movement_history(){return hazard_landslide_movement_history;}
    public void setHazard_landslide_movement_history(int hazard_landslide_movement_history){this.hazard_landslide_movement_history=hazard_landslide_movement_history;}
    //Rockfall only
    public int getHazard_rockfall_maint_frequency(){return hazard_rockfall_maint_frequency;}
    public void setHazard_rockfall_maint_frequency(int hazard_rockfall_maint_frequency){this.hazard_rockfall_maint_frequency=hazard_rockfall_maint_frequency;}

    public int getCase_one_struc_cond(){return case_one_struc_cond;}
    public void setCase_one_struc_cond(int case_one_struc_cond){this.case_one_struc_cond=case_one_struc_cond;}

    public int getCase_one_rock_friction(){return case_one_rock_friction;}
    public void setCase_one_rock_friction(int case_one_rock_friction){this.case_one_rock_friction=case_one_rock_friction;}

    public int getCase_two_struc_cond(){return case_two_struc_cond;}
    public void setCase_two_struc_cond(int case_two_struc_cond){this.case_two_struc_cond=case_two_struc_cond;}

    public int getCase_two_diff_erosion(){return case_two_diff_erosion;}
    public void setCase_two_diff_erosion(int case_two_diff_erosion){this.case_two_diff_erosion=case_two_diff_erosion;}

    //Risk Rating
    public String getRoute_trail_width(){return route_trail_width;}
    public void setRoute_trail_width(String route_trail_width){this.route_trail_width=route_trail_width;}

    public String getHuman_ex_factor(){return human_ex_factor;}
    public void setHuman_ex_factor(String human_ex_factor){this.human_ex_factor=human_ex_factor;}

    public String getPercent_dsd(){return percent_dsd;}
    public void setPercent_dsd(String percent_dsd){this.percent_dsd=percent_dsd;}

    public int getR_w_impacts(){return r_w_impacts;}
    public void setR_w_impacts(int r_w_impacts){this.r_w_impacts=r_w_impacts;}

    public int getEnviro_cult_impacts(){return enviro_cult_impacts;}
    public void setEnviro_cult_impacts(int enviro_cult_impacts){this.enviro_cult_impacts=enviro_cult_impacts;}

    public int getMaint_complexity(){return maint_complexity;}
    public void setMaint_complexity(int maint_complexity){this.maint_complexity=maint_complexity;}

    public int getEvent_cost(){return event_cost;}
    public void setEvent_cost(int event_cost){this.event_cost=event_cost;}

    public String getRisk_total(){return risk_total;}
    public void setRisk_total(String risk_total){this.risk_total=risk_total;}

    public String getTotal_score(){return total_score;}
    public void setTotal_score(String total_score){this.total_score=total_score;}




}
