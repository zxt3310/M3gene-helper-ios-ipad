//
//  registView.m
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "registView.h"

@interface contentLable : UILabel

@end
@implementation contentLable
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = (text.length + 1)*18;
        temp.size.height = 22;
        self.text = text;
        self.frame = temp;
        
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        self.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        
    }
    return self;
}

@end

@interface contentTF : UITextField

@end
@implementation contentTF

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = 188*SCREEN_WEIGHT/1024;
        temp.size.height = 22;
        self.frame = temp;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
        self.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end


#define Origin_TAG 100

#define Offset_Y 50
#define Offset_Last 30

@implementation registViewNew
{
    UIDatePicker *datePicker;
    contentTF *CSRQtf;
    contentTF *DDBHtf;
    CGRect currentTf_frame;
    float lastScroll;
    NSArray *organization_id_Array;
    NSArray *doctor_id_Array;
    NSArray *recieve_id_array;
    UIComboBox *SYJGbox;
    UIComboBox *SJDWcb;
    UIComboBox *SJYScb;
    NSInteger age;
    NSString *selectedDor;
}
@synthesize hidden = _hidden;
@synthesize DDBH = _DDBH;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentSize = CGSizeMake(frame.size.width, 1026*SCREEN_HEIGHT/768 + Offset_Y + Offset_Last);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    _SJYB = _SEX = _AZS_SWITCH = _JZAZS_SWITCH = @"1";
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    super.hidden = hidden;
    if (!hidden) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)show
{
    contentLable *titleLb = [[contentLable alloc] initWithFrame:[self caculateFrameY:11 isLeft:YES isLable:YES]  andText:@"检验单录入"];
    [self addSubview:titleLb];
    //分割线------------------------------------------------------------------------------------------------------------------------
    contentLable *tag1 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"送检信息"];
    UITextField *blue1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue1.enabled = NO;
    blue1.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue1 addSubview:tag1];
    [self addSubview:blue1];
    
    //送检样本 101
    contentLable *SJYBlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:YES] andText:@"送检样本"];
    [self addSubview:SJYBlb];
    UISingleSelector *SJYBtf = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:NO]];
   // SJYBtf.text = _SJYB;
    SJYBtf.itemList = @[@"血清",@"组织"];
    SJYBtf.itemId = @[@"1",@"2"];
    SJYBtf.switchId = _SJYB;
    SJYBtf.tag = Origin_TAG + 1;
    [self addSubview:SJYBtf];
   
    //订单编号
    contentLable *DDBHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:YES] andText:@"样本编号"];
    [self addSubview:DDBHlb];
    DDBHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:NO]];
    DDBHtf.text = _DDBH;
    DDBHtf.enabled = NO;
    [self addSubview:DDBHtf];
    
    //送检机构 103
    contentLable *SJDWlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:130 isLeft:YES isLable:YES] andText:@"送检机构"];
    [self addSubview:SJDWlb];
    
    SJDWcb = [[UIComboBox alloc] initWithFrame:[self caculateFrameY:130 isLeft:YES isLable:NO]];
    SJDWcb.delegate = self;
    SJDWcb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    SJDWcb.comborColor = SJDWcb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    SJDWcb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    SJDWcb.tag = Origin_TAG +3;
    [self addSubview:SJDWcb];
    
    //送检医生 104
    contentLable *SJYSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:130 isLeft:NO isLable:YES] andText:@"送检医生"];
    [self addSubview:SJYSlb];
    
    SJYScb = [[UIComboBox alloc]initWithFrame:[self caculateFrameY:130 isLeft:NO isLable:NO]];
    SJYScb.delegate = self;
    SJYScb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    SJYScb.comborColor = SJYScb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    SJYScb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    SJYScb.tag = Origin_TAG +4;
    [self addSubview:SJYScb];
    
    //收样机构 105
    contentLable *SYJGlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:168 + Offset_Y isLeft:YES isLable:YES] andText:@"收样机构"];
    [self addSubview:SYJGlb];
    SYJGbox = [[UIComboBox alloc] initWithFrame:[self caculateFrameY:168+ Offset_Y isLeft:YES isLable:NO]];
    
    SYJGbox.delegate = self;
    SYJGbox.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    SYJGbox.comborColor = SYJGbox.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    SYJGbox.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    SYJGbox.tag = Origin_TAG + 5;
    [self addSubview:SYJGbox];
    
    contentLable *tag4 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"收样信息"];
    UITextField *blue4 = [[UITextField alloc]initWithFrame:CGRectMake(0, 168, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue4.enabled = NO;
    blue4.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue4 addSubview:tag4];
    [self addSubview:blue4];
    
    //分割线------------------------------------------------------------------------------------------------------------------------
    contentLable *tag2 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"受检人信息"];
    UITextField *blue2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 207 + Offset_Y, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue2.enabled = NO;
    blue2.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue2 addSubview:tag2];
    [self addSubview:blue2];
    
    //姓名 106
    contentLable *XMlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 + Offset_Y isLeft:YES isLable:YES] andText:@"姓      名"];
    [self addSubview:XMlb];
    contentTF *XMtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 + Offset_Y isLeft:YES isLable:NO]];
    XMtf.text = _NAME;
    XMtf.tag = Origin_TAG + 6;
    [self addSubview:XMtf];
    //身份证号 107
    contentLable *SFZHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 + Offset_Y isLeft:NO isLable:YES] andText:@"身份证号"];
    [self addSubview:SFZHlb];
    contentTF *SFZHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 + Offset_Y isLeft:NO isLable:NO]];
    SFZHtf.text = _SFZH;
    SFZHtf.tag = Origin_TAG + 7;
    [self addSubview:SFZHtf];
    
    
    //联系电话 108
    contentLable *LXDHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:290 + Offset_Y isLeft:YES isLable:YES] andText:@"联系电话"];
    [self addSubview:LXDHlb];
    contentTF *LXDHtf  = [[contentTF alloc] initWithFrame:[self caculateFrameY:290 + Offset_Y isLeft:YES isLable:NO]];
    LXDHtf.text = _LXDH;
    LXDHtf.tag = Origin_TAG + 8;
    [self addSubview:LXDHtf];
    
    //所在地区 102
    contentLable *SZDQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:290 + Offset_Y isLeft:NO isLable:YES] andText:@"所在地区"];
    [self addSubview:SZDQlb];
    contentTF *SZDQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:290 + Offset_Y isLeft:NO isLable:NO]];
    SZDQtf.text = _JSDZ;
    SZDQtf.tag = Origin_TAG + 2;
    [self addSubview:SZDQtf];
    
    
    //出生日期 110
    contentLable *CSRQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:323 + Offset_Y isLeft:YES isLable:YES] andText:@"出生日期"];
    [self addSubview:CSRQlb];
    CSRQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:323 + Offset_Y isLeft:YES isLable:NO]];
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    CSRQtf.inputView = datePicker;
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 40)];
    toolBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(dateConfirm)];
    [item setTintColor:[UIColor blueColor]];
    toolBar.items = @[item];
    CSRQtf.inputAccessoryView = toolBar;
    CSRQtf.text = _CSRQ;
    CSRQtf.tag = Origin_TAG +10;
    [self addSubview:CSRQtf];
    
    
    //民族 111
    contentLable *MZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:359 + Offset_Y isLeft:YES isLable:YES] andText:@"民      族"];
    [self addSubview:MZlb];
    contentTF *MZtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:359 + Offset_Y isLeft:YES isLable:NO]];
    MZtf.text = _MZ;
    MZtf.tag = Origin_TAG + 11;
    [self addSubview:MZtf];
    
    //籍贯 112
    contentLable *JGlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:359 + Offset_Y isLeft:NO isLable:YES] andText:@"籍      贯"];
    [self addSubview:JGlb];
    contentTF *JGtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:359 + Offset_Y isLeft:NO isLable:NO]];
    JGtf.text = _JG;
    JGtf.tag = Origin_TAG + 12;
    [self addSubview:JGtf];
    
    //性别 113
    contentLable *XBlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:323 + Offset_Y isLeft:NO isLable:YES] andText:@"性      别"];
    [self addSubview:XBlb];
    UISingleSelector *XBSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:323 + Offset_Y isLeft:NO isLable:NO]];
    XBSst.delegate = self;
    XBSst.tag = Origin_TAG + 13;
    XBSst.itemList = @[@"男",@"女"];
    XBSst.itemId = @[@"0",@"1"];
    XBSst.switchId = _SEX;
    [self addSubview:XBSst];
    
    //寄送地址 109
    contentLable *BGJSDZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:395 + Offset_Y isLeft:YES isLable:YES] andText:@"寄送地址"];
    [self addSubview:BGJSDZlb];
    contentTF *BGJSDZtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:395 + Offset_Y isLeft:YES isLable:NO]];
    CGRect temp = BGJSDZtf.frame;
    temp.size.width = 494 *SCREEN_WEIGHT/1024;
    BGJSDZtf.frame = temp;
    BGJSDZtf.text = _JSDZ;
    BGJSDZtf.tag = Origin_TAG + 9;
    [self addSubview:BGJSDZtf];
    
    //分割线------------------------------------------------------------------------------------------------------------------------
    contentLable *tag3 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"健康信息"];
    UITextField *blue3 = [[UITextField alloc]initWithFrame:CGRectMake(0, 401 + Offset_Y + Offset_Last, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue3.enabled = NO;
    blue3.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue3 addSubview:tag3];
    [self addSubview:blue3];
    
    //癌症史 114
    contentLable *AZSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:450 + Offset_Y + Offset_Last isLeft:YES isLable:YES] andText:@"癌 症 史"];
    [self addSubview:AZSlb];
    
    UISingleSelector *AZSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:450 + Offset_Y + Offset_Last isLeft:YES isLable:NO]];
    AZSst.delegate = self;
    AZSst.tag = Origin_TAG + 14;
    AZSst.itemList = @[@"有",@"无"];
    AZSst.itemId = @[@"1",@"0"];
    AZSst.switchId = _AZS_SWITCH;
    [self addSubview:AZSst];
    
    //发病年龄 115
    contentLable *FBNLlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:450 + Offset_Y + Offset_Last isLeft:NO isLable:YES] andText:@"发病年龄"];
    [self addSubview:FBNLlb];
    contentTF *FBNLtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:450 + Offset_Y + Offset_Last isLeft:NO isLable:NO]];
    FBNLtf.text = _FBNL;
    FBNLtf.tag = Origin_TAG + 15;
    [self addSubview:FBNLtf];
    
    //临床表现 116
    contentLable *LCBXlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:490 + Offset_Y + Offset_Last isLeft:YES isLable:YES] andText:@"临床表现及治愈情况"];
    [self addSubview:LCBXlb];
    UITextView *LCBXtf = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    LCBXtf.layer.borderWidth = 1;
    LCBXtf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,523 * SCREEN_HEIGHT/768 + Offset_Y + Offset_Last, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    LCBXtf.text = _LCBX;
    LCBXtf.tag = Origin_TAG + 16;
    [self addSubview:LCBXtf];
    
    //家族癌症史 117
    contentLable *JZAZSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:639 + Offset_Y + Offset_Last isLeft:YES isLable:YES] andText:@"家族癌症史"];
    [self addSubview:JZAZSlb];
    UISingleSelector *JZAZSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:639 + Offset_Y + Offset_Last isLeft:YES isLable:NO]];
    JZAZSst.delegate = self;
    JZAZSst.tag = Origin_TAG + 17;
    JZAZSst.itemList = @[@"有",@"无"];
    JZAZSst.itemId = @[@"1",@"0"];
    JZAZSst.switchId = _JZAZS_SWITCH;
    [self addSubview:JZAZSst];
    
    //关系 118
    contentLable *GXlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:639 + Offset_Y + Offset_Last isLeft:NO isLable:YES] andText:@"关      系"];
    [self addSubview:GXlb];
    UIComboBox *GXcb = [[UIComboBox alloc] initWithFrame:[self caculateFrameY:639 + Offset_Y + Offset_Last isLeft:NO isLable:NO]];
    GXcb.tag = Origin_TAG + 18;
    GXcb.delegate = self;
    GXcb.comboList = @[@"父母",@"子女",@"亲戚"];
    GXcb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    GXcb.comborColor = GXcb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    GXcb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self addSubview:GXcb];
    // 119
    UITextView *JZAZStf = [[UITextView alloc] initWithFrame:CGRectZero];
    JZAZStf.layer.borderWidth = 1;
    JZAZStf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,672*SCREEN_HEIGHT/768 + Offset_Y + Offset_Last, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    JZAZStf.text = _JZAZS;
    JZAZStf.tag = Origin_TAG + 19;
    [self addSubview:JZAZStf];
    
    //其他疾病 120
    contentLable *QTBSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:788 + Offset_Y + Offset_Last isLeft:YES isLable:YES] andText:@"其他疾病"];
    [self addSubview:QTBSlb];
    UITextView *QTBStf = [[UITextView alloc] initWithFrame:[self caculateFrameY:821 + Offset_Y + Offset_Last isLeft:YES isLable:NO]];
    QTBStf.layer.borderWidth = 1;
    QTBStf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,821*SCREEN_HEIGHT/768 + Offset_Y + Offset_Last, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    QTBStf.text = _QTBS;
    QTBStf.tag = Origin_TAG + 20;
    [self addSubview:QTBStf];
    
    //保存按钮
    UIButton *saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBt.frame = CGRectMake(287 * SCREEN_WEIGHT/1024, 945*SCREEN_HEIGHT/768 + Offset_Y + Offset_Last, 174*SCREEN_WEIGHT/1024, 52*SCREEN_HEIGHT/768);
    saveBt.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    saveBt.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    saveBt.layer.cornerRadius = 10;
    saveBt.showsTouchWhenHighlighted = YES;
    [saveBt setTitle:@"保存" forState:UIControlStateNormal];
    [saveBt addTarget:self action:@selector(saveBtenClick) forControlEvents:UIControlEventTouchUpInside];
    saveBt.tintColor = [UIColor whiteColor];
    [self addSubview:saveBt];
    
    LCBXtf.font = JZAZStf.font = QTBStf.font = FBNLtf.font;
    LCBXtf.layer.borderColor = JZAZStf.layer.borderColor = QTBStf.layer.borderColor = FBNLtf.layer.borderColor;
    LCBXtf.delegate = JZAZStf.delegate = QTBStf.delegate = self;
    
    [self setTextFieldDelegate];

}

