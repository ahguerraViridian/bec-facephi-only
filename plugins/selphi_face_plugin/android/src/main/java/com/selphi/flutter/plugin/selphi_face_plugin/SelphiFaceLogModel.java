package com.selphi.flutter.plugin.selphi_face_plugin;

import androidx.lifecycle.MutableLiveData;

public class SelphiFaceLogModel {
    private static SelphiFaceLogModel mLogModelInstance;
    // Create a LiveData with a String
    private MutableLiveData<String> currentLog;

    public static SelphiFaceLogModel getLogModel() {
        //instantiate a new CustomerLab if we didn't instantiate one yet
        if (mLogModelInstance == null) {
            mLogModelInstance = new SelphiFaceLogModel();
        }
        return mLogModelInstance;
    }

    public void setCurrentLogJSON(String time, String type, String info) {
        String logJSON = "{\"time\":\""+time+"\",\"type\":\""+type+"\", \"info\":\""+info+"\"}";
        currentLog.postValue(logJSON);
    }

    public MutableLiveData<String> getCurrentLog() {
        if (currentLog == null) {
            currentLog = new MutableLiveData<String>();
        }
        return currentLog;
    }
}