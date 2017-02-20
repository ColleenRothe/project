package teammsu.colleenrothe.usmp;

//how to check internet connectivity:
//http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity


import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.annotation.ArrayRes;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
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
import android.widget.TableLayout.LayoutParams;
import android.util.AttributeSet;
import android.widget.TableRow;
import android.view.ViewGroup;
import android.database.*;
import android.widget.Spinner;
import android.view.View.OnClickListener;
import android.graphics.Color;
import android.content.res.Resources;
import android.widget.Button;



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
        table = (TableLayout) findViewById(R.id.table);
        offlineSelector = (Spinner) findViewById(R.id.offlineSelector);
        offlineSelector.setOnItemSelectedListener(offlineListener);

        submit = (Button) findViewById(R.id.offlineSubmit);

        if(!isNetworkAvailable()){
            submit.setBackgroundColor(Color.DKGRAY);
            submit.setClickable(false);
        }

    }

    // Check all connectivities whether available or not
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

        if (id == R.id.action_home) {
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
            should_load=false;
            should_submit=false;
            Intent intent = new Intent(this, MainActivity.class);
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

    public void goLoadForm(View view) {
        if(selected_row!=-1) { //something has to be selected....or no go
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
        System.out.println("Load");
    }

    public void goClearForm(View view) {
        if(selected_row!=-1) { //something has to be selected....or no go
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

    public void goSubmitForm(View view) {
        if(selected_row!=-1) { //something has to be selected....or no go
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

    public void addRockfallRow(){
        RockfallDBHandler dbHandler = new RockfallDBHandler(this, null, null, 1);
        rows = dbHandler.getNumRows();
        int [] ids = dbHandler.getIds();
        for(int i = 1; i<=rows; i++){
            Rockfall rockfall = new Rockfall();
            rockfall = dbHandler.findRockfall(ids[i-1]);
            final TableRow rockfallRow = new TableRow(this);
            rockfallRow.setClickable(true);
            rockfallRow.setTag(rockfall.getId());
            rockfallRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }

                }

            });

            TextView textview = new TextView(this);
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

            textview.setText("Agency:"+agency+"\nHazard Type:"+hazard_type+
                    "\nRoad/Trail ID:"+road_trail_num+"\nDate:"+date+"\n_________________________");

            rockfallRow.addView(textview);

            table.addView(rockfallRow);

        }


    }

    public void addLandslideRow(){
        LandslideDBHandler dbHandler = new LandslideDBHandler(this, null, null, 1);
        rows = dbHandler.getNumRows();
        int [] ids = dbHandler.getIds();
        for(int i = 1; i<=rows; i++){
            Landslide landslide = new Landslide();

            //landslide = dbHandler.findLandslide(i); //not necessarily...
            landslide = dbHandler.findLandslide(ids[i-1]);
            final TableRow landslideRow = new TableRow(this);
            landslideRow.setClickable(true);
            landslideRow.setTag(landslide.getId());
            landslideRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }


                }

            });

            TextView textview = new TextView(this);
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

            textview.setText("Agency:"+agency+"\nHazard Type:"+hazard_type+
                    "\nRoad/Trail ID:"+road_trail_num+"\nDate:"+date+"\n_________________________");

            landslideRow.addView(textview);

            table.addView(landslideRow);

        }

    }

    public void addNewSlopeEventRow(){
        NewSlopeEventDBHandler dbHandler = new NewSlopeEventDBHandler(this, null, null, 1);
        int [] ids = dbHandler.getIds();
        rows = dbHandler.getNumRows();
        for(int i = 1; i<=rows; i++){
            NewSlopeEvent nse = new NewSlopeEvent();
            nse = dbHandler.findNSE(ids[i-1]);
            final TableRow nseRow = new TableRow(this);
            nseRow.setClickable(true);
            nseRow.setTag(nse.getId());
            nseRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }


                }

            });

            TextView textview = new TextView(this);
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

            textview.setText("Hazard Type:"+hazard_type_string+"\nState:"+state_string+
            "\nRoad/Trail ID:"+road_trail_num+"\nEvent Date:"+event_date+"\n_________________________");

            nseRow.addView(textview);

            table.addView(nseRow);

        }

    }

    public void addMaintenanceRow() {
        MaintenanceDBHandler dbHandler = new MaintenanceDBHandler(this, null, null, 1);
        int [] ids = dbHandler.getIds();
        rows = dbHandler.getNumRows();
        for (int i = 1; i <= rows; i++) {
            Maintenance maintenance = new Maintenance();
            maintenance = dbHandler.findMaintenance(ids[i-1]);
            final TableRow maintenanceRow = new TableRow(this);
            maintenanceRow.setClickable(true);
            maintenanceRow.setTag(maintenance.getID());
            maintenanceRow.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    if((int)v.getTag() == selected_row){
                        v.setBackgroundColor(Color.TRANSPARENT);
                        selected_row=-1;
                    }
                    else if (selected_row == -1){
                        v.setBackgroundColor(Color.GRAY);
                        selected_row=(int)v.getTag();

                    }

                }

            });

            TextView textEventType = new TextView(this);
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
            textEventType.setText("Event Type:" + us_event_string + "\n Maint. Type: "+maintenance_string+"\nCode:"+maintenance.getCode_relation()+"\n_________________________");

            maintenanceRow.addView(textEventType);

            table.addView(maintenanceRow);

        }

    }

    public void clearTable(){
        int end = table.getChildCount();

        View view1 = (View) findViewById(R.id.offlineLayout1);
        View view2 = (View) findViewById(R.id.offlineLayout2);
        View view3 = (View) findViewById(R.id.offlineLayout3);
        for(int i = end-1; i>=0;i--){
            if((table.getChildAt(i)!=view1)&&(table.getChildAt(i)!=view2)&&(table.getChildAt(i)!=view3)){
                table.removeViewAt(i);
            }
        }



    }


    private final AdapterView.OnItemSelectedListener offlineListener = new AdapterView.OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

            if (position == 0) {
                System.out.println("Selected Landslide");
                selected_row = -1;
                clearTable();
                addLandslideRow();

            } else if (position == 1) {
                System.out.println("Selected Rockfall");
                selected_row = -1;
                clearTable();
                addRockfallRow();


            } else if (position == 2) {
                System.out.println("Selected Maintenance");
                selected_row = -1;
                clearTable();
                addMaintenanceRow();

            } else if (position == 3) {
                System.out.println("Selected New Slope Event");
                selected_row = -1;
                clearTable();
                addNewSlopeEventRow();

            }
        }
            @Override
            public void onNothingSelected (AdapterView < ? > parent){

            }

    };

}
