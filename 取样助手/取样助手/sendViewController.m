//
//  sendViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "sendViewController.h"
#define ScreenHigh [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define navigationBarFrame self.navigationController.navigationBar.frame.size.height
#define toolBar [UIApplication sharedApplication].statusBarFrame.size.height

@interface sendViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSString *token;
    NSString *expressID;
    UILabel *expressSelectLb;
    UITextField *expressNumberTF;
    UITextField *priceTF;
    UIScrollView *Scrollview;
    float y;
    NSMutableArray *codeArray;
    NSInteger lableTag;
}

@end

@implementation sendViewController


- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _isExpressNumber = NO;
        token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        codeArray = [[NSMutableArray alloc]init];
        lableTag = 1;
//        _expressNumber = @"";
//        _expressName = @"";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
    
    //tablecell
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WEIGHT, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -STATUSBAR_HEIGHT - 70) style:UITableViewStylePlain];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.tableView setDelegate:self];
//    [self.tableView setDataSource:self];
//    [self.view addSubview:self.tableView];
    //取快递列表
    [self expressListRequest];
    
    //快递列表
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 250, ScreenWidth, ScreenHigh - 250)];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.hidden = YES;
    [self.view addSubview:_pickerView];
   
    //上传按钮
    _sendBt = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/12.35,SCREEN_WEIGHT/2, SCREEN_HEIGHT/12.35)];
    [_sendBt setTitle:@"确认上传" forState:UIControlStateNormal];
    [_sendBt setBackgroundColor:[UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1]];
    _sendBt.enabled = NO;
    [_sendBt addTarget:self action:@selector(sendBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBt];
    
    
    //取消按钮
    UIButton *cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, SCREEN_HEIGHT - SCREEN_HEIGHT/12.35, SCREEN_WEIGHT/2,SCREEN_HEIGHT/12.35)];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBt setBackgroundColor:[UIColor grayColor]];
    [cancelBt addTarget:self action:@selector(cancelBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBt];
    
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //快递区域
    UIView *expressView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WEIGHT, SCREEN_HEIGHT/4.83)];
    expressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:expressView];
    
    
    //选择快递
    UILabel *expressNamelable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/37 + 50,SCREEN_HEIGHT/37 ,SCREEN_WEIGHT/6.69,SCREEN_HEIGHT/26.76)];
    expressNamelable.text = @"快递公司";
    expressNamelable.font = MYUIFONT;
    [expressView addSubview:expressNamelable];
    
    //标签
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/37 + 50,SCREEN_HEIGHT/37 + expressNamelable.frame.size.height + 13, SCREEN_WEIGHT/6.69, SCREEN_WEIGHT/26.79)];
    nameLable.text = @"快递单号";
    nameLable.font = MYUIFONT;
    [expressView addSubview:nameLable];

    
    //选择快递 内容lable
    expressSelectLb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/3.947,SCREEN_HEIGHT/44.47 +3 ,SCREEN_WEIGHT/1.99,SCREEN_HEIGHT/26.68)];
    expressSelectLb.layer.borderWidth = 1;
    expressSelectLb.font = MYUIFONT;
    [expressView addSubview:expressSelectLb];
    
    
    //快递单号 输入框
    expressNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/3.947,SCREEN_HEIGHT/44.47 +5 + expressSelectLb.frame.size.height + 18,SCREEN_WEIGHT/1.99,SCREEN_HEIGHT/26.68)];
    expressNumberTF.layer.borderColor = [UIColor blackColor].CGColor;
    expressNumberTF.layer.borderWidth = 1;
    expressNumberTF.delegate = self;
    expressNumberTF.font = MYUIFONT;
    [expressView addSubview:expressNumberTF];

    
    //选择快递按钮
    UIButton *choseExpressBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/1.26,SCREEN_HEIGHT/47.64 + 2, SCREEN_WEIGHT/5.36,SCREEN_HEIGHT/26.68)];
    [choseExpressBt setTitle:@"选择快递" forState:UIControlStateNormal];
    choseExpressBt.titleLabel.font = MYBUTTONFONT;
    [choseExpressBt setBackgroundColor:MYBUTTONCOLOR];
    choseExpressBt.tintColor = [UIColor whiteColor];
    [choseExpressBt addTarget:self action:@selector(choseExpressBtClick) forControlEvents:UIControlEventTouchUpInside];
    [expressView addSubview:choseExpressBt];
    
    //扫码按钮
    _scanBt = [UIButton buttonWithType:UIButtonTypeCustom];             //[[UIButton alloc] initWithFrame:CGRectMake(260, 30, 100, 40)];
    [_scanBt setTitle:@"扫码" forState:UIControlStateNormal];
    _scanBt.tintColor = [UIColor whiteColor];
    _scanBt.titleLabel.font = MYBUTTONFONT;
    _scanBt.frame = CGRectMake(SCREEN_WEIGHT/1.26,SCREEN_HEIGHT/47.64 + choseExpressBt.frame.size.height + 22, SCREEN_WEIGHT/5.36,SCREEN_HEIGHT/26.68);
    [_scanBt setBackgroundColor:MYBUTTONCOLOR];
    _scanBt.tag = 5;
    [_scanBt addTarget:self action:@selector(scanBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [expressView addSubview:_scanBt];

    
    //快递价格
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/37 + 50,nameLable.frame.origin.y + nameLable.frame.size.height + 6 + 7,SCREEN_WEIGHT/6.69,SCREEN_HEIGHT/26.76)];
    priceLable.text = @"快递价格";
    priceLable.font = MYUIFONT;
    [expressView addSubview:priceLable];
    
    //价格lable
    priceTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/3.947,expressNumberTF.frame.origin.y + expressNumberTF.frame.size.height + 18,SCREEN_WEIGHT/1.99,SCREEN_HEIGHT/26.68)];
    priceTF.placeholder = @"请输入价格";
    priceTF.delegate = self;
    priceTF.layer.borderWidth = 1;
    priceTF.font = MYUIFONT;
    [expressView addSubview:priceTF];
    
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    //条形码区域
    Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,expressView.frame.origin.y + expressView.frame.size.height + 10,SCREEN_WEIGHT,SCREEN_HEIGHT - navigationBarFrame - STATUSBAR_HEIGHT - expressView.frame.size.height - SCREEN_HEIGHT/12.35 - 20)];
    Scrollview.backgroundColor = [UIColor whiteColor];
    Scrollview.contentSize = Scrollview.frame.size;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldHidde)];
    [Scrollview addGestureRecognizer:tap];
    Scrollview.scrollEnabled = YES;
    [self.view addSubview:Scrollview];
    
    UILabel *codeNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WEIGHT/17.86, SCREEN_WEIGHT/17.86, SCREEN_WEIGHT/4.26, SCREEN_HEIGHT/47.64)];
    codeNumberLb.text = @"检验单条形码";
    codeNumberLb.font = MYUIFONT;
    [Scrollview addSubview:codeNumberLb];
    
    //扫码按钮
    
    UIButton *codeScanBt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WEIGHT/1.75, SCREEN_HEIGHT/60.63, SCREEN_WEIGHT/5.36, SCREEN_HEIGHT/26.68)];
    [codeScanBt setTitle:@"扫码" forState:UIControlStateNormal];
    codeScanBt.tintColor = [UIColor whiteColor];
    codeScanBt.titleLabel.font = MYBUTTONFONT;
    codeScanBt.backgroundColor = MYBUTTONCOLOR;
    [codeScanBt addTarget:self action:@selector(scanBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [Scrollview addSubview:codeScanBt];
    
    //清除按钮
    UIButton *clearBt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WEIGHT/1.28, SCREEN_HEIGHT/60.63, SCREEN_WEIGHT/5.36, SCREEN_HEIGHT/26.68)];
    [clearBt setTitle:@"清除" forState:UIControlStateNormal];
    clearBt.tintColor = [UIColor whiteColor];
    clearBt.titleLabel.font = MYBUTTONFONT;
    clearBt.backgroundColor = [UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1];
    [clearBt addTarget:self action:@selector(clearBtClick) forControlEvents:UIControlEventTouchUpInside];
    [Scrollview addSubview:clearBt];
    
    
    //loading 菊花
    float topY = 320;
    if (ScreenHigh > 480.0) {
        topY += 40;
    }
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(ScreenWidth/2.5, topY, 80, 70)];
    _loadingView.hidden = YES;
    _loadingView.dscpLabel.text = @"正在上传";
    [self.view addSubview:_loadingView];
    

    // Do any additional setup after loading the view.
    
    
     [self.view bringSubviewToFront:_pickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark pickview快递列表部分

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _expressList.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return @"选择快递公司";
    }
    return _expressList[row-1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        return;
    }
    _expressName = _expressList[row - 1];
    expressSelectLb.text = _expressName;
    _pickerView.hidden = YES;
    
    if(([_expressName isEqualToString:@"自送"] & codeArray.count) >0)
    {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }
    else
    {
        _sendBt.enabled = NO;
        _sendBt.backgroundColor = [UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1];

    }
    
    if (_number !=nil &_expressNumber !=nil & _expressName !=nil) {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }
}

