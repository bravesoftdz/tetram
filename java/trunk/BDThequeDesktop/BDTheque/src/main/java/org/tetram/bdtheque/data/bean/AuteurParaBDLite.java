package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurParaBDLite extends AuteurLite {
    private UUID idParaBD;

    public UUID getIdParaBD() {
        return idParaBD;
    }

    public void setIdParaBD(UUID idParaBD) {
        this.idParaBD = idParaBD;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuteurParaBDLite)) return false;
        if (!super.equals(o)) return false;

        AuteurParaBDLite that = (AuteurParaBDLite) o;

        if (idParaBD != null ? !idParaBD.equals(that.idParaBD) : that.idParaBD != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (idParaBD != null ? idParaBD.hashCode() : 0);
        return result;
    }

}
