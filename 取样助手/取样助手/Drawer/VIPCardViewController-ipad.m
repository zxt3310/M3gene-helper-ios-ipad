//
//  VIPCardViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/12/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#define CUSTOM_FONT [UIFont fontWithName:@"STHeitiSC-Light" size:22]
#define TEXT_FONT [UIFont fontWithName:@"STHeitiSC-Light" size:18]
#define CUSTOM_COLOR [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1]
#define LB_Origin_Left_X   0
#define LB_Origin_Middle_X 347*SCREEN_WEIGHT/1024
#define LB_Origin_Right_X  700*SCREEN_WEIGHT/1024
#define TF_Origin_Left_X   127*SCREEN_WEIGHT/1024
#define TF_Origin_Middle_X 473*SCREEN_WEIGHT/1024
#define TF_Origin_Right_X  818*SCREEN_WEIGHT/1024

#define Origin_TAG 100


#import "VIPCardViewController-ipad.h"

@interface contentView : UIView
@property (nonatomic) NSString *titleStr;
@end
@implementation contentView
@synthesize titleStr = _titleStr;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UITextField *titleTag = [[UITextField alloc] initWithFrame:CGRectMake(29 * SCREEN_WEIGHT/1024, 20 *SCREEN_HEIGHT/768 , 26, 26)];
        titleTag.enabled = NO;
        titleTag.layer.cornerRadius = 13;
        titleTag.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
        [self addSubview:titleTag];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleTag.frame.origin.x + titleTag.frame.size.width + 18, titleTag.frame.origin.y, 100, 25)];
        title.tag = 1;
        title.text = _titleStr;
        title.font = CUSTOM_FONT;
        title.textColor = CUSTOM_COLOR;
        [self addSubview:title];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    UILabel *titleLb = (UILabel *)[self viewWithTag:1];
    titleLb.text = titleStr;
}

- (NSString *)titleStr
{
    return _titleStr;
}
@end

@interface contentLb : UILabel
@end
@implementation contentLb
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.font = CUSTOM_FONT;
        self.textColor = CUSTOM_COLOR;
        self.textAlignment = NSTextAlignmentRight;
        
    }
    return self;
}
@end

@interface contentTextField : UITextField
@end
@implementation contentTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = 185*SCREEN_WEIGHT/1024;
        temp.size.height = 40;
        self.frame = temp;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
        self.font = TEXT_FONT;
        self.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
        self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        self.leftViewMode = UITextFieldViewModeAlways;

    }
    return self;
}
@end