- (NSString *)DDBH{
    return _DDBH;
}
- (void)setDDBH:(NSString *)DDBH{
    _DDBH = DDBH;
    DDBHtf.text = DDBH;
}

- (void)didMoveToWindow
{
    [self orgnizitionRequest];
    [self receiveOrgRequest];
}

#pragma mark 拼post josn字符串 上传或暂存
- (NSString *)builtToSendString{
    NSArray *itemArray = @[@"sample_type",@"native",@"org_id",@"doctor_id",@"lab_id",@"name",@"id_card",@"phone",@"address",@"birthday",@"nation",
                           @"region",@"gender",@"is_cancer",@"onset_age",@"condition",@"family_is_cancer",@"relation",@"family_cancer",@"other_disease"];//,@"age",@"type",@"source"];
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    
    for (id obj in self.subviews) {
        
        NSString *unitStr;
        NSInteger tage;
        
        if ([obj isKindOfClass:[UISingleSelector class]]) {
            UISingleSelector *object = (UISingleSelector *)obj;
            unitStr = object.switchId;
            tage = object.tag;
        }
        else if ([obj isKindOfClass:[UIComboBox class]]){
            UIComboBox *object = (UIComboBox *)obj;
            tage = object.tag;
            if (object.selectId != -1) {
                switch (tage) {
                    case 103:
                        unitStr = organization_id_Array[object.selectId];
                        break;
                    case 104:
                        unitStr = doctor_id_Array[object.selectId];
                        break;
                    case 118:
                        unitStr = object.selectString;
                        break;
                    default:
                        unitStr = recieve_id_array[object.selectId];
                        break;
                }
            }
            else{
                unitStr = @"";
            }
        }
        else if ([obj isKindOfClass:[contentTF class]]){
            contentTF *object = (contentTF*) obj;
            unitStr = object.text;
            tage = object.tag;
        }
        else if ([obj isKindOfClass:[UITextView class]]){
            UITextView *object = (UITextView *)obj;
            unitStr = object.text;
            tage = object.tag;
        }
        else{
            continue;
        }
        
        if (tage > 100){
            if (!unitStr) {
                unitStr = @"";
            }
            
            [userDic setObject:unitStr forKey:itemArray[tage - 101]];
            [userDic setObject:[NSString stringWithFormat:@"%ld",age] forKey:@"age"];
            [userDic setObject:@"1" forKey:@"type"];
            [userDic setObject:@"助手" forKey:@"source"];
            [userDic setObject:@" " forKey:@"email"];
            [userDic setObject:@" " forKey:@"cancer"];
        }
    }
    return [self convertToJSONData:[userDic copy]];
}

