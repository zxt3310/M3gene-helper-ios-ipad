//
//  registView.m
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "registView.h"

@interface contentLable : UILabel

@end
@implementation contentLable
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = (text.length + 1)*18;
        temp.size.height = 22;
        self.frame = temp;
        
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        self.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        
    }
    return self;
}

@end

@interface contentTF : UITextField

@end
@implementation contentTF

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = 188*SCREEN_WEIGHT/1024;
        temp.size.height = 22;
        self.frame = temp;
        
        self.textColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    }
    return self;
}

@end



@implementation registViewNew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

- (void)show
{
    
}

@end
