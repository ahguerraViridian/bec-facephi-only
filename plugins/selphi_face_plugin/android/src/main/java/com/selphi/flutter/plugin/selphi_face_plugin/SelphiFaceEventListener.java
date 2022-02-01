package com.selphi.flutter.plugin.selphi_face_plugin;

import androidx.annotation.NonNull;
import com.facephi.fphiwidgetcore.IFPhiWidgetEventListener;

public class SelphiFaceEventListener implements IFPhiWidgetEventListener {
    @Override
    public void onEvent(long time, @NonNull String type, @NonNull String info) {
        // Return the info to the hybrid client
        SelphiFaceLogModel.getLogModel().setCurrentLogJSON(time+"", type, info);
    }
}