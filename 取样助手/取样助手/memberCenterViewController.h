//
//  memberCenterViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2017/2/15.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
#import "draftViewController-iphone.h"
#import "oprateRecordVC.h"
#import "passwdChangeViewController.h"

@interface memberCenterViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property NSString *userName;
@property NSString *token;
@property NSArray *productList;


@end
