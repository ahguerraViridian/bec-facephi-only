package com.selphi.flutter.plugin.selphi_face_plugin;

import java.util.Observable;

public class SelphiFaceObservableQR extends Observable {
    private Boolean isValid;

    public SelphiFaceObservableQR(Boolean isValid) {
        this.isValid = isValid;
    }

    public Boolean getIsValid() {
        return isValid;
    }

    public void setIsValid(Boolean isValid) {
        this.isValid = isValid;
        setChanged();
        notifyObservers(isValid);
    }
}