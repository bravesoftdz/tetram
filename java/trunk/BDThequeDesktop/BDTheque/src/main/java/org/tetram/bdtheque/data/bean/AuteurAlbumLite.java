package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurAlbumLite extends AuteurSerieLite {
    private UUID idAlbum;

    public UUID getIdAlbum() {
        return idAlbum;
    }

    public void setIdAlbum(UUID idAlbum) {
        this.idAlbum = idAlbum;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuteurAlbumLite)) return false;
        if (!super.equals(o)) return false;

        AuteurAlbumLite that = (AuteurAlbumLite) o;

        if (idAlbum != null ? !idAlbum.equals(that.idAlbum) : that.idAlbum != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (idAlbum != null ? idAlbum.hashCode() : 0);
        return result;
    }
}