@interface VIPCardViewControllerIpad ()
@end
@implementation VIPCardViewControllerIpad
{
    UIDatePicker *datepicker;
    contentTextField *birthTf;
    
    float currentTf_originY;
    NSMutableDictionary *postDic;
    NSArray *cardListJson; //从json数据中分离出的卡片总列表
    NSArray *cardList;  //根据下拉菜单选择过滤出的针对产品的卡片列表
    
    UIComboBox *productCbo;
    UIComboBox *cardCbo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isReEditOperate = NO;
        _card_type = -1;
        _payment_type = -1;
        _gender = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor colorWithMyNeed:216 green:216 blue:216 alpha:1];
    
    contentView *cardInfoView = [[contentView alloc] initWithFrame:CGRectMake(0, 101, SCREEN_WEIGHT, 137*SCREEN_HEIGHT/768)];
    cardInfoView.titleStr = @"卡片信息";
    [self.view addSubview:cardInfoView];
    
    contentLb *productLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 79*SCREEN_HEIGHT/768, 110, 22)];
    productLb.text = @"产品选择";
    [cardInfoView addSubview:productLb];
    
    productCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, productLb.frame.origin.y - 10, 218, 40)];
    productCbo.delegate = self;
    productCbo.comboList = @[@"和普安",@"和家安",@"和家欢",@"和美安",@"爱无忧"];
    productCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    productCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    productCbo.textFont = TEXT_FONT;
    productCbo.tag = Origin_TAG + 1;
    productCbo.selectId = _card_type;
    [cardInfoView addSubview:productCbo];
    
    contentLb *cardIdLb = [[contentLb alloc] initWithFrame:CGRectMake(600*SCREEN_WEIGHT/1024, productLb.frame.origin.y, 110*SCREEN_HEIGHT/768, 22)];
    cardIdLb.text = @"*卡号";
    [cardInfoView addSubview:cardIdLb];
    
    cardCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(721*SCREEN_WEIGHT/1024, productLb.frame.origin.y - 10, 218,40)];
    cardCbo.tag = Origin_TAG;
    cardCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    cardCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    cardCbo.textFont = TEXT_FONT;
    cardCbo.comboList = cardList;
    if (_code) {
        [cardCbo setValue:[NSString stringWithFormat:@"LH%@",_code] forKey:@"selectString"];
    }
    [cardInfoView addSubview:cardCbo];

    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    contentView *userInfoView = [[contentView alloc ] initWithFrame:CGRectMake(0, cardInfoView.frame.origin.y + cardInfoView.frame.size.height + 10, SCREEN_WEIGHT, 242*SCREEN_HEIGHT/768)];
    userInfoView.titleStr = @"用户资料";
    [self.view addSubview:userInfoView];
    
    contentLb *userNameLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 74 *SCREEN_HEIGHT/768, 110, 22)];
    userNameLb.text = @"*姓名";
    [userInfoView addSubview:userNameLb];
    
    contentTextField *userNameTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, userNameLb.frame.origin.y - 10, 0, 0)];
    userNameTf.tag = Origin_TAG + 2;
    userNameTf.delegate = self;
    userNameTf.text = _name;
    [userInfoView addSubview:userNameTf];
    
    contentLb *genderLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, userNameLb.frame.origin.y, 110, 22)];
    genderLb.text = @"*性别";
    [userInfoView addSubview:genderLb];
    
    UIComboBox *genderCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, userNameTf.frame.origin.y, 185*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768)];
    genderCbo.comboList = @[@"男",@"女"];
    genderCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    genderCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    genderCbo.textFont = TEXT_FONT;
    genderCbo.tag = Origin_TAG + 3;
    genderCbo.selectId = _gender;
    [userInfoView addSubview:genderCbo];
    
    contentLb *telLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, userNameLb.frame.origin.y, 110, 20)];
    telLb.text = @"*联系方式";
    [userInfoView addSubview:telLb];
    
    contentTextField *telTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, userNameTf.frame.origin.y, 0, 0)];
    telTf.tag = Origin_TAG + 4;
    telTf.delegate = self;
    telTf.text = _phone;
    [userInfoView addSubview:telTf];
    
    contentLb *birthLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 130 * SCREEN_HEIGHT/768, 110, 22)];
    birthLb.text = @"出生年月";
    [userInfoView addSubview:birthLb];
    
    birthTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, birthLb.frame.origin.y - 10, 0, 0)];
    birthTf.tag = Origin_TAG + 5;
    birthTf.delegate = self;
    birthTf.text = _birthday;
    [userInfoView addSubview:birthTf];
    
    contentLb *occupationLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, birthLb.frame.origin.y, 110, 22)];
    occupationLb.text = @"职业";
    [userInfoView addSubview:occupationLb];
    
    contentTextField *occupationTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, birthTf.frame.origin.y, 0, 0)];
    occupationTf.tag = Origin_TAG + 6;
    occupationTf.delegate = self;
    occupationTf.text = _career;
    [userInfoView addSubview:occupationTf];
    
    contentLb *carLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, birthLb.frame.origin.y, 110, 22)];
    carLb.text = @"车型";
    [userInfoView addSubview:carLb];
    
    contentTextField *carTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, birthTf.frame.origin.y, 0, 0)];
    carTf.tag = Origin_TAG + 7;
    carTf.delegate = self;
    carTf.text = _motor_type;
    [userInfoView addSubview:carTf];
    
    contentLb *hobbyLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 185 *SCREEN_HEIGHT/768, 110, 22)];
    hobbyLb.text = @"爱好";
    [userInfoView addSubview:hobbyLb];
    
    contentTextField *hobbyTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, hobbyLb.frame.origin.y - 10, 0, 0)];
    hobbyTf.tag = Origin_TAG + 8;
    hobbyTf.delegate = self;
    hobbyTf.text = _interest;
    [userInfoView addSubview:hobbyTf];
    
    contentLb *additionLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, hobbyLb.frame.origin.y, 110, 22)];
    additionLb.text = @"备注";
    [userInfoView addSubview:additionLb];
    
    contentTextField *additionTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, hobbyTf.frame.origin.y, 0, 0)];
    additionTf.tag = Origin_TAG + 9;
    additionTf.delegate = self;
    additionTf.text = _remark;
    [userInfoView addSubview:additionTf];
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    contentView *payInfoView = [[contentView alloc] initWithFrame:CGRectMake(0, userInfoView.frame.origin.y + userInfoView.frame.size.height + 10, SCREEN_WEIGHT, 268 * SCREEN_HEIGHT/768)];
    payInfoView.titleStr = @"付款信息";
    [self.view addSubview:payInfoView];
    
    contentLb *payNumberLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X + 80,79*SCREEN_HEIGHT/768, 150 *SCREEN_WEIGHT/1024, 22)];
    payNumberLb.text = @"*付款金额";
    [payInfoView addSubview:payNumberLb];
    
    contentTextField *payNumberTf = [[contentTextField alloc] initWithFrame:CGRectMake(158*SCREEN_WEIGHT/1024 + 80, 69*SCREEN_HEIGHT/768,0,0)];
    payNumberTf.tag = Origin_TAG + 10;
    payNumberTf.delegate = self;
    payNumberTf.text = _payment_amount;
    [payInfoView addSubview:payNumberTf];
    
    contentLb *payType = [[contentLb alloc] initWithFrame:CGRectMake(347*SCREEN_WEIGHT/1024 + 250, payNumberLb.frame.origin.y, 110*SCREEN_WEIGHT/1024, 22)];
    payType.text = @"*付款方式";
    [payInfoView addSubview:payType];
    
    UIComboBox *payTypeCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X + 250, payNumberTf.frame.origin.y, 185*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768)];
    payTypeCbo.comboList = @[@"刷卡",@"微信",@"支付宝"];
    payTypeCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    payTypeCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    payTypeCbo.textFont = TEXT_FONT;
    payTypeCbo.tag = Origin_TAG + 11;
    payTypeCbo.selectId = _payment_type;
    [payInfoView addSubview:payTypeCbo];
    
    contentLb *payDateLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, payNumberLb.frame.origin.y, 110*SCREEN_WEIGHT/1024, 22)];
    payDateLb.text = @"使用次数";
    [payInfoView addSubview:payDateLb];
    
    contentTextField *payDateTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, payNumberTf.frame.origin.y, 0, 0)];
    payDateTf.tag = Origin_TAG + 12;
    payDateTf.delegate = self;
    payDateTf.text = _pay_time;
    [payInfoView addSubview:payDateTf];
    
    contentLb *payTypeDitailLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X + 80, 130*SCREEN_HEIGHT/768, 150 *SCREEN_WEIGHT/1024, 22)];
    payTypeDitailLb.text = @"*付款方式信息";
    [payInfoView addSubview:payTypeDitailLb];
    
    contentTextField *payTypeDitailTf = [[contentTextField alloc] initWithFrame:CGRectMake(payNumberTf.frame.origin.x, 124*SCREEN_HEIGHT/768, 0, 0)];
    payTypeDitailTf.tag = Origin_TAG + 13;
    payTypeDitailTf.delegate = self;
    payTypeDitailTf.text = _pay_info;
    [payInfoView addSubview:payTypeDitailTf];
    
    contentLb *payAddition = [[contentLb alloc] initWithFrame:CGRectMake(351*SCREEN_WEIGHT/1024 + 80, 136*SCREEN_HEIGHT/768, 500, 16)];
    payAddition.textAlignment = NSTextAlignmentLeft;
    payAddition.text = @"（刷卡－填写卡后4位，支付宝－填写支付宝名称,微信－填写微信号）";
    payAddition.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    payAddition.textColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    [payInfoView addSubview:payAddition];
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(425, 697, 174, 52);
    saveBtn.layer.cornerRadius = 10;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    saveBtn.titleLabel.font = CUSTOM_FONT;
    saveBtn.titleLabel.textColor = [UIColor whiteColor];
    [saveBtn addTarget:self action:@selector(saveBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [self setNewBar];
    
    datepicker = [[UIDatePicker alloc] init];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:-120];
    datepicker.maximumDate = [NSDate date];
    datepicker.minimumDate = [cal dateByAddingComponents:comp toDate:[NSDate date] options:0];
    datepicker.datePickerMode = UIDatePickerModeDate;
    birthTf.inputView = datepicker;
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 40)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(switchDateAction)];
    bar.items = @[item];
    birthTf.inputAccessoryView = bar;
    
    [self productRequest];
    
    payDateLb.hidden = YES;
    payDateTf.hidden = YES;
}