#pragma mark 填充数据

- (void)fillUserData{
    NSDictionary *dic = parseJsonString(_fillString);
    if (!dic) {
        return;
    }
    
    NSArray *itemArray = @[@"sample_type",@"native",@"org_id",@"doctor_id",@"lab_id",@"name",@"id_card",@"phone",@"address",@"birthday",@"nation",
                           @"region",@"gender",@"is_cancer",@"onset_age",@"condition",@"family_is_cancer",@"relation",@"family_cancer",@"other_disease"];
    for (int i=0; i<itemArray.count; i++) {
        for (UIView *obj in self.subviews) {
            if (obj.tag == i+101) {
                NSString *unitStr = [dic objectForKey:itemArray[i]];
                
                if ([obj isKindOfClass:[contentTF class]]) {
                    contentTF *object = (contentTF *)obj;
                    object.text = unitStr;
                }
                else if ([obj isKindOfClass:[UISingleSelector class]]){
                    UISingleSelector *object = (UISingleSelector *)obj;
                    object.switchId = unitStr;
                }
                else if ([obj isKindOfClass:[UITextView class]]){
                    UITextView *object = (UITextView *)obj;
                    object.text = unitStr;
                }
                else if ([obj isKindOfClass:[UIComboBox class]]){
                    UIComboBox *object = (UIComboBox *)obj;
                    switch (object.tag) {
                        case 103:
                            object.selectId = (int)[organization_id_Array indexOfObject:unitStr];
                            break;
                        case 104:
                            selectedDor = unitStr;
                            break;
                        case 118:{
                            object.selectId = (int)[object.comboList indexOfObject:unitStr];
                            NSLog(@"%ld",object.selectId);
                        }
                            break;
                        default:
                            object.selectId = [recieve_id_array indexOfObject:unitStr];
                            break;
                    }
                }
            }
        }
    }
}

