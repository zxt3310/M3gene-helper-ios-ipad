//
//  scanViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol refreshCellNuber <NSObject>
@optional
- (void) refreshCellNumber : (NSString *) code;
@end

@protocol tabBarSwitchDelegate <NSObject>

@optional

-(void)tabBarSwitch;
@end


@interface scanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    id <refreshCellNuber> delegate;
}
@property (nonatomic,assign) id <refreshCellNuber> delegate;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end
