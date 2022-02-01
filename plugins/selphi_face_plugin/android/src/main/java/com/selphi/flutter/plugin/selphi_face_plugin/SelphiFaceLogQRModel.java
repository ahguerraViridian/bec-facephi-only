package com.selphi.flutter.plugin.selphi_face_plugin;

import androidx.lifecycle.MutableLiveData;

public class SelphiFaceLogQRModel {
    private static SelphiFaceLogQRModel mLogModelInstance;
    // Create a LiveData with a String
    private MutableLiveData<String> currentLog;

    public static SelphiFaceLogQRModel getLogModel() {
        //instantiate a new CustomerLab if we didn't instantiate one yet
        if (mLogModelInstance == null) {
            mLogModelInstance = new SelphiFaceLogQRModel();
        }
        return mLogModelInstance;
    }

    public void setCurrentLogJSON(String qr) {
        //String logJSON = "{\"qrData\":\""+qr+"\"}";
        currentLog.postValue(qr);
    }

    public MutableLiveData<String> getCurrentLog() {
        if (currentLog == null) {
            currentLog = new MutableLiveData<String>();
        }
        return currentLog;
    }
}