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

#import "VIPCardViewController.h"

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



@interface VIPCardViewController ()
@end
@implementation VIPCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithMyNeed:216 green:216 blue:216 alpha:1];
    
    contentView *cardInfoView = [[contentView alloc] initWithFrame:CGRectMake(0, 101, SCREEN_WEIGHT, 137*SCREEN_HEIGHT/768)];
    cardInfoView.titleStr = @"卡片信息";
    [self.view addSubview:cardInfoView];
    
    contentLb *cardIdLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 79*SCREEN_HEIGHT/768, 110, 22)];
    cardIdLb.text = @"*卡号";
    [cardInfoView addSubview:cardIdLb];
    
    contentTextField *cardIdTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, cardIdLb.frame.origin.y - 10, 0, 0)];
    [cardInfoView addSubview:cardIdTf];
    
    contentLb *productLb = [[contentLb alloc] initWithFrame:CGRectMake(600*SCREEN_WEIGHT/1024, cardIdLb.frame.origin.y, 110*SCREEN_HEIGHT/768, 22)];
    productLb.text = @"产品选择";
    [cardInfoView addSubview:productLb];
    
    UIComboBox *productCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(721*SCREEN_WEIGHT/1024, cardIdLb.frame.origin.y - 10, 218, 40)];
    productCbo.comboList = @[@"和普安",@"和家安",@"和美安"];
    productCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    productCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    productCbo.textFont = TEXT_FONT;
    [cardInfoView addSubview:productCbo];
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    contentView *userInfoView = [[contentView alloc ] initWithFrame:CGRectMake(0, cardInfoView.frame.origin.y + cardInfoView.frame.size.height + 10, SCREEN_WEIGHT, 242*SCREEN_HEIGHT/768)];
    userInfoView.titleStr = @"用户资料";
    [self.view addSubview:userInfoView];
    
    contentLb *userNameLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 74 *SCREEN_HEIGHT/768, 110, 22)];
    userNameLb.text = @"*姓名";
    [userInfoView addSubview:userNameLb];
    
    contentTextField *userNameTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, userNameLb.frame.origin.y - 10, 0, 0)];
    [userInfoView addSubview:userNameTf];
    
    contentLb *genderLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, userNameLb.frame.origin.y, 110, 22)];
    genderLb.text = @"*性别";
    [userInfoView addSubview:genderLb];
    
    UIComboBox *genderCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, userNameTf.frame.origin.y, 185*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768)];
    genderCbo.comboList = @[@"男",@"女"];
    genderCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    genderCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    genderCbo.textFont = TEXT_FONT;
    [userInfoView addSubview:genderCbo];
    
    contentLb *telLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, userNameLb.frame.origin.y, 110, 20)];
    telLb.text = @"*联系方式";
    [userInfoView addSubview:telLb];
    
    contentTextField *telTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, userNameTf.frame.origin.y, 0, 0)];
    [userInfoView addSubview:telTf];
    
    contentLb *birthLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 130 * SCREEN_HEIGHT/768, 110, 22)];
    birthLb.text = @"出生年月";
    [userInfoView addSubview:birthLb];
    
    contentTextField *birthTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, birthLb.frame.origin.y - 10, 0, 0)];
    [userInfoView addSubview:birthTf];
    
    contentLb *occupationLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, birthLb.frame.origin.y, 110, 22)];
    occupationLb.text = @"职业";
    [userInfoView addSubview:occupationLb];
    
    contentTextField *occupationTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, birthTf.frame.origin.y, 0, 0)];
    [userInfoView addSubview:occupationTf];
    
    contentLb *carLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, birthLb.frame.origin.y, 110, 22)];
    carLb.text = @"车型";
    [userInfoView addSubview:carLb];
    
    contentTextField *carTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, birthTf.frame.origin.y, 0, 0)];
    [userInfoView addSubview:carTf];
    
    contentLb *hobbyLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X, 185 *SCREEN_HEIGHT/768, 110, 22)];
    hobbyLb.text = @"爱好";
    [userInfoView addSubview:hobbyLb];
    
    contentTextField *hobbyTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Left_X, hobbyLb.frame.origin.y - 10, 0, 0)];
    [userInfoView addSubview:hobbyTf];
    
    contentLb *additionLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Middle_X, hobbyLb.frame.origin.y, 110, 22)];
    additionLb.text = @"备注";
    [userInfoView addSubview:additionLb];
    
    contentTextField *additionTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, hobbyTf.frame.origin.y, 0, 0)];
    [userInfoView addSubview:additionTf];
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    contentView *payInfoView = [[contentView alloc] initWithFrame:CGRectMake(0, userInfoView.frame.origin.y + userInfoView.frame.size.height + 10, SCREEN_WEIGHT, 268 * SCREEN_HEIGHT/768)];
    payInfoView.titleStr = @"付款信息";
    [self.view addSubview:payInfoView];
    
    contentLb *payNumberLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Left_X,79*SCREEN_HEIGHT/768, 150 *SCREEN_WEIGHT/1024, 22)];
    payNumberLb.text = @"*付款金额";
    [payInfoView addSubview:payNumberLb];
    
    contentTextField *payNumberTf = [[contentTextField alloc] initWithFrame:CGRectMake(158*SCREEN_WEIGHT/1024, 69*SCREEN_HEIGHT*768,0,0)];
    [payInfoView addSubview:payNumberTf];
    
    contentLb *payType = [[contentLb alloc] initWithFrame:CGRectMake(347*SCREEN_WEIGHT/1024, payNumberLb.frame.origin.y, 110*SCREEN_WEIGHT/1024, 22)];
    payType.text = @"付款方式";
    [payInfoView addSubview:payType];
    
    UIComboBox *payTypeCbo = [[UIComboBox alloc] initWithFrame:CGRectMake(TF_Origin_Middle_X, payNumberTf.frame.origin.y, 185*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768)];
    payTypeCbo.comboList = @[@"微信",@"支付宝"];
    payTypeCbo.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    payTypeCbo.textColor = [UIColor colorWithMyNeed:117 green:117 blue:117 alpha:1];
    payTypeCbo.textFont = TEXT_FONT;
    [payInfoView addSubview:payTypeCbo];
    
    contentLb *payDateLb = [[contentLb alloc] initWithFrame:CGRectMake(LB_Origin_Right_X, payNumberLb.frame.origin.y, 110*SCREEN_WEIGHT/1024, 22)];
    payDateLb.text = @"付款日期";
    [payInfoView addSubview:payDateLb];
    
    contentTextField *payDateTf = [[contentTextField alloc] initWithFrame:CGRectMake(TF_Origin_Right_X, payNumberTf.frame.origin.y, 0, 0)];
    [payInfoView addSubview:payDateTf];
    
    contentLb *pay

    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(425, 697, 174, 52);
    saveBtn.layer.cornerRadius = 10;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    saveBtn.titleLabel.font = CUSTOM_FONT;
    saveBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:saveBtn];
    
    [self setNewBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
