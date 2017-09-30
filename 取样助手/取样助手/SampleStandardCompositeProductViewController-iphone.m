//
//  SampleStandardCompositeProductViewController-iphone.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/28.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardCompositeProductViewController-iphone.h"

@interface SampleStandardCompositeProductViewController_iphone ()
{
    CGFloat orignPoint;
    CGFloat currentHeight;
    NSMutableArray *pointAry;
    UIScrollView *scorollView;
}
@end

@implementation SampleStandardCompositeProductViewController_iphone

- (void)viewDidLoad {
    [super viewDidLoad];
    currentHeight = 0;
    orignPoint = 0;
    pointAry = [[NSMutableArray alloc] init];
    
    SampleBaseView *baseView = [[SampleBaseView alloc] initWithFrame:self.view.frame];
    self.title = @"样本类型";
    baseView.titleText = [NSString stringWithFormat:@"您选择的产品是：%@",_product_name];
    self.view = baseView;
    self.view.backgroundColor = [UIColor whiteColor];
    scorollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100*SCREEN_HEIGHT/667, SCREEN_WEIGHT, 480*SCREEN_HEIGHT/667)];
    
    //循环绘制控件
    for (int i=0; i<_composite_productArray.count; i++) {
        NSArray *infoAry = [_composite_productArray[i] objectForKey:@"sample_info_gather_list"];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15*SCREEN_WEIGHT/375, orignPoint, 100, 15)];
        titleLb.text = [NSString stringWithFormat:@"第%d种",i+1];
        titleLb.textColor = [UIColor colorWithMyNeed:59 green:122 blue:219 alpha:1];
        [scorollView addSubview:titleLb];
        
        for (int j=0; j<infoAry.count; j++) {
            NSArray *unitAry = infoAry[j];
            UILabel *noteLb = [[UILabel alloc] initWithFrame:CGRectMake(30*SCREEN_WEIGHT/375, orignPoint +25,300,15)];
            noteLb.text = @"以下任选其一";
            noteLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
            noteLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
            [scorollView addSubview:noteLb];
            
            for (int k=0; k<unitAry.count; k++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(30*SCREEN_WEIGHT/375 + k%2*160*SCREEN_WEIGHT/375, orignPoint + 50 + k/2*40*SCREEN_HEIGHT/667, 150*SCREEN_WEIGHT/375, 30*SCREEN_HEIGHT/667);
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
                [button setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
                NSString *nameStr = [unitAry[k] objectForKey:@"name"];
                [button setTitle:nameStr forState:UIControlStateNormal];
                NSInteger unitId = [[unitAry[k] objectForKey:@"id"] integerValue];
                
                button.tag = 100 * (i+1) + unitId;
                currentHeight = button.frame.origin.y + 30*SCREEN_HEIGHT/375;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [scorollView addSubview:button];
            }
            orignPoint = currentHeight;
        }
        orignPoint = currentHeight + 20;
        if (i < _composite_productArray.count -1) {
            UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(10, orignPoint-10, SCREEN_WEIGHT-20, 1)];
            lineLb.layer.borderWidth = 1;
            lineLb.layer.borderColor = [UIColor colorWithMyNeed:200 green:200 blue:200 alpha:1].CGColor;
            [scorollView addSubview:lineLb];
        }
    }
    
    scorollView.contentSize = CGSizeMake(SCREEN_WEIGHT, orignPoint + 50);
    
    [self.view addSubview:scorollView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(25*SCREEN_WEIGHT/375, 600*SCREEN_HEIGHT/667, 150*SCREEN_WEIGHT/375, 40);
    [backBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    backBtn.layer.cornerRadius = 10;
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(195*SCREEN_WEIGHT/375, 600*SCREEN_HEIGHT/667, 150*SCREEN_HEIGHT/667, 40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)buttonClick:(UIButton *)sender{
    sender.selected = YES;
    sender.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
    sender.backgroundColor = [UIColor colorWithMyNeed:218 green:236 blue:255 alpha:1];
    NSInteger part = sender.tag/100;
    
    for (id obj in scorollView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            if (button.tag/100 == part) {
                NSDictionary *dic = _composite_productArray[part - 1];
                NSArray *ary = [dic objectForKey:@"sample_gather_list"];
                NSInteger idNo = sender.tag%100;
                for (int i=0; i<ary.count; i++) {
                    NSArray *unitAry = ary[i];
                    for (int j=0; j<unitAry.count; j++) {
                        if (unitAry.count == 1) {
                            UIButton *selectedBtn = (UIButton *)[scorollView viewWithTag:[unitAry[0] integerValue] + 100*part];
                            selectedBtn.selected = YES;
                            selectedBtn.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
                            selectedBtn.backgroundColor = [UIColor colorWithMyNeed:218 green:236 blue:255 alpha:1];
                        }
                        if ([unitAry[j] integerValue] == idNo) {
                            for (NSString *key in unitAry) {
                                if ([key integerValue]!= idNo) {
                                    UIButton *rareBtn = (UIButton* )[scorollView viewWithTag:[key integerValue]+100*part];
                                    rareBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
                                    [rareBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
                                    [rareBtn setBackgroundColor:[UIColor whiteColor]];
                                    rareBtn.selected = NO;
                                }
                            }
                        }                        
                    }
                }
                continue;
            }
            button.selected = NO;
            button.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
            [button setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)backBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtn:(UIButton *)sender{
    NSMutableArray *sampleAry = [[NSMutableArray alloc] init];
    NSMutableDictionary *sampleDic = [[NSMutableDictionary alloc] init];
    for (id obj in scorollView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            if (button.selected && button.tag >0) {
                NSInteger group = button.tag/100;
                NSInteger idNo = button.tag%100;
                NSDictionary *listDic = _composite_productArray[group - 1];
                NSString *transportStr = [listDic objectForKey:@"transport_name"];
                NSArray *gatherListAry = [listDic objectForKey:@"sample_info_gather_list"];
                for (int i=0; i<gatherListAry.count; i++) {
                    NSArray *unitArray = gatherListAry[i];
                    for (int j=0; j<unitArray.count; j++) {
                        NSInteger unitId = [[unitArray[j] objectForKey:@"id"] integerValue];
                        if (unitId == idNo) {
                            NSString *sampleStr = [NSString stringWithFormat:@"%@,%@",[unitArray[j] objectForKey:@"name"],[unitArray[j] objectForKey:@"requirement"]];
                            [sampleDic setObject:sampleStr forKey:@"requirement"];
                            [sampleDic setObject:transportStr forKey:@"transports_str"];
                            [sampleAry addObject:[sampleDic copy]];
                        }
                    }
                }
            }
        }
    }
    if (sampleAry.count == 0) {
        alertMsgView(@"请选择样本组合", self);
        return;
    }
    SampleStandardRequirementViewController_iphone *ssrvc = [[SampleStandardRequirementViewController_iphone alloc] init];
    ssrvc.reuqirementArray = [sampleAry copy];
    ssrvc.productNameStr = _product_name;
    [self.navigationController pushViewController:ssrvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
