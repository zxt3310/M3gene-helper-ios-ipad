//
//  UISingleSelector.m
//  取样助手
//
//  Created by Zxt3310 on 2016/12/8.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "UISingleSelector.h"

@implementation UISingleSelector

{
    UITextField *comboFT;
    UITextField *selectTag;
    UILabel *itemLable;
}

@synthesize itemList = _itemList;
@synthesize itemId = _itemId;
@synthesize switchId = _switchId;
@synthesize textFont = _textFont;
@synthesize textColor = _textColor;
@synthesize selectorOutBorderColor = _selectorOutBorderColor;
@synthesize selectorInterColor = _selectorInterColor;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        _textColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        _selectorOutBorderColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        _selectorInterColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        _delegate = self;
    }
    return self;
}


- (void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    
    CGFloat x = 0;
    for(int i = 0;i<itemList.count;i++ )
    {
        comboFT = [[UITextField alloc] initWithFrame:CGRectMake(0 + x, 0, 18*SCREEN_WEIGHT/1024, 18*SCREEN_HEIGHT/768)];
        comboFT.userInteractionEnabled = YES;
        comboFT.layer.borderWidth = 1;
        comboFT.layer.borderColor = _selectorOutBorderColor.CGColor;
        comboFT.layer.cornerRadius = comboFT.frame.size.width/2;
        comboFT.delegate = self;
        
        selectTag = [[UITextField alloc]initWithFrame:CGRectMake(3, 3, comboFT.frame.size.width - 6, comboFT.frame.size.height - 6)];
        selectTag.tag = 10 + i;
        selectTag.enabled = NO;
        selectTag.hidden = YES;
        selectTag.layer.borderWidth =1;
        selectTag.backgroundColor = _selectorInterColor;
        selectTag.layer.cornerRadius = selectTag.frame.size.width/2;
        [comboFT addSubview:selectTag];
        [self addSubview:comboFT];
        
        itemLable = [[UILabel alloc]init];
        itemLable.text = itemList[i];
        itemLable.frame = CGRectMake(comboFT.frame.origin.x + comboFT.frame.size.width * 2, 0,itemLable.text.length * 18,20);
        itemLable.font = _textFont;
        itemLable.textColor = _textColor;
        [self addSubview:itemLable];
        
        x = itemLable.frame.origin.x + itemLable.frame.size.width + 20;
    }
    CGRect temp = self.frame;
    temp.size.width = x;
    self.frame = temp;
}

- (NSArray *)itemList
{
    return _itemList;
}

- (void)setItemId:(NSArray *)itemId
{
    _itemId = itemId;
}

- (NSArray *)itemId
{
    return _itemId;
}

- (void)setSwitchId:(NSString *)switchId
{
    _switchId = switchId;
    
    for (id object in self.subviews)
    {
        if ([object isKindOfClass:[UITextField class]]) {
            
            for (int i = 10; i<10 + _itemList.count; i++) {
                UITextField *selectView = (UITextField *)[object viewWithTag:i];
                
                if([_itemId[i - 10]isEqualToString:switchId])
                {
                    selectView.hidden = NO;
                }
                else{
                    selectView.hidden = YES;
                }
            }
        }
    }
}

- (NSString *)switchId
{
    return _switchId;
}

- (UIColor *)textColor
{
    return _textColor;
}

- (UIFont *)textFont
{
    return _textFont;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    for (id object in self.subviews) {
        if([object isKindOfClass:[UILabel class]])
        {
            UILabel *lable = (UILabel *)object;
            lable.font = textFont;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (id object in self.subviews) {
        if([object isKindOfClass:[UILabel class]])
        {
            UILabel *lable = (UILabel *)object;
            lable.textColor = textColor;
        }
    }

}

- (UIColor *)selectorInterColor
{
    return _selectorInterColor;
}

- (void)setSelectorInterColor:(UIColor *)selectorInterColor
{
    _selectorInterColor = selectorInterColor;
    
    for (id object in self.subviews) {
        if([object isKindOfClass:[UITextField class]])
        {
            UITextField *lable = (UITextField *)object;
            for (id tf in lable.subviews) {
                if([tf isKindOfClass:[UITextField class]])
                {
                    UITextField *textFT = (UITextField *)tf;
                    textFT.backgroundColor = selectorInterColor;
                    textFT.layer.borderColor = selectorInterColor.CGColor;
                }
            }
        }
    }
}

- (UIColor *)selectorOutBorderColor
{
    return _selectorOutBorderColor;
}

- (void)setSelectorOutBorderColor:(UIColor *)selectorOutBorderColor
{
    _selectorOutBorderColor = selectorOutBorderColor;
    for (id object in self.subviews) {
        if([object isKindOfClass:[UITextField class]])
        {
            UITextField *lable = (UITextField *)object;
            lable.layer.borderColor = selectorOutBorderColor.CGColor;
        }
    }
}



- (NSString *)stringOfSelectedString
{
    NSString *string;
    if (!_switchId || !_itemList) {
        string = @"";
    }
    else
    {
        for (int i = 0; i<_itemList.count; i++) {
            if ([_switchId isEqualToString:_itemList[i]]) {
                string = _itemList[i];
            }
        }
    }
    return string;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger i;
    for (id object in textField.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)object;
            i = tf.tag;
            [self setSwitchId:_itemId[i-10]];
           
            @try {
                [_delegate singleSelecotr:self DidSelectAtSelectList:_itemList[i - 10]];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
        }
    }
    
    return  NO;
}

- (void)singleSelecotr:(UISingleSelector *)singleSelector DidSelectAtSelectList:(NSString *)selectString
{
    NSLog(@"%@",selectString);
}

@end
