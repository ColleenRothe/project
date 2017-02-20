package teammsu.colleenrothe.usmp;
//source: post request
//http://www.java2blog.com/2016/07/how-to-send-http-request-getpost-in-java.html
//http://stackoverflow.com/questions/6343166/how-to-fix-android-os-networkonmainthreadexception

//how to check internet connectivity:
//http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity





import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Region;
import android.location.Location;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
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
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Pattern;

import android.widget.AdapterView.OnItemSelectedListener;

import java.io.OutputStreamWriter;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import java.net.URL;
import java.net.URLConnection;
import java.io.StringReader;

import java.util.*;



import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.games.event.Event;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.google.gson.stream.JsonReader;

import android.view.View.OnFocusChangeListener;

public class LandslideActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener, GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    //<<<SITE INFORMATION>>>
    Spinner Agency;
    Spinner Regional;
    Spinner Local;
    EditText Date;
    EditText RoadTrailNo;
    Spinner RoadTrail;
    EditText RoadTrailClass;
    EditText Rater;
    EditText BeginMile;
    EditText EndMile;
    Spinner Side;
    Spinner Weather;
    EditText HazardType;
    EditText BeginLat;
    EditText EndLat;
    EditText BeginLong;
    EditText EndLong;
    EditText Datum;
    EditText Aadt;
    EditText LengthAffected;
    EditText AxialLength;
    EditText SlopeAngle;
    EditText SightDistance;
    EditText RtWidth;
    Spinner Speed;
    EditText DitchWidth1;
    EditText DitchWidth2;
    EditText DitchDepth1;
    EditText DitchDepth2;
    EditText DitchSlope1;
    EditText DitchSlope2;
    EditText DitchSlope3;
    EditText DitchSlope4;
    EditText AnnualRain1;
    EditText AnnualRain2;
    Spinner SoleAccess;
    Spinner Mitigation;
    //photos go here
    EditText Comments;
    EditText FlmaName;
    EditText FlmaId;
    EditText FlmaDescription;


    //<<<PRELIMINARY RATINGS>>
    Spinner RWidthAffected; //A
    Spinner SlideErosion; //B
    EditText RLengthAffected; //C
    Spinner ImpactOU; //G
    EditText AadtEtc; //H
    CheckBox CheckAadt; //H checkbox
    Boolean aadtCheckmark = false; //H Checkmark
    //Prelim Total
    EditText PrelimRating;

    //<<<SLOPE HAZARD RATINGS>>>
    Spinner SlopeDrainage; //I
    EditText AnnualRainfall; //J
    EditText AxialLOS; //K
    Spinner ThawStability; //L
    Spinner InstabilityRMF; //M
    Spinner MovementHistory; //N
    //Hazard Total
    EditText HazardTotal;

    //<<RISK RATINGS>>
    EditText RouteTW; //V
    EditText HumanEF; //W
    EditText PercentDSD; //X
    Spinner RightOWI; //Y
    Spinner ECImpact; //Z
    Spinner MaintComplexity; //AA
    Spinner EventCost; //BB
    //Risk Total
    EditText RiskTotal;

    //Final Total
    EditText Total;

    //Submit Button.....
    Button SubmitButton;

    //Location Stuff...
    private GoogleApiClient mGoogleApiClient;
    private Location mLastLocation;
    LocationRequest mLocationRequest;

    ArrayAdapter<String> adapterRegional;
    ArrayList<String> fs_regions;

    ArrayAdapter<String> adapterLocal;
    ArrayList<String> fs_local1;

    //edit site
    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/getLandslide.php"; //to place the sites
    Map<String, String> map;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landslide);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        SubmitButton = (Button) findViewById(R.id.LSubmitButton);

        //<<<SITE INFORMATION>>>
        Agency = (Spinner) findViewById(R.id.LAgency);
        Agency.setFocusable(true);
        Agency.setFocusableInTouchMode(true);
        Regional = (Spinner) findViewById(R.id.LRegional);
        Regional.setFocusable(true);
        Regional.setFocusableInTouchMode(true);
        Local = (Spinner) findViewById(R.id.LLocal);
        Local.setFocusable(true);
        Local.setFocusableInTouchMode(true);

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

