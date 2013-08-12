package org.tetram.bdtheque.gui.fragments;

import android.app.Activity;
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

import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

public class ImageFragment extends Fragment {

    public static final String IMAGE_FRAGMENT_SAVED_STATE = "org.tetram.bdtheque.gui.fragments.ImageFragment.SAVED_STATE";
    public static final String IMAGE_FRAGMENT_IMAGES = "org.tetram.bdtheque.gui.fragments.ImageFragment.IMAGES";
    public static final String IMAGE_FRAGMENT_POSITION = "org.tetram.bdtheque.gui.fragments.ImageFragment.CURRENT_IMAGE";
    public static final String IMAGE_FRAGMENT_CLICKABLE = "org.tetram.bdtheque.gui.fragments.ImageFragment.CLICKABLE";
    private static final int UPDATE_POSITION = 0;
    protected ImageLoader imageLoader = ImageLoader.getInstance();
    DisplayImageOptions options;
    ViewPager pager;
    private List<ImageBean> imagesList;
    private boolean clickable;
    private int currentImage;
    private OnPageChangeListener pageChangeListener;

    public static ImageFragment getFragment(List<ImageBean> images, boolean clickable, Bundle savedBundle) {
        Bundle args = new Bundle();
        args.putBoolean(IMAGE_FRAGMENT_CLICKABLE, clickable);
        args.putParcelableArrayList(IMAGE_FRAGMENT_IMAGES, (ArrayList<? extends Parcelable>) images);
        if (savedBundle != null)
            args.putBundle(IMAGE_FRAGMENT_SAVED_STATE, savedBundle);

        ImageFragment imageFragment = new ImageFragment();
        imageFragment.setArguments(args);

        return imageFragment;
    }

    public static ImageFragment getFragment(List<ImageBean> images, int currentImage, boolean clickable) {
        ImageFragment imageFragment = getFragment(images, clickable, null);
        Bundle args = imageFragment.getArguments();
        args.putInt(IMAGE_FRAGMENT_POSITION, currentImage);

        return imageFragment;
    }

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
        View view = inflater.inflate(R.layout.fiche_image_fragment, container, false);

        this.currentImage = 0;

        if (getArguments() != null) {
            this.imagesList = getArguments().getParcelableArrayList(IMAGE_FRAGMENT_IMAGES);
            if (getArguments().containsKey(IMAGE_FRAGMENT_SAVED_STATE))
                this.currentImage = getArguments().getBundle(IMAGE_FRAGMENT_SAVED_STATE).getInt(IMAGE_FRAGMENT_POSITION, 0);
            else if (getArguments().containsKey(IMAGE_FRAGMENT_POSITION))
                this.currentImage = getArguments().getInt(IMAGE_FRAGMENT_POSITION, 0);
            this.clickable = getArguments().getBoolean(IMAGE_FRAGMENT_CLICKABLE, false);
        }

        if (savedInstanceState != null) {
            this.currentImage = savedInstanceState.getInt(IMAGE_FRAGMENT_POSITION);
            getArguments().putInt(IMAGE_FRAGMENT_POSITION, this.currentImage);
        }

        this.options = new DisplayImageOptions.Builder()
                .showImageForEmptyUri(R.drawable.ic_empty)
                .showImageOnFail(R.drawable.ic_error)
                .resetViewBeforeLoading(true)
                .cacheOnDisc(true)
                .imageScaleType(ImageScaleType.EXACTLY)
                .bitmapConfig(Bitmap.Config.ARGB_8888)
                .displayer(new FadeInBitmapDisplayer(300))
                .build();

        this.pager = (ViewPager) view.findViewById(R.id.pager);
        this.pager.setAdapter(new ImagePagerAdapter());
        this.pager.setCurrentItem(this.currentImage);
        this.pager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                pageSelected(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        return view;
    }

    private void pageSelected(int position) {
        this.currentImage = position;
        if (this.pageChangeListener != null)
            this.pageChangeListener.onPageSelected(position);
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(IMAGE_FRAGMENT_POSITION, this.pager.getCurrentItem());
    }

    @Override
    public void onViewStateRestored(Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
        if (savedInstanceState != null) {
            this.pager.setCurrentItem(savedInstanceState.getInt(IMAGE_FRAGMENT_POSITION, 0));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == UPDATE_POSITION) {
            if (resultCode == Activity.RESULT_OK) {
                this.pager.setCurrentItem(data.getIntExtra(IMAGE_FRAGMENT_POSITION, 0));
            }
        } else
            super.onActivityResult(requestCode, resultCode, data);
    }

    @SuppressWarnings("UnusedDeclaration")
    public void setPageChangeListener(OnPageChangeListener pageChangeListener) {
        this.pageChangeListener = pageChangeListener;
    }

    public interface OnPageChangeListener {
        public void onPageSelected(int position);
    }

    @SuppressWarnings("NonStaticInnerClassInSecureContext")
    private class ImagePagerAdapter extends PagerAdapter {

        private final LayoutInflater inflater;
        private final String externalDir;

        ImagePagerAdapter() {
            super();
            this.externalDir = getActivity().getExternalFilesDir(Environment.DIRECTORY_PICTURES).toString();
            this.inflater = getLayoutInflater(null);
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return ImageFragment.this.imagesList.size();
        }

        @SuppressWarnings("UnusedAssignment")
        @Override
        public Object instantiateItem(ViewGroup container, final int position) {
            View imageLayout = this.inflater.inflate(R.layout.fiche_image_fragment_page, container, false);
            ImageView imageView = (ImageView) imageLayout.findViewById(R.id.image);
            final ProgressBar spinner = (ProgressBar) imageLayout.findViewById(R.id.loading);

            ImageBean imageBean = ImageFragment.this.imagesList.get(position);
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
                    ((PhotoView) view).setZoomable(false);
                }

                @Override
                public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
                    spinner.setVisibility(View.GONE);
                    if (ImageFragment.this.clickable) {
                        ((PhotoView) view).setOnPhotoTapListener(new PhotoViewAttacher.OnPhotoTapListener() {
                            @SuppressWarnings("AnonymousClassVariableHidesContainingMethodVariable")
                            @Override
                            public void onPhotoTap(View view, float x, float y) {
                                Intent intent = new Intent();
                                intent.setClass(getActivity(), ImageActivity.class);
                                intent.putParcelableArrayListExtra(IMAGE_FRAGMENT_IMAGES, (ArrayList<? extends Parcelable>) ImageFragment.this.imagesList);
                                intent.putExtra(IMAGE_FRAGMENT_POSITION, position);
                                startActivityForResult(intent, UPDATE_POSITION);
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
