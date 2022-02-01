package com.selphid.flutter.plugin.selphid_plugin;

import androidx.lifecycle.MutableLiveData;

public class SelphidFaceLogModel {
    private static SelphidFaceLogModel mLogModelInstance;
    // Create a LiveData with a String
    private MutableLiveData<String> currentLog;

    public static SelphidFaceLogModel getLogModel() {
        //instantiate a new CustomerLab if we didn't instantiate one yet
        if (mLogModelInstance == null) {
            mLogModelInstance = new SelphidFaceLogModel();
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