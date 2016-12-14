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
        self.text = text;
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
        self.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
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
    contentLable *titleLb = [[contentLable alloc] initWithFrame:[self caculateFrameY:11 isLeft:YES isLable:YES]  andText:@"检验单录入"];
    [self addSubview:titleLb];
    //分割线
    contentLable *tag1 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"送检信息"];
    UITextField *blue1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue1.enabled = NO;
    blue1.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue1 addSubview:tag1];
    [self addSubview:blue1];
    
    //送检样本
    contentLable *SJYBlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:YES] andText:@"送检样本"];
    [self addSubview:SJYBlb];
    contentTF *SJYBtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:NO]];
    SJYBtf.text = _SJYB;
    [self addSubview:SJYBtf];
    //订单编号
    contentLable *DDBHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:YES] andText:@"送检编号"];
    [self addSubview:DDBHlb];
    contentTF *DDBHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:NO]];
    DDBHtf.text = _DDBH;
    [self addSubview:DDBHtf];
    
    
    //采集日期
    contentLable *CJRQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:168 isLeft:YES isLable:YES] andText:@"采集日期"];
    [self addSubview:CJRQlb];
    contentTF *CJRQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:168 isLeft:YES isLable:NO]];
    CJRQtf.text = _CJRQ;
    
    //分割线
    contentLable *tag2 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"受检人信息"];
    UITextField *blue2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 207, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue2.enabled = NO;
    blue2.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue2 addSubview:tag2];
    [self addSubview:blue2];
    
    //姓名
    contentLable *XMlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 isLeft:YES isLable:YES] andText:@"姓    名"];
    [self addSubview:XMlb];
    contentTF *XMtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 isLeft:YES isLable:NO]];
    XMtf.text = _NAME;
    [self addSubview:XMtf];
    //身份证号
    contentLable *SFZHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 isLeft:NO isLable:YES] andText:@"身份证号"];
    [self addSubview:SFZHlb];
    contentTF *SFZHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 isLeft:NO isLable:NO]];
    SFZHtf.text = _SFZH;
    [self addSubview:SFZHtf];
    
    
    //联系电话
    contentLable *LXDHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:292 isLeft:YES isLable:YES] andText:@"联系电话"];
    [self addSubview:LXDHlb];
    contentTF *LXDHtf  = [[contentTF alloc] initWithFrame:[self caculateFrameY:292 isLeft:YES isLable:NO]];
    LXDHtf.text = _LXDH;
    [self addSubview:LXDHtf];
    //报告寄送地址
    contentLable *BGJSDZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:292 isLeft:NO isLable:YES] andText:@"报告寄送地址"];
    [self addSubview:BGJSDZlb];
    contentTF *BGJSDZtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:292 isLeft:NO isLable:NO]];
    BGJSDZtf.text = _JSDZ;
    [self addSubview:BGJSDZtf];
    
    
    //出生日期
    contentLable *CSRQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:325 isLeft:YES isLable:YES] andText:@"出生日期"];
    [self addSubview:CSRQlb];
    contentTF *CSRQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:325 isLeft:YES isLable:NO]];
    CSRQtf.text = _CSRQ;
    [self addSubview:CSRQtf];
    
    
    //民族
    contentLable *MZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:361 isLeft:YES isLable:YES] andText:@"民族"];

    
    
}



//计算纵向位置
- (CGRect)caculateFrameY:(CGFloat)y isLeft:(BOOL)isLeft isLable:(BOOL)isLable
{
    CGRect currentFrame;
    CGRect lbLeftFrame = CGRectMake(50*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768, 90, 20);
    CGRect lbRightFrame = CGRectMake(357*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768,90 ,20);
    CGRect tfLeftFrame = CGRectMake(146*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768, 188, 22);
    CGRect tfRightFrame = CGRectMake(452*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768, 188, 22);
    if(isLeft)
    {
        if(isLable)
        {
            currentFrame = lbLeftFrame;
        }
        else
        {
            currentFrame = tfLeftFrame;
        }
    }
    else
    {
        if (isLable)
        {
            currentFrame = lbRightFrame;
        }
        else
        {
            currentFrame = tfRightFrame;
        }
    }
    
    return currentFrame;
}
@end
