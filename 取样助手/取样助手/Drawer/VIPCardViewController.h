//
//  VIPCardViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
#import "NetUtils.h"
#import "UIComboBox.h"

@interface VIPCardViewController : UIViewController <UITextFieldDelegate,UIComboBoxDelegate>

@property NSString *token;
@property NSString *userName;
@property BOOL isReEditOperate;
@property NSInteger deleteIndex;

@property id <cacheListRefresh> refreshDelegate;

@property NSString *code;
@property NSInteger card_type;
@property NSString *name;
@property NSInteger gender;
@property NSString *phone;
@property NSString *birthday;
@property NSString *career;
@property NSString *motor_type;
@property NSString *interest;
@property NSString *remark;
@property NSString *payment_amount;
@property NSInteger payment_type;
@property NSString *pay_time;
@property NSString *pay_info;


@end
