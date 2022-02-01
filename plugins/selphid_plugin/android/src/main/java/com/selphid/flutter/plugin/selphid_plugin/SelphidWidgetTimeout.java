package com.selphid.flutter.plugin.selphid_plugin;

import com.facephi.fphiselphidwidgetcore.WidgetTimeout;

public enum SelphidWidgetTimeout {
    TIMEOUT_SHORT("Short") {
        @Override
        public WidgetTimeout getWidgetTimeout() {
            return WidgetTimeout.Short;
        }
    },
    TIMEOUT_MEDIUM("Medium") {
        @Override
        public WidgetTimeout getWidgetTimeout() {
            return WidgetTimeout.Medium;
        }
    },
    TIMEOUT_LONG("Long") {
        @Override
        public WidgetTimeout getWidgetTimeout() { return WidgetTimeout.Long; }
    };

    private final String name;

    SelphidWidgetTimeout(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }

    public abstract WidgetTimeout getWidgetTimeout();
}
