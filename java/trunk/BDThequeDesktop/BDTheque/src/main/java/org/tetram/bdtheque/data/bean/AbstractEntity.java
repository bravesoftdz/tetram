package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class AbstractEntity {
    protected AbstractEntity() {
    }

    @Override
    public String toString() {
        return buildLabel();
    }

    public String buildLabel() {
        return "";
    }

}