- (void)scanBtClick:(UIButton *)sender
{
    if(sender.tag == 5)
    {
        _isExpressNumber = YES;
    }
    _svc = [[scanViewController alloc] init];
    
    _svc.delegate = self;
    [self.navigationController pushViewController:_svc animated:YES];
  
    
}

- (void)clearBtClick
{
    for(int i=1 ; i<lableTag; i++)
    {
        UILabel *lable = (UILabel *)[Scrollview viewWithTag:i];
        [lable removeFromSuperview];
    }
    _number = nil;
    
    y=0;
    
    [codeArray removeAllObjects];
    _sendBt.enabled = NO;
    _sendBt.backgroundColor = [UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1];
    Scrollview.contentSize = Scrollview.frame.size;
}

- (void)expressBtClick
{
    _svc = [[scanViewController alloc] init];
    
    _svc.delegate = self;
    [self.navigationController pushViewController:_svc animated:YES];
    _isExpressNumber = YES;
}	


- (void)sendBtClick
{
    _loadingView.hidden = NO;
    [self sendPostRequest];
    _loadingView.hidden = YES;
}

- (void)cancelBtClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 代理刷新控件
- (void) refreshCellNumber:(NSString *)code
{
    if(!_isExpressNumber)
    {
        _number = code;
        
        UILabel *codeNumberLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT-SCREEN_WEIGHT/1.59)/2, SCREEN_HEIGHT/8.89 + y, SCREEN_WEIGHT/1.59, SCREEN_HEIGHT/30.32)];
        codeNumberLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        codeNumberLable.textAlignment = NSTextAlignmentCenter;
        
        codeNumberLable.textColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1];
        codeNumberLable.text = code;
        codeNumberLable.tag = lableTag;
        lableTag++;
        [Scrollview addSubview:codeNumberLable];
        
        y = y + SCREEN_HEIGHT/30.32 + 10;
        if(codeNumberLable.frame.origin.y + codeNumberLable.frame.size.height + 10 >= Scrollview.frame.size.height)
        {
            CGSize temp = Scrollview.contentSize;
            temp.height = temp.height + SCREEN_HEIGHT/30.32 + 10;
            Scrollview.contentSize = temp;
        }
        [codeArray addObject:code];
    }
    
    else
    {
        _expressNumber = code;
        expressNumberTF.text = _expressNumber;
        _isExpressNumber = NO;
        
    }
    
    if([_expressName isEqualToString:@"自送"])
    {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];

    }
   
    if (_number !=nil &_expressNumber !=nil & _expressName !=nil) {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }
    
}

