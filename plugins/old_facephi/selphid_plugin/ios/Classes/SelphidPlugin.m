#import "SelphidPlugin.h"

@implementation SelphidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"selphid_plugin"
            binaryMessenger:[registrar messenger]];
  SelphidPlugin* instance = [[SelphidPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    _result = result;
  if ([@"startSelphIDWidget" isEqualToString:call.method]) {
  
      NSString * mode = call.arguments[@"operationMode"];
      NSString * resourcesPath = call.arguments[@"resourcesPath"];
      NSString * widgetLicense = call.arguments[@"widgetLicense"];
      NSDictionary * config = call.arguments[@"widgetConfigurationJSON"];
      
      NSString * previousOCRData = call.arguments[@"previousOCRData"];
      
      NSError *error = nil;
      NSBundle *bundle = [NSBundle bundleForClass:[SelphidPlugin class]];
      NSString *strBundle = [bundle pathForResource:resourcesPath ofType:@"zip"];
      
      _uc = [[FPhiSelphIDWidget alloc]initWithFrontCameraIfAvailable :true
                                resources:strBundle
                                delegate:self
                                license:widgetLicense
                                error:&error];
      
      if (error != nil) {
          switch (error.code) {
              case FWMECameraPermission:
              {
                  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                  [dict setObject:[NSNumber numberWithInt:2] forKey:@"finishStatus"];
                  [dict setObject:[NSNumber numberWithInt:3] forKey:@"errorType"];
                  result([FlutterError errorWithCode:@"PERMISSION ERROR"
                                             message:@"Permission error during proccess."
                                             details:nil]);
                  return;
              }
              default:
              {
                  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                  [dict setObject:[NSNumber numberWithInt:2] forKey:@"finishStatus"];
                  [dict setObject:[NSNumber numberWithInt:1] forKey:@"errorType"];
                  result([FlutterError errorWithCode:@"GENERIC ERROR"
                                             message:@"Error during bundle resources loading."
                                             details:nil]);
                  return;
              }
          }
      }
      
      // Analyze configuration properties
      if (config != nil) {
          NSObject *debug = [config objectForKey:@"debug"];
          if (debug != nil)
          _uc.debugMode = ((NSNumber *)debug).boolValue;
          
          NSObject *showAfterCapture = [config objectForKey:@"showResultAfterCapture"];
          if (showAfterCapture != nil)
          _uc.showAfterCapture = ((NSNumber *)showAfterCapture).boolValue;
          
          NSObject *showTutorial = [config objectForKey:@"showTutorial"];
          if (showTutorial != nil)
          _uc.showTutorial = ((NSNumber *)showTutorial).boolValue;
          //_uc.showTutorial = false;
          
          NSString *scanMode = [config objectForKey:@"scanMode"]; // Front, Back, Wizard
          if (scanMode != nil) {
              if ([scanMode compare:@"GenericMode"] == NSOrderedSame) {
                  _uc.scanMode = SMGeneric;
              } else if ([scanMode compare:@"SpecificMode"] == NSOrderedSame) {
                  _uc.scanMode = SMSpecific;
              } else if ([scanMode compare:@"SearchMode"] == NSOrderedSame) {
                  _uc.scanMode = SMSearch;
              } else {
                  _uc.scanMode = SMGeneric;
              }
              
              NSObject *specificData = [config objectForKey:@"specificData"];
              if (specificData != nil && specificData != (NSString*)[NSNull null])
              _uc.specificData = ((NSString *)specificData);
              else
              _uc.specificData = @"";
          }
          
          
              NSObject *tokenImageQuality = [config objectForKey:@"tokenImageQuality"];
              if (tokenImageQuality != nil)
                  _uc.tokenImageQuality = ((NSNumber *)tokenImageQuality).floatValue;
              
          
          NSObject *wizardMode = [config objectForKey:@"wizardMode"];
          if (wizardMode != nil) {
              _uc.wizardMode = ((NSNumber *)wizardMode).boolValue;
          }
          
          NSObject *locale = [config objectForKey:@"locale"];
          if (locale != nil && locale != (NSString*)[NSNull null])
            _uc.locale = ((NSString *)locale);
          else
            _uc.locale = @"";

          NSString *documentType = [config objectForKey:@"documentType"]; // Front, Back, Wizard
            if (documentType != nil) {
                if ([documentType compare:@"DT_IDCard"] == NSOrderedSame) {
                    _uc.scanType = DTIDCard;
                } else if ([documentType compare:@"DT_Passport"] == NSOrderedSame) {
                    _uc.scanType = DTPassport;
                } else if ([documentType compare:@"DT_DriversLicense"] == NSOrderedSame) {
                    _uc.scanType = DTDriversLicense;
                } else if ([documentType compare:@"DT_ForeignCard"] == NSOrderedSame) {
                    _uc.scanType = DTForeignCard;
                } else if ([documentType compare:@"DT_CreditCard"] == NSOrderedSame) {
                    _uc.scanType = DTCreditCard;
                } else {
                    _uc.scanType = DTIDCard;
                }
            }
          
          NSString *timeout = [config objectForKey:@"timeout"]; // Front, Back, Wizard
            if (timeout != nil) {
                if ([timeout compare:@"Short"] == NSOrderedSame) {
                    _uc.timeout = TShort;
                } else if ([timeout compare:@"Medium"] == NSOrderedSame) {
                    _uc.timeout = TMedium;
                } else if ([timeout compare:@"Long"] == NSOrderedSame) {
                    _uc.timeout = TLong;
                } else {
                    _uc.timeout = TShort;
                }
            }
      }
      
      if ([mode compare:@"CaptureFront"] == NSOrderedSame) {
          _uc.scanSide = DSFront;
          _uc.wizardMode = false;
      } else if ([mode compare:@"CaptureBack"] == NSOrderedSame) {
          _uc.scanSide = DSBack;
          _uc.wizardMode = false;
      } else if ([mode compare:@"CaptureWizard"] == NSOrderedSame) {
          _uc.scanSide = DSFront;
          _uc.wizardMode = true;
      } else if ([mode compare:@"Tutorial"] == NSOrderedSame) {
          _uc.showTutorial = true;
          _uc.showTutorialOnly = true;
      } else {
          result([FlutterError errorWithCode:@"OPERATION MODE ERROR"
                                     message:@"The mode selected doesn't exist."
                                     details:nil]);
          return;
      }
      
      if (_uc.wizardMode || [previousOCRData isEqual:[NSNull null]])
        _uc.tokenPreviousCaptureData = nil;
      else
         _uc.tokenPreviousCaptureData = previousOCRData;
      
      UIViewController *flutterViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
      [_uc StartExtraction];
      [flutterViewController presentViewController:_uc animated:true completion:nil];
  } else {
     result(FlutterMethodNotImplemented);
  }
}

- (BOOL)prefersStatusBarHidden {
    https://flutter.dev/docs/get-started/flutter-for/ios-devs#what-is-the-equivalent-of-cocoapods-how-do-i-add-dependencies
    // DETECT iPhone X @Hack: no parece que exista una forma mejor de detectar el iPhone X
    if ([[UIScreen mainScreen] nativeBounds].size.height == 1792 ||
        [[UIScreen mainScreen] nativeBounds].size.height == 2436 ||
        [[UIScreen mainScreen] nativeBounds].size.height == 2688) {
        return false;
    }
    
    return true;
}
    
    // protocol implementation
-(void) CaptureFinished {
    
    NSLog(@"StartCapture finished");
    
    NSMutableDictionary *dictResult = [self parseResults:(FPhiSelphIDWidget *)_uc];
    
    self.uc = nil;
    
     _result(dictResult);
}
    
-(NSString*) getBase64FromUIImage:(UIImage*)thisImage {
    NSData *data = UIImageJPEGRepresentation([self scaleAndRotateImage:thisImage], 0.9f);
    return [SelphidPlugin base64forData:data];
}
    
-(void) CaptureFailed:(NSError *)error {
    NSLog(@"StartCapture failed");
    
    self.uc = nil;
    _result([FlutterError errorWithCode:@"CAPTURE ERROR"
                               message:@"The capture process failed."
                               details:nil]);
    
}
    
-(void)CaptureCancelled {
    
    NSLog(@"StartCapture cancelled");

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:3] forKey:@"finishStatus"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"errorType"];
    [dict setObject:[NSNumber numberWithInt:self.uc.results.captureProgress] forKey:@"timeoutStatus"];

    self.uc = nil;
    _result(dict);
}
    
