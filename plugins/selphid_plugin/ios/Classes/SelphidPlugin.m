#import "SelphidPlugin.h"
#if __has_include(<selphid_plugin/selphid_plugin-Swift.h>)
#import <selphid_plugin/selphid_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "selphid_plugin-Swift.h"
#endif

@implementation SelphidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftSelphIdPlugin registerWithRegistrar:registrar];
}

@end
