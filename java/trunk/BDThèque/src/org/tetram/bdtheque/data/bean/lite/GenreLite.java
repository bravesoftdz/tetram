package org.tetram.bdtheque.data.bean.lite;

/**
 * Created by Thierry on 24/05/2014.
 */
public class GenreLite extends DBEntityLite {
    private String genre;
    private Integer quantite;

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    @Override
    public String buildLabel() {
        return genre;
    }
}