- (void)switchDateAction
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [format stringFromDate:datepicker.date];
    birthTf.text = dateStr;
    [birthTf resignFirstResponder];
}

- (void)collectContentInfo
{
    NSArray *jsonKeyArray = @[@"code",@"card_type",@"name",@"gender",@"phone",@"birthday",@"career",@"motor_type",@"interest",@"remark",@"payment_amount",@"payment_type",@"pay_time",@"pay_info"];
    postDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<jsonKeyArray.count; i++) {
        [postDic setObject:[[NSObject alloc]init] forKey:jsonKeyArray[i]];
    }
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[contentView class]]) {
            contentView *content = (contentView *) object;
            for (id control in content.subviews) {
                if ([control isKindOfClass:[contentTextField class]]) {
                    contentTextField *tempTf = (contentTextField *)control;
                    [postDic setValue:tempTf.text forKey:jsonKeyArray[tempTf.tag - 100]];
                }
                if ([control isKindOfClass:[UIComboBox class]])
                {
                    UIComboBox *tempCbo = (UIComboBox *)control;
                    if(tempCbo.tag == Origin_TAG)
                    {
                        [postDic setValue:[tempCbo.selectString stringByReplacingOccurrencesOfString:@"LH" withString:@""] forKey:jsonKeyArray[tempCbo.tag - 100]];
                    }
                    else
                    {
                        [postDic setValue:[NSString stringWithFormat:@"%ld",(long)tempCbo.selectId] forKey:jsonKeyArray[tempCbo.tag - 100]];
                    }
                }
            }
        }
    }
}

