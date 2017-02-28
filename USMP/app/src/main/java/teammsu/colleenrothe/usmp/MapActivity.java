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

    //offline func
    private OfflineManager offlineManager;
    private OfflineRegion offlineRegion;


    private boolean offline = true;

    private boolean isEndNotified;
    private ProgressBar progressBar;
    private int regionSelected;


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
            final TextView tv = new TextView(this);
            tv.setText("Corner Coordinates for saved map area", TextView.BufferType.NORMAL);
            final EditText neLat = new EditText(this);
            neLat.setHint("NE Corner latitude");
            final EditText neLong = new EditText(this);
            neLong.setHint("NE Corner longitude");
            final EditText swLat = new EditText(this);
            swLat.setHint("SW Corner Latitude");
            final EditText swLong = new EditText(this);
            swLong.setHint("SW Corner Longitude");

            LatLngBounds bounds = map.getProjection().getVisibleRegion().latLngBounds;


            layout.addView(tv);
            layout.addView(neLat);
            layout.addView(neLong);
            layout.addView(swLat);
            layout.addView(swLong);

            alertDialogBuilder.setView(layout);


            alertDialogBuilder.setCancelable(true).setPositiveButton("OK", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
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
        if (id == R.id.action_clear_cache) {
            return true;
        }
        if (id == R.id.action_cache_status) {
            downloadedRegionList();
        }
        if (id == R.id.action_load_offline_points) {
            return true;
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

    public void downloadRegion(){
        System.out.println("DOWNLOAD");
        final String regionName = "testRegion";
        startProgress();
        System.out.println(mapView.getMarkerViewsInBounds(map.getProjection().getVisibleRegion().latLngBounds).size());

        // Create offline definition using the current
        // style and boundaries of visible map area
        String styleUrl = map.getStyleUrl();
        LatLngBounds bounds = map.getProjection().getVisibleRegion().latLngBounds;
        double minZoom = map.getCameraPosition().zoom;
        double maxZoom = map.getMaxZoom();
        float pixelRatio = this.getResources().getDisplayMetrics().density;
        OfflineTilePyramidRegionDefinition definition = new OfflineTilePyramidRegionDefinition(
                styleUrl, bounds, minZoom, maxZoom, pixelRatio);
        // Build a JSONObject using the user-defined offline region title,
        // convert it into string, and use it to create a metadata variable.
        // The metadata varaible will later be passed to createOfflineRegion()
        byte[] metadata;
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(JSON_FIELD_REGION_NAME, regionName);
            String json = jsonObject.toString();
            metadata = json.getBytes(JSON_CHARSET);
        } catch (Exception exception) {
            Log.e(TAG, "Failed to encode metadata: " + exception.getMessage());
            metadata = null;
        }
        // Create the offline region and launch the download
        offlineManager.createOfflineRegion(definition, metadata, new OfflineManager.CreateOfflineRegionCallback() {
            @Override
            public void onCreate(OfflineRegion offlineRegion) {
                Log.d(TAG, "Offline region created: " + regionName);
                MapActivity.this.offlineRegion = offlineRegion;
                launchDownload();
            }

            @Override
            public void onError(String error) {
                Log.e(TAG, "Error: " + error);
            }
        });
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
            Intent intent = new Intent(this, MainActivity.class);
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