#pragma mark 保存按钮
- (void)saveBtenClick{
    NSString *Str = [self builtToSendString];
    NSDictionary *postDic = parseJsonString(Str);
    
    if (!postDic) {
        return;
    }
    
    UIViewController *superController;
    for (UIView *next = self.superview;next != nil;next = next.superview) {
        UIResponder *nextresponder = [next nextResponder];
        if ([nextresponder isKindOfClass:[UIViewController class]]) {
            superController = (UIViewController *)nextresponder;
            break;
        }
    }
    
    NSMutableString *postStr = [[NSMutableString alloc] init];
    
    for (NSString *key in postDic) {
        [postStr appendString:[NSString stringWithFormat:@"&%@=%@",key,[postDic objectForKey:key]]];
    }
    [postStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?token=%@&order_code=%@",SaveUser_URL,_token,DDBHtf.text];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *response = sendFullRequest(urlStr, [[postStr copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil, nil, NO);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!response) {
                alertMsgView(@"网络连接错误，请检查网络",superController);
                return ;
            }
            
            NSDictionary *returnDic = parseJsonResponse(response);
            if (!returnDic) {
                alertMsgView(@"返回数据错误，请重试", superController);
                return;
            }
            NSNumber *result = [returnDic objectForKey:@"err"];
            if ([result integerValue] !=0) {
                alertMsgView(@"保存失败，请重试", superController);
                return;
            }
            
            alertMsgView(@"保存成功", superController);
        });
    });
    
    NSLog(@"%@",Str);
}

