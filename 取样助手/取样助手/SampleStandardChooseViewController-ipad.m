//
//  SampleStandardChooseViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/8.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardChooseViewController-ipad.h"
#define orign_Tag

@interface unitLableView : UIView
@property (nonatomic) NSString *titleText;
@end
@implementation unitLableView
{
    UILabel *titleLb;
}
@synthesize titleText = _titleText;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *tagFiled = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              25*SCREEN_WEIGHT/1024,
                                                                              25*SCREEN_WEIGHT/1024)];
        tagFiled.layer.cornerRadius = tagFiled.frame.size.width/2;
        tagFiled.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
        tagFiled.enabled = NO;
        [self addSubview:tagFiled];
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(45 * SCREEN_WEIGHT/1024,
                                                                     1.5 *SCREEN_HEIGHT/768,
                                                                     44*SCREEN_WEIGHT/1024,
                                                                     22*SCREEN_HEIGHT/768)];
        titleLb.textColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
        titleLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:22];
        [self addSubview:titleLb];
    }
    return self;
}

- (NSString *)titleText{
    return _titleText;
}
- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    titleLb.text = titleText;
}

@end

@interface SampleStandardChooseViewController_ipad ()
{
    int x;
    int y;
}
@end

@implementation SampleStandardChooseViewController_ipad

- (instancetype)init{
    self = [super init];
    if (self) {
        x=0;
        y=0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNewBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 131*SCREEN_HEIGHT/768,
                                                                 SCREEN_WEIGHT,
                                                                 22)];
    titleLb.text = @"";
    titleLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:22];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    [self.view addSubview:titleLb];
    
    UILabel *noteLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                175*SCREEN_HEIGHT/768,
                                                                SCREEN_WEIGHT,
                                                                18)];
    noteLb.textAlignment = NSTextAlignmentCenter;
    noteLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    noteLb.text = @"共有11种样本类型采集方式，请选择患者能提供的任意一种样本类型查看采集标准";
    noteLb.textColor = [UIColor colorWithMyNeed:118 green:118 blue:118 alpha:1];
    [self.view addSubview:noteLb];
    
    unitLableView *zjView = [[unitLableView alloc] initWithFrame:CGRectMake(70*SCREEN_WEIGHT/1024,
                                                                           223*SCREEN_HEIGHT/768,
                                                                            200*SCREEN_WEIGHT/1024,
                                                                            25)];
    zjView.titleText = @"组织";
    [self.view addSubview:zjView];
    
    unitLableView *xyView = [[unitLableView alloc] initWithFrame:CGRectMake(70*SCREEN_WEIGHT/1024,
                                                                            540*SCREEN_HEIGHT/768,
                                                                            200*SCREEN_WEIGHT/1024,
                                                                            25)];
    xyView.titleText = @"血液";
    [self.view addSubview:xyView];
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               498*SCREEN_HEIGHT/768,
                                                               SCREEN_WEIGHT,
                                                                12)];
    lineLb.backgroundColor = [UIColor colorWithMyNeed:188 green:188 blue:188 alpha:1];
    [self.view addSubview:lineLb];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(751*SCREEN_WEIGHT/1024,
                               682*SCREEN_HEIGHT/768,
                               180*SCREEN_WEIGHT/1024,
                               55);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    for (int i=0; i<_tissueAry.count; i++) {
        UIButton *tissueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tissueBtn.frame = CGRectMake(73*SCREEN_WEIGHT/1024 + x%4 * 238*SCREEN_WEIGHT/1024,
                                     278*SCREEN_HEIGHT/768 + y/4 * 55 *SCREEN_HEIGHT/768,
                                     160*SCREEN_WEIGHT/1024,
                                     45);
        [tissueBtn setTitle:_tissueAry[i] forState:UIControlStateNormal];
        [tissueBtn setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview: tissueBtn];
        
        x++;
        y++;
    }

}

- (void)tissuBtn:(UIButton *)sender{
    
}

- (void)setNewBar
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 101)];
    header.layer.shadowColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
    header.layer.shadowRadius = 4;
    header.layer.shadowOpacity = 1;
    header.layer.shadowOffset = CGSizeMake(0, 1);
    
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:header.frame];
    backimg.backgroundColor = [UIColor whiteColor];
    header.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.5].CGColor;
    header.layer.borderWidth = 0;
    [self.view addSubview:header];
    [header addSubview:backimg];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateHighlighted];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 8)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    CGRect rect = backBtn.frame;
    rect.origin.x = 30;
    rect.origin.y = 35;
    rect.size.height = 65;
    rect.size.width = 60;
    backBtn.frame = rect;
    [header addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width + 16, 32, SCREEN_WEIGHT - (rect.size.width+8) * 2, 44)];
    titleLabel.text = @"样本标准";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36];// boldSystemFontOfSize:36];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtn:(UIButton *)sender{
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
