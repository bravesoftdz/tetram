package org.tetram.bdtheque.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import org.tetram.bdtheque.R;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;

public class UserConfig {
    private static final UserConfig ourInstance = new UserConfig();

    public static UserConfig getInstance() {
        return ourInstance;
    }

    private UserConfig() {
        super();
    }

    @SuppressWarnings("RedundantFieldInitialization")
    private int formatTitreAlbum = 0;
    private boolean afficheNoteListes = true;
    private String symboleMonetaire = DecimalFormatSymbols.getInstance().getCurrencySymbol();
    private DecimalFormat formatMonetaire = buildFormatMonetaire();

    public void reloadConfig(final Context context) {
        final SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(context);
        this.formatTitreAlbum = Integer.valueOf(sharedPref.getString(context.getString(R.string.pref_formatTitreAlbum), "0"));
        this.afficheNoteListes = sharedPref.getBoolean(context.getString(R.string.pref_notationListe), true);
        this.symboleMonetaire = sharedPref.getString(context.getString(R.string.pref_symboleMonetaire), DecimalFormatSymbols.getInstance().getCurrencySymbol());
    }

    public int getFormatTitreAlbum() {
        return this.formatTitreAlbum;
    }

    public boolean shouldAfficheNoteListes() {
        return this.afficheNoteListes;
    }

    public String getSymboleMonetaire() {
        return this.symboleMonetaire;
    }

    public void setSymboleMonetaire(String symboleMonetaire) {
        this.symboleMonetaire = symboleMonetaire;
    }

    private DecimalFormat buildFormatMonetaire() {
        DecimalFormat currencyFormat = (DecimalFormat) NumberFormat.getCurrencyInstance();
        DecimalFormatSymbols dfs = currencyFormat.getDecimalFormatSymbols();
        dfs.setCurrencySymbol(this.symboleMonetaire);
        currencyFormat.setDecimalFormatSymbols(dfs);
        return currencyFormat;
    }

    public DecimalFormat getFormatMonetaire() {
        return this.formatMonetaire;
    }

}