- (void)setTextFieldDelegate
{
    for (id object in self.subviews) {
        if ([object isKindOfClass:[contentTF class]]) {
            contentTF *tempTf = (contentTF *)object;
            tempTf.delegate = self;
        }
    }
}

//计算纵向位置
- (CGRect)caculateFrameY:(CGFloat)y isLeft:(BOOL)isLeft isLable:(BOOL)isLable
{
    CGRect currentFrame;
    CGRect lbLeftFrame = CGRectMake(50*SCREEN_WEIGHT/1024, (y)*SCREEN_HEIGHT/768, 90, 20);
    CGRect lbRightFrame = CGRectMake(357*SCREEN_WEIGHT/1024, (y)*SCREEN_HEIGHT/768,90 ,20);
    CGRect tfLeftFrame = CGRectMake(146*SCREEN_WEIGHT/1024, (y)*SCREEN_HEIGHT/768, 188, 22);
    CGRect tfRightFrame = CGRectMake(452*SCREEN_WEIGHT/1024, (y)*SCREEN_HEIGHT/768, 188, 22);
    if(isLeft)
    {
        if(isLable)
        {
            currentFrame = lbLeftFrame;
        }
        else
        {
            currentFrame = tfLeftFrame;
        }
    }
    else
    {
        if (isLable)
        {
            currentFrame = lbRightFrame;
        }
        else
        {
            currentFrame = tfRightFrame;
        }
    }
    
    return currentFrame;
}


