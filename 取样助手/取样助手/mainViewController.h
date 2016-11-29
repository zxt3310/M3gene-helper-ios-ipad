//
//  ViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFanBasicViewController.h"
#import "UIViewController+UFanViewController.h"
#import "scanViewController.h"
#import "uploadViewController.h"
#import "sendViewController.h"
#import "loginViewController.h"
#import "publicMethod.h"
#import "uploadIpadViewController.h"

@interface mainViewController :UFanBasicViewController  <tabBarSwitchDelegate,loginUpdateToken>

@property (nonatomic) UITableView *tableView;

@property sendViewController *svc;

@end

@interface newTabBarController : UITabBarController

@property NSString *mytitle;

@end
