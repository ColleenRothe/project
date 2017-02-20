package teammsu.colleenrothe.usmp;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.pdf.PdfRenderer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.ParcelFileDescriptor;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;


import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

public class manualActivity extends AppCompatActivity {

    private ImageView img;
    private int currentpage = 0;
    private Button next, previous;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manual);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);


        next = (Button) findViewById(R.id.next);
        previous = (Button) findViewById(R.id.previous);


        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(manualActivity.this, "NEXT", Toast.LENGTH_SHORT).show();
                currentpage++;
                render();
            }
        });


        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(manualActivity.this, "PREVIOUS", Toast.LENGTH_SHORT).show();
                currentpage--;
                render();
            }
        });




    }


    private void render() {

        try {
            Toast.makeText(manualActivity.this, "TRY RENDER", Toast.LENGTH_SHORT).show();

            img = (ImageView) findViewById(R.id.image);

            int width = img.getWidth();
            int height = img.getHeight();

            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_4444);

            File file = new File(getFilesDir(), "ratingmanual.pdf");  //Add your own PDF file path which you
            //Uploaded in assets folder.

            if(file.exists()){
                Toast.makeText(manualActivity.this, "EXISTS 1 ", Toast.LENGTH_SHORT).show();
            }
            else{
                Toast.makeText(manualActivity.this, "NOT EXISTS 1 ", Toast.LENGTH_SHORT).show();

            }
            PdfRenderer renderer = new PdfRenderer(ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY));

            if(currentpage<0){
                currentpage =0;

            }else if(currentpage>renderer.getPageCount()){


                currentpage = renderer.getPageCount() -1;

                Matrix matrix = img.getImageMatrix();

                Rect rect = new Rect(0,0, width , height);

                renderer.openPage(currentpage).render(bitmap,rect,matrix , PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY );

                img.setImageMatrix(matrix);
                img.setImageBitmap(bitmap);
                img.invalidate();

            }


        } catch (Exception e) {

            e.printStackTrace();

        }

    }




//    public void go() throws IOException {
//        File file = new File(getFilesDir(), "ratingmanual.pdf");
//        if (file.exists()) {
//            //Toast.makeText(manualActivity.this, "EXISTS 1 ", Toast.LENGTH_SHORT).show();
//
//        } else {
//            //Toast.makeText(manualActivity.this, "NOT EXISTS 1 ", Toast.LENGTH_SHORT).show();
//
//        }
//        AssetManager assetManager = getAssets();
////        String [] files = assetManager.list("");
////        for (int i = 0; i< files.length; i++){
////            if(files[i].equals("ratingmanual.pdf")){
////                Toast.makeText(manualActivity.this, "It's here " , Toast.LENGTH_SHORT).show();
////            }
////        }
//        InputStream in = null;
//
//        in = assetManager.open("ratingmanual.pdf");
//        InputStreamReader isr = new InputStreamReader(in);
//
//        BufferedReader br = new BufferedReader(isr, 8192);
//        try {
//            String test = br.readLine();
//            if (test == null) {
//                Toast.makeText(manualActivity.this, "NOT EXISTS 1 ", Toast.LENGTH_SHORT).show();
//            } else {
//                Toast.makeText(manualActivity.this, "TEST" + test, Toast.LENGTH_SHORT).show();
//
//            }
//
//
//            isr.close();
//            in.close();
//            br.close();
//        }catch(IOException e){
//            e.printStackTrace();
//        }
//
//
//        //Toast.makeText(manualActivity.this, "AVAILABLE " + in.available(), Toast.LENGTH_SHORT).show();
//        //Toast.makeText(manualActivity.this, "READ " + in.read(), Toast.LENGTH_SHORT).show();
//
//
//
//
//
//
//    }
//
//    //http://stackoverflow.com/questions/24129719/android-cant-find-file-in-assets-folder
//    //http://asmncl.blogspot.in/2012/06/android-open-pdf-file-in-webview.html
//    private void CopyReadAssets() {
//        AssetManager assetManager = getAssets();
//
//        InputStream in = null;
//        OutputStream out = null;
//        File file = new File(getFilesDir(), "ratingmanual.pdf");
//        try {
//            in = assetManager.open("ratingmanual.pdf");
//            out = openFileOutput(file.getName(), Context.MODE_WORLD_READABLE);
//
//            copyFile(in, out);
//            in.close();
//            in = null;
//            out.flush();
//            out.close();
//            out = null;
//        } catch (Exception e) {
//            Log.e("tag", e.getMessage());
//        }
//
//        Intent intent = new Intent(Intent.ACTION_VIEW);
//        intent.setDataAndType(
//                Uri.parse("file://" + getFilesDir() + "/ratingmanual.pdf"),
//                "application/pdf");
//
//        startActivity(intent);
//    }
//
//    private void copyFile(InputStream in, OutputStream out) throws IOException {
//        byte[] buffer = new byte[1024];
//        int read;
//        while ((read = in.read(buffer)) != -1) {
//            out.write(buffer, 0, read);
//        }
//    }
//

