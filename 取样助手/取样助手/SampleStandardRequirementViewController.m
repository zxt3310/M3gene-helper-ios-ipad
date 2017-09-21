//
//  SampleStandardRequirementViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/13.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardRequirementViewController.h"
#import "publicMethod.h"

@interface SampleStandardRequirementViewController ()
{
    int x;
}
@end

@implementation SampleStandardRequirementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    x=0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNewBar];
    
    UILabel *titleProductLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 161*SCREEN_HEIGHT/768,SCREEN_WEIGHT, 22)];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 185*SCREEN_HEIGHT/768, SCREEN_WEIGHT, 22)];
    titleLb.font = titleProductLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:22];
    titleLb.textColor = titleProductLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    titleLb.text = @"样本采集标准和样本运输标准";
    titleProductLb.text = _productNameStr;
    titleLb.textAlignment = titleProductLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleProductLb];
    [self.view addSubview:titleLb];
    
    UILabel *ditailLb = [[UILabel alloc] initWithFrame:CGRectMake(127*SCREEN_WEIGHT/1024, 267*SCREEN_HEIGHT/768, 257*SCREEN_WEIGHT/1024, 58)];
    UILabel *requireLable = [[UILabel alloc] initWithFrame:CGRectMake(127*SCREEN_WEIGHT/1024, 267*SCREEN_HEIGHT/768, 385*SCREEN_WEIGHT/1024, 58)];
    UILabel *trasportLble = [[UILabel alloc] initWithFrame:CGRectMake(511*SCREEN_WEIGHT/1024, 267*SCREEN_HEIGHT/768, 385*SCREEN_WEIGHT/1024, 58)];
    requireLable.text = @"采样标准";
    trasportLble.text = @"运输标准";
    ditailLb.text = @"样本名称";
    trasportLble.font = requireLable.font = ditailLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    trasportLble.textColor = requireLable.textColor = ditailLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    trasportLble.layer.borderWidth = requireLable.layer.borderWidth = ditailLb.layer.borderWidth =1;
    trasportLble.layer.borderColor = requireLable.layer.borderColor = ditailLb.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
    trasportLble.backgroundColor = requireLable.backgroundColor = ditailLb.backgroundColor = [UIColor colorWithMyNeed:218 green:235 blue:255 alpha:1];
    trasportLble.textAlignment = requireLable.textAlignment = ditailLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:requireLable];
    [self.view addSubview:trasportLble];
    //[self.view addSubview:ditailLb];
    
    
    for (int i=0; i<_reuqirementArray.count; i++) {
        UILabel *ditailLable = [[UILabel alloc] initWithFrame:CGRectMake(127*SCREEN_WEIGHT/1024, 324*SCREEN_HEIGHT/768 + i*99,257*SCREEN_WEIGHT/1024 ,100)];
        UILabel *requirementLb = [[UILabel alloc] initWithFrame:CGRectMake(127*SCREEN_WEIGHT/1024, 324*SCREEN_HEIGHT/768 + i*99, 385*SCREEN_WEIGHT/1024, 100)];
        UILabel *transportLb = [[UILabel alloc] initWithFrame:CGRectMake(511*SCREEN_WEIGHT/1024, 324*SCREEN_HEIGHT/768 + i*99, 385*SCREEN_WEIGHT/1024, 100)];
        requirementLb.font = transportLb.font = ditailLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        requirementLb.textColor = transportLb.textColor = ditailLable.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        requirementLb.layer.borderWidth = transportLb.layer.borderWidth = ditailLable.layer.borderWidth = 1;
        requirementLb.layer.borderColor = transportLb.layer.borderColor = ditailLable.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
        requirementLb.textAlignment = transportLb.textAlignment = ditailLable.textAlignment = NSTextAlignmentCenter;
        requirementLb.numberOfLines = transportLb.numberOfLines = ditailLable.numberOfLines = 0;
        requirementLb.text = [_reuqirementArray[i] objectForKey:@"requirement"];
        transportLb.text = [_reuqirementArray[i] objectForKey:@"transports_str"];
        [self.view addSubview:requirementLb];
        [self.view addSubview:transportLb];
        //[self.view addSubview:ditailLable];
    }
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(127*SCREEN_WEIGHT/1024, 640*SCREEN_HEIGHT/768, 241*SCREEN_WEIGHT/1024, 55);
    
    UIButton *reChosseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reChosseBtn.frame = CGRectMake(656*SCREEN_WEIGHT/1024, 640*SCREEN_HEIGHT/768, 241*SCREEN_WEIGHT/1024, 55);
    
    doneBtn.backgroundColor = reChosseBtn.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    doneBtn.tintColor = reChosseBtn.tintColor = [UIColor whiteColor];
    doneBtn.layer.cornerRadius = reChosseBtn.layer.cornerRadius = 10;
    //doneBtn.titleLabel.font = reChosseBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
    [doneBtn setTitle:@"好的，我明白了" forState:UIControlStateNormal];
    [reChosseBtn setTitle:@"重新选择" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(popBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [reChosseBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [self.view addSubview:reChosseBtn];
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

- (void)popBtnEvent:(UIButton *) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
