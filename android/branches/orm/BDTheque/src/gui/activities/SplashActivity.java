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
import org.tetram.bdtheque.database.BDDatabaseHelper;

import java.util.Date;

public class SplashActivity extends Activity {

    private static final int STOPSPLASH = 9999;
    private static final int MIN_WAIT_TIME = 2000;
    private Date startTime;
    private boolean backButtonPressed;
    private boolean noWait;

    private final transient Handler splashHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == STOPSPLASH) {
                final Animation finalAnimation = AnimationUtils.loadAnimation(getBaseContext(), android.R.anim.fade_out);
                finalAnimation.setDuration(1000);
                finalAnimation.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationEnd(Animation animation) {
                        findViewById(R.id.splash).setVisibility(View.INVISIBLE);
                        if (!SplashActivity.this.backButtonPressed) goToMainActivity();
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

                findViewById(R.id.splash).startAnimation(finalAnimation);
            }
            super.handleMessage(msg);
        }

    };

    public void goToMainActivity() {
        final Intent intent = new Intent(SplashActivity.this, RepertoireActivity.class);
        startActivity(intent);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);    // Removes title bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);    // Removes notification bar
        setContentView(R.layout.splash);
        setTitle("");
    }

    @SuppressWarnings("ResultOfObjectAllocationIgnored")
    @Override
    protected void onStart() {
        super.onStart();
        this.startTime = new Date();
        new BDDatabaseHelper(this);
        if (!this.noWait) waitExtraTime();
    }

    @Override
    public void onBackPressed() {
        this.backButtonPressed = true;
        super.onBackPressed();
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        /** Si l'utilisateur appuie sur l'ecran on passe à l'Activity principale */
        if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
            Message stopMessage = this.splashHandler.obtainMessage(STOPSPLASH);
            if (stopMessage == null)
                this.noWait = true;
            else {
                this.splashHandler.removeMessages(STOPSPLASH);
                this.splashHandler.handleMessage(stopMessage);
            }
        }
        return true;
    }

    void waitExtraTime() {
        final long tempsRestant = MIN_WAIT_TIME - (new Date().getTime() - this.startTime.getTime());
        if (tempsRestant > 0) this.splashHandler.sendEmptyMessageDelayed(STOPSPLASH, tempsRestant);
    }
}