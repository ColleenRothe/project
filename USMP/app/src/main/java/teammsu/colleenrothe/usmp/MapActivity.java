package teammsu.colleenrothe.usmp;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapbox.mapboxsdk.MapboxAccountManager;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.Marker;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.annotations.MarkerOptions;


import com.mapbox.mapboxsdk.geometry.LatLngBounds;
import com.mapbox.mapboxsdk.offline.OfflineManager;
import com.mapbox.mapboxsdk.offline.OfflineRegion;
import com.mapbox.mapboxsdk.offline.OfflineRegionError;
import com.mapbox.mapboxsdk.offline.OfflineRegionStatus;
import com.mapbox.mapboxsdk.offline.OfflineTilePyramidRegionDefinition;

import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory;
import com.mapbox.services.commons.models.Position;

import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLConnection;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;


import org.json.JSONObject;
import android.util.Log;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import android.content.Context;

import java.util.ArrayList;

import java.io.BufferedReader;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

//https://www.mapbox.com/android-sdk/examples/offline-map/
//https://www.mapbox.com/android-sdk/examples/offline-manager/

public class MapActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    MapView mapView; //mapbox map view
    private MapboxMap map;
    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/pin.php"; //to place the sites
    private static final String JSON_URL2 = "http://nl.cs.montana.edu/test_sites/colleen.rothe/percentiles.php"; //percentiles for image
    private static final String JSON_URL3 = "http://nl.cs.montana.edu/test_sites/colleen.rothe/getLandslide.php"; //to get full site info for an offline site

    //offline func
    private OfflineManager offlineManager;
    private OfflineRegion offlineRegion;
    private boolean isEndNotified;
    private ProgressBar progressBar;
    private int regionSelected;
    private String regionName;

    private ArrayList<String> offline_ids = new ArrayList<String>();
    Map<String, String> oMap;

    // JSON encoding/decoding
    public static final String JSON_CHARSET = "UTF-8";
    public static final String JSON_FIELD_REGION_NAME = "FIELD_REGION_NAME";
    private static final String TAG = "MapActivity";


    String [] sites;
    String [] tempSites; //could bring down?
    String [] [] finalSites; //final 2d array that the site information is kept in
    Double l25 = 0.0;
    Double l50 = 0.0;
    Double l75 = 0.0;
    Double r25 = 0.0;
    Double r50 = 0.0;
    Double r75 = 0.0;
    String [] percentages;
    static String ALoad_id = "0";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MapboxAccountManager.start(this, "pk.eyJ1IjoiY29sNTE2IiwiYSI6ImNpbWt0ZzViODAxNzh2YWtnN29ndDBxYzMifQ.dfNXNCfTPXZahyvRrTDU1g");

        setContentView(R.layout.activity_map);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

      ;

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        mapView = (MapView) findViewById(R.id.mapView);
        mapView.onCreate(savedInstanceState);

        mapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(MapboxMap mapboxMap) {
                map = mapboxMap;
            }
        });


        getJSON2(JSON_URL2);

        // Set up the offlineManager
        offlineManager = OfflineManager.getInstance(this);
        // Assign progressBar for later use
        progressBar = (ProgressBar) findViewById(R.id.progress_bar);



    }





    // Add the mapView lifecycle to the activity's lifecycle methods
    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mapView.onPause();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mapView.onSaveInstanceState(outState);
    }



    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.map, menu); //side
        getMenuInflater().inflate(R.menu.menu_main, menu); //top


        return true;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_cache_map) {
            Context context = mapView.getContext();
            LinearLayout layout = new LinearLayout(context);
            layout.setOrientation(LinearLayout.VERTICAL);

            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
//            final TextView tv = new TextView(this);
//            tv.setText("Corner Coordinates for saved map area", TextView.BufferType.NORMAL);
//            final EditText neLat = new EditText(this);
//            neLat.setHint("NE Corner latitude");
//            final EditText neLong = new EditText(this);
//            neLong.setHint("NE Corner longitude");
//            final EditText swLat = new EditText(this);
//            swLat.setHint("SW Corner Latitude");
//            final EditText swLong = new EditText(this);
//            swLong.setHint("SW Corner Longitude");
//
//            layout.addView(tv);
//            layout.addView(neLat);
//            layout.addView(neLong);
//            layout.addView(swLat);
//            layout.addView(swLong);

            final TextView tv = new TextView(this);
            tv.setText("Enter name for saved map area");
            final EditText et = new EditText(this);

            layout.addView(tv);
            layout.addView(et);


            alertDialogBuilder.setView(layout);


            alertDialogBuilder.setCancelable(true).setPositiveButton("OK", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    regionName = String.valueOf(et.getText());
                    downloadRegion();
                }

            });

            alertDialogBuilder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                        //finish();
                } });

            // create alert dialog
            AlertDialog alertDialog = alertDialogBuilder.create();
            // show it
            alertDialog.show();
        }

        if (id == R.id.action_cache_status) {
            downloadedRegionList();
        }
        if (id == R.id.action_load_offline_points) {
            OfflineSiteDBHandler dbHandler = new OfflineSiteDBHandler(this, null, null, 1);
            int [] ids = dbHandler.getIds();

            for(int i = 0; i<ids.length; i++) {
                OfflineSite offlineSite = new OfflineSite();
                offlineSite = dbHandler.findOfflineSite(ids[i]);
                System.out.println("site id is " + offlineSite.getSite_id());

                map.addMarker(new MarkerOptions()
                        .position(new LatLng(Double.parseDouble(offlineSite.getBegin_coordinate_lat()), Double.parseDouble(offlineSite.getBegin_coordinate_long())))
                        .title(offlineSite.getSite_id()));
                        //.snippet("Total Score:" + finalSites[k][4])
                        //.snippet(finalSites[k][0])
                        //.icon(icon0));


            }

            map.setOnInfoWindowLongClickListener(new MapboxMap.OnInfoWindowLongClickListener() {
                                                           @Override
                                                           public void onInfoWindowLongClick(Marker marker) {
                                                               //go to the annotation's info
                                                               //pass site id....
                                                               //ALoad_id = marker.getTitle();
                                                               Intent intent = new Intent(MapActivity.this, AnnotationInfoActivity.class);
                                                               intent.putExtra("offline",marker.getTitle());
                                                               startActivity(intent);

                                                           }
                                                       }
            );



        }
        if (id == R.id.action_info) {
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
            final TextView tv = new TextView(this);
            String message = "Cache map: Input northeast and southwest corner coordinates to save a portion of the map for offline use" +
                    "You must be online to do this, and will be notified when the download is complete (~2 min.).\n \n" +
                    "Clear Cache: Delete the current saved map (can only save one at a time). \n \n" +
                    "Cache Status: Check to see if you have a map section saved for offline use. If cached area is invalid, will notify you and automatically clear. \n \n" +
                    "Load Offline Points: While offline, load the map and previously saved sites. Only works if you have previously saved a map while online. You may need to zoom in to view map tiles.";
            tv.setText(message, TextView.BufferType.NORMAL);

            alertDialogBuilder.setView(tv);
            alertDialogBuilder.setCancelable(false).setPositiveButton("OK", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                }
            });

            // create alert dialog
            AlertDialog alertDialog = alertDialogBuilder.create();
            // show it
            alertDialog.show();
        }


        if(id == R.id.action_home){
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }

    // START OFFLINE SITE INFORMATION METHODS

    public void saveOfflineSites(){
        for(int i = 0; i < offline_ids.size(); i++){
            getJSONO(JSON_URL3, offline_ids.get(i));
        }
    }

    public void GetTextO(String id) throws UnsupportedEncodingException {
        //intent thing
        //String id = getIntent().getStringExtra("editing");
        String data="id="+id;
        String text = "";
        BufferedReader reader = null;
        try {
            System.out.println("TRY Offline");

            // Defined URL  where to send data
            URL url = new URL(JSON_URL3);

            // Send POST data request

            URLConnection conn = url.openConnection();
            conn.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(data);
            wr.flush();

            // Get the server response

            reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line = null;

            // Read Server Response
            while ((line = reader.readLine()) != null) {
                // Append server response in string
                sb.append(line + "\n");
            }


            text = sb.toString();
        } catch (Exception ex) {

        } finally {
            try {
                reader.close();
            } catch (Exception ex) {
            }
        }


        System.out.println(text);
        dealWithTextO(text);

    }

    public void dealWithTextO(final String text){
        runOnUiThread(new Runnable() {
            String text2 = text;
            @Override
            public void run() {
                System.out.println("Deal with it Offline");


                text2 = text2.replace("[",""); //old,new
                text2 = text2.replace("]",""); //old,new
                text2 = text2.replace("{",""); //old,new
                text2 = text2.replace("}",""); //old,new
                String text3 = "{";
                text3 = text3.concat(text2);
                text3 =text3.concat("}");

                oMap = new Gson().fromJson(text3, new TypeToken<HashMap<String, String>>() {}.getType());
                System.out.println(oMap.get("ID"));
                //can't do the db handler in runnable, so call new method
                newOfflineSite();

            }
        });
    }

    //create db offline site stuff
    public void newOfflineSite(){
        OfflineSiteDBHandler dbHandler = new OfflineSiteDBHandler(this, null, null, 1);

        ArrayList<String> agencyList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.AgencyList)));

        String agencyS = oMap.get("UMBRELLA_AGENCY"); //int
        int agency = 0;
        if(agencyList.contains(agencyS)){
            agency = agencyList.indexOf(agencyS);
        }

        ArrayList<String> regionalList1 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSRegionalList)));
        ArrayList<String> regionalList2 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSRegionalList)));
        String regionalS = oMap.get("REGIONAL_ADMIN"); //int
        int regional = 0;

        //fs
        if(agency == 1){
            if(regionalList1.contains(regionalS)){
                regional = regionalList1.indexOf(regionalS);
            }
        }
        //nps
        if(agency ==2){
            if(regionalList2.contains(regionalS)){
                regional = regionalList2.indexOf(regionalS);
            }
        }

        ArrayList<String> localList1 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList1)));
        ArrayList<String> localList2 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList2)));
        ArrayList<String> localList3 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList3)));
        ArrayList<String> localList4 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList4)));
        ArrayList<String> localList5 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList5)));
        ArrayList<String> localList6 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList6)));
        ArrayList<String> localList7 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList7)));
        ArrayList<String> localList8 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList8)));
        ArrayList<String> localList9 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.FSLocalList9)));
        ArrayList<String> localList10 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocalList1)));
        ArrayList<String> localList11 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocalList2)));
        ArrayList<String> localList12 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocal3)));
        ArrayList<String> localList13 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocal4)));
        ArrayList<String> localList14 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocal5)));
        ArrayList<String> localList15 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocal6)));
        ArrayList<String> localList16 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.NPSLocal7)));

        String localS = oMap.get("LOCAL_ADMIN"); //int
        int local = 0;
        //fs
        if(agency == 1){
            if(regional == 1) {
                if (localList1.contains(localS)) {
                    local = localList1.indexOf(localS);
                }
            }
            else if (regional == 2){
            if(localList2.contains(localS)) {
                    local = localList2.indexOf(localS);
                }
            }
            else if (regional == 3) {
                if (localList3.contains(localS)) {
                    local = localList3.indexOf(localS);
                }
            }
            else if(regional == 4) {
                 if (localList4.contains(localS)) {
                    local = localList4.indexOf(localS);
                }
            }
            else if (regional == 5) {
                 if (localList5.contains(localS)) {
                    local = localList5.indexOf(localS);
                }
            }
            else if (regional == 6) {
                 if (localList6.contains(localS)) {
                    local = localList6.indexOf(localS);
                }
            }
            else if (regional == 7) {
                 if (localList7.contains(localS)) {
                    local = localList7.indexOf(localS);
                }
            }
            else if (regional == 8) {
                 if (localList8.contains(localS)) {
                    local = localList8.indexOf(localS);
                }
            }
            else if (regional == 9) {
                 if (localList9.contains(localS)) {
                    local = localList9.indexOf(localS);
                }
            }
            else {
                local = 0;
            }
        }

        String date = oMap.get("DATE");
        String road_trail_no = oMap.get("ROAD_TRAIL_NO");
        int road_or_trail = 0;
        String road_or_trailS = oMap.get("ROAD_OR_TRAIL"); //R,T
        if(road_or_trailS.equals("T")){
            road_or_trail = 1;
        }
        String road_trail_class = oMap.get("ROAD_TRAIL_CLASS");
        String rater = oMap.get("RATER");
        String begin_mile = oMap.get("BEGIN_MILE_MARKER");
        String end_mile = oMap.get("END_MILE_MARKER");

        ArrayList<String> sideList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.sideList)));
        int side = 0;
        String sideS = oMap.get("SIDE"); //int
        if(sideList.contains(sideS)){
            side = sideList.indexOf(sideS);
        }

        ArrayList<String> weatherList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.weatherList)));
        int weather = 0;
        String weatherS = oMap.get("WEATHER"); //int
        if(weatherList.contains(weatherS)){
            weather = weatherList.indexOf(weatherS);
        }

        String hazard_type = oMap.get("HAZARD_TYPE");
        String begin_coordinate_lat = oMap.get("BEGIN_COORDINATE_LAT");
        String end_coordinate_lat = oMap.get("END_COORDINATE_LAT");
        String begin_coordinate_long = oMap.get("BEGIN_COORDINATE_LONG");
        String end_coordinate_long = oMap.get("END_COORDINATE_LONG");
        String datum = oMap.get("DATUM");
        String aadt = oMap.get("AADT");
        String length_affected = oMap.get("LENGTH_AFFECTED");
        String slope_ht_axial_length = oMap.get("SLOPE_HT_AXIAL_LENGTH");
        String slope_angle = oMap.get("SLOPE_ANGLE");
        String sight_distance = oMap.get("SIGHT_DISTANCE");
        String road_trail_width = oMap.get("ROAD_TRAIL_WIDTH");
        //speed
        String minimum_ditch_width = oMap.get("MINIMUM_DITCH_WIDTH");
        String maximum_ditch_width = oMap.get("MAXIMUM_DITCH_WIDTH");
        String minimum_ditch_depth = oMap.get("MINIMUM_DITCH_DEPTH");
        String maximum_ditch_depth = oMap.get("MAXIMUM_DITCH_DEPTH");
        String minimum_ditch_slope_first = oMap.get("MINIMUM_DITCH_SLOPE_FIRST");
        String maximum_ditch_slope_first = oMap.get("MAXIMUM_DITCH_SLOPE_FIRST");
        String minimum_ditch_slope_second = oMap.get("MINIMUM_DITCH_SLOPE_SECOND");
        String maximum_ditch_slope_second = oMap.get("MAXIMUM_DITCH_SLOPE_SECOND");
        String blk_size = oMap.get("BLK_SIZE");
        String volume = oMap.get("VOLUME");
        String begin_annual_rainfall = oMap.get("BEGIN_ANNUAL_RAINFALL");
        String end_annual_rainfall = oMap.get("END_ANNUAL_RAINFALL");
        int sole_access_route = 0;
        String sole_access_routeS = oMap.get("SOLE_ACCESS_ROUTE"); //Y,N
        if(sole_access_routeS.equals("Y")){
            sole_access_route = 1;
        }
        int fixes_present = 0;
        String fixes_presentS = oMap.get("FIXES_PRESENT"); //Y,N
        if(fixes_presentS.equals("Y")){
            fixes_present = 1;
        }
        String comments = oMap.get("COMMENT");
        String flma_name = oMap.get("FLMA_NAME");
        String flma_id = oMap.get("FLMA_ID");
        String flma_description = oMap.get("FLMA_DESCRIPTION");

        //prelim ratings landslide only
        int landslide_prelim_road_width_affected = 0;
        String landslide_prelim_road_width_affectedS = oMap.get("LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED"); //int
        if(!"".equals(landslide_prelim_road_width_affectedS)){
            landslide_prelim_road_width_affected = Integer.parseInt(landslide_prelim_road_width_affectedS);
        }

        int landslide_prelim_slide_erosion_effects = 0;
        String landslide_prelim_slide_erosion_effectsS = oMap.get("LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS"); //int
        if(!landslide_prelim_slide_erosion_effectsS.equals("")){
            landslide_prelim_slide_erosion_effects = Integer.parseInt(landslide_prelim_slide_erosion_effectsS);
        }
        String landslide_prelim_length_affected = oMap.get("LANDSLIDE_PRELIM_LENGTH_AFFECTED");

        //prelim ratings rockfall only
        int rockfall_prelim_ditch_eff = 0;
        String rockfall_prelim_ditch_effS = oMap.get("ROCKFALL_PRELIM_DITCH_EFF"); //int
        if(!rockfall_prelim_ditch_effS.equals("")){
            rockfall_prelim_ditch_eff = Integer.parseInt(rockfall_prelim_ditch_effS);
        }

        int rockfall_prelim_rockfall_history = 0;
        String rockfall_prelim_rockfall_historyS = oMap.get("ROCKFALL_PRELIM_ROCKFALL_HISTORY"); //int
        if(!rockfall_prelim_rockfall_historyS.equals("")){
            rockfall_prelim_rockfall_history = Integer.parseInt(rockfall_prelim_rockfall_historyS);
        }

        String rockfall_prelim_block_size_event_vol = oMap.get("ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL");

        //prelim ratings all
        int preliminary_rating_impact_on_use = 0;
        String preliminary_rating_impact_on_useS = oMap.get("PRELIMINARY_RATING_IMPACT_ON_USE"); //int
        if(!preliminary_rating_impact_on_useS.equals("")){
            preliminary_rating_impact_on_use = Integer.parseInt(preliminary_rating_impact_on_useS);
        }

        int preliminary_rating_aadt_usage_calc_checkbox = 0;
        String preliminary_rating_aadt_usage_calc_checkboxS = oMap.get("PRELIMINARY_RATING_ADDT_USAGE_CALC_CHECKBOX"); //int
        if(!preliminary_rating_aadt_usage_calc_checkboxS.equals("")){
            preliminary_rating_aadt_usage_calc_checkbox = Integer.parseInt(preliminary_rating_aadt_usage_calc_checkboxS);
        }

        String preliminary_rating_aadt_usage = oMap.get("PRELIMINARY_RATING_AADT_USAGE");
        String preliminary_rating = oMap.get("PRELIMINARY_RATING");

        //slope hazard ratings all
        int hazard_rating_slope_drainage = 0;
        String hazard_rating_slope_drainageS = oMap.get("HAZARD_RATING_SLOPE_DRAINAGE"); //int
        if(!hazard_rating_slope_drainageS.equals("")){
            hazard_rating_slope_drainage = Integer.parseInt(hazard_rating_slope_drainageS);
        }
        String hazard_rating_annual_rainfall = oMap.get("HAZARD_RATING_ANNUAL_RAINFALL");
        String hazard_rating_slope_height_axial_length = oMap.get("HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH");
        String hazard_total = oMap.get("HAZARD_TOTAL");

        //slope hazard ratings landslide only
        int landslide_hazard_rating_thaw_stability = 0;
        String landslide_hazard_rating_thaw_stabilityS = oMap.get("LANDSLIDE_HAZARD_RATING_THAW_STABILITY"); //int
        if(!landslide_hazard_rating_thaw_stabilityS.equals("")){
            landslide_hazard_rating_thaw_stability = Integer.parseInt(landslide_hazard_rating_thaw_stabilityS);
        }
        int landslide_hazard_rating_maint_frequency = 0;
        String landslide_hazard_rating_maint_frequencyS = oMap.get("LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY"); //int
        if(!landslide_hazard_rating_maint_frequencyS.equals("")){
            landslide_hazard_rating_maint_frequency = Integer.parseInt(landslide_hazard_rating_maint_frequencyS);
        }
        int landslide_hazard_rating_movement_history = 0;
        String landslide_hazard_rating_movement_historyS = oMap.get("LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY"); //int
        if(!landslide_hazard_rating_movement_historyS.equals("")){
            landslide_hazard_rating_movement_history = Integer.parseInt(landslide_hazard_rating_movement_historyS);
        }

        //slope hazard ratings rockfall only
        int rockfall_hazard_rating_maint_frequency = 0;
        String rockfall_hazard_rating_maint_frequencyS = oMap.get("ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY"); //int
        if(!rockfall_hazard_rating_maint_frequencyS.equals("")){
            rockfall_hazard_rating_maint_frequency = Integer.parseInt(rockfall_hazard_rating_maint_frequencyS);
        }
        int rockfall_hazard_rating_case_one_struc_condition = 0;
        String rockfall_hazard_rating_case_one_struc_conditionS = oMap.get("ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION"); //int
        if(!rockfall_hazard_rating_case_one_struc_conditionS.equals("")){
            rockfall_hazard_rating_case_one_struc_condition = Integer.parseInt(rockfall_hazard_rating_case_one_struc_conditionS);
        }
        int rockfall_hazard_rating_case_one_rock_friction = 0;
        String rockfall_hazard_rating_case_one_rock_frictionS = oMap.get("ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION"); //int
        if(!rockfall_hazard_rating_case_one_rock_frictionS.equals("")){
            rockfall_hazard_rating_case_one_rock_friction = Integer.parseInt(rockfall_hazard_rating_case_one_rock_frictionS);
        }
        int rockfall_hazard_rating_case_two_struc_condition = 0;
        String rockfall_hazard_rating_case_two_struc_conditionS = oMap.get("ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION"); //int
        if(!rockfall_hazard_rating_case_two_struc_conditionS.equals("")){
            rockfall_hazard_rating_case_two_struc_condition = Integer.parseInt(rockfall_hazard_rating_case_two_struc_conditionS);
        }
        int rockfall_hazard_rating_case_two_diff_erosion = 0;
        String rockfall_hazard_rating_case_two_diff_erosionS = oMap.get("ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION"); //int
        if(!rockfall_hazard_rating_case_two_diff_erosionS.equals("")){
            rockfall_hazard_rating_case_two_diff_erosion = Integer.parseInt(rockfall_hazard_rating_case_two_diff_erosionS);
        }

        //risk ratings- all
        String risk_rating_route_trail = oMap.get("RISK_RATING_ROUTE_TRAIL");
        String risk_rating_human_ex_factor = oMap.get("RISK_RATING_HUMAN_EX_FACTOR");
        String risk_rating_percent_dsd = oMap.get("RISK_RATING_PERCENT_DSD");
        int risk_rating_r_w_impacts = 0;
        String risk_rating_r_w_impactsS = oMap.get("RISK_RATING_R_W_IMPACTS"); //int
        if(!risk_rating_r_w_impactsS.equals("")){
            risk_rating_r_w_impacts = Integer.parseInt(risk_rating_r_w_impactsS);
        }
        int risk_rating_enviro_cult_impacts = 0;
        String risk_rating_enviro_cult_impactsS = oMap.get("RISK_RATING_ENVIRO_CULT_IMPACTS"); //int
        if (!risk_rating_enviro_cult_impactsS.equals("")){
            risk_rating_enviro_cult_impacts = Integer.parseInt(risk_rating_enviro_cult_impactsS);
        }
        int risk_rating_maint_complexity = 0;
        String risk_rating_maint_complexityS = oMap.get("RISK_RATING_MAINT_COMPLEXITY"); //int
        if(!risk_rating_maint_complexityS.equals("")){
            risk_rating_maint_complexity = Integer.parseInt(risk_rating_maint_complexityS);
        }
        int risk_rating_event_cost = 0;
        String risk_rating_event_costS = oMap.get("RISK_RATING_EVENT_COST"); //int
        if(!risk_rating_event_costS.equals("")){
            risk_rating_event_cost = Integer.parseInt(risk_rating_event_costS);
        }
        String risk_total = oMap.get("RISK_TOTAL");

        String total_score = oMap.get("TOTAL_SCORE");

        int speed_limit = 0;
        String photos = "";
        String site_id = oMap.get("SITE_ID");
        String prelim_rating_landslide_id = oMap.get("PRELIMINARY_RATING_LANDSLIDE_ID");


        OfflineSite offlineSite = new OfflineSite(agency,regional,local,date,road_trail_no,road_or_trail,road_trail_class,rater,begin_mile,end_mile,
                side,weather,hazard_type,begin_coordinate_lat,begin_coordinate_long,end_coordinate_lat,end_coordinate_long,datum,aadt,length_affected,
                slope_ht_axial_length,slope_angle,sight_distance,road_trail_width,speed_limit,minimum_ditch_width,maximum_ditch_width,minimum_ditch_depth,
                maximum_ditch_depth,minimum_ditch_slope_first,maximum_ditch_slope_first,minimum_ditch_slope_second,maximum_ditch_slope_second,blk_size,
                volume,begin_annual_rainfall,end_annual_rainfall,sole_access_route,fixes_present,photos,comments,flma_name,flma_id,flma_description,
                landslide_prelim_road_width_affected,landslide_prelim_slide_erosion_effects,landslide_prelim_length_affected,rockfall_prelim_ditch_eff,
                rockfall_prelim_rockfall_history,rockfall_prelim_block_size_event_vol,preliminary_rating_impact_on_use,preliminary_rating_aadt_usage_calc_checkbox,
                preliminary_rating_aadt_usage,preliminary_rating,hazard_rating_slope_drainage,hazard_rating_annual_rainfall,hazard_rating_slope_height_axial_length,
                hazard_total,landslide_hazard_rating_thaw_stability,landslide_hazard_rating_maint_frequency,landslide_hazard_rating_movement_history,
                rockfall_hazard_rating_maint_frequency,rockfall_hazard_rating_case_one_struc_condition,rockfall_hazard_rating_case_one_rock_friction,
                rockfall_hazard_rating_case_two_struc_condition,rockfall_hazard_rating_case_two_diff_erosion,risk_rating_route_trail,risk_rating_human_ex_factor,
                risk_rating_percent_dsd,risk_rating_r_w_impacts,risk_rating_enviro_cult_impacts,risk_rating_maint_complexity,risk_rating_event_cost,
                risk_total,total_score,site_id,prelim_rating_landslide_id);

        dbHandler.addOfflineSite(offlineSite);
        System.out.println("CREATED");

    }

    private void getJSONO(String url, final String id) {
        class GetJSON extends AsyncTask<String, Void, String> {
            //ProgressDialog loading; //just to tell the user that the map is in progress...all good
            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                //loading = ProgressDialog.show(AnnotationInfoActivity.this, "Please Wait...",null,true,true);
            }

            @Override
            protected String doInBackground(String... params) {

                try {
                    GetTextO(id);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                return null;
            }

            @Override
            protected void onPostExecute(String s) {
                super.onPostExecute(s);
                //loading.dismiss(); //dismiss the "loading" message
                //System.out.println(s);  //testing
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }

    // END OFFLINE SITE INFORMATION METHODS

    public void downloadRegion(){
        System.out.println("DOWNLOAD");
        startProgress();
        //to save a list of the site ids in the view
        LatLngBounds bounds = map.getProjection().getVisibleRegion().latLngBounds;
        List<Marker> markers = map.getMarkers();
        for(int i = 0; i< markers.size(); i++){
            if(bounds.contains(markers.get(i).getPosition())){
                System.out.println(markers.get(i).getTitle());
                offline_ids.add(markers.get(i).getTitle());
            }
        }
        saveOfflineSites();

//        // Create offline definition using the current
//        // style and boundaries of visible map area
//        String styleUrl = map.getStyleUrl();
//        //LatLngBounds bounds = map.getProjection().getVisibleRegion().latLngBounds;
//        double minZoom = map.getCameraPosition().zoom;
//        double maxZoom = map.getMaxZoom();
//        float pixelRatio = this.getResources().getDisplayMetrics().density;
//        OfflineTilePyramidRegionDefinition definition = new OfflineTilePyramidRegionDefinition(
//                styleUrl, bounds, minZoom, maxZoom, pixelRatio);
//        // Build a JSONObject using the user-defined offline region title,
//        // convert it into string, and use it to create a metadata variable.
//        // The metadata varaible will later be passed to createOfflineRegion()
//        byte[] metadata;
//        try {
//            JSONObject jsonObject = new JSONObject();
//            jsonObject.put(JSON_FIELD_REGION_NAME, regionName);
//            String json = jsonObject.toString();
//            metadata = json.getBytes(JSON_CHARSET);
//        } catch (Exception exception) {
//            Log.e(TAG, "Failed to encode metadata: " + exception.getMessage());
//            metadata = null;
//        }
//        // Create the offline region and launch the download
//        offlineManager.createOfflineRegion(definition, metadata, new OfflineManager.CreateOfflineRegionCallback() {
//            @Override
//            public void onCreate(OfflineRegion offlineRegion) {
//                Log.d(TAG, "Offline region created: " + regionName);
//                MapActivity.this.offlineRegion = offlineRegion;
//                launchDownload();
//            }
//
//            @Override
//            public void onError(String error) {
//                Log.e(TAG, "Error: " + error);
//            }
//        });
    }

    private void launchDownload() {
        // Set up an observer to handle download progress and
        // notify the user when the region is finished downloading
        offlineRegion.setObserver(new OfflineRegion.OfflineRegionObserver() {
            @Override
            public void onStatusChanged(OfflineRegionStatus status) {
                // Compute a percentage
                double percentage = status.getRequiredResourceCount() >= 0
                        ? (100.0 * status.getCompletedResourceCount() / status.getRequiredResourceCount()) :
                        0.0;


                System.out.println("percentage is" + percentage);

                if (status.isComplete()) {
                    // Download complete
                    endProgress("Region downloaded successfully.");
                    return;
                } else if (status.isRequiredResourceCountPrecise()) {
                    // Switch to determinate state
                    setPercentage((int) Math.round(percentage));
                }

                // Log what is being currently downloaded
                Log.d(TAG, String.format("%s/%s resources; %s bytes downloaded.",
                        String.valueOf(status.getCompletedResourceCount()),
                        String.valueOf(status.getRequiredResourceCount()),
                        String.valueOf(status.getCompletedResourceSize())));

                System.out.println("Status Changed");
            }

            @Override
            public void onError(OfflineRegionError error) {
                Log.e(TAG, "onError reason: " + error.getReason());
                Log.e(TAG, "onError message: " + error.getMessage());
            }

            @Override
            public void mapboxTileCountLimitExceeded(long limit) {
                Log.e(TAG, "Mapbox tile count limit exceeded: " + limit);
            }
        });
        // Change the region state
        offlineRegion.setDownloadState(OfflineRegion.STATE_ACTIVE);
    }
    private void downloadedRegionList() {
        // Build a region list when the user clicks the list button

        // Reset the region selected int to 0
        regionSelected = 0;

        // Query the DB asynchronously
        offlineManager.listOfflineRegions(new OfflineManager.ListOfflineRegionsCallback() {
            @Override
            public void onList(final OfflineRegion[] offlineRegions) {
                // Check result. If no regions have been
                // downloaded yet, notify user and return
                if (offlineRegions == null || offlineRegions.length == 0) {
                    Toast.makeText(MapActivity.this, "You have no regions yet.", Toast.LENGTH_SHORT).show();
                    return;
                }

                // Add all of the region names to a list
                ArrayList<String> offlineRegionsNames = new ArrayList<>();
                for (OfflineRegion offlineRegion : offlineRegions) {
                    offlineRegionsNames.add(getRegionName(offlineRegion));
                }
                final CharSequence[] items = offlineRegionsNames.toArray(new CharSequence[offlineRegionsNames.size()]);

                // Build a dialog containing the list of regions
                AlertDialog dialog = new AlertDialog.Builder(MapActivity.this)
                        .setTitle("List")
                        .setSingleChoiceItems(items, 0, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                // Track which region the user selects
                                regionSelected = which;
                            }
                        })
                        .setPositiveButton("Navigate to", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {

                                Toast.makeText(MapActivity.this, items[regionSelected], Toast.LENGTH_LONG).show();

                                // Get the region bounds and zoom
                                LatLngBounds bounds = ((OfflineTilePyramidRegionDefinition)
                                        offlineRegions[regionSelected].getDefinition()).getBounds();
                                double regionZoom = ((OfflineTilePyramidRegionDefinition)
                                        offlineRegions[regionSelected].getDefinition()).getMinZoom();

                                // Create new camera position
                                CameraPosition cameraPosition = new CameraPosition.Builder()
                                        .target(bounds.getCenter())
                                        .zoom(regionZoom)
                                        .build();

                                // Move camera to new position
                                map.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                // Make progressBar indeterminate and
                                // set it to visible to signal that
                                // the deletion process has begun
                                progressBar.setIndeterminate(true);
                                progressBar.setVisibility(View.VISIBLE);

                                //delete the site information
                                OfflineSiteDBHandler dbHandler = new OfflineSiteDBHandler(MapActivity.this, null, null, 1);
                                int [] ids = dbHandler.getIds();
                                for(int i = 0; i< ids.length; i++) {
                                    dbHandler.deleteOfflineSite(ids[i]);
                                }

                                // Begin the deletion process
                                offlineRegions[regionSelected].delete(new OfflineRegion.OfflineRegionDeleteCallback() {
                                    @Override
                                    public void onDelete() {
                                        // Once the region is deleted, remove the
                                        // progressBar and display a toast
                                        progressBar.setVisibility(View.INVISIBLE);
                                        progressBar.setIndeterminate(false);
                                        Toast.makeText(MapActivity.this, "Region deleted", Toast.LENGTH_LONG).show();
                                    }

                                    @Override
                                    public void onError(String error) {
                                        progressBar.setVisibility(View.INVISIBLE);
                                        progressBar.setIndeterminate(false);
                                        Log.e(TAG, "Error: " + error);
                                    }
                                });
                            }
                        })
                        .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                // When the user cancels, don't do anything.
                                // The dialog will automatically close
                            }
                        }).create();
                dialog.show();

            }

            @Override
            public void onError(String error) {
                Log.e(TAG, "Error: " + error);
            }
        });
    }

    private String getRegionName(OfflineRegion offlineRegion) {
        // Get the retion name from the offline region metadata
        String regionName;

        try {
            byte[] metadata = offlineRegion.getMetadata();
            String json = new String(metadata, JSON_CHARSET);
            JSONObject jsonObject = new JSONObject(json);
            regionName = jsonObject.getString(JSON_FIELD_REGION_NAME);
        } catch (Exception exception) {
            Log.e(TAG, "Failed to decode metadata: " + exception.getMessage());
            regionName = "Region " + offlineRegion.getID();
        }
        return regionName;
    }




    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.home) {
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        } else if (id == R.id.map) {
            Intent intent = new Intent(this, MapActivity.class);
            startActivity(intent);
        }
        else if (id == R.id.slopeRatingForm) {
            Intent intent = new Intent(this, RatingChoiceActivity.class);
            startActivity(intent);

        } else if (id == R.id.newSlopeEvent) {
            Intent intent = new Intent(this, NewSlopeEventActivity.class);
            startActivity(intent);

        } else if (id == R.id.maintenaceForm) {
            Intent intent = new Intent(this, MaintenanceMapActivity.class);
            startActivity(intent);

        }
        else if (id == R.id.account) {
            Intent intent = new Intent(this, AccountActivity.class);
            startActivity(intent);

        }
        else if (id == R.id.logout) {
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);

        }else if (id == R.id.savedList) {
            Intent intent = new Intent(this, OfflineList.class);
            startActivity(intent);

        }
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    //DATABASE STUFF (PERCENTILES FOR IMAGE)
    private void getJSON2(String url) {
        class GetJSON extends AsyncTask<String, Void, String>{
            //dont need another loading message...

            @Override
            protected void onPreExecute() {
                super.onPreExecute();

            }

            @Override
            protected String doInBackground(String... params) {

                String uri = params[0];

                BufferedReader bufferedReader = null;
                try {
                    URL url = new URL(uri);
                    HttpURLConnection con = (HttpURLConnection) url.openConnection();
                    StringBuilder sb = new StringBuilder();

                    bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream()));

                    String json;
                    while((json = bufferedReader.readLine())!= null){
                        sb.append(json+"\n");
                    }
                    String temp1 = sb.toString().replaceAll("\"", ""); //get rid of the ""
                    String temp2 = temp1.replaceAll("\\[", ""); //get rid of the brackets
                    String temp = temp2.replaceAll("\\]", ""); //get rid of brackets

                    percentages = temp.split(","); //break up the percentages by ,
                    return sb.toString().trim();

                }catch(Exception e){
                    return null;
                }

            }

            @Override
            protected void onPostExecute(String s) {
                super.onPostExecute(s);
                getJSON(JSON_URL); //move down to get images
                //then testing...then create the map sites
                System.out.println(s);
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }



    //DATABASE STUFF (MARKER)
    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String>{
            ProgressDialog loading; //just to tell the user that the map is in progress...all good

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                loading = ProgressDialog.show(MapActivity.this, "Please Wait...",null,true,true);
            }

            @Override
            protected String doInBackground(String... params) {

                String uri = params[0];

                BufferedReader bufferedReader = null;
                try {
                    URL url = new URL(uri);
                    HttpURLConnection con = (HttpURLConnection) url.openConnection();
                    StringBuilder sb = new StringBuilder();

                    bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream()));

                    String json;
                    while((json = bufferedReader.readLine())!= null){
                        sb.append(json+"\n");
                    }

                    sites = sb.toString().split("],"); //split the big string into individual sites by ending bracket
                    testing(); //call method that will split into 2d array
                    return sb.toString().trim();

                }catch(Exception e){
                    return null;
                }

            }

            @Override
            protected void onPostExecute(String s) {
                super.onPostExecute(s);
                loading.dismiss(); //dismiss the "loading" message
                //System.out.println(s);  //testing
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }


    //for the pin model helper...just to place the sites
    public void testing(){
        //-2 because the last one has the double bracket
        finalSites = new String[(sites.length -1)][7]; //the final 2d array to hold onto the sites
        for(int i = 0; i < (sites.length -1); i++) { //for all of the sites
            String temp = sites[i];
            String temp1 = temp.replaceAll("\"", ""); // get rid of the "" around each thing
            String temp2 = temp1.replaceAll("\\[", ""); //get rid of the brackets
            tempSites = temp2.split(","); //split site info by comma
            for (int j = 0; j < tempSites.length; j++) { //from 0 -->7 (id, site id, lat, long, score, rockfall, landslide)
                finalSites[i][j] = tempSites[j]; //put the value into the final array
                if(i == (sites.length-2) && j == (tempSites.length -1)){ //sites.length - 2 && tempSites.length.
                    makeMap(); //new method to help break up the code...
                    break; //redundant
                }
            } //end j for
        } //end i for
    }

    //put all the markers on
    public void makeMap(){
        //taken out of onCreate() to avoid the null array issue
        mapView.getMapAsync(new OnMapReadyCallback() {
                @Override
                public void onMapReady(MapboxMap mapboxMap) {
                    map = mapboxMap;

                    //assign the percentages
                    l25 = Double.parseDouble(percentages[0]); //string to double...
                    l50 = Double.parseDouble(percentages[1]);
                    l75 = Double.parseDouble(percentages[2]);
                    r25 = Double.parseDouble(percentages[3]);
                    r50 = Double.parseDouble(percentages[4]);
                    r75 = Double.parseDouble(percentages[5]);

                    //create icon for the custom marker to use
                    IconFactory iconFactory = IconFactory.getInstance(MapActivity.this);
                    Drawable iconDrawable0 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_whitelandslide);
                    Icon icon0;


                    //Landslide
                    Drawable iconDrawable = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_greenlandslide);
                    Icon icon = iconFactory.fromDrawable(iconDrawable);

                    Drawable iconDrawable2 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_yellowlandslide);
                    Icon icon2 = iconFactory.fromDrawable(iconDrawable2);

                    Drawable iconDrawable3 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_orangelandslide);
                    Icon icon3 = iconFactory.fromDrawable(iconDrawable3);

                    Drawable iconDrawable4 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_redlandslide);
                    Icon icon4 = iconFactory.fromDrawable(iconDrawable4);

                    //Rockfall
                    Drawable iconDrawable5 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_greenrockfall);
                    Icon icon5 = iconFactory.fromDrawable(iconDrawable5);

                    Drawable iconDrawable6 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_yellowrockfall);
                    Icon icon6 = iconFactory.fromDrawable(iconDrawable6);

                    Drawable iconDrawable7 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_orangerockfall);
                    Icon icon7 = iconFactory.fromDrawable(iconDrawable7);

                    Drawable iconDrawable8 = ContextCompat.getDrawable(MapActivity.this, R.drawable.ic_redrockfall);
                    Icon icon8 = iconFactory.fromDrawable(iconDrawable8);



                    for(int k = 0; k<finalSites.length; k++) { //finalSites.length
                        //image to be used....for now they are all red rockfall
                        Double type = Double.parseDouble(finalSites[k][6]); //help tell if landslide or rockfall
                        Double total = Double.parseDouble(finalSites[k][4]); //total score to determine image

                        //then it's a landslide
                        if(type > 0){
                            //System.out.println("YAY ITS A LANDSLIDE");
                            if(total <= l25){
                                icon0 = icon;
                            }
                            else if(total <= l50){
                                icon0 = icon2;
                            }
                            else if(total <= l75){
                                icon0 = icon3;
                            }
                            else{
                                icon0 = icon4;
                            }

                        }
                        else{ //rockfall
                            if(total <= r25){
                                icon0 = icon5;
                            }
                            else if(total <= r50){
                                icon0 = icon6;
                            }
                            else if(total <= r75){
                                icon0 = icon7;
                            }
                            else{
                                icon0 = icon8;
                            }

                        }

                        //need to convert lat/long values from string -> double to be used to place site
                        double latitude = Double.parseDouble(finalSites[k][2]);
                        double longitude = Double.parseDouble(finalSites[k][3]);

                        //String finalScore = finalSites[k][4];
                        //the first site...should be somewhere near ghana
                        mapboxMap.addMarker(new MarkerOptions()
                                .position(new LatLng(latitude, longitude))
                                .title(finalSites[k][1])
                                //.snippet("Total Score:" + finalSites[k][4])
                                .snippet(finalSites[k][0])
                                .icon(icon0));
                    }


                    mapboxMap.setOnInfoWindowLongClickListener(new MapboxMap.OnInfoWindowLongClickListener() {
                        @Override
                        public void onInfoWindowLongClick(Marker marker) {
                            //go to the annotation's info
                            //pass site id....
                            ALoad_id = marker.getSnippet();
                            Intent intent = new Intent(MapActivity.this, AnnotationInfoActivity.class);
                            startActivity(intent);

                        }
                    }
                    );

                }
            });

    }

    // Progress bar methods
    private void startProgress() {
        // Disable buttons
        //downloadButton.setEnabled(false);
        //listButton.setEnabled(false);

        // Start and show the progress bar
        isEndNotified = false;
        progressBar.setIndeterminate(true);
        progressBar.setVisibility(View.VISIBLE);
    }

    private void setPercentage(final int percentage) {
        progressBar.setIndeterminate(false);
        progressBar.setProgress(percentage);
    }

    private void endProgress(final String message) {
        // Don't notify more than once
        if (isEndNotified) {
            return;
        }

        // Enable buttons
        //downloadButton.setEnabled(true);
        //listButton.setEnabled(true);

        // Stop and hide the progress bar
        isEndNotified = true;
        progressBar.setIndeterminate(false);
        progressBar.setVisibility(View.GONE);

        // Show a toast
        Toast.makeText(MapActivity.this, message, Toast.LENGTH_LONG).show();
    }


}
