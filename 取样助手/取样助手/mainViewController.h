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
#import "firstItemViewController.h"
#import "CustomURLCache.h"
#import "DataCenterWebViewController.h"

@interface mainViewController :UFanBasicViewController  <loginUpdateToken>

@property (nonatomic) UITableView *tableView;

@property sendViewController *svc;
@property NSArray *productList;

@property NSString *userName;
@property NSString *token;
@property NSArray *role;

@property id <loginUpdateToken>leftVc;

- (void)updateToken:(NSString *)currentToken name:(NSString *)name role:(NSArray *)roleArray;
@end