//    public void render(){
//
//        File fileBrochure = new File(getFilesDir(), "/ratingmanual.pdf");
//        if (!fileBrochure.exists())
//        {
//            CopyAssetsbrochure();
//        }
//
//        /** PDF reader code */
//        File file = new File(getFilesDir(), "/ratingmanual.pdf");
//
//        Intent intent = new Intent(Intent.ACTION_VIEW);
//        intent.setDataAndType(Uri.fromFile(file),"application/pdf");
//        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        try
//        {
//            getApplicationContext().startActivity(intent);
//        }
//        catch (ActivityNotFoundException e)
//        {
//            Toast.makeText(manualActivity.this, "NO Pdf Viewer", Toast.LENGTH_SHORT).show();
//        }
//    }
//    private void CopyAssetsbrochure() {
//        AssetManager assetManager = getAssets();
//        String[] files = null;
//        try
//        {
//            files = assetManager.list("");
//        }
//        catch (IOException e){}
//        for(int i=0; i<files.length; i++)
//        {
//            String fStr = files[i];
//            if(fStr.equalsIgnoreCase("RatingManual.pdf"))
//            {
//                InputStream in = null;
//                OutputStream out = null;
//                try
//                {
//                    in = assetManager.open(files[i]);
//                    out = new FileOutputStream("/sdcard/" + files[i]);
//                    copyFile(in, out);
//                    in.close();
//                    in = null;
//                    out.flush();
//                    out.close();
//                    out = null;
//                    break;
//                }
//                catch(Exception e){}
//            }
//        }
//    }
//
//    private void copyFile(InputStream in, OutputStream out) throws IOException
//    {
//        byte[] buffer = new byte[1024];
//        int read;
//        while((read = in.read(buffer)) != -1){
//            out.write(buffer, 0, read);
//        }
//    }


//    private void render() throws IOException {
//        System.out.println("RENDER");
//
//
//            //File file = new File("/Users/colleenrothe/AndroidStudioProjects/USMP/app/src/main/assets/RatingManual.pdf");
////            String path = "/Users/colleenrothe/AndroidStudioProjects/USMP/app/src/main/assets/RatingManual.pdf";
////            String base = "/Users/colleenrothe/AndroidStudioProjects/USMP/app/src/main/java/com/example/colleenrothe/usmp/manualActivity.java";
////            String relative = new File(base).toURI().relativize(new File(path).toURI()).getPath();
//            AssetManager am = getAssets();
//            String filePath = this.getFilesDir() + File.separator + "RatingManual.pdf";
//            File destinationFile = new File(filePath);
//
//
//            InputStream inputStream = am.open("RatingManual.pdf");
//            FileOutputStream outputStream = new FileOutputStream(destinationFile);
//            byte [] buffer = new byte[1024];
//            int length = 0;
//            while ((length = inputStream.read(buffer)) != -1){
//                outputStream.write(buffer,0,length);
//            }
//        outputStream.close();
//        inputStream.close();;
//
//        if (destinationFile.exists()) {
//            Uri path = Uri.fromFile(destinationFile);
//            Intent intent = new Intent(Intent.ACTION_VIEW);
//            intent.setDataAndType(path, "application/pdf");
//            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//
//            try {
//                startActivity(intent);
//            } catch (ActivityNotFoundException e) {
//                Toast.makeText(manualActivity.this,
//                        "No Application Available to View PDF",
//                        Toast.LENGTH_SHORT).show();
//            }
//        }
//
//            //File file = createFileFromInputStream(inputStream);
//
//            //File file = new File("/sdcard/RatingManual.pdf");
//
//        //usmp/app/src/main/assets/RatingManual.pdf
//
//    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        switch (id) {
            case R.id.action_home:
                System.out.println("HOME");
                Intent intent = new Intent(this, MainActivity.class);
                startActivity(intent);
                break;

        }
        return true;

    }



}
