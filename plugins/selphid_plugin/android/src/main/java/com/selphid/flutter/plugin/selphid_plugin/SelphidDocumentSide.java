package com.selphid.flutter.plugin.selphid_plugin;

import com.facephi.fphiselphidwidgetcore.WidgetSelphIDDocumentSide;

public enum SelphidDocumentSide {
    MODE_FRONT("CaptureFront") {
        @Override
        public WidgetSelphIDDocumentSide getDocumentSide() {
            return WidgetSelphIDDocumentSide.DSFront;
        }

        @Override
        public boolean getIsWizardMode() {
            return false;
        }
    },
    MODE_BACK("CaptureBack") {
        @Override
        public WidgetSelphIDDocumentSide getDocumentSide() {
            return WidgetSelphIDDocumentSide.DSBack;
        }

        @Override
        public boolean getIsWizardMode() {
            return false;
        }
    },
    MODE_WIZARD("CaptureWizard") {
        @Override
        public WidgetSelphIDDocumentSide getDocumentSide() {
            return WidgetSelphIDDocumentSide.DSFront;
        }

        @Override
        public boolean getIsWizardMode() {
            return true;
        }
    };

    private final String name;

    SelphidDocumentSide(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }

    public abstract WidgetSelphIDDocumentSide getDocumentSide();

    public abstract boolean getIsWizardMode();
}