- (void)tapAction:(UIGestureRecognizer *)sender
{
    [self endEditing:YES];
    [self resignFirstResponderNow];
}

- (void)resignFirstResponderNow
{
    for(id object in self.subviews)
    {
        if ([object isKindOfClass:[UIComboBox class]])
        {
            UIComboBox *combo = (UIComboBox *) object;
            [combo dismissTable];
        }
    }
}

- (void)cleanUpAllControl{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[contentTF class]]) {
            contentTF *object = (contentTF *)obj;
            object.text = @"";
        }
        if ([obj isKindOfClass:[UITextView class]]) {
            UITextView *object = (UITextView *)obj;
            object.text = @"";
        }
        if ([obj isKindOfClass:[UIComboBox class]]) {
            UIComboBox *object = (UIComboBox *)obj;
            [object resetCombo];
        }
    }
}

- (void)dateConfirm
{
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval start = [datePicker.date timeIntervalSince1970];
    NSTimeInterval value = end - start;
    age = value/(24 * 3600 * 365);
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    CSRQtf.text = [format stringFromDate:datePicker.date];
    [CSRQtf resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class])isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)fillNumber:(NSString *)numberStr
{
    DDBHtf.text = numberStr;
}

#pragma mark 键盘上浮
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTf_frame = [self convertRect:textField.frame toView:self.superview.superview];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentTf_frame = [self convertRect:textView.frame toView:self.superview.superview];
    return YES;
}