- (void)saveBtnClickAction
{
    [self collectContentInfo];
    
    NSMutableString *postStr = [[NSMutableString alloc] init];
    for(NSString *key in postDic.allKeys)
    {
        NSString *appendStr = [NSString stringWithFormat:@"&%@=%@",key,[postDic objectForKey:key]];
        [postStr appendString:appendStr];
    }
    [postStr deleteCharactersInRange:NSMakeRange(0, 1)];
    
    [self uploadSaveRequest:[postStr copy]];
}

- (void)uploadSaveRequest:(NSString *)fullPostStr
{
    NSString *urlStr = [[NSString stringWithFormat:@"http://gzh.gentest.ranknowcn.com/mobi-cms/card/bind?%@",fullPostStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *responseData = sendRequestWithFullURLandHeaders(urlStr, nil, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!responseData) {
                alertMsgView(@"无法连接到服务器，请检查网络或稍后再试", self);
                return;
            }

            NSDictionary *responseDic = parseJsonResponse(responseData);
            if (!responseData) {
                alertMsgView(@"保存失败，请稍后再试", self);
            }
            
            NSNumber *error = JsonValue([responseDic objectForKey:@"err"], @"NSNumber");
            if (error == nil) {
                alertMsgView(@"返回错误数据，请稍后再试", self);
                return;
            }
            NSInteger errmsg = [error integerValue];
            if (errmsg > 0) {
                NSString *errStr = JsonValue([responseDic objectForKey:@"errmsg"], @"NSString");
                alertMsgView(errStr, self);
                return;
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ula = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ula];
            [self presentViewController:alert animated:YES completion:^{
                if(_isReEditOperate)
                {
                    NSArray *arry = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
                    NSMutableArray *operateArray = [[NSMutableArray alloc]initWithArray:arry];
                    [operateArray removeObjectAtIndex:_deleteIndex];
                    arry = [operateArray copy];
                    [self.refreshDelegate refresh:arry];
                }
                [self clearAll];
            }];
        });
    });
}