-(void)CaptureTimeout {
    
    NSLog(@"StartCapture timeout");
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:4] forKey:@"finishStatus"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"errorType"];
    [dict setObject:[NSNumber numberWithInt:self.uc.results.captureProgress] forKey:@"timeoutStatus"];

    self.uc = nil;
     _result(dict);
}
    
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
    
    
-(NSMutableDictionary *) parseResults:(FPhiSelphIDWidget *)userControl {
    FPhiSelphIDWidgetExtractionData * data = _uc.results;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // Generic data
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"finishStatus"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"errorType"];
    [dict setObject:[NSNumber numberWithInt:data.captureProgress] forKey:@"timeoutStatus"];

    
    if(data.documentCaptured != nil) {
        [dict setObject:data.documentCaptured forKey:@"lastDocumentCaptured"];
    }
    
    if(data.frontDocument != nil)
    [dict setObject:[self getBase64FromUIImage:data.frontDocument] forKey:@"frontDocumentImage"];
    if(data.backDocument != nil)
    [dict setObject:[self getBase64FromUIImage:data.backDocument] forKey:@"backDocumentImage"];
    if(data.faceImage != nil)
    [dict setObject:[self getBase64FromUIImage:data.faceImage] forKey:@"faceImage"];
    if(data.rawFrontDocument != nil)
    [dict setObject:[self getBase64FromUIImage:data.rawFrontDocument] forKey:@"rawFrontDocument"];
    if(data.rawBackDocument != nil)
    [dict setObject:[self getBase64FromUIImage:data.rawBackDocument] forKey:@"rawBackDocument"];
    if(data.signatureImage != nil)
    [dict setObject:[self getBase64FromUIImage:data.signatureImage] forKey:@"signatureImage"];
    if(data.fingerprintImage != nil)
    [dict setObject:[self getBase64FromUIImage:data.fingerprintImage]
             forKey:@"fingerprintImage"];
    
    if(data.tokenOCR != nil)
    [dict setObject:data.tokenOCR forKey:@"tokenOCR"];
    if(data.tokenFaceImage != nil)
    [dict setObject:data.tokenFaceImage forKey:@"tokenFaceImage"];
    if(data.tokenFrontDocument != nil)
    [dict setObject:data.tokenFrontDocument forKey:@"tokenFrontDocument"];
    if(data.tokenBackDocument != nil)
    [dict setObject:data.tokenBackDocument forKey:@"tokenBackDocument"];
    if(data.tokenRawFrontDocument != nil)
    [dict setObject:data.tokenRawFrontDocument forKey:@"tokenRawFrontDocument"];
    if(data.tokenRawBackDocument != nil)
    [dict setObject:data.tokenRawBackDocument forKey:@"tokenRawBackDocument"];
   
    NSMutableDictionary* dictOCR = [[NSMutableDictionary alloc] init];
    for (NSString *key in [data.ocrResults allKeys]) {
        [dictOCR setObject:data.ocrResults[key] forKey:[key componentsSeparatedByString:@"/"].lastObject];
    }
    
    NSError* errorData;
    NSData* dictData = [NSJSONSerialization dataWithJSONObject:dictOCR
                                                       options: 0
                                                         error:&errorData];
    NSString* jsonString = [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
    if(jsonString != nil){
        [dict setObject:jsonString forKey:@"documentData"];
    }
    
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"errorType"];
    
    
    [dict setObject:[NSNumber numberWithFloat:data.matchingSidesScore]  forKey:@"matchingSidesScore"];
    
    return dict;
}
    
