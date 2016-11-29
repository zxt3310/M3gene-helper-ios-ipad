//
//  scanExpressViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tabBarSwitchDelegate <NSObject>
@optional
- (void) tabBarSwitch;
@end

@interface sendResaultViewController : UIViewController

@property NSString *resaultString;
@property id <tabBarSwitchDelegate> switchDelegate;
@end
