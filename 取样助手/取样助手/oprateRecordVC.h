//
//  oprateRecordVC.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtils.h"
#import "publicMethod.h"
@interface oprateRecordVC : UIViewController

@property NSInteger tableCount;
@property (nonatomic) UITableView *tableView;

@property NSArray *tableArry;
@property NSString *Id;
@property NSString *operateTime;
@property NSString *operateName;
@property NSString *status;

@end