//                Toast.makeText(getApplicationContext(),
//                        "Selected Agency : " + agency, Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // do nothing....
            }
        });



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
;

        fs_regions = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterRegional = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_regions);
        adapterRegional.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Regional.setAdapter(adapterRegional);



        fs_local1 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterLocal = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_local1);
        adapterLocal.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Local.setAdapter(adapterLocal);




        Date = (EditText) findViewById(R.id.L_Date);
        Calendar cal = Calendar.getInstance(TimeZone.getDefault());
        SimpleDateFormat sdf = new SimpleDateFormat("dd:MMMM:yyyy HH:mm:ss a");
        String strDate = sdf.format(cal.getTime());
        Date.setText(strDate, TextView.BufferType.EDITABLE);

        RoadTrail = (Spinner) findViewById(R.id.L_RoadTrail);
        RoadTrail.setFocusable(true);
        RoadTrail.setFocusableInTouchMode(true);
        RoadTrail.setOnItemSelectedListener(rtWatcher);

        RoadTrailNo = (EditText) findViewById(R.id.L_RoadTrailNo);
        RoadTrailNo.setOnFocusChangeListener(roadTrailNoWatcher);

        RoadTrailClass = (EditText) findViewById(R.id.L_RoadTrailClass);
        RoadTrailClass.setOnFocusChangeListener(roadTrailClassWatcher);

        Rater = (EditText) findViewById(R.id.L_Rater);
        Rater.setOnFocusChangeListener(raterWatcher);

        BeginMile = (EditText) findViewById(R.id.L_BeginMile);
        BeginMile.setOnFocusChangeListener(beginMileWatcher);

        EndMile = (EditText) findViewById(R.id.L_EndMile);
        EndMile.setOnFocusChangeListener(endMileWatcher);

        Side = (Spinner) findViewById(R.id.L_Side);
        Side.setFocusable(true);
        Side.setFocusableInTouchMode(true);

        Weather = (Spinner) findViewById(R.id.L_Weather);
        Weather.setFocusable(true);
        Weather.setFocusableInTouchMode(true);

        HazardType = (EditText) findViewById(R.id.L_HazardType);
        HazardType.setOnFocusChangeListener(hazardTypeWatcher);

        BeginLat = (EditText) findViewById(R.id.L_BeginLat);
        BeginLat.setOnFocusChangeListener(beginLatWatcher);

        EndLat = (EditText) findViewById(R.id.L_EndLat);
        EndLat.setOnFocusChangeListener(endLatWatcher);

        BeginLong = (EditText) findViewById(R.id.L_BeginLong);
        BeginLong.setOnFocusChangeListener(beginLongWatcher);

        EndLong = (EditText) findViewById(R.id.L_EndLong);
        EndLong.setOnFocusChangeListener(endLongWatcher);

        Datum = (EditText) findViewById(R.id.L_Datum);

        Aadt = (EditText) findViewById(R.id.L_Paadt);
        Aadt.setOnFocusChangeListener(aadtWatcher);

        LengthAffected = (EditText) findViewById(R.id.L_LengthAffected);
        LengthAffected.setOnFocusChangeListener(lengthAffectedWatcher);

        AxialLength = (EditText) findViewById(R.id.L_AxialLength);
        AxialLength.setOnFocusChangeListener(axialLengthWatcher);

        SlopeAngle = (EditText) findViewById(R.id.L_SlopeAngle);
        SlopeAngle.setOnFocusChangeListener(slopeAngleWatcher);

        SightDistance = (EditText) findViewById(R.id.L_SightDistance);
        SightDistance.setOnFocusChangeListener(sightDistanceWatcher);
        //SightDistance.setOnFocusChangeListener(dsdWatcher);


        RtWidth = (EditText) findViewById(R.id.L_RtWidth);
        RtWidth.setOnFocusChangeListener(rtWidthWatcher);


        Speed = (Spinner) findViewById(R.id.L_Speed);
        Speed.setFocusable(true);
        Speed.setFocusableInTouchMode(true);
        Speed.setOnItemSelectedListener(speedWatcher);
        //Speed.setOnItemSelectedListener(riskWatcher); //NEW NEW NEW NEW

        DitchWidth1 = (EditText) findViewById(R.id.L_DitchWidth1);
        DitchWidth1.setOnFocusChangeListener(ditchWidth1Watcher);

        DitchWidth2 = (EditText) findViewById(R.id.L_DitchWidth2);
        DitchWidth2.setOnFocusChangeListener(ditchWidth2Watcher);

        DitchDepth1 = (EditText) findViewById(R.id.L_DitchDepth1);
        DitchDepth1.setOnFocusChangeListener(ditchDepth1Watcher);

        DitchDepth2 = (EditText) findViewById(R.id.L_DitchDepth2);
        DitchDepth2.setOnFocusChangeListener(ditchDepth2Watcher);

        DitchSlope1 = (EditText) findViewById(R.id.L_DitchSlope1);
        DitchSlope1.setOnFocusChangeListener(ditchSlope1Watcher);

        DitchSlope2 = (EditText) findViewById(R.id.L_DitchSlope2);
        DitchSlope2.setOnFocusChangeListener(ditchSlope2Watcher);

        DitchSlope3 = (EditText) findViewById(R.id.L_DitchSlope3);
        DitchSlope3.setOnFocusChangeListener(ditchSlope3Watcher);

        DitchSlope4 = (EditText) findViewById(R.id.L_DitchSlope4);
        DitchSlope4.setOnFocusChangeListener(ditchSlope4Watcher);

        AnnualRain1 = (EditText) findViewById(R.id.L_AnnualRain1);
        AnnualRain1.setOnFocusChangeListener(rainWatcher1);

        AnnualRain2 = (EditText) findViewById(R.id.L_AnnualRain2);
        AnnualRain2.setOnFocusChangeListener(rainWatcher2);

        SoleAccess = (Spinner) findViewById(R.id.L_SoleAccess);
        SoleAccess.setFocusableInTouchMode(true);
        SoleAccess.setFocusable(true);

        Mitigation = (Spinner) findViewById(R.id.L_Mitigation);
        Mitigation.setFocusableInTouchMode(true);
        Mitigation.setFocusable(true);

        //Photos here

        Comments= (EditText) findViewById(R.id.L_Comments);
        FlmaName= (EditText) findViewById(R.id.L_FlmaName);
        FlmaId= (EditText) findViewById(R.id.L_FlmaId);
        FlmaDescription = (EditText) findViewById(R.id.L_FlmaDescription);

        //<<<PRELIMINARY RATINGS>>>
        RWidthAffected = (Spinner) findViewById(R.id.L_RWidthAffected); //A
        RWidthAffected.setFocusable(true);
        RWidthAffected.setFocusableInTouchMode(true);
        RWidthAffected.setOnItemSelectedListener(prelimWatcher);
        RWidthAffected.setOnItemSelectedListener(slopeHazardWatcher);

        SlideErosion = (Spinner) findViewById(R.id.L_SlideErosion); //B
        SlideErosion.setFocusable(true);
        SlideErosion.setFocusableInTouchMode(true);
        SlideErosion.setOnItemSelectedListener(prelimWatcher);
        RWidthAffected.setOnItemSelectedListener(slopeHazardWatcher);

        RLengthAffected = (EditText) findViewById(R.id.L_RLengthAffected); //C
        RLengthAffected.setOnFocusChangeListener(rLengthAffectedWatcher);

        ImpactOU = (Spinner) findViewById(R.id.L_ImpactOU); //G
        ImpactOU.setFocusable(true);
        ImpactOU.setFocusableInTouchMode(true);
        ImpactOU.setOnItemSelectedListener(prelimWatcher);
        ImpactOU.setOnItemSelectedListener(riskWatcher);

        AadtEtc = (EditText) findViewById(R.id.L_AadtEtc); //H
        CheckAadt = (CheckBox) findViewById(R.id.L_CheckAadt);
        AadtEtc.setOnFocusChangeListener(aadtEtcWatcher);

        PrelimRating = (EditText) findViewById(R.id.L_PrelimRating);


        //<<<SLOPE HAZARD RATINGS>>>
        SlopeDrainage = (Spinner) findViewById(R.id.L_SlopeDrainage); //I
        SlopeDrainage.setFocusable(true);
        SlopeDrainage.setFocusableInTouchMode(true);
        SlopeDrainage.setOnItemSelectedListener(slopeHazardWatcher);

        AnnualRainfall = (EditText) findViewById(R.id.L_AnnualRainfall); //J
        AnnualRainfall.setOnFocusChangeListener(annualRainfallWatcher);

        AxialLOS = (EditText) findViewById(R.id.L_AxialLos); //K
        AxialLOS.setOnFocusChangeListener(axialLOSWatcher);

        ThawStability = (Spinner) findViewById(R.id.L_ThawStability); //L
        ThawStability.setFocusable(true);
        ThawStability.setFocusableInTouchMode(true);
        ThawStability.setOnItemSelectedListener(slopeHazardWatcher);

        InstabilityRMF = (Spinner) findViewById(R.id.L_InstabilityRMF);//M
        InstabilityRMF.setFocusable(true);
        InstabilityRMF.setFocusableInTouchMode(true);
        InstabilityRMF.setOnItemSelectedListener(slopeHazardWatcher);

        MovementHistory = (Spinner) findViewById(R.id.L_MovementHistory); //N
        MovementHistory.setFocusable(true);
        MovementHistory.setFocusableInTouchMode(true);
        MovementHistory.setOnItemSelectedListener(slopeHazardWatcher);

        HazardTotal = (EditText) findViewById(R.id.L_HazardTotal);
        HazardTotal.addTextChangedListener(totalWatcher);


        //<<<RISK RATINGS>>>
        RouteTW = (EditText) findViewById(R.id.L_RouteTW); //V
        RouteTW.setOnFocusChangeListener(routeTWWatcher);

        HumanEF = (EditText) findViewById(R.id.L_HumanEF); //W
        HumanEF.setText("1");
        HumanEF.setOnFocusChangeListener(humanEFCalcWatcher);

        PercentDSD = (EditText) findViewById(R.id.L_PercentDSD);//X
        PercentDSD.setOnFocusChangeListener(percentDsdWatcher);

        RightOWI = (Spinner) findViewById(R.id.L_RightOWI); //Y
        RightOWI.setFocusable(true);
        RightOWI.setFocusableInTouchMode(true);
        RightOWI.setOnItemSelectedListener(riskWatcher);

        ECImpact = (Spinner) findViewById(R.id.L_ECImpact); //Z
        ECImpact.setFocusable(true);
        ECImpact.setFocusableInTouchMode(true);
        ECImpact.setOnItemSelectedListener(riskWatcher);

        MaintComplexity = (Spinner) findViewById(R.id.L_MaintComplexity); //AA
        MaintComplexity.setFocusable(true);
        MaintComplexity.setFocusableInTouchMode(true);
        MaintComplexity.setOnItemSelectedListener(riskWatcher);

        EventCost = (Spinner) findViewById(R.id.L_EventCost); //BB
        EventCost.setFocusable(true);
        EventCost.setFocusableInTouchMode(true);
        EventCost.setOnItemSelectedListener(riskWatcher);

        RiskTotal = (EditText) findViewById(R.id.L_RiskTotal);
        RiskTotal.addTextChangedListener(totalWatcher);


        //FINAL TOTAL
        Total = (EditText) findViewById(R.id.L_TotalScore);

        //LOAD
        if (OfflineList.selected_row!=-1 && OfflineList.should_load==true){
            OfflineList.should_load=false;
            lookupLandslide(OfflineList.selected_row);
        }

        //EDIT
        if(getIntent().getStringExtra("editing") != null){
            System.out.println("yay! please do edit");
            getJSON(JSON_URL);
        }



        if(!isNetworkAvailable()){
            SubmitButton.setBackgroundColor(Color.DKGRAY);
            SubmitButton.setClickable(false);
        }


        //PRE-GIVEN STUFF

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);


        // Create an instance of GoogleAPIClient.
        if (mGoogleApiClient == null) {
            mGoogleApiClient = new GoogleApiClient.Builder(this)
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .addApi(LocationServices.API)
                    .build();
        }

        createLocationRequest();



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

    protected void createLocationRequest() {
        System.out.println("create Location Request");
        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(20000);
        mLocationRequest.setFastestInterval(5000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }


    @Override
    protected void onStart() {
        super.onStart();
        if (mGoogleApiClient != null) {
            mGoogleApiClient.connect();
        }

    }


    @Override
    public void onConnected(Bundle bundle) {
        //permissions...
        mLastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
//        if (mLastLocation != null) {
//            System.out.println("weird toast stuff");
//
//            Toast.makeText(this, "Latitude:" + mLastLocation.getLatitude() + ", Longitude:" + mLastLocation.getLongitude(), Toast.LENGTH_LONG).show();
//
//        }

    }

    //HERE Location
    public void setBeginCoords(View view) {
        if (mLastLocation != null) {
            BeginLat.setText(String.valueOf(mLastLocation.getLatitude()));
            BeginLong.setText(String.valueOf(mLastLocation.getLongitude()));

        }

    }

    public void setEndCoords(View view) {
        if (mLastLocation != null) {
            EndLat.setText(String.valueOf(mLastLocation.getLatitude()));
            EndLong.setText(String.valueOf(mLastLocation.getLongitude()));
        }

    }

    @Override
    public void onConnectionSuspended(int i) {

    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {

    }

//    protected void startLocationUpdates() {
//        //LocationServices.FusedLocationApi.requestLocationUpdates(
//                //mGoogleApiClient, mLocationRequest, this);
//        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient,mLocationRequest,this);
//    }


    @Override
    protected void onStop() {
        super.onStop();
        if (mGoogleApiClient != null) {
            mGoogleApiClient.disconnect();
        }
    }

    public void onLocationChanged(Location location) {
        mLastLocation = location;
        //Toast.makeText(this, "Latitude:" + mLastLocation.getLatitude()+", Longitude:"+mLastLocation.getLongitude(),Toast.LENGTH_LONG).show();
        System.out.println("made it here finally");
    }


    //EDIT FORM
    public void GetText() throws UnsupportedEncodingException {
        //intent thing
        String id = getIntent().getStringExtra("editing");
        String data="id="+id;
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


                text2 = text2.replace("[",""); //old,new
                text2 = text2.replace("]",""); //old,new
                text2 = text2.replace("{",""); //old,new
                text2 = text2.replace("}",""); //old,new
                String text3 = "{";
                text3 = text3.concat(text2);
                text3 =text3.concat("}");

                //System.out.println(text3);



                //Map<String, String> map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                map = new Gson().fromJson(text3, new TypeToken<HashMap<String, String>>() {}.getType());
                System.out.println(map);
                //System.out.println(map.get("ID"));

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


                Date.setText(map.get("DATE"));
                RoadTrailNo.setText(map.get("ROAD_TRAIL_NO"));
                String road_or_trail = map.get("ROAD_OR_TRAIL");
                if(road_or_trail.equals("1")){
                    RoadTrail.setSelection(1);
                }
                else{
                    RoadTrail.setSelection(0);
                }
                RoadTrailClass.setText(map.get("ROAD_TRAIL_CLASS"));
                Rater.setText(map.get("RATER"));
                BeginMile.setText(map.get("BEGIN_MILE_MARKER"));
                EndMile.setText(map.get("END_MILE_MARKER"));

                String side = map.get("SIDE");
                String [] sideArray = getResources().getStringArray(R.array.sideList);
                for(int i = 0; i<sideArray.length;i++){
                    if(sideArray[i].equals(side)){
                        Side.setSelection(i);
                    }
                }

                String weather = map.get("WEATHER");
                String [] weatherArray = getResources().getStringArray(R.array.weatherList);
                for(int i = 0; i<weatherArray.length;i++){
                    if(weatherArray[i].equals(weather)){
                        Weather.setSelection(i);
                    }
                }

                HazardType.setText(map.get("HAZARD_TYPE"));

                BeginLat.setText(map.get("BEGIN_COORDINATE_LAT"));
                EndLat.setText(map.get("END_COORDINATE_LAT"));
                BeginLong.setText(map.get("BEGIN_COORDINATE_LONG"));
                EndLong.setText(map.get("END_COORDINATE_LONG"));
                Datum.setText(map.get("DATUM"));
                Aadt.setText(map.get("AADT"));
                LengthAffected.setText(map.get("LENGTH_AFFECTED"));
                AxialLength.setText(map.get("SLOPE_HT_AXIAL_LENGTH"));
                SlopeAngle.setText(map.get("SLOPE_ANGLE"));
                SightDistance.setText(map.get("SIGHT_DISTANCE"));
                RtWidth.setText(map.get("ROAD_TRAIL_WIDTH"));

                //speed???? need to look into that...

                DitchWidth1.setText(map.get("MINIMUM_DITCH_WIDTH"));
                DitchWidth2.setText(map.get("MAXIMUM_DITCH_WIDTH"));
                DitchDepth1.setText(map.get("MINIMUM_DITCH_DEPTH"));
                DitchDepth2.setText(map.get("MAXIMUM_DITCH_DEPTH"));
                DitchSlope1.setText(map.get("MINIMUM_DITCH_SLOPE_FIRST"));
                DitchSlope2.setText(map.get("MAXIMUM_DITCH_SLOPE_FIRST"));
                DitchSlope3.setText(map.get("MINIMUM_DITCH_SLOPE_SECOND"));
                DitchSlope4.setText(map.get("MAXIMUM_DITCH_SLOPE_SECOND"));

                //blk size
                //volume

                AnnualRain1.setText(map.get("BEGIN_ANNUAL_RAINFALL"));
                AnnualRain2.setText(map.get("END_ANNUAL_RAINFALL"));

                String sole_access_route = map.get("SOLE_ACCESS_ROUTE");
                if(sole_access_route.equals("yes")){
                    SoleAccess.setSelection(1);
                }else{
                    SoleAccess.setSelection(0);
                }

                String fixes_present = map.get("FIXES_PRESENT");
                if(fixes_present.equals("yes")){
                    Mitigation.setSelection(1);
                }else{
                    Mitigation.setSelection(0);
                }

                //photos?

                Comments.setText(map.get("COMMENT"));
                FlmaName.setText(map.get("FLMA_NAME"));
                FlmaId.setText(map.get("FLMA_ID"));
                FlmaDescription.setText(map.get("FLMA_DESCRIPTION"));

                //PRELIMINARY RATINGS-LANDSLIDE ONLY
                String [] ratingArray = getResources().getStringArray(R.array.ratingList);

                String landslide_prelim_road_width_affected = map.get("LANDSLIDE_PRELIM_ROAD_WIDTH_AFFECTED");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(landslide_prelim_road_width_affected)){
                        RWidthAffected.setSelection(i);
                    }
                }

                String landslide_prelim_slide_erosion_effects = map.get("LANDSLIDE_PRELIM_SLIDE_EROSION_EFFECTS");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(landslide_prelim_slide_erosion_effects)){
                        SlideErosion.setSelection(i);
                    }
                }

                RLengthAffected.setText(map.get("LANDSLIDE_PRELIM_LENGTH_AFFECTED"));

                //PRELIM RATINGS ALL
                String preliminary_rating_impact_on_use = map.get("PRELIMINARY_RATING_IMPACT_ON_USE");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(preliminary_rating_impact_on_use)){
                        ImpactOU.setSelection(i);
                    }
                }

                String aadt_checkbox = (map.get("PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX"));
                if(aadt_checkbox == "1"){
                    CheckAadt.toggle();
                    aadtCheckmark = true;
                }

                AadtEtc.setText(map.get("PRELIMINARY_RATING_AADT_USAGE_CALC_CHECKBOX"));
                PrelimRating.setText(map.get("PRELIMINARY_RATING"));

                //Slope Hazard Ratings ALL

                String hazard_rating_slope_drainage = map.get("HAZARD_RATING_SLOPE_DRAINAGE");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(hazard_rating_slope_drainage)){
                        SlopeDrainage.setSelection(i);
                    }
                }

                AnnualRainfall.setText(map.get("HAZARD_RATING_ANNUAL_RAINFALL"));
                AxialLOS.setText(map.get("HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH"));
                HazardTotal.setText(map.get("HAZARD_TOTAL"));

                //Slope Hazard Ratings->Landslide Only
                String landslide_hazard_rating_thaw_stability = map.get("LANDSLIDE_HAZARD_RATING_THAW_STABILITY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(landslide_hazard_rating_thaw_stability)){
                        ThawStability.setSelection(i);
                    }
                }

                String landslide_hazard_rating_maint_frequency = map.get("LANDSLIDE_HAZARD_RATING_MAINT_FREQUENCY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(landslide_hazard_rating_maint_frequency)){
                        InstabilityRMF.setSelection(i);
                    }
                }

                String landslide_hazard_rating_movement_history = map.get("LANDSLIDE_HAZARD_RATING_MOVEMENT_HISTORY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(landslide_hazard_rating_movement_history)){
                        MovementHistory.setSelection(i);
                    }
                }

                //Risk Ratings-ALL
                RouteTW.setText(map.get("RISK_RATING_ROUTE_TRAIL"));
                HumanEF.setText(map.get("RISK_RATING_HUMAN_EX_FACTOR"));
                PercentDSD.setText(map.get("RISK_RATING_PERCENT_DSD"));
                String risk_rating_r_w_impacts = map.get("RISK_RATING_R_W_IMPACTS");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(risk_rating_r_w_impacts)){
                        RightOWI.setSelection(i);
                    }
                }
                String risk_rating_enviro_cult_impacts = map.get("RISK_RATING_ENVIRO_CULT_IMPACTS");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(risk_rating_r_w_impacts)){
                        ECImpact.setSelection(i);
                    }
                }

                String risk_rating_maint_complexity = map.get("RISK_RATING_MAINT_COMPLEXITY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(risk_rating_maint_complexity)){
                        MaintComplexity.setSelection(i);
                    }
                }

                String risk_rating_event_cost = map.get("RISK_RATING_EVENT_COST");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(risk_rating_event_cost)){
                        EventCost.setSelection(i);
                    }
                }

                RiskTotal.setText(map.get("RISK_TOTAL"));
                Total.setText(map.get("TOTAL_SCORE"));

            }
        });


    }
    private void getJSON(String url) {
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



    //Road Trail No. Verification
    private final OnFocusChangeListener roadTrailNoWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (RoadTrailNo.getText().length() == 0) {
                    RoadTrailNo.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Road/Trail No. must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    RoadTrailNo.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }
        }
    };

    //Road Trail Class Verification
    private final OnFocusChangeListener roadTrailClassWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (RoadTrailClass.getText().length() == 0) {
                    RoadTrailClass.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Road/Trail class must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    RoadTrailClass.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }
        }

    };
    //Rater Verification
    private final OnFocusChangeListener raterWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (Rater.getText().length() == 0 || Rater.getText().length() >= 30) {
                    Rater.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Rater cannot be empty and must be shorter than 30 characters.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    Rater.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }
        }

    };

    //Begin Mile Verification
    private final OnFocusChangeListener beginMileWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginMile.getText().toString();

                if (text.length() == 0 || (!Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    BeginMile.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Beginning Mile Marker must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    BeginMile.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }
        }

    };

    //Begin Mile Verification
    private final OnFocusChangeListener endMileWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndMile.getText().toString();

                if (text.length() == 0 || (!Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    EndMile.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ending Mile Marker must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    EndMile.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }
        }

    };

    //Hazard Type Verification
    private final OnFocusChangeListener hazardTypeWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (HazardType.getText().length() == 0 || HazardType.getText().length() >= 255) {
                    HazardType.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Hazard Type cannot be empty and must be shorter than 255 characters.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    HazardType.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }

            }
        }

    };


    //Latitude Validation


    private final OnFocusChangeListener beginLatWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginLat.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]{2}\\.[0-9]+", text))) {
                    BeginLat.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Begin Latitude must have a value with the appropriate format ##.#####")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    BeginLat.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }

        }

    };

    private final OnFocusChangeListener endLatWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndLat.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]{2}\\.[0-9]+", text))) {
                    EndLat.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("End Latitude must have a value with the appropriate format ##.#####")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    EndLat.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }

        }

    };

    //longitude validation
    private final OnFocusChangeListener beginLongWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginLong.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("\\-[0-9]{3}\\.[0-9]+", text))) {
                    BeginLong.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Begin Longitude must have a value with the appropriate format -###.#####")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    BeginLong.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }

        }

    };

    private final OnFocusChangeListener endLongWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndLong.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("\\-[0-9]{3}\\.[0-9]+", text))) {
                    EndLong.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("End Longitude must have a value with the appropriate format -###.#####")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    EndLong.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }
            }

        }

    };

    //C: when the length affected in site info is changed, update prelim rating roadway length affected
    private final OnFocusChangeListener lengthAffectedWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = LengthAffected.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    LengthAffected.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Length of Affected Road/Trail must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }
                //if not empty...
                else if (text.length() != 0) {
                    System.out.println("NOT ZERO");

                    double x = 1;

                    String length = LengthAffected.getText().toString();
                    Double lengths = Double.parseDouble(length);

                    x = Math.sqrt((lengths / 25.0));

                    double score = Math.pow(3, x);

                    if (score > 100) {
                        score = 100;
                    }
                    int scoreInt = (int) Math.round(score);

                    String scores = String.valueOf(scoreInt);

                    RLengthAffected.setText(scores);
                    calcPrelim();
                    slopeHazardCalc();
                    LengthAffected.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }
            }

        }

    };

    //actual validation if they would change C's text
    private final OnFocusChangeListener rLengthAffectedWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 101;
                if (RLengthAffected.getText().length() != 0) {
                    text = Integer.parseInt(RLengthAffected.getText().toString());
                }
                if (RLengthAffected.length() == 0 || text > 100 || text < 0) {
                    RLengthAffected.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }
                //if not empty...
                else {
                    calcPrelim();
                    slopeHazardCalc();
                    RLengthAffected.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }
            }

        }

    };


    //H: when the site info aadt is changed, update aadt etc.

    //checkbox click

    public void aadtChecked(View view) {
        if (CheckAadt.isChecked()) {
            aadtCheckmark = true;

            if (Aadt.getText().toString().length() != 0) {
                double x = 1;
                String aadt = Aadt.getText().toString();
                Double aadts = Double.parseDouble(aadt);

                x = Math.sqrt((aadts / 25));

                double score = Math.pow(3, x);

                if (score > 100) {
                    score = 100;
                }

                int scoreInt = (int) Math.round(score);

                String scores = String.valueOf(scoreInt);

                AadtEtc.setText(scores);
                calcPrelim();
                calcRiskTotal();
            }


        } else {
            aadtCheckmark = false;
        }

    }

    private final OnFocusChangeListener aadtWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (Aadt.length() == 0) {
                    Aadt.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));
                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("AADT must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }

                //if not empty...
                else if (Aadt.length() != 0) {
                    Aadt.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                    if (aadtCheckmark == true) {

                        double x = 1.;
                        String aadt = Aadt.getText().toString();
                        Double aadts = Double.parseDouble(aadt);

                        x = Math.sqrt((aadts / 25));

                        double score = Math.pow(3, x);

                        if (score > 100) {
                            score = 100;
                        }

                        int scoreInt = (int) Math.round(score);

                        String scores = String.valueOf(scoreInt);

                        AadtEtc.setText(scores);
                    }

                    calcPrelim();
                    calcRiskTotal();

                }
            }

        }

    };

    //validation if they were to manually change H's
    private final OnFocusChangeListener aadtEtcWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (AadtEtc.length() == 0) {
                    AadtEtc.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));
                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }

                //if not empty...
                else if (AadtEtc.length() != 0) {
                    AadtEtc.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                    calcPrelim();
                    calcRiskTotal();

                }

            }

        }

    };


    //Validation: Slope Angle
    private final OnFocusChangeListener slopeAngleWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 100;
                if (SlopeAngle.getText().length() != 0) {
                    text = Integer.parseInt(SlopeAngle.getText().toString()); //problem if there is a .

                }
                if (SlopeAngle.length() == 0 || text < 0 || text > 90) {
                    SlopeAngle.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Slope Angle must have an integer value between 0 and 90 degrees")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    SlopeAngle.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }

            }

        }

    };


    //Validation: Sight Distance
    private final OnFocusChangeListener sightDistanceWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = SightDistance.getText().toString();

                if (SightDistance.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    SightDistance.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Sight Distance must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    double score = 0;
                    double x = 1;
                    int helper = 0;

                    String sightDistanceS = SightDistance.getText().toString();
                    Double sightDistance = Double.parseDouble(sightDistanceS);

                    String speed = Speed.getSelectedItem().toString();

                    if (speed.equals("25mph")) {
                        helper = 375;
                    } else if (speed.equals("30mph")) {
                        helper = 450;
                    } else if (speed.equals("35mph")) {
                        helper = 525;
                    } else if (speed.equals("40mph")) {
                        helper = 600;
                    } else if (speed.equals("45mph")) {
                        helper = 675;
                    } else if (speed.equals("50mph")) {
                        helper = 750;
                    } else if (speed.equals("55mph")) {
                        helper = 875;
                    } else if (speed.equals("60mph")) {
                        helper = 1000;
                    } else if (speed.equals("65mph")) {
                        helper = 1050;
                    }


                    x = ((120 - ((sightDistance / helper) * 100)) / 20);


                    score = Math.pow(3, x);
                    if (score > 100) {
                        score = 100;
                    }

                    int scoreInt = (int) Math.round(score);


                    String scores = String.valueOf(scoreInt);

                    PercentDSD.setText(scores);
                    calcRiskTotal();
                    SightDistance.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    //Validation ditch width(s) validation

    private final OnFocusChangeListener ditchWidth1Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = DitchWidth1.getText().toString();
                if (DitchWidth1.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    DitchWidth1.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch width minimum must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchWidth1.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    private final OnFocusChangeListener ditchWidth2Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = DitchWidth2.getText().toString();
                if (DitchWidth2.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    DitchWidth2.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch width maximum must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchWidth2.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    //Validation: Ditch Depth(s)
    private final OnFocusChangeListener ditchDepth1Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = DitchWidth1.getText().toString();
                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    DitchDepth1.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Depth minimum must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    System.out.println("TEXT IS" + DitchDepth1.getText().toString());
                    DitchDepth1.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    private final OnFocusChangeListener ditchDepth2Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = DitchWidth2.getText().toString();
                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    DitchDepth2.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Depth maximum must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchDepth2.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };
    private final OnFocusChangeListener ditchSlope1Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (DitchSlope1.length() == 0) {
                    DitchSlope1.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Slope first begin must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchSlope1.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    private final OnFocusChangeListener ditchSlope2Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (DitchSlope2.length() == 0) {
                    DitchSlope2.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Slope first end must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchSlope2.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };
    private final OnFocusChangeListener ditchSlope3Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (DitchSlope3.length() == 0) {
                    DitchSlope3.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Slope second begin must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchSlope3.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };

    private final OnFocusChangeListener ditchSlope4Watcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (DitchSlope4.length() == 0) {
                    DitchSlope4.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Ditch Slope second end must have an integer value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                } else {
                    DitchSlope4.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                }


            }

        }

    };


    private final OnItemSelectedListener prelimWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            calcPrelim();
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    //preliminary rating A+B+C+G+H
    public void calcPrelim() {
        int score = 0;
        int a = 0;
        int b = 0;
        int c = 0;
        int g = 0;
        int h = 0;
        //A: spinner roadway width affected
        int aH = RWidthAffected.getSelectedItemPosition();
        if (aH == 0) {
            a = 3;
        } else if (aH == 1) {
            a = 9;
        } else if (aH == 2) {
            a = 27;
        } else if (aH == 3) {
            a = 81;
        }

        //B: slide erosion effects -> spinner
        int bH = SlideErosion.getSelectedItemPosition();
        if (bH == 0) {
            b = 3;
        } else if (bH == 1) {
            b = 9;
        } else if (bH == 2) {
            b = 27;
        } else if (bH == 3) {
            b = 81;
        }
        //C: calculated Landslide/roadway width affected
        int lengthC = RLengthAffected.getText().length();
        if (lengthC != 0) {
            c = Integer.parseInt(RLengthAffected.getText().toString());
            score += c;
        }
        //G: impact on use
        int gH = ImpactOU.getSelectedItemPosition();
        if (gH == 0) {
            g = 3;
        } else if (gH == 1) {
            g = 9;
        } else if (gH == 2) {
            g = 27;
        } else if (gH == 3) {
            g = 81;
        }
        //H: calculated aadt
        int lengthH = AadtEtc.getText().toString().length();
        if (lengthH != 0) {
            h = Integer.parseInt(AadtEtc.getText().toString());
            score += h;
        }


        score = score + a + b + g;

        String scores = String.valueOf(score);
        PrelimRating.setText(scores);


    }

    //SLOPE HAZARD RATINGS
    //J: Update Annual Rainfall
    private final OnFocusChangeListener rainWatcher1 = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = AnnualRain1.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    AnnualRain1.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Annual rainfall minimum must have a decimal value")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }

                //if not empty...
                if (text.length() != 0 && AnnualRain2.getText().toString() != "") {
                    double average = 0;
                    int score = 3;

                    String rainS1 = AnnualRain1.getText().toString();
                    double rain1 = Double.parseDouble(rainS1);

                    String rainS2 = AnnualRain2.getText().toString();
                    double rain2 = Double.parseDouble(rainS1);

                    average = ((rain1 + rain2) / 2);

                    if (average >= 10 && average < 30) {
                        score = 9;
                    } else if (average >= 30 && average < 60) {
                        score = 27;
                    } else if (average >= 60) {
                        score = 81;
                    }

                    String scores = String.valueOf(score);

                    AnnualRainfall.setText(scores);
                    slopeHazardCalc();
                    AnnualRain1.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }


            }

        }

    };

    //J: Update Annual Rainfall

    private final OnFocusChangeListener rainWatcher2 = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = AnnualRain2.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    AnnualRain2.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Annual rainfall maximum must have a decimal value")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }
                //if not empty...
                if (text.length() != 0 && AnnualRain1.getText().toString() != "") {
                    double average = 0;
                    int score = 3;
                    double rain1 = 0;
                    double rain2 = 0;

                    String rainS1 = AnnualRain1.getText().toString();
                    if (rainS1.length() != 0) {
                        rain1 = Double.parseDouble(rainS1);
                    }

                    String rainS2 = AnnualRain2.getText().toString();
                    if (rainS2.length() != 0) {
                        rain2 = Double.parseDouble(rainS1);
                    }

                    average = ((rain1 + rain2) / 2);

                    if (average >= 10 && average < 30) {
                        score = 9;
                    } else if (average >= 30 && average < 60) {
                        score = 27;
                    } else if (average >= 60) {
                        score = 81;
                    }

                    String scores = String.valueOf(score);

                    AnnualRainfall.setText(scores);
                    slopeHazardCalc();
                    AnnualRain2.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }


            }

        }

    };

    //validation if they were to manually change the annual rainfall
    private final OnFocusChangeListener annualRainfallWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 101;
                if (AnnualRainfall.getText().length() != 0) {
                    text = Integer.parseInt(AnnualRainfall.getText().toString());
                }
                if (AnnualRainfall.length() == 0 || text > 100 || text < 0) {
                    AnnualRainfall.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }
                //if not empty...
                else {

                    slopeHazardCalc();
                    AnnualRainfall.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }


            }

        }

    };


    private final OnItemSelectedListener slopeHazardWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            slopeHazardCalc();
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    //Slope Hazard Total: A+B+C+I+J+K+L+M+N
    public void slopeHazardCalc() {
        int score = 0;
        int a = 0;
        int b = 0;
        int c = 0;
        int i = 0;
        int j = 0;
        int k = 0;
        int l = 0;
        int m = 0;
        int n = 0;

        //A: spinner roadway width affected
        int aH = RWidthAffected.getSelectedItemPosition();
        if (aH == 0) {
            a = 3;
        } else if (aH == 1) {
            a = 9;
        } else if (aH == 2) {
            a = 27;
        } else if (aH == 3) {
            a = 81;
        }
        //B: slide erosion effects -> spinner
        int bH = SlideErosion.getSelectedItemPosition();
        if (bH == 0) {
            b = 3;
        } else if (bH == 1) {
            b = 9;
        } else if (bH == 2) {
            b = 27;
        } else if (bH == 3) {
            b = 81;
        }
        //C: calculated Landslide/roadway length affected
        int lengthC = RLengthAffected.getText().length();
        if (lengthC != 0) {
            c = Integer.parseInt(RLengthAffected.getText().toString());
            score += c;
        }

        //I: Slope Drainage Spinner
        int iH = SlopeDrainage.getSelectedItemPosition();
        if (iH == 0) {
            i = 3;
        } else if (iH == 1) {
            i = 9;
        } else if (iH == 2) {
            i = 27;
        } else if (iH == 3) {
            i = 81;
        }

        //J: Annual Rainfall Calc
        int lengthJ = AnnualRainfall.getText().toString().length();
        if (lengthJ != 0) {
            j = Integer.parseInt(AnnualRainfall.getText().toString());
            score += j;
        }

        //K: Axial Length of Slide Calc
        int lengthK = AxialLOS.getText().toString().length();
        if (lengthK != 0) {
            k = Integer.parseInt(AxialLOS.getText().toString());
            score += k;
        }

        //L: Thaw stability Spinner
        int lH = ThawStability.getSelectedItemPosition();
        if (lH == 0) {
            l = 3;
        } else if (lH == 1) {
            l = 9;
        } else if (lH == 2) {
            l = 27;
        } else if (lH == 3) {
            l = 81;
        }

        //M: Instability - related maintenance frequency spinner
        int mH = InstabilityRMF.getSelectedItemPosition();
        if (mH == 0) {
            m = 3;
        } else if (mH == 1) {
            m = 9;
        } else if (mH == 2) {
            m = 27;
        } else if (mH == 3) {
            m = 81;
        }

        //N: Movement History spinner
        int nH = MovementHistory.getSelectedItemPosition();
        if (nH == 0) {
            n = 3;
        } else if (nH == 1) {
            n = 9;
        }
        if (nH == 2) {
            n = 27;
        }
        if (nH == 3) {
            n = 81;
        }

//        System.out.println("A is: " + a);
//        System.out.println("B is: " + b);
//        System.out.println("C is: " + c);
//        System.out.println("I is: " + i);
//        System.out.println("J is: " + j);
//        System.out.println("K is: " + k);
//        System.out.println("L is: " + l);
//        System.out.println("M is: " + m);
//        System.out.println("N is: " + n);


        score = score + a + b + i + l + m + n;
        String scoreS = String.valueOf(score);
        HazardTotal.setText(scoreS);

    }


    //k:Use axial length from site info to set Axial Length of Slide
    private final OnFocusChangeListener axialLengthWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = AxialLength.getText().toString();
                if (s.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", s))) {
                    AxialLength.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Slope Height (rock)/Axial Length (slide) must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }
                if (s.length() != 0) {
                    double x = 1;
                    double score = 0;

                    String lengthS = AxialLength.getText().toString();
                    double length = Double.parseDouble(lengthS);

                    x = (length / 25);

                    score = Math.pow(3, x);

                    if (score > 100) {
                        score = 100;
                    }

                    int scoreInt = (int) Math.round(score);

                    String scores = String.valueOf(scoreInt);
                    AxialLOS.setText(scores);
                    slopeHazardCalc();
                    AxialLength.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }


            }

        }

    };


    //Validation: if they were to manually change axial los
    private final OnFocusChangeListener axialLOSWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = AxialLOS.getText().toString();
                int text = 101;
                if (s.length() != 0) {
                    text = Integer.parseInt(s.toString());
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    AxialLOS.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }
                //if not empty...
                else {

                    slopeHazardCalc();
                    AxialLOS.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }

            }

        }

    };


    //RISK RATINGS
    //V-Need to pull if either road/ trail....need to somehow watch the rt spinner
    private final OnFocusChangeListener rtWidthWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = RtWidth.getText().toString();

                if (s.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", s))) {
                    RtWidth.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Roadway/Trail width must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }
                //if not empty...
                else {
                    double score = 0;
                    double x = 1;
                    String thing = RoadTrail.getSelectedItem().toString();

                    if (thing.equals("Road")) {
                        System.out.println("ROAD!!");
                        String widthS = RtWidth.getText().toString();
                        double width = Double.parseDouble(widthS);

                        x = ((44 - width) / 8);
                    }
                    if (thing.equals("Trail")) {
                        String widthS = RtWidth.getText().toString();
                        double width = Double.parseDouble(widthS);

                        x = ((18 - width) / 4);
                    }

                    score = Math.pow(3, x);

                    if (score > 100) {
                        score = 100;
                    }

                    int scoreInt = (int) Math.round(score);
                    String scores = String.valueOf(scoreInt);
                    RouteTW.setText(scores);
                    calcRiskTotal();
                    RtWidth.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }

            }

        }

    };

    private final OnItemSelectedListener rtWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            String widthS = RtWidth.getText().toString();
            int length = widthS.length();
            if (length != 0) {
                //double width = Double.parseDouble(widthS);
                double width = 20;
                double score = 0;
                double x = 1;
                String thing = RoadTrail.getSelectedItem().toString();
                if (thing.equals("Road")) {

                    x = ((44 - width) / 8);
                }
                if (thing.equals("Trail")) {


                    x = ((18 - width) / 4);
                }

                score = Math.pow(3, x);
                if (score > 100) {
                    score = 100;
                }

                int scoreInt = (int) Math.round(score);


                String scores = String.valueOf(scoreInt);
                RouteTW.setText(scores);
                calcRiskTotal();

            }
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    //If they were to manually change V
    private final OnFocusChangeListener routeTWWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = RouteTW.getText().toString();
                int text = 101;
                if (s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    RouteTW.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }
                //if not empty...
                else {

                    calcRiskTotal();
                    RouteTW.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }


            }

        }

    };

    //Human Ex Factor: need aadt, slope length, speed limit...not doing anything right now
