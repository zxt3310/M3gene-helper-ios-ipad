//
//  POPViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/1.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>

@optional

// Override this method in UIViewController derived class to handle 'Back' button click

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface POPViewController : UIViewController

@end


@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
