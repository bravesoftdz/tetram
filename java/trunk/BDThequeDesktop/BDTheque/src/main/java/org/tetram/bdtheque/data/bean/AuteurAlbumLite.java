package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class AuteurAlbumLite extends AuteurSerieLite {

    private final ObjectProperty<UUID> idAlbum = new SimpleObjectProperty<>(this, "idAlbum", null);

    static {
        baseClass = AuteurAlbumLite.class;
    }


    public UUID getIdAlbum() {
        return idAlbum.get();
    }

    public void setIdAlbum(UUID idAlbum) {
        this.idAlbum.set(idAlbum);
    }

    public ObjectProperty<UUID> idAlbumProperty() {
        return idAlbum;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object other) {
        if (this == other) return true;
        if (!(other instanceof AuteurAlbumLite)) return false;
        if (!super.equals(other)) return false;

        AuteurAlbumLite that = (AuteurAlbumLite) other;

        if (getIdAlbum() != null ? !getIdAlbum().equals(that.getIdAlbum()) : that.getIdAlbum() != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (getIdAlbum() != null ? getIdAlbum().hashCode() : 0);
        return result;
    }

    @Override
    public AbstractDBEntity lightRef() {
        final AuteurAlbumLite e = (AuteurAlbumLite) super.lightRef();
        e.setIdAlbum(this.getIdAlbum());
        return e;
    }
}
