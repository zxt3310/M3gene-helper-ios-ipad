//
//  sendViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scanViewController.h"
#import "CMCustomViews.h"
#import "NetUtils.h"
#import "publicMethod.h"

@interface sendViewController : UIViewController

@property id <tabBarSwitchDelegate> switchDelegate;

@property scanViewController *svc;

@property (nonatomic) UITableView *tableView;

@property LoadingView *lodingView;

@property UIButton *scanBt;
@property UIButton *photoBt;
@property NSString *number;
@property NSString *expressNumber;

@property BOOL isExpressNumber;

@property NSArray *expressList;
@property UIPickerView *pickerView;

@property LoadingView *loadingView;

@property NSString *expressName;
@property UIButton *sendBt;
@property NSString *product;
@property BOOL isSendExpress;
@end
