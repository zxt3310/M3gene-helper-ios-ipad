//
//  AppDelegate.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UFanViewController.h"
#import "leftDrawerViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property UINavigationController *rootNavigationController;

@end

