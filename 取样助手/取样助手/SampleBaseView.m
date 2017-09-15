//
//  SampleBaseView.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/15.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleBaseView.h"
#import "publicMethod.h"

@implementation SampleBaseView
{
    UITextField *infoTf;
    UILabel *titleLb;
}
@synthesize titleText = _titleText;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        infoTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WEIGHT, 32)];
        infoTf.backgroundColor = [UIColor colorWithMyNeed:250 green:248 blue:216 alpha:1];
        infoTf.enabled = NO;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(34 *SCREEN_WEIGHT/375, 10, 16, 15)];
        UIImage *image = [UIImage imageNamed:@"喇叭"];
        imageView.image = image;
        [infoTf addSubview:imageView];
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(58 *SCREEN_WEIGHT/375, 11, 300 *SCREEN_WEIGHT/375, 13)];
        titleLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        titleLb.textColor = [UIColor colorWithMyNeed:118 green:118 blue:118 alpha:1];
        [infoTf addSubview:titleLb];
        [self addSubview:infoTf];
    }
    return self;
}

- (NSString*)titleText{
    return _titleText;
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    titleLb.text = titleText;
}

@end
