package org.tetram.bdtheque.data.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.UUID;

public abstract class CommonBean implements Parcelable {
    @SuppressWarnings("InstanceVariableNamingConvention")
    private UUID id;

    public CommonBean(Parcel in) {
        super();
        readFromParcel(in);
    }

    public CommonBean() {
        super();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeValue(this.id);
    }

    public void readFromParcel(Parcel in) {
        this.id = (UUID) in.readValue(UUID.class.getClassLoader());
    }

    public UUID getId() {
        return this.id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

}
