package teammsu.colleenrothe.usmp;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Class that implements a DB to save full offline landslide or rockfall site from map
 * Combo of the landslide and rockfall DB handlers
 * CREDITS:
 *      (1)Idea/Code from: http://www.techotopia.com/index.php/An_Android_SQLite_Database_Tutorial
 */

public class OfflineSiteDBHandler extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "offlineSiteDB.db";
    public static final String TABLE_OFFLINE_SITE = "offlineSite";

    //column names
    public static final String COLUMN_ID = "_id";
    public static final String COLUMN_UMBRELLA_AGENCY = "umbrella_agency";
    public static final String COLUMN_REGIONAL_ADMIN = "regional_admin";
    public static final String COLUMN_LOCAL_ADMIN = "local_admin";
    public static final String COLUMN_DATE = "date";
    public static final String COLUMN_ROAD_TRAIL_NUMBER = "road_trail_number";
    public static final String COLUMN_ROAD_OR_TRAIL = "road_or_trail";
    public static final String COLUMN_ROAD_TRAIL_CLASS = "road_trail_class";
    public static final String COLUMN_RATER = "rater";
    public static final String COLUMN_BEGIN_MILE_MARKER = "begin_mile_marker";
    public static final String COLUMN_END_MILE_MARKER = "end_mile_marker";
    public static final String COLUMN_SIDE = "side";
    public static final String COLUMN_WEATHER = "weather";
    public static final String COLUMN_HAZARD_TYPE = "hazard_type";
    public static final String COLUMN_BEGIN_COORDINATE_LAT = "begin_coordinate_lat";
    public static final String COLUMN_BEGIN_COORDINATE_LONG = "begin_coordinate_long";
    public static final String COLUMN_END_COORDINATE_LATITUDE = "end_coordinate_latitude";
    public static final String COLUMN_END_COORDINATE_LONGITUDE = "end_coordinate_longitude";
    public static final String COLUMN_DATUM = "datum";
    public static final String COLUMN_AADT = "aadt";
    public static final String COLUMN_LENGTH_AFFECTED = "length_affected";
    public static final String COLUMN_SLOPE_HEIGHT_AXIAL_LENGTH = "slope_height_axial_length";
    public static final String COLUMN_SLOPE_ANGLE = "slope_angle";
    public static final String COLUMN_SIGHT_DISTANCE = "sight_distance";
    public static final String COLUMN_ROAD_TRAIL_WIDTH = "road_trail_width";
    public static final String COLUMN_SPEED_LIMIT = "speed_limit";
    public static final String COLUMN_MINIMUM_DITCH_WIDTH = "minimum_ditch_width";
    public static final String COLUMN_MAXIMUM_DITCH_WIDTH = "maximum_ditch_width";
    public static final String COLUMN_MINIMUM_DITCH_DEPTH = "minimum_ditch_depth";
    public static final String COLUMN_MAXIMUM_DITCH_DEPTH = "maximum_ditch_depth";
    public static final String COLUMN_FIRST_BEGIN_DITCH_SLOPE = "first_begin_ditch_slope";
    public static final String COLUMN_FIRST_END_DITCH_SLOPE = "first_end_ditch_slope";
    public static final String COLUMN_SECOND_BEGIN_DITCH_SLOPE = "second_begin_ditch_slope";
    public static final String COLUMN_SECOND_END_DITCH_SLOPE = "second_end_ditch_slope";
    public static final String COLUMN_BLK_SIZE = "blk_size";
    public static final String COLUMN_VOLUME = "volume";
    public static final String COLUMN_START_ANNUAL_RAINFALL = "start_annual_rainfall";
    public static final String COLUMN_END_ANNUAL_RAINFALL = "end_annual_rainfall";
    public static final String COLUMN_SOLE_ACCESS_ROUTE = "sole_access_route";
    public static final String COLUMN_FIXES_PRESENT = "fixes_present";
    public static final String COLUMN_PHOTOS = "photos";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String COLUMN_FLMA_NAME = "flma_name";
    public static final String COLUMN_FLMA_ID = "flma_id";
    public static final String COLUMN_FLMA_DESCRIPTION = "flma_description";

    //Preliminary Rating
    //landslide only
    public static final String COLUMN_PRELIM_LANDSLIDE_ROAD_WIDTH_AFFECTED = "prelim_landslide_road_width_affected";
    public static final String COLUMN_PRELIM_LANDSLIDE_SLIDE_EROSION_EFFECTS ="prelim_landslide_slide_erosion_effects";
    public static final String COLUMN_PRELIM_LANDSLIDE_LENGTH_AFFECTED = "prelim_landslide_length_affected";
    //Rockfall only
    public static final String COLUMN_PRELIM_ROCKFALL_DITCH_EFF = "prelim_rockfall_ditch_eff";
    public static final String COLUMN_PRELIM_ROCKFALL_ROCKFALL_HISTORY = "prelim_rockfall_rockfall_history";
    public static final String COLUMN_PRELIM_ROCKFALL_BLOCK_SIZE_EVENT_VOL = "prelim_rockfall_block_size_event_vol";
    //for all
    public static final String COLUMN_IMPACT_ON_USE = "impact_on_use";
    public static final String COLUMN_AADT_USAGE_CALC_CHECKBOX = "aadt_usage_calc_checkbox";
    public static final String COLUMN_AADT_USAGE = "aadt_usage";
    public static final String COLUMN_PRELIM_RATING = "prelim_rating";
    //Hazard Rating
    //for all
    public static final String COLUMN_SLOPE_DRAINAGE = "slope_drainage";
    public static final String COLUMN_HAZARD_RATING_ANNUAL_RAINFALL = "hazard_rating_annual_rainfall";
    public static final String COLUMN_HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH = "hazard_rating_slope_height_axial_length";
    public static final String COLUMN_HAZARD_RATING_TOTAL = "hazard_rating_total";
    //Landslide only
    public static final String COLUMN_HAZARD_LANDSLIDE_THAW_STABILITY = "hazard_landslide_thaw_stability";
    public static final String COLUMN_HAZARD_LANDSLIDE_MAINT_FREQUENCY = "hazard_landslide_maint_frequency";
    public static final String COLUMN_HAZARD_LANDSLIDE_MOVEMENT_HISTORY = "hazard_landslide_movement_history";
    //rockfall only
    public static final String COLUMN_HAZARD_ROCKFALL_MAINT_FREQUENCY = "hazard_rockfall_maint_frequency";
    public static final String COLUMN_CASE_ONE_STRUC_COND = "case_one_struc_cond";
    public static final String COLUMN_CASE_ONE_ROCK_FRICTION = "case_one_rock_friction";
    public static final String COLUMN_CASE_TWO_STRUC_COND = "case_two_struc_cond";
    public static final String COLUMN_CASE_TWO_DIFF_EROSION = "case_two_diff_erosion";
    //Risk Rating
    public static final String COLUMN_ROUTE_TRAIL_WIDTH = "route_trail_width";
    public static final String COLUMN_HUMAN_EX_FACTOR = "human_ex_factor";
    public static final String COLUMN_PERCENT_DSD = "percent_dsd";
    public static final String COLUMN_R_W_IMPACTS = "r_w_impacts";
    public static final String COLUMN_ENVIRO_CULT_IMPACTS = "enviro_cult_impacts";
    public static final String COLUMN_MAINT_COMPLEXITY = "maint_complexity";
    public static final String COLUMN_EVENT_COST = "event_cost";
    public static final String COLUMN_RISK_TOTAL = "risk_total";

    public static final String COLUMN_TOTAL_SCORE = "total_score";

    public static final String COLUMN_SITE_ID = "site_id";
    public static final String COLUMN_PRELIM_RATING_LANDSLIDE_ID = "prelim_rating_landslide_id";




    public OfflineSiteDBHandler(Context context, String name,
                             SQLiteDatabase.CursorFactory factory, int version) {
        super(context, DATABASE_NAME, factory, DATABASE_VERSION);
    }

    //create offline table in the database
    @Override
    public void onCreate(SQLiteDatabase db) {
        // TODO Auto-generated method stub
        String CREATE_OFFLINE_SITE_TABLE = "CREATE TABLE " +
                TABLE_OFFLINE_SITE + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_UMBRELLA_AGENCY + " TEXT," + COLUMN_REGIONAL_ADMIN + " TEXT,"+COLUMN_LOCAL_ADMIN + " TEXT,"+COLUMN_DATE +
                " TEXT," + COLUMN_ROAD_TRAIL_NUMBER + " TEXT," + COLUMN_ROAD_OR_TRAIL + " INTEGER," + COLUMN_ROAD_TRAIL_CLASS +
                " TEXT," + COLUMN_RATER + " TEXT," + COLUMN_BEGIN_MILE_MARKER + " TEXT," + COLUMN_END_MILE_MARKER + " TEXT," +
                COLUMN_SIDE + " INTEGER," + COLUMN_WEATHER + " INTEGER," + COLUMN_HAZARD_TYPE + " TEXT," + COLUMN_BEGIN_COORDINATE_LAT +
                " TEXT," + COLUMN_BEGIN_COORDINATE_LONG + " TEXT," + COLUMN_END_COORDINATE_LATITUDE + " TEXT," + COLUMN_END_COORDINATE_LONGITUDE +
                " TEXT," + COLUMN_DATUM + " TEXT," + COLUMN_AADT + " TEXT," + COLUMN_LENGTH_AFFECTED + " TEXT," + COLUMN_SLOPE_HEIGHT_AXIAL_LENGTH
                + " TEXT," + COLUMN_SLOPE_ANGLE + " TEXT," + COLUMN_SIGHT_DISTANCE + " TEXT," + COLUMN_ROAD_TRAIL_WIDTH + " TEXT," + COLUMN_SPEED_LIMIT +
                " INTEGER," + COLUMN_MINIMUM_DITCH_WIDTH + " TEXT," + COLUMN_MAXIMUM_DITCH_WIDTH + " TEXT," + COLUMN_MINIMUM_DITCH_DEPTH + " TEXT," +
                COLUMN_MAXIMUM_DITCH_DEPTH + " TEXT," + COLUMN_FIRST_BEGIN_DITCH_SLOPE + " TEXT," + COLUMN_FIRST_END_DITCH_SLOPE + " TEXT," +
                COLUMN_SECOND_BEGIN_DITCH_SLOPE + " TEXT," + COLUMN_SECOND_END_DITCH_SLOPE + " TEXT," + COLUMN_BLK_SIZE + " TEXT," + COLUMN_VOLUME + " TEXT,"
                + COLUMN_START_ANNUAL_RAINFALL + " TEXT," + COLUMN_END_ANNUAL_RAINFALL + " TEXT," + COLUMN_SOLE_ACCESS_ROUTE + " INTEGER," + COLUMN_FIXES_PRESENT +
                " INTEGER," + COLUMN_PHOTOS + " TEXT," + COLUMN_COMMENTS + " TEXT," + COLUMN_FLMA_NAME + " TEXT," + COLUMN_FLMA_ID + " TEXT," +
                COLUMN_FLMA_DESCRIPTION + " TEXT," + COLUMN_PRELIM_LANDSLIDE_ROAD_WIDTH_AFFECTED+" INTEGER,"+COLUMN_PRELIM_LANDSLIDE_SLIDE_EROSION_EFFECTS+" INTEGER,"+
                COLUMN_PRELIM_LANDSLIDE_LENGTH_AFFECTED+" TEXT,"+ COLUMN_PRELIM_ROCKFALL_DITCH_EFF + " INTEGER," + COLUMN_PRELIM_ROCKFALL_ROCKFALL_HISTORY + " INTEGER," +
                COLUMN_PRELIM_ROCKFALL_BLOCK_SIZE_EVENT_VOL + " TEXT," + COLUMN_IMPACT_ON_USE + " INTEGER," + COLUMN_AADT_USAGE_CALC_CHECKBOX + " INTEGER," +
                COLUMN_AADT_USAGE + " TEXT," + COLUMN_PRELIM_RATING + " TEXT," + COLUMN_SLOPE_DRAINAGE + " INTEGER," + COLUMN_HAZARD_RATING_ANNUAL_RAINFALL
                + " TEXT," + COLUMN_HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH + " TEXT," + COLUMN_HAZARD_RATING_TOTAL + " TEXT," + COLUMN_HAZARD_LANDSLIDE_THAW_STABILITY
                +" INTEGER,"+COLUMN_HAZARD_LANDSLIDE_MAINT_FREQUENCY+" INTEGER,"+COLUMN_HAZARD_LANDSLIDE_MOVEMENT_HISTORY+" INTEGER,"+ COLUMN_HAZARD_ROCKFALL_MAINT_FREQUENCY +
                " INTEGER," + COLUMN_CASE_ONE_STRUC_COND + " INTEGER," + COLUMN_CASE_ONE_ROCK_FRICTION + " INTEGER," + COLUMN_CASE_TWO_STRUC_COND + " INTEGER," +
                COLUMN_CASE_TWO_DIFF_EROSION + " INTEGER," + COLUMN_ROUTE_TRAIL_WIDTH + " TEXT," + COLUMN_HUMAN_EX_FACTOR + " TEXT," + COLUMN_PERCENT_DSD + " TEXT," + COLUMN_R_W_IMPACTS + " INTEGER," +
                COLUMN_ENVIRO_CULT_IMPACTS + " INTEGER," + COLUMN_MAINT_COMPLEXITY + " INTEGER," + COLUMN_EVENT_COST + " INTEGER," + COLUMN_RISK_TOTAL
                + " TEXT," + COLUMN_TOTAL_SCORE + " TEXT," + COLUMN_SITE_ID + " TEXT," + COLUMN_PRELIM_RATING_LANDSLIDE_ID+" TEXT"+")";

        db.execSQL(CREATE_OFFLINE_SITE_TABLE);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // TODO Auto-generated method stub
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_OFFLINE_SITE);
        onCreate(db);

    }

    //add a new offline site
    public void addOfflineSite(OfflineSite form){
        ContentValues values = new ContentValues();

        //make sure that the id# is unique, make it bigger than any of the others in the db
        int maxID = 1;
        if(getNumRows()>0) {
            String query = "Select "+ COLUMN_ID + " FROM " + TABLE_OFFLINE_SITE;
            SQLiteDatabase db = this.getWritableDatabase();
            Cursor cursor = db.rawQuery(query, null);

            if (cursor.moveToFirst()) {
                cursor.moveToFirst();
                for (int i = 0; i < getNumRows(); i++) {
                    if (Integer.parseInt(cursor.getString(i))>maxID){
                        maxID = Integer.parseInt(cursor.getString(i));
                    }
                }

                cursor.close();
            }

            db.close();
            maxID++;
        }


        values.put(COLUMN_ID, String.valueOf(maxID));
        //get the rest of the values from the offline form

        values.put(COLUMN_UMBRELLA_AGENCY, form.getAgency());
        values.put(COLUMN_REGIONAL_ADMIN, form.getRegional());
        values.put(COLUMN_LOCAL_ADMIN, form.getLocal());

        values.put(COLUMN_DATE, form.getDate());
        values.put(COLUMN_ROAD_TRAIL_NUMBER, form.getRoad_trail_number());
        values.put(COLUMN_ROAD_OR_TRAIL, form.getRoad_or_Trail());
        values.put(COLUMN_ROAD_TRAIL_CLASS, form.getRoad_trail_class());
        values.put(COLUMN_RATER, form.getRater());
        values.put(COLUMN_BEGIN_MILE_MARKER, form.getBegin_mile_marker());
        values.put(COLUMN_END_MILE_MARKER, form.getEnd_mile_marker());
        values.put(COLUMN_SIDE, form.getSide());
        values.put(COLUMN_WEATHER, form.getWeather());
        values.put(COLUMN_HAZARD_TYPE, form.getHazard_type());
        values.put(COLUMN_BEGIN_COORDINATE_LAT, form.getBegin_coordinate_lat());
        values.put(COLUMN_BEGIN_COORDINATE_LONG, form.getBegin_coordinate_long());
        values.put(COLUMN_END_COORDINATE_LATITUDE, form.getEnd_coordinate_latitude());
        values.put(COLUMN_END_COORDINATE_LONGITUDE, form.getEnd_coordinate_longitude());
        values.put(COLUMN_DATUM, form.getDatum());
        values.put(COLUMN_AADT, form.getAadt());
        values.put(COLUMN_LENGTH_AFFECTED, form.getLength_affected());
        values.put(COLUMN_SLOPE_HEIGHT_AXIAL_LENGTH, form.getSlope_height_axial_length());
        values.put(COLUMN_SLOPE_ANGLE, form.getSlope_angle());
        values.put(COLUMN_SIGHT_DISTANCE, form.getSight_distance());
        values.put(COLUMN_ROAD_TRAIL_WIDTH, form.getRoad_trail_width());
        values.put(COLUMN_SPEED_LIMIT, form.getSpeed_limit());
        values.put(COLUMN_MINIMUM_DITCH_WIDTH, form.getMinimum_ditch_width());
        values.put(COLUMN_MAXIMUM_DITCH_WIDTH, form.getMaximum_ditch_width());
        values.put(COLUMN_MINIMUM_DITCH_DEPTH, form.getMinimum_ditch_depth());
        values.put(COLUMN_MAXIMUM_DITCH_DEPTH, form.getMaximum_ditch_depth());
        values.put(COLUMN_FIRST_BEGIN_DITCH_SLOPE, form.getFirst_begin_ditch_slope());
        values.put(COLUMN_FIRST_END_DITCH_SLOPE, form.getFirst_end_ditch_slope());
        values.put(COLUMN_SECOND_BEGIN_DITCH_SLOPE, form.getSecond_begin_ditch_slope());
        values.put(COLUMN_SECOND_END_DITCH_SLOPE, form.getSecond_end_ditch_slope());
        values.put(COLUMN_BLK_SIZE, form.getBlk_size());
        values.put(COLUMN_VOLUME, form.getVolume());
        values.put(COLUMN_START_ANNUAL_RAINFALL, form.getStart_annual_rainfall());
        values.put(COLUMN_END_ANNUAL_RAINFALL, form.getEnd_annual_rainfall());
        values.put(COLUMN_SOLE_ACCESS_ROUTE, form.getSole_access_route());
        values.put(COLUMN_FIXES_PRESENT, form.getFixes_Present());
        values.put(COLUMN_PHOTOS, form.getphotos());
        values.put(COLUMN_COMMENTS, form.getComments());
        values.put(COLUMN_FLMA_NAME, form.getFlma_name());
        values.put(COLUMN_FLMA_ID, form.getFlma_id());
        values.put(COLUMN_FLMA_DESCRIPTION, form.getFlma_description());

        //preliminary rating
        //landslide only
        values.put(COLUMN_PRELIM_LANDSLIDE_ROAD_WIDTH_AFFECTED, form.getPrelim_landslide_road_width_affected());
        values.put(COLUMN_PRELIM_LANDSLIDE_SLIDE_EROSION_EFFECTS, form.getPrelim_landslide_slide_erosion_effects());
        values.put(COLUMN_PRELIM_LANDSLIDE_LENGTH_AFFECTED, form.getPrelim_landslide_length_affected());
        //Rockfall only
        values.put(COLUMN_PRELIM_ROCKFALL_DITCH_EFF, form.getPrelim_rockfall_ditch_eff());
        values.put(COLUMN_PRELIM_ROCKFALL_ROCKFALL_HISTORY, form.getPrelim_rockfall_rockfall_history());
        values.put(COLUMN_PRELIM_ROCKFALL_BLOCK_SIZE_EVENT_VOL, form.getPrelim_rockfall_block_size_event_vol());
        //for all
        values.put(COLUMN_IMPACT_ON_USE, form.getImpact_on_use());
        values.put(COLUMN_AADT_USAGE_CALC_CHECKBOX, form.getAadt_usage_calc_checkbox());
        values.put(COLUMN_AADT_USAGE, form.getAadt_usage());
        values.put(COLUMN_PRELIM_RATING, form.getPrelim_rating());

        //hazard rating
        //for all
        values.put(COLUMN_SLOPE_DRAINAGE, form.getSlope_drainage());
        values.put(COLUMN_HAZARD_RATING_ANNUAL_RAINFALL, form.getHazard_rating_annual_rainfall());
        values.put(COLUMN_HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH, form.getHazard_rating_slope_height_axial_length());
        values.put(COLUMN_HAZARD_RATING_TOTAL, form.getHazard_rating_total());
        //landslide only
        values.put(COLUMN_HAZARD_LANDSLIDE_THAW_STABILITY, form.getHazard_landslide_thaw_stability());
        values.put(COLUMN_HAZARD_LANDSLIDE_MAINT_FREQUENCY, form.getHazard_landslide_maint_frequency());
        values.put(COLUMN_HAZARD_LANDSLIDE_MOVEMENT_HISTORY, form.getHazard_landslide_movement_history());
        //rockfall only
        values.put(COLUMN_HAZARD_ROCKFALL_MAINT_FREQUENCY, form.getHazard_rockfall_maint_frequency());
        values.put(COLUMN_CASE_ONE_STRUC_COND, form.getCase_one_struc_cond());
        values.put(COLUMN_CASE_ONE_ROCK_FRICTION, form.getCase_one_rock_friction());
        values.put(COLUMN_CASE_TWO_STRUC_COND, form.getCase_two_struc_cond());
        values.put(COLUMN_CASE_TWO_DIFF_EROSION, form.getCase_two_diff_erosion());

        //Risk Ratings
        values.put(COLUMN_ROUTE_TRAIL_WIDTH, form.getRoute_trail_width());
        values.put(COLUMN_HUMAN_EX_FACTOR, form.getHuman_ex_factor());
        values.put(COLUMN_PERCENT_DSD, form.getPercent_dsd());
        values.put(COLUMN_R_W_IMPACTS, form.getR_w_impacts());
        values.put(COLUMN_ENVIRO_CULT_IMPACTS, form.getEnviro_cult_impacts());
        values.put(COLUMN_MAINT_COMPLEXITY, form.getMaint_complexity());
        values.put(COLUMN_EVENT_COST, form.getEvent_cost());
        values.put(COLUMN_RISK_TOTAL, form.getRisk_total());

        values.put(COLUMN_TOTAL_SCORE, form.getTotal_score());

        values.put(COLUMN_SITE_ID, form.getSite_id());
        values.put(COLUMN_PRELIM_RATING_LANDSLIDE_ID, form.getPrelim_rating_landslide_id());



        SQLiteDatabase db = this.getWritableDatabase();

        db.insert(TABLE_OFFLINE_SITE, null, values);
        db.close();
    }

    //find the offline form in the database that you want, search by unique id #
    public OfflineSite findOfflineSite(int id){
        String query = "Select * FROM " + TABLE_OFFLINE_SITE + " WHERE " + COLUMN_ID + " =  \"" + id + "\"";

        SQLiteDatabase db = this.getWritableDatabase();

        Cursor cursor = db.rawQuery(query, null);

        OfflineSite offlineSite = new OfflineSite();

        if (cursor.moveToFirst()) {
            cursor.moveToFirst();
            offlineSite.setId(Integer.parseInt(cursor.getString(0)));

            offlineSite.setAgency(Integer.parseInt(cursor.getString(1)));
            offlineSite.setRegional(Integer.parseInt(cursor.getString(2)));
            offlineSite.setLocal(Integer.parseInt(cursor.getString(3)));

            //here!
            offlineSite.setDate(cursor.getString(4));
            offlineSite.setRoad_trail_number(cursor.getString(5));
            offlineSite.setRoad_or_Trail(Integer.parseInt(cursor.getString(6)));
            offlineSite.setRoad_trail_class(cursor.getString(7));
            offlineSite.setRater(cursor.getString(8));
            offlineSite.setBegin_mile_marker(cursor.getString(9));
            offlineSite.setEnd_mile_marker(cursor.getString(10));
            offlineSite.setSide(Integer.parseInt(cursor.getString(11)));
            offlineSite.setWeather(Integer.parseInt(cursor.getString(12)));
            offlineSite.setHazard_type(cursor.getString(13));
            offlineSite.setBegin_coordinate_lat(cursor.getString(14));
            offlineSite.setBegin_coordinate_long(cursor.getString(15));
            offlineSite.setEnd_coordinate_latitude(cursor.getString(16));
            offlineSite.setEnd_coordinate_longitude(cursor.getString(17));
            offlineSite.setDatum(cursor.getString(18));
            offlineSite.setAadt(cursor.getString(19));
            offlineSite.setLength_affected(cursor.getString(20));
            offlineSite.setSlope_height_axial_length(cursor.getString(21));
            offlineSite.setSlope_angle(cursor.getString(22));
            offlineSite.setSight_distance(cursor.getString(23));
            offlineSite.setRoad_trail_width(cursor.getString(24));
            offlineSite.setSpeed_limit(Integer.parseInt(cursor.getString(25)));
            offlineSite.setMinimum_ditch_width(cursor.getString(26));
            offlineSite.setMaximum_ditch_width(cursor.getString(27));
            offlineSite.setMinimum_ditch_depth(cursor.getString(28));
            offlineSite.setMaximum_ditch_depth(cursor.getString(29));
            offlineSite.setFirst_begin_ditch_slope(cursor.getString(30));
            offlineSite.setFirst_end_ditch_slope(cursor.getString(31));
            offlineSite.setSecond_begin_ditch_slope(cursor.getString(32));
            offlineSite.setSecond_end_ditch_slope(cursor.getString(33));
            offlineSite.setBlk_size(cursor.getString(34));
            offlineSite.setVolume(cursor.getString(35));
            //LANDSLIDE NUMBERS DIFFER STARTING HERE...
            offlineSite.setStart_annual_rainfall(cursor.getString(36));
            offlineSite.setEnd_annual_rainfall(cursor.getString(37));
            offlineSite.setSole_access_route(Integer.parseInt(cursor.getString(38)));
            offlineSite.setFixes_Present(Integer.parseInt(cursor.getString(39)));
            offlineSite.setPhotos(cursor.getString(40));
            offlineSite.setComments(cursor.getString(41));
            offlineSite.setFlma_name(cursor.getString(42));
            offlineSite.setFlma_id(cursor.getString(43));
            offlineSite.setFlma_description(cursor.getString(44));

            //offline numbers ok to here.....

            //preliminary rating
            //landslide only
            offlineSite.setPrelim_landslide_road_width_affected(Integer.parseInt(cursor.getString(45)));
            offlineSite.setPrelim_landslide_slide_erosion_effects(Integer.parseInt(cursor.getString(46)));
            offlineSite.setPrelim_landslide_length_affected(cursor.getString(47));
            //rockfall only
            offlineSite.setPrelim_rockfall_ditch_eff(Integer.parseInt(cursor.getString(48)));
            offlineSite.setPrelim_rockfall_rockfall_history(Integer.parseInt(cursor.getString(49)));
            offlineSite.setPrelim_rockfall_block_size_event_vol(cursor.getString(50));
            //for all
            offlineSite.setImpact_on_use(Integer.parseInt(cursor.getString(51)));
            offlineSite.setAadt_usage_calc_checkbox(Integer.parseInt(cursor.getString(52)));
            offlineSite.setAadt_usage(cursor.getString(53));
            offlineSite.setPrelim_rating(cursor.getString(54));
            //Hazard Rating
            //for all
            offlineSite.setSlope_drainage(Integer.parseInt(cursor.getString(55)));
            offlineSite.setHazard_rating_annual_rainfall(cursor.getString(56));
            offlineSite.setHazard_rating_slope_height_axial_length(cursor.getString(57));
            offlineSite.setHazard_rating_total(cursor.getString(58));
            //landslide only
            offlineSite.setHazard_landslide_thaw_stability(Integer.parseInt(cursor.getString(59)));
            offlineSite.setHazard_landslide_maint_frequency(Integer.parseInt(cursor.getString(60)));
            offlineSite.setHazard_landslide_movement_history(Integer.parseInt(cursor.getString(61)));
            //rockfall only
            offlineSite.setHazard_rockfall_maint_frequency(Integer.parseInt(cursor.getString(62)));
            offlineSite.setCase_one_struc_cond(Integer.parseInt(cursor.getString(63)));
            offlineSite.setCase_one_rock_friction(Integer.parseInt(cursor.getString(64)));
            offlineSite.setCase_two_struc_cond(Integer.parseInt(cursor.getString(65)));
            offlineSite.setCase_two_diff_erosion(Integer.parseInt(cursor.getString(66)));
            //Risk Ratings
            offlineSite.setRoute_trail_width(cursor.getString(67));
            offlineSite.setHuman_ex_factor(cursor.getString(68));
            offlineSite.setPercent_dsd(cursor.getString(69));
            offlineSite.setR_w_impacts(Integer.parseInt(cursor.getString(70)));
            offlineSite.setEnviro_cult_impacts(Integer.parseInt(cursor.getString(71)));
            offlineSite.setMaint_complexity(Integer.parseInt(cursor.getString(72)));
            offlineSite.setEvent_cost(Integer.parseInt(cursor.getString(73)));
            offlineSite.setRisk_total(cursor.getString(74));

            offlineSite.setTotal_score(cursor.getString(75));
            offlineSite.setSite_id(cursor.getString(76));
            offlineSite.setPrelim_rating_landslide_id(cursor.getString(77));



            cursor.close();
        } else {
            offlineSite = null;
        }
        db.close();
        return offlineSite;
    }



    //delete a offline form in db, found by unique id #
    public void deleteOfflineSite(int id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_OFFLINE_SITE, COLUMN_ID + "=" + id, null);
    }

    //get the number of rows in the offline table
    public int getNumRows(){
        SQLiteDatabase db = this.getReadableDatabase();
        long row = DatabaseUtils.queryNumEntries(db, TABLE_OFFLINE_SITE);
        int rows = (int)row;
        System.out.println("rows"+rows);
        return rows;

    }

    //get an array of the unique ids in the landslide table
    public int [] getIds(){
        int [] ids = new int [getNumRows()];

        String query = "Select "+ COLUMN_ID + " FROM " + TABLE_OFFLINE_SITE;
        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor2 = db.rawQuery(query, null);
        if(getNumRows()>0) {
            if (cursor2.moveToFirst()) {
                cursor2.moveToFirst();
                for (int i = 0; i <getNumRows(); i++) {
                    ids[i] = Integer.parseInt(cursor2.getString(0));
                    cursor2.moveToNext();

                }

                cursor2.close();
            }

            db.close();
        }

        return ids;
    }
}
