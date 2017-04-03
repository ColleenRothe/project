package teammsu.colleenrothe.usmp;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
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
import android.widget.AdapterView;
import android.widget.TableLayout;
import android.widget.TextView;
import android.widget.TableRow;
import android.widget.Spinner;
import android.view.View.OnClickListener;
import android.graphics.Color;
import android.content.res.Resources;
import android.widget.Button;

/* Class for the list of saved offline sites
CREDITS:
    (1)how to check internet connectivity:
        http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity
*/

public class OfflineList extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private TableLayout table;
    private Button submit;
    private Spinner offlineSelector;
    int rows = 0;
    static int selected_row = -1;
    static boolean should_load = false;
    static boolean should_submit = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //provided
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_offline_list);
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

        //connection to UI
        table = (TableLayout) findViewById(R.id.table);
        offlineSelector = (Spinner) findViewById(R.id.offlineSelector);
        offlineSelector.setOnItemSelectedListener(offlineListener);
        submit = (Button) findViewById(R.id.offlineSubmit);

        //if there is no network connectivity, can't submit
        if(!isNetworkAvailable()){
            submit.setBackgroundColor(Color.DKGRAY);
            submit.setClickable(false);
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
        //getMenuInflater().inflate(R.menu.offline_list, menu);
        return true;
    }

    //top menu
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }

        if (id == R.id.action_home) {
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
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        } else if (id == R.id.map) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, MapActivity.class);
            startActivity(intent);

        } else if (id == R.id.slopeRatingForm) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, RatingChoiceActivity.class);
            startActivity(intent);

        } else if (id == R.id.newSlopeEvent) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, NewSlopeEventActivity.class);
            startActivity(intent);

        } else if (id == R.id.maintenaceForm) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, MaintenanceMapActivity.class);
            startActivity(intent);

        } else if (id == R.id.account) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, AccountActivity.class);
            startActivity(intent);

        } else if (id == R.id.logout) {
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);

        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    //call to load form
    public void goLoadForm(View view) {
        //a row must be selected, call up the correct type of form
        if(selected_row!=-1) {
            if (offlineSelector.getSelectedItemPosition() == 0) {
                should_load=true;
                Intent intent = new Intent(this, LandslideActivity.class);
                startActivity(intent);
            } else if (offlineSelector.getSelectedItemPosition() == 1) {
                should_load=true;
                Intent intent = new Intent(this, RockfallActivity.class);
                startActivity(intent);
            } else if (offlineSelector.getSelectedItemPosition() == 2) {
                should_load=true;
                Intent intent = new Intent(this, MaintenanceActivity.class);
                startActivity(intent);
            } else {
                should_load=true;
                Intent intent = new Intent(this, NewSlopeEventActivity.class);
                startActivity(intent);
            }
        }
    }

    //call to clear form
    public void goClearForm(View view) {
        //a row must be selected, delete correct type of form in database
        if(selected_row!=-1) {
            if (offlineSelector.getSelectedItemPosition() == 0) {
                LandslideDBHandler dbHandler = new LandslideDBHandler(this, null, null, 1);
                dbHandler.deleteLandslide(selected_row);
            } else if (offlineSelector.getSelectedItemPosition() == 1) {
                RockfallDBHandler dbHandler = new RockfallDBHandler(this, null, null, 1);
                dbHandler.deleteRockfall(selected_row);
            } else if (offlineSelector.getSelectedItemPosition() == 2) {
                MaintenanceDBHandler dbHandler = new MaintenanceDBHandler(this, null, null, 1);
                dbHandler.deleteMaintenance(selected_row);
            } else {
                NewSlopeEventDBHandler dbHandler = new NewSlopeEventDBHandler(this, null, null, 1);
                dbHandler.deleteNSE(selected_row);
            }
        }
    }

    //call to submit form
    public void goSubmitForm(View view) {
        //a row must be selected, open correct form with call to submit
        if(selected_row!=-1) {
            if (offlineSelector.getSelectedItemPosition() == 0) {
                should_load=true;
                should_submit=true;
                Intent intent = new Intent(this, LandslideActivity.class);
                startActivity(intent);
            } else if (offlineSelector.getSelectedItemPosition() == 1) {
                should_load=true;
                should_submit=true;
                Intent intent = new Intent(this, RockfallActivity.class);
                startActivity(intent);
            } else if (offlineSelector.getSelectedItemPosition() == 2) {
                should_load=true;
                should_submit=true;
                Intent intent = new Intent(this, MaintenanceActivity.class);
                startActivity(intent);
            } else {
                should_load=true;
                should_submit=true;
                Intent intent = new Intent(this, NewSlopeEventActivity.class);
                startActivity(intent);
            }
        }


    }

    //info popup to tell user what is going on
    public void getInfo(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("Select a form type to see a list of forms saved offline on your device\n\n" +
                "Load: Select a saved form, and click the load button to pull up the saved form's info\n\n" +
                "Clear: Select a saved form and click the clear button to delete it. It will no longer be saved on your device\n\n" +
                "Submit: Select a saved form and click the submit button to submit the form to the database\n\n");

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

    //add a row for an offline saved rockfall form
    public void addRockfallRow(){
        RockfallDBHandler dbHandler = new RockfallDBHandler(this, null, null, 1);
        rows = dbHandler.getNumRows();
        int [] ids = dbHandler.getIds();
        //for each saved rockfall
        for(int i = 1; i<=rows; i++){
            //create a new rockfall
            Rockfall rockfall = new Rockfall();
            //set it equal to the one we are looking for
            rockfall = dbHandler.findRockfall(ids[i-1]);
            final TableRow rockfallRow = new TableRow(this);
            //allow user to click on the row
            rockfallRow.setClickable(true);
            //set the row tag to the id of the saved rockfall form
            rockfallRow.setTag(rockfall.getId());
            //when the user clicks
            rockfallRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    //if this row is the one that is already selected, unselect
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    //if no row is selected, make the selected row this one
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }

                }

            });
            //new text view to hold the information
            TextView textview = new TextView(this);
            //get the information
            String hazard_type = rockfall.getHazard_type();
            int agencyNum = rockfall.getAgency();
            String agency = "";
            if(agencyNum == 4){
                agency = "BIA";

            }else if (agencyNum == 3){
                agency = "BLM";

            }else if (agencyNum == 2){
                agency = "NPS";
            }else if (agencyNum == 1){
                agency = "FS";
            }else{
                agency = "";
            }
            String road_trail_num = rockfall.getRoad_trail_number();
            String date = rockfall.getDate();

            //display the information
            textview.setText("Agency:"+agency+"\nHazard Type:"+hazard_type+
                    "\nRoad/Trail ID:"+road_trail_num+"\nDate:"+date+"\n_________________________");

            rockfallRow.addView(textview);
            //add the row of information to the table
            table.addView(rockfallRow);

        }


    }

    //add a row for an offline saved landslide form
    public void addLandslideRow(){
        LandslideDBHandler dbHandler = new LandslideDBHandler(this, null, null, 1);
        rows = dbHandler.getNumRows();
        int [] ids = dbHandler.getIds();
        //for each saved landslide
        for(int i = 1; i<=rows; i++){
            //create a new landslide
            Landslide landslide = new Landslide();
            //set it equal to the one we are looking for
            landslide = dbHandler.findLandslide(ids[i-1]);
            final TableRow landslideRow = new TableRow(this);
            //allow user to click on the row
            landslideRow.setClickable(true);
            //set the row tag to the id of the saved landslide form
            landslideRow.setTag(landslide.getId());
            //when the user clicks
            landslideRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    //if this row is the one that is already selected, unselect
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    //if no row is selected, make the selected row this one
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }


                }

            });
            //new text view to hold the information
            TextView textview = new TextView(this);
            //get the information
            String hazard_type = landslide.getHazard_type();
            int agencyNum = landslide.getAgency();
            String agency = "";
            if(agencyNum == 4){
                agency = "BIA";

            }else if (agencyNum == 3){
                agency = "BLM";

            }else if (agencyNum == 2){
                agency = "NPS";
            }else if (agencyNum == 1){
                agency = "FS";
            }else{
                agency = "";
            }
            String road_trail_num = landslide.getRoad_trail_number();
            String date = landslide.getDate();

            //display the information
            textview.setText("Agency:"+agency+"\nHazard Type:"+hazard_type+
                    "\nRoad/Trail ID:"+road_trail_num+"\nDate:"+date+"\n_________________________");

            landslideRow.addView(textview);
            //add the row of information to the table
            table.addView(landslideRow);

        }

    }

    //add a row for an offline saved new slope event form
    public void addNewSlopeEventRow(){
        NewSlopeEventDBHandler dbHandler = new NewSlopeEventDBHandler(this, null, null, 1);
        int [] ids = dbHandler.getIds();
        rows = dbHandler.getNumRows();
        //for each saved nse form
        for(int i = 1; i<=rows; i++){
            //create a new nse
            NewSlopeEvent nse = new NewSlopeEvent();
            //set it equal to the one we are looking for
            nse = dbHandler.findNSE(ids[i-1]);
            final TableRow nseRow = new TableRow(this);
            //allow user to click on row
            nseRow.setClickable(true);
            //set the row tag to the id of the saved nse form
            nseRow.setTag(nse.getId());
            //if this row is the one that is already selected, unselect
            nseRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    //if no row is selected, make the selected row this one
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }


                }

            });
            //new text view to hold the info
            TextView textview = new TextView(this);
            //get the info
            int hazard_type = nse.getHazard_type();
            String hazard_type_string = "";
            if(hazard_type==0){
                hazard_type_string="Rockfall";
            }else if (hazard_type==1){
                hazard_type_string="Landslide";
            }else if (hazard_type==2){
                hazard_type_string="Debris Flow";
            }else{
                hazard_type_string="Snow Avalance";
            }

            int state = nse.getState();
            String state_string = "";
            Resources res = getResources();
            String [] states = res.getStringArray(R.array.stateList);
            state_string=states[state];

            String road_trail_num = nse.getRoad_trail_number();
            String event_date = nse.getDateinput();
            //display the info
            textview.setText("Hazard Type:"+hazard_type_string+"\nState:"+state_string+
            "\nRoad/Trail ID:"+road_trail_num+"\nEvent Date:"+event_date+"\n_________________________");

            nseRow.addView(textview);
            //add new row to the table
            table.addView(nseRow);

        }

    }

    //add a row for an offline saved maintenance form
    public void addMaintenanceRow() {
        MaintenanceDBHandler dbHandler = new MaintenanceDBHandler(this, null, null, 1);
        int [] ids = dbHandler.getIds();
        rows = dbHandler.getNumRows();
        //for each saved maint form
        for (int i = 1; i <= rows; i++) {
            //create a new maintenance form
            Maintenance maintenance = new Maintenance();
            maintenance = dbHandler.findMaintenance(ids[i-1]);
            final TableRow maintenanceRow = new TableRow(this);
            //allow user to click on the row
            maintenanceRow.setClickable(true);
            //set the row tag to the id of the saved maintenance form
            maintenanceRow.setTag(maintenance.getID());
            //when the user clicks
            maintenanceRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    //if this row is the one that is already selected, unselect
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    //if no row is selected, make the selected row this one
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }

                }

            });
            //new text view to hold the info
            TextView textEventType = new TextView(this);
            //get the info
            int us_event = maintenance.getUs_event();
            String us_event_string = "";
            if (us_event == 0) {
                us_event_string = "Recent Unstable Slope Event";
            } else if (us_event == 1) {
                us_event_string = "Routine Maintenance";
            } else {
                us_event_string = "Slope Mitigation/Repair";
            }

            int maintenance_type = maintenance.getMaintenance_type();
            String maintenance_string = "";
            if (maintenance_type == 0) {
                maintenance_string = "New Maintenance";
            } else {
                maintenance_string = "Repeat Maintenance";
            }

            //display the info
            textEventType.setText("Event Type:" + us_event_string + "\n Maint. Type: "+maintenance_string+"\nCode:"+maintenance.getCode_relation()+"\n_________________________");

            maintenanceRow.addView(textEventType);
            //add the row of info to the table
            table.addView(maintenanceRow);

        }

    }

   //clear the table when you are switching between form types
    public void clearTable(){
        int end = table.getChildCount();
        //but don't clear the top header things that are the same for each form type
        View view1 = (View) findViewById(R.id.offlineLayout1);
        View view2 = (View) findViewById(R.id.offlineLayout2);
        View view3 = (View) findViewById(R.id.offlineLayout3);
        for(int i = end-1; i>=0;i--){
            if((table.getChildAt(i)!=view1)&&(table.getChildAt(i)!=view2)&&(table.getChildAt(i)!=view3)){
                table.removeViewAt(i);
            }
        }
    }


    //listens to what type of form is selected
    private final AdapterView.OnItemSelectedListener offlineListener = new AdapterView.OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            //check for level 2 - read only
            if(LoginActivity.permissions == 2){
                submit.setBackgroundColor(Color.DKGRAY);
                submit.setClickable(false);
            }

            if (position == 0) { //landslide
                //no row initially selected
                selected_row = -1;
                //empty out the table from previous form type
                clearTable();
                //add rows of the appropriate type
                addLandslideRow();

            } else if (position == 1) { //rockfall
                //no row initially selected
                selected_row = -1;
                //empty out the table from previous form type
                clearTable();
                //add rows of the appropriate type
                addRockfallRow();


            } else if (position == 2) { //maintenance
                //no row initially selected
                selected_row = -1;
                //empty out the table from previous form type
                clearTable();
                //add rows of the appropriate type
                addMaintenanceRow();

            } else if (position == 3) { //nse
                //no row initially selected
                selected_row = -1;
                //empty out the table from previous form type
                clearTable();
                //add rows of the appropriate type
                addNewSlopeEventRow();

            }
        }
            @Override
            public void onNothingSelected (AdapterView < ? > parent){

            }

    };

}