- (void)choseExpressBtClick
{
    [_pickerView reloadAllComponents];
    _pickerView.hidden = NO;
    
}

- (void)checkSendButtonEnable:(NSNotification*) notice
{
    
}

#pragma mark 网络请求部分
//上传请求
- (void)sendPostRequest
{
    NSString *strUrl;
    if(_isSendExpress)
    {
      strUrl = [NSString stringWithFormat:uploadExpress_URL];
    }
    else
    {
        strUrl = [NSString stringWithFormat:uploadreport_URL];
    }
    
    NSMutableString *codeNumber = [[NSMutableString alloc]init];
    for(int i = 0 ; i < codeArray.count ; i++)
    {
        [codeNumber appendFormat:@",%@",codeArray[i]];
    }
    [codeNumber deleteCharactersInRange:NSMakeRange(0, 1)];
    
    //NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",codeNumber,@"order_code",_expressNumber,@"express_code",_expressName,@"express_type", nil];
    NSString *post = [NSString stringWithFormat:@"order_code=%@&price=%@&express_code=%@&express_type=%@",codeNumber,priceTF.text,expressNumberTF.text,_expressName];
    
    //NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSDictionary *additionalHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:token,@"token", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSData *response = sendRequestWithFullURLandHeaders(strUrl, post, additionalHeaders);
            dispatch_async(dispatch_get_main_queue(),^{
                if(!response)
                {
                    alertMsgView(@"无法链接服务器，请检查网络", self);
                    NSLog(@"send faild check");
                    return ;
                }
                
                NSString *respStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"%@",respStr);
                
                NSDictionary *dic = parseJsonResponse(response);
                NSNumber *resault = JsonValue([dic objectForKey:@"err"], @"NSNumber");
                if (resault == nil) {
                    alertMsgView(@"服务器维护中，请稍后再试", self);
                    return;
                }
                NSInteger err = [resault integerValue];
                if(err > 0)
                {
                    NSString *errormsg = replaceUnicode(JsonValue([dic objectForKey:@"errmsg"], @"NSString"));
                    alertMsgView(errormsg, self);
                    return;
                }
                
                for (id object in self.view.subviews) {
                    if ([object isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)object;
                        textField.text = @"";
                    }
                }
                [self clearBtClick];
                alertMsgView(@"上传成功", self);
                
        });
    });
    
}

//获取列表请求
- (void)expressListRequest
{
    NSString *strUrl = [NSString stringWithFormat:expressList_URL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(strUrl, nil);
    if (!response) {
        NSLog(@"response is null check");
        return ;
    }
        NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strResp);

        NSDictionary *responseData = parseJsonResponse(response);
        NSString *resault = JsonValue([responseData objectForKey:@"err"], @"NSString");
        NSInteger err = [resault integerValue];
        if(err > 0)
        {
            return;
        }
        _expressList = JsonValue([responseData objectForKey:@"data"], @"NSArray");
    });
}

- (void)textFieldHidde
{
    [self textFieldShouldReturn:priceTF];
    [self textFieldShouldReturn:expressNumberTF];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (event.allTouches.count > 1) {
        return;
    }
    
    UITouch *touch = event.allTouches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [expressNumberTF resignFirstResponder];
        [priceTF resignFirstResponder];
        [self.view resignFirstResponder];
    }
    
}

@end
