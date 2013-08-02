package org.tetram.bdtheque.gui.activities;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.widget.LinearLayout;

import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.gui.fragments.ImageFragment;

import java.util.ArrayList;

public class ImageActivity extends FragmentActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout view = new LinearLayout(this);
        view.setId(android.R.id.content);
        setContentView(view);

        ArrayList<ImageBean> images = getIntent().getParcelableArrayListExtra("images");

        getSupportFragmentManager().beginTransaction().add(android.R.id.content, ImageFragment.getFragment(images, false)).commit();
    }
}