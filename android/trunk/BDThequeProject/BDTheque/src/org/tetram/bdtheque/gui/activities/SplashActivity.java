package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.database.DatabaseHelper;

import java.util.Date;

public class SplashActivity extends Activity {

    private static final int STOPSPLASH = 9999;
    static int MIN_WAIT_TIME = 2000;
    private Date startTime;
    private boolean backButtonPressed = false;
    private boolean noWait = false;

    private transient Handler splashHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == STOPSPLASH) {
                final Animation animation = AnimationUtils.loadAnimation(getBaseContext(), android.R.anim.fade_out);
                animation.setDuration(1000);
                animation.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationEnd(Animation animation) {
                        findViewById(R.id.splash).setVisibility(View.INVISIBLE);
                        if (!backButtonPressed) goToMainActivity();
                        // doublon avec le noHistory du manifest mais ça pose pas de problème
                        // ceinture... bretelles...
                        SplashActivity.this.finish();
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {
                        // nothing to do ...
                    }

                    @Override
                    public void onAnimationStart(Animation animation) {
                        // nothing to do ...
                    }
                });

                findViewById(R.id.splash).startAnimation(animation);
            }
            super.handleMessage(msg);
        }

    };

    public void goToMainActivity() {
        final Intent intent = new Intent(SplashActivity.this, RepertoireActivity.class);
        startActivity(intent);
    }

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);    // Removes title bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);    // Removes notification bar
        setContentView(R.layout.splash);
        setTitle("");
    }

    @Override
    protected void onStart() {
        super.onStart();
        startTime = new Date();
        new DatabaseHelper(this);
        if (!noWait) waitExtraTime();
    }

    @Override
    public void onBackPressed() {
        backButtonPressed = true;
        super.onBackPressed();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        /** Si l'utilisateur appuie sur l'ecran on passe à l'Activity principale */
        if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
            Message stopMessage = splashHandler.obtainMessage(STOPSPLASH);
            if (stopMessage == null)
                noWait = true;
            else {
                splashHandler.removeMessages(STOPSPLASH);
                splashHandler.handleMessage(stopMessage);
            }
        }
        return true;
    }

    void waitExtraTime() {
        final long tempsRestant = MIN_WAIT_TIME - (new Date().getTime() - startTime.getTime());
        if (tempsRestant > 0) splashHandler.sendEmptyMessageDelayed(STOPSPLASH, tempsRestant);
    }
}