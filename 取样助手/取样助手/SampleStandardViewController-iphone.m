//
//  SampleStandardViewController-iphone.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/11.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardViewController-iphone.h"

@interface SampleStandardViewController_iphone ()
{
    NSArray *productNameAry;
    NSArray *productIdAry;
    NSInteger productNo;
}
@end
#define oringTag 100;
@implementation SampleStandardViewController_iphone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择产品";
    productNo = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
//                                                                 166*SCREEN_HEIGHT/768,
//                                                                 SCREEN_WEIGHT,
//                                                                 22)];
//    titleLb.text = @"请选择检测产品";
//    titleLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:22];
//    titleLb.textAlignment = NSTextAlignmentCenter;
//    titleLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
//    [self.view addSubview:titleLb];
//    
//    UILabel *noteLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
//                                                                210*SCREEN_HEIGHT/768,
//                                                                SCREEN_WEIGHT,
//                                                                18)];
//    noteLb.textAlignment = NSTextAlignmentCenter;
//    noteLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
//    noteLb.text = @"系统会根据你选择的产品提供取样标准";
//    noteLb.textColor = [UIColor colorWithMyNeed:118 green:118 blue:118 alpha:1];
//    [self.view addSubview:noteLb];
    
    UIComboBox *productCb = [[UIComboBox alloc] initWithFrame:CGRectMake(60*SCREEN_WEIGHT/375,
                                                                         157*SCREEN_HEIGHT/667,
                                                                         188*SCREEN_WEIGHT/375,
                                                                         33)];
    productCb.placeColor = [UIColor colorWithMyNeed:155 green:155 blue:155 alpha:1];
    productCb.textColor = [UIColor blackColor];
    productCb.tag = oringTag;
    [self.view addSubview:productCb];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(282*SCREEN_WEIGHT/375,
                              157*SCREEN_HEIGHT/667,
                              33,
                              33);
    addBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
    addBtn.layer.cornerRadius = 16.5;
    addBtn.layer.borderWidth = 2;
    [addBtn setImage:[UIImage imageNamed:@"adder"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addProductBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(139*SCREEN_WEIGHT/375,
                               553*SCREEN_HEIGHT/667,
                               100*SCREEN_WEIGHT/375,
                               40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    if (_productAry) {
        NSMutableArray *namelistAry = [[NSMutableArray alloc] init];
        NSMutableArray *idListAry = [[NSMutableArray alloc] init];
        for (int i=0; i<_productAry.count; i++) {
            NSDictionary *dic = _productAry[i];
            NSString *name = [dic objectForKey:@"name"];
            NSString *Id = [dic objectForKey:@"id"];
            [namelistAry addObject:name];
            [idListAry addObject:Id];
        }
        productIdAry = [idListAry copy];
        productNameAry = [namelistAry copy];
        productCb.comboList = productNameAry;
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
   
}

- (void)addProductBtn:(UIButton *)sender{
    if (productNo > 1){
        alertMsgView(@"产品个数已达上限", self);
        return;
    }
    UIComboBox *productCb = [[UIComboBox alloc] initWithFrame:CGRectMake(60*SCREEN_WEIGHT/375,
                                                                         210*SCREEN_HEIGHT/667 + productNo * (33 + 20*SCREEN_HEIGHT/768),
                                                                         188*SCREEN_WEIGHT/375,
                                                                         33)];
    productCb.placeColor = [UIColor colorWithMyNeed:155 green:155 blue:155 alpha:1];
    productCb.textColor = [UIColor blackColor];
    productCb.comboList = productNameAry;
    [self.view addSubview:productCb];
    productNo++;
    productCb.tag = productNo+oringTag;
    NSLog(@"%ld",productCb.tag);
}

- (void)nextBtn:(UIButton *)sender{
    SampleStandardChooseViewController_iphone *SSCVC = [[SampleStandardChooseViewController_iphone alloc] init];
    [self.navigationController pushViewController:SSCVC animated:YES];
}

@end
