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
    SampleBaseView *baseView = [[SampleBaseView alloc] initWithFrame:self.view.frame];
    baseView.titleText = @"系统会根据你选择的产品提供采样标准";
    self.view = baseView;
    self.title = @"选择产品";
    productNo = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [addBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
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
            
            SampleStandardChooseViewController_iphone *SSCVC = [[SampleStandardChooseViewController_iphone alloc] init];
            SSCVC.tissueNameArray = [tissueNameArray copy];
            SSCVC.bloodNameArray = [bloodNameArray copy];
            SSCVC.tissueIdArray = [tissueIdArray copy];
            SSCVC.bloodIdArray = [bloodIdArray copy];
            SSCVC.productStr = [productStr copy];
            SSCVC.productNameStr = [productNameStr copy];
            
            [self.navigationController pushViewController:SSCVC animated:YES];
        });
    });
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
