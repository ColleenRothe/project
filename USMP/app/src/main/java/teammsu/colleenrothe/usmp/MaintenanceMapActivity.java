package teammsu.colleenrothe.usmp;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.content.Context;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;

import com.mapbox.mapboxsdk.MapboxAccountManager;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.Marker;
import com.mapbox.mapboxsdk.annotations.MarkerOptions;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
//import com.mapbox.mapboxsdk.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/*Class for the map that shows the maintenance forms
   CREDITS:
        (1)blue marker from: http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_blue.png
        (2)white marker from: http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_white.png

 */

public class MaintenanceMapActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    MapView MaintenanceMapView; //mapbox map view
    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/maintenanceMap.php"; //to place the sites
    public static boolean newOld = true; //old = true, new=false(don't have to do anything when false)

    String [] sites;
    String [] tempSites; //could bring down?
    String [] [] finalSites; //final 2d array that the site information is kept in
    static String load_id = "0";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        newOld = true;
        //provided
        super.onCreate(savedInstanceState);
        //mapbox account
        MapboxAccountManager.start(this, "pk.eyJ1IjoiY29sNTE2IiwiYSI6ImNpbWt0ZzViODAxNzh2YWtnN29ndDBxYzMifQ.dfNXNCfTPXZahyvRrTDU1g");

        //provided
        setContentView(R.layout.activity_maintenance_map);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //Connection to UI
        MaintenanceMapView = (MapView) findViewById(R.id.MaintenanceMapView);

        MaintenanceMapView.onCreate(savedInstanceState);

        //Call to php/db
        getJSON(JSON_URL);
    }

    // Add the mapView lifecycle to the activity's lifecycle methods
    @Override
    public void onResume() {
        super.onResume();
        MaintenanceMapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        MaintenanceMapView.onPause();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        MaintenanceMapView.onLowMemory();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        MaintenanceMapView.onDestroy();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        MaintenanceMapView.onSaveInstanceState(outState);
    }

    //go back
    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    //open menus
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.maintenance_map, menu); //side
        getMenuInflater().inflate(R.menu.menu_main, menu); //top

        return true;
    }

    //top menus
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_mmLegend) {
            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
            final ImageView iv = new ImageView(this);
            iv.setImageResource(R.drawable.maintenance_legend_web);

            alertDialogBuilder.setView(iv);
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

        } else if (id == R.id.maintenaceForm) {  //don't go anywhere...already here
            //Intent intent = new Intent(this, MaintenanceActivity.class);
            //startActivity(intent);


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

    //get the info from the db
    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String> {

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

            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
    }

    //for the pin model helper...just to place the sites
    public void testing(){
        //-2 because the last one has the double bracket
        finalSites = new String[(sites.length -1)][10]; //the final 2d array to hold onto the sites
        for(int i = 0; i < (sites.length -1); i++) { //for all of the sites
            String temp = sites[i];
            String temp1 = temp.replaceAll("\"", ""); // get rid of the "" around each thing
            String temp2 = temp1.replaceAll("\\[", ""); //get rid of the brackets
            tempSites = temp2.split(","); //split site info by comma
            for (int j = 0; j < tempSites.length; j++) { //from 0 -->10 (id, site id, lat, long....)
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
        MaintenanceMapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(final MapboxMap mapboxMap) {

                IconFactory iconFactory = IconFactory.getInstance(MaintenanceMapActivity.this);

                //no slope rating associated (site id = 0)

                //Credits(2)
                Drawable iconDrawable = ContextCompat.getDrawable(MaintenanceMapActivity.this, R.mipmap.ic_mmwhite);
                Icon whiteIcon = iconFactory.fromDrawable(iconDrawable);

                //slope rating associated

                //Credits(1)
                Drawable iconDrawable2 = ContextCompat.getDrawable(MaintenanceMapActivity.this, R.mipmap.ic_mmblue);
                Icon blueIcon = iconFactory.fromDrawable(iconDrawable2);

                //for all of the sites....
                for(int k = 0; k<finalSites.length; k++) {
                    Icon chosenIcon = blueIcon;  //automatically set to be associated
                    //need to convert lat/long values from string -> double to be used to place site
                    double latitude = Double.parseDouble(finalSites[k][2]);
                    double longitude = Double.parseDouble(finalSites[k][3]);
                    //no slope rating associated
                    if(finalSites[k][1].equals("0")){
                        chosenIcon = whiteIcon;
                    // else yes slope rating associated
                    }

                    //String finalScore = finalSites[k][4];
                    //add a new marker
                    mapboxMap.addMarker(new MarkerOptions()
                            .position(new LatLng(latitude, longitude))
                            //set title as site_id
                            .title(finalSites[k][1])
                            .setIcon(chosenIcon)
                            //.snippet("Code" + finalSites[k][4]));
                            //set snippet as id
                            .snippet(finalSites[k][0]));
                            //.icon(icon0));

                }

                //long click on the map
                mapboxMap.setOnMapLongClickListener(new MapboxMap.OnMapLongClickListener() {
                    @Override
                    public void onMapLongClick(@NonNull LatLng point) {
                        //add a new marker to create a new maintenance form
                        mapboxMap.addMarker(new MarkerOptions()
                            .position(point)
                            .title("New Maintenance Form")
                            .snippet("Click to add site")
                        );


                    }

                });
                //long click on info window on existing site
                mapboxMap.setOnInfoWindowLongClickListener(new MapboxMap.OnInfoWindowLongClickListener() {
                    @Override
                    public void onInfoWindowLongClick(Marker marker) {
                        //go to the maintenance form....fill if necessary
                        if (marker.getTitle().equals("New Maintenance Form")){
                            newOld = false; //don't have to do anything.....
                        }else{
                            //newOld = true;
                            load_id=marker.getSnippet();
                        }
                        //pull up the maintenance form
                        Intent intent = new Intent(MaintenanceMapActivity.this, MaintenanceActivity.class);
                        startActivity(intent);
                    }
                }
                );
            }

        });
    }
}
