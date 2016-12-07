//
//  registView.h
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"

//单选控件
@interface comboBox : UIView
@property (nonatomic) NSArray *itemList; //选项文字
@property (nonatomic) NSArray *itemId;   //选项对应输出
@property (nonatomic) NSString *switchId; //选中标识
- (NSString *)stringOfSelectedString;

@end

@interface registViewNew : UIView

@property NSString *SJYB;
@property NSString *DDBH;
@property NSString *SJDW;
@property NSString *SJYS;
@property NSString *CJRQ;
@property NSString *NAME;
@property NSString *SFZH;
@property NSString *LXDH;
@property NSString *JSDZ;
@property NSString *CSRQ;
@property NSInteger SEX;
@property NSString *MZ;
@property NSString *JG;
@property NSInteger AZS;
@property NSString *FBNL;
@property NSString *LCBX;
@property NSInteger JZAZS_SWITCH;
@property NSString *JZAZS;
@property NSString *GX;
@property NSString *QTBS;

@end
