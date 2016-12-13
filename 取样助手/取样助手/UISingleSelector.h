//
//  UISingleSelector.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/8.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WEIGHT [[UIScreen mainScreen] bounds].size.width

@interface UISingleSelector : UIView <UITextFieldDelegate>

//单选控件

@property (nonatomic) NSArray *itemList; //选项文字
@property (nonatomic) NSArray *itemId;   //索引    目前仅支持文本数组
@property (nonatomic) NSString *switchId; //选中标识
@property (nonatomic) UIFont *textFont;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *selectorOutBorderColor;
@property (nonatomic) UIColor *selectorInterColor;

- (NSString *)stringOfSelectedString;  //

@end


@protocol UISingleSelectorDelegate <NSObject>

@optional
- (void)singleSelecotr:(UISingleSelector *)singleSelector DidSelectAtSelectList:(NSString *) selectString;

@end


@interface UISingleSelector ()<UISingleSelectorDelegate>

@property id<UISingleSelectorDelegate> delegate;

@end
