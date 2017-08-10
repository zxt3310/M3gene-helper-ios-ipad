//
//  registView.h
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
#import "NetUtils.h"
#import "UIComboBox.h"
#import "UISingleSelector.h"

@interface registViewNew : UIScrollView  <UIGestureRecognizerDelegate,UIComboBoxDelegate,UISingleSelectorDelegate,UITextFieldDelegate,UITextViewDelegate,UITextFieldDelegate>

@property NSString *SJYB;
@property (nonatomic) NSString *DDBH;
@property NSString *SJDW;
@property NSString *SJYS;
@property NSString *CJRQ;
@property NSString *NAME;
@property NSString *SFZH;
@property NSString *LXDH;
@property NSString *JSDZ;
@property NSString *CSRQ;
@property NSString *SYJG;
@property NSString *SEX;
@property NSString *MZ;
@property NSString *JG;
@property NSString *AZS_SWITCH;
@property NSString *FBNL;
@property NSString *LCBX;
@property NSString *JZAZS_SWITCH;
@property NSString *JZAZS;
@property NSString *GX;
@property NSString *QTBS;

@property NSString *token;
@property NSInteger productId;

@property NSString *fillString;

@property (nonatomic)BOOL hidden;
- (void)show;
- (void)resignFirstResponderNow;
- (NSString *)builtToSendString;
- (void)fillUserData;
@end