- (void) changeContentViewPoint:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    if (![notification.name isEqual:UIKeyboardWillHideNotification] && keyBoardEndY > currentTf_frame.origin.y + currentTf_frame.size.height) {
        return;
    }
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        if (![notification.name isEqual:UIKeyboardWillShowNotification]) {
            if (lastScroll == 0) {
                return ;
            }
            [self setContentOffset:CGPointMake(0, self.contentOffset.y - lastScroll) animated:YES]; // keyBoardEndY的坐标包括了状态栏的高度，要减去
            lastScroll = 0;
        }
        else
        {
            float a = self.contentOffset.y;
            [self setContentOffset:CGPointMake(0, self.contentOffset.y + currentTf_frame.origin.y + currentTf_frame.size.height + 10 - keyBoardEndY)];
            lastScroll = self.contentOffset.y - a;
        }
    }];
}

#pragma mark UIcomboBox代理
- (void)UIComboBox:(UIComboBox *)comboBox didSelectRow:(NSIndexPath *)indexPath
{
    if (comboBox.tag == 103) {
        [self doctorRequest:organization_id_Array[indexPath.row - 1]];
        
        //清空关联box
        UIComboBox *box = (UIComboBox *)[self viewWithTag:104];
        [box resetCombo];
        
        NSLog(@"%@",organization_id_Array[comboBox.selectId]);
    }
    
    if (comboBox.tag == 104) {
        NSLog(@"%@",doctor_id_Array[comboBox.selectId]);
    }
    
    NSLog(@"%@",comboBox.selectString);
    NSLog(@"%ld",(long)comboBox.selectId);
    
    
}

- (void)singleSelecotr:(UISingleSelector *)singleSelector DidSelectAtSelectList:(NSString *)selectString
{
    
}

#pragma mark 下拉菜单数据请求
- (void)orgnizitionRequest
{
    UIViewController *superController;
    for (UIView *next = self.superview;next != nil;next = next.superview) {
        UIResponder *nextresponder = [next nextResponder];
        if ([nextresponder isKindOfClass:[UIViewController class]]) {
            superController = (UIViewController *)nextresponder;
            break;
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?token=%@&product=%ld",ORGANIZATION_URL,_token,(long)_productId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *responseData = sendGETRequest(urlStr, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (!responseData) {
                alertMsgView(@"网络连接错误，请检查网络", superController);
            }
            NSDictionary *retunDic = parseJsonResponse(responseData);
            if (!retunDic) {
                alertMsgView(@"无法获取机构列表，返回数据有误", superController);
                return;
            }
            NSNumber *resault = [retunDic objectForKey:@"err"];
            if (!resault) {
                alertMsgView(@"无法获取机构列表，返回数据有误", superController);
                return;
            }
            NSInteger errmsg = [resault integerValue];
            if (errmsg > 0) {
                alertMsgView([retunDic objectForKey:@"errmsg"], superController);
                return;
            }
            NSArray *organizationArray = [retunDic objectForKey:@"data"];
            NSMutableArray *id_Array = [[NSMutableArray alloc] init];
            NSMutableArray *name_Array = [[NSMutableArray alloc] init];
            for (int i = 0; i<organizationArray.count; i++) {
                NSDictionary *orDic = organizationArray[i];
                [id_Array addObject:[orDic objectForKey:@"id"]];
                [name_Array addObject:[orDic objectForKey:@"name"]];
            }
            organization_id_Array = [id_Array copy];
            SJDWcb.comboList = [name_Array copy];
            
            if (_fillString) {
                [self fillUserData];
            }
        });
    });
}

