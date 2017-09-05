//
//  SampleStandardViewController-ipad.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/5.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardViewController-ipad.h"
#define oringTag 100;
@interface SampleStandardViewController_ipad ()
{
    NSArray *productNameAry;
    NSArray *productIdAry;
    int productNo;
}
@end

@implementation SampleStandardViewController_ipad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    productNo = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 166*SCREEN_HEIGHT/768,
                                                                 SCREEN_WEIGHT,
                                                                 22)];
    titleLb.text = @"请选择检测产品";
    titleLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:22];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    [self.view addSubview:titleLb];
    
    UILabel *noteLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                210*SCREEN_HEIGHT/768,
                                                                SCREEN_WEIGHT,
                                                                18)];
    noteLb.textAlignment = NSTextAlignmentCenter;
    noteLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    noteLb.text = @"系统会根据你选择的产品提供取样标准";
    noteLb.textColor = [UIColor colorWithMyNeed:118 green:118 blue:118 alpha:1];
    [self.view addSubview:noteLb];
    
    UIComboBox *productCb = [[UIComboBox alloc] initWithFrame:CGRectMake(298*SCREEN_WEIGHT/1024,
                                                                        277*SCREEN_HEIGHT/768,
                                                                        316*SCREEN_WEIGHT/1024,
                                                                        50)];
    productCb.tag = oringTag;
    [self.view addSubview:productCb];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(666*SCREEN_WEIGHT/1024,
                              279*SCREEN_HEIGHT/768,
                              50,
                              50);
    addBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
    addBtn.layer.cornerRadius = 25;
    addBtn.layer.borderWidth = 2;
    [addBtn setImage:[UIImage imageNamed:@"adder"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addProductBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(422*SCREEN_WEIGHT/1024,
                               648*SCREEN_HEIGHT/768,
                               180*SCREEN_WEIGHT/1024,
                               55);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [self.view addSubview:nextBtn];
    
    [self setNewBar];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)addProductBtn:(UIButton *)sender{
    UIComboBox *productCb = [[UIComboBox alloc] initWithFrame:CGRectMake(298*SCREEN_WEIGHT/1024,
                                                                         357*SCREEN_HEIGHT/768 + productNo * (50 + 25*SCREEN_HEIGHT/768),
                                                                         316*SCREEN_WEIGHT/1024,
                                                                         50)];
    productCb.comboList = productNameAry;
    [self.view addSubview:productCb];
    productNo++;
    productCb.tag = oringTag + productNo;
}

@end