-(UIImage *)scaleAndRotateImage:(UIImage *)image {
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        
        case UIImageOrientationUp: //EXIF = 1
        transform = CGAffineTransformIdentity;
        break;
        
        case UIImageOrientationUpMirrored: //EXIF = 2
        transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
        transform = CGAffineTransformScale(transform, -1.0, 1.0);
        break;
        
        case UIImageOrientationDown: //EXIF = 3
        transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;
        
        case UIImageOrientationDownMirrored: //EXIF = 4
        transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        break;
        
        case UIImageOrientationLeftMirrored: //EXIF = 5
        boundHeight = bounds.size.height;
        bounds.size.height = bounds.size.width;
        bounds.size.width = boundHeight;
        transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
        transform = CGAffineTransformScale(transform, -1.0, 1.0);
        transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
        break;
        
        case UIImageOrientationLeft: //EXIF = 6
        boundHeight = bounds.size.height;
        bounds.size.height = bounds.size.width;
        bounds.size.width = boundHeight;
        transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
        transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
        break;
        
        case UIImageOrientationRightMirrored: //EXIF = 7
        boundHeight = bounds.size.height;
        bounds.size.height = bounds.size.width;
        bounds.size.width = boundHeight;
        transform = CGAffineTransformMakeScale(-1.0, 1.0);
        transform = CGAffineTransformRotate(transform, M_PI / 2.0);
        break;
        
        case UIImageOrientationRight: //EXIF = 8
        boundHeight = bounds.size.height;
        bounds.size.height = bounds.size.width;
        bounds.size.width = boundHeight;
        transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
        transform = CGAffineTransformRotate(transform, M_PI / 2.0);
        break;
        
        default:
        [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
        
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
