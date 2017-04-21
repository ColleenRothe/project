package teammsu.colleenrothe.usmp;

import android.database.DatabaseUtils;
import android.database.sqlite.*;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.content.ContentValues;
import android.database.Cursor;
import java.lang.Long;

/**
 * Class that implements a DB to save maintenance forms offline
 * CREDITS:
 *      (1)Idea/Code from: http://www.techotopia.com/index.php/An_Android_SQLite_Database_Tutorial
 */

public class MaintenanceDBHandler extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "maintenanceDB.db";
    public static final String TABLE_MAINTENANCE = "maintenance";

    //column names
    public static final String COLUMN_ID = "_id";
    public static final String COLUMN_SITE_ID = "site_id";
    public static final String COLUMN_CODE_RELATION = "code_relation";
    public static final String COLUMN_MAINTENANCE_TYPE = "maintenance_type";
    public static final String COLUMN_RT_NUM = "rt_num";
    public static final String COLUMN_BEGIN_MILE = "begin_mile";
    public static final String COLUMN_END_MILE = "end_mile";
    public static final String COLUMN_AGENCY = "agency";
    public static final String COLUMN_REGIONAL = "regional";
    public static final String COLUMN_LOCAL = "local";
    public static final String COLUMN_US_EVENT = "us_event";
    public static final String COLUMN_EVENT_DESC = "event_desc";
    public static final String COLUMN_TOTAL = "total";
    public static final String COLUMN_P1 = "p1";
    public static final String COLUMN_P2 = "p2";
    public static final String COLUMN_P3 = "p3";
    public static final String COLUMN_P4 = "p4";
    public static final String COLUMN_P4_5 = "p4_5";
    public static final String COLUMN_P5 = "p5";
    public static final String COLUMN_P6 = "p6";
    public static final String COLUMN_P7 = "p7";
    public static final String COLUMN_P8 = "p8";
    public static final String COLUMN_P9 = "p9";
    public static final String COLUMN_P10 = "p10";
    public static final String COLUMN_P11 = "p11";
    public static final String COLUMN_P12 = "p12";
    public static final String COLUMN_P13 = "p13";
    public static final String COLUMN_P14 = "p14";
    public static final String COLUMN_P15 = "p15";
    public static final String COLUMN_P16 = "p16";
    public static final String COLUMN_P17 = "p17";
    public static final String COLUMN_P18 = "p18";
    public static final String COLUMN_P19 = "p19";
    public static final String COLUMN_P20 = "p20";
    public static final String COLUMN_OTHERS1_DESC = "others1_desc";
    public static final String COLUMN_OTHERS2_DESC = "others2_desc";
    public static final String COLUMN_OTHERS3_DESC = "others3_desc";
    public static final String COLUMN_OTHERS4_DESC = "others4_desc";
    public static final String COLUMN_OTHERS5_DESC = "others5_desc";
    public static final String COLUMN_TOTAL_PERCENT = "total_percent";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";




    public MaintenanceDBHandler(Context context, String name,
                       CursorFactory factory, int version) {
        super(context, DATABASE_NAME, factory, DATABASE_VERSION);
    }

    //create maintenance table in the database
    @Override
    public void onCreate(SQLiteDatabase db) {
        // TODO Auto-generated method stub
        String CREATE_MAINTENANCE_TABLE = "CREATE TABLE " +
                TABLE_MAINTENANCE + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_SITE_ID + " INTEGER," + COLUMN_CODE_RELATION
                + " TEXT," +  COLUMN_MAINTENANCE_TYPE + " INTEGER,"+COLUMN_RT_NUM+" TEXT,"+COLUMN_BEGIN_MILE+
                " TEXT,"+COLUMN_END_MILE+" TEXT,"+COLUMN_AGENCY+ " INTEGER,"+COLUMN_REGIONAL+" INTEGER,"+
                COLUMN_LOCAL+" INTEGER,"+COLUMN_US_EVENT+" INTEGER,"+COLUMN_EVENT_DESC+ " TEXT,"+COLUMN_TOTAL+
                " INTEGER,"+COLUMN_P1+" INTEGER,"+COLUMN_P2+" INTEGER,"+COLUMN_P3+" INTEGER,"+COLUMN_P4
                +" INTEGER,"+COLUMN_P4_5+" INTEGER,"+COLUMN_P5+" INTEGER,"+COLUMN_P6+" INTEGER,"+ COLUMN_P7+
                " INTEGER,"+ COLUMN_P8 +" INTEGER,"+COLUMN_P9+" INTEGER,"+COLUMN_P10+" INTEGER,"+COLUMN_P11+
                " INTEGER,"+COLUMN_P12+" INTEGER,"+COLUMN_P13+" INTEGER,"+COLUMN_P14+" INTEGER,"+COLUMN_P15
                +" INTEGER,"+COLUMN_P16+" INTEGER,"+COLUMN_P17+" INTEGER,"+COLUMN_P18+" INTEGER,"+COLUMN_P19+
                " INTEGER,"+COLUMN_P20+" INTEGER,"+COLUMN_OTHERS1_DESC+" TEXT,"+COLUMN_OTHERS2_DESC+" TEXT,"+
                COLUMN_OTHERS3_DESC+" TEXT,"+COLUMN_OTHERS4_DESC+" TEXT,"+COLUMN_OTHERS5_DESC+" TEXT,"+
                COLUMN_TOTAL_PERCENT+" INTEGER,"+COLUMN_LATITUDE+" TEXT,"+COLUMN_LONGITUDE+" TEXT"+")";

        db.execSQL(CREATE_MAINTENANCE_TABLE);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // TODO Auto-generated method stub
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_MAINTENANCE);
        onCreate(db);

    }

    //add a new maintenance form
    public void addMaintenance(Maintenance form) {
        ContentValues values = new ContentValues();

        //make sure that the id# is unique, make it bigger than any of the others in the db
        int maxID = 1;
        if(getNumRows()>0) {

            String query = "Select "+ COLUMN_ID + " FROM " + TABLE_MAINTENANCE;
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

        //get the rest of the values from the maintenance form
        values.put(COLUMN_SITE_ID, form.getSite_id());
        values.put(COLUMN_CODE_RELATION, form.getCode_relation());
        values.put(COLUMN_MAINTENANCE_TYPE, form.getMaintenance_type());
        values.put(COLUMN_RT_NUM, form.getRt_num());
        values.put(COLUMN_BEGIN_MILE, form.getBegin_mile());
        values.put(COLUMN_END_MILE, form.getEnd_mile());
        values.put(COLUMN_AGENCY, form.getAgency());
        values.put(COLUMN_REGIONAL, form.getRegional());
        values.put(COLUMN_LOCAL, form.getLocal());
        values.put(COLUMN_US_EVENT, form.getUs_event());
        values.put(COLUMN_EVENT_DESC, form.getEvent_desc());
        values.put(COLUMN_TOTAL, form.getTotal());

        values.put(COLUMN_P1, form.getP1());
        values.put(COLUMN_P2, form.getP2());
        values.put(COLUMN_P3, form.getP3());
        values.put(COLUMN_P4, form.getP4());
        values.put(COLUMN_P4_5, form.getP4_5());
        values.put(COLUMN_P5, form.getP5());
        values.put(COLUMN_P6, form.getP6());
        values.put(COLUMN_P7, form.getP7());
        values.put(COLUMN_P8, form.getP8());
        values.put(COLUMN_P9, form.getP9());
        values.put(COLUMN_P10, form.getP10());
        values.put(COLUMN_P11, form.getP11());
        values.put(COLUMN_P12, form.getP12());
        values.put(COLUMN_P13, form.getP13());
        values.put(COLUMN_P14, form.getP14());
        values.put(COLUMN_P15, form.getP15());
        values.put(COLUMN_P16, form.getP16());
        values.put(COLUMN_P17, form.getP17());
        values.put(COLUMN_P18, form.getP18());
        values.put(COLUMN_P19, form.getP19());
        values.put(COLUMN_P20, form.getP20());

        values.put(COLUMN_OTHERS1_DESC, form.getOthers1_desc());
        values.put(COLUMN_OTHERS2_DESC, form.getOthers2_desc());
        values.put(COLUMN_OTHERS3_DESC, form.getOthers3_desc());
        values.put(COLUMN_OTHERS4_DESC, form.getOthers4_desc());
        values.put(COLUMN_OTHERS5_DESC, form.getOthers5_desc());
        values.put(COLUMN_TOTAL_PERCENT, form.getTotal_percent());
        values.put(COLUMN_LATITUDE, form.getLatitude());
        values.put(COLUMN_LONGITUDE, form.getLongitude());


        SQLiteDatabase db = this.getWritableDatabase();

        db.insert(TABLE_MAINTENANCE, null, values);
        db.close();
    }

    //find the maintenance form in the database that you want, search by unique id #
    public Maintenance findMaintenance(int id) {
        String query = "Select * FROM " + TABLE_MAINTENANCE + " WHERE " + COLUMN_ID + " =  \"" + id + "\"";

        SQLiteDatabase db = this.getWritableDatabase();

        Cursor cursor = db.rawQuery(query, null);

        Maintenance maintenance = new Maintenance();

        if (cursor.moveToFirst()) {
            cursor.moveToFirst();
            maintenance.setID(Integer.parseInt(cursor.getString(0)));
            maintenance.setSite_id(Integer.parseInt(cursor.getString(1)));
            maintenance.setCode_relation(cursor.getString(2));
            maintenance.setMaintenance_type(Integer.parseInt(cursor.getString(3)));
            maintenance.setRt_num(cursor.getString(4));
            maintenance.setBegin_mile(cursor.getString(5));
            maintenance.setEnd_mile(cursor.getString(6));
            maintenance.setAgency(Integer.parseInt(cursor.getString(7)));
            maintenance.setRegional(Integer.parseInt(cursor.getString(8)));
            maintenance.setLocal(Integer.parseInt(cursor.getString(9)));
            maintenance.setUs_event(Integer.parseInt(cursor.getString(10)));
            maintenance.setEvent_desc(cursor.getString(11));
            maintenance.setTotal(Integer.parseInt(cursor.getString(12)));
            maintenance.setP1(Integer.parseInt(cursor.getString(13)));
            maintenance.setP2(Integer.parseInt(cursor.getString(14)));
            maintenance.setP3(Integer.parseInt(cursor.getString(15)));
            maintenance.setP4(Integer.parseInt(cursor.getString(16)));
            maintenance.setP4_5(Integer.parseInt(cursor.getString(17)));
            maintenance.setP5(Integer.parseInt(cursor.getString(18)));
            maintenance.setP6(Integer.parseInt(cursor.getString(19)));
            maintenance.setP7(Integer.parseInt(cursor.getString(20)));
            maintenance.setP8(Integer.parseInt(cursor.getString(21)));
            maintenance.setP9(Integer.parseInt(cursor.getString(22)));
            maintenance.setP10(Integer.parseInt(cursor.getString(23)));
            maintenance.setP11(Integer.parseInt(cursor.getString(24)));
            maintenance.setP12(Integer.parseInt(cursor.getString(25)));
            maintenance.setP13(Integer.parseInt(cursor.getString(26)));
            maintenance.setP14(Integer.parseInt(cursor.getString(27)));
            maintenance.setP15(Integer.parseInt(cursor.getString(28)));
            maintenance.setP16(Integer.parseInt(cursor.getString(29)));
            maintenance.setP17(Integer.parseInt(cursor.getString(30)));
            maintenance.setP18(Integer.parseInt(cursor.getString(31)));
            maintenance.setP19(Integer.parseInt(cursor.getString(32)));
            maintenance.setP20(Integer.parseInt(cursor.getString(33)));
            maintenance.setOthers1_desc(cursor.getString(34));
            maintenance.setOthers2_desc(cursor.getString(35));
            maintenance.setOthers3_desc(cursor.getString(36));
            maintenance.setOthers4_desc(cursor.getString(37));
            maintenance.setOthers5_desc(cursor.getString(38));
            maintenance.setTotal_percent(Integer.parseInt(cursor.getString(39)));
            maintenance.setLatitude(cursor.getString(40));
            maintenance.setLongitude(cursor.getString(41));

            cursor.close();
        } else {
            maintenance = null;
        }
        db.close();
        return maintenance;
    }

    //delete a maintenance form in db, found by unique id #
    public void deleteMaintenance(int id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_MAINTENANCE, COLUMN_ID + "=" + id, null);
    }

    //get the number of rows in the maintenance table
    public int getNumRows(){
        SQLiteDatabase db = this.getReadableDatabase();
        long row = DatabaseUtils.queryNumEntries(db, TABLE_MAINTENANCE);
        int rows = (int)row;
        System.out.println("rows"+rows);
        return rows;

    }

    //get an array of the unique ids in the maintenance table
    public int [] getIds(){
        int [] ids = new int [getNumRows()];

        String query = "Select "+ COLUMN_ID + " FROM " + TABLE_MAINTENANCE;
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
