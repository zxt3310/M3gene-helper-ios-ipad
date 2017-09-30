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
    NSInteger productNo;
    UIButton *sigleBtn;
    UIButton *tribleBtn;
    UIView *compositeView;
    UIComboBox *productCb;
    NSInteger currentId;
    NSString *currentProduct;

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
    
    sigleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sigleBtn.frame = CGRectMake(300*SCREEN_WEIGHT/1024,
                                280*SCREEN_HEIGHT/768,
                                200*SCREEN_WEIGHT/1024, 40);
    sigleBtn.layer.borderWidth = 1;
    sigleBtn.layer.borderColor = [UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1].CGColor;
    [sigleBtn setTitle:@"单检测产品" forState:UIControlStateNormal];
    [sigleBtn setTitleColor:[UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1] forState:UIControlStateNormal];
    sigleBtn.layer.cornerRadius = 20;
    sigleBtn.selected = YES;
    [sigleBtn addTarget:self action:@selector(singleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sigleBtn];
    
    tribleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tribleBtn.frame = CGRectMake(510*SCREEN_WEIGHT/1024,
                                 280*SCREEN_HEIGHT/768,
                                 200*SCREEN_WEIGHT/1024, 40);
    tribleBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
    tribleBtn.layer.borderWidth = 1;
    tribleBtn.layer.cornerRadius = 20;
    [tribleBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
    [tribleBtn setTitle:@"组合检测产品" forState:UIControlStateNormal];
    [tribleBtn addTarget:self action:@selector(tribleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tribleBtn];
    tribleBtn.titleLabel.font = sigleBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    productCb = [[UIComboBox alloc] initWithFrame:CGRectMake(338*SCREEN_WEIGHT/1024,
                                                                        377*SCREEN_HEIGHT/768,
                                                                        316*SCREEN_WEIGHT/1024,
                                                                        50)];
    productCb.placeColor = [UIColor colorWithMyNeed:155 green:155 blue:155 alpha:1];
    productCb.textColor = [UIColor blackColor];
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
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    
    addBtn.hidden = YES;
    
    compositeView = [[UIView alloc] initWithFrame:CGRectMake(0, 300*SCREEN_HEIGHT/667, SCREEN_WEIGHT, 200*SCREEN_HEIGHT/667)];
    for (int i=0; i<_composite_prouductList.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(70*SCREEN_HEIGHT/375 + i%2*142*SCREEN_WEIGHT/375,1+i/2*100*SCREEN_HEIGHT/667, 122*SCREEN_WEIGHT/375, 80*SCREEN_HEIGHT/667);
        NSInteger tagId = [[_composite_prouductList[i] objectForKey:@"id"] integerValue];
        button.tag = tagId + 100;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
        NSString *titleStr = [_composite_prouductList[i] objectForKey:@"name"];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(composite_btn_click:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.numberOfLines = 0;
        [compositeView addSubview:button];
    }
    compositeView.hidden = YES;
    [self.view addSubview:compositeView];

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

- (void)composite_btn_click:(UIButton *)sender{
    sender.selected = YES;
    sender.layer.borderColor = [UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1].CGColor;
    [sender setTitleColor:[UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1] forState:UIControlStateNormal];
    for (id obj in compositeView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *object = (UIButton *) obj;
            if (object.tag != sender.tag) {
                object.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
                [object setTitleColor:[UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1] forState:UIControlStateNormal];
            }
        }
    }
    currentId = sender.tag - 100;
    currentProduct = sender.titleLabel.text;
}

- (void)singleBtnEvent:(UIButton *) sender{
    sender.selected = YES;
    tribleBtn.selected = NO;
    
    sender.layer.borderColor = [UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1].CGColor;
    [sender setTitleColor:[UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1] forState:UIControlStateNormal];
    
    tribleBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
    [tribleBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
    compositeView.hidden = YES;
    productCb.hidden = NO;
    [productCb dismissTable];
}

- (void)tribleBtnEvent:(UIButton *) sender{
    sender.selected = YES;
    sigleBtn.selected = NO;
    
    sender.layer.borderColor = [UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1].CGColor;
    [sender setTitleColor:[UIColor colorWithMyNeed:0 green:102 blue:51 alpha:1] forState:UIControlStateNormal];
    
    sigleBtn.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
    [sigleBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
    productCb.hidden = YES;
    compositeView.hidden = NO;
    [productCb dismissTable];
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
    if (productNo > 1){
        alertMsgView(@"产品个数已达上限", self);
        return;
    }
    UIComboBox *productCbox = [[UIComboBox alloc] initWithFrame:CGRectMake(298*SCREEN_WEIGHT/1024,
                                                                         357*SCREEN_HEIGHT/768 + productNo * (50 + 25*SCREEN_HEIGHT/768),
                                                                         316*SCREEN_WEIGHT/1024,
                                                                         50)];
    productCbox.placeColor = [UIColor colorWithMyNeed:155 green:155 blue:155 alpha:1];
    productCbox.textColor = [UIColor blackColor];
    productCbox.comboList = productNameAry;
    [self.view addSubview:productCbox];
    productNo++;
    productCb.tag = productNo+oringTag;
    NSLog(@"%ld",productCb.tag);
}

- (void)nextBtn:(UIButton *)sender{
    if (sigleBtn.selected == YES) {
        NSMutableString *productStr = [[NSMutableString alloc] init];
        NSMutableString *productNameStr = [[NSMutableString alloc] init];
        for (id obj in self.view.subviews) {
            if ([obj isKindOfClass:[UIComboBox class]]) {
                UIComboBox *object = (UIComboBox *)obj;
                NSInteger selectNo = object.selectId;
                if (selectNo<0) {
                    continue;
                }
                [productStr appendFormat:@",%@", productIdAry[selectNo]];
                [productNameStr appendFormat:@",%@",productNameAry[selectNo]];
            }
        }
        if (productStr.length >0) {
            [productStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            [productNameStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        else{
            alertMsgView(@"请至少选择一个产品", self);
            return;
        }
        
        NSArray *checkArray = [productStr componentsSeparatedByString:@","];
        for (int j=0;j<checkArray.count;j++) {
            for (int i=0; i<checkArray.count; i++) {
                if ([checkArray[j] isEqual:checkArray[i]]) {
                    if (i!=j) {
                        alertMsgView(@"请勿选择相同产品", self);
                        return;
                    }
                }
            }
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?product_ids=%@",SearchAllSample,[productStr copy]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *response = sendGETRequest(urlStr, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!response) {
                    alertMsgView(@"网络错误", self);
                    NSLog(@"network was faild");
                    return ;
                }
                
                NSDictionary *returnDic = parseJsonResponse(response);
                if (!returnDic) {
                    alertMsgView(@"返回数据错误", self);
                    NSLog(@"converse to NSDictionary faild, data error");
                    return;
                }
                
                NSNumber *result = [returnDic objectForKey:@"err"];
                if (!result) {
                    alertMsgView(@"返回数据错误", self);
                    NSLog(@"result is NULL");
                    return;
                }
                
                if ([result integerValue] != 0) {
                    alertMsgView([returnDic objectForKey:@"errmsg"], self);
                    NSLog(@"result error!");
                    return;
                }
                
                NSArray *dataArray = [returnDic objectForKey:@"data"];
                NSMutableArray *tissueNameArray = [[NSMutableArray alloc] init];
                NSMutableArray *tissueIdArray = [[NSMutableArray alloc] init];
                NSMutableArray *bloodNameArray = [[NSMutableArray alloc] init];
                NSMutableArray *bloodIdArray = [[NSMutableArray alloc] init];
                
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dic = (NSDictionary *)dataArray[i];
                    NSString *idStr = [dic objectForKey:@"id"];
                    NSString *nameStr = [dic objectForKey:@"name"];
                    NSNumber *type = [dic objectForKey:@"type"];
                    if ([type integerValue] == 1) {
                        [tissueNameArray addObject:nameStr];
                        [tissueIdArray addObject:idStr];
                        continue;
                    }
                    [bloodNameArray addObject:nameStr];
                    [bloodIdArray addObject:idStr];
                }
                
                SampleStandardChooseViewController_ipad *SSCVC = [[SampleStandardChooseViewController_ipad alloc] init];
                SSCVC.tissueNameArray = [tissueNameArray copy];
                SSCVC.bloodNameArray = [bloodNameArray copy];
                SSCVC.tissueIdArray = [tissueIdArray copy];
                SSCVC.bloodIdArray = [bloodIdArray copy];
                SSCVC.productStr = [productStr copy];
                SSCVC.productNameStr = [productNameStr copy];
                SSCVC.connectDic = [returnDic objectForKey:@"sample_alsoids_map"];
                
                [self.navigationController pushViewController:SSCVC animated:YES];
            });
        });
    }
    else{
        NSString *urlStr = [NSString stringWithFormat:@"%@/info?composite_product_id=%ld",Compoite_product,currentId];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *response = sendGETRequest(urlStr, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!response) {
                    alertMsgView(@"网络错误", self);
                    NSLog(@"network was faild");
                    return ;
                }
                
                NSDictionary *returnDic = parseJsonResponse(response);
                if (!returnDic) {
                    alertMsgView(@"返回数据错误", self);
                    NSLog(@"converse to NSDictionary faild, data error");
                    return;
                }
                
                NSNumber *result = [returnDic objectForKey:@"err"];
                if (!result) {
                    alertMsgView(@"返回数据错误", self);
                    NSLog(@"result is NULL");
                    return;
                }
                
                if ([result integerValue] != 0) {
                    alertMsgView([returnDic objectForKey:@"errmsg"], self);
                    NSLog(@"result error!");
                    return;
                }
                SampleStandardCompositeProductViewController_ipad *SCPVC = [[SampleStandardCompositeProductViewController_ipad alloc] init];
                SCPVC.composite_productArray = [returnDic objectForKey:@"pst_cpsrt_list"];
                SCPVC.product_name = currentProduct;
                [self.navigationController pushViewController:SCPVC animated:YES];
            });
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIComboBox class]]) {
            UIComboBox *object  = (UIComboBox *) obj;
            [object dismissTable];
        }
    }
}

@end
