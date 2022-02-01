package com.selphi.flutter.plugin.selphi_face_plugin;

import java.util.Observable;
import java.util.Observer;
import com.facephi.fphiwidgetcore.IFPhiWidgetQR;

public class SelphiFaceEventQRListener implements IFPhiWidgetQR, Observer {
    public static Boolean isValidQR = false;

    @Override
    public boolean isValidQR(String s) {
        //Log.i("qrData: ", s);
        SelphiFaceLogQRModel.getLogModel().setCurrentLogJSON(s);
        if (SelphiFaceEventQRListener.isValidQR == true) {
            return true;
        }
        return false;
    }

    @Override
    public void update(Observable observable, Object o) {
        //Log.i("Observable Object: ", o.toString());
        SelphiFaceEventQRListener.isValidQR = Boolean.parseBoolean(o.toString());
    }
}