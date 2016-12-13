//
//  UIComboBox.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/13.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComboBox : UIControl <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *comboList;
@property UIColor *layerColor;
@property UIColor *comborColor;
@property UIFont *textFont;
@property UIColor *textColor;

- (void)dismissTable;
@end
