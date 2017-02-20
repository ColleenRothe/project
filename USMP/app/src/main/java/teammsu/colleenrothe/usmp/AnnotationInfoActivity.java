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
import java.util.Map;
import java.util.HashMap;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AnnotationInfoActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    TextView siteId;
    TextView coordinates;
    TextView date;
    TextView slopeStatus;
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

    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/mapService2.php"; //to place the sites



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
        siteId = (TextView) findViewById(R.id.AISiteid);
        coordinates = (TextView) findViewById(R.id.AICoordinates);
        date = (TextView) findViewById(R.id.AIDate);
        slopeStatus = (TextView) findViewById(R.id.AISlopeStatus);
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

        getJSON(JSON_URL);

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
        getMenuInflater().inflate(R.menu.menu_main, menu);
        getMenuInflater().inflate(R.menu.online_home, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }
        if(id == R.id.action_home){
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.home) {
            Intent intent = new Intent(this, MainActivity.class);
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

        } else if (id == R.id.account) {
            Intent intent = new Intent(this, AccountActivity.class);
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

    public void GetText() throws UnsupportedEncodingException {
        //String data = URLEncoder.encode("id=355", "UTF-8");
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



    public void dealWithText(final String text){
        runOnUiThread(new Runnable() {
            String text2 = text;
            @Override
            public void run() {
                System.out.println("Deal with it");

                System.out.println(text2);

                text2 = text2.replace("[",""); //old,new
                text2 = text2.replace("]",""); //old,new

                //Map<String, String> map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                System.out.println(map);
                System.out.println(map.get("ID"));

                //0 is the id
                siteId.setText(map.get("SITE_ID"));
                coordinates.setText(map.get("COORDINATES"));
                date.setText(map.get("DATE"));
                slopeStatus.setText(map.get("SLOPE_STATUS"));
                agency.setText(map.get("UMBRELLA_AGENCY"));
                Rtnum.setText(map.get("ROAD_TRAIL_NO"));
                beginMile.setText(map.get("BEGIN_MILE_MARKER"));
                endMile.setText(map.get("END_MILE_MARKER"));
                side.setText(map.get("SIDE"));
                hazardType.setText(map.get("HAZARD_TYPE"));
                prelimRating.setText(map.get("PRELIM_RATING"));
                totalScore.setText(map.get("TOTAL_SCORE"));
                photos.setText(map.get("PHOTOS"));
                comments.setText(map.get("COMMENTS"));
            }
        });


    }

    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String>{
            //ProgressDialog loading; //just to tell the user that the map is in progress...all good

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                //loading = ProgressDialog.show(AnnotationInfoActivity.this, "Please Wait...",null,true,true);
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
                //loading.dismiss(); //dismiss the "loading" message
                //System.out.println(s);  //testing
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }

    public void editSite(View view){

        clicked_id = map.get("ID");
        String type = map.get("HAZARD_RATING_ROCKFALL_ID");
        //landslide
        if(type.equals("0")){
            Intent intent = new Intent(this, LandslideActivity.class);
            intent.putExtra("editing",clicked_id);
            startActivity(intent);
        }
        //rockfall
        else{
            Intent intent = new Intent(this, RockfallActivity.class);
            intent.putExtra("editing",clicked_id);
            startActivity(intent);
        }

    }


}
