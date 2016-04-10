package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.widget.LinearLayout;

import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.gui.fragments.ImageFragment;

import java.util.ArrayList;

public class ImageActivity extends FragmentActivity implements ImageFragment.OnPageChangeListener {

    private int currentImage;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout view = new LinearLayout(this);
        view.setId(android.R.id.content);
        setContentView(view);

        getActionBar().hide();

        ArrayList<ImageBean> images = getIntent().getParcelableArrayListExtra(ImageFragment.IMAGE_FRAGMENT_IMAGES);
        this.currentImage = getIntent().getIntExtra(ImageFragment.IMAGE_FRAGMENT_POSITION, 0);
        if (savedInstanceState != null)
            this.currentImage = savedInstanceState.getInt(ImageFragment.IMAGE_FRAGMENT_POSITION, this.currentImage);

        ImageFragment fragment = ImageFragment.getFragment(images, this.currentImage, false);
        fragment.setPageChangeListener(this);
        getSupportFragmentManager()
                .beginTransaction()
                .replace(android.R.id.content, fragment)
                .commit();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        outState.putInt(ImageFragment.IMAGE_FRAGMENT_POSITION, this.currentImage);
        super.onSaveInstanceState(outState);
    }

    @Override
    public void finish() {
        Intent data = new Intent();
        data.putExtra(ImageFragment.IMAGE_FRAGMENT_POSITION, this.currentImage);
        if (getParent() == null) {
            setResult(Activity.RESULT_OK, data);
        } else {
            getParent().setResult(Activity.RESULT_OK, data);
        }
        super.finish();
    }

    @Override
    public void onPageSelected(int position) {
        this.currentImage = position;
    }
}