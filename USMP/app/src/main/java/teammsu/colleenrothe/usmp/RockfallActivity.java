package teammsu.colleenrothe.usmp;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.location.Location;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
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
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Button;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Pattern;
import android.widget.AdapterView.OnItemSelectedListener;
import com.darsh.multipleimageselect.activities.AlbumSelectActivity;
import com.darsh.multipleimageselect.helpers.Constants;
import com.darsh.multipleimageselect.models.Image;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.squareup.okhttp.Headers;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.MultipartBuilder;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

/* Class for the Rockfall Slope Rating Form
    CREDITS:
    (1) Post Request
            http://www.java2blog.com/2016/07/how-to-send-http-request-getpost-in-java.html
            http://stackoverflow.com/questions/6343166/how-to-fix-android-os-networkonmainthreadexception
    (2) Internet Connectivity
            http://stackoverflow.com/questions/28168867/check-internet-status-from-the-main-activity
    (3) Image Compression
            http://www.android-examples.com/compress-bitmap-image-in-android-and-reduce-image-size/
    (4) Image picker library
        https://github.com/darsh2/MultipleImageSelect
    (5) Upload an image
        https://github.com/square/okhttp/wiki/Recipes
 */


public class RockfallActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener, GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {

    //<<<SITE INFORMATION>>>
    Spinner Agency;
    Spinner Regional;
    Spinner Local;
    EditText Date;
    Spinner RoadTrail;
    EditText RoadTrailNo;
    EditText RoadTrailClass;
    EditText Rater;
    EditText BeginMile;
    EditText EndMile;
    Spinner Side;
    Spinner Weather;
    Spinner HazardType1;
    Spinner HazardType2;
    Spinner HazardType3;
    EditText BeginLat;
    EditText EndLat;
    EditText BeginLong;
    EditText EndLong;
    EditText Datum;
    EditText Aadt;
    EditText LengthAffected;
    EditText SlopeHeight;
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
    EditText BlkSize;
    int bulks = 0;
    EditText Volume;
    int vols = 0;
    EditText AnnualRain1;
    EditText AnnualRain2;
    Spinner SoleAccess;
    Spinner Mitigation;
    EditText Comments;
    EditText FlmaName;
    EditText FlmaId;
    EditText FlmaDescription;

    //<<<PRELIMINARY RATINGS>>
    Spinner DitchEffectiveness; //E
    Spinner RockfallHistory; //E
    EditText BSVperEvent; //F
    Spinner ImpactOU; //G
    EditText AadtEtc; //H
    CheckBox CheckAadt; //H checkbox
    Boolean aadtCheckmark = false; //H Checkmark
    //Prelim Total
    EditText PrelimRating;

    //<<<SLOPE HAZARD RATINGS>>>
    Spinner SlopeDrainage; //I
    EditText AnnualRainfall; //J
    EditText SlopeHeightCalc; //K
    Spinner RockfallRMF; //O
    Spinner StructuralCondition1; //P
    Spinner RockFriction1; //Q
    Spinner StructuralCondition2; //R
    Spinner RockFriction2; //S
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

    Button SubmitButton;
    ScrollView RScroll;

    //Location Stuff...
    private GoogleApiClient mGoogleApiClient;
    private Location mLastLocation;
    LocationRequest mLocationRequest;

    //edit site
    private static final String JSON_URL = "http://nl.cs.montana.edu/test_sites/colleen.rothe/get_current_site.php"; //to place the sites
    Map<String, String> map;

    ArrayAdapter<String> adapterRegional;
    ArrayList<String> fs_regions;

    ArrayAdapter<String> adapterLocal;
    ArrayList<String> fs_local1;

