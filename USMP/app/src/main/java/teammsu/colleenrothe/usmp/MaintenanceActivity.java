package teammsu.colleenrothe.usmp;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
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
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Spinner;
import android.widget.Button;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import android.content.Context;
import android.widget.Toast;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.util.HashMap;
import java.util.Map;

/* Class for Maintenance Form
    CREDITS:
        (1) Check internet connectivity
              http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity
        (2) Picker listener...programatically change the options
              http://pulse7.net/android/android-spinner-drop-down-list-example-in-android-studio-2-0/
        (3) POST request from android studio
            http://androidexample.com/How_To_Make_HTTP_POST_Request_To_Server_-_Android_Example/index.php?view=article_discription&aid=64
 */

public class MaintenanceActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    Spinner MaintenanceID;
    EditText Mcode;
    Spinner MaintenanceType;
    EditText RTNumber;
    EditText BeginMile;
    EditText EndMile;
    Spinner Agency;
    Spinner Regional;
    Spinner Local;
    Spinner EventType;
    EditText MDescription;
    EditText TotalCost;

    EditText Percent1;
    EditText Percent2;
    EditText Percent3;
    EditText Percent4;
    EditText Percent4_5;
    EditText Percent5;
    EditText Percent6;
    EditText Percent7;
    EditText Percent8;
    EditText Percent9;
    EditText Percent10;
    EditText Percent11;
    EditText Percent12;
    EditText Percent13;
    EditText Percent14;
    EditText Percent15;
    EditText Percent16;
    EditText Percent17;
    EditText Percent18;
    EditText Percent19;
    EditText Percent20;

    EditText Other1;
    EditText Other2;
    EditText Other3;
    EditText Other4;
    EditText Other5;

    Button SubmitButton;


    EditText RunningTotal;
    TextView fabText;

    ArrayAdapter<String> adapterRegional;
    ArrayList<String> fs_regions;

    ArrayAdapter<String> adapterLocal;
    ArrayList<String> fs_local1;

    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/currentMaintenance.php";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //provided
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maintenance);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        //holds the running percentage that the user has added
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fabText = (TextView) findViewById(R.id.fabText);
        fabText.setText("%");
        //click on the percentage, more detailed view popup
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(MaintenanceActivity.this);
                final TextView tv = new TextView(MaintenanceActivity.this);
                tv.setText("Total Percent used:" + RunningTotal.getText() + "%");

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
        });

        //provided
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //Connect to UI
        SubmitButton = (Button) findViewById(R.id.MSubmitButton);

        MaintenanceID = (Spinner) findViewById(R.id.MaintenanceID);
        Mcode = (EditText) findViewById(R.id.Mcode);
        MDescription = (EditText) findViewById(R.id.MDescription);
        TotalCost = (EditText) findViewById(R.id.TotalCost);

        MaintenanceType = (Spinner) findViewById(R.id.MaintenanceType);
        MaintenanceType.setFocusable(true);
        MaintenanceType.setFocusableInTouchMode(true);

        RTNumber = (EditText) findViewById(R.id.MRtNum);
        BeginMile = (EditText) findViewById(R.id.MBeginMile);
        EndMile = (EditText) findViewById(R.id.MEndMile);

        Agency = (Spinner) findViewById(R.id.MAgency);
        Agency.setFocusable(true);
        Agency.setFocusableInTouchMode(true);

        //Watch to see if the user changes the agency, update the regional spinner accordingly
        Agency.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapter, View v, int position, long id) {
                String agency = adapter.getItemAtPosition(position).toString();
                if (agency.equals("FS")) {
                    fs_regions.clear();
                    //get the FS regional list
                    String[] regionArray = getResources().getStringArray(R.array.FSRegionalList);
                    for (int i = 0; i < regionArray.length; i++) {
                        fs_regions.add(regionArray[i]);
                    }
                    adapterRegional.notifyDataSetChanged();

                } else if (agency.equals("NPS")) {
                    System.out.println("NPS");
                    fs_regions.clear();
                    String[] regionArray = getResources().getStringArray(R.array.NPSRegionalList);
                    for (int i = 0; i < regionArray.length; i++) {
                        fs_regions.add(regionArray[i]);
                    }
                    adapterRegional.notifyDataSetChanged();

                } else if (agency.equals("BLM")) {
                    fs_regions.clear();
                    String[] regionArray = getResources().getStringArray(R.array.RegionalList);
                    fs_regions.add(regionArray[0]);
                    adapterRegional.notifyDataSetChanged();

                } else if (agency.equals("BIA")) {
                    fs_regions.clear();
                    String[] regionArray = getResources().getStringArray(R.array.RegionalList);
                    fs_regions.add(regionArray[0]);
                    adapterRegional.notifyDataSetChanged();

                } else if (agency.equals("Select Agency Option")) {
                    fs_regions.clear();
                    String[] regionArray = getResources().getStringArray(R.array.RegionalList);
                    fs_regions.add(regionArray[0]);
                    adapterRegional.notifyDataSetChanged();
                }

            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // do nothing....
            }
        });

        Regional = (Spinner) findViewById(R.id.MRegional);
        Regional.setFocusable(true);
        Regional.setFocusableInTouchMode(true);

        //watch to see if the user changes the regional spinner...update the local spinner accordingly
        Regional.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapter, View v, int position, long id) {
                String region = adapter.getItemAtPosition(position).toString();
                //FS
                if (region.equals("Northern Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList1);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Rocky Mountain Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList2);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Southwestern Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList3);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Intermountain Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList4);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Pacific Southwest Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList5);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Pacific Northwest Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList6);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Southern Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList7);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Eastern Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList8);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Alaska Region")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.FSLocalList9);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                } else if (region.equals("Select Regional Option")) {
                    fs_local1.clear();
                    String[] regionArray = getResources().getStringArray(R.array.LocalList);
                    fs_local1.add(regionArray[0]);
                    adapterLocal.notifyDataSetChanged();
                }
                //NPS
                else if (region.equals("AKR")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocalList1);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("IMR")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocalList2);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("MWR")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocal3);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("NCR")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocal4);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("NER")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocal5);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("PWR")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocal6);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();

                }else if (region.equals("SER")) {
                    fs_local1.clear();
                    String[] localArray = getResources().getStringArray(R.array.NPSLocal7);
                    for (int i = 0; i < localArray.length; i++) {
                        fs_local1.add(localArray[i]);
                    }
                    adapterLocal.notifyDataSetChanged();
                }

            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // do nothing....
            }


        });

        Local = (Spinner) findViewById(R.id.MLocal);
        Local.setFocusable(true);
        Local.setFocusableInTouchMode(true);

        fs_regions = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterRegional = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_regions);
        adapterRegional.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Regional.setAdapter(adapterRegional);

        fs_local1 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterLocal = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_local1);
        adapterLocal.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Local.setAdapter(adapterLocal);

        EventType = (Spinner) findViewById(R.id.EventType);
        EventType.setFocusable(true);
        EventType.setFocusableInTouchMode(true);

        Percent1 = (EditText) findViewById(R.id.Percent1);
        Percent2 = (EditText) findViewById(R.id.Percent2);
        Percent3 = (EditText) findViewById(R.id.Percent3);
        Percent4 = (EditText) findViewById(R.id.Percent4);
        Percent4_5 = (EditText) findViewById(R.id.Percent4_5);
        Percent5 = (EditText) findViewById(R.id.Percent5);
        Percent6 = (EditText) findViewById(R.id.Percent6);
        Percent7 = (EditText) findViewById(R.id.Percent7);
        Percent8 = (EditText) findViewById(R.id.Percent8);
        Percent9 = (EditText) findViewById(R.id.Percent9);
        Percent10 = (EditText) findViewById(R.id.Percent10);
        Percent11 = (EditText) findViewById(R.id.Percent11);
        Percent12 = (EditText) findViewById(R.id.Percent12);
        Percent13 = (EditText) findViewById(R.id.Percent13);
        Percent14 = (EditText) findViewById(R.id.Percent14);
        Percent15 = (EditText) findViewById(R.id.Percent15);
        Percent16 = (EditText) findViewById(R.id.Percent16);
        Percent17 = (EditText) findViewById(R.id.Percent17);
        Percent18 = (EditText) findViewById(R.id.Percent18);
        Percent19 = (EditText) findViewById(R.id.Percent19);
        Percent20 = (EditText) findViewById(R.id.Percent20);

        Other1 = (EditText) findViewById(R.id.Other1);
        Other2 = (EditText) findViewById(R.id.Other2);
        Other3 = (EditText) findViewById(R.id.Other3);
        Other4 = (EditText) findViewById(R.id.Other4);
        Other5 = (EditText) findViewById(R.id.Other5);


        RunningTotal = (EditText) findViewById(R.id.RunningTotal);

        Percent1.addTextChangedListener(totalWatcher);
        Percent2.addTextChangedListener(totalWatcher);
        Percent3.addTextChangedListener(totalWatcher);
        Percent4.addTextChangedListener(totalWatcher);
        Percent5.addTextChangedListener(totalWatcher);
        Percent6.addTextChangedListener(totalWatcher);
        Percent7.addTextChangedListener(totalWatcher);
        Percent8.addTextChangedListener(totalWatcher);
        Percent9.addTextChangedListener(totalWatcher);
        Percent10.addTextChangedListener(totalWatcher);
        Percent11.addTextChangedListener(totalWatcher);
        Percent12.addTextChangedListener(totalWatcher);
        Percent13.addTextChangedListener(totalWatcher);
        Percent14.addTextChangedListener(totalWatcher);
        Percent15.addTextChangedListener(totalWatcher);
        Percent16.addTextChangedListener(totalWatcher);
        Percent17.addTextChangedListener(totalWatcher);
        Percent18.addTextChangedListener(totalWatcher);
        Percent19.addTextChangedListener(totalWatcher);
        Percent20.addTextChangedListener(totalWatcher);

        //MaintenanceMapActivity.newOld =false;

        //looking at an already created form
        if (MaintenanceMapActivity.newOld == true) {
            getJSON(JSON_URL); //call to get info from the db
        }
        //creating a new form
        else {
            Context context = getApplicationContext();
            int duration = Toast.LENGTH_SHORT;

        }

        //LOAD from an offline list
        if (OfflineList.selected_row!=-1 && OfflineList.should_load==true){
            OfflineList.should_load=false;
            lookupMaintenance(OfflineList.selected_row);
        }
        //if no network connection...can't submit
        if(!isNetworkAvailable()){
            SubmitButton.setBackgroundColor(Color.DKGRAY);
            SubmitButton.setClickable(false);
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

    //get info from the db
    public void GetText() throws UnsupportedEncodingException {
        //String data = URLEncoder.encode("id=355", "UTF-8");
        String data="id="+MaintenanceMapActivity.load_id;
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
    public void dealWithText(String text){
        text = text.replace("[",""); //old,new
        text = text.replace("]",""); //old,new
        Map<String, String> map = new Gson().fromJson(text, new TypeToken<HashMap<String, String>>() {}.getType());
        System.out.println(map);

        //Set information on the maintenance form
        Mcode.setText(map.get("CODE_RELATION"));
        String maintenance_type = map.get("MAINTENANCE_TYPE");
        if(maintenance_type == "N"){
            MaintenanceType.setSelection(0);
        }
        else{
            MaintenanceType.setSelection(1);
        }

        RTNumber.setText(map.get("ROAD_TRAIL_NO"));
        BeginMile.setText(map.get("BEGIN_MILE_MARKER"));
        EndMile.setText(map.get("END_MILE_MARKER"));
        String agency = (map.get("UMBRELLA_AGENCY"));
        String [] agencyArray = getResources().getStringArray(R.array.AgencyList);
        for(int i = 0; i<agencyArray.length;i++){
            if(agencyArray[i].equals(agency)){
                Agency.setSelection(i);
            }
        }

        String regional = (map.get("REGIONAL_ADMIN"));
        String [] regionalArray1 = getResources().getStringArray(R.array.FSRegionalList);
        String [] regionalArray2 = getResources().getStringArray(R.array.NPSRegionalList);

        for(int i = 0; i<regionalArray1.length;i++){
            if(regionalArray1[i].equals(regional)){
                Regional.setSelection(i);
            }
        }

        for(int i = 0; i<regionalArray2.length;i++){
            if(regionalArray2[i].equals(regional)){
                Regional.setSelection(i);
            }
        }

        String local = (map.get("LOCAL_ADMIN"));
        String [] local1 = getResources().getStringArray(R.array.FSLocalList1);
        String [] local2 = getResources().getStringArray(R.array.FSLocalList2);
        String [] local3 = getResources().getStringArray(R.array.FSLocalList3);
        String [] local4 = getResources().getStringArray(R.array.FSLocalList4);
        String [] local5 = getResources().getStringArray(R.array.FSLocalList5);
        String [] local6 = getResources().getStringArray(R.array.FSLocalList6);
        String [] local7 = getResources().getStringArray(R.array.FSLocalList7);
        String [] local8 = getResources().getStringArray(R.array.FSLocalList8);
        String [] local9 = getResources().getStringArray(R.array.FSLocalList9);
        String [] local10 = getResources().getStringArray(R.array.NPSLocalList1);
        String [] local11 = getResources().getStringArray(R.array.NPSLocalList2);
        String [] local12 = getResources().getStringArray(R.array.NPSLocal3);
        String [] local13 = getResources().getStringArray(R.array.NPSLocal4);
        String [] local14 = getResources().getStringArray(R.array.NPSLocal5);
        String [] local15 = getResources().getStringArray(R.array.NPSLocal6);
        String [] local16 = getResources().getStringArray(R.array.NPSLocal7);

        ArrayList<String> localList1 = new ArrayList<String>(Arrays.asList(local1));
        ArrayList<String> localList2 = new ArrayList<String>(Arrays.asList(local2));
        ArrayList<String> localList3 = new ArrayList<String>(Arrays.asList(local3));
        ArrayList<String> localList4 = new ArrayList<String>(Arrays.asList(local4));
        ArrayList<String> localList5 = new ArrayList<String>(Arrays.asList(local5));
        ArrayList<String> localList6 = new ArrayList<String>(Arrays.asList(local6));
        ArrayList<String> localList7 = new ArrayList<String>(Arrays.asList(local7));
        ArrayList<String> localList8 = new ArrayList<String>(Arrays.asList(local8));
        ArrayList<String> localList9 = new ArrayList<String>(Arrays.asList(local9));
        ArrayList<String> localList10 = new ArrayList<String>(Arrays.asList(local10));
        ArrayList<String> localList11 = new ArrayList<String>(Arrays.asList(local11));
        ArrayList<String> localList12 = new ArrayList<String>(Arrays.asList(local12));
        ArrayList<String> localList13 = new ArrayList<String>(Arrays.asList(local13));
        ArrayList<String> localList14 = new ArrayList<String>(Arrays.asList(local14));
        ArrayList<String> localList15 = new ArrayList<String>(Arrays.asList(local15));
        ArrayList<String> localList16 = new ArrayList<String>(Arrays.asList(local16));


        if(localList1.contains(local)){
            Local.setSelection(localList1.indexOf(local));
        }
        else if (localList2.contains(local)){
            Local.setSelection(localList2.indexOf(local));
        }else if (localList3.contains(local)){
            Local.setSelection(localList3.indexOf(local));
        }else if (localList4.contains(local)){
            Local.setSelection(localList4.indexOf(local));
        }else if (localList5.contains(local)){
            Local.setSelection(localList5.indexOf(local));
        }else if (localList6.contains(local)){
            Local.setSelection(localList6.indexOf(local));
        }else if (localList7.contains(local)){
            Local.setSelection(localList7.indexOf(local));
        }else if (localList8.contains(local)){
            Local.setSelection(localList8.indexOf(local));
        }else if (localList9.contains(local)){
            Local.setSelection(localList9.indexOf(local));
        }else if (localList10.contains(local)){
            Local.setSelection(localList10.indexOf(local));
        }else if (localList11.contains(local)){
            Local.setSelection(localList11.indexOf(local));
        }else if (localList12.contains(local)){
            Local.setSelection(localList12.indexOf(local));
        }else if (localList13.contains(local)){
            Local.setSelection(localList13.indexOf(local));
        }else if (localList14.contains(local)){
            Local.setSelection(localList14.indexOf(local));
        }else if (localList15.contains(local)){
            Local.setSelection(localList15.indexOf(local));
        }else if (localList16.contains(local)){
            Local.setSelection(localList16.indexOf(local));
        }




        String us_event = map.get("US_EVENT");


        if(us_event.equals("SM") ){
            EventType.setSelection(2);
        }
        else if (us_event.equals("RM")){
            EventType.setSelection(1);
        }else{
            EventType.setSelection(0);
        }

        MDescription.setText(map.get("EVENT_DESC"));
        Percent1.setText(map.get("DESIGN_PSE"));
        Percent2.setText(map.get("REMOVE_DITCH"));
        Percent3.setText(map.get("REMOVE_ROAD_TRAIL"));
        Percent4.setText(map.get("RELEVEL_AGGREGATE"));
        Percent4_5.setText(map.get("RELEVEL_PATCH"));
        Percent5.setText(map.get("DRAINAGE_IMPROVEMENT"));
        Percent6.setText(map.get("DEEP_PATCH"));
        Percent7.setText(map.get("HAUL_DEBRIS"));
        Percent8.setText(map.get("SCALING_ROCK_SLOPES"));
        Percent9.setText(map.get("ROAD_TRAIL_ALIGNMENT"));
        Percent10.setText(map.get("REPAIR_ROCKFALL_BARRIER"));
        Percent11.setText(map.get("REPAIR_ROCKFALL_NETTING"));
        Percent12.setText(map.get("SEALING_CRACKS"));
        Percent13.setText(map.get("GUARDRAIL"));
        Percent14.setText(map.get("CLEANING_DRAINS"));
        Percent15.setText(map.get("FLAGGING_SIGNING"));
        Other1.setText(map.get("OTHERS1_DESC"));
        Other2.setText(map.get("OTHERS2_DESC"));
        Other3.setText(map.get("OTHERS3_DESC"));
        Other4.setText(map.get("OTHERS4_DESC"));
        Other5.setText(map.get("OTHERS5_DESC"));
        Percent16.setText(map.get("OTHERS1"));
        Percent17.setText(map.get("OTHERS2"));
        Percent18.setText(map.get("OTHERS3"));
        Percent19.setText(map.get("OTHERS4"));
        Percent20.setText(map.get("OTHERS5"));
        TotalCost.setText((map.get("TOTAL")));
        RunningTotal.setText(map.get("TOTAL_PERCENT"));


    }

    //first call to get db info
    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String>{
            ProgressDialog loading; //just to tell the user that the map is in progress...all good

            @Override
            protected void onPreExecute() {
                super.onPreExecute();
                loading = ProgressDialog.show(MaintenanceActivity.this, "Please Wait...",null,true,true);
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
                loading.dismiss(); //dismiss the "loading" message
            }
        }
        GetJSON gj = new GetJSON();
        gj.execute(url);
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
        getMenuInflater().inflate(R.menu.maintenance, menu);
        getMenuInflater().inflate(R.menu.menu_main, menu);

        return true;
    }

    //top menu
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
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
            Intent intent = new Intent(this, MaintenanceActivity.class);

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

    //calculate the running percent total
    public void calcPercent(){
        int total = 0;
        if(Percent1.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent1.getText().toString());
            total += percent1;
        }
        if(Percent2.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent2.getText().toString());
            total += percent1;
        }
        if(Percent3.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent3.getText().toString());
            total += percent1;
        }
        if(Percent4.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent4.getText().toString());
            total += percent1;
        }
        if(Percent4_5.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent4_5.getText().toString());
            total += percent1;
        }
        if(Percent5.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent5.getText().toString());
            total += percent1;
        }
        if(Percent6.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent6.getText().toString());
            total += percent1;
        }
        if(Percent7.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent7.getText().toString());
            total += percent1;
        }
        if(Percent8.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent8.getText().toString());
            total += percent1;
        }
        if(Percent9.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent9.getText().toString());
            total += percent1;
        }
        if(Percent10.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent10.getText().toString());
            total += percent1;
        }
        if(Percent11.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent11.getText().toString());
            total += percent1;
        }
        if(Percent12.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent12.getText().toString());
            total += percent1;
        }
        if(Percent13.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent13.getText().toString());
            total += percent1;
        }
        if(Percent14.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent14.getText().toString());
            total += percent1;
        }
        if(Percent15.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent15.getText().toString());
            total += percent1;
        }
        if(Percent16.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent16.getText().toString());
            total += percent1;
        }
        if(Percent17.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent17.getText().toString());
            total += percent1;
        }
        if(Percent18.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent18.getText().toString());
            total += percent1;
        }
        if(Percent19.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent19.getText().toString());
            total += percent1;
        }
        if(Percent20.getText().length() != 0){
            int percent1 = Integer.parseInt(Percent20.getText().toString());
            total += percent1;
        }


        String totalS = String.valueOf(total);
        RunningTotal.setText(totalS);
        RunningTotal.setBackgroundColor(getResources().getColor(android.R.color.transparent));
        fabText.setText(totalS+"%");

        //the running percentage should not be more than 100....warn the user
        if(total > 100) {
            RunningTotal.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

            AlertDialog.Builder builder = new AlertDialog.Builder(MaintenanceActivity.this);
            builder.setMessage("Running total should not be greater than 100")
                    .setTitle("Warning");
            builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    // User clicked OK button
                }
            });

            AlertDialog dialog = builder.create();

            dialog.show();
        }

    }

    //if text changes, re-calculate the percentages
    private final TextWatcher totalWatcher = new TextWatcher() {
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        public void afterTextChanged(Editable s) {
            calcPercent();

        }
    };

    //informational popup
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

    //go to the list of offline sites
    public void goOfflineSites(View view){
        Intent intent = new Intent(this, OfflineList.class);
        startActivity(intent);
    }

    //submit the maintenance form
    public void M_Submit(View view) throws Exception{
        Thread thread = new Thread(new Runnable() {

            @Override
            public void run() {
                try  {
                    URL url = new URL("http://nl.cs.montana.edu/usmp/server/maintenance/add_maintenance.php");
                    URLConnection conn = url.openConnection();
                    conn.setDoOutput(true);
                    OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());

                    String MDescriptionText = String.valueOf(MDescription.getText());
                    String code = String.valueOf(Mcode.getText());
                    String rtnum = String.valueOf(RTNumber.getText());
                    String beginMile = String.valueOf(BeginMile.getText());
                    String endMile = String.valueOf(EndMile.getText());
                    String Percent1Text = String.valueOf(Percent1.getText());
                    String Percent2Text = String.valueOf(Percent2.getText());
                    String Percent3Text = String.valueOf(Percent3.getText());
                    String Percent4Text = String.valueOf(Percent4.getText());
                    String Percent4_5Text = String.valueOf(Percent4_5.getText());
                    String Percent5Text = String.valueOf(Percent5.getText());
                    String Percent6Text = String.valueOf(Percent6.getText());
                    String Percent7Text = String.valueOf(Percent7.getText());
                    String Percent8Text = String.valueOf(Percent8.getText());
                    String Percent9Text = String.valueOf(Percent9.getText());
                    String Percent10Text = String.valueOf(Percent10.getText());
                    String Percent11Text = String.valueOf(Percent11.getText());
                    String Percent12Text = String.valueOf(Percent12.getText());
                    String Percent13Text = String.valueOf(Percent13.getText());
                    String Percent14Text = String.valueOf(Percent14.getText());
                    String Percent15Text = String.valueOf(Percent15.getText());
                    String Percent16Text = String.valueOf(Percent16.getText());
                    String Percent17Text = String.valueOf(Percent17.getText());
                    String Percent18Text = String.valueOf(Percent18.getText());
                    String Percent19Text = String.valueOf(Percent19.getText());
                    String Percent20Text = String.valueOf(Percent20.getText());

                    String Other1Text = String.valueOf(Other1.getText());
                    String Other2Text = String.valueOf(Other2.getText());
                    String Other3Text = String.valueOf(Other3.getText());
                    String Other4Text = String.valueOf(Other4.getText());
                    String Other5Text = String.valueOf(Other5.getText());

                    String TotalPercent = String.valueOf(RunningTotal.getText());

                    //client/maintenance_form.php for values
                    String maintenanceType = "";
                    if(MaintenanceType.getSelectedItem().toString().equals("New Maintenance")){
                        maintenanceType="N";
                    }else{ //repeat maintenance
                        maintenanceType="O";

                    }

                    String agency = "search_0";
                    if(Agency.getSelectedItemPosition()!=0){
                        agency = Agency.getSelectedItem().toString();
                    }

                    String regional = "search_0";
                    if(Regional.getSelectedItemPosition()!=0){
                        regional = Regional.getSelectedItem().toString();
                    }

                    String local = "search_0";
                    if(Local.getSelectedItemPosition()!=0){
                        local = Local.getSelectedItem().toString();
                    }

                    String usEvent = "";
                    if(EventType.getSelectedItem().toString().equals("Recent Unstable Slope Event")){
                        usEvent = "USE";

                    }
                    else if(EventType.getSelectedItem().toString().equals("Routine Maintenance")){
                        usEvent = "RM";

                    }
                    else{ //slope mitigation/repair
                        usEvent = "SM";

                    }

                    writer.write("code_relation="+code+"&maintenance_type="+maintenanceType+"&road_trail_no="+rtnum+"&begin_mile_marker="+beginMile+"&end_mile_marker=" +
                            endMile+"&umbrella_agency="+agency+"&regional_admin="+regional+"&local_admin="+local+"&us_event="+usEvent+"&event_desc="+MDescriptionText+
                    "&design_pse_val="+Percent1Text+"&remove_ditch_val="+Percent2Text+"&remove_road_trail_val="+Percent3Text+"&relevel_aggregate_val="+Percent4Text+
                    "&relevel_patch_val="+Percent4_5Text+"&drainage_improvement_val="+Percent5Text+"&deep_patch_val="+Percent6Text+"&haul_debris_val="+Percent7Text+
                    "&scaling_rock_slopes_val="+Percent8Text+"&road_trail_alignment_val="+Percent9Text+"&repair_rockfall_barrier_val="+Percent10Text+
                    "&repair_rockfall_netting_val="+Percent11Text+"&sealing_cracks_val="+Percent12Text+"&guardrail_val="+Percent13Text+"&cleaning_drains_val="+Percent14Text+
                    "&flagging_signing_val="+Percent15Text+"&other1_desc="+Other1Text+"&other1_val="+Percent16Text+"&other2_desc="+Other2Text+"&other2_val="+Percent17Text+
                    "&other3_desc="+Other3Text+"&other3_val="+Percent18Text+"&other4_desc="+Other4Text+"&other4_val="+Percent19Text+"&other5_desc="+Other5Text+
                    "&other5_val="+Percent20Text+"&total="+TotalPercent);
                    writer.flush();
                    String line;
                    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    while ((line = reader.readLine()) != null) {
                        System.out.println(line);
                    }
                    writer.close();

                    reader.close();
                } catch (Exception e) {

                    e.printStackTrace();
                }
            }
        });

        thread.start();

    }

    //create a new maintenance form to save offline
    public void newMaintenance(View view){
        MaintenanceDBHandler dbHandler = new MaintenanceDBHandler(this, null, null, 1);

        //id
        int site_id = 0;
        String code_relation = Mcode.getText().toString();
        int maintenance_type = MaintenanceType.getSelectedItemPosition();
        String rt_num = RTNumber.getText().toString();
        String begin_mile = BeginMile.getText().toString();
        String end_mile = EndMile.getText().toString();
        int agency = Agency.getSelectedItemPosition();
        int regional = Regional.getSelectedItemPosition();
        int local = Local.getSelectedItemPosition();
        int us_event = EventType.getSelectedItemPosition();
        String event_desc = MDescription.getText().toString();
        int total = 0;
        if(!TotalCost.getText().toString().isEmpty()) {
            total = Integer.parseInt(TotalCost.getText().toString());
        }
        int p1 = 0;
        if(!Percent1.getText().toString().isEmpty()) {
            p1 = Integer.parseInt(Percent1.getText().toString());
        }

        int p2=0;
        if(!Percent2.getText().toString().isEmpty()) {
            p2 = Integer.parseInt(Percent2.getText().toString());
        }

        int p3=0;
        if(!Percent3.getText().toString().isEmpty()) {
            p3 = Integer.parseInt(Percent3.getText().toString());
        }
        int p4=0;
        if(!Percent4.getText().toString().isEmpty()) {
            p4 = Integer.parseInt(Percent4.getText().toString());
        }
        int p4_5=0;
        if(!Percent4_5.getText().toString().isEmpty()) {
            p4_5 = Integer.parseInt(Percent4_5.getText().toString());
        }
        int p5=0;
        if(!Percent5.getText().toString().isEmpty()) {
            p5 = Integer.parseInt(Percent5.getText().toString());
        }
        int p6=0;
        if(!Percent6.getText().toString().isEmpty()) {
            p6 = Integer.parseInt(Percent6.getText().toString());
        }
        int p7=0;
        if(!Percent7.getText().toString().isEmpty()) {
            p7 = Integer.parseInt(Percent7.getText().toString());
        }
        int p8=0;
        if(!Percent8.getText().toString().isEmpty()) {
            p8 = Integer.parseInt(Percent8.getText().toString());
        }
        int p9=0;
        if(!Percent9.getText().toString().isEmpty()) {
            p9 = Integer.parseInt(Percent9.getText().toString());
        }
        int p10=0;
        if(!Percent10.getText().toString().isEmpty()) {
            p10 = Integer.parseInt(Percent10.getText().toString());
        }
        int p11=0;
        if(!Percent11.getText().toString().isEmpty()) {
            p11 = Integer.parseInt(Percent11.getText().toString());
        }
        int p12=0;
        if(!Percent12.getText().toString().isEmpty()) {
            p12 = Integer.parseInt(Percent12.getText().toString());
        }
        int p13=0;
        if(!Percent13.getText().toString().isEmpty()) {
            p13 = Integer.parseInt(Percent13.getText().toString());
        }
        int p14=0;
        if(!Percent14.getText().toString().isEmpty()) {
            p14 = Integer.parseInt(Percent14.getText().toString());
        }
        int p15=0;
        if(!Percent15.getText().toString().isEmpty()) {
            p15 = Integer.parseInt(Percent15.getText().toString());
        }
        int p16=0;
        if(!Percent16.getText().toString().isEmpty()) {
            p16 = Integer.parseInt(Percent16.getText().toString());
        }
        int p17=0;
        if(!Percent17.getText().toString().isEmpty()) {
            p17 = Integer.parseInt(Percent17.getText().toString());
        }
        int p18=0;
        if(!Percent18.getText().toString().isEmpty()) {
            p18 = Integer.parseInt(Percent18.getText().toString());
        }
        int p19=0;
        if(!Percent19.getText().toString().isEmpty()) {
            p19 = Integer.parseInt(Percent19.getText().toString());
        }
        System.out.println("P19 IS: "+p19);

        int p20=0;
        if(!Percent20.getText().toString().isEmpty()) {
            p20 = Integer.parseInt(Percent20.getText().toString());
        }
        String others1_desc = Other1.getText().toString();
        String others2_desc = Other2.getText().toString();
        String others3_desc = Other3.getText().toString();
        String others4_desc = Other4.getText().toString();
        String others5_desc = Other5.getText().toString();
        int total_percent=0;
        if(!RunningTotal.getText().toString().isEmpty()) {
            total_percent = Integer.parseInt(RunningTotal.getText().toString());
        }

        Maintenance maintenance =
                new Maintenance(site_id, code_relation,maintenance_type,rt_num,begin_mile,end_mile,
                        agency,regional,local,us_event,event_desc,total,p1,p2,p3,p4,p4_5,p5,p6,p7,p8,
                        p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,others1_desc,others2_desc,others3_desc,
                        others4_desc,others5_desc,total_percent);

        dbHandler.addMaintenance(maintenance);

        //saved....zero out the fields to start over

        //MaintenanceID.setSelection(0);
        Mcode.setText("");
        MaintenanceType.setSelection(0);
        RTNumber.setText("");
        BeginMile.setText("");
        EndMile.setText("");
        Agency.setSelection(0);
        Regional.setSelection(0);
        Local.setSelection(0);
        EventType.setSelection(0);
        TotalCost.setText("");
        Percent1.setText("");
        Percent2.setText("");
        Percent3.setText("");
        Percent4.setText("");
        Percent4_5.setText("");
        Percent5.setText("");
        Percent6.setText("");
        Percent7.setText("");
        Percent8.setText("");
        Percent9.setText("");
        Percent10.setText("");
        Percent11.setText("");
        Percent12.setText("");
        Percent13.setText("");
        Percent14.setText("");
        Percent15.setText("");
        Percent16.setText("");
        Percent17.setText("");
        Percent18.setText("");
        Percent19.setText("");
        Percent20.setText("");
        Other1.setText("");
        Other2.setText("");
        Other3.setText("");
        Other4.setText("");
        Other5.setText("");
        RunningTotal.setText("");

    }

    //find a maintenance form by unique site id #
    public void lookupMaintenance (int finder) {
        MaintenanceDBHandler dbHandler = new MaintenanceDBHandler(this, null, null, 1);

        Maintenance maintenance =
                dbHandler.findMaintenance(finder); //fill how?

        //set everything...
        if (maintenance != null) {
            Mcode.setText(maintenance.getCode_relation());
            MaintenanceType.setSelection(maintenance.getMaintenance_type());
            RTNumber.setText(maintenance.getRt_num());
            BeginMile.setText(maintenance.getBegin_mile());
            EndMile.setText(maintenance.getEnd_mile());
            Agency.setSelection(maintenance.getAgency());
            Regional.setSelection(maintenance.getRegional());
            Local.setSelection(maintenance.getLocal());
            EventType.setSelection(maintenance.getUs_event());
            MDescription.setText(String.valueOf(maintenance.getEvent_desc()));
            TotalCost.setText(String.valueOf(maintenance.getTotal()));
            Percent1.setText(String.valueOf(maintenance.getP1()));
            Percent2.setText(String.valueOf(maintenance.getP2()));
            Percent3.setText(String.valueOf(maintenance.getP3()));
            Percent4.setText(String.valueOf(maintenance.getP4()));
            Percent4_5.setText(String.valueOf(maintenance.getP4_5()));
            Percent5.setText(String.valueOf(maintenance.getP5()));
            Percent6.setText(String.valueOf(maintenance.getP6()));
            Percent7.setText(String.valueOf(maintenance.getP7()));
            Percent8.setText(String.valueOf(maintenance.getP8()));
            Percent9.setText(String.valueOf(maintenance.getP9()));
            Percent10.setText(String.valueOf(maintenance.getP10()));
            Percent11.setText(String.valueOf(maintenance.getP11()));
            Percent12.setText(String.valueOf(maintenance.getP12()));
            Percent13.setText(String.valueOf(maintenance.getP13()));
            Percent14.setText(String.valueOf(maintenance.getP14()));
            Percent15.setText(String.valueOf(maintenance.getP15()));
            Percent16.setText(String.valueOf(maintenance.getP16()));
            Percent17.setText(String.valueOf(maintenance.getP17()));
            Percent18.setText(String.valueOf(maintenance.getP18()));
            Percent19.setText(String.valueOf(maintenance.getP19()));
            Percent20.setText(String.valueOf(maintenance.getP20()));
            Other1.setText(String.valueOf(maintenance.getOthers1_desc()));
            Other2.setText(String.valueOf(maintenance.getOthers2_desc()));
            Other3.setText(String.valueOf(maintenance.getOthers3_desc()));
            Other4.setText(String.valueOf(maintenance.getOthers4_desc()));
            Other5.setText(String.valueOf(maintenance.getOthers5_desc()));
            RunningTotal.setText(String.valueOf(maintenance.getTotal_percent()));

            if(OfflineList.should_submit==true){
                OfflineList.should_submit=false;
                //submit button perform click...
                SubmitButton.performClick();

            }

        } else {
            Mcode.setText("No Match Found");
        }
    }
}
