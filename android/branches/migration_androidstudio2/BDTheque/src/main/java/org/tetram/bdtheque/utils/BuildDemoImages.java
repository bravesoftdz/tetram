package org.tetram.bdtheque.utils;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class BuildDemoImages extends AsyncTask<Void, Void, Void> {

    private ProgressDialog progress;
    private final List<Field> drawables = new ArrayList<>();
    private String externalDir;
    private final Context context;
    private boolean alreadyDone;

    public BuildDemoImages(Context context) {
        super();
        this.context = context;
    }

    @Nullable
    @Override
    protected Void doInBackground(Void... params) {
        if (!this.alreadyDone) {
            for (int i = 0, drawablesSize = this.drawables.size(); i < drawablesSize; i++) {
                Field field = this.drawables.get(i);
                String fieldName = field.getName();
                this.progress.setProgress(i);
                int drawableId = this.context.getResources().getIdentifier(fieldName, "drawable", this.context.getPackageName());
                Bitmap bm = BitmapFactory.decodeResource(this.context.getResources(), drawableId);
                File file = new File(this.externalDir, fieldName);
                FileOutputStream outStream;
                try {
                    outStream = new FileOutputStream(file);
                    try {
                        bm.compress(Bitmap.CompressFormat.PNG, 100, outStream);
                        outStream.flush();
                    } finally {
                        outStream.close();
                    }
                } catch (FileNotFoundException ignored) {
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    @Override
    protected void onPostExecute(Void result) {
        if (!this.alreadyDone) {
            Log.i(getClass().getName(), this.context.getString(org.tetram.bdtheque.R.string.msg_loading_demo_data_done));
            SharedPreferences prefs = this.context.getSharedPreferences("demo", Context.MODE_PRIVATE);
            prefs.edit().putBoolean("imageBuild", true).commit();
            this.progress.cancel();
        }
        super.onPostExecute(result);
    }

    @Override
    protected void onPreExecute() {
        SharedPreferences prefs = this.context.getSharedPreferences("demo", Context.MODE_PRIVATE);
        this.alreadyDone = prefs.getBoolean("imageBuild", false);

        if (!this.alreadyDone) {
            for (Field field : R.drawable.class.getFields()) {
                String fieldName = field.getName();
                if (fieldName.startsWith("demo_img_") /*&& fieldName.endsWith(".jpg")*/)
                    this.drawables.add(field);
            }

            this.progress = new ProgressDialog(this.context);
            this.progress.setTitle(this.context.getString(org.tetram.bdtheque.R.string.msg_loading_demo_data));
            this.progress.setMessage(this.context.getString(org.tetram.bdtheque.R.string.msg_chargement));
            this.progress.setIndeterminate(false);
            this.progress.setCancelable(false);
            this.progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            this.progress.setMax(this.drawables.size());
            this.progress.setProgress(0);
            this.progress.show();

            this.externalDir = this.context.getExternalFilesDir(Environment.DIRECTORY_PICTURES).toString();
        }
        super.onPreExecute();
    }
}
