#import "SelphiFacePlugin.h"
#if __has_include(<selphi_face_plugin/selphi_face_plugin-Swift.h>)
#import <selphi_face_plugin/selphi_face_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "selphi_face_plugin-Swift.h"
#endif

@implementation SelphiFacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSelphiFacePlugin registerWithRegistrar:registrar];
}
@end
