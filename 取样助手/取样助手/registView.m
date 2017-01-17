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



@implementation registViewNew
{
    UIDatePicker *datePicker;
    contentTF *CJRQtf;
    contentTF *DDBHtf;
    CGRect currentTf_frame;
    float lastScroll;
}
@synthesize hidden = _hidden;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentSize = CGSizeMake(frame.size.width, 1026*SCREEN_HEIGHT/768);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
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
    
    //送检样本
    contentLable *SJYBlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:YES] andText:@"送检样本"];
    [self addSubview:SJYBlb];
    contentTF *SJYBtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:92 isLeft:YES isLable:NO]];
    SJYBtf.text = _SJYB;
    [self addSubview:SJYBtf];
    //订单编号
    contentLable *DDBHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:YES] andText:@"送检编号"];
    [self addSubview:DDBHlb];
    DDBHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:92 isLeft:NO isLable:NO]];
    DDBHtf.text = _DDBH;
    [self addSubview:DDBHtf];
    
    //采集日期
    contentLable *CJRQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:168 isLeft:YES isLable:YES] andText:@"采集日期"];
    [self addSubview:CJRQlb];
    CJRQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:168 isLeft:YES isLable:NO]];
    CJRQtf.text = _CJRQ;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    CJRQtf.inputView = datePicker;
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 40)];
    toolBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(dateConfirm)];
    [item setTintColor:[UIColor blueColor]];
    toolBar.items = @[item];
    CJRQtf.inputAccessoryView = toolBar;
    [self addSubview:CJRQtf];
    
    
    //送检单位
    contentLable *SJDWlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:130 isLeft:YES isLable:YES] andText:@"送检单位"];
    [self addSubview:SJDWlb];
    
    UIComboBox *SJDWcb = [[UIComboBox alloc] initWithFrame:[self caculateFrameY:130 isLeft:YES isLable:NO]];
    SJDWcb.tag = 100;
    SJDWcb.delegate = self;
    SJDWcb.comboList = @[@"北大医院",@"301医院",@"北京武警总医院",@"协和医院",@"积水潭医院"];
    SJDWcb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    SJDWcb.comborColor = SJDWcb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    SJDWcb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self addSubview:SJDWcb];
    
    //送检医生
    contentLable *SJYSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:130 isLeft:NO isLable:YES] andText:@"送检医生"];
    [self addSubview:SJYSlb];
    
    UIComboBox *SJYScb = [[UIComboBox alloc]initWithFrame:[self caculateFrameY:130 isLeft:NO isLable:NO]];
    SJYScb.delegate = self;
    SJYScb.tag = 101;
    SJYScb.comboList = @[@"王医生",@"李医生",@"赵医生",@"孙医生",@"刘医生",@"郑大夫",@"郭博士"];
    SJYScb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    SJYScb.comborColor = SJYScb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    SJYScb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self addSubview:SJYScb];
    
    //分割线------------------------------------------------------------------------------------------------------------------------
    contentLable *tag2 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"受检人信息"];
    UITextField *blue2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 207, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue2.enabled = NO;
    blue2.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue2 addSubview:tag2];
    [self addSubview:blue2];
    
    //姓名
    contentLable *XMlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 isLeft:YES isLable:YES] andText:@"姓      名"];
    [self addSubview:XMlb];
    contentTF *XMtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 isLeft:YES isLable:NO]];
    XMtf.text = _NAME;
    [self addSubview:XMtf];
    //身份证号
    contentLable *SFZHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:257 isLeft:NO isLable:YES] andText:@"身份证号"];
    [self addSubview:SFZHlb];
    contentTF *SFZHtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:257 isLeft:NO isLable:NO]];
    SFZHtf.text = _SFZH;
    [self addSubview:SFZHtf];
    
    
    //联系电话
    contentLable *LXDHlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:290 isLeft:YES isLable:YES] andText:@"联系电话"];
    [self addSubview:LXDHlb];
    contentTF *LXDHtf  = [[contentTF alloc] initWithFrame:[self caculateFrameY:290 isLeft:YES isLable:NO]];
    LXDHtf.text = _LXDH;
    [self addSubview:LXDHtf];
    //报告寄送地址
    contentLable *BGJSDZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:290 isLeft:NO isLable:YES] andText:@"寄送地址"];
    [self addSubview:BGJSDZlb];
    contentTF *BGJSDZtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:290 isLeft:NO isLable:NO]];
    BGJSDZtf.text = _JSDZ;
    [self addSubview:BGJSDZtf];
    
    
    //出生日期
    contentLable *CSRQlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:323 isLeft:YES isLable:YES] andText:@"出生日期"];
    [self addSubview:CSRQlb];
    contentTF *CSRQtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:323 isLeft:YES isLable:NO]];
    CSRQtf.text = _CSRQ;
    [self addSubview:CSRQtf];
    
    
    //民族
    contentLable *MZlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:359 isLeft:YES isLable:YES] andText:@"民      族"];
    [self addSubview:MZlb];
    contentTF *MZtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:359 isLeft:YES isLable:NO]];
    MZtf.text = _MZ;
    [self addSubview:MZtf];
    //籍贯
    contentLable *JGlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:359 isLeft:NO isLable:YES] andText:@"籍      贯"];
    [self addSubview:JGlb];
    contentTF *JGtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:359 isLeft:NO isLable:NO]];
    JGtf.text = _JG;
    [self addSubview:JGtf];
    
    //性别
    contentLable *XBlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:323 isLeft:NO isLable:YES] andText:@"性      别"];
    [self addSubview:XBlb];
    UISingleSelector *XBSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:323 isLeft:NO isLable:NO]];
    XBSst.delegate = self;
    XBSst.tag = 100;
    XBSst.itemList = @[@"男",@"女"];
    XBSst.itemId = @[@"0",@"1"];
    [self addSubview:XBSst];
    
    //分割线------------------------------------------------------------------------------------------------------------------------
    contentLable *tag3 = [[contentLable alloc] initWithFrame:[self caculateFrameY:6 isLeft:YES isLable:YES] andText:@"健康信息"];
    UITextField *blue3 = [[UITextField alloc]initWithFrame:CGRectMake(0, 401, self.frame.size.width, 30 *SCREEN_HEIGHT/768)];
    blue3.enabled = NO;
    blue3.backgroundColor = [UIColor colorWithMyNeed:114 green:176 blue:248 alpha:1];
    [blue3 addSubview:tag3];
    [self addSubview:blue3];
    
    //癌症史
    contentLable *AZSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:450 isLeft:YES isLable:YES] andText:@"癌 症 史"];
    [self addSubview:AZSlb];
    
    UISingleSelector *AZSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:450 isLeft:YES isLable:NO]];
    AZSst.delegate = self;
    AZSst.tag = 101;
    AZSst.itemList = @[@"有",@"无"];
    AZSst.itemId = @[@"1",@"0"];
    //AZSst.switchId = _AZS_SWITCH;
    [self addSubview:AZSst];
    
    //发病年龄
    contentLable *FBNLlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:450 isLeft:NO isLable:YES] andText:@"发病年龄"];
    [self addSubview:FBNLlb];
    contentTF *FBNLtf = [[contentTF alloc] initWithFrame:[self caculateFrameY:450 isLeft:NO isLable:NO]];
    FBNLtf.text = _FBNL;
    [self addSubview:FBNLtf];
    
    //临床表现
    contentLable *LCBXlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:490 isLeft:YES isLable:YES] andText:@"临床表现及治愈情况"];
    [self addSubview:LCBXlb];
    contentTF *LCBXtf = [[contentTF alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    LCBXtf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,523 * SCREEN_HEIGHT/768, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    LCBXtf.text = _LCBX;
    [self addSubview:LCBXtf];
    
    //家族癌症史
    contentLable *JZAZSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:639 isLeft:YES isLable:YES] andText:@"家族癌症史"];
    [self addSubview:JZAZSlb];
    UISingleSelector *JZAZSst = [[UISingleSelector alloc] initWithFrame:[self caculateFrameY:639 isLeft:YES isLable:NO]];
    JZAZSst.delegate = self;
    JZAZSst.tag = 102;
    JZAZSst.itemList = @[@"有",@"无"];
    JZAZSst.itemId = @[@"1",@"0"];
    [self addSubview:JZAZSst];
    //关系
    contentLable *GXlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:639 isLeft:NO isLable:YES] andText:@"关      系"];
    [self addSubview:GXlb];
    UIComboBox *GXcb = [[UIComboBox alloc] initWithFrame:[self caculateFrameY:639 isLeft:NO isLable:NO]];
    GXcb.tag = 102;
    GXcb.delegate = self;
    GXcb.comboList = @[@"父母",@"子女",@"亲戚"];
    GXcb.placeColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
    GXcb.comborColor = GXcb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    GXcb.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self addSubview:GXcb];
    contentTF *JZAZStf = [[contentTF alloc] initWithFrame:CGRectZero];
    JZAZStf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,672*SCREEN_HEIGHT/768, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    JZAZStf.text = _JZAZS;
    [self addSubview:JZAZStf];
    
    //其他疾病
    contentLable *QTBSlb = [[contentLable alloc] initWithFrame:[self caculateFrameY:788 isLeft:YES isLable:YES] andText:@"其他疾病"];
    [self addSubview:QTBSlb];
    contentTF *QTBStf = [[contentTF alloc] initWithFrame:[self caculateFrameY:821 isLeft:YES isLable:NO]];
    QTBStf.frame = CGRectMake(52*SCREEN_WEIGHT/1024,821*SCREEN_HEIGHT/768, 588*SCREEN_WEIGHT/1024, 101*SCREEN_HEIGHT/768);
    QTBStf.text = _QTBS;
    [self addSubview:QTBStf];
    
    //保存按钮
    UIButton *saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBt.frame = CGRectMake(287 * SCREEN_WEIGHT/1024, 945*SCREEN_HEIGHT/768, 174*SCREEN_WEIGHT/1024, 52*SCREEN_HEIGHT/768);
    saveBt.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    saveBt.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    saveBt.layer.cornerRadius = 10;
    saveBt.showsTouchWhenHighlighted = YES;
    [saveBt setTitle:@"保存" forState:UIControlStateNormal];
    saveBt.tintColor = [UIColor whiteColor];
    [self addSubview:saveBt];
    
    [self setTextFieldDelegate];

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
    CGRect tfLeftFrame = CGRectMake(146*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768, 188, 22);
    CGRect tfRightFrame = CGRectMake(452*SCREEN_WEIGHT/1024, y*SCREEN_HEIGHT/768, 188, 22);
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

- (void)dateConfirm
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    CJRQtf.text = [format stringFromDate:datePicker.date];
    [CJRQtf resignFirstResponder];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTf_frame = [self convertRect:textField.frame toView:self.superview.superview];
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

- (void)UIComboBox:(UIComboBox *)comboBox didSelectRow:(NSIndexPath *)indexPath
{
    
}

- (void)singleSelecotr:(UISingleSelector *)singleSelector DidSelectAtSelectList:(NSString *)selectString
{
    
}

@end
