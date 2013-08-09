package org.tetram.bdtheque.gui.fragments;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Environment;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.SimpleImageLoadingListener;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BuildConfig;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.gui.activities.ImageActivity;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

public class ImageFragment extends Fragment {

    private int currentImage;
    private View view;
    private List<ImageBean> imagesList;
    private ImageView imageView;
    private boolean clickable;

    public static ImageFragment getFragment(List<ImageBean> images, int currentImage, boolean clickable) {
        Bundle args = new Bundle();
        args.putBoolean("clickable", clickable);
        args.putParcelableArrayList("images", (ArrayList<? extends Parcelable>) images);
        args.putInt("currentImage", currentImage);

        ImageFragment imageFragment = new ImageFragment();
        imageFragment.setArguments(args);

        return imageFragment;
    }

    private static final String STATE_POSITION = "STATE_POSITION";

    protected ImageLoader imageLoader = ImageLoader.getInstance();
    DisplayImageOptions options;
    ViewPager pager;

    /*
                // Special cases
			"http://cdn.urbanislandz.com/wp-content/uploads/2011/10/MMSposter-large.jpg", // very large image
			"file:///sdcard/Universal Image Loader @#&=+-_.,!()~'%20.png", // Image from SD card with encoded symbols
			"assets://Living Things @#&=+-_.,!()~'%20.jpg", // Image from assets
			"drawable://" + R.drawable.ic_launcher, // Image from drawables

     */

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        this.view = inflater.inflate(R.layout.fiche_image_fragment, container, false);

        if (getArguments() != null) {
            this.imagesList = getArguments().getParcelableArrayList("images");
            this.currentImage = getArguments().getInt("currentImage", 0);
            this.clickable = getArguments().getBoolean("clickable", false);
        }

        if (savedInstanceState != null) {
            this.currentImage = savedInstanceState.getInt(STATE_POSITION);
        }

        this.options = new DisplayImageOptions.Builder()
                .showImageForEmptyUri(R.drawable.ic_empty)
                .showImageOnFail(R.drawable.ic_error)
                .resetViewBeforeLoading(true)
                .cacheOnDisc(true)
                .imageScaleType(ImageScaleType.EXACTLY)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .displayer(new FadeInBitmapDisplayer(300))
                .build();

        this.pager = (ViewPager) this.view.findViewById(R.id.pager);
        this.pager.setAdapter(new ImagePagerAdapter(this.imagesList, this.clickable));
        this.pager.setCurrentItem(this.currentImage);

        return this.view;
    }

    private void showImage(int i) {
        this.currentImage = i;
        if (this.currentImage < 0) this.currentImage = this.imagesList.size() - 1;
        if (this.currentImage >= this.imagesList.size()) this.currentImage = 0;

        // s'il y a plusieurs editions, certaines n'ont peut etre pas d'images
        if (!this.imagesList.isEmpty()) {
            ImageBean imageBean = this.imagesList.get(this.currentImage);
            setUIElement(this.view, R.id.image_type_image, imageBean.getCategorieImage().getLibelle());

            if (BuildConfig.DEBUG) {
                String fileName = "demo_img_" + imageBean.getId().toString().toLowerCase().replaceAll("-", "_");
                int resID = getResources().getIdentifier(fileName, "drawable", getActivity().getPackageName());
                this.imageView.setImageResource(resID);
            }
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

    @SuppressWarnings("NonStaticInnerClassInSecureContext")
    private class ImagePagerAdapter extends PagerAdapter {

        private final List<ImageBean> images;
        private final LayoutInflater inflater;
        private final String externalDir;
        private final boolean clickable;

        ImagePagerAdapter(List<ImageBean> images, boolean clickable) {
            super();
            this.clickable = clickable;
            this.externalDir = getActivity().getExternalFilesDir(Environment.DIRECTORY_PICTURES).toString();
            this.images = images;
            this.inflater = getLayoutInflater(null);
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return this.images.size();
        }

        @SuppressWarnings("UnusedAssignment")
        @Override
        public Object instantiateItem(ViewGroup container, final int position) {
            View imageLayout = this.inflater.inflate(R.layout.fiche_image_fragment_page, container, false);
            ImageView imageView = (ImageView) imageLayout.findViewById(R.id.image);
            final ProgressBar spinner = (ProgressBar) imageLayout.findViewById(R.id.loading);

            ImageBean imageBean = this.images.get(position);
            String imagePath = "";
            if (BuildConfig.DEBUG)
                imagePath = new File(this.externalDir, "demo_img_" + imageBean.getId().toString().toLowerCase().replaceAll("-", "_")).toString();

            setUIElement(imageLayout, R.id.image_type_image, imageBean.getCategorieImage().getLibelle());

            ImageFragment.this.imageLoader.displayImage(String.format("file://%s", imagePath), imageView, ImageFragment.this.options, new SimpleImageLoadingListener() {
                @Override
                public void onLoadingStarted(String imageUri, View view) {
                    spinner.setVisibility(View.VISIBLE);
                }

                @Override
                public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
                    String message = null;
                    switch (failReason.getType()) {
                        case IO_ERROR:
                            message = "Input/Output error";
                            break;
                        case DECODING_ERROR:
                            message = "Image can't be decoded";
                            break;
                        case NETWORK_DENIED:
                            message = "Downloads are denied";
                            break;
                        case OUT_OF_MEMORY:
                            message = "Out Of Memory error";
                            break;
                        case UNKNOWN:
                            message = "Unknown error";
                            break;
                    }
                    Toast.makeText(ImageFragment.this.getActivity(), message, Toast.LENGTH_SHORT).show();

                    spinner.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
                    spinner.setVisibility(View.GONE);
                    if (ImagePagerAdapter.this.clickable) {
                        view.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                Intent intent = new Intent();
                                intent.setClass(getActivity(), ImageActivity.class);
                                intent.putParcelableArrayListExtra("images", (ArrayList<? extends Parcelable>) ImageFragment.this.imagesList);
                                intent.putExtra("currentImage", position);
                                startActivity(intent);
                            }
                        });

                    }
                }
            });

            container.addView(imageLayout, 0);
            return imageLayout;
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view.equals(object);
        }

    }
}