- (void)productRequest
{
    NSString *urlStr = VIPCARD_productList_URL;
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *returnData = sendGETRequest(urlStr, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!returnData) {
                alertMsgView(@"获取产品列表失败，无法连接到服务器", self);
                return ;
            }
            
            NSDictionary *responseDic = parseJsonResponse(returnData);
            if (!responseDic) {
                alertMsgView(@"获取产品列表失败，请返回上一级菜单并重试", self);
                return;
            }
            NSNumber *resault = [responseDic objectForKey:@"err"];
            if (!resault) {
                alertMsgView(@"获取产品列表失败,返回数据有误，请稍后再试", self);
            }
            if ([resault integerValue] > 0) {
                NSString *errmsg = [responseDic objectForKey:@"errmsg"];
                alertMsgView(errmsg, self);
                return;
            }
            productCbo.comboList = JsonValue([responseDic objectForKey:@"card_types"],@"NSArray");
            cardListJson = JsonValue([responseDic objectForKey:@"data"], @"NSArray");
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    titleLabel.text = @"贵宾卡";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36];// boldSystemFontOfSize:36];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
    
    UIButton *cacheBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cacheBt setTitle:@"暂存到草稿箱" forState:UIControlStateNormal];
    cacheBt.titleLabel.textColor = [UIColor whiteColor];
    cacheBt.frame = CGRectMake(876 * SCREEN_WEIGHT/1024, 46*SCREEN_HEIGHT/768, 120*SCREEN_WEIGHT/1024, 40);
    cacheBt.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
    cacheBt.layer.cornerRadius = 10;
    [cacheBt addTarget:self action:@selector(cacheBtClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cacheBt];
}

- (void)cacheBtClick
{
    [self collectContentInfo];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormat stringFromDate:[NSDate date]];
    

    NSArray *cacheArray = @[@"cacheType",@"operateTime",@"registStr"];
    NSArray *cacheData = @[@"CACHE_VIP",timeStr,postDic];
    NSDictionary *cacheDic = [NSDictionary dictionaryWithObjects:cacheData forKeys:cacheArray];
    
    //存入数组
    
    NSArray *arry = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
    NSMutableArray *operateArray = [[NSMutableArray alloc]initWithArray:arry];
    if(_isReEditOperate)
    {
        [operateArray removeObjectAtIndex:_deleteIndex];
    }
    [operateArray addObject:cacheDic];
    arry = [operateArray copy];
    
    @try
    {
        [[NSUserDefaults standardUserDefaults] setObject:arry forKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ula];
        [self presentViewController:alert animated:YES completion:^{
            [self clearAll];
            [self.refreshDelegate refresh:arry];
        }];
    }

}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[contentView class]]) {
            contentView *subView = (contentView *)object;
            for (id control in subView.subviews) {
                if ([control isKindOfClass:[UIComboBox class]]) {
                    UIComboBox *box = (UIComboBox *)control;
                    [box dismissTable];
                }
            }
        }
    }
}

- (void)clearAll
{
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[contentView class]]) {
            contentView *content = (contentView *) object;
            for (id control in content.subviews) {
                if ([control isKindOfClass:[contentTextField class]]) {
                    contentTextField *tempTf = (contentTextField *)control;
                    tempTf.text = @"";
                }
                if ([control isKindOfClass:[UIComboBox class]])
                {
                    UIComboBox *tempCbo = (UIComboBox *)control;
                    [tempCbo resetCombo];
                }
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTf_originY = [textField.superview convertRect:textField.frame toView:self.view].origin.y;
    return YES;
}

- (void) changeContentViewPoint:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    if (![notification.name isEqual:UIKeyboardWillHideNotification] && keyBoardEndY > currentTf_originY + 40) {
        return;
    }
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        if (![notification.name isEqual:UIKeyboardWillShowNotification]) {
            self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        }
        else
        {
            self.view.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/2.0 - currentTf_originY + keyBoardEndY - 50);
        }
    }];
}

- (void)UIComboBox:(UIComboBox *)comboBox didSelectRow:(NSIndexPath *)indexPath
{
    NSMutableArray *cardArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<cardListJson.count; i++) {
        NSDictionary *cardDic = JsonValue(cardListJson[i],@"NSDictionary");
        NSNumber *cardType = JsonValue([cardDic objectForKey:@"card_type"],@"NSNumber");
        NSInteger type = [cardType integerValue];
        if (type == indexPath.row - 1) {
            NSString *cardId = [NSString stringWithFormat:@"LH%@",JsonValue([cardDic objectForKey:@"code"],@"NSString")];
            [cardArray addObject:cardId];
        }
    }
    [cardCbo resetCombo];
    if (cardArray.count == 0) {
        cardCbo.introductStr = @"无此产品相关卡片";
    }
    else
    {
        cardCbo.introductStr = @"-请选择-";
    }
    cardCbo.comboList = [cardArray copy];
}

@end
