package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.utils.StringUtils;

public class SerieLiteBean extends CommonBean implements TreeNodeBean {

    private String titre;
    private CollectionLiteBean collection;
    private EditeurLiteBean editeur;

    public String getTitre() {
        return this.titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    private String chaineAffichage(boolean simple) {
        String result;
        if (simple)
            result = this.titre;
        else
            result = StringUtils.formatTitre(this.titre);

        String s = StringUtils.ajoutString("", StringUtils.formatTitre(this.editeur.getNom()), " ");
        if (this.collection != null)
            s = StringUtils.ajoutString(s, StringUtils.formatTitre(this.collection.getNom()), " - ");
        return StringUtils.ajoutString(result, s, " ", "(", ")");
    }

    @Override
    public String getTreeNodeText() {
        return chaineAffichage(false);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }

    public void setCollection(CollectionLiteBean collection) {
        this.collection = collection;
    }

    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }
}
