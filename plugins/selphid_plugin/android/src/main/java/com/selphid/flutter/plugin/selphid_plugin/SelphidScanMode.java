package com.selphid.flutter.plugin.selphid_plugin;

import com.facephi.fphiselphidwidgetcore.WidgetSelphIDScanMode;

public enum SelphidScanMode {
    SM_GENERIC("GenericMode") {
        @Override
        public WidgetSelphIDScanMode getScanMode() {
            return WidgetSelphIDScanMode.SMGeneric;
        }
    },
    SM_SEARCH("SearchMode") {
        @Override
        public WidgetSelphIDScanMode getScanMode() {
            return WidgetSelphIDScanMode.SMSearch;
        }
    },
    SM_SPECIFIC("SpecificMode") {
        @Override
        public WidgetSelphIDScanMode getScanMode() { return WidgetSelphIDScanMode.SMSpecific; }
    };

    private final String name;

    SelphidScanMode(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }

    public abstract WidgetSelphIDScanMode getScanMode();

}
