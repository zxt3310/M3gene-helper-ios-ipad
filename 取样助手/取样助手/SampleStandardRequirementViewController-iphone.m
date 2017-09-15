//
//  SampleStandardRequirementViewController-iphone.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/15.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardRequirementViewController-iphone.h"

@interface SampleStandardRequirementViewController_iphone ()
{
    int x;
}
@end

@implementation SampleStandardRequirementViewController_iphone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"采集标准和运输条件";
    x=0;
    SampleBaseView *baseView = [[SampleBaseView alloc] initWithFrame:self.view.frame];
    baseView.titleText = [NSString stringWithFormat:@"您选择的产品是：%@",_productNameStr];
    self.view = baseView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *ditailLb = [[UILabel alloc] initWithFrame:CGRectMake(35*SCREEN_WEIGHT/375, 154*SCREEN_HEIGHT/667, 257*SCREEN_WEIGHT/375, 58)];
    UILabel *requireLable = [[UILabel alloc] initWithFrame:CGRectMake(35*SCREEN_WEIGHT/375, 154*SCREEN_HEIGHT/667, 152*SCREEN_WEIGHT/375, 40)];
    UILabel *trasportLble = [[UILabel alloc] initWithFrame:CGRectMake(186*SCREEN_WEIGHT/375, 154*SCREEN_HEIGHT/667, 152*SCREEN_WEIGHT/375, 40)];
    requireLable.text = @"采样标准";
    trasportLble.text = @"运输标准";
    ditailLb.text = @"样本名称";
    trasportLble.font = requireLable.font = ditailLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    trasportLble.textColor = requireLable.textColor = ditailLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    trasportLble.layer.borderWidth = requireLable.layer.borderWidth = ditailLb.layer.borderWidth =1;
    trasportLble.layer.borderColor = requireLable.layer.borderColor = ditailLb.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
    trasportLble.backgroundColor = requireLable.backgroundColor = ditailLb.backgroundColor = [UIColor colorWithMyNeed:218 green:235 blue:255 alpha:1];
    trasportLble.textAlignment = requireLable.textAlignment = ditailLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:requireLable];
    [self.view addSubview:trasportLble];
    //[self.view addSubview:ditailLb];
    
    
    for (int i=0; i<_reuqirementArray.count; i++) {
        UILabel *ditailLable = [[UILabel alloc] initWithFrame:CGRectMake(127*SCREEN_WEIGHT/1024, 323*SCREEN_HEIGHT/768 + i*99,257*SCREEN_WEIGHT/1024 ,100)];
        UILabel *requirementLb = [[UILabel alloc] initWithFrame:CGRectMake(35*SCREEN_WEIGHT/375, 193*SCREEN_HEIGHT/667 + i*79, 152*SCREEN_WEIGHT/375, 80)];
        UILabel *transportLb = [[UILabel alloc] initWithFrame:CGRectMake(186*SCREEN_WEIGHT/375, 193*SCREEN_HEIGHT/667 + i*79, 152*SCREEN_WEIGHT/375, 80)];
        requirementLb.font = transportLb.font = ditailLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
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
    doneBtn.frame = CGRectMake(34*SCREEN_WEIGHT/375, 602*SCREEN_HEIGHT/667, 134*SCREEN_WEIGHT/375, 40);
    
    UIButton *reChosseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reChosseBtn.frame = CGRectMake(207*SCREEN_WEIGHT/375, 602*SCREEN_HEIGHT/667, 134*SCREEN_WEIGHT/375, 40);
    
    doneBtn.backgroundColor = reChosseBtn.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    doneBtn.tintColor = reChosseBtn.tintColor = [UIColor whiteColor];
    doneBtn.layer.cornerRadius = reChosseBtn.layer.cornerRadius = 10;
    doneBtn.titleLabel.font = reChosseBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
    [doneBtn setTitle:@"好的，我明白了" forState:UIControlStateNormal];
    [reChosseBtn setTitle:@"重新选择" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(popBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [reChosseBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [self.view addSubview:reChosseBtn];
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
