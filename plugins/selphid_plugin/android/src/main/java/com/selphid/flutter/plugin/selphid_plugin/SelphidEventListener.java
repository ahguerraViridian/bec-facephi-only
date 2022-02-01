package com.selphid.flutter.plugin.selphid_plugin;

import androidx.annotation.NonNull;

import com.facephi.fphiselphidwidgetcore.IFPhiWidgetSelphIDEventListener;

public class SelphidEventListener implements IFPhiWidgetSelphIDEventListener {
    @Override
    public void onEvent(long time, @NonNull String type, @NonNull String info) {
        SelphidFaceLogModel.getLogModel().setCurrentLogJSON(time+"", type, info);
    }
}