//                        private final OnFocusChangeListener humanEFWatcher = new OnFocusChangeListener() {
//                            public void onFocusChange(View v, boolean hasFocus) {
//
//                                if (!hasFocus) {
//                                    //if not empty...
//                                    if (s.length() != 0) {
//                                        double score = 0;
//                                        double x = 1;
//                                        double slopeLength = 1; //should be length affected??
//
//                                        Double aadt = Double.parseDouble(Aadt.getText().toString());
//                                        int speed = 0;
//                                        int speedH = Speed.getSelectedItemPosition();
//
//                                        if (speedH == 0) {
//                                            speed = 25;
//                                        } else if (speedH == 1) {
//                                            speed = 30;
//                                        } else if (speedH == 2) {
//                                            speed = 35;
//                                        } else if (speedH == 3) {
//                                            speed = 40;
//                                        } else if (speedH == 4) {
//                                            speed = 45;
//                                        } else if (speedH == 5) {
//                                            speed = 50;
//                                        } else if (speedH == 6) {
//                                            speed = 55;
//                                        } else if (speedH == 7) {
//                                            speed = 60;
//                                        } else if (speedH == 8) {
//                                            speed = 65;
//                                        }
//
//                                        x = (((aadt / 24) * slopeLength * 100) / speed) / 12.5;
//                                        score = Math.pow(3, x);
//                                        if (score > 100) {
//                                            score = 100;
//                                        }
//
//                                        int scoreInt = (int) Math.round(score);
//                                        String scores = String.valueOf(scoreInt);
//                                        HumanEF.setText(scores);
//                                        calcRiskTotal();
//
//                                    }
//
//
//                                }
//
//                            }
//
//                        };

    //Validation if they were to manually change W

    private final OnFocusChangeListener humanEFCalcWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = HumanEF.getText().toString();
                int text = 101;
                if (s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    HumanEF.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                }
                //if not empty...
                else {
                    HumanEF.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                    calcRiskTotal();

                }

            }

        }

    };


    //X- % DSD. Need watcher for speed spinner
    private final OnFocusChangeListener dsdWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = SightDistance.getText().toString();

                if (s.length() != 0) {
                    double score = 0;
                    double x = 1;
                    int helper = 0;

                    String sightDistanceS = SightDistance.getText().toString();
                    Double sightDistance = Double.parseDouble(sightDistanceS);

                    String speed = Speed.getSelectedItem().toString();

                    if (speed.equals("25mph")) {
                        helper = 375;
                    } else if (speed.equals("30mph")) {
                        helper = 450;
                    } else if (speed.equals("35mph")) {
                        helper = 525;
                    } else if (speed.equals("40mph")) {
                        helper = 600;
                    } else if (speed.equals("45mph")) {
                        helper = 675;
                    } else if (speed.equals("50mph")) {
                        helper = 750;
                    } else if (speed.equals("55mph")) {
                        helper = 875;
                    } else if (speed.equals("60mph")) {
                        helper = 1000;
                    } else if (speed.equals("65mph")) {
                        helper = 1050;
                    }


                    x = ((120 - ((sightDistance / helper) * 100)) / 20);


                    score = Math.pow(3, x);
                    if (score > 100) {
                        score = 100;
                    }

                    int scoreInt = (int) Math.round(score);


                    String scores = String.valueOf(scoreInt);

                    PercentDSD.setText(scores);
                    calcRiskTotal();


                }


            }

        }

    };

    //Validation If they were to manually change X
    private final OnFocusChangeListener percentDsdWatcher = new OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = PercentDSD.getText().toString();
                int text = 101;
                if (s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    System.out.println("TEXT IS" + text);
                    PercentDSD.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(LandslideActivity.this);
                    builder.setMessage("Field must have an integer value between 0 and 100.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();


                } else {
                    PercentDSD.setBackgroundColor(getResources().getColor(android.R.color.transparent));

                    calcRiskTotal();


                }


            }

        }

    };

    private final OnItemSelectedListener speedWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            String sightDistanceS = SightDistance.getText().toString();
            int length = sightDistanceS.length();

            //not emtpy
            if (length != 0) {

                double score = 0;
                double x = 1;
                int helper = 0;

                Double sightDistance = Double.parseDouble(sightDistanceS);

                String speed = Speed.getSelectedItem().toString();
                if (speed.equals("25mph")) {
                    helper = 375;
                } else if (speed.equals("30mph")) {
                    helper = 450;
                } else if (speed.equals("35mph")) {
                    helper = 525;
                } else if (speed.equals("40mph")) {
                    helper = 600;
                } else if (speed.equals("45mph")) {
                    helper = 675;
                } else if (speed.equals("50mph")) {
                    helper = 750;
                } else if (speed.equals("55mph")) {
                    helper = 875;
                } else if (speed.equals("60mph")) {
                    helper = 1000;
                } else if (speed.equals("65mph")) {
                    helper = 1050;
                }

                x = ((120 - ((sightDistance / helper) * 100)) / 20);


                score = Math.pow(3, x);
                if (score > 100) {
                    score = 100;
                }

                int scoreInt = (int) Math.round(score);


                String scores = String.valueOf(scoreInt);
                PercentDSD.setText(scores);
            }
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    private final OnItemSelectedListener riskWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            calcRiskTotal();
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    public void calcRiskTotal() {
        int score = 0;
        int g = 0;
        int h = 0;
        int v = 0;
        int w = 0;
        int x = 0;
        int y = 0;
        int z = 0;
        int aa = 0;
        int bb = 0;

        //G: impact on use
        int gH = ImpactOU.getSelectedItemPosition();
        if (gH == 0) {
            g = 3;
        } else if (gH == 1) {
            g = 9;
        } else if (gH == 2) {
            g = 27;
        } else if (gH == 3) {
            g = 81;
        }
        //H: calculated aadt
        int lengthH = AadtEtc.getText().toString().length();
        if (lengthH != 0) {
            h = Integer.parseInt(AadtEtc.getText().toString());
            score += h;
        }

        //V: Route/Trail Width
        int lengthV = RouteTW.getText().toString().length();
        if (lengthV != 0) {
            v = Integer.parseInt(RouteTW.getText().toString());
            score += v;
        }

        //W: Human Exposure Factor
        int lengthW = HumanEF.getText().toString().length();
        if (lengthW != 0) {
            w = Integer.parseInt(HumanEF.getText().toString());
            score += w;
        }

        //X: % DSD
        int lengthX = PercentDSD.getText().toString().length();
        if (lengthX != 0) {
            x = Integer.parseInt(PercentDSD.getText().toString());
            score = +x;
        }

        //Y: ROW Impacts Spinner
        int yH = RightOWI.getSelectedItemPosition();
        if (yH == 0) {
            y = 3;
        } else if (yH == 1) {
            y = 9;
        } else if (yH == 2) {
            y = 27;
        }
        if (yH == 3) {
            y = 81;
        }

        //Z: EC Impacts Spinner
        int zH = ECImpact.getSelectedItemPosition();
        if (zH == 0) {
            z = 3;
        } else if (zH == 1) {
            z = 9;
        } else if (zH == 2) {
            z = 27;
        } else if (zH == 3) {
            z = 81;
        }

        //AA: Maintenance Complexity Spinner
        int aaH = MaintComplexity.getSelectedItemPosition();
        if (aaH == 0) {
            aa = 3;
        } else if (aaH == 1) {
            aa = 9;
        }
        if (aaH == 2) {
            aa = 27;
        }
        if (aaH == 3) {
            aa = 81;
        }

        //BB: Event Cost Spinner
        int bbH = EventCost.getSelectedItemPosition();
        if (bbH == 0) {
            bb = 3;
        } else if (bbH == 1) {
            bb = 9;
        } else if (bbH == 2) {
            bb = 27;
        }
        if (bbH == 3) {
            bb = 81;
        }

        score = score + g + y + z + aa + bb;

        String scoreS = String.valueOf(score);
        RiskTotal.setText(scoreS);
    }

    private final TextWatcher totalWatcher = new TextWatcher() {
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        public void afterTextChanged(Editable s) {

            calcTotal();

        }
    };


    //calculate total score...
    public void calcTotal() {
        int score = 0;
        int hazard = 0;
        int risk = 0;
        if (HazardTotal.getText().toString().length() != 0) {
            hazard = Integer.parseInt(HazardTotal.getText().toString());
        }
        if (RiskTotal.getText().toString().length() != 0) {
            risk = Integer.parseInt(RiskTotal.getText().toString());
        }

        score = hazard + risk;
        String scoreS = String.valueOf(score);
        Total.setText(scoreS);


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
        getMenuInflater().inflate(R.menu.landslide, menu);
        getMenuInflater().inflate(R.menu.menu_main, menu);


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
            Intent intent = new Intent(this, MaintenanceActivity.class);
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


    //ALL OF THE POPUP EXTRA INFORMATION

    public void popup1(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("FLMA stands for Federal Land Management Agency", TextView.BufferType.NORMAL);

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

    public void popup2(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:0-5%\n\n9:6-25%\n\n27:26-50%\n\n81:51-100%", TextView.BufferType.NORMAL);

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

    public void popup3(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Visible crack or slight deposit of material/minor erosion\n\n9:1 inch offset, or 6-inch deposit of material / major erosion will affect trave in < 5 years\n\n27:2-inch offset or 12-inch deposit/mod. erosion impacting travel annually\n\n81:4-inch offset or 24-inch deposit/severe erosion impacting travel consistently", TextView.BufferType.NORMAL);

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

    public void popup4(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:25ft\n\n9:100ft\n\n27:225ft\n\n81:400ft", TextView.BufferType.NORMAL);

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

    //impact on use
    public void popup5(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Full use continues with minor delay\n\n9:Partial use remains Use modification required, short(3mi / 30min.) detour available\n\n27:Use is blocked - long(>30min.) detour available or less than 1 day closure\n\n81:Use is blocked - no detour available/closure > 1 week", TextView.BufferType.NORMAL);

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

    //aadt etc.
    public void popup6(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:50 Rarely Used Insignificant economic/rec. importance\n\n9:200 Occasionally used Minor economic/rec. importance\n\n27:450 Frequently used Moderate economic/rec. importance\n\n81:800 Constantly used Significant economic/rec. importance", TextView.BufferType.NORMAL);

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

    public void popup7(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("Good(15-21pts)\n\nFair(22-161pts)\n\nPoor(>161pts");

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

    //SLOPE HAZARD RATINGS
    public void popup8(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Slope appears dry or well drained; surface runoff well controlled\n\n9:Intermittent water on slope; mod. not well drained; or surface runoff moderately controlled\n\n27:Water usually on slope; poorly drained; or surface runoff poorly controlled\n\n81:Water always on slope; very poorly drained; or surface water runoff control not present");

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

    public void popup9(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:0-10\"\n\n9:10-30\"\n\n27:30-60\"\n\n81:60\"+");

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

    public void popup10(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:25ft\n\n9:50ft\n\n27:75ft\n\n81:100ft");

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

    public void popup11(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Unfrozen/Thaw Stable\n\n9:Slightly Thaw Unstable\n\n27:Moderately Thaw Unstable\n\n81:Highly Thaw Unstable");

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

    public void popup12(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Minor movement or sporadic creep\n\n9:Up to 1 inch annually or steady annual creep\n\n27:Up to 3 inches per event, one event per year\n\n81:>3\" per event, >6\" annually, more than 1 event per year (includes all debris flows)");

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

    public void popup122(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Every 10 years\n\n9:Every 5 years\n\n27:Every 2 years\n\n81:Every year");

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

    //Risk Ratings
    public void popup13(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:\n36ft\n14ft\n\n9:\n28ft\n10ft\n\n27:\n20ft\n6ft\n\n81:\n12ft\n2ft");

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

    public void popup14(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:12.5% of the time\n\n9:25% of the time\n\n27:37.5% of the time\n\n81:50% of the time");

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

    public void popup15(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Adequate, 100% of the low design value\n\n9:Moderate, 80% of the low design value\n\n27:Limited, 60% of the low design value\n\n81:Very limited, 40% of the low design value");

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

    public void popup16(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:No R\\W implications\n\n9:Minor effects beyond R/W\n\n27:Private property, no structures affected\n\n81:Structures, roads, RR, utilities, or Parks affected");

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

    public void popup17(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:None/No Potential to Cause Effects\n\n9:Likely to Effect/No Hist. Prop. Affected\n\n27:Likely to adversely Affect/Finding of No Adverse Effect\n\n81:Current adverse effects/Adverse Effect");

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

    public void popup18(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Routine Effort/In-House\n\n9:In-House maint./special project\n\n27:Specialized equip/contract\n\n\n81:Complex/dangerous effort/location/contract");

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

    public void popup19(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:$0-2k\n\n9:$2-25k\n\n27:$25-100k\n\n81:>$100k");

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

    public void popup20(View view) {
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

    public void goOfflineSites(View view) {
        Intent intent = new Intent(this, OfflineList.class);
        startActivity(intent);
    }

    public void editSubmit() throws Exception{
        Thread thread = new Thread(new Runnable() {

            @Override
            public void run() {
                try  {
                    URL url = new URL("http://nl.cs.montana.edu/usmp/server/new_site_php/add_new_site.php");
                    URLConnection conn = url.openConnection();
                    conn.setDoOutput(true);
                    OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());

                    //GET ALL THE VALUES
                    //String mgmt_area = String.valueOf(ManagementArea.getText());
                    String umbrella_agency = String.valueOf(Agency.getSelectedItem());
                    String regional_admin = String.valueOf(Regional.getSelectedItem());
                    String local_admin = String.valueOf(Local.getSelectedItem());


                    String road_trail_number = String.valueOf(RoadTrailNo.getText());
                    String road_trail_class = String.valueOf(RoadTrailClass.getText());
                    String begin_mile_marker = String.valueOf(BeginMile.getText());
                    String end_mile_marker = String.valueOf(EndMile.getText());
                    String road_or_trail = "R";
                    if(RoadTrail.getSelectedItem().toString().equals("Trail")){
                        road_or_trail="T";
                    }
                    String side = ""; //L/R??
                    if(Side.getSelectedItemPosition()==0){
                        side = "L";
                    }
                    else if(Side.getSelectedItemPosition()==1){
                        side = "R";
                    }
                    else if(Side.getSelectedItemPosition()==2){
                        side = "N";
                    }
                    else if(Side.getSelectedItemPosition()==3){
                        side = "NE";
                    }
                    else if(Side.getSelectedItemPosition()==4){
                        side = "E";
                    }
                    else if(Side.getSelectedItemPosition()==5){
                        side = "SE";
                    }
                    else if(Side.getSelectedItemPosition()==6){
                        side = "S";
                    }
                    else if(Side.getSelectedItemPosition()==7){
                        side = "SW";
                    }
                    else if(Side.getSelectedItemPosition()==8){
                        side = "W";
                    }
                    if(Side.getSelectedItemPosition()==9){
                        side = "NW";
                    }

                    String l_rater = String.valueOf(Rater.getText());

                    //ENUM in Database.....
                    String weather = "";
                    weather = Weather.getSelectedItem().toString();

                    //date stuff

                    String begin_coordinate_lat = String.valueOf(BeginLat.getText());
                    String begin_coordinate_long = String.valueOf(BeginLong.getText());
                    String end_coordinate_latitude = String.valueOf(EndLat.getText());
                    String end_coordinate_longitude = String.valueOf(EndLong.getText());
                    String datum = String.valueOf(Datum.getText());
                    String aadt = String.valueOf(Aadt.getText());
                    String hazard_type = String.valueOf(HazardType.getText());
                    String length_affected = String.valueOf(LengthAffected.getText());
                    String slope_height_axial_length = String.valueOf(AxialLength.getText());
                    String slope_angle = String.valueOf(SlopeAngle.getText());
                    String sight_distance = String.valueOf(SightDistance.getText());
                    String road_trail_width = String.valueOf(RtWidth.getText()); //?

                    String speed_limit = Speed.getSelectedItem().toString();

                    String minimum_ditch_width = String.valueOf(DitchWidth1.getText());
                    String maximum_ditch_width = String.valueOf(DitchWidth2.getText());
                    String minimum_ditch_depth = String.valueOf(DitchDepth1.getText());
                    String maximum_ditch_depth = String.valueOf(DitchDepth2.getText());
                    String first_begin_ditch_slope = String.valueOf(DitchSlope1.getText());
                    String first_end_ditch_slope = String.valueOf(DitchSlope2.getText());
                    String second_begin_ditch_slope = String.valueOf(DitchSlope3.getText());
                    String second_end_ditch_slope = String.valueOf(DitchSlope4.getText());

                    String start_annual_rainfall = String.valueOf(AnnualRain1.getText());
                    String end_annual_rainfall = String.valueOf(AnnualRain2.getText());

                    String sole_access_route = "N";
                    if(SoleAccess.getSelectedItemPosition()==1){
                        sole_access_route ="Y";
                    }

                    String fixes_present = "N";
                    if(Mitigation.getSelectedItemPosition()==1){
                        fixes_present = "Y";
                    }

                    //blk size
                    //volume
                    //photos

                    String comments = String.valueOf(Comments.getText());
                    String flma_id = String.valueOf(FlmaId.getText());
                    String flma_name = String.valueOf(FlmaName.getText());
                    String flma_description = String.valueOf(FlmaDescription.getText());

                    //PRELIMINARY RATING

                    String road_width_affected = "3";
                    if(RWidthAffected.getSelectedItemPosition()==1){
                        road_width_affected = "9";
                    }
                    else if(RWidthAffected.getSelectedItemPosition()==2){
                        road_width_affected = "27";
                    }
                    else if(RWidthAffected.getSelectedItemPosition()==3){
                        road_width_affected = "81";
                    }

                    String slide_erosion_effects = "3";
                    if(SlideErosion.getSelectedItemPosition()==1){
                        slide_erosion_effects="9";
                    }
                    else if(SlideErosion.getSelectedItemPosition()==2){
                        slide_erosion_effects="27";
                    }
                    else if(SlideErosion.getSelectedItemPosition()==3){
                        slide_erosion_effects="81";
                    }

                    String l_length_affected = String.valueOf(RLengthAffected.getText());

                    //rockfall stuff here

                    //for all
                    String impact_on_use = "3";
                    if(ImpactOU.getSelectedItemPosition() == 1){
                        impact_on_use = "9";
                    }
                    else if(ImpactOU.getSelectedItemPosition() == 2){
                        impact_on_use = "27";
                    }
                    else if(ImpactOU.getSelectedItemPosition() == 3){
                        impact_on_use = "81";
                    }

                    String aadt_usage_calc_checkbox = "0";
                    if(CheckAadt.isChecked()){
                        aadt_usage_calc_checkbox = "1";
                    }

                    String aadt_usage = String.valueOf(AadtEtc.getText());

                    String prelim_rating = String.valueOf(PrelimRating.getText());

                    //SLOPE HAZARD RATINGS

                    //for all
                    String slope_drainage = "3";
                    if(SlopeDrainage.getSelectedItemPosition() == 1){
                        slope_drainage = "9";
                    }
                    else if(SlopeDrainage.getSelectedItemPosition() == 2){
                        slope_drainage = "27";
                    }
                    else if(SlopeDrainage.getSelectedItemPosition() == 3){
                        slope_drainage = "81";
                    }

                    String annual_rainfall = String.valueOf(AnnualRainfall.getText());
                    String axial_los = String.valueOf(AxialLOS.getText()); //hr_slope_height_axial_length

                    //landslide
                    String thaw_stability = "3";
                    if(ThawStability.getSelectedItemPosition()==1){
                        thaw_stability = "9";
                    }
                    else if(ThawStability.getSelectedItemPosition()==2){
                        thaw_stability = "27";
                    }
                    else if(ThawStability.getSelectedItemPosition()==3){
                        thaw_stability = "81";
                    }

                    String maint_freq = "3";
                    if(InstabilityRMF.getSelectedItemPosition()==1){
                        maint_freq = "9";
                    }
                    else if(InstabilityRMF.getSelectedItemPosition()==2){
                        maint_freq = "27";
                    }
                    else if(InstabilityRMF.getSelectedItemPosition()==3){
                        maint_freq = "81";
                    }

                    String movement_history = "3";
                    if(MovementHistory.getSelectedItemPosition() == 1){
                        movement_history = "9";
                    }
                    else if(MovementHistory.getSelectedItemPosition() == 2){
                        movement_history = "27";
                    }
                    else if(MovementHistory.getSelectedItemPosition() == 3){
                        movement_history = "81";
                    }

                    //rockfall fields here

                    //all
                    String hazard_total = String.valueOf(HazardTotal.getText());

                    //RISK RATINGS--same for all
                    String route_trail_width = String.valueOf(RouteTW.getText());
                    String human_ex_factor = String.valueOf(HumanEF.getText());
                    String percent_dsd = String.valueOf(PercentDSD.getText());

                    String r_w_impacts = "3";
                    if(RightOWI.getSelectedItemPosition() == 1){
                        r_w_impacts = "9";
                    }
                    else if(RightOWI.getSelectedItemPosition() == 2){
                        r_w_impacts = "27";
                    }
                    else if(RightOWI.getSelectedItemPosition() == 3){
                        r_w_impacts = "81";
                    }

                    String enviro_cult_impacts = "3";
                    if(ECImpact.getSelectedItemPosition() == 1){
                        enviro_cult_impacts = "9";
                    }
                    else if(ECImpact.getSelectedItemPosition() == 2){
                        enviro_cult_impacts = "27";
                    }
                    else if(ECImpact.getSelectedItemPosition() == 3){
                        enviro_cult_impacts = "81";
                    }

                    String maint_complexity = "3";
                    if(MaintComplexity.getSelectedItemPosition() == 1){
                        maint_complexity = "9";
                    }
                    else if(MaintComplexity.getSelectedItemPosition() == 2){
                        maint_complexity = "27";
                    }
                    else if(MaintComplexity.getSelectedItemPosition() == 3){
                        maint_complexity = "81";
                    }

                    String event_cost = "3";
                    if(EventCost.getSelectedItemPosition() == 1){
                        event_cost = "9";
                    }
                    else if(EventCost.getSelectedItemPosition() == 2){
                        event_cost = "27";
                    }
                    else if(EventCost.getSelectedItemPosition() == 3){
                        event_cost = "81";
                    }

                    String risk_total = String.valueOf(RiskTotal.getText());

                    String total_score = String.valueOf(Total.getText());

                    String old_site_id = "0";


                    writer.write("old_site_id="+old_site_id+"&umbrella_agency="+umbrella_agency+"&regional_admin="+regional_admin+"&local_admin="+local_admin+"&road_trail_number="+road_trail_number+"&road_trail_class="+road_trail_class+
                            "&begin_mile_marker="+begin_mile_marker+"&end_mile_marker="+end_mile_marker+"&road_or_trail="+road_or_trail+"&side="+
                            side +"&rater="+l_rater+"&weather="+weather+"&begin_coordinate_latitude="+begin_coordinate_lat+"&begin_coordinate_longitude="+
                            begin_coordinate_long+"&end_coordinate_latitude="+end_coordinate_latitude+"&end_coordinate_longitude="+end_coordinate_longitude+
                            "&datum="+datum+"&aadt="+aadt+"&hazard_type="+hazard_type+"&length_affected="+length_affected+"&slope_height_axial_length="+
                            slope_height_axial_length+"&slope_angle="+slope_angle+"&sight_distance="+sight_distance+"&road_trail_width="+road_trail_width+
                            "&speed_limit="+speed_limit+"&minimum_ditch_width="+minimum_ditch_width+"&maximum_ditch_width="+maximum_ditch_width+
                            "&minimum_ditch_depth="+minimum_ditch_depth+"&maximum_ditch_depth="+maximum_ditch_depth+"&first_begin_ditch_slope="+first_begin_ditch_slope+
                            "&first_end_ditch_slope="+first_end_ditch_slope+"&second_begin_ditch_slope="+second_begin_ditch_slope+"&second_end_ditch_slope="+
                            second_end_ditch_slope+"&start_annual_rainfall="+start_annual_rainfall+"&end_annual_rainfall="+end_annual_rainfall+
                            "&sole_access_route="+sole_access_route+"&fixes_present="+fixes_present+"&blk_size= &volume= &prelim_landslide_road_width_affected="+
                            road_width_affected+"&prelim_landslide_slide_erosion_effects="+slide_erosion_effects+"&prelim_landslide_slide_erosion_effects="+
                            slide_erosion_effects+"&prelim_landslide_length_affected="+length_affected+"&prelim_rockfall_ditch_eff= &prelim_rockfall_rockfall_history= " +
                            "&prelim_rockfall_block_size_event_vol= &impact_on_use="+impact_on_use+"&aadt_usage_calc_checkbox="+
                            aadt_usage_calc_checkbox+"&aadt_usage="+aadt_usage+"&prelim_rating="+prelim_rating+"&slope_drainage="+
                            slope_drainage+"&hazard_rating_annual_rainfall="+annual_rainfall+"&hazard_rating_slope_height_axial_length="+axial_los+
                            "&hazard_landslide_thaw_stability="+thaw_stability+"&hazard_landslide_maint_frequency="+maint_freq+"&hazard_landslide_movement_history="+
                            movement_history+"&hazard_rockfall_maint_frequency= &case_one_struc_cond= &case_one_rock_friction= &case_two_struc_condition= &case_two_diff_erosion= "+
                            "&route_trail_width="+route_trail_width+"&human_ex_factor="+human_ex_factor+"&percent_dsd="+percent_dsd+"&r_w_impacts="+
                            r_w_impacts+"&enviro_cult_impacts="+enviro_cult_impacts+"&maint_complexity="+maint_complexity+"&event_cost="+event_cost+
                            "&hazard_rating_landslide_total="+hazard_total+"&hazard_rating_rockfall_total= &risk_total="+risk_total+"&total_score="+total_score+"&comments="+
                            comments +"&fmla_id="+flma_id+"&fmla_name="+flma_name+"&fmla_description="+flma_description);
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

    //submit form
    public void LSubmit(View view) throws Exception {

        //EDIT
        if(getIntent().getStringExtra("editing") != null){
            System.out.println("yay! please do EDIT SUBMIT");
            editSubmit();
        }
        else {
            Thread thread = new Thread(new Runnable() {

                @Override
                public void run() {
                    try {
                        URL url = new URL("http://nl.cs.montana.edu/usmp/server/new_site_php/add_new_site.php");
                        URLConnection conn = url.openConnection();
                        conn.setDoOutput(true);
                        OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());

                        //GET ALL THE VALUES
                        String umbrella_agency = String.valueOf(Agency.getSelectedItem());
                        String regional_admin = String.valueOf(Regional.getSelectedItem());
                        String local_admin = String.valueOf(Local.getSelectedItem());

                        String road_trail_number = String.valueOf(RoadTrailNo.getText());
                        String road_trail_class = String.valueOf(RoadTrailClass.getText());
                        String begin_mile_marker = String.valueOf(BeginMile.getText());
                        String end_mile_marker = String.valueOf(EndMile.getText());
                        String road_or_trail = "R";
                        if (RoadTrail.getSelectedItem().toString().equals("Trail")) {
                            road_or_trail = "T";
                        }
                        String side = ""; //L/R??
                        if (Side.getSelectedItemPosition() == 0) {
                            side = "L";
                        } else if (Side.getSelectedItemPosition() == 1) {
                            side = "R";
                        } else if (Side.getSelectedItemPosition() == 2) {
                            side = "N";
                        } else if (Side.getSelectedItemPosition() == 3) {
                            side = "NE";
                        } else if (Side.getSelectedItemPosition() == 4) {
                            side = "E";
                        } else if (Side.getSelectedItemPosition() == 5) {
                            side = "SE";
                        } else if (Side.getSelectedItemPosition() == 6) {
                            side = "S";
                        } else if (Side.getSelectedItemPosition() == 7) {
                            side = "SW";
                        } else if (Side.getSelectedItemPosition() == 8) {
                            side = "W";
                        }
                        if (Side.getSelectedItemPosition() == 9) {
                            side = "NW";
                        }

                        String l_rater = String.valueOf(Rater.getText());

                        //ENUM in Database.....
                        String weather = "";
                        weather = Weather.getSelectedItem().toString();

                        //date stuff

                        String begin_coordinate_lat = String.valueOf(BeginLat.getText());
                        String begin_coordinate_long = String.valueOf(BeginLong.getText());
                        String end_coordinate_latitude = String.valueOf(EndLat.getText());
                        String end_coordinate_longitude = String.valueOf(EndLong.getText());
                        String datum = String.valueOf(Datum.getText());
                        String aadt = String.valueOf(Aadt.getText());
                        String hazard_type = String.valueOf(HazardType.getText());
                        String length_affected = String.valueOf(LengthAffected.getText());
                        String slope_height_axial_length = String.valueOf(AxialLength.getText());
                        String slope_angle = String.valueOf(SlopeAngle.getText());
                        String sight_distance = String.valueOf(SightDistance.getText());
                        String road_trail_width = String.valueOf(RtWidth.getText()); //?

                        String speed_limit = Speed.getSelectedItem().toString();

                        String minimum_ditch_width = String.valueOf(DitchWidth1.getText());
                        String maximum_ditch_width = String.valueOf(DitchWidth2.getText());
                        String minimum_ditch_depth = String.valueOf(DitchDepth1.getText());
                        String maximum_ditch_depth = String.valueOf(DitchDepth2.getText());
                        String first_begin_ditch_slope = String.valueOf(DitchSlope1.getText());
                        String first_end_ditch_slope = String.valueOf(DitchSlope2.getText());
                        String second_begin_ditch_slope = String.valueOf(DitchSlope3.getText());
                        String second_end_ditch_slope = String.valueOf(DitchSlope4.getText());

                        String start_annual_rainfall = String.valueOf(AnnualRain1.getText());
                        String end_annual_rainfall = String.valueOf(AnnualRain2.getText());

                        String sole_access_route = "N";
                        if (SoleAccess.getSelectedItemPosition() == 1) {
                            sole_access_route = "Y";
                        }

                        String fixes_present = "N";
                        if (Mitigation.getSelectedItemPosition() == 1) {
                            fixes_present = "Y";
                        }

                        //blk size
                        //volume
                        //photos

                        String comments = String.valueOf(Comments.getText());
                        String flma_id = String.valueOf(FlmaId.getText());
                        String flma_name = String.valueOf(FlmaName.getText());
                        String flma_description = String.valueOf(FlmaDescription.getText());

                        //PRELIMINARY RATING

                        String road_width_affected = "3";
                        if (RWidthAffected.getSelectedItemPosition() == 1) {
                            road_width_affected = "9";
                        } else if (RWidthAffected.getSelectedItemPosition() == 2) {
                            road_width_affected = "27";
                        } else if (RWidthAffected.getSelectedItemPosition() == 3) {
                            road_width_affected = "81";
                        }

                        String slide_erosion_effects = "3";
                        if (SlideErosion.getSelectedItemPosition() == 1) {
                            slide_erosion_effects = "9";
                        } else if (SlideErosion.getSelectedItemPosition() == 2) {
                            slide_erosion_effects = "27";
                        } else if (SlideErosion.getSelectedItemPosition() == 3) {
                            slide_erosion_effects = "81";
                        }

                        String l_length_affected = String.valueOf(RLengthAffected.getText());

                        //rockfall stuff here

                        //for all
                        String impact_on_use = "3";
                        if (ImpactOU.getSelectedItemPosition() == 1) {
                            impact_on_use = "9";
                        } else if (ImpactOU.getSelectedItemPosition() == 2) {
                            impact_on_use = "27";
                        } else if (ImpactOU.getSelectedItemPosition() == 3) {
                            impact_on_use = "81";
                        }

                        String aadt_usage_calc_checkbox = "0";
                        if (CheckAadt.isChecked()) {
                            aadt_usage_calc_checkbox = "1";
                        }

                        String aadt_usage = String.valueOf(AadtEtc.getText());

                        String prelim_rating = String.valueOf(PrelimRating.getText());

                        //SLOPE HAZARD RATINGS

                        //for all
                        String slope_drainage = "3";
                        if (SlopeDrainage.getSelectedItemPosition() == 1) {
                            slope_drainage = "9";
                        } else if (SlopeDrainage.getSelectedItemPosition() == 2) {
                            slope_drainage = "27";
                        } else if (SlopeDrainage.getSelectedItemPosition() == 3) {
                            slope_drainage = "81";
                        }

                        String annual_rainfall = String.valueOf(AnnualRainfall.getText());
                        String axial_los = String.valueOf(AxialLOS.getText()); //hr_slope_height_axial_length

                        //landslide
                        String thaw_stability = "3";
                        if (ThawStability.getSelectedItemPosition() == 1) {
                            thaw_stability = "9";
                        } else if (ThawStability.getSelectedItemPosition() == 2) {
                            thaw_stability = "27";
                        } else if (ThawStability.getSelectedItemPosition() == 3) {
                            thaw_stability = "81";
                        }

                        String maint_freq = "3";
                        if (InstabilityRMF.getSelectedItemPosition() == 1) {
                            maint_freq = "9";
                        } else if (InstabilityRMF.getSelectedItemPosition() == 2) {
                            maint_freq = "27";
                        } else if (InstabilityRMF.getSelectedItemPosition() == 3) {
                            maint_freq = "81";
                        }

                        String movement_history = "3";
                        if (MovementHistory.getSelectedItemPosition() == 1) {
                            movement_history = "9";
                        } else if (MovementHistory.getSelectedItemPosition() == 2) {
                            movement_history = "27";
                        } else if (MovementHistory.getSelectedItemPosition() == 3) {
                            movement_history = "81";
                        }

                        //rockfall fields here

                        //all
                        String hazard_total = String.valueOf(HazardTotal.getText());

                        //RISK RATINGS--same for all
                        String route_trail_width = String.valueOf(RouteTW.getText());
                        String human_ex_factor = String.valueOf(HumanEF.getText());
                        String percent_dsd = String.valueOf(PercentDSD.getText());

                        String r_w_impacts = "3";
                        if (RightOWI.getSelectedItemPosition() == 1) {
                            r_w_impacts = "9";
                        } else if (RightOWI.getSelectedItemPosition() == 2) {
                            r_w_impacts = "27";
                        } else if (RightOWI.getSelectedItemPosition() == 3) {
                            r_w_impacts = "81";
                        }

                        String enviro_cult_impacts = "3";
                        if (ECImpact.getSelectedItemPosition() == 1) {
                            enviro_cult_impacts = "9";
                        } else if (ECImpact.getSelectedItemPosition() == 2) {
                            enviro_cult_impacts = "27";
                        } else if (ECImpact.getSelectedItemPosition() == 3) {
                            enviro_cult_impacts = "81";
                        }

                        String maint_complexity = "3";
                        if (MaintComplexity.getSelectedItemPosition() == 1) {
                            maint_complexity = "9";
                        } else if (MaintComplexity.getSelectedItemPosition() == 2) {
                            maint_complexity = "27";
                        } else if (MaintComplexity.getSelectedItemPosition() == 3) {
                            maint_complexity = "81";
                        }

                        String event_cost = "3";
                        if (EventCost.getSelectedItemPosition() == 1) {
                            event_cost = "9";
                        } else if (EventCost.getSelectedItemPosition() == 2) {
                            event_cost = "27";
                        } else if (EventCost.getSelectedItemPosition() == 3) {
                            event_cost = "81";
                        }

                        String risk_total = String.valueOf(RiskTotal.getText());

                        String total_score = String.valueOf(Total.getText());

                        //flma problem


                        writer.write("mgmt_area=" + "&umbrella_agency="+umbrella_agency+"&regional_admin="+regional_admin+"&local_admin="+local_admin+"&road_trail_number=" + road_trail_number + "&road_trail_class=" + road_trail_class +
                                "&begin_mile_marker=" + begin_mile_marker + "&end_mile_marker=" + end_mile_marker + "&road_or_trail=" + road_or_trail + "&side=" +
                                side + "&rater=" + l_rater + "&weather=" + weather + "&begin_coordinate_latitude=" + begin_coordinate_lat + "&begin_coordinate_longitude=" +
                                begin_coordinate_long + "&end_coordinate_latitude=" + end_coordinate_latitude + "&end_coordinate_longitude=" + end_coordinate_longitude +
                                "&datum=" + datum + "&aadt=" + aadt + "&hazard_type=" + hazard_type + "&length_affected=" + length_affected + "&slope_height_axial_length=" +
                                slope_height_axial_length + "&slope_angle=" + slope_angle + "&sight_distance=" + sight_distance + "&road_trail_width=" + road_trail_width +
                                "&speed_limit=" + speed_limit + "&minimum_ditch_width=" + minimum_ditch_width + "&maximum_ditch_width=" + maximum_ditch_width +
                                "&minimum_ditch_depth=" + minimum_ditch_depth + "&maximum_ditch_depth=" + maximum_ditch_depth + "&first_begin_ditch_slope=" + first_begin_ditch_slope +
                                "&first_end_ditch_slope=" + first_end_ditch_slope + "&second_begin_ditch_slope=" + second_begin_ditch_slope + "&second_end_ditch_slope=" +
                                second_end_ditch_slope + "&start_annual_rainfall=" + start_annual_rainfall + "&end_annual_rainfall=" + end_annual_rainfall +
                                "&sole_access_route=" + sole_access_route + "&fixes_present=" + fixes_present + "&blk_size= &volume= &prelim_landslide_road_width_affected=" +
                                road_width_affected + "&prelim_landslide_slide_erosion_effects=" + slide_erosion_effects + "&prelim_landslide_slide_erosion_effects=" +
                                slide_erosion_effects + "&prelim_landslide_length_affected=" + length_affected + "&prelim_rockfall_ditch_eff= &prelim_rockfall_rockfall_history= " +
                                "&prelim_rockfall_block_size_event_vol= &impact_on_use=" + impact_on_use + "&aadt_usage_calc_checkbox=" +
                                aadt_usage_calc_checkbox + "&aadt_usage=" + aadt_usage + "&prelim_rating=" + prelim_rating + "&slope_drainage=" +
                                slope_drainage + "&hazard_rating_annual_rainfall=" + annual_rainfall + "&hazard_rating_slope_height_axial_length=" + axial_los +
                                "&hazard_landslide_thaw_stability=" + thaw_stability + "&hazard_landslide_maint_frequency=" + maint_freq + "&hazard_landslide_movement_history=" +
                                movement_history + "&hazard_rockfall_maint_frequency= &case_one_struc_cond= &case_one_rock_friction= &case_two_struc_condition= &case_two_diff_erosion= " +
                                "&route_trail_width=" + route_trail_width + "&human_ex_factor=" + human_ex_factor + "&percent_dsd=" + percent_dsd + "&r_w_impacts=" +
                                r_w_impacts + "&enviro_cult_impacts=" + enviro_cult_impacts + "&maint_complexity=" + maint_complexity + "&event_cost=" + event_cost +
                                "&hazard_rating_landslide_total=" + hazard_total + "&hazard_rating_rockfall_total= &risk_total=" + risk_total + "&total_score=" + total_score + "&comments=" +
                                comments + "&fmla_id=" + flma_id + "&fmla_name=" + flma_name + "&fmla_description=" + flma_description);
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

    }

    public void newLandslide(View view){
        LandslideDBHandler dbHandler = new LandslideDBHandler(this, null, null, 1);
        //id
        int umbrella_agency = Agency.getSelectedItemPosition();
        int regional_admin = Regional.getSelectedItemPosition();
        int local_admin = Local.getSelectedItemPosition();
        String date = Date.getText().toString();
        String road_trail_number = RoadTrailNo.getText().toString();
        int road_or_trail = RoadTrail.getSelectedItemPosition();
        String road_trail_class = RoadTrailClass.getText().toString();
        String rater = Rater.getText().toString();
        String begin_mile_marker = BeginMile.getText().toString();
        String end_mile_marker = EndMile.getText().toString();
        int side = Side.getSelectedItemPosition();
        int weather = Weather.getSelectedItemPosition();
        String hazard_type = HazardType.getText().toString();
        String begin_coordinate_lat = BeginLat.getText().toString();
        String begin_coordinate_long = BeginLong.getText().toString();
        String end_coordinate_latitude = EndLat.getText().toString();
        String end_coordinate_longitude = EndLong.getText().toString();
        String datum = Datum.getText().toString();
        String aadt = Aadt.getText().toString();
        String length_affected = LengthAffected.getText().toString();
        String slope_height_axial_length = AxialLength.getText().toString();
        String slope_angle=SlopeAngle.getText().toString();
        String sight_distance = SightDistance.getText().toString();
        String road_trail_width = RtWidth.getText().toString();
        int speed_limit = Speed.getSelectedItemPosition();
        String minimum_ditch_width = DitchWidth1.getText().toString();
        String maximum_ditch_width = DitchWidth2.getText().toString();
        String minimum_ditch_depth = DitchDepth1.getText().toString();
        String maximum_ditch_Depth = DitchDepth2.getText().toString();
        String first_begin_ditch_slope = DitchSlope1.getText().toString();
        String first_end_ditch_slope = DitchSlope2.getText().toString();
        String second_begin_ditch_slope = DitchSlope3.getText().toString();
        String second_end_ditch_slope = DitchSlope4.getText().toString();
        String start_annual_rainfall =AnnualRain1.getText().toString();
        String end_annual_rainfall = AnnualRain2.getText().toString();
        int sole_access_route = SoleAccess.getSelectedItemPosition();
        int fixes_present = Mitigation.getSelectedItemPosition();
        String photos = "";
        String comments = Comments.getText().toString();
        String flma_name = FlmaName.getText().toString();
        String flma_id = FlmaId.getText().toString();
        String flma_description = FlmaDescription.getText().toString();

        //Preliminary Rating
            //landslide only
        int prelim_landslide_road_width_affected = RWidthAffected.getSelectedItemPosition();
        int prelim_landslide_slide_erosion_effects = SlideErosion.getSelectedItemPosition();
        String prelim_landslide_length_affected = RLengthAffected.getText().toString();
            //for all
        int impact_on_use = ImpactOU.getSelectedItemPosition();
        //0 is unchecked...1 is checked
        int aadt_usage_calc_checkbox = 0;
        if(CheckAadt.isChecked()){
            aadt_usage_calc_checkbox=1;
        }
        String aadt_usage = AadtEtc.getText().toString();
        String prelim_rating = PrelimRating.getText().toString();

        //Hazard Rating
            //for all
        int slope_drainage = SlopeDrainage.getSelectedItemPosition();
        String hazard_rating_annual_rainfall = AnnualRainfall.getText().toString();
        String hazard_rating_slope_height_axial_length = AxialLOS.getText().toString();
        String hazard_rating_total = HazardTotal.getText().toString();
            //landslide only
        int hazard_landslide_thaw_stability = ThawStability.getSelectedItemPosition();
        int hazard_landslide_maint_freq = InstabilityRMF.getSelectedItemPosition();
        int hazard_landslide_movement_history = MovementHistory.getSelectedItemPosition();

        //Risk Ratings
        String route_trail_width = RouteTW.getText().toString();
        String human_ex_factor = HumanEF.getText().toString();
        String percent_dsd = PercentDSD.getText().toString();
        int r_w_impacts = RightOWI.getSelectedItemPosition();
        int enviro_cult_impacts = ECImpact.getSelectedItemPosition();
        int maint_complexity = MaintComplexity.getSelectedItemPosition();
        int event_cost = EventCost.getSelectedItemPosition();
        String risk_total = RiskTotal.getText().toString();

        String total_score = Total.getText().toString();

        Landslide landslide =
                new Landslide(umbrella_agency,regional_admin,local_admin,date,road_trail_number,road_or_trail,road_trail_class,
                        rater,begin_mile_marker,end_mile_marker,side,weather,hazard_type,
                        begin_coordinate_lat,begin_coordinate_long,end_coordinate_latitude,
                        end_coordinate_longitude,datum,aadt,length_affected,slope_height_axial_length,
                        slope_angle,sight_distance,road_trail_width,speed_limit,minimum_ditch_width,
                        maximum_ditch_width,minimum_ditch_depth,maximum_ditch_Depth,first_begin_ditch_slope,
                        first_end_ditch_slope,second_begin_ditch_slope,second_end_ditch_slope,start_annual_rainfall,
                        end_annual_rainfall,sole_access_route,fixes_present,photos,comments,flma_name,flma_id,
                        flma_description,prelim_landslide_road_width_affected,prelim_landslide_slide_erosion_effects,
                        prelim_landslide_length_affected,impact_on_use,aadt_usage_calc_checkbox,aadt_usage,
                        prelim_rating,slope_drainage,hazard_rating_annual_rainfall,hazard_rating_slope_height_axial_length,
                        hazard_rating_total,hazard_landslide_thaw_stability,hazard_landslide_maint_freq,
                        hazard_landslide_movement_history,route_trail_width,human_ex_factor,percent_dsd,r_w_impacts,
                        enviro_cult_impacts,maint_complexity,event_cost,risk_total,total_score);

        dbHandler.addLandslide(landslide);
        //Message to the user that it worked....
        //set = 0

        //id
        Agency.setSelection(0);
        Regional.setSelection(0);
        Local.setSelection(0);
        Date.setText("");
        RoadTrailNo.setText("");
        RoadTrail.setSelection(0);
        RoadTrailClass.setText("");
        Rater.setText("");
        BeginMile.setText("");
        EndMile.setText("");
        Side.setSelection(0);
        Weather.setSelection(0);
        HazardType.setText("");
        BeginLat.setText("");
        BeginLong.setText("");
        EndLat.setText("");
        EndLong.setText("");
        Datum.setText("");
        Aadt.setText("");
        LengthAffected.setText("");
        AxialLength.setText("");
        SlopeAngle.setText("");
        SightDistance.setText("");
        RtWidth.setText("");
        Speed.setSelection(0);
        DitchWidth1.setText("");
        DitchWidth2.setText("");
        DitchDepth1.setText("");
        DitchDepth2.setText("");
        DitchSlope1.setText("");
        DitchSlope2.setText("");
        DitchSlope3.setText("");
        DitchSlope4.setText("");
        AnnualRain1.setText("");
        AnnualRain2.setText("");
        SoleAccess.setSelection(0);
        Mitigation.setSelection(0);
        //photos
        Comments.setText("");
        FlmaName.setText("");
        FlmaId.setText("");
        FlmaDescription.setText("");

        //Preliminary Rating
            //landslide only
        RWidthAffected.setSelection(0);
        SlideErosion.setSelection(0);
        LengthAffected.setSelection(0);
            //for all
        ImpactOU.setSelection(0);
        if(CheckAadt.isChecked()){
            CheckAadt.toggle();
        }
        AadtEtc.setText("");
        PrelimRating.setText("");

        //Hazard Rating
            //for all
        SlopeDrainage.setSelection(0);
        AnnualRainfall.setText("");
        AxialLOS.setText("");
        HazardTotal.setText("");
            //landslide only
        ThawStability.setSelection(0);
        InstabilityRMF.setSelection(0);
        MovementHistory.setSelection(0);

        //Risk Ratings

        RouteTW.setText("");
        HumanEF.setText("");
        PercentDSD.setText("");
        RightOWI.setSelection(0);
        ECImpact.setSelection(0);
        MaintComplexity.setSelection(0);
        EventCost.setSelection(0);
        RiskTotal.setText("");
        Total.setText("");

    }

    public void lookupLandslide(int finder) {
        LandslideDBHandler dbHandler = new LandslideDBHandler(this, null, null, 1);

        Landslide landslide = dbHandler.findLandslide(finder); //fill how?

        //set everything
        if (landslide != null) {
            Agency.setSelection(landslide.getAgency());
            Regional.setSelection(landslide.getRegional());
            Local.setSelection(landslide.getLocal());

            Date.setText(landslide.getDate());
            RoadTrailNo.setText(landslide.getRoad_trail_number());
            RoadTrail.setSelection(landslide.getRoad_or_Trail());
            RoadTrailClass.setText(landslide.getRoad_trail_class());
            Rater.setText(landslide.getRater());
            BeginMile.setText(landslide.getBegin_mile_marker());
            EndMile.setText(landslide.getEnd_mile_marker());
            Side.setSelection(landslide.getSide());
            Weather.setSelection(landslide.getWeather());
            HazardType.setText(landslide.getHazard_type());
            BeginLat.setText(landslide.getBegin_coordinate_lat());
            BeginLong.setText(landslide.getBegin_coordinate_long());
            EndLat.setText(landslide.getEnd_coordinate_latitude());
            EndLong.setText(landslide.getEnd_coordinate_longitude());
            Datum.setText(landslide.getDatum());
            Aadt.setText(landslide.getAadt());
            LengthAffected.setText(landslide.getLength_affected());
            AxialLength.setText(landslide.getSlope_height_axial_length());
            SlopeAngle.setText(landslide.getSlope_angle());
            SightDistance.setText(landslide.getSight_distance());
            RtWidth.setText(landslide.getRoad_trail_width());
            Speed.setSelection(landslide.getSpeed_limit());
            DitchWidth1.setText(landslide.getMinimum_ditch_width());
            DitchWidth2.setText(landslide.getMaximum_ditch_width());
            DitchDepth1.setText(landslide.getMinimum_ditch_depth());
            DitchDepth2.setText(landslide.getMaximum_ditch_depth());
            DitchSlope1.setText(landslide.getFirst_begin_ditch_slope());
            DitchSlope2.setText(landslide.getFirst_end_ditch_slope());
            DitchSlope3.setText(landslide.getSecond_begin_ditch_slope());
            DitchSlope4.setText(landslide.getSecond_end_ditch_slope());
            AnnualRain1.setText(landslide.getStart_annual_rainfall());
            AnnualRain2.setText(landslide.getEnd_annual_rainfall());
            SoleAccess.setSelection(landslide.getSole_access_route());
            Mitigation.setSelection(landslide.getFixes_Present());
            //photos
            Comments.setText(landslide.getComments());
            FlmaName.setText(landslide.getFlma_name());
            FlmaId.setText(landslide.getFlma_id());
            FlmaDescription.setText(landslide.getFlma_description());

            //preliminary rating
            //landslide only
            RWidthAffected.setSelection(landslide.getPrelim_landslide_road_width_affected());
            SlideErosion.setSelection(landslide.getPrelim_landslide_slide_erosion_effects());
            RLengthAffected.setText(landslide.getPrelim_landslide_length_affected());
            //for all
            ImpactOU.setSelection(landslide.getImpact_on_use());

            if (landslide.getAadt_usage_calc_checkbox() == 1 && !CheckAadt.isChecked()) {
                CheckAadt.toggle();
            } else if (landslide.getAadt_usage_calc_checkbox() == 0 && CheckAadt.isChecked()) {
                CheckAadt.toggle();
                ;
            }

            AadtEtc.setText(landslide.getAadt_usage());
            PrelimRating.setText(landslide.getPrelim_rating());

            //Hazard Rating
            //for all
            SlopeDrainage.setSelection(landslide.getSlope_drainage());
            AnnualRainfall.setText(landslide.getHazard_rating_annual_rainfall());
            AxialLOS.setText(landslide.getHazard_rating_slope_height_axial_length());
            HazardTotal.setText(landslide.getHazard_rating_total());
            //landslide only
            ThawStability.setSelection(landslide.getHazard_landslide_thaw_stability());
            InstabilityRMF.setSelection(landslide.getHazard_landslide_maint_frequency());
            MovementHistory.setSelection(landslide.getHazard_landslide_movement_history());

            //Risk Ratings
            RouteTW.setText(landslide.getRoute_trail_width());
            HumanEF.setText(landslide.getHuman_ex_factor());
            PercentDSD.setText(landslide.getPercent_dsd());
            RightOWI.setSelection(landslide.getR_w_impacts());
            ECImpact.setSelection(landslide.getEnviro_cult_impacts());
            MaintComplexity.setSelection(landslide.getMaint_complexity());
            EventCost.setSelection(landslide.getEvent_cost());
            RiskTotal.setText(landslide.getRisk_total());

            Total.setText(landslide.getTotal_score());

            if(OfflineList.should_submit==true){
                OfflineList.should_submit=false;
                //submit button perform click...
                SubmitButton.performClick();

            }


        } else {
            Comments.setText("No Match Found"); //or something else....
        }


    }
    }

