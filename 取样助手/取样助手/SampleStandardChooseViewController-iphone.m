//
//  SampleStandardChooseViewController-iphone.m
//  取样助手
//
//  Created by Zxt3310 on 2017/9/11.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "SampleStandardChooseViewController-iphone.h"

#define orign_Tag

@interface unitLableView_iphone : UIView
@property (nonatomic) NSString *titleText;
@end
@implementation unitLableView_iphone
{
    UILabel *titleLb;
}
@synthesize titleText = _titleText;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *tagFiled = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                              1.5,
                                                                              10*SCREEN_WEIGHT/375,
                                                                              10*SCREEN_WEIGHT/375)];
        tagFiled.layer.cornerRadius = tagFiled.frame.size.width/2;
        tagFiled.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
        tagFiled.enabled = NO;
        [self addSubview:tagFiled];
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(25 * SCREEN_WEIGHT/375,
                                                            0,
                                                            100*SCREEN_WEIGHT/375,
                                                            14*SCREEN_HEIGHT/667)];
        titleLb.textColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
        titleLb.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
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

@interface SampleStandardChooseViewController_iphone ()
{
    int x;
    int y;
}
@end

@implementation SampleStandardChooseViewController_iphone

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
    SampleBaseView *baseView = [[SampleBaseView alloc] initWithFrame:self.view.frame];
    baseView.titleText = [NSString stringWithFormat:@"你选择的产品是：%@",_productNameStr];
    self.view = baseView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"样本类型";
    
    unitLableView_iphone *zjView = [[unitLableView_iphone alloc] initWithFrame:CGRectMake(32*SCREEN_WEIGHT/375,
                                                                            131*SCREEN_HEIGHT/667,
                                                                            200*SCREEN_WEIGHT/375,
                                                                            15)];
    zjView.titleText = @"组织";
    [self.view addSubview:zjView];
    
    unitLableView_iphone *xyView = [[unitLableView_iphone alloc] initWithFrame:CGRectMake(32*SCREEN_WEIGHT/375,
                                                                            509*SCREEN_HEIGHT/667,
                                                                            200*SCREEN_WEIGHT/1024,
                                                                            15)];
    xyView.titleText = @"血液";
    [self.view addSubview:xyView];
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                485*SCREEN_HEIGHT/667,
                                                                SCREEN_WEIGHT,
                                                                10)];
    lineLb.backgroundColor = [UIColor colorWithMyNeed:188 green:188 blue:188 alpha:1];
    [self.view addSubview:lineLb];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(241*SCREEN_WEIGHT/375,
                               602*SCREEN_HEIGHT/667,
                               100*SCREEN_WEIGHT/375,
                               40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    [nextBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastBtn.frame = CGRectMake(34*SCREEN_WEIGHT/375,
                               602*SCREEN_HEIGHT/667,
                               100*SCREEN_WEIGHT/375,
                               40);
    [lastBtn setTitle:@"上一步" forState:UIControlStateNormal];
    lastBtn.titleLabel.textColor = [UIColor whiteColor];
    [lastBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    lastBtn.layer.cornerRadius = 10;
    [lastBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastBtn];
    
    for (int i=0; i<_tissueNameArray.count; i++) {
        UIButton *tissueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tissueBtn.frame = CGRectMake(32*SCREEN_WEIGHT/375 + i%2 * 174*SCREEN_WEIGHT/375,
                                     181*SCREEN_HEIGHT/667 + i/2 * 50 *SCREEN_HEIGHT/667,
                                     135*SCREEN_WEIGHT/375,
                                     35);
        [tissueBtn setTitle:_tissueNameArray[i] forState:UIControlStateNormal];
        [tissueBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
        [tissueBtn addTarget:self action:@selector(selectSampleAction:) forControlEvents:UIControlEventTouchUpInside];
        tissueBtn.layer.borderWidth = 1;
        tissueBtn.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
        tissueBtn.tag = [_tissueIdArray[i] integerValue] + 100;
        tissueBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        [self.view addSubview: tissueBtn];
        
    }
    
    for (int i=0; i<_bloodNameArray.count; i++) {
        UIButton *bloodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bloodBtn.frame = CGRectMake(32*SCREEN_WEIGHT/375 + i%2 * 174*SCREEN_WEIGHT/375,
                                    539*SCREEN_HEIGHT/667 + i/2 * 50 *SCREEN_HEIGHT/667,
                                    135*SCREEN_WEIGHT/375,
                                    35);
        [bloodBtn setTitle:_bloodNameArray[i] forState:UIControlStateNormal];
        [bloodBtn setTitleColor:[UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1] forState:UIControlStateNormal];
        [bloodBtn addTarget:self action:@selector(selectSampleAction:) forControlEvents:UIControlEventTouchUpInside];
        bloodBtn.layer.borderWidth = 1;
        bloodBtn.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
        bloodBtn.tag = [_bloodIdArray[i] integerValue] + 200;
        bloodBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        [self.view addSubview: bloodBtn];
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectSampleAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *object = (UIButton *) obj;
            if (object.tag && object.tag != sender.tag) {
                object.selected = NO;
                
                object.backgroundColor = [UIColor whiteColor];
                object.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
                
            }
        }
    }
    
    if (_connectDic.count>0) {
        NSInteger sample_id;
        if (sender.tag>200) {
            sample_id = sender.tag - 200;
        }
        else{
            sample_id = sender.tag - 100;
        }
        for (NSString *key in _connectDic.allKeys) {
            NSArray *ary = [_connectDic objectForKey:key];
            for (NSString *ID in ary) {
                if ([key integerValue] == sample_id) {
                    NSInteger btnId = [ID integerValue];
                    UIButton *button = (UIButton *)[self.view viewWithTag:btnId + 200];
                    button.selected = YES;
                    button.backgroundColor = [UIColor colorWithMyNeed:218 green:236 blue:255 alpha:1];
                    button.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
                }
            }
        }
    }

    if (sender.selected == YES) {
        sender.backgroundColor = [UIColor colorWithMyNeed:218 green:236 blue:255 alpha:1];
        sender.layer.borderColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1].CGColor;
    }else{
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
    }
}

- (void)nextBtn:(UIButton *)sender{
    NSMutableString *sampleStr = [[NSMutableString alloc] init];
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *object = (UIButton *)obj;
            if (object.selected == NO) {
                continue;
            }
            if (object.tag >= 100 && object.tag<200) {
                [sampleStr appendFormat:@",%ld",object.tag-100];
                continue;
            }
            
            if (object.tag >=200) {
                [sampleStr appendFormat:@",%ld",object.tag-200];
            }
        }
    }
    if (sampleStr.length>0) {
        [sampleStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    NSLog(@"%@",[sampleStr copy]);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?product_ids=%@&sample_type_id=%@",SampleTrasport,_productStr,sampleStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(urlStr, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!response) {
                alertMsgView(@"网络错误", self);
                return ;
            }
            NSDictionary *returnDic = parseJsonResponse(response);
            if (!returnDic) {
                alertMsgView(@"返回数据错误", self);
                return;
            }
            NSNumber *reslut = [returnDic objectForKey:@"err"];
            if ([reslut integerValue] != 0) {
                alertMsgView([returnDic objectForKey:@"errmsg"], self);
                return;
            }
            NSArray *dataArray = [returnDic objectForKey:@"data"];
            SampleStandardRequirementViewController_iphone *SSRVC = [[SampleStandardRequirementViewController_iphone alloc] init];
            SSRVC.reuqirementArray = dataArray;
            SSRVC.productNameStr = _productNameStr;
            [self.navigationController pushViewController:SSRVC animated:YES];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
