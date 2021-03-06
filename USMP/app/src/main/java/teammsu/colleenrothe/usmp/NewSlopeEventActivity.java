package teammsu.colleenrothe.usmp;

/* Class for the new slope event form
CREDITS:
    (1) Check network connectivity
        http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity
    (2) Image dialog popup
        http://stackoverflow.com/questions/7693633/android-image-dialog-popup
    (3) Upload an image
        https://github.com/square/okhttp/wiki/Recipes
    (4) Compress image size
        http://www.android-examples.com/compress-bitmap-image-in-android-and-reduce-image-size/
    (5) Image picker library
        https://github.com/darsh2/MultipleImageSelect
*/

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
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
import android.view.ViewTreeObserver;
import android.view.Window;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.CheckBox;
import android.widget.Button;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;
import java.io.IOException;
import android.net.Uri;
import android.provider.MediaStore;
import android.widget.ImageView;
import android.view.ViewGroup;
import android.graphics.drawable.*;
import android.widget.RelativeLayout;
import com.darsh.multipleimageselect.activities.AlbumSelectActivity;
import com.darsh.multipleimageselect.helpers.Constants;
import com.darsh.multipleimageselect.models.Image;
import com.squareup.okhttp.Headers;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.MultipartBuilder;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;
import java.util.ArrayList;
import java.io.ByteArrayOutputStream;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class NewSlopeEventActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    EditText ObserverName;
    EditText Email;
    EditText PhoneNo;
    EditText ObserverComments;
    TextView TodaysDate;
    //for date of event
    private DatePicker datePicker;
    private Calendar calendar;
    private TextView dateView;
    private int year, month, day;
    Spinner dateApprox;
    Spinner NSEHazardType;
    Spinner State;
    EditText NSEroadTrailNo;
    Spinner NSERoadTrail;
    EditText NSEbeginMile;
    EditText NSEendMile;
    EditText NSEDatum;
    EditText NSELat;
    EditText NSELong;
    Spinner AfterFailure;
    EditText NSELengthAffected;
    Spinner largestRock;
    Spinner NumFallen;
    Spinner Debris;
    //description of event location
    CheckBox AboveRT;
    CheckBox BelowRT;
    CheckBox Culvert;
    CheckBox AboveRiver;
    CheckBox AboveCoast;
    CheckBox BurnedArea;
    CheckBox Deforested;
    CheckBox Urban;
    CheckBox Mine;
    CheckBox Retaining;
    CheckBox NaturalSlope;
    CheckBox Engineered;
    CheckBox Unknown;
    CheckBox Other;
    //possible cause of event
    CheckBox Rain;
    CheckBox Thunderstorm;
    CheckBox Continuous;
    CheckBox Hurricane;
    CheckBox Flooding;
    CheckBox Snowfall;
    CheckBox Prolonged;
    CheckBox HighTemp;
    CheckBox Earthquake;
    CheckBox Volcanic;
    CheckBox Leaking;
    CheckBox Mining;
    CheckBox Construction;
    CheckBox Dam;
    CheckBox NoObvious;
    CheckBox UnknownCause;
    CheckBox SecondOther;

    Spinner Damages;
    TextView DamagesComments;

    Button SubmitButton;
    ScrollView NSEScroll;

    //Images
    ArrayList<Image> selectedImages;
    Uri imageUri;
    String [] savedImagePaths;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //provided
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_slope_event);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //UI Connection
        SubmitButton = (Button) findViewById(R.id.NSESubmitButton);
        NSEScroll = (ScrollView)findViewById(R.id.NSEScroll);

        NSEScroll.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
            @Override
            public void onScrollChanged() {
                if (!isNetworkAvailable()) {
                    SubmitButton.setBackgroundColor(Color.DKGRAY);
                    SubmitButton.setClickable(false);
                }

                //check for level 2 - read only
                if(LoginActivity.permissions == 2){
                    SubmitButton.setBackgroundColor(Color.DKGRAY);
                    SubmitButton.setClickable(false);
                }

            }
        });

        ObserverName = (EditText) findViewById(R.id.ObserverName);
        Email = (EditText) findViewById(R.id.Email);
        PhoneNo = (EditText) findViewById(R.id.PhoneNo);
        ObserverComments = (EditText) findViewById(R.id.ObserverComments);

        //today's date
        TodaysDate = (TextView)findViewById(R.id.TodaysDate);
        Calendar cal = Calendar.getInstance(TimeZone.getDefault());

        SimpleDateFormat sdf = new SimpleDateFormat("dd:MMMM:yyyy HH:mm:ss a");
        String strDate = sdf.format(cal.getTime());

        TodaysDate.setText(strDate, TextView.BufferType.EDITABLE );

        dateApprox = (Spinner) findViewById(R.id.DateApprox);

        //date of event
        dateView = (TextView) findViewById(R.id.EventDate);
        calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);

        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DAY_OF_MONTH);
        showDate(year, month+1, day);

        NSEHazardType = (Spinner) findViewById(R.id.NSEHazardType);
        NSEHazardType.setFocusable(true);
        NSEHazardType.setFocusableInTouchMode(true);

        State = (Spinner) findViewById(R.id.State);
        NSEroadTrailNo = (EditText) findViewById(R.id.NSEroadTrailNo);

        NSERoadTrail = (Spinner) findViewById(R.id.NSEroadTrail);
        NSERoadTrail.setFocusable(true);
        NSERoadTrail.setFocusableInTouchMode(true);

        NSEbeginMile = (EditText) findViewById(R.id.NSEbeginMile);
        NSEendMile = (EditText) findViewById(R.id.NSEendMile);
        NSEDatum = (EditText) findViewById(R.id.NSEDatum);
        NSELat = (EditText) findViewById(R.id.NSELat);
        NSELong = (EditText) findViewById(R.id.NSELong);

        AfterFailure = (Spinner) findViewById(R.id.AfterFailure);
        AfterFailure.setFocusable(true);
        AfterFailure.setFocusableInTouchMode(true);

        NSELengthAffected = (EditText) findViewById(R.id.NSELengthAffected);

        largestRock = (Spinner) findViewById(R.id.largestRock);
        largestRock.setFocusable(true);
        largestRock.setFocusableInTouchMode(true);

        NumFallen = (Spinner) findViewById(R.id.NumFallen);
        Debris = (Spinner) findViewById(R.id.Debris);

        //description of event location
        AboveRT = (CheckBox) findViewById(R.id.AboveRT);
        BelowRT = (CheckBox) findViewById(R.id.BelowRT);
        Culvert = (CheckBox) findViewById(R.id.Culvert);
        AboveRiver = (CheckBox) findViewById(R.id.AboveRiver);
        AboveCoast = (CheckBox) findViewById(R.id.AboveCoast);
        BurnedArea = (CheckBox) findViewById(R.id.BurnedArea);
        Deforested = (CheckBox) findViewById(R.id.Deforested);
        Urban = (CheckBox) findViewById(R.id.Urban);
        Mine = (CheckBox) findViewById(R.id.Mine);
        Retaining = (CheckBox) findViewById(R.id.Retaining);
        NaturalSlope = (CheckBox) findViewById(R.id.NaturalSlope);
        Engineered = (CheckBox) findViewById(R.id.Engineered);
        Unknown = (CheckBox) findViewById(R.id.Unknown);
        Other = (CheckBox) findViewById(R.id.Other);

        //possible cause of event
        Rain = (CheckBox) findViewById(R.id.Rain);
        Thunderstorm = (CheckBox) findViewById(R.id.Thunderstorm);
        Continuous = (CheckBox) findViewById(R.id.Continuous);
        Hurricane = (CheckBox) findViewById(R.id.Hurricane);
        Flooding = (CheckBox) findViewById(R.id.Flooding);
        Snowfall = (CheckBox) findViewById(R.id.Snowfall);
        Prolonged = (CheckBox) findViewById(R.id.Prolonged);
        HighTemp = (CheckBox) findViewById(R.id.HighTemp);
        Earthquake = (CheckBox) findViewById(R.id.Earthquake);
        Volcanic = (CheckBox) findViewById(R.id.Volcanic);
        Leaking = (CheckBox) findViewById(R.id.Leaking);
        Mining = (CheckBox) findViewById(R.id.Mining);
        Construction = (CheckBox) findViewById(R.id.Construction);
        Dam = (CheckBox) findViewById(R.id.Dam);
        NoObvious = (CheckBox) findViewById(R.id.NoObvious);
        UnknownCause = (CheckBox) findViewById(R.id.UnknownCause);
        SecondOther = (CheckBox) findViewById(R.id.SecondOther);

        Damages = (Spinner) findViewById(R.id.Damages);
        DamagesComments = (TextView) findViewById(R.id.DamagesComments);

        //provided
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //LOAD
        if (OfflineList.selected_row!=-1 && OfflineList.should_load==true){
            OfflineList.should_load=false;
            lookupNSE(OfflineList.selected_row);
        }

    }

    //CREDITS(1)
    public boolean isNetworkAvailable() {
        ConnectivityManager cm = (ConnectivityManager)
                getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = cm.getActiveNetworkInfo();
        // if no network is available networkInfo will be null
        // otherwise check if we are connected
        if (networkInfo != null && networkInfo.isConnected()) {
            return true;
        }
        return false;
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
        getMenuInflater().inflate(R.menu.new_slope_event, menu);
        getMenuInflater().inflate(R.menu.menu_main, menu);

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

    //date picker auto-generated
    @SuppressWarnings("deprecation")
    public void setDate(View view) {
        showDialog(999);
        Toast.makeText(getApplicationContext(), "ca", Toast.LENGTH_SHORT)
                .show();
    }

    @Override
    protected Dialog onCreateDialog(int id) {
        // TODO Auto-generated method stub
        if (id == 999) {
            return new DatePickerDialog(this, myDateListener, year, month, day);
        }
        return null;
    }

    private DatePickerDialog.OnDateSetListener myDateListener = new DatePickerDialog.OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
            // arg1 = year
            // arg2 = month
            // arg3 = day
            showDate(arg1, arg2+1, arg3);
        }
    };

    private void showDate(int year, int month, int day) {
        dateView.setText(new StringBuilder().append(day).append("/")
                .append(month).append("/").append(year));
    }

    //information popup
    public void popup1(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("Save forms while offline. See what forms you have saved on the list. " +
                "Clear a form when it isn't needed or load a form to double-check the information. " +
                "Submit form(s) once you are back online.");

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

    //Submit NSE form
    public void NSE_Submit(View view) throws Exception {

        Thread thread = new Thread(new Runnable() {

            @Override
            public void run() {
                try  {
                    //new connection
                    URL url = new URL("http://nl.cs.montana.edu/usmp/server/new_slope_event/add_new_slope_event.php");
                    URLConnection conn = url.openConnection();
                    conn.setDoOutput(true);
                    OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
                    //get all fo the values
                    String observer_name = String.valueOf(ObserverName.getText());
                    String email = String.valueOf(Email.getText());
                    String phone_no = String.valueOf(PhoneNo.getText());
                    String comments = String.valueOf(ObserverComments.getText());
                    //String date?
                    String approxDate = "";
                    if(dateApprox.getSelectedItem().toString().equals("Known")){
                        approxDate = "K";
                    }
                    else if(dateApprox.getSelectedItem().toString().equals("Approximately")){
                        approxDate= "A";
                    }
                    else{ //unknown
                        approxDate= "U";
                    }

                    String date_input = String.valueOf(dateView.getText()); //as date?

                    String hazard_type = "";

                    //check these....
                    if(NSEHazardType.getSelectedItem().toString().equals("Rockfall")){
                        hazard_type= "R";

                    }
                    else if(NSEHazardType.getSelectedItem().toString().equals("Landslide")){
                        hazard_type= "L";

                    }
                    else if(NSEHazardType.getSelectedItem().toString().equals("Debris Flow")){
                            hazard_type= "D";
                    }
                    else{ //snow avalanche
                        hazard_type= "S";

                    }

                    String state = State.getSelectedItem().toString();
                    String road_trail_number = String.valueOf(NSEroadTrailNo.getText());
                    String rt_type = "R";
                    if(NSERoadTrail.getSelectedItem().toString().equals("Trail")){
                        rt_type="T";
                    }
                    String begin_mile_marker = String.valueOf(NSEbeginMile.getText());
                    String end_mile_marker = String.valueOf(NSEendMile.getText());
                    String datum = String.valueOf(NSEDatum.getText());
                    String coordinate_latitude = String.valueOf(NSELat);
                    String coordinate_longitude = String.valueOf(NSELong);

                    //check these values...
                    String condition = "";
                    if(AfterFailure.getSelectedItem().toString().equals("Blocked")){
                        condition = "Blocked";
                    }
                    else if (AfterFailure.getSelectedItem().toString().equals("Blocked, detours exist around failure")){
                        condition = "Blocked, detours exist around";
                    }
                    else if (AfterFailure.getSelectedItem().toString().equals("Partially blocked but passable")){
                        condition = "Partially blocked but passable";
                    }
                    else if (AfterFailure.getSelectedItem().toString().equals("Ditch full of debris")){

                        condition = "Ditch full of debris";
                    }
                    else{ //Route threatened by unstable slope
                        condition = "Route threatened";
                    }

                    String lengthAffected = String.valueOf(NSELengthAffected.getText());
                    String size_rock = "";
                    if(largestRock.getSelectedItemPosition()==0){
                        size_rock=">3in";
                    }
                    else if(largestRock.getSelectedItemPosition()==1){
                        size_rock=">1ft";

                    }
                    else if(largestRock.getSelectedItemPosition()==2){
                        size_rock="1-3ft";

                    }
                    else if(largestRock.getSelectedItemPosition()==3){
                        size_rock=">3ft";

                    }

                    String num_fallen_rocks = "";
                    if(NumFallen.getSelectedItemPosition() == 0){
                        num_fallen_rocks = "1";
                    }
                    else if(NumFallen.getSelectedItemPosition() == 1){
                        num_fallen_rocks = "2";
                    }
                    else if(NumFallen.getSelectedItemPosition() ==2){
                        num_fallen_rocks = "3-5";
                    }
                    else if(NumFallen.getSelectedItemPosition() == 3){
                        num_fallen_rocks = "5-10";
                    }
                    else if(NumFallen.getSelectedItemPosition() == 4){
                        num_fallen_rocks = "10+";
                    }
                    String vol_debris = "";
                    if(Debris.getSelectedItemPosition()==0){
                        vol_debris = "<5ft^3";
                    }
                    else if(Debris.getSelectedItemPosition()==1){
                        vol_debris = "<2.5yds^3";
                    }
                    else if(Debris.getSelectedItemPosition()==2){
                        vol_debris = "<10yds^3";
                    }
                    else if(Debris.getSelectedItemPosition()==3){
                        vol_debris = ">10yds^3";
                    }

                    //description of event location

                    String above_road = "0";
                    if (AboveRT.isChecked()){
                        above_road = "1";
                    }
                    String below_road = "0";
                    if (BelowRT.isChecked()){
                        below_road = "1";
                    }
                    String at_culvert = "0";
                    if (Culvert.isChecked()){
                        at_culvert = "1";
                    }
                    String above_river = "0";
                    if (AboveRiver.isChecked()){
                        above_river = "1";
                    }
                    String above_coast = "0";
                    if (AboveCoast.isChecked()){
                        above_coast = "1";
                    }
                    String burned_area = "0";
                    if (BurnedArea.isChecked()){
                        burned_area = "1";
                    }
                    String deforested_slope = "0";
                    if (Deforested.isChecked()){
                        deforested_slope = "1";
                    }
                    String urban = "0";
                    if (Urban.isChecked()){
                        urban = "1";
                    }
                    String mine = "0";
                    if (Mine.isChecked()){
                        mine = "1";
                    }
                    String retaining_wall = "0";
                    if (Retaining.isChecked()){
                        retaining_wall = "1";
                    }
                    String natural_slope = "0";
                    if (NaturalSlope.isChecked()){
                        natural_slope = "1";
                    }
                    String engineered_slope = "0";
                    if (Engineered.isChecked()){
                        engineered_slope = "1";
                    }
                    String unknown = "0";
                    if (Unknown.isChecked()){
                        unknown = "1";
                    }
                    String other = "0";
                    if (Other.isChecked()){
                        other = "1";
                    }

                    //possible cause of event
                    String rain_checkbox = "0";
                    if (Rain.isChecked()){
                        rain_checkbox = "1";
                    }
                    String thunder_checkbox = "0";
                    if (Thunderstorm.isChecked()){
                        thunder_checkbox = "1";
                    }
                    String cont_rain_checkbox = "0";
                    if (Continuous.isChecked()){
                        cont_rain_checkbox = "1";
                    }
                    String hurricane_checkbox = "0";
                    if (Hurricane.isChecked()){
                        hurricane_checkbox = "1";
                    }
                    String flood_checkbox = "0";
                    if (Flooding.isChecked()){
                        flood_checkbox = "1";
                    }
                    String snowfall_checkbox = "0";
                    if (Snowfall.isChecked()){
                        snowfall_checkbox = "1";
                    }
                    String freezing_checkbox = "0";
                    if (Prolonged.isChecked()){
                        freezing_checkbox = "1";
                    }
                    String high_temp_checkbox = "0";
                    if (HighTemp.isChecked()){
                        high_temp_checkbox = "1";
                    }
                    String earthquake_checkbox = "0";
                    if (Earthquake.isChecked()){
                        earthquake_checkbox = "1";
                    }
                    String volcano_checkbox = "0";
                    if (Volcanic.isChecked()){
                        volcano_checkbox = "1";
                    }
                    String leaky_pipe_checkbox = "0";
                    if (Leaking.isChecked()){
                        leaky_pipe_checkbox = "1";
                    }
                    String mining_checkbox = "0";
                    if (Mining.isChecked()){
                        mining_checkbox = "1";
                    }
                    String construction_checkbox = "0";
                    if (Construction.isChecked()){
                        construction_checkbox = "1";
                    }
                    String dam_embankment_collapse_checkbox = "0";
                    if (Dam.isChecked()){
                        dam_embankment_collapse_checkbox = "1";
                    }
                    String not_obvious_checkbox = "0";
                    if (NoObvious.isChecked()){
                        not_obvious_checkbox = "1";
                    }
                    String unknown_checkbox = "0";
                    if (UnknownCause.isChecked()){
                        unknown_checkbox = "1";
                    }
                    String other_checkbox = "0";
                    if (SecondOther.isChecked()){
                        other_checkbox = "1";
                    }

                    String damages_y_n = "N";
                    if(Damages.getSelectedItemPosition() == 1){
                        damages_y_n="Y";
                    }

                    String damages = String.valueOf(DamagesComments.getText());

                    writer.write("observer_name="+observer_name+"&email="+email+"&phone_no="+phone_no+"&observer_comments="+comments+
                    "&date_approximator="+approxDate+"&date_input="+date_input+"&hazard_type="+hazard_type+"&state="+state+"&road_trail_number="+
                    road_trail_number+"&rt_type="+rt_type+"&begin_mile_marker="+begin_mile_marker+"&end_mile_marker="+end_mile_marker+"&datum="+datum+
                    "&coordinate_latitude="+coordinate_latitude+"&coordinate_longitude="+coordinate_longitude+"&condition="+condition+
                    "&affected_length="+lengthAffected+"&size_rock="+size_rock+"&num_fallen_rocks="+num_fallen_rocks+"&vol_debris="+vol_debris+
                    "&above_road="+above_road+"&below_road="+below_road+"&at_culvert="+at_culvert+"&above_river="+above_river+"&above_coast="+
                    above_coast+"&burned_area="+burned_area+"&deforested_slope="+deforested_slope+"&urban="+urban+"&mine="+mine+"retaining_wall="+
                    retaining_wall+"&natural_slope="+natural_slope+"&engineered_slope="+engineered_slope+"&unknown="+unknown+"&other="+other+
                    "&rain_checkbox="+rain_checkbox+"&thunder_checkbox="+thunder_checkbox+"&cont_rain_checkbox="+cont_rain_checkbox+"&hurricane_checkbox="+
                    hurricane_checkbox+"&flood_checkbox="+flood_checkbox+"&snowfall_checkbox="+snowfall_checkbox+"&freezing_checkbox="+freezing_checkbox+
                    "&high_temp_checkbox="+high_temp_checkbox+"&earthquake_checkbox="+earthquake_checkbox+"&volcano_checkbox="+volcano_checkbox+
                    "&leaky_pipe_checkbox="+leaky_pipe_checkbox+"&mining_checkbox="+mining_checkbox+"&construction_checkbox"+construction_checkbox+
                    "&dam_embankment_collapse_checkbox="+dam_embankment_collapse_checkbox+"&not_obvious_checkbox="+not_obvious_checkbox+
                    "&unknown_checkbox="+unknown_checkbox+"&other_checkbox="+other_checkbox+"&damages_y_n="+damages_y_n+"&damages="+damages);
                    writer.flush();
                    String line;
                    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    while ((line = reader.readLine()) != null) {
                        System.out.println(line);
                    }
                    writer.close();
                    reader.close();
                    uploadImage();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        thread.start();


    }

    //create a new NSE form to save offline
    public void newNSE(View view){
        NewSlopeEventDBHandler dbHandler = new NewSlopeEventDBHandler(this, null, null, 1);

        String observer_name = ObserverName.getText().toString();
        String email = Email.getText().toString();
        String phone_no = PhoneNo.getText().toString();
        String comments = ObserverComments.getText().toString();
        String date = TodaysDate.getText().toString();
        int date_approximator = dateApprox.getSelectedItemPosition();
        String dateInput = dateView.getText().toString(); //??
        int hazard_type = NSEHazardType.getSelectedItemPosition();
        int state = State.getSelectedItemPosition();



        //save photos

        String tempPhotos = "";

        if(selectedImages != null){
            for(int i=0; i<selectedImages.size(); i++){
                if(i==0){
                    tempPhotos = tempPhotos.concat(selectedImages.get(i).path);
                }
                else{
                    tempPhotos = tempPhotos.concat(",");
                    tempPhotos = tempPhotos.concat(selectedImages.get(i).path);
                }
            }
        }
        String photos = tempPhotos;

        String road_trail_number = NSEroadTrailNo.getText().toString();
        int rt_type = NSERoadTrail.getSelectedItemPosition();
        String begin_mile_marker = NSEbeginMile.getText().toString();
        String end_mile_marker = NSEendMile.getText().toString();
        String datum = NSEDatum.getText().toString();
        String coordinate_latitude = NSELat.getText().toString();
        String coordinate_longitude=NSELong.getText().toString();
        int condition = AfterFailure.getSelectedItemPosition();
        String affected_length = NSELengthAffected.getText().toString();
        int size_rock = largestRock.getSelectedItemPosition();
        int num_fallen_rocks = NumFallen.getSelectedItemPosition();
        int vol_debris = Debris.getSelectedItemPosition();

        //0=false
        //1=true

        int above_road = 0;
        if (AboveRT.isChecked()){
            above_road=1;
        }

        int below_road = 0;
        if (BelowRT.isChecked()){
            below_road=1;
        }

        int at_culvert = 0;
        if (Culvert.isChecked()){
            at_culvert=1;
        }

        int above_river = 0;
        if (AboveRiver.isChecked()){
            above_river=1;
        }

        int above_coast = 0;
        if (AboveCoast.isChecked()){
            above_coast=1;
        }

        int burned_area = 0;
        if (BurnedArea.isChecked()){
            burned_area=1;
        }

        int deforested_slope = 0;
        if (Deforested.isChecked()){
            deforested_slope=1;
        }

        int urban = 0;
        if (Urban.isChecked()){
            urban=1;
        }

        int mine = 0;
        if (Mine.isChecked()){
            mine=1;
        }

        int retaining_wall = 0;
        if (Retaining.isChecked()){
            retaining_wall=1;
        }

        int natural_slope = 0;
        if (NaturalSlope.isChecked()){
            natural_slope=1;
        }

        int engineered_slope = 0;
        if (Engineered.isChecked()){
            engineered_slope=1;
        }

        int unknown = 0;
        if (Unknown.isChecked()){
            unknown=1;
        }

        int other = 0;
        if (Other.isChecked()){
            other=1;
        }

        //0=false
        //1=true

        int rain_checkbox = 0;
        if (Rain.isChecked()){
            rain_checkbox=1;
        }

        int thunder_checkbox = 0;
        if (Thunderstorm.isChecked()){
            thunder_checkbox=1;
        }

        int cont_rain_checkbox = 0;
        if (Continuous.isChecked()){
            cont_rain_checkbox=1;
        }

        int hurricane_checkbox = 0;
        if (Hurricane.isChecked()){
            hurricane_checkbox=1;
        }

        int flood_checkbox = 0;
        if (Flooding.isChecked()){
            flood_checkbox=1;
        }

        int snowfall_checkbox = 0;
        if (Snowfall.isChecked()){
            snowfall_checkbox=1;
        }

        int freezing_checkbox = 0;
        if (Prolonged.isChecked()){
            freezing_checkbox=1;
        }

        int high_temp_checkbox = 0;
        if (HighTemp.isChecked()){
            high_temp_checkbox=1;
        }

        int earthquake_checkbox = 0;
        if (Earthquake.isChecked()){
            earthquake_checkbox=1;
        }

        int volcano_checkbox = 0;
        if (Volcanic.isChecked()){
            volcano_checkbox=1;
        }

        int leaky_pipe_checkbox = 0;
        if (Leaking.isChecked()){
            leaky_pipe_checkbox=1;
        }

        int mining_checkbox = 0;
        if (Mining.isChecked()){
            mining_checkbox=1;
        }

        int construction_checkbox = 0;
        if (Construction.isChecked()){
            construction_checkbox=1;
        }

        int dam_embankment_collapse_checkbox = 0;
        if (Dam.isChecked()){
            dam_embankment_collapse_checkbox=1;
        }

        int not_obvious_checkbox = 0;
        if (NoObvious.isChecked()){
            not_obvious_checkbox=1;
        }

        int unknown_checkbox = 0;
        if (UnknownCause.isChecked()){
            unknown_checkbox=1;
        }

        int other_checkbox = 0;
        if (SecondOther.isChecked()){
            other_checkbox=1;
        }

        int damages_y_n = Damages.getSelectedItemPosition();
        String damages = DamagesComments.getText().toString();

        NewSlopeEvent nse = new NewSlopeEvent(observer_name,email,phone_no,date,date_approximator,
                dateInput,hazard_type,state,photos,road_trail_number,rt_type,begin_mile_marker,
                end_mile_marker,datum,coordinate_latitude,coordinate_longitude,condition,affected_length,
                size_rock,num_fallen_rocks,vol_debris,above_road,below_road,at_culvert,above_river,
                above_coast,burned_area,deforested_slope,urban,mine,retaining_wall,natural_slope,
                engineered_slope,unknown,other,rain_checkbox,thunder_checkbox,cont_rain_checkbox,
                hurricane_checkbox,flood_checkbox,snowfall_checkbox,freezing_checkbox,high_temp_checkbox,
                earthquake_checkbox,volcano_checkbox,leaky_pipe_checkbox,mining_checkbox,construction_checkbox,dam_embankment_collapse_checkbox,
                not_obvious_checkbox,unknown_checkbox,other_checkbox,damages_y_n,damages,comments);
        dbHandler.addNewSlopeEvent(nse);

        //set everything empty to start over

        ObserverName.setText("");
        Email.setText("");
        PhoneNo.setText("");
        //date...still today so ok
        ObserverComments.setText("");
        dateApprox.setSelection(0);
        dateView.setText("");
        NSEHazardType.setSelection(0);
        State.setSelection(0);
        //photos...
        NSEroadTrailNo.setText("");
        NSERoadTrail.setSelection(0);
        NSEbeginMile.setText("");
        NSEendMile.setText("");
        NSEDatum.setText("");
        NSELat.setText("");
        NSELong.setText("");
        AfterFailure.setSelection(0);
        NSELengthAffected.setText("");
        largestRock.setSelection(0);
        NumFallen.setSelection(0);
        Debris.setSelection(0);

        if(AboveRT.isChecked()){
            AboveRT.toggle();
        }

        if(BelowRT.isChecked()){
            BelowRT.toggle();
        }

        if(Culvert.isChecked()){
            Culvert.toggle();
        }

        if(AboveRiver.isChecked()){
            AboveRiver.toggle();
        }

        if(AboveCoast.isChecked()){
            AboveCoast.toggle();
        }

        if(BurnedArea.isChecked()){
            BurnedArea.toggle();
        }

        if(Deforested.isChecked()){
            Deforested.toggle();
        }

        if(Urban.isChecked()){
            Urban.toggle();
        }

        if(Mine.isChecked()){
            Mine.toggle();
        }

        if(Retaining.isChecked()){
            Retaining.toggle();
        }

        if(NaturalSlope.isChecked()){
            NaturalSlope.toggle();
        }

        if(Engineered.isChecked()){
            Engineered.toggle();
        }

        if(Unknown.isChecked()){
            Unknown.toggle();
        }

        if(Other.isChecked()){
            Other.toggle();
        }

        ////////////////////////

        if(Rain.isChecked()){
            Rain.toggle();
        }

        if(Thunderstorm.isChecked()){
            Thunderstorm.toggle();
        }

        if(Continuous.isChecked()){
            Continuous.toggle();
        }

        if(Hurricane.isChecked()){
            Hurricane.toggle();
        }

        if(Flooding.isChecked()){
            Flooding.toggle();
        }

        if(Snowfall.isChecked()){
            Snowfall.toggle();
        }

        if(Prolonged.isChecked()){
            Prolonged.toggle();
        }

        if(HighTemp.isChecked()){
            HighTemp.toggle();
        }

        if(Earthquake.isChecked()){
            Earthquake.toggle();
        }

        if(Volcanic.isChecked()){
            Volcanic.toggle();
        }

        if(Leaking.isChecked()){
            Leaking.toggle();
        }

        if(Mining.isChecked()){
            Mining.toggle();
        }

        if(Construction.isChecked()){
            Construction.toggle();
        }

        if(Dam.isChecked()){
            Dam.toggle();
        }

        if(NoObvious.isChecked()){
            NoObvious.toggle();
        }

        if(UnknownCause.isChecked()){
            UnknownCause.toggle();
        }

        if(SecondOther.isChecked()){
            SecondOther.toggle();
        }

        Damages.setSelection(0);
        DamagesComments.setText("");


    }

    //find an nse form by unique id
    public void lookupNSE(int finder){
        NewSlopeEventDBHandler dbHandler = new NewSlopeEventDBHandler(this, null, null, 1);

        NewSlopeEvent nse = dbHandler.findNSE(finder);

        //set everything
        if (nse != null) {
            ObserverName.setText(nse.getObserver_name());
            Email.setText(nse.getEmail());
            PhoneNo.setText(nse.getPhone_no());
            ObserverComments.setText(nse.getComments());
            TodaysDate.setText(nse.getDate());
            dateApprox.setSelection(nse.getDate_approximator());
            dateView.setText(nse.getDateinput());
            NSEHazardType.setSelection(nse.getHazard_type());
            State.setSelection(nse.getState());

            String tempPhoto = nse.getPhotos();
            savedImagePaths = tempPhoto.split(",");

            NSEroadTrailNo.setText(nse.getRoad_trail_number());
            NSERoadTrail.setSelection(nse.getRt_type());
            NSEbeginMile.setText(nse.getBegin_mile_marker());
            NSEendMile.setText(nse.getEnd_mile_marker());
            NSEDatum.setText(nse.getDatum());
            NSELat.setText(nse.getCoordinate_latitude());
            NSELong.setText(nse.getCoordinate_longitude());
            AfterFailure.setSelection(nse.getCondition());
            NSELengthAffected.setText(String.valueOf(nse.getAffected_length()));
            largestRock.setSelection(nse.getSize_rock());
            NumFallen.setSelection(nse.getNum_fallen_rocks());
            Debris.setSelection(nse.getVol_debris());

            //1 is checked...assuming that all are unchecked....
            if(nse.getAbove_road() == 1){
                AboveRT.toggle();
            }

            if(nse.getBelow_road() == 1){
                BelowRT.toggle();
            }

            if(nse.getAt_culvert() == 1){
                Culvert.toggle();
            }

            if(nse.getAbove_river() == 1){
                AboveRiver.toggle();
            }
            if(nse.getAbove_coast() == 1){
                AboveCoast.toggle();
            }
            if(nse.getBurned_area() == 1){
                BurnedArea.toggle();
            }
            if(nse.getDeforested_slope() == 1){
                Deforested.toggle();
            }
            if(nse.getUrban() == 1){
                Urban.toggle();
            }
            if(nse.getMine() == 1){
                Mine.toggle();
            }
            if(nse.getRetaining_wall() == 1){
                Retaining.toggle();
            }
            if(nse.getNatural_slope() == 1){
                NaturalSlope.toggle();
            }
            if(nse.getEngineered_slope() == 1){
                Engineered.toggle();
            }
            if(nse.getUnknown() == 1){
                Unknown.toggle();
            }
            if(nse.getOther() == 1){
                Other.toggle();
            }
            //////////////////////////////////////
            if(nse.getRain_checkbox() == 1){
                Rain.toggle();
            }
            if(nse.getThunder_checkbox() == 1){
                Thunderstorm.toggle();
            }
            if(nse.getCont_rain_checkbox() == 1){
                Continuous.toggle();
            }
            if(nse.getHurricane_checkbox() == 1){
                Hurricane.toggle();
            }
            if(nse.getFlood_checkbox() == 1){
                Flooding.toggle();
            }
            if(nse.getSnowfall_checkbox() == 1){
                Snowfall.toggle();
            }
            if(nse.getFreezing_checkbox() == 1){
                Prolonged.toggle();
            }
            if(nse.getHigh_temp_checkbox() == 1){
                HighTemp.toggle();
            }
            if(nse.getEarthquake_checkbox() == 1){
                Earthquake.toggle();
            }
            if(nse.getVolcano_checkbox() == 1){
                Volcanic.toggle();
            }
            if(nse.getLeaky_pipe_checkbox() == 1){
                Leaking.toggle();
            }
            if(nse.getMining_checkbox() == 1){
                Mining.toggle();
            }
            if(nse.getConstruction_checkbox() == 1){
                Construction.toggle();
            }
            if(nse.getDam_embankment_collapse_checkbox() == 1){
                Dam.toggle();
            }
            if(nse.getNot_obvious_checkbox() == 1){
                NoObvious.toggle();
            }
            if(nse.getUnknown_checkbox() == 1){
                UnknownCause.toggle();
            }
            if(nse.getOther_checkbox() == 1){
                SecondOther.toggle();
            }

            Damages.setSelection(nse.getDamages_y_n());
            DamagesComments.setText(nse.getDamages());

            if(OfflineList.should_submit==true){
                OfflineList.should_submit=false;
                //submit button perform click...
                SubmitButton.performClick();

            }

        } else { //can't find unique id in the database
        ObserverName.setText("No Match Found"); //or something else....
    }

    }
    //When you click on the choose files button
    //CREDITS(5)
    public void chooseImages(View view) {
        Intent intent = new Intent(this, AlbumSelectActivity.class);
                intent.putExtra(Constants.INTENT_EXTRA_LIMIT, 10);
                startActivityForResult(intent, Constants.REQUEST_CODE);
    }

    //called from the choose files button
    //CREDITS(5)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constants.REQUEST_CODE && resultCode == RESULT_OK && data != null) {
            //holds the images you selected
            selectedImages = data.getParcelableArrayListExtra(Constants.INTENT_EXTRA_IMAGES);
        }
    }

    //CREDITS(2)
    //called when you view the chosen images
    public void viewChosen(View view){
        Dialog builder = new Dialog(this);
        builder.requestWindowFeature(Window.FEATURE_NO_TITLE);
        builder.getWindow().setBackgroundDrawable(
                new ColorDrawable(android.graphics.Color.TRANSPARENT));
        builder.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                //nothing;
            }
        });

        //if there are some images to view....
        if(selectedImages != null) {
            //scroll view is the parent view
            ScrollView scroller = new ScrollView(this);
            //linear layout is child of scroll
            LinearLayout ll = new LinearLayout(this);
            //for each of the selected images....
            for (int i = 0; i < selectedImages.size(); i++) {
                Uri currentImage =  Uri.fromFile(new File(selectedImages.get(i).path));
                //create a new imageview
                ImageView imageView = new ImageView(this);
                imageView.setImageURI(currentImage);
                //add image view to the linear layout
                ll.addView(imageView);
            }
            //add linear layout with all the images to the scrollview
            scroller.addView(ll);
            //add the scroll view to the builder
            builder.addContentView(scroller, new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            //display
            builder.show();

        }
        //else viewing from a saved offline site
        else if(savedImagePaths != null){
            //parent scrollview
            ScrollView scroller = new ScrollView(this);
            //child linear layout
            LinearLayout ll = new LinearLayout(this);

            for (int i = 0; i < savedImagePaths.length; i++) {
                Uri currentImage =  Uri.fromFile(new File(savedImagePaths[i]));
                //create a new imageview
                ImageView imageView = new ImageView(this);
                imageView.setImageURI(currentImage);
                //add image view to linear layout
                ll.addView(imageView);
            }
            //add linear layout with all the images to the scrollview
            scroller.addView(ll);
            //add scroll view to the builder
            builder.addContentView(scroller, new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            //display
            builder.show();
        }
    }

    //CREDITS(3)
    //upload image to server/db
    public void uploadImage() throws  Exception {
        class Run extends AsyncTask<String, Void, String> {

            @Override
            protected String doInBackground(String... params) {

                try {
                    //if there is an image to upload
                    if(selectedImages.size() != 0){
                        smallerImage();
                        for(int i = 0; i<selectedImages.size(); i++) {
                            final MediaType MEDIA_TYPE_PNG = MediaType.parse("image/png");
                            final OkHttpClient client = new OkHttpClient();
                            String imageName = selectedImages.get(i).name;

                            RequestBody requestBody = new MultipartBuilder()
                                    .type(MultipartBuilder.FORM)

                                    .addPart(
                                            Headers.of("Content-Disposition", "form-data; name=\"" +
                                                    imageName +
                                                    "\"; filename=\"" +
                                                    imageName +
                                                    "\""),
                                            RequestBody.create(MEDIA_TYPE_PNG, new File(selectedImages.get(i).path)))
                                    .build();

                            Request request = new Request.Builder()
                                    .url("http://nl.cs.montana.edu/usmp/server/new_slope_event/add_new_slope_event.php")
                                    .post(requestBody)
                                    .build();

                            Response response = null;

                            response = client.newCall(request).execute();

                            if (!response.isSuccessful()) try {
                                throw new IOException("Unexpected code " + response);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }

                            System.out.println(response.body().string());

                        }
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
                return null;
            }

        }
        Run r = new Run();
        r.execute();
    }

    //CREDITS(4)
    //Manipulate the size of an image
    public void smallerImage(){
        ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream();
        Bitmap bitmap1;
        Uri uri = Uri.fromFile(new File(selectedImages.get(0).path));
        try {
            bitmap1 = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uri);
            bitmap1.compress(Bitmap.CompressFormat.JPEG,40,bytearrayoutputstream);

        }catch (IOException e){
            e.printStackTrace();
        }

        byte [] BYTE = bytearrayoutputstream.toByteArray();
        Bitmap bitmap2 = BitmapFactory.decodeByteArray(BYTE,0,BYTE.length);
        ImageView imageView = new ImageView(this);
        imageView.setImageBitmap(bitmap2);

        String path = MediaStore.Images.Media.insertImage(this.getContentResolver(), bitmap2, "Title", null);
        Uri uri2 = Uri.parse(path);

    }

}



