package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class UniversLite extends AbstractDBEntity {
    private String nomUnivers;

    public String getNomUnivers() {
        return nomUnivers;
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers = nomUnivers;
    }

    @Override
    public String buildLabel() {
        return StringUtils.formatTitre(nomUnivers);
    }
}
