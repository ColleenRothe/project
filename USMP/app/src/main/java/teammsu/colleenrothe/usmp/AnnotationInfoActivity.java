package teammsu.colleenrothe.usmp;

//http://stackoverflow.com/questions/9583878/how-to-parse-a-string-into-a-listdictionary

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.SystemClock;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

import java.net.URLConnection;
import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/* This is a class for the limited information (aka annotation) shown after clicking on
   a site on the main map (either landslide or rockfall)
 */

public class AnnotationInfoActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    TextView siteId;
    TextView coordinates;
    TextView date;
    TextView agency;
    TextView Rtnum;
    TextView beginMile;
    TextView endMile;
    TextView side;
    TextView hazardType;
    TextView prelimRating;
    TextView totalScore;
    TextView photos;
    TextView comments;

    Map<String, String> map;
    String clicked_id = "0";
    String offline_clicked = "0";
    String offline_landslide_id = "";

    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/get_current_site.php"; //to place the sites

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //provided
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_annotation_info);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //new

        //to connect to items on the UI
        siteId = (TextView) findViewById(R.id.AISiteid);
        coordinates = (TextView) findViewById(R.id.AICoordinates);
        date = (TextView) findViewById(R.id.AIDate);
        agency = (TextView) findViewById(R.id.AIAgency);
        Rtnum = (TextView) findViewById(R.id.AIRtnum);
        beginMile = (TextView) findViewById(R.id.AIBeginMile);
        endMile= (TextView) findViewById(R.id.AIEndMile);
        side = (TextView) findViewById(R.id.AISide);
        hazardType = (TextView) findViewById(R.id.AIHazardType);
        prelimRating = (TextView) findViewById(R.id.AIPrelimRating);
        totalScore = (TextView) findViewById(R.id.AITotalScore);
        photos = (TextView) findViewById(R.id.AIPhotos);
        comments = (TextView) findViewById(R.id.AIComments);

        //if you are viewing a site in offline mode....
        if(getIntent().getStringExtra("offline")!=null){
            offline_clicked = getIntent().getStringExtra("offline");
            loadFromOffline();

        //you are viewing a site while having internet connection
        }else{
            getJSON(JSON_URL); //call to populate
        }


    }

    //back button
    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    //to open the menus
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        getMenuInflater().inflate(R.menu.online_home, menu);
        return true;
    }

    //top menu
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();

        if(id == R.id.action_home){
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }

    //side menu
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
        } else if (id == R.id.slopeRatingForm) {
            Intent intent = new Intent(this, RatingChoiceActivity.class);
            startActivity(intent);

        } else if (id == R.id.newSlopeEvent) {
            Intent intent = new Intent(this, NewSlopeEventActivity.class);
            startActivity(intent);

        } else if (id == R.id.maintenaceForm) {
            Intent intent = new Intent(this, MaintenanceMapActivity.class);
            startActivity(intent);

        } else if (id == R.id.logout) {
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

    //LOAD FROM AN OFFLINE SAVED SITE
    public void loadFromOffline(){
        //database handler
        OfflineSiteDBHandler dbHandler = new OfflineSiteDBHandler(this, null, null, 1);
        //ids of the saved sites
        int [] ids = dbHandler.getIds();
        for(int i = 0; i<ids.length; i++){
            //create a new offline site
            OfflineSite offlineSite = new OfflineSite();
            offlineSite = dbHandler.findOfflineSite(ids[i]);
            //if it is the one we are looking for
            if(offlineSite.getSite_id().equals(offline_clicked)){
                //set all the values on the UI to the saved ones we want
                siteId.setText(offlineSite.getSite_id());
                coordinates.setText(offlineSite.getBegin_coordinate_lat()+","+offlineSite.getBegin_coordinate_long());
                date.setText(offlineSite.getDate());

                int agencyI = offlineSite.getAgency();
                ArrayList<String> agencyList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.AgencyList)));
                String agencyS = agencyList.get(agencyI);
                agency.setText(agencyS);

                Rtnum.setText(offlineSite.getRoad_trail_number());
                beginMile.setText(offlineSite.getBegin_mile_marker());
                endMile.setText(offlineSite.getEnd_mile_marker());

                int sideI = offlineSite.getSide();
                ArrayList<String> sideList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.sideList)));
                String sideS = sideList.get(sideI);
                side.setText(sideS);

                hazardType.setText(offlineSite.getHazard_type());
                prelimRating.setText(offlineSite.getPrelim_rating());
                totalScore.setText(offlineSite.getTotal_score());
                photos.setText(offlineSite.getphotos());
                comments.setText(offlineSite.getComments());
                offline_landslide_id=offlineSite.getPrelim_rating_landslide_id();
                offline_clicked = offlineSite.getSite_id();
                break;
            }

        }

    }

        //send post request and get data back from db
    public void GetText() throws UnsupportedEncodingException {
        String data="id="+MapActivity.ALoad_id;
        String text = "";
        BufferedReader reader = null;
        try {
            System.out.println("TRY");

            // Defined URL  where to send data
            URL url = new URL(JSON_URL);

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
        dealWithText(text);

    }


    //parse the response
    public void dealWithText(final String text){
        runOnUiThread(new Runnable() {
            String text2 = text;
            @Override
            public void run() {

                text2 = text2.replace("[",""); //old,new
                text2 = text2.replace("]",""); //old,new


                //weird bug, not with all sites, only some
                if(text2.charAt(2) != 'I'){ //not 4, 6
                    text2 = text2.replace("\"0\":", "");
                    text2 = text2.replace("\"1\":", "");
                    text2 = text2.replace("\"2\":", "");
                    text2 = text2.replace("\"3\":", "");
                    text2 = text2.replace("\"4\":", "");
                    text2 = text2.replace("\"5\":", "");
                    text2 = text2.replace("\"6\":", "");
                    text2 = text2.replace("\"7\":", "");

                    text2 = text2.replace(",,",",");
                }


                text2 = text2.replace("{",""); //old,new
                text2 = text2.replace("}",""); //old,new
                String text3 = "{";
                text3 = text3.concat(text2);
                text2 = text3.concat("}");

                //weird new bug.... will print like {"0": {"ID:"...
                if(text2.charAt(2) != 'I'){ //not 4, 6
                    text2 = text2.substring(5,text2.length());
                    text2 = "{".concat(text2);
                }
                System.out.println("final TEXT 2: "+text2);


                //Map<String, String> map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                System.out.println(map);

                //fill-in values on the UI
                siteId.setText(map.get("SITE_ID"));
                String coordinatesS = map.get("BEGIN_COORDINATE_LAT")+","+map.get("BEGIN_COORDINATE_LONG");
                coordinates.setText(coordinatesS);
                date.setText(map.get("DATE"));
                agency.setText(map.get("UMBRELLA_AGENCY"));
                Rtnum.setText(map.get("ROAD_TRAIL_NO"));
                beginMile.setText(map.get("BEGIN_MILE_MARKER"));
                endMile.setText(map.get("END_MILE_MARKER"));
                side.setText(map.get("SIDE"));
                hazardType.setText(map.get("HAZARD_TYPE2"));
                prelimRating.setText(map.get("PRELIMINARY_RATING"));
                totalScore.setText(map.get("TOTAL_SCORE"));
                photos.setText(map.get("PHOTOS"));
                comments.setText(map.get("COMMENT"));
            }
        });


    }

    //call method to start the post-response and get the data
    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String>{

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
            }

            @Override
            protected String doInBackground(String... params) {

                try {
                    GetText();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                return null;
            }

            @Override
            protected void onPostExecute(String s) {
                super.onPostExecute(s);
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }

    //call to open the correct type of form and edit the site
    public void editSite(View view){
        //if working in offline mode...
        if(getIntent().getStringExtra("offline")!=null){
            //landslide
            System.out.println("offline landslide id is:"+offline_landslide_id);
            if(!offline_landslide_id.equals("0")){
                Intent intent = new Intent(this, LandslideActivity.class);
                //tell form you are working in offline mode
                intent.putExtra("offline", offline_clicked);
                startActivity(intent);
            }
            //rockfall
            else{
                Intent intent = new Intent(this, RockfallActivity.class);
                //tell form you are working in offline mode
                intent.putExtra("offline", offline_clicked);
                startActivity(intent);
            }
         //working with internet connectivity
        }else {
            clicked_id = map.get("ID");
            String type = map.get("HAZARD_RATING_ROCKFALL_ID");
            //landslide
            if (type.equals("0")) {
                Intent intent = new Intent(this, LandslideActivity.class);
                //tell form you are working in editing mode
                intent.putExtra("editing", clicked_id);
                startActivity(intent);
            }
            //rockfall
            else {
                Intent intent = new Intent(this, RockfallActivity.class);
                //tell form you are working in editing mode
                intent.putExtra("editing", clicked_id);
                startActivity(intent);
            }
        }

    }


}
