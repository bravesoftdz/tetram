package org.tetram.bdtheque.gui.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BuildConfig;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.gui.activities.ImageActivity;

import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

public class ImageFragment extends Fragment {

    private int currentImage;
    private View view;
    private List<ImageBean> imagesList;
    private ImageView imageView;

    public static ImageFragment getFragment(List<ImageBean> images, boolean clickable) {
        Bundle args = new Bundle();
        args.putBoolean("clickable", clickable);
        args.putParcelableArrayList("images", (ArrayList<? extends Parcelable>) images);

        ImageFragment imageFragment = new ImageFragment();
        imageFragment.setArguments(args);

        return imageFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        this.view = inflater.inflate(R.layout.fiche_image_fragment, container, false);

        this.imageView = (ImageView) this.view.findViewById(R.id.image_image);

        this.view.findViewById(R.id.image_btn_prev).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showImage(ImageFragment.this.currentImage - 1);
            }
        });
        this.view.findViewById(R.id.image_btn_next).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showImage(ImageFragment.this.currentImage + 1);
            }
        });

        if (getArguments() != null) {
            List<ImageBean> images = getArguments().getParcelableArrayList("images");
            if (images != null) setImagesList(images);

            if (getArguments().getBoolean("clickable", false))
                this.imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent intent = new Intent();
                        intent.setClass(getActivity(), ImageActivity.class);
                        intent.putParcelableArrayListExtra("images", (ArrayList<? extends Parcelable>) ImageFragment.this.imagesList);
                        startActivity(intent);
                    }
                });
        }

        // ne sert pas à grand chose puisque j'ai pas trouvé d'autre solution que de recréer le fragment à chaque fois
        if (savedInstanceState != null) {
            this.currentImage = savedInstanceState.getInt("currentImage");
            showImage(this.currentImage);
        }

        return this.view;
    }

    private void showImage(int i) {
        this.currentImage = i;
        if (this.currentImage < 0) this.currentImage = this.imagesList.size() - 1;
        if (this.currentImage >= this.imagesList.size()) this.currentImage = 0;

        ImageBean imageBean = this.imagesList.get(this.currentImage);
        setUIElement(this.view, R.id.image_type_image, imageBean.getCategorieImage().getLibelle());

        if (BuildConfig.DEBUG) {
            String fileName = "img_" + imageBean.getId().toString().toLowerCase().replaceAll("-", "_");
            int resID = getResources().getIdentifier(fileName, "drawable", getActivity().getPackageName());
            this.imageView.setImageResource(resID);
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("currentImage", this.currentImage);
    }

    @Override
    public void onViewStateRestored(Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
        if (savedInstanceState != null) {
            this.currentImage = savedInstanceState.getInt("currentImage");
            showImage(this.currentImage);
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    public List<ImageBean> getImagesList() {
        return this.imagesList;
    }

    public void setImagesList(List<ImageBean> imagesList) {
        this.imagesList = imagesList;
        showImage(this.currentImage);
    }
}
