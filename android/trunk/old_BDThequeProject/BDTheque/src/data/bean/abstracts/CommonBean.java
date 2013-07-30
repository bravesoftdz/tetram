package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.UUID;

public abstract class CommonBean implements Parcelable {

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
        dest.writeValue(this.getId());
    }

    public void readFromParcel(Parcel in) {
        this.setId((UUID) in.readValue(UUID.class.getClassLoader()));
    }

    public abstract UUID getId();

    public abstract void setId(UUID id);

}
