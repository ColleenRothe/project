package teammsu.colleenrothe.usmp;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Class that implements a DB to save NSE forms offline
 * CREDITS:
 *      (1)Idea/Code from: http://www.techotopia.com/index.php/An_Android_SQLite_Database_Tutorial
 */


public class NewSlopeEventDBHandler extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "newSlopeEventDB.db";
    public static final String TABLE_NEW_SLOPE_EVENT = "newSlopeEvent";

    //column names
    public static final String COLUMN_ID = "_id";
    public static final String COLUMN_OBSERVER_NAME = "observer_name";
    public static final String COLUMN_EMAIL = "email";
    public static final String COLUMN_PHONE_NO = "phone_no";
    public static final String COLUMN_DATE = "date";
    public static final String COLUMN_DATE_APPROXIMATOR = "date_approximator";
    public static final String COLUMN_DATEINPUT = "dateinput";
    public static final String COLUMN_HAZARD_TYPE= "hazard_type";
    public static final String COLUMN_STATE = "state";
    public static final String COLUMN_PHOTOS = "photos";
    public static final String COLUMN_ROAD_TRAIL_NUMBER="road_trail_number";
    public static final String COLUMN_RT_TYPE="rt_type";
    public static final String COLUMN_BEGIN_MILE_MARKER="begin_mile_marker";
    public static final String COLUMN_END_MILE_MARKER="end_mile_marker";
    public static final String COLUMN_DATUM="datum";
    public static final String COLUMN_COORDINATE_LATITUDE="coordinate_latitude";
    public static final String COLUMN_COORDINATE_LONGITUDE="coordinate_longitude";
    public static final String COLUMN_CONDITION="condition";
    public static final String COLUMN_AFFECTED_LENGTH="affected_length";
    public static final String COLUMN_SIZE_ROCK="size_rock";
    public static final String COLUMN_NUM_FALLEN_ROCKS="num_fallen_rocks";
    public static final String COLUMN_VOL_DEBRIS="vol_debris";

    public static final String COLUMN_ABOVE_ROAD="above_road";
    public static final String COLUMN_BELOW_ROAD="below_road";
    public static final String COLUMN_AT_CULVERT="at_culvert";
    public static final String COLUMN_ABOVE_RIVER="above_river";
    public static final String COLUMN_ABOVE_COAST="above_coast";
    public static final String COLUMN_BURNED_AREA="burned_area";
    public static final String COLUMN_DEFORESTED_SLOPE="deforested_slope";
    public static final String COLUMN_URBAN="urban";
    public static final String COLUMN_MINE="mine";
    public static final String COLUMN_RETAINING_WALL="retaining_wall";
    public static final String COLUMN_NATURAL_SLOPE="natural_slope";
    public static final String COLUMN_ENGINEERED_SLOPE="engineered_slope";
    public static final String COLUMN_UNKNOWN="unknown";
    public static final String COLUMN_OTHER="other";

    public static final String COLUMN_RAIN_CHECKBOX="rain_checkbox";
    public static final String COLUMN_THUNDER_CHECKBOX="thunder_checkbox";
    public static final String COLUMN_CONT_RAIN_CHECKBOX="cont_rain_checkbox";
    public static final String COLUMN_HURRICANE_CHECKBOX="hurricane_checkbox";
    public static final String COLUMN_FLOOD_CHECKBOX="flood_checkbox";
    public static final String COLUMN_SNOWFALL_CHECKBOX="snowfall_checkbox";
    public static final String COLUMN_FREEZING_CHECKBOX="freezing_checkbox";
    public static final String COLUMN_HIGH_TEMP_CHECKBOX="high_temp_checkbox";
    public static final String COLUMN_EARTHQUAKE_CHECKBOX="earthquake_checkbox";
    public static final String COLUMN_VOLCANO_CHECKBOX="volcano_checkbox";
    public static final String COLUMN_LEAKY_PIPE_CHECKBOX="leaky_pipe_checkbox";
    public static final String COLUMN_MINING_CHECKBOX="mining_checkbox";
    public static final String COLUMN_CONSTRUCTION_CHECKBOX="construction_checkbox";
    public static final String COLUMN_DAM_EMBANKMENT_COLLAPSE_CHECKBOX="dam_embankment_collapse_checkbox";
    public static final String COLUMN_NOT_OBVIOUS_CHECKBOX="not_obvious_checkbox";
    public static final String COLUMN_UNKNOWN_CHECKBOX="unknown_checkbox";
    public static final String COLUMN_OTHER_CHECKBOX="other_checkbox";

    public static final String COLUMN_DAMAGES_Y_N="damages_y_n";
    public static final String COLUMN_DAMAGES="damages";



    public NewSlopeEventDBHandler(Context context, String name,
                                SQLiteDatabase.CursorFactory factory, int version) {
        super(context, DATABASE_NAME, factory, DATABASE_VERSION);
    }

    //create the nse table in the database
    @Override
    public void onCreate(SQLiteDatabase db) {
        // TODO Auto-generated method stub
        String CREATE_NEW_SLOPE_EVENT_TABLE = "CREATE TABLE " +
                TABLE_NEW_SLOPE_EVENT + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_OBSERVER_NAME+" TEXT,"+COLUMN_EMAIL+" TEXT,"+
                COLUMN_PHONE_NO+" TEXT, "+COLUMN_DATE+ " TEXT,"+COLUMN_DATE_APPROXIMATOR+" INTEGER,"+COLUMN_DATEINPUT+
                " TEXT,"+ COLUMN_HAZARD_TYPE+ " INTEGER,"+ COLUMN_STATE+" INTEGER, "+COLUMN_PHOTOS+" TEXT,"+
                COLUMN_ROAD_TRAIL_NUMBER+" TEXT,"+COLUMN_RT_TYPE+ " INTEGER,"+COLUMN_BEGIN_MILE_MARKER+" TEXT,"+
                COLUMN_END_MILE_MARKER+" TEXT,"+COLUMN_DATUM+" TEXT,"+COLUMN_COORDINATE_LATITUDE+" TEXT,"+
                COLUMN_COORDINATE_LONGITUDE+" TEXT,"+COLUMN_CONDITION+" INTEGER,"+COLUMN_AFFECTED_LENGTH+ " TEXT,"+
                COLUMN_SIZE_ROCK+" INTEGER,"+COLUMN_NUM_FALLEN_ROCKS+" INTEGER,"+COLUMN_VOL_DEBRIS+" INTEGER,"+
                COLUMN_ABOVE_ROAD+" INTEGER,"+COLUMN_BELOW_ROAD+" INTEGER,"+COLUMN_AT_CULVERT+" INTEGER,"+COLUMN_ABOVE_RIVER
                +" INTEGER,"+COLUMN_ABOVE_COAST+" INTEGER,"+COLUMN_BURNED_AREA+" INTEGER,"+COLUMN_DEFORESTED_SLOPE+" INTEGER,"+
                COLUMN_URBAN+" INTEGER,"+COLUMN_MINE+" INTEGER,"+COLUMN_RETAINING_WALL+" INTEGER,"+COLUMN_NATURAL_SLOPE+" INTEGER,"+
                COLUMN_ENGINEERED_SLOPE+" INTEGER,"+COLUMN_UNKNOWN+" INTEGER,"+COLUMN_OTHER+" INTEGER,"+COLUMN_RAIN_CHECKBOX
                +" INTEGER,"+COLUMN_THUNDER_CHECKBOX+" INTEGER,"+COLUMN_CONT_RAIN_CHECKBOX+" INTEGER,"+COLUMN_HURRICANE_CHECKBOX
                +" INTEGER,"+COLUMN_FLOOD_CHECKBOX+" INTEGER,"+COLUMN_SNOWFALL_CHECKBOX+" INTEGER,"+COLUMN_FREEZING_CHECKBOX
                +" INTEGER,"+COLUMN_HIGH_TEMP_CHECKBOX+" INTEGER,"+COLUMN_EARTHQUAKE_CHECKBOX+" INTEGER,"+COLUMN_VOLCANO_CHECKBOX
                +" INTEGER,"+COLUMN_LEAKY_PIPE_CHECKBOX+" INTEGER,"+COLUMN_MINING_CHECKBOX+" INTEGER,"+COLUMN_CONSTRUCTION_CHECKBOX
                +" INTEGER,"+COLUMN_DAM_EMBANKMENT_COLLAPSE_CHECKBOX+" INTEGER,"+COLUMN_NOT_OBVIOUS_CHECKBOX+" INTEGER,"+
                COLUMN_UNKNOWN_CHECKBOX+" INTEGER,"+COLUMN_OTHER_CHECKBOX+" INTEGER,"+COLUMN_DAMAGES_Y_N+ " INTEGER,"+
                COLUMN_DAMAGES+" TEXT"+")";

        db.execSQL(CREATE_NEW_SLOPE_EVENT_TABLE);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // TODO Auto-generated method stub
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NEW_SLOPE_EVENT);
        onCreate(db);

    }

    //add a new nse
    public void addNewSlopeEvent(NewSlopeEvent form){
        ContentValues values = new ContentValues();

        //make sure that the id# is unique, make it bigger than any of the others in the db
        int maxID = 1;
        if(getNumRows()>0) {

            String query = "Select "+ COLUMN_ID + " FROM " + TABLE_NEW_SLOPE_EVENT;
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

        //get the rest of the values from the nse form
        values.put(COLUMN_OBSERVER_NAME, form.getObserver_name());
        values.put(COLUMN_EMAIL, form.getEmail());
        values.put(COLUMN_PHONE_NO, form.getPhone_no());
        values.put(COLUMN_DATE, form.getDate());
        values.put(COLUMN_DATE_APPROXIMATOR, form.getDate_approximator());
        values.put(COLUMN_DATEINPUT, form.getDateinput());
        values.put(COLUMN_HAZARD_TYPE, form.getHazard_type());
        values.put(COLUMN_STATE, form.getState());
        values.put(COLUMN_PHOTOS, form.getPhotos());
        values.put(COLUMN_ROAD_TRAIL_NUMBER, form.getRoad_trail_number());
        values.put(COLUMN_RT_TYPE, form.getRt_type());
        values.put(COLUMN_BEGIN_MILE_MARKER, form.getBegin_mile_marker());
        values.put(COLUMN_END_MILE_MARKER, form.getEnd_mile_marker());
        values.put(COLUMN_DATUM, form.getDatum());
        values.put(COLUMN_COORDINATE_LATITUDE, form.getCoordinate_latitude());
        values.put(COLUMN_COORDINATE_LONGITUDE, form.getCoordinate_longitude());
        values.put(COLUMN_CONDITION, form.getCondition());
        values.put(COLUMN_AFFECTED_LENGTH, form.getAffected_length());
        values.put(COLUMN_SIZE_ROCK, form.getSize_rock());
        values.put(COLUMN_NUM_FALLEN_ROCKS, form.getNum_fallen_rocks());
        values.put(COLUMN_VOL_DEBRIS, form.getVol_debris());

        values.put(COLUMN_ABOVE_ROAD, form.getAbove_road());
        values.put(COLUMN_BELOW_ROAD, form.getBelow_road());
        values.put(COLUMN_AT_CULVERT, form.getAt_culvert());
        values.put(COLUMN_ABOVE_RIVER, form.getAbove_river());
        values.put(COLUMN_ABOVE_COAST, form.getAbove_coast());
        values.put(COLUMN_BURNED_AREA, form.getBurned_area());
        values.put(COLUMN_DEFORESTED_SLOPE, form.getDeforested_slope());
        values.put(COLUMN_URBAN, form.getUrban());
        values.put(COLUMN_MINE, form.getMine());
        values.put(COLUMN_RETAINING_WALL, form.getRetaining_wall());
        values.put(COLUMN_NATURAL_SLOPE, form.getNatural_slope());
        values.put(COLUMN_ENGINEERED_SLOPE, form.getEngineered_slope());
        values.put(COLUMN_UNKNOWN, form.getUnknown());
        values.put(COLUMN_OTHER, form.getOther());

        values.put(COLUMN_RAIN_CHECKBOX, form.getRain_checkbox());
        values.put(COLUMN_THUNDER_CHECKBOX, form.getThunder_checkbox());
        values.put(COLUMN_CONT_RAIN_CHECKBOX, form.getCont_rain_checkbox());
        values.put(COLUMN_HURRICANE_CHECKBOX, form.getHurricane_checkbox());
        values.put(COLUMN_FLOOD_CHECKBOX, form.getFlood_checkbox());
        values.put(COLUMN_SNOWFALL_CHECKBOX, form.getSnowfall_checkbox());
        values.put(COLUMN_FREEZING_CHECKBOX, form.getFreezing_checkbox());
        values.put(COLUMN_HIGH_TEMP_CHECKBOX, form.getHigh_temp_checkbox());
        values.put(COLUMN_EARTHQUAKE_CHECKBOX, form.getEarthquake_checkbox());
        values.put(COLUMN_VOLCANO_CHECKBOX, form.getVolcano_checkbox());
        values.put(COLUMN_LEAKY_PIPE_CHECKBOX, form.getLeaky_pipe_checkbox());
        values.put(COLUMN_MINING_CHECKBOX, form.getMining_checkbox());
        values.put(COLUMN_CONSTRUCTION_CHECKBOX, form.getConstruction_checkbox());
        values.put(COLUMN_DAM_EMBANKMENT_COLLAPSE_CHECKBOX, form.getDam_embankment_collapse_checkbox());
        values.put(COLUMN_NOT_OBVIOUS_CHECKBOX, form.getNot_obvious_checkbox());
        values.put(COLUMN_UNKNOWN_CHECKBOX, form.getUnknown_checkbox());
        values.put(COLUMN_OTHER_CHECKBOX, form.getOther_checkbox());

        values.put(COLUMN_DAMAGES_Y_N, form.getDamages_y_n());
        values.put(COLUMN_DAMAGES, form.getDamages());

        SQLiteDatabase db = this.getWritableDatabase();

        db.insert(TABLE_NEW_SLOPE_EVENT, null, values);
        db.close();

    }

    //find the nse form in the database that you want, search by unique id #
    public NewSlopeEvent findNSE(int id) {
        String query = "Select * FROM " + TABLE_NEW_SLOPE_EVENT + " WHERE " + COLUMN_ID + " =  \"" + id + "\"";

        SQLiteDatabase db = this.getWritableDatabase();

        Cursor cursor = db.rawQuery(query, null);

        NewSlopeEvent nse = new NewSlopeEvent();

        if (cursor.moveToFirst()) {
            cursor.moveToFirst();
            nse.setId(Integer.parseInt(cursor.getString(0)));
            nse.setObserver_name(cursor.getString(1));
            nse.setEmail(cursor.getString(2));
            nse.setPhone_no(cursor.getString(3));
            nse.setDate(cursor.getString(4));
            nse.setDate_approximator(Integer.parseInt(cursor.getString(5)));
            nse.setDateinput(cursor.getString(6));
            nse.setHazard_type(Integer.parseInt(cursor.getString(7)));
            nse.setState(Integer.parseInt(cursor.getString(8)));
            nse.setPhotos(cursor.getString(9));
            nse.setRoad_trail_number(cursor.getString(10));
            nse.setRt_type(Integer.parseInt(cursor.getString(11)));
            nse.setBegin_mile_marker(cursor.getString(12));
            nse.setEnd_mile_marker(cursor.getString(13));
            nse.setDatum(cursor.getString(14));
            nse.setCoordinate_latitude(cursor.getString(15));
            nse.setCoordinate_longitude(cursor.getString(16));
            nse.setCondition(Integer.parseInt(cursor.getString(17)));
            nse.setAffected_length(cursor.getString(18));
            nse.setSize_rock(Integer.parseInt(cursor.getString(19)));
            nse.setNum_fallen_rocks(Integer.parseInt(cursor.getString(20)));
            nse.setVol_debris(Integer.parseInt(cursor.getString(21)));

            nse.setAbove_road(Integer.parseInt(cursor.getString(22)));
            nse.setBelow_road(Integer.parseInt(cursor.getString(23)));
            nse.setAt_culvert(Integer.parseInt(cursor.getString(24)));
            nse.setAbove_river(Integer.parseInt(cursor.getString(25)));
            nse.setAbove_coast(Integer.parseInt(cursor.getString(26)));
            nse.setBurned_area(Integer.parseInt(cursor.getString(27)));
            nse.setDeforested_slope(Integer.parseInt(cursor.getString(28)));
            nse.setUrban(Integer.parseInt(cursor.getString(29)));
            nse.setMine(Integer.parseInt(cursor.getString(30)));
            nse.setRetaining_wall(Integer.parseInt(cursor.getString(31)));
            nse.setNatural_slope(Integer.parseInt(cursor.getString(32)));
            nse.setEngineered_slope(Integer.parseInt(cursor.getString(33)));
            nse.setUnknown(Integer.parseInt(cursor.getString(34)));
            nse.setOther(Integer.parseInt(cursor.getString(35)));

            nse.setRain_checkbox(Integer.parseInt(cursor.getString(36)));
            nse.setThunder_checkbox(Integer.parseInt(cursor.getString(37)));
            nse.setCont_rain_checkbox(Integer.parseInt(cursor.getString(38)));
            nse.setHurricane_checkbox(Integer.parseInt(cursor.getString(39)));
            nse.setFlood_checkbox(Integer.parseInt(cursor.getString(40)));
            nse.setSnowfall_checkbox(Integer.parseInt(cursor.getString(41)));
            nse.setFreezing_checkbox(Integer.parseInt(cursor.getString(42)));
            nse.setHigh_temp_checkbox(Integer.parseInt(cursor.getString(43)));
            nse.setEarthquake_checkbox(Integer.parseInt(cursor.getString(44)));
            nse.setVolcano_checkbox(Integer.parseInt(cursor.getString(45)));
            nse.setLeaky_pipe_checkbox(Integer.parseInt(cursor.getString(46)));
            nse.setMining_checkbox(Integer.parseInt(cursor.getString(47)));
            nse.setConstruction_checkbox(Integer.parseInt(cursor.getString(48)));
            nse.setDam_embankment_collapse_checkbox(Integer.parseInt(cursor.getString(49)));
            nse.setNot_obvious_checkbox(Integer.parseInt(cursor.getString(50)));
            nse.setUnknown_checkbox(Integer.parseInt(cursor.getString(51)));
            nse.setOther_checkbox(Integer.parseInt(cursor.getString(52)));

            nse.setDamages_y_n(Integer.parseInt(cursor.getString(53)));
            nse.setDamages(cursor.getString(54));


            cursor.close();
        } else {
            nse = null;
        }
        db.close();
        return nse;
    }

    //delete a nse from in db, found by unique id #
    public void deleteNSE(int id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_NEW_SLOPE_EVENT, COLUMN_ID + "=" + id, null);
    }

    //get the number of rows in the nse table
    public int getNumRows(){
        SQLiteDatabase db = this.getReadableDatabase();
        long row = DatabaseUtils.queryNumEntries(db, TABLE_NEW_SLOPE_EVENT);
        int rows = (int)row;
        System.out.println("rows"+rows);
        return rows;

    }

    //get an array of the unique ids in the nse table
    public int [] getIds(){
        int [] ids = new int [getNumRows()];

        String query = "Select "+ COLUMN_ID + " FROM " + TABLE_NEW_SLOPE_EVENT;
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
