#import <Flutter/Flutter.h>
#import <FPhiSelphIDWidgetiOS/FPhiSelphIDWidgetios.h>

@interface SelphidPlugin : NSObject<FlutterPlugin, FPhiSelphIDWidgetProtocol>
    @property (nonatomic) FPhiSelphIDWidget *uc;
    @property (nonatomic) FlutterResult result;
@end

