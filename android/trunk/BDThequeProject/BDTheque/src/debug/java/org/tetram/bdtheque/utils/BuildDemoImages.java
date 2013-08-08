package org.tetram.bdtheque.utils;

import android.app.ProgressDialog;
import android.content.Context;
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

public class BuildDemoImages extends AsyncTask<Void, Void, Void> {

    private ProgressDialog progress;
    private Field[] drawables;
    private String externalDir;
    private final Context context;

    public BuildDemoImages(Context context) {
        super();
        this.context = context;
    }

    @Nullable
    @Override
    protected Void doInBackground(Void... params) {
        int drawablesLength = this.drawables.length;

        for (int i = 0; i < drawablesLength; i++) {
            this.progress.setProgress(i);
            Field field = this.drawables[i];
            String fieldName = field.getName();
            if (fieldName.startsWith("demo_img_") /*&& fieldName.endsWith(".jpg")*/) {
                int drawableId = this.context.getResources().getIdentifier(fieldName, "drawable", this.context.getPackageName());
                Bitmap bm = BitmapFactory.decodeResource(this.context.getResources(), drawableId);
                File file = new File(this.externalDir, fieldName);
                FileOutputStream outStream = null;
                try {
                    outStream = new FileOutputStream(file);
                    try {
                        bm.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
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
        Log.i(getClass().getName(), this.context.getString(org.tetram.bdtheque.R.string.msg_loading_demo_data_done));
        this.progress.cancel();
        super.onPostExecute(result);
    }

    @Override
    protected void onPreExecute() {
        this.drawables = R.drawable.class.getFields();

        this.progress = new ProgressDialog(this.context);
        this.progress.setTitle(this.context.getString(org.tetram.bdtheque.R.string.msg_loading_demo_data));
        this.progress.setMessage(this.context.getString(org.tetram.bdtheque.R.string.msg_chargement));
        this.progress.setIndeterminate(false);
        this.progress.setCancelable(false);
        this.progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        this.progress.setMax(this.drawables.length);
        this.progress.setProgress(0);
        this.progress.show();

        this.externalDir = this.context.getExternalFilesDir(Environment.DIRECTORY_PICTURES).toString();
        super.onPreExecute();
    }
}
