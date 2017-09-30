//
//  SampleStandardCompositeProductViewController-ipad.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/30.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardCompositeProductViewController-ipad.h"

@interface SampleStandardCompositeProductViewController_ipad ()
{
    CGFloat orignPoint;
    CGFloat currentHeight;
    NSMutableArray *pointAry;
    UIScrollView *scorollView;

}
@end

@implementation SampleStandardCompositeProductViewController_ipad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNewBar];
    currentHeight = 0;
    orignPoint = 0;
    pointAry = [[NSMutableArray alloc] init];
    
   // SampleBaseView *baseView = [[SampleBaseView alloc] initWithFrame:self.view.frame];
    self.title = @"样本类型";
    //baseView.titleText = [NSString stringWithFormat:@"您选择的产品是：%@",_product_name];
    //self.view = baseView;
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
    nextBtn.frame = CGRectMake(195*SCREEN_WEIGHT/375, 600*SCREEN_HEIGHT/667, 150*SCREEN_WEIGHT/375, 40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
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
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    SampleStandardRequirementViewController *ssrvc = [[SampleStandardRequirementViewController alloc] init];
    ssrvc.reuqirementArray = [sampleAry copy];
    ssrvc.productNameStr = _product_name;
    [self.navigationController pushViewController:ssrvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