    //images
    ArrayList<Image> selectedImages;
    Uri imageUri;
    String [] savedImagePaths;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //provided
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rockfall);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //UI Connection
        SubmitButton = (Button)findViewById(R.id.RSubmitButton);
        RScroll = (ScrollView)findViewById(R.id.RScroll);

        RScroll.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
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

        //<<<SITE INFORMATION>>>
        Agency = (Spinner) findViewById(R.id.RAgency);
        Agency.setFocusable(true);
        Agency.setFocusableInTouchMode(true);
        Regional = (Spinner) findViewById(R.id.RRegional);
        Regional.setFocusable(true);
        Regional.setFocusableInTouchMode(true);
        Local = (Spinner) findViewById(R.id.RLocal);
        Local.setFocusable(true);
        Local.setFocusableInTouchMode(true);

        //listen if they change agency choice, update regional accordingly
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

        //listen if they change regional option, update local accordingly
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


        fs_regions = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterRegional = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_regions);
        adapterRegional.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Regional.setAdapter(adapterRegional);

        fs_local1 = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.RegionalList)));
        adapterLocal = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, fs_local1);
        adapterLocal.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        Local.setAdapter(adapterLocal);

        Date = (EditText) findViewById(R.id.R_Date);
        Calendar cal = Calendar.getInstance(TimeZone.getDefault());
        SimpleDateFormat sdf = new SimpleDateFormat("dd:MMMM:yyyy HH:mm:ss a");
        String strDate = sdf.format(cal.getTime());
        Date.setText(strDate, TextView.BufferType.EDITABLE);

        RoadTrail = (Spinner) findViewById(R.id.R_RoadTrail);
        RoadTrail.setFocusable(true);
        RoadTrail.setFocusableInTouchMode(true);
        RoadTrail.setOnItemSelectedListener(rtWatcher);

        RoadTrailNo = (EditText) findViewById(R.id.R_RoadTrailNo);
        RoadTrailNo.setOnFocusChangeListener(roadTrailNoWatcher);

        RoadTrailClass = (EditText) findViewById(R.id.R_RoadTrailClass);
        RoadTrailClass.setOnFocusChangeListener(roadTrailClassWatcher);

        Rater = (EditText) findViewById(R.id.R_Rater);
        Rater.setOnFocusChangeListener(raterWatcher);

        BeginMile = (EditText) findViewById(R.id.R_BeginMile);
        BeginMile.setOnFocusChangeListener(beginMileWatcher);

        EndMile = (EditText) findViewById(R.id.R_EndMile);
        EndMile.setOnFocusChangeListener(endMileWatcher);

        Side = (Spinner) findViewById(R.id.R_Side);
        Side.setFocusable(true);
        Side.setFocusableInTouchMode(true);

        Weather = (Spinner) findViewById(R.id.R_Weather);
        Weather.setFocusable(true);
        Weather.setFocusableInTouchMode(true);

        HazardType1 = (Spinner) findViewById(R.id.RHazard1);
        HazardType1.setFocusable(true);
        HazardType1.setFocusableInTouchMode(true);

        HazardType2 = (Spinner) findViewById(R.id.RHazard2);
        HazardType2.setFocusable(true);
        HazardType2.setFocusableInTouchMode(true);

        HazardType3 = (Spinner) findViewById(R.id.RHazard3);
        HazardType3.setFocusable(true);
        HazardType3.setFocusableInTouchMode(true);

        BeginLat = (EditText) findViewById(R.id.R_BeginLat);
        BeginLat.setOnFocusChangeListener(beginLatWatcher);

        EndLat = (EditText) findViewById(R.id.R_EndLat);
        EndLat.setOnFocusChangeListener(endLatWatcher);

        BeginLong = (EditText) findViewById(R.id.R_BeginLong);
        BeginLong.setOnFocusChangeListener(beginLongWatcher);

        EndLong = (EditText) findViewById(R.id.R_EndLong);
        EndLong.setOnFocusChangeListener(endLongWatcher);

        Datum = (EditText) findViewById(R.id.R_Datum);

        Aadt = (EditText) findViewById(R.id.R_Paadt);
        Aadt.setOnFocusChangeListener(aadtWatcher);

        LengthAffected = (EditText) findViewById(R.id.R_LengthAffected);
        LengthAffected.setOnFocusChangeListener(lengthAffectedWatcher);

        SlopeHeight = (EditText) findViewById(R.id.R_SlopeHeight);
        SlopeHeight.setOnFocusChangeListener(slopeHeightWatcher);

        SlopeAngle = (EditText) findViewById(R.id.R_SlopeAngle);
        SlopeAngle.setOnFocusChangeListener(slopeAngleWatcher);

        SightDistance = (EditText) findViewById(R.id.R_SightDistance);
        SightDistance.setOnFocusChangeListener(sightDistanceWatcher);

        RtWidth = (EditText) findViewById(R.id.R_RtWidth);
        RtWidth.setOnFocusChangeListener(rtWidthWatcher);

        Speed = (Spinner) findViewById(R.id.R_Speed);
        Speed.setOnItemSelectedListener(speedWatcher);
        Speed.setFocusable(true);
        Speed.setFocusableInTouchMode(true);

        DitchWidth1 = (EditText) findViewById(R.id.R_DitchWidth1);

        DitchWidth2 = (EditText) findViewById(R.id.R_DitchWidth2);

        DitchDepth1 = (EditText) findViewById(R.id.R_DitchDepth1);

        DitchDepth2 = (EditText) findViewById(R.id.R_DitchDepth2);

        DitchSlope1 = (EditText) findViewById(R.id.R_DitchSlope1);

        DitchSlope2 = (EditText) findViewById(R.id.R_DitchSlope2);

        DitchSlope3 = (EditText) findViewById(R.id.R_DitchSlope3);

        DitchSlope4 = (EditText) findViewById(R.id.R_DitchSlope4);

        BlkSize = (EditText) findViewById(R.id.R_BlkSize);
        BlkSize.setOnFocusChangeListener(blkSizeWatcher);

        Volume = (EditText) findViewById(R.id.R_Volume);
        Volume.setOnFocusChangeListener(volumeWatcher);

        AnnualRain1 = (EditText) findViewById(R.id.R_AnnualRain1);
        AnnualRain1.setOnFocusChangeListener(rainWatcher1);

        AnnualRain2 = (EditText) findViewById(R.id.R_AnnualRain2);
        AnnualRain2.setOnFocusChangeListener(rainWatcher2);

        SoleAccess = (Spinner) findViewById(R.id.R_SoleAccess);
        SoleAccess.setFocusableInTouchMode(true);
        SoleAccess.setFocusable(true);

        Mitigation = (Spinner) findViewById(R.id.R_Mitigation);
        Mitigation.setFocusableInTouchMode(true);
        Mitigation.setFocusable(true);

        Comments= (EditText) findViewById(R.id.R_Comments);
        FlmaName= (EditText) findViewById(R.id.R_FlmaName);
        FlmaId= (EditText) findViewById(R.id.R_FlmaId);
        FlmaDescription = (EditText) findViewById(R.id.R_FlmaDescription);

        //<<<PRELIMINARY RATINGS>>>
        DitchEffectiveness = (Spinner) findViewById(R.id.R_DitchEffectiveness); //D
        DitchEffectiveness.setOnItemSelectedListener(prelimWatcher);
        DitchEffectiveness.setOnItemSelectedListener(slopeHazardWatcher);
        DitchEffectiveness.setFocusable(true);
        DitchEffectiveness.setFocusableInTouchMode(true);

        RockfallHistory = (Spinner) findViewById(R.id.R_RockfallHistory); //E
        RockfallHistory.setOnItemSelectedListener(prelimWatcher);
        RockfallHistory.setFocusable(true);
        RockfallHistory.setFocusableInTouchMode(true);
        DitchEffectiveness.setOnItemSelectedListener(slopeHazardWatcher); //??????PROB

        BSVperEvent = (EditText) findViewById(R.id.R_BSVperEvent); //F
        BSVperEvent.setOnFocusChangeListener(BSVperEventWatcher);
        DitchEffectiveness.setOnItemSelectedListener(slopeHazardWatcher); //????PROB

        ImpactOU = (Spinner) findViewById(R.id.R_ImpactOU); //G
        ImpactOU.setOnItemSelectedListener(prelimWatcher);
        ImpactOU.setFocusable(true);
        ImpactOU.setFocusableInTouchMode(true);
        ImpactOU.setOnItemSelectedListener(riskWatcher);

        AadtEtc = (EditText) findViewById(R.id.R_AadtEtc); //H
        CheckAadt = (CheckBox) findViewById(R.id.R_CheckAadt);
        AadtEtc.setOnFocusChangeListener(aadtEtcWatcher);

        PrelimRating = (EditText) findViewById(R.id.R_PrelimRating);

        //<<<SLOPE HAZARD RATINGS>>>
        SlopeDrainage = (Spinner) findViewById(R.id.R_SlopeDrainage); //I
        SlopeDrainage.setFocusable(true);
        SlopeDrainage.setFocusableInTouchMode(true);
        SlopeDrainage.setOnItemSelectedListener(slopeHazardWatcher);

        AnnualRainfall = (EditText) findViewById(R.id.R_AnnualRainfall); //J
        AnnualRainfall.setOnFocusChangeListener(annualRainfallWatcher);

        SlopeHeightCalc = (EditText) findViewById(R.id.R_SlopeHeightCalc); //K
        SlopeHeightCalc.setOnFocusChangeListener(slopeHeightCalcWatcher);

        RockfallRMF = (Spinner) findViewById(R.id.R_RockfallRMF); //O
        RockfallRMF.setFocusable(true);
        RockfallRMF.setFocusableInTouchMode(true);
        RockfallRMF.setOnItemSelectedListener(slopeHazardWatcher);

        StructuralCondition1 = (Spinner) findViewById(R.id.R_StructuralCondition1); //P
        StructuralCondition1.setFocusable(true);
        StructuralCondition1.setFocusableInTouchMode(true);
        StructuralCondition1.setOnItemSelectedListener(slopeHazardWatcher);

        RockFriction1 = (Spinner) findViewById(R.id.R_RockFriction1); //Q
        RockFriction1.setFocusable(true);
        RockFriction1.setFocusableInTouchMode(true);
        RockFriction1.setOnItemSelectedListener(slopeHazardWatcher);

        StructuralCondition2 = (Spinner) findViewById(R.id.R_StructuralCondition2); //R
        StructuralCondition2.setFocusable(true);
        StructuralCondition2.setFocusableInTouchMode(true);
        StructuralCondition2.setOnItemSelectedListener(slopeHazardWatcher);

        RockFriction2 = (Spinner) findViewById(R.id.R_RockFriction2); //S
        RockFriction2.setFocusable(true);
        RockFriction2.setFocusableInTouchMode(true);
        RockFriction2.setOnItemSelectedListener(slopeHazardWatcher);

        HazardTotal = (EditText) findViewById(R.id.R_HazardTotal);
        HazardTotal.addTextChangedListener(totalWatcher);

        //<<<RISK RATINGS>>>
        RouteTW = (EditText) findViewById(R.id.R_RouteTW); //V
        RouteTW.setOnFocusChangeListener(routeTWWatcher);

        HumanEF = (EditText) findViewById(R.id.R_HumanEF); //W
        HumanEF.setText("1");
        HumanEF.setOnFocusChangeListener(humanEFCalcWatcher);

        PercentDSD = (EditText) findViewById(R.id.R_PercentDSD);//X
        PercentDSD.setOnFocusChangeListener(percentDsdWatcher);

        RightOWI = (Spinner) findViewById(R.id.R_RightOWI); //Y
        RightOWI.setFocusable(true);
        RightOWI.setFocusableInTouchMode(true);
        RightOWI.setOnItemSelectedListener(riskWatcher);

        ECImpact = (Spinner) findViewById(R.id.R_ECImpact); //Z
        ECImpact.setFocusable(true);
        ECImpact.setFocusableInTouchMode(true);
        ECImpact.setOnItemSelectedListener(riskWatcher);

        MaintComplexity = (Spinner) findViewById(R.id.R_MaintComplexity); //AA
        MaintComplexity.setFocusable(true);
        MaintComplexity.setFocusableInTouchMode(true);
        MaintComplexity.setOnItemSelectedListener(riskWatcher);

        EventCost = (Spinner) findViewById(R.id.R_EventCost); //BB
        EventCost.setFocusable(true);
        EventCost.setFocusableInTouchMode(true);
        EventCost.setOnItemSelectedListener(riskWatcher);

        RiskTotal = (EditText) findViewById(R.id.R_RiskTotal);
        RiskTotal.addTextChangedListener(totalWatcher);

        //FINAL TOTAL
        Total = (EditText) findViewById(R.id.R_TotalScore);

        //LOAD
        if (OfflineList.selected_row!=-1 && OfflineList.should_load==true){
            OfflineList.should_load=false;
            lookupRockfall(OfflineList.selected_row);
        }

        //EDIT
        if(getIntent().getStringExtra("editing") != null){
            System.out.println("yay! please do edit");
            getJSON(JSON_URL);
        }
        else if(getIntent().getStringExtra("offline")!=null){
            System.out.println("yay! offline form");
            loadFromOffline();
        }

        if(!isNetworkAvailable()){
            SubmitButton.setBackgroundColor(Color.DKGRAY);
            SubmitButton.setClickable(false);
        }


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

    //CREDITS (2)
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

    //location methods...

    protected void createLocationRequest() {
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
    }

    //Set current location for beginning latitude/longitude
    public void setBeginCoords(View view) {
        if(mLastLocation!=null){
            BeginLat.setText(String.valueOf(mLastLocation.getLatitude()));
            BeginLong.setText(String.valueOf(mLastLocation.getLongitude()));

        }

    }

    //set current location for ending latitude/longitude
    public void setEndCoords(View view) {
        if(mLastLocation!=null){
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

    @Override
    protected void onStop() {
        super.onStop();
        if (mGoogleApiClient != null) {
            mGoogleApiClient.disconnect();
        }
    }

    //////////End location methods

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
        getMenuInflater().inflate(R.menu.rockfall, menu);
        getMenuInflater().inflate(R.menu.menu_main, menu);

        return true;
    }

    //side menu
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_home) {
            Intent intent = new Intent(this, OnlineHomeActivity.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }


    //top menu
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
            Intent intent = new Intent(this, MaintenanceActivity.class);
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

                //Map<String, String> map = new Gson().fromJson(text2, new TypeToken<HashMap<String, String>>() {}.getType());
                map = new Gson().fromJson(text3, new TypeToken<HashMap<String, String>>() {}.getType());
                System.out.println(map);
                System.out.println("keys");
                System.out.println(map.keySet());

                //Set form fields

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

                //todo: hazard type (1)
                String hazardString = map.get("HAZARD_TYPE2");
                System.out.println("hazard string is: "+ hazardString);
                if(!hazardString.equals("") && !hazardString.equals(null)) {
                    String[] hazards = hazardString.split(",");
                    ArrayList<String> hazardTypeList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.HazardTypeRList)));


                    for (int i = 0; i < hazards.length; i++) {
                        if (i == 3) { //can't have more than 3
                            break;
                        }
                        //if it's in the list, set the spinner to it
                        if (hazardTypeList.contains(hazards[i])) {
                            if (i == 0) {
                                HazardType1.setSelection(hazardTypeList.indexOf(hazards[i]));
                            } else if (i == 1) {
                                HazardType2.setSelection(hazardTypeList.indexOf(hazards[i]));
                            } else {
                                HazardType3.setSelection(hazardTypeList.indexOf(hazards[i]));
                            }
                        }
                    }
                }


                BeginLat.setText(map.get("BEGIN_COORDINATE_LAT"));
                EndLat.setText(map.get("END_COORDINATE_LAT"));
                BeginLong.setText(map.get("BEGIN_COORDINATE_LONG"));
                EndLong.setText(map.get("END_COORDINATE_LONG"));
                Datum.setText(map.get("DATUM"));
                Aadt.setText(map.get("AADT"));
                LengthAffected.setText(map.get("LENGTH_AFFECTED"));
                SlopeHeight.setText(map.get("SLOPE_HT_AXIAL_LENGTH"));
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

                BlkSize.setText(map.get("BLK_SIZE"));
                Volume.setText(map.get("VOLUME"));

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

                //PRELIMINARY RATINGS-Rockfall ONLY
                String [] ratingArray = getResources().getStringArray(R.array.ratingList);
                String [] zeroRatingArray = getResources().getStringArray(R.array.zeroRatingList);

                String rockfall_prelim_ditch_eff = map.get("ROCKFALL_PRELIM_DITCH_EFF");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(rockfall_prelim_ditch_eff)){
                        DitchEffectiveness.setSelection(i);
                    }
                }

                String rockfall_prelim_rockfall_history = map.get("ROCKFALL_PRELIM_ROCKFALL_HISTORY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(rockfall_prelim_rockfall_history)){
                        RockfallHistory.setSelection(i);
                    }
                }

                BSVperEvent.setText(map.get("ROCKFALL_PRELIM_BLOCK_SIZE_EVENT_VOL"));

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

                AadtEtc.setText(map.get("PRELIMINARY_RATING_AADT_USAGE"));
                PrelimRating.setText(map.get("PRELIMINARY_RATING"));

                //Slope Hazard Ratings ALL
                String hazard_rating_slope_drainage = map.get("HAZARD_RATING_SLOPE_DRAINAGE");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(hazard_rating_slope_drainage)){
                        SlopeDrainage.setSelection(i);
                    }
                }

                AnnualRainfall.setText(map.get("HAZARD_RATING_ANNUAL_RAINFALL"));
                SlopeHeightCalc.setText(map.get("HAZARD_RATING_SLOPE_HEIGHT_AXIAL_LENGTH"));
                HazardTotal.setText(map.get("HAZARD_TOTAL"));

                //Slope Hazard Ratings->Rockfall Only
                String rockfall_hazard_rating_maint_frequency = map.get("ROCKFALL_HAZARD_RATING_MAINT_FREQUENCY");
                for(int i = 0; i< ratingArray.length; i++){
                    if(ratingArray[i].equals(rockfall_hazard_rating_maint_frequency)){
                        RockfallRMF.setSelection(i);
                    }
                }

                String rockfall_hazard_rating_case_one_struc_condition = map.get("ROCKFALL_HAZARD_RATING_CASE_ONE_STRUC_CONDITION");
                for(int i = 0; i< ratingArray.length; i++){
                    if(zeroRatingArray[i].equals(rockfall_hazard_rating_case_one_struc_condition)){
                        StructuralCondition1.setSelection(i);
                    }
                }

                String rockfall_hazard_rating_case_one_rock_friction = map.get("ROCKFALL_HAZARD_RATING_CASE_ONE_ROCK_FRICTION");
                for(int i = 0; i< ratingArray.length; i++){
                    if(zeroRatingArray[i].equals(rockfall_hazard_rating_case_one_rock_friction)){
                        RockFriction1.setSelection(i);
                    }
                }

                String rockfall_hazard_rating_case_two_struc_condition = map.get("ROCKFALL_HAZARD_RATING_CASE_TWO_STRUC_CONDITION");
                for(int i = 0; i< ratingArray.length; i++){
                    if(zeroRatingArray[i].equals(rockfall_hazard_rating_case_two_struc_condition)){
                        StructuralCondition2.setSelection(i);
                    }
                }

                String rockfall_hazard_rating_case_two_diff_erosion = map.get("ROCKFALL_HAZARD_RATING_CASE_TWO_DIFF_EROSION");
                for(int i = 0; i< ratingArray.length; i++){
                    if(zeroRatingArray[i].equals(rockfall_hazard_rating_case_two_diff_erosion)){
                        RockFriction2.setSelection(i);
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
    //call to get info from db
    private void getJSON(String url) {
        class GetJSON extends AsyncTask<String, Void, String> {

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


    //Road Trail No. Verification
    private final View.OnFocusChangeListener roadTrailNoWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (RoadTrailNo.getText().length() == 0) {
                    RoadTrailNo.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
                    builder.setMessage("Road/Trail No. must have a value.")
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
    private final View.OnFocusChangeListener roadTrailClassWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (RoadTrailClass.getText().length() == 0) {
                    RoadTrailClass.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
                    builder.setMessage("Road/Trail class must have a value.")
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
    private final View.OnFocusChangeListener raterWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (Rater.getText().length() == 0 || Rater.getText().length() >= 30) {
                    Rater.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
    private final View.OnFocusChangeListener beginMileWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginMile.getText().toString();

                if (text.length() == 0 || (!Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    BeginMile.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
    private final View.OnFocusChangeListener endMileWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndMile.getText().toString();

                if (text.length() == 0 || (!Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    EndMile.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    //Latitude Validation
    private final View.OnFocusChangeListener beginLatWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginLat.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]{2}\\.[0-9]+", text))) {
                    BeginLat.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener endLatWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndLat.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]{2}\\.[0-9]+", text))) {
                    EndLat.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
    private final View.OnFocusChangeListener beginLongWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = BeginLong.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("\\-[0-9]{3}\\.[0-9]+", text))) {
                    BeginLong.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener endLongWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = EndLong.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("\\-[0-9]{3}\\.[0-9]+", text))) {
                    EndLong.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener aadtWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (Aadt.length() == 0) {
                    Aadt.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));
                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
    private final View.OnFocusChangeListener aadtEtcWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                if (AadtEtc.length() == 0) {
                    AadtEtc.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));
                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener lengthAffectedWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = LengthAffected.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    LengthAffected.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                else{
                    LengthAffected.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }
            }
        }

    };

    //Validation: Slope Height -->(k)
    private final View.OnFocusChangeListener slopeHeightWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = SlopeHeight.getText().toString();
                if (s.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", s))) {
                    SlopeHeight.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

                    String lengthS = SlopeHeight.getText().toString();
                    double length = Double.parseDouble(lengthS);

                    x = (length / 25);

                    score = Math.pow(3, x);

                    if (score > 100) {
                        score = 100;
                    }

                    int scoreInt = (int) Math.round(score);

                    String scores = String.valueOf(scoreInt);
                    SlopeHeightCalc.setText(scores);
                    slopeHazardCalc();
                    SlopeHeight.setBackgroundColor(getResources().getColor(android.R.color.transparent));


                }

            }
        }

    };

    //Validation: Slope Angle
    private final View.OnFocusChangeListener slopeAngleWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 100;
                if(SlopeAngle.getText().length() != 0){
                    text = Integer.parseInt(SlopeAngle.getText().toString()); //problem if there is a .

                }
                if (SlopeAngle.length() == 0 || text < 0 || text > 90) {
                    SlopeAngle.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
    private final View.OnFocusChangeListener sightDistanceWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {
            if (!hasFocus) {
                String text = SightDistance.getText().toString();

                if (SightDistance.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    SightDistance.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener BSVperEventWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 101;
                if (BSVperEvent.getText().length() != 0) {
                    text = Integer.parseInt(BSVperEvent.getText().toString());
                }
                if (BSVperEvent.length() == 0 || text > 100 || text < 0) {
                    BSVperEvent.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                    BSVperEvent.setBackgroundColor(getResources().getColor(android.R.color.transparent));
                }
            }
        }
    };


    //calculate prelim rating on change
    private final OnItemSelectedListener prelimWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            calcPrelim();
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    //calc prelim here
    public void calcPrelim(){
        int score = 0;
        int d = 0;
        int e = 0;
        int f = 0;
        int g = 0;
        int h = 0;
        //D: spinner ditch effectiveness
        int aH = DitchEffectiveness.getSelectedItemPosition();
        if (aH == 0) {
            d = 3;
        } else if (aH == 1) {
            d = 9;
        } else if (aH == 2) {
            d = 27;
        } else if (aH == 3) {
            d = 81;
        }

        //E: Rockfall History spinner
        int bH = RockfallHistory.getSelectedItemPosition();
        if (bH == 0) {
            e = 3;
        } else if (bH == 1) {
            e = 9;
        } else if (bH == 2) {
            e = 27;
        } else if (bH == 3) {
            e = 81;
        }
        //F: Blk Size/Vol per event
        int lengthC = BSVperEvent.getText().length();
        if (lengthC != 0) {
            f = Integer.parseInt(BSVperEvent.getText().toString());
            score += f;
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


        score = score + d + e + g;

        String scores = String.valueOf(score);
        PrelimRating.setText(scores);

    }

    //SLOPE HAZARD RATINGS
    //J: Update Annual Rainfall
    private final View.OnFocusChangeListener rainWatcher1 = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = AnnualRain1.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    AnnualRain1.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    private final View.OnFocusChangeListener rainWatcher2 = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String text = AnnualRain2.getText().toString();

                if (text.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", text))) {
                    AnnualRain2.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                    if(rainS1.length() != 0) {
                        rain1 = Double.parseDouble(rainS1);
                    }

                    String rainS2 = AnnualRain2.getText().toString();
                    if(rainS2.length() != 0) {
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
    private final View.OnFocusChangeListener annualRainfallWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                int text = 101;
                if(AnnualRainfall.getText().length() != 0){
                    text = Integer.parseInt(AnnualRainfall.getText().toString());
                }
                if (AnnualRainfall.length() == 0 || text > 100 || text < 0) {
                    AnnualRainfall.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                else{
                    slopeHazardCalc();
                    AnnualRainfall.setBackgroundColor(getResources().getColor(android.R.color.transparent));
                }
            }
        }

    };

    //validation if they were to manually change the annual rainfall
    private final View.OnFocusChangeListener blkSizeWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String blk = BlkSize.getText().toString();
                double bulk = 0;

                if(blk.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", blk))){
                    BlkSize.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
                    builder.setMessage("Blk size must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }
                else{
                    BlkSize.setBackgroundColor(getResources().getColor(android.R.color.transparent));
                    double x = Double.parseDouble(blk);
                    bulk = Math.pow(3,x);
                    if(bulk > 100){
                        bulk = 100;
                    }
                    bulks = (int) Math.round(bulk);

                    int score = 0;
                    if(bulks > vols){
                        String answer = String.valueOf(bulks);
                        BSVperEvent.setText(answer);
                    }
                    else{
                        String answer = String.valueOf(vols);
                        BSVperEvent.setText(answer);

                    }
                }

            }

        }

    };

    //validation if they were to manually change the annual rainfall
    private final View.OnFocusChangeListener volumeWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String volume = Volume.getText().toString();
                double vol = 0 ;

                if(volume.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", volume))){
                    Volume.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
                    builder.setMessage("Volume must have a decimal value.")
                            .setTitle("Warning");
                    builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            // User clicked OK button
                        }
                    });

                    AlertDialog dialog = builder.create();

                    dialog.show();

                }

                else{
                    Volume.setBackgroundColor(getResources().getColor(android.R.color.transparent));
                    Double med = Double.parseDouble(volume);
                    double x = (med/3);
                    vol = Math.pow(3,x);
                    if(vol > 100){
                        vol = 100;
                    }
                    vols = (int) Math.round(vol);

                    int score = 0;
                    if(bulks > vols){
                        String answer = String.valueOf(bulks);
                        BSVperEvent.setText(answer);
                    }
                    else{
                        String answer = String.valueOf(vols);
                        BSVperEvent.setText(answer);

                    }
                }


            }

        }

    };

    //Validation: if they were to manually change axial los
    private final View.OnFocusChangeListener slopeHeightCalcWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = SlopeHeightCalc.getText().toString();
                int text = 101;
                if(s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    SlopeHeightCalc.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                    SlopeHeightCalc.setBackgroundColor(getResources().getColor(android.R.color.transparent));
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

    //slope hazard calc: D+E+F+I+J+K+O+(>(P+Q || (R+S)
    public void slopeHazardCalc() {
        int score = 0;
        int d = 0;
        int e = 0;
        int f = 0;
        int i = 0;
        int j = 0;
        int k = 0;
        int o = 0;
        int p = 0;
        int q = 0;
        int r = 0;
        int s = 0;
        int big = 0;

        //D: spinner ditch effectiveness
        int aH = DitchEffectiveness.getSelectedItemPosition();
        if (aH == 0) {
            d = 3;
        } else if (aH == 1) {
            d = 9;
        } else if (aH == 2) {
            d = 27;
        } else if (aH == 3) {
            d = 81;
        }

        //E: Rockfall History spinner
        int bH = RockfallHistory.getSelectedItemPosition();
        if (bH == 0) {
            e = 3;
        } else if (bH == 1) {
            e = 9;
        } else if (bH == 2) {
            e = 27;
        } else if (bH == 3) {
            e = 81;
        }
        //F: Blk Size/Vol per event
        int lengthC = BSVperEvent.getText().length();
        if (lengthC != 0) {
            f = Integer.parseInt(BSVperEvent.getText().toString());
            score += f;
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
        int lengthK = SlopeHeightCalc.getText().toString().length();
        if (lengthK != 0) {
            k = Integer.parseInt(SlopeHeightCalc.getText().toString());
            score += k;
        }

        //O: Rockfall  RMF
        int lH = RockfallRMF.getSelectedItemPosition();
        if (lH == 0) {
            o = 3;
        } else if (lH == 1) {
            o = 9;
        } else if (lH == 2) {
            o = 27;
        } else if (lH == 3) {
            o = 81;
        }

        //P: Structural Condition I
        int mH = StructuralCondition1.getSelectedItemPosition();
        if (mH == 0) {
            p = 3;
        } else if (mH == 1) {
            p = 9;
        } else if (mH == 2) {
            p = 27;
        } else if (mH == 3) {
            p = 81;
        }

        //Q: Friction I
        int nH = RockFriction1.getSelectedItemPosition();
        if (nH == 0) {
            q = 3;
        } else if (nH == 1) {
            q = 9;
        }
        if (nH == 2) {
            q = 27;
        }
        if (nH == 3) {
            q = 81;
        }

        //R: Structural Condition II
        int rH = StructuralCondition2.getSelectedItemPosition();
        if(rH == 0){
            r=3;
        }
        else if (rH == 1){
            r = 9;
        }
        else if (rH == 2){
            r = 27;
        }
        else if (rH == 3){
            r = 81;
        }

        //S: Rock Friction II (Dif. in erosion rate)
        int sH = RockFriction2.getSelectedItemPosition();
        if(sH == 0){
            s = 3;
        }
        else if (sH == 1){
            s = 9;
        }
        else if (sH == 2){
            s = 27;
        }
        else if (sH == 3){
            s = 81;
        }

        int pq = p+q;
        int rs = r+s;

        if(pq>rs){
            big = pq;
        }
        else{
            big = rs;
        }

        score = score + d + e + i + o + big;
        String scoreS = String.valueOf(score);
        HazardTotal.setText(scoreS);

    }

    //RISK RATINGS
    //V-Need to pull if either road/ trail....need to somehow watch the rt spinner
    private final View.OnFocusChangeListener rtWidthWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = RtWidth.getText().toString();

                if (s.length() == 0 || !(Pattern.matches("[0-9]+\\.*[0-9]*", s))) {
                    RtWidth.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                else{
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
    private final View.OnFocusChangeListener routeTWWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = RouteTW.getText().toString();
                int text = 101;
                if(s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    RouteTW.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                else{

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

    private final View.OnFocusChangeListener humanEFCalcWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                //if not empty...
                String s = HumanEF.getText().toString();
                int text = 101;
                if(s.length() != 0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    HumanEF.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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

    //Validation If they were to manually change X
    private final View.OnFocusChangeListener percentDsdWatcher = new View.OnFocusChangeListener() {
        public void onFocusChange(View v, boolean hasFocus) {

            if (!hasFocus) {
                String s = PercentDSD.getText().toString();
                int text = 101;
                if(s.length() !=0) {
                    text = Integer.parseInt(s);
                }
                if (s.length() == 0 || text > 100 || text < 0) {
                    System.out.println("TEXT IS" + text);
                    PercentDSD.setBackgroundColor(getResources().getColor(android.R.color.holo_red_dark));

                    AlertDialog.Builder builder = new AlertDialog.Builder(RockfallActivity.this);
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
                else {
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

    //on changed, calculate risk total
    private final OnItemSelectedListener riskWatcher = new OnItemSelectedListener() {

        @Override

        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            calcRiskTotal();
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {
        }

    };

    public void calcRiskTotal(){
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

    //on changed, calculate total
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


    //<<POPUPS>>
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

    //ditch effectiveness
    public void popup2(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Good\n\n9:Moderate%\n\n27:Limited%\n\n81:No Catchment%", TextView.BufferType.NORMAL);

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

    //rockfall history
    public void popup3(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Few Falls\n\n9:Occasional Falls\n\n27:Many Falls\n\n81:Constant Falls", TextView.BufferType.NORMAL);

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

    //block size or volume
    public void popup4(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:1ft or 3yd^3\n\n9:2ft or 6yd^3\n\n27:3ft or 9yd^3\n\n81:4ft or 12yd^3", TextView.BufferType.NORMAL);

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

    //preliminary rating
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

    //slope drainage
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

    //annual rainfall
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

    //slope height
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

    //rockfall-related maintenance frequency
    public void popup11(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Normal,scheduled maintenance\n\n9:Patrols after every storm event\n\n27:Routine seasonal patrols\n\n81:Year round patrols");

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

    //Geo Character Case I

    //structural condition
    public void popup12(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Discontinuous favorable\n\n9:Discontinuous random\n\n27:Discontinuous adverse\n\n81:Continuous adverse");

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

    //rock friction
    public void popup13(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Rough/Irregular\n\n9:Undulating\n\n27:Planar\n\n81:Clay infilled/Slickensided");

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

    //Geo character Case II

    //structural condition
    public void popup14(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Few differential erosion features\n\n9:Occasional differential erosion features\n\n27:Many differential erosion features\n\n81:Major differential erosion features");

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

    //Diff. in Erosion Rates
    public void popup15(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Small Difference\n\n9:Moderate difference\n\n27:Large difference\n\n81:Extreme difference");

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

    //RISK RATINGS

    //route or trail width
    public void popup16(View view) {
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

    public void popup17(View view) {
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

    public void popup18(View view) {
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

    public void popup19(View view) {
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

    public void popup20(View view) {
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

    public void popup21(View view) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        final TextView tv = new TextView(this);
        tv.setText("3:Routine Effort/In-House\n\n9:In-House maint./special project\n\n27:Specialized equip/contract\n\n81:Complex/dangerous effort/location/contract");

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

    public void popup22(View view) {
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

    public void popup23(View view) {
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

  //submit edited form
    public void editSubmit() throws Exception{
        Thread thread = new Thread(new Runnable() {

            @Override
            public void run() {
                try {
                    URL url = new URL("http://nl.cs.montana.edu/test_sites/colleen.rothe/editSite.php");
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
                    //todo: hazard type (2)
                    String temp = "";
                    if(HazardType1.getSelectedItem().toString() != "") {
                        temp = temp.concat(HazardType1.getSelectedItem().toString());
                    }
                    if(HazardType2.getSelectedItem().toString() != "") {
                        temp = temp.concat(",");
                        temp = temp.concat(HazardType2.getSelectedItem().toString());
                    }
                    if(HazardType3.getSelectedItem().toString() != "") {
                        temp = temp.concat(",");
                        temp = temp.concat(HazardType3.getSelectedItem().toString());
                    }
                    String hazard_type = temp;



                    String length_affected = String.valueOf(LengthAffected.getText());
                    String slope_height_axial_length = String.valueOf(SlopeHeight.getText());
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
                    String blk_size = String.valueOf(BlkSize.getText());
                    String volume = String.valueOf(Volume.getText());


                    String comments = String.valueOf(Comments.getText());
                    String flma_id = String.valueOf(FlmaId.getText());
                    String flma_name = String.valueOf(FlmaName.getText());
                    String flma_description = String.valueOf(FlmaDescription.getText());

                    //PRELIMINARY RATING
                    String ditch_eff = "3";
                    if (DitchEffectiveness.getSelectedItemPosition() == 1) {
                        ditch_eff = "9";
                    } else if (DitchEffectiveness.getSelectedItemPosition() == 2) {
                        ditch_eff = "27";
                    } else if (DitchEffectiveness.getSelectedItemPosition() == 3) {
                        ditch_eff = "81";
                    }

                    String rockfall_history = "3";
                    if (RockfallHistory.getSelectedItemPosition() == 1) {
                        rockfall_history = "9";
                    } else if (RockfallHistory.getSelectedItemPosition() == 2) {
                        rockfall_history = "27";
                    } else if (RockfallHistory.getSelectedItemPosition() == 3) {
                        rockfall_history = "81";
                    }

                    String block_size_event_vol = String.valueOf(BSVperEvent.getText());

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
                    String axial_los = String.valueOf(SlopeHeightCalc.getText()); //hr_slope_height_axial_length

                    String rockfall_related_maint_frequency = "3";
                    if (RockfallRMF.getSelectedItemPosition() == 1) {
                        rockfall_related_maint_frequency = "9";
                    } else if (RockfallRMF.getSelectedItemPosition() == 2) {
                        rockfall_related_maint_frequency = "27";
                    } else if (RockfallRMF.getSelectedItemPosition() == 3) {
                        rockfall_related_maint_frequency = "81";
                    }

                    //geo case 1
                    String case_one_struc_condition = "3";
                    if (StructuralCondition1.getSelectedItemPosition() == 1) {
                        case_one_struc_condition = "9";
                    } else if (StructuralCondition1.getSelectedItemPosition() == 2) {
                        case_one_struc_condition = "27";
                    } else if (StructuralCondition1.getSelectedItemPosition() == 3) {
                        case_one_struc_condition = "81";
                    }

                    String case_one_rock_friction = "3";
                    if (RockFriction1.getSelectedItemPosition() == 1) {
                        case_one_rock_friction = "9";
                    } else if (RockFriction1.getSelectedItemPosition() == 2) {
                        case_one_rock_friction = "27";
                    } else if (RockFriction1.getSelectedItemPosition() == 3) {
                        case_one_rock_friction = "81";
                    }

                    //geo case 2
                    String case_two_struc_condition = "3";
                    if (StructuralCondition2.getSelectedItemPosition() == 1) {
                        case_two_struc_condition = "9";
                    } else if (StructuralCondition2.getSelectedItemPosition() == 2) {
                        case_two_struc_condition = "27";
                    } else if (StructuralCondition2.getSelectedItemPosition() == 3) {
                        case_two_struc_condition = "81";
                    }

                    String case_two_diff_erosion = "3";
                    if (RockFriction2.getSelectedItemPosition() == 1) {
                        case_two_diff_erosion = "9";
                    } else if (RockFriction2.getSelectedItemPosition() == 2) {
                        case_two_diff_erosion = "27";
                    } else if (RockFriction2.getSelectedItemPosition() == 3) {
                        case_two_diff_erosion = "81";
                    }


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

                    //todo: hazard type (3) after aadt
                    writer.write("umbrella_agency=" + umbrella_agency + "&regional_admin=" + regional_admin + "&local_admin=" + local_admin + "&road_trail_number=" + road_trail_number + "&road_trail_class=" + road_trail_class +
                            "&begin_mile_marker=" + begin_mile_marker + "&end_mile_marker=" + end_mile_marker + "&road_or_trail=" + road_or_trail + "&side=" +
                            side + "&rater=" + l_rater + "&weather=" + weather + "&begin_coordinate_latitude=" + begin_coordinate_lat + "&begin_coordinate_longitude=" +
                            begin_coordinate_long + "&end_coordinate_latitude=" + end_coordinate_latitude + "&end_coordinate_longitude=" + end_coordinate_longitude +
                            "&datum=" + datum + "&aadt=" + aadt + "&hazard_type="+hazard_type+ "&length_affected=" + length_affected + "&slope_height_axial_length=" +
                            slope_height_axial_length + "&slope_angle=" + slope_angle + "&sight_distance=" + sight_distance + "&road_trail_width=" + road_trail_width +
                            "&speed_limit=" + speed_limit + "&minimum_ditch_width=" + minimum_ditch_width + "&maximum_ditch_width" + maximum_ditch_width +
                            "&minimum_ditch_depth=" + minimum_ditch_depth + "&maximum_ditch_depth=" + maximum_ditch_depth + "&first_begin_ditch_slope=" + first_begin_ditch_slope +
                            "&first_end_ditch_slope=" + first_end_ditch_slope + "&second_begin_ditch_slope=" + second_begin_ditch_slope + "&second_end_ditch_slope=" +
                            second_end_ditch_slope + "&start_annual_rainfall=" + start_annual_rainfall + "&end_annual_rainfall=" + end_annual_rainfall +
                            "&sole_access_route=" + sole_access_route + "&fixes_present=" + fixes_present + "&blk_size=" + blk_size + " &volume=" + volume + "&prelim_landslide_road_width_affected= &prelim_landslide_slide_erosion_effects= &prelim_landslide_slide_erosion_effects= " +
                            "&prelim_landslide_length_affected=" + length_affected + "&prelim_rockfall_ditch_eff=" + ditch_eff + "&prelim_rockfall_rockfall_history=" + rockfall_history +
                            "&prelim_rockfall_block_size_event_vol=" + block_size_event_vol + " &impact_on_use=" + impact_on_use + "&aadt_usage_calc_checkbox=" +
                            aadt_usage_calc_checkbox + "&aadt_usage=" + aadt_usage + "&prelim_rating=" + prelim_rating + "&slope_drainage=" +
                            slope_drainage + "&hazard_rating_annual_rainfall=" + annual_rainfall + "&hazard_rating_slope_height_axial_length=" + axial_los +
                            "&hazard_landslide_thaw_stability= &hazard_landslide_maint_frequency= &hazard_landslide_movement_history= " +
                            "&hazard_rockfall_maint_frequency=" + rockfall_related_maint_frequency + "&case_one_struc_cond=" + case_one_struc_condition + " &case_one_rock_friction=" + case_one_rock_friction + "&case_two_struc_condition=" + case_two_struc_condition + " &case_two_diff_erosion=" +
                            case_two_diff_erosion + "&route_trail_width=" + route_trail_width + "&human_ex_factor=" + human_ex_factor + "&percent_dsd=" + percent_dsd + "&r_w_impacts=" +
                            r_w_impacts + "&enviro_cult_impacts=" + enviro_cult_impacts + "&maint_complexity=" + maint_complexity + "&event_cost=" + event_cost +
                            "&hazard_rating_landslide_total=" + hazard_total + "&hazard_rating_rockfall_total= &risk_total=" + risk_total + "&total_score=" + total_score + "&comments=" +
                            comments + "&fmla_id=" + flma_id + "&fmla_name=" + flma_name + "&fmla_description=" + flma_description);

                    //success message
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RockfallActivity.this);
                    final TextView tv = new TextView(RockfallActivity.this);
                    tv.setText("Form Submitted Successfully", TextView.BufferType.NORMAL);

                    alertDialogBuilder.setView(tv);
                    alertDialogBuilder.setCancelable(false).setPositiveButton("OK", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                        }
                    });

                    // create alert dialog
                    AlertDialog alertDialog = alertDialogBuilder.create();
                    // show it
                    alertDialog.show();
                    //end success message

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

    //Submit rockfall form
    public void RSubmit(View view) throws Exception{
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
                        //todo: hazard type (4)
                        String temp = "";
                        if(HazardType1.getSelectedItem().toString() != "") {
                            temp = temp.concat(HazardType1.getSelectedItem().toString());
                        }
                        if(HazardType2.getSelectedItem().toString() != "") {
                            temp = temp.concat(",");
                            temp = temp.concat(HazardType2.getSelectedItem().toString());
                        }
                        if(HazardType3.getSelectedItem().toString() != "") {
                            temp = temp.concat(",");
                            temp = temp.concat(HazardType3.getSelectedItem().toString());
                        }
                        String hazard_type = temp;
                        String length_affected = String.valueOf(LengthAffected.getText());
                        String slope_height_axial_length = String.valueOf(SlopeHeight.getText());
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
                        String blk_size = String.valueOf(BlkSize.getText());
                        String volume = String.valueOf(Volume.getText());


                        String comments = String.valueOf(Comments.getText());
                        String flma_id = String.valueOf(FlmaId.getText());
                        String flma_name = String.valueOf(FlmaName.getText());
                        String flma_description = String.valueOf(FlmaDescription.getText());

                        //PRELIMINARY RATING
                        String ditch_eff = "3";
                        if (DitchEffectiveness.getSelectedItemPosition() == 1) {
                            ditch_eff = "9";
                        } else if (DitchEffectiveness.getSelectedItemPosition() == 2) {
                            ditch_eff = "27";
                        } else if (DitchEffectiveness.getSelectedItemPosition() == 3) {
                            ditch_eff = "81";
                        }

                        String rockfall_history = "3";
                        if (RockfallHistory.getSelectedItemPosition() == 1) {
                            rockfall_history = "9";
                        } else if (RockfallHistory.getSelectedItemPosition() == 2) {
                            rockfall_history = "27";
                        } else if (RockfallHistory.getSelectedItemPosition() == 3) {
                            rockfall_history = "81";
                        }

                        String block_size_event_vol = String.valueOf(BSVperEvent.getText());

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
                        String axial_los = String.valueOf(SlopeHeightCalc.getText()); //hr_slope_height_axial_length

                        String rockfall_related_maint_frequency = "3";
                        if (RockfallRMF.getSelectedItemPosition() == 1) {
                            rockfall_related_maint_frequency = "9";
                        } else if (RockfallRMF.getSelectedItemPosition() == 2) {
                            rockfall_related_maint_frequency = "27";
                        } else if (RockfallRMF.getSelectedItemPosition() == 3) {
                            rockfall_related_maint_frequency = "81";
                        }

                        //geo case 1
                        String case_one_struc_condition = "3";
                        if (StructuralCondition1.getSelectedItemPosition() == 1) {
                            case_one_struc_condition = "9";
                        } else if (StructuralCondition1.getSelectedItemPosition() == 2) {
                            case_one_struc_condition = "27";
                        } else if (StructuralCondition1.getSelectedItemPosition() == 3) {
                            case_one_struc_condition = "81";
                        }

                        String case_one_rock_friction = "3";
                        if (RockFriction1.getSelectedItemPosition() == 1) {
                            case_one_rock_friction = "9";
                        } else if (RockFriction1.getSelectedItemPosition() == 2) {
                            case_one_rock_friction = "27";
                        } else if (RockFriction1.getSelectedItemPosition() == 3) {
                            case_one_rock_friction = "81";
                        }

                        //geo case 2
                        String case_two_struc_condition = "3";
                        if (StructuralCondition2.getSelectedItemPosition() == 1) {
                            case_two_struc_condition = "9";
                        } else if (StructuralCondition2.getSelectedItemPosition() == 2) {
                            case_two_struc_condition = "27";
                        } else if (StructuralCondition2.getSelectedItemPosition() == 3) {
                            case_two_struc_condition = "81";
                        }

                        String case_two_diff_erosion = "3";
                        if (RockFriction2.getSelectedItemPosition() == 1) {
                            case_two_diff_erosion = "9";
                        } else if (RockFriction2.getSelectedItemPosition() == 2) {
                            case_two_diff_erosion = "27";
                        } else if (RockFriction2.getSelectedItemPosition() == 3) {
                            case_two_diff_erosion = "81";
                        }


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

                        //todo: hazard type (5) after aadt

                        writer.write("umbrella_agency=" + umbrella_agency + "&regional_admin=" + regional_admin + "&local_admin=" + local_admin + "&road_trail_number=" + road_trail_number + "&road_trail_class=" + road_trail_class +
                                "&begin_mile_marker=" + begin_mile_marker + "&end_mile_marker=" + end_mile_marker + "&road_or_trail=" + road_or_trail + "&side=" +
                                side + "&rater=" + l_rater + "&weather=" + weather + "&begin_coordinate_latitude=" + begin_coordinate_lat + "&begin_coordinate_longitude=" +
                                begin_coordinate_long + "&end_coordinate_latitude=" + end_coordinate_latitude + "&end_coordinate_longitude=" + end_coordinate_longitude +
                                "&datum=" + datum + "&aadt=" + aadt +"&hazard_type="+hazard_type+ "&length_affected=" + length_affected + "&slope_height_axial_length=" +
                                slope_height_axial_length + "&slope_angle=" + slope_angle + "&sight_distance=" + sight_distance + "&road_trail_width=" + road_trail_width +
                                "&speed_limit=" + speed_limit + "&minimum_ditch_width=" + minimum_ditch_width + "&maximum_ditch_width" + maximum_ditch_width +
                                "&minimum_ditch_depth=" + minimum_ditch_depth + "&maximum_ditch_depth=" + maximum_ditch_depth + "&first_begin_ditch_slope=" + first_begin_ditch_slope +
                                "&first_end_ditch_slope=" + first_end_ditch_slope + "&second_begin_ditch_slope=" + second_begin_ditch_slope + "&second_end_ditch_slope=" +
                                second_end_ditch_slope + "&start_annual_rainfall=" + start_annual_rainfall + "&end_annual_rainfall=" + end_annual_rainfall +
                                "&sole_access_route=" + sole_access_route + "&fixes_present=" + fixes_present + "&blk_size=" + blk_size + " &volume=" + volume + "&prelim_landslide_road_width_affected= &prelim_landslide_slide_erosion_effects= &prelim_landslide_slide_erosion_effects= " +
                                "&prelim_landslide_length_affected=" + length_affected + "&prelim_rockfall_ditch_eff=" + ditch_eff + "&prelim_rockfall_rockfall_history=" + rockfall_history +
                                "&prelim_rockfall_block_size_event_vol=" + block_size_event_vol + " &impact_on_use=" + impact_on_use + "&aadt_usage_calc_checkbox=" +
                                aadt_usage_calc_checkbox + "&aadt_usage=" + aadt_usage + "&prelim_rating=" + prelim_rating + "&slope_drainage=" +
                                slope_drainage + "&hazard_rating_annual_rainfall=" + annual_rainfall + "&hazard_rating_slope_height_axial_length=" + axial_los +
                                "&hazard_landslide_thaw_stability= &hazard_landslide_maint_frequency= &hazard_landslide_movement_history= " +
                                "&hazard_rockfall_maint_frequency=" + rockfall_related_maint_frequency + "&case_one_struc_cond=" + case_one_struc_condition + " &case_one_rock_friction=" + case_one_rock_friction + "&case_two_struc_condition=" + case_two_struc_condition + " &case_two_diff_erosion=" +
                                case_two_diff_erosion + "&route_trail_width=" + route_trail_width + "&human_ex_factor=" + human_ex_factor + "&percent_dsd=" + percent_dsd + "&r_w_impacts=" +
                                r_w_impacts + "&enviro_cult_impacts=" + enviro_cult_impacts + "&maint_complexity=" + maint_complexity + "&event_cost=" + event_cost +
                                "&hazard_rating_landslide_total=" + hazard_total + "&hazard_rating_rockfall_total= &risk_total=" + risk_total + "&total_score=" + total_score + "&comments=" +
                                comments + "&fmla_id=" + flma_id + "&fmla_name=" + flma_name + "&fmla_description=" + flma_description);

//                        //success message
//                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RockfallActivity.this);
//                        final TextView tv = new TextView(RockfallActivity.this);
//                        tv.setText("Form Submitted Successfully", TextView.BufferType.NORMAL);
//
//                        alertDialogBuilder.setView(tv);
//                        alertDialogBuilder.setCancelable(false).setPositiveButton("OK", new DialogInterface.OnClickListener() {
//                            public void onClick(DialogInterface dialog, int id) {
//                            }
//                        });
//
//                        // create alert dialog
//                        AlertDialog alertDialog = alertDialogBuilder.create();
//                        // show it
//                        alertDialog.show();
//                        //end success message


                        writer.flush();
                        String line;
                        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                        while ((line = reader.readLine()) != null) {
                            System.out.println(line);
                        }
                        writer.close();
                        reader.close();
                        uploadImage(); //here

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });

            thread.start();
        }

    }


    //add a new rockfall in the database
    public void newRockfall(View view){
        RockfallDBHandler dbHandler = new RockfallDBHandler(this, null, null, 1);
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
        //todo: hazard type (6)
        String temp = "";
        if(HazardType1.getSelectedItem().toString() != "") {
            temp = temp.concat(HazardType1.getSelectedItem().toString());
        }
        if(HazardType2.getSelectedItem().toString() != "") {
            temp = temp.concat(",");
            temp = temp.concat(HazardType2.getSelectedItem().toString());
        }
        if(HazardType3.getSelectedItem().toString() != "") {
            temp = temp.concat(",");
            temp = temp.concat(HazardType3.getSelectedItem().toString());
        }
        String hazard_type = temp;

        String begin_coordinate_lat = BeginLat.getText().toString();
        String begin_coordinate_long = BeginLong.getText().toString();
        String end_coordinate_latitude = EndLat.getText().toString();
        String end_coordinate_longitude = EndLong.getText().toString();
        String datum = Datum.getText().toString();
        String aadt = Aadt.getText().toString();
        String length_affected = LengthAffected.getText().toString();
        String slope_height_axial_length = SlopeHeight.getText().toString();
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
        String blk_size = BlkSize.getText().toString();
        String volume = Volume.getText().toString();
        String start_annual_rainfall =AnnualRain1.getText().toString();
        String end_annual_rainfall = AnnualRain2.getText().toString();
        int sole_access_route = SoleAccess.getSelectedItemPosition();
        int fixes_present = Mitigation.getSelectedItemPosition();

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

        String comments = Comments.getText().toString();
        String flma_name = FlmaName.getText().toString();
        String flma_id = FlmaId.getText().toString();
        String flma_description = FlmaDescription.getText().toString();
        
        //Preliminary Rating
            //Rockfall only
        int prelim_rockfall_ditch_eff=DitchEffectiveness.getSelectedItemPosition();
        int prelim_rockfall_rockfall_history = RockfallHistory.getSelectedItemPosition();
        String prelim_rockfall_block_size_event_vol = BSVperEvent.getText().toString();
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
        String hazard_rating_slope_height_axial_length = SlopeHeightCalc.getText().toString();
        String hazard_rating_total = HazardTotal.getText().toString();
            //rockfall only
        int hazard_rockfall_maint_frequency = RockfallRMF.getSelectedItemPosition();
        int case_one_struc_cond = StructuralCondition1.getSelectedItemPosition();
        int case_one_rock_friction = RockFriction1.getSelectedItemPosition();
        int case_two_struc_condition= StructuralCondition2.getSelectedItemPosition();
        int case_two_diff_erosion = RockFriction2.getSelectedItemPosition();

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


        Rockfall rockfall=new Rockfall(umbrella_agency,regional_admin,local_admin, date, road_trail_number,  road_or_trail,
         road_trail_class, rater,  begin_mile_marker,  end_mile_marker,
         side,  weather,  hazard_type,  begin_coordinate_lat,  begin_coordinate_long,
                 end_coordinate_latitude,  end_coordinate_longitude,  datum,  aadt, 
        length_affected,  slope_height_axial_length,  slope_angle,  sight_distance,
                 road_trail_width,  speed_limit,  minimum_ditch_width,  maximum_ditch_width,
                 minimum_ditch_depth,  maximum_ditch_Depth,  first_begin_ditch_slope,
        first_end_ditch_slope,  second_begin_ditch_slope,  second_end_ditch_slope, blk_size,
                 volume,  start_annual_rainfall,  end_annual_rainfall,  sole_access_route,  fixes_present,
         photos,  comments,  flma_name,  flma_id,  flma_description,  prelim_rockfall_ditch_eff,
         prelim_rockfall_rockfall_history,  prelim_rockfall_block_size_event_vol,  impact_on_use,
         aadt_usage_calc_checkbox,  aadt_usage,  prelim_rating,  slope_drainage,  hazard_rating_annual_rainfall,
                 hazard_rating_slope_height_axial_length,  hazard_rockfall_maint_frequency,  case_one_struc_cond,
         case_one_rock_friction,  case_two_struc_condition,  case_two_diff_erosion,  hazard_rating_total,
                 route_trail_width,  human_ex_factor,  percent_dsd,  r_w_impacts,  enviro_cult_impacts,
         maint_complexity,  event_cost,  risk_total,  total_score);
        

        dbHandler.addRockfall(rockfall);

        //clear out the fields
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
        HazardType1.setSelection(0);
        HazardType2.setSelection(0);
        HazardType3.setSelection(0);

        //HazardType.setText("");
        BeginLat.setText("");
        BeginLong.setText("");
        EndLat.setText("");
        EndLong.setText("");
        Datum.setText("");
        Aadt.setText("");
        LengthAffected.setText("");
        SlopeHeight.setText("");
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
        BlkSize.setText("");
        Volume.setText("");
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
            //rockfall only
        DitchEffectiveness.setSelection(0);
        RockfallHistory.setSelection(0);
        BSVperEvent.setText("");
        
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
        SlopeHeightCalc.setText("");
        HazardTotal.setText("");
            //rockfall only
        RockfallRMF.setSelection(0);
        StructuralCondition1.setSelection(0);
        RockFriction1.setSelection(0);
        StructuralCondition2.setSelection(0);
        RockFriction2.setSelection(0);

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

    //find a rockfall in the database
    public void lookupRockfall(int finder) {
        RockfallDBHandler dbHandler = new RockfallDBHandler(this, null, null, 1);

        Rockfall rockfall = dbHandler.findRockfall(finder); //fill how?

        //set everything
        if (rockfall != null) {
            Agency.setSelection(rockfall.getAgency());
            Regional.setSelection(rockfall.getRegional());
            Local.setSelection(rockfall.getLocal());
            Date.setText(rockfall.getDate());
            RoadTrailNo.setText(rockfall.getRoad_trail_number());
            RoadTrail.setSelection(rockfall.getRoad_or_Trail());
            RoadTrailClass.setText(rockfall.getRoad_trail_class());
            Rater.setText(rockfall.getRater());
            BeginMile.setText(rockfall.getBegin_mile_marker());
            EndMile.setText(rockfall.getEnd_mile_marker());
            Side.setSelection(rockfall.getSide());
            Weather.setSelection(rockfall.getWeather());
            //todo: hazard type (9)
            String hazardString = rockfall.getHazard_type();

            if(hazardString != "") {

                String [] hazards = hazardString.split(",");

                ArrayList<String> hazardTypeList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.HazardTypeRList)));

                    for (int i = 0; i < hazards.length; i++) {
                        if (i == 3) { //can't have more than 3
                            break;
                        }
                        //if it's in the list, set the spinner to it
                        if (hazardTypeList.contains(hazards[i])) {
                            if (i == 0) {
                                HazardType1.setSelection(hazardTypeList.indexOf(hazards[i]));
                            } else if (i == 1) {
                                HazardType2.setSelection(hazardTypeList.indexOf(hazards[i]));
                            } else {
                                HazardType3.setSelection(hazardTypeList.indexOf(hazards[i]));
                            }
                        }
                    }//end for
            }

            BeginLat.setText(rockfall.getBegin_coordinate_lat());
            BeginLong.setText(rockfall.getBegin_coordinate_long());
            EndLat.setText(rockfall.getEnd_coordinate_latitude());
            EndLong.setText(rockfall.getEnd_coordinate_longitude());
            Datum.setText(rockfall.getDatum());
            Aadt.setText(rockfall.getAadt());
            LengthAffected.setText(rockfall.getLength_affected());
            SlopeHeight.setText(rockfall.getSlope_height_axial_length());
            SlopeAngle.setText(rockfall.getSlope_angle());
            SightDistance.setText(rockfall.getSight_distance());
            RtWidth.setText(rockfall.getRoad_trail_width());
            Speed.setSelection(rockfall.getSpeed_limit());
            DitchWidth1.setText(rockfall.getMinimum_ditch_width());
            DitchWidth2.setText(rockfall.getMaximum_ditch_width());
            DitchDepth1.setText(rockfall.getMinimum_ditch_depth());
            DitchDepth2.setText(rockfall.getMaximum_ditch_depth());
            DitchSlope1.setText(rockfall.getFirst_begin_ditch_slope());
            DitchSlope2.setText(rockfall.getFirst_end_ditch_slope());
            DitchSlope3.setText(rockfall.getSecond_begin_ditch_slope());
            DitchSlope4.setText(rockfall.getSecond_end_ditch_slope());
            BlkSize.setText(rockfall.getBlk_size());
            Volume.setText(rockfall.getVolume());
            AnnualRain1.setText(rockfall.getStart_annual_rainfall());
            AnnualRain2.setText(rockfall.getEnd_annual_rainfall());
            SoleAccess.setSelection(rockfall.getSole_access_route());
            Mitigation.setSelection(rockfall.getFixes_Present());
            //photos
            String tempPhoto = rockfall.getphotos();
            savedImagePaths = tempPhoto.split(",");

            Comments.setText(rockfall.getComments());
            FlmaName.setText(rockfall.getFlma_name());
            FlmaId.setText(rockfall.getFlma_id());
            FlmaDescription.setText(rockfall.getFlma_description());

            //preliminary rating
                //rockfall only
            DitchEffectiveness.setSelection(rockfall.getPrelim_rockfall_ditch_eff());
            RockfallHistory.setSelection(rockfall.getPrelim_rockfall_rockfall_history());
            BSVperEvent.setText(rockfall.getPrelim_rockfall_block_size_event_vol());
            //for all
            ImpactOU.setSelection(rockfall.getImpact_on_use());

            if (rockfall.getAadt_usage_calc_checkbox() == 1 && !CheckAadt.isChecked()) {
                CheckAadt.toggle();
            } else if (rockfall.getAadt_usage_calc_checkbox() == 0 && CheckAadt.isChecked()) {
                CheckAadt.toggle();
                ;
            }

            AadtEtc.setText(rockfall.getAadt_usage());
            PrelimRating.setText(rockfall.getPrelim_rating());

            //Hazard Rating
                //for all
            SlopeDrainage.setSelection(rockfall.getSlope_drainage());
            AnnualRainfall.setText(rockfall.getHazard_rating_annual_rainfall());
            SlopeHeightCalc.setText(rockfall.getHazard_rating_slope_height_axial_length());
            HazardTotal.setText(rockfall.getHazard_rating_total());
                //rockfall only
            RockfallRMF.setSelection(rockfall.getHazard_rockfall_maint_frequency());
            StructuralCondition1.setSelection(rockfall.getCase_one_struc_cond());
            RockFriction1.setSelection(rockfall.getCase_one_rock_friction());
            StructuralCondition2.setSelection(rockfall.getCase_two_struc_cond());
            RockFriction2.setSelection(rockfall.getCase_two_diff_erosion());

            //Risk Ratings
            RouteTW.setText(rockfall.getRoute_trail_width());
            HumanEF.setText(rockfall.getHuman_ex_factor());
            PercentDSD.setText(rockfall.getPercent_dsd());
            RightOWI.setSelection(rockfall.getR_w_impacts());
            ECImpact.setSelection(rockfall.getEnviro_cult_impacts());
            MaintComplexity.setSelection(rockfall.getMaint_complexity());
            EventCost.setSelection(rockfall.getEvent_cost());
            RiskTotal.setText(rockfall.getRisk_total());

            Total.setText(rockfall.getTotal_score());

            if(OfflineList.should_submit==true){
                OfflineList.should_submit=false;
                //submit button perform click...
                SubmitButton.performClick();

            }
        } else {
            Comments.setText("No Match Found"); //or something else....
        }
    }

    //LOAD FROM OFFLINE SITES
    public void loadFromOffline() {
        String offline_clicked = getIntent().getStringExtra("offline");
        OfflineSiteDBHandler dbHandler = new OfflineSiteDBHandler(this, null, null, 1);
        int[] ids = dbHandler.getIds();
        for (int i = 0; i < ids.length; i++) {
            OfflineSite offlineSite = new OfflineSite();
            offlineSite = dbHandler.findOfflineSite(ids[i]);
            if (offlineSite.getSite_id().equals(offline_clicked)) {

                //FILL IN THE FORM
                int agency = offlineSite.getAgency();
                Agency.setSelection(agency);

                int regional = offlineSite.getRegional();
                Regional.setSelection(regional);

                int local = offlineSite.getLocal();
                Local.setSelection(local);

                Date.setText(offlineSite.getDate());
                RoadTrailNo.setText(offlineSite.getRoad_trail_number());

                int road_trail = offlineSite.getRoad_or_Trail();
                RoadTrail.setSelection(road_trail);

                RoadTrailClass.setText(offlineSite.getRoad_trail_class());
                Rater.setText(offlineSite.getRater());
                BeginMile.setText(offlineSite.getBegin_mile_marker());
                EndMile.setText(offlineSite.getEnd_mile_marker());

                Side.setSelection(offlineSite.getSide());

                Weather.setSelection(offlineSite.getWeather());

                //todo: hazard type (10)
                String hazardString = offlineSite.getHazard_type();


                    String [] hazards = hazardString.split(",");

                    ArrayList<String> hazardTypeList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.HazardTypeRList)));


                    for(int j = 0; j<hazards.length; j++){
                        if(j==3){ //can't have more than 3
                            break;
                        }
                        //if it's in the list, set the spinner to it
                        if(hazardTypeList.contains(hazards[j])){
                            if(j == 0){
                                HazardType1.setSelection(hazardTypeList.indexOf(hazards[j]));
                            }else if(j == 1){
                                HazardType2.setSelection(hazardTypeList.indexOf(hazards[j]));
                            }else{
                                HazardType3.setSelection(hazardTypeList.indexOf(hazards[j]));
                            }
                        }
                    }



                BeginLat.setText(offlineSite.getBegin_coordinate_lat());
                EndLat.setText(offlineSite.getEnd_coordinate_latitude());
                BeginLong.setText(offlineSite.getEnd_coordinate_longitude());
                EndLong.setText(offlineSite.getEnd_coordinate_longitude());
                Datum.setText(offlineSite.getDatum());
                Aadt.setText(offlineSite.getAadt());
                LengthAffected.setText(offlineSite.getLength_affected());
                SlopeHeight.setText(offlineSite.getSlope_height_axial_length());
                SlopeAngle.setText(offlineSite.getSlope_angle());
                SightDistance.setText(offlineSite.getSight_distance());
                RtWidth.setText(offlineSite.getRoad_trail_width());
                //speed limit?
                DitchWidth1.setText(offlineSite.getMinimum_ditch_width());
                DitchWidth2.setText(offlineSite.getMaximum_ditch_width());
                DitchDepth1.setText(offlineSite.getMinimum_ditch_depth());
                DitchDepth2.setText(offlineSite.getMaximum_ditch_depth());
                DitchSlope1.setText(offlineSite.getFirst_begin_ditch_slope());
                DitchSlope2.setText(offlineSite.getFirst_end_ditch_slope());
                DitchSlope3.setText(offlineSite.getSecond_begin_ditch_slope());
                DitchSlope4.setText(offlineSite.getSecond_end_ditch_slope());
                BlkSize.setText(offlineSite.getBlk_size());
                Volume.setText(offlineSite.getVolume());
                AnnualRain1.setText(offlineSite.getStart_annual_rainfall());
                AnnualRain2.setText(offlineSite.getEnd_annual_rainfall());

                int sole_access_route = offlineSite.getSole_access_route();
                SoleAccess.setSelection(sole_access_route);

                int mitigation_present = offlineSite.getFixes_Present();
                Mitigation.setSelection(mitigation_present);

                //photos

                Comments.setText(offlineSite.getComments());
                FlmaName.setText(offlineSite.getFlma_name());
                FlmaId.setText(offlineSite.getFlma_id());
                FlmaDescription.setText(offlineSite.getFlma_description());

                //PRELIMINARY RATINGS
                //rockall only

                ArrayList<String> ratingList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.ratingList)));
                ArrayList<String> zeroList = new ArrayList<String>(Arrays.asList(getResources().getStringArray(R.array.zeroRatingList)));


                String ditchEffectiveness = String.valueOf(offlineSite.getPrelim_rockfall_ditch_eff());

                if (ratingList.contains(ditchEffectiveness)) {
                    DitchEffectiveness.setSelection(ratingList.indexOf(ditchEffectiveness));
                }

                String rockfallHistory = String.valueOf(offlineSite.getPrelim_rockfall_rockfall_history());
                if (ratingList.contains(rockfallHistory)) {
                    RockfallHistory.setSelection(ratingList.indexOf(rockfallHistory));
                }

                BSVperEvent.setText(offlineSite.getPrelim_rockfall_block_size_event_vol());

                //all
                String impact_on_use = String.valueOf(offlineSite.getImpact_on_use());
                if(ratingList.contains(impact_on_use)){
                    ImpactOU.setSelection(ratingList.indexOf(impact_on_use));
                }

                int checkmark = offlineSite.getAadt_usage_calc_checkbox();
                //0 false, 1 true?
                if (checkmark == 1) {
                    CheckAadt.setSelected(true);
                } else {
                    CheckAadt.setSelected(false);
                }

                AadtEtc.setText(offlineSite.getAadt_usage());
                PrelimRating.setText(offlineSite.getPrelim_rating());

                //SLOPE HAZARD RATINGS
                //all

                String slopeDrainage = String.valueOf(offlineSite.getSlope_drainage());
                if (ratingList.contains(slopeDrainage)) {
                    SlopeDrainage.setSelection(ratingList.indexOf(slopeDrainage));
                }
                AnnualRainfall.setText(offlineSite.getHazard_rating_annual_rainfall());
                SlopeHeightCalc.setText(offlineSite.getHazard_rating_slope_height_axial_length());

                String rockfallRMF = String.valueOf(offlineSite.getHazard_rockfall_maint_frequency());
                if (ratingList.contains(rockfallRMF)) {
                    RockfallRMF.setSelection(ratingList.indexOf(rockfallRMF));
                }

                //zero list stuff
                String struc1 = String.valueOf(offlineSite.getCase_one_struc_cond());
                if (zeroList.contains(struc1)) {
                    StructuralCondition1.setSelection(zeroList.indexOf(struc1));
                }

                String rock1 = String.valueOf(offlineSite.getCase_one_rock_friction());
                if (zeroList.contains(rock1)) {
                    RockFriction1.setSelection(zeroList.indexOf(rock1));
                }

                String struc2 = String.valueOf(offlineSite.getCase_two_struc_cond());
                if (zeroList.contains(struc2)) {
                    StructuralCondition2.setSelection(zeroList.indexOf(struc2));
                }

                String rock2 = String.valueOf(offlineSite.getCase_two_diff_erosion());
                if (zeroList.contains(rock2)) {
                    RockFriction2.setSelection(zeroList.indexOf(rock2));
                }

                HazardTotal.setText(offlineSite.getHazard_rating_total());

                //RISK RATINGS-ALL
                RouteTW.setText(offlineSite.getRoute_trail_width());
                HumanEF.setText(offlineSite.getHuman_ex_factor());
                PercentDSD.setText(offlineSite.getPercent_dsd());

                String rowImpacts = String.valueOf(offlineSite.getR_w_impacts());
                if (ratingList.contains(rowImpacts)) {
                    RightOWI.setSelection(ratingList.indexOf(rowImpacts));
                }

                String ecImpacts = String.valueOf(offlineSite.getEnviro_cult_impacts());
                if (ratingList.contains(ecImpacts)) {
                    ECImpact.setSelection(ratingList.indexOf(ecImpacts));
                }

                String maintComplexity = String.valueOf(offlineSite.getMaint_complexity());
                if (ratingList.contains(maintComplexity)) {
                    MaintComplexity.setSelection(ratingList.indexOf(maintComplexity));
                }

                String eventCost = String.valueOf(offlineSite.getEvent_cost());
                if (ratingList.contains(eventCost)) {
                    EventCost.setSelection(ratingList.indexOf(eventCost));
                }

                RiskTotal.setText(offlineSite.getRisk_total());

                Total.setText(offlineSite.getTotal_score());

                break;
            }
        }

    }

    //Image picker
    //CREDITS(4)
    public void chooseImages(View view) {
        Intent intent = new Intent(this, AlbumSelectActivity.class);
        intent.putExtra(Constants.INTENT_EXTRA_LIMIT, 10);
        startActivityForResult(intent, Constants.REQUEST_CODE);

    }

    //CREDITS(4)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constants.REQUEST_CODE && resultCode == RESULT_OK && data != null) {
            selectedImages = data.getParcelableArrayListExtra(Constants.INTENT_EXTRA_IMAGES);
            StringBuffer stringBuffer = new StringBuffer();
            for (int i = 0, l = selectedImages.size(); i < l; i++) {
                stringBuffer.append(selectedImages.get(i).path + "\n");
            }
            System.out.println(stringBuffer.toString());
        }

        imageUri = Uri.fromFile(new File(selectedImages.get(0).path));


    }

    //view images you have chosen
    public void viewChosen(View view){
        System.out.println(imageUri);
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

        //if you have chosen an image
        if(selectedImages != null) {
            ScrollView scroller = new ScrollView(this);
            LinearLayout ll = new LinearLayout(this);

            for (int i = 0; i < selectedImages.size(); i++) {
                Uri currentImage =  Uri.fromFile(new File(selectedImages.get(i).path));
                ImageView imageView = new ImageView(this);
                imageView.setImageURI(currentImage);
                ll.addView(imageView);
            }
            scroller.addView(ll);
            builder.addContentView(scroller, new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            builder.show();

        }
        //else if you are loading images from a site saved offline
        else if(savedImagePaths != null){
            ScrollView scroller = new ScrollView(this);
            LinearLayout ll = new LinearLayout(this);

            for (int i = 0; i < savedImagePaths.length; i++) {
                Uri currentImage =  Uri.fromFile(new File(savedImagePaths[i]));
                ImageView imageView = new ImageView(this);
                imageView.setImageURI(currentImage);
                ll.addView(imageView);
            }
            scroller.addView(ll);
            builder.addContentView(scroller, new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            builder.show();

        }
    }

    //CREDITS(5)
    //upload image
    public void uploadImage() throws  Exception {
        class Run extends AsyncTask<String, Void, String> {

            @Override
            protected String doInBackground(String... params) {

                try {

                    if(selectedImages.size() != 0){
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
                                    .url("http://nl.cs.montana.edu/usmp/server/new_site_php/add_new_site.php")
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

    //CREDITS(3)
    //compress image size
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