- (void)doctorRequest:(NSString *)doctor_id
{
    UIViewController *superController;
    for (UIView *next = [self superview];next;next = next.superview) {
        UIResponder *nextresponder = [next nextResponder];
        if ([nextresponder isKindOfClass:[UIViewController class]]) {
            superController = (UIViewController *)nextresponder;
            break;
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@?token=%@&product=%ld",ORGANIZATION_URL,doctor_id,_token,(long)_productId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *responseData = sendGETRequest(urlStr, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!responseData) {
                alertMsgView(@"网络连接错误，无法获取医生列表，请检查网络", superController);
            }
            NSDictionary *retunDic = parseJsonResponse(responseData);
            if (!retunDic) {
                alertMsgView(@"无法获取医生列表，返回数据有误", superController);
                return;
            }
            NSNumber *resault = [retunDic objectForKey:@"err"];
            if (!resault) {
                alertMsgView(@"无法获取医生列表，返回数据有误", superController);
                return;
            }
            NSInteger errmsg = [resault integerValue];
            if (errmsg > 0) {
                alertMsgView([retunDic objectForKey:@"errmsg"], superController);
                return;
            }
            NSArray *doctor_array = [retunDic objectForKey:@"data"];
            NSMutableArray *id_array = [[NSMutableArray alloc] init];
            NSMutableArray *name_array = [[NSMutableArray alloc] init];
            for (int i=0; i<doctor_array.count; i++) {
                NSDictionary *doc_dic = doctor_array[i];
                [id_array addObject:[doc_dic objectForKey:@"id"]];
                [name_array addObject:[NSString stringWithFormat:@"%@  %@",[doc_dic objectForKey:@"department"],[doc_dic objectForKey:@"name"]]];
            }
            doctor_id_Array = [id_array copy];
            SJYScb.comboList = [name_array copy];
            
            UIComboBox *doctorBox = (UIComboBox *)[self viewWithTag:104];
            doctorBox.selectId = (int)[doctor_id_Array indexOfObject:selectedDor];
        });
    });
}

- (void)receiveOrgRequest{
    UIViewController *superController;
    for (UIView *next = [self superview];next;next = next.superview) {
        UIResponder *nextresponder = [next nextResponder];
        if ([nextresponder isKindOfClass:[UIViewController class]]) {
            superController = (UIViewController *)nextresponder;
            break;
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?token=%@",RecieveORG_URL,_token];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *responseData = sendGETRequest(urlStr, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!responseData) {
                alertMsgView(@"网络连接错误，无法获取医生列表，请检查网络", superController);
            }
            NSDictionary *retunDic = parseJsonResponse(responseData);
            if (!retunDic) {
                alertMsgView(@"无法获取医生列表，返回数据有误", superController);
                return;
            }
            NSNumber *resault = [retunDic objectForKey:@"err"];
            if (!resault) {
                alertMsgView(@"无法获取医生列表，返回数据有误", superController);
                return;
            }
            NSInteger errmsg = [resault integerValue];
            if (errmsg > 0) {
                alertMsgView([retunDic objectForKey:@"errmsg"], superController);
                return;
            }
            NSArray *doctor_array = [retunDic objectForKey:@"data"];
            NSMutableArray *id_array = [[NSMutableArray alloc] init];
            NSMutableArray *name_array = [[NSMutableArray alloc] init];
            for (int i=0; i<doctor_array.count; i++) {
                NSDictionary *doc_dic = doctor_array[i];
                [id_array addObject:[doc_dic objectForKey:@"id"]];
                [name_array addObject:[NSString stringWithFormat:@"%@",[doc_dic objectForKey:@"name"]]];
            }
            SYJGbox.comboList = [name_array copy];
            recieve_id_array = [id_array copy];
        });
    });
}

#pragma mark 转json字符串方法
- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

@end
