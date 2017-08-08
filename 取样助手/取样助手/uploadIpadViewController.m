//
//  uploadIpadViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/11/25.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "uploadIpadViewController.h"

@interface detailView : UIView
@property UIPickerView *productPicker;
@property UILabel *titleLable;
@property (nonatomic)BOOL hidden;
@end
@implementation detailView
@synthesize productPicker = productPicker;
@synthesize titleLable = titleLable;
@synthesize hidden = _hidden;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithMyNeed:230 green:230 blue:230 alpha:1].CGColor;
        self.hidden = YES;
        
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 110, 22)];
        titleLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        [self addSubview:titleLable];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    super.hidden = hidden;
    for (id object in self.subviews) {
        if ([object isKindOfClass:[registViewNew class]]) {
            registViewNew *tempView = (registViewNew *)object;
            tempView.hidden = hidden;
        }
    }
}

@end


@interface uploadIpadViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,refreshCellNuber,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    UITableView *leftView;
    LoadingView *loadingView;
    NSArray *listItem;  //列表标题
    UIButton *sendBt;   //上传按钮
    BOOL allowRigest;   //是否允许录入
    
    detailView *productView;
    detailView *scanCodeView;
    detailView *orderPicView;
    detailView *registPageView;
    detailView *medicalPicView;
    detailView *diseseSelectView;
    registViewNew *registNewView;

    
    NSArray *listView;
    UITextField *productTF; //产品信息
    UITextField *diseseTF; //疾病信息
    


    UITextField *numberLable;
    UIImageView *orderPic;
    UIView *background; //放大图片view
    UIImage *upimage; //处理后的上传图片 病例图
    BOOL isTakeMedicalPhoto;
    UIImage *_medicalImage; //病例图片
    int imageViewCount;//病例图片控件计数器
    NSString *imageId;
    NSMutableArray *imageIdArray; //图片 id 串
    
    CGFloat x; //动态生成病例图 偏移量
    CGFloat y; //
    
    WKWebView *html5Web;
    //---------------------------------
    UIComboBox *com;
}
@end


@implementation uploadIpadViewController

@synthesize productName = productName;
@synthesize productId = productId;
@synthesize number = number;
@synthesize registString = registString;
@synthesize upOrderImg = upOrderImg;
@synthesize isReEditOperate = isReEditOperate;
@synthesize deleteIndex = deleteIndex;
@synthesize diseseName = diseseName;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        listItem = @[@"产品选择",@"扫描检验单条形码",@"检验单录入",@"疾病选择",@"检验单图片",@"客户病例"];
        
        CGRect frame = CGRectMake(280 *SCREEN_WEIGHT/1024,101, 744*SCREEN_WEIGHT /1024,SCREEN_HEIGHT - 101);
        productView = [[detailView alloc]initWithFrame:frame];
        scanCodeView = [[detailView alloc]initWithFrame:frame];
        orderPicView = [[detailView alloc]initWithFrame:frame];
        registPageView = [[detailView alloc]initWithFrame:frame];
        medicalPicView = [[detailView alloc]initWithFrame:frame];
        diseseSelectView = [[detailView alloc]initWithFrame:frame];
        //registNewView = [[registViewNew alloc] initWithFrame:frame];
        
        isReEditOperate = NO;
        
        //暂存数据初始化
        productId =@"";
        productName=@"";
        number = @"";
        registString = @"";
        upOrderImg = [[UIImage alloc]init];
        
        imageIdArray = [[NSMutableArray alloc]init];
        html5Web = [[WKWebView alloc]init];
        
        x = 0;
        y = 0;
        imageViewCount = 10;
        isTakeMedicalPhoto = NO;

        listView = [NSArray arrayWithObjects:productView,scanCodeView,registPageView,diseseSelectView,orderPicView,medicalPicView,nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]init];
    tapG.delegate = self;
    [self.view addGestureRecognizer:tapG];
    
    leftView = [[UITableView alloc] initWithFrame:CGRectMake(0, 101, 280*SCREEN_WEIGHT/1024, SCREEN_HEIGHT - 101) style:UITableViewStylePlain];
    
    leftView.delegate =self;
    leftView.dataSource = self;
    leftView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    leftView.backgroundColor = [UIColor colorWithMyNeed:249 green:249 blue:249 alpha:1];
    leftView.scrollEnabled = NO;
    [self.view addSubview:leftView];
    [self setProductView];
    [self setScanView];
    [self setOrderPicView];
    [self setRegistView];
    [self setMedicalPicView];
    [self setDiseseSelectView];
    //默认选中第一行并实现第一行点击效果
    NSIndexPath *firstpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [leftView selectRowAtIndexPath:firstpath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:leftView didSelectRowAtIndexPath:firstpath];
    [self setNewBar];
    
    //loading 动画
    float topY = SCREEN_HEIGHT/3;
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT- 80)/2, topY, 80, 70)];
    loadingView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
    [self checkUpLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNewBar
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 101)];
    //header.layer.borderWidth = 1;
    //header.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
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
    
    sendBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBt setTitle:@"确认上传" forState:UIControlStateNormal];
    sendBt.titleLabel.textColor = [UIColor whiteColor];
    sendBt.enabled = NO;
    sendBt.layer.cornerRadius = 10;
    sendBt.frame = CGRectMake(736 * SCREEN_WEIGHT/1024, 46*SCREEN_HEIGHT/768, 120*SCREEN_WEIGHT/1024, 40);
    sendBt.backgroundColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1];
    [sendBt addTarget:self action:@selector(sendBtClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:sendBt];
    
    UIButton *cacheBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cacheBt setTitle:@"暂存到草稿箱" forState:UIControlStateNormal];
    cacheBt.titleLabel.textColor = [UIColor whiteColor];
    cacheBt.frame = CGRectMake(876 * SCREEN_WEIGHT/1024, 46*SCREEN_HEIGHT/768, 120*SCREEN_WEIGHT/1024, 40);
    cacheBt.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
    cacheBt.layer.cornerRadius = 10;
    [cacheBt addTarget:self action:@selector(cacheBtClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cacheBt];

    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"iconBack"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"iconBack"] forState:UIControlStateHighlighted];
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
    titleLabel.text = @"订单录入";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendBtClick
{
    loadingView.dscpLabel.text = @"正在上传";
    loadingView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        NSString *uploadUrl = [NSString stringWithFormat:orderUpload_URL];
        
        NSMutableString *upImageId = [[NSMutableString alloc] init];
        for (int i = 0; i<imageIdArray.count; i++) {
            [upImageId appendFormat:@",%@",imageIdArray[i]];
        }
        if(upImageId.length > 0)
        {
            [upImageId deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token",productId,@"product",numberLable.text,@"order_code",upOrderImg,@"pic",upImageId,@"medical_pics", nil];
        
        NSData *responsData = [self loadRequestWithImg:dic urlstring:uploadUrl];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            loadingView.hidden = YES;
            
            if(!responsData)
            {
                alertMsgView(@"无法连接服务器，请检查网络", self);
                NSLog(@"return nil");
                return;
            }
            
            NSDictionary *jsonData = parseJsonResponse(responsData);
            
            NSNumber *resault = JsonValue([jsonData objectForKey:@"err"],@"NSNumber");
            if (resault == nil) {
                alertMsgView(@"服务器维护中，请重试", self);
                return;
            }
            
            NSInteger err = [resault integerValue];
            if (err > 0) {
                NSString *errormsg = replaceUnicode(JsonValue([jsonData objectForKey:@"errmsg"],@"NSString"));
                alertMsgView(errormsg, self);
                return;
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ula = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:ula];
                [self presentViewController:alert animated:YES completion:^{
                    
                    if(isReEditOperate)
                    {
                        NSArray *arry = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
                        NSMutableArray *operateArray = [[NSMutableArray alloc]initWithArray:arry];
                        [operateArray removeObjectAtIndex:deleteIndex];
                        arry = [operateArray copy];
                        [[NSUserDefaults standardUserDefaults] setObject:arry forKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self.refreshDelegate refresh:arry];
                    }

                    [self clearUItext];
                    [self checkUpLoad];
                }];
            }
        });
    });
}

- (void)cacheBtClick
{

//    [html5Web evaluateJavaScript:@"app_fetch_form();" completionHandler:^(NSString *str,NSError *error){
//        
//        if(!str)
//        {
//            str = registString;
//        }
    
    //registString = str;
    for (id obj in diseseSelectView.subviews){
        if ([obj isKindOfClass:[registViewNew class]]) {
            registViewNew *object = (registViewNew *)obj;
            registString = [object builtToSendString];
        }
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormat stringFromDate:[NSDate date]];
    
    //处理图片数据
    NSData *imgData = UIImagePNGRepresentation(upOrderImg);
    if(!imgData)
    {
        imgData = [[NSData alloc]init];
    }
    NSArray *cacheArray = @[@"cacheType",@"operateTime",@"productName",@"productId",@"code_number",@"orderPic",@"registStr"];
    NSArray *cacheData = @[@"CACHE_ORDER",timeStr,productTF.text,productId,numberLable.text,imgData,registString];
    NSDictionary *cacheDic = [NSDictionary dictionaryWithObjects:cacheData forKeys:cacheArray];
    
    //存入数组
    
    NSArray *arry = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
    NSMutableArray *operateArray = [[NSMutableArray alloc]initWithArray:arry];
    if(isReEditOperate)
    {
        [operateArray removeObjectAtIndex:deleteIndex];
    }
    [operateArray addObject:cacheDic];
    arry = [operateArray copy];
    
    @try
    {
        [[NSUserDefaults standardUserDefaults] setObject:arry forKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ula];
        [self presentViewController:alert animated:YES completion:^{
            [self clearUItext];
            [self.refreshDelegate refresh:arry];
            [self checkUpLoad];
        }];
      }
//    }];
}
#pragma mark 左侧列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    height = 90*SCREEN_HEIGHT/768;

    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = listItem[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithMyNeed:230 green:230 blue:230 alpha:1].CGColor;
    cell.backgroundColor = tableView.backgroundColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    for(int i = 0;i < listView.count; i++)
    {
        detailView *view = (detailView *)listView[i];
        if(indexPath.row == i)
        {
            if(i == 2)
            {
                if(productTF.text.length == 0 || numberLable.text.length == 0)
                {
                    alertMsgView(@"请扫码或选择产品名称", self);
                    return;
                }
                else{
                    //判断完善页面是否需要从草稿箱中取出上次录入未保存的内容，如果需要research=1页面不从数据库中加载。反之为0；
                    NSString *isblank;
                    if(registString.length == 0)
                    {
                        isblank = @"1";
                    }
                    else
                    {
                        isblank = @"0";
                    }
                        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@?token=%@&search=%@",orderComplate_URL,numberLable.text,productId,_token,isblank];
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                        [html5Web loadRequest:request];
                    }
            }
            view.hidden = NO;
        }
        else
            view.hidden = YES;
    }
    
}
#pragma mark 右侧pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRow;
    if (pickerView.tag == 1) {
        numberOfRow = _productList.count+1;
    }
    else
    {
        return 5;
    }
    return numberOfRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *currentName;
    if(row == 0)
    {
        if (pickerView.tag == 1) {
            return @"请选择产品";
        }
        else{
            return @"请选择疾病";
        }
    }
    
    if (pickerView.tag == 1) {
        NSDictionary *productDic = _productList[row - 1];
        currentName = [productDic objectForKey:@"name"];
    }
    else {
        return @"test";
    }
    
    return currentName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row >0)
    {
        if(pickerView.tag == 1)
        {
            NSDictionary *productDic = _productList[row - 1];
            productName = [productDic objectForKey:@"name"];
            productId = [productDic objectForKey:@"id"];
            productTF.text = productName;
            [self checkUpLoad];
            [productTF resignFirstResponder];
        }
        else {
            
        }
    }
}

#pragma mark 右侧页面部分
#pragma mark 产品选择
- (void)setProductView
{
    productView.titleLable.text = @"产品选择";
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(egg:)];
//    tap.numberOfTapsRequired = 3;
//    [productView.titleLable addGestureRecognizer:tap];
//    productView.titleLable.userInteractionEnabled = YES;
    
    productView.productPicker = [[UIPickerView alloc]init];
    productView.productPicker.delegate = self;
    productTF = [[UITextField alloc]initWithFrame:CGRectMake(180, 55, 400, 30)];
    productTF.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
    productTF.placeholder = @"点击选择";
    productTF.textAlignment = NSTextAlignmentCenter;
    productTF.layer.borderWidth = 1;
    productTF.inputView = productView.productPicker;
    productView.productPicker.tag = 1;

    productTF.text = productName;
    
    [productView addSubview:productTF];
    [self.view addSubview:productView];
}

- (void)okClick
{
    productTF.text = productName;
    
    [self checkUpLoad];
    
    [productTF resignFirstResponder];
}

#pragma mark 检验单扫码
- (void)setScanView
{
    CGRect temp = scanCodeView.titleLable.frame;
    temp.size.width = 200;
    scanCodeView.titleLable.frame = temp;
    scanCodeView.titleLable.text = @"扫描检验单条形码";
    
    UIButton *scanBt = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBt.frame = CGRectMake(630*SCREEN_WEIGHT/1024,scanCodeView.titleLable.frame.origin.y + 40,80*SCREEN_WEIGHT/1024,40*SCREEN_HEIGHT/768);
    [scanBt setTitle:@"扫码" forState:UIControlStateNormal];
    scanBt.titleLabel.textColor = [UIColor whiteColor];
    scanBt.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
    scanBt.layer.cornerRadius = 5;
    [scanBt addTarget:self action:@selector(scanBtClick) forControlEvents:UIControlEventTouchUpInside];
    [scanCodeView addSubview:scanBt];
    
    numberLable = [[UITextField alloc]initWithFrame:CGRectMake(scanCodeView.titleLable.frame.origin.x, scanCodeView.titleLable.frame.origin.y + 40, 400*SCREEN_WEIGHT/1024, 40)];
    numberLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    numberLable.text = number;
    numberLable.layer.borderWidth = 1;
    [scanCodeView addSubview:numberLable];
  
    [self.view addSubview:scanCodeView];
}

- (void)scanBtClick
{
    scanViewController *svc = [[scanViewController alloc] init];
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];

}
//代理刷新
- (void) refreshCellNumber:(NSString *)code
{
    numberLable.text = code;
    
    self.registString = @"";
    
    [self checkUpLoad];
    //[self checkOrderRequest];
}

#pragma mark 检验单拍照
- (void)setOrderPicView
{
    CGRect temp = orderPicView.titleLable.frame;
    temp.size.width = 200;
    orderPicView.titleLable.frame = temp;
    orderPicView.titleLable.text = @"检验单拍照";
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(630*SCREEN_WEIGHT/1024,orderPicView.titleLable.frame.origin.y,80*SCREEN_WEIGHT/1024,40*SCREEN_HEIGHT/768);
    [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    photoBtn.titleLabel.textColor = [UIColor whiteColor];
    photoBtn.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
    [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [orderPicView addSubview:photoBtn];
    
    orderPic = [[UIImageView alloc]initWithFrame:CGRectMake(orderPicView.titleLable.frame.origin.x+80, orderPicView.titleLable.frame.origin.y + 100, 480*SCREEN_WEIGHT/1024, 280*SCREEN_WEIGHT/768)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapAction:)];
    [orderPic addGestureRecognizer:tap];
    orderPic.userInteractionEnabled = YES;
    orderPic.image = upOrderImg;
    [orderPicView addSubview:orderPic];
    
    [self.view addSubview:orderPicView];
}



#pragma mark 详细信息录入
- (void)setRegistView
{
    CGRect temp = registPageView.frame;
    temp.origin.x = temp.origin.y = 0;
    html5Web.frame = temp;
    [registPageView addSubview:html5Web];
    html5Web.UIDelegate = self;
    html5Web.navigationDelegate = self;
    [self.view addSubview:registPageView];
}

#pragma mark 病例拍照
- (void)setMedicalPicView
{
    medicalPicView.titleLable.text = @"客户病例（最多可上传6章图片）";
    CGRect temp = medicalPicView.titleLable.frame;
    temp.size.width = (medicalPicView.titleLable.text.length + 1) * 22;
    medicalPicView.titleLable.frame = temp;
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(530*SCREEN_WEIGHT/1024,orderPicView.titleLable.frame.origin.y,80*SCREEN_WEIGHT/1024,40*SCREEN_HEIGHT/768);
    [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    photoBtn.titleLabel.textColor = [UIColor whiteColor];
    photoBtn.backgroundColor = [UIColor colorWithMyNeed:88 green:207 blue:225 alpha:1];
    [photoBtn addTarget:self action:@selector(medicalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [medicalPicView addSubview:photoBtn];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(630*SCREEN_WEIGHT/1024,orderPicView.titleLable.frame.origin.y,80*SCREEN_WEIGHT/1024,40*SCREEN_HEIGHT/768);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearBtn.titleLabel.textColor = [UIColor whiteColor];
    clearBtn.backgroundColor = [UIColor colorWithMyNeed:200 green:200 blue:200 alpha:1];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [medicalPicView addSubview:clearBtn];
    
    [self.view addSubview:medicalPicView];
}

- (void)medicalBtnClick
{
    if(medicalPicView.subviews.count>8)
    {
        alertMsgView(@"最多拍摄6张图片", self);
        return;
    }
    isTakeMedicalPhoto = YES;
    [self photoBtnClick];
}

- (void)clearBtnClick
{
    if(!_medicalImage)
    {
        return;
    }
    for (int i = 10 ; i< imageViewCount ; i++)
    {
        UIImageView *imageView = (UIImageView *)[medicalPicView viewWithTag:i];
        [imageView removeFromSuperview];
    }
    _medicalImage = nil;
    [self deletePic];
    imageViewCount = 10;
    x = 0;
    y = 0;
    [imageIdArray removeAllObjects];
}

#pragma mark 疾病选择页面

- (void)setDiseseSelectView
{
//    diseseSelectView.titleLable.text = @"疾病选择";
//    diseseSelectView.productPicker = [[UIPickerView alloc]init];
//    diseseSelectView.productPicker.delegate = self;
//    diseseTF = [[UITextField alloc]initWithFrame:CGRectMake(180, 55, 400, 30)];
//    diseseTF.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
//    diseseTF.placeholder = @"点击选择";
//    diseseTF.textAlignment = NSTextAlignmentCenter;
//    diseseTF.layer.borderWidth = 1;
//    diseseTF.inputView = diseseSelectView.productPicker;
//    diseseSelectView.productPicker.tag = 2;
//    
//    diseseTF.text = diseseName;
//    
//    [diseseSelectView addSubview:diseseTF];
//    [self.view addSubview:diseseSelectView];
    
    registViewNew *registview = [[registViewNew alloc] initWithFrame:CGRectMake(0, 0, diseseSelectView.frame.size.width, diseseSelectView.frame.size.height)];
    registview.delegate = self;
    registview.token = self.token;
    registview.productId = 1;
    [registview show];
    [diseseSelectView addSubview:registview];
    
    [self.view addSubview:diseseSelectView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    registViewNew *regist = (registViewNew *)scrollView;
    [regist resignFirstResponderNow];
}
//检查订单是否重复
- (void)checkOrderRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?order_code=%@",orderCheck_URL,numberLable.text];
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(urlStr, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!response)
            {
                alertMsgView(@"无法连接服务器，请检查网络", self);
                NSLog(@"send Faild");
                return ;
            }
            
            NSDictionary *responseData = parseJsonResponse(response);
            
            NSNumber *errStr = JsonValue([responseData objectForKey:@"err"],@"NSNumber");
            
            if (errStr == nil) {
                alertMsgView(@"服务器维护中，请稍后再试", self);
                return;
            }
            
            NSInteger err = [errStr integerValue];
            
            if(err > 0)
            {
                NSString *errmsg = [responseData objectForKey:@"errmsg"];
                alertMsgView(errmsg, self);
                allowRigest = NO;
                return;
            }
            NSDictionary *dataDic = [responseData objectForKey:@"data"];
            //订单了类型
            NSString *type = [dataDic objectForKey:@"type"];
            NSLog(@"%@",type);
            
        });
    });
    
}

#pragma mark 拍照按钮事件
- (void)photoBtnClick
{
    UIAlertController *uac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nullable action){return;}];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"使用相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self selectImageFromCamera];
    }];
    UIAlertAction *mediaAction = [UIAlertAction actionWithTitle:@"从照片选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self selectImageFromMedia];
    }];
    [uac addAction:mediaAction];
    [uac addAction:cameraAction];
    [uac addAction:cancelAction];
    [self presentViewController:uac animated:YES completion:nil];
    
}

#pragma mark 调用相机或图库
- (void)selectImageFromCamera
{
    UIImagePickerController *_imagePickController = [[UIImagePickerController alloc]init];
    _imagePickController.delegate = self;
    _imagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickController.allowsEditing = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickController.mediaTypes = _imagePickController.mediaTypes = @[(NSString *)kUTTypeImage];
        
    }

    //_imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //_imagePickController.mediaTypes = @[(NSString *)kUTTypeImage];
    _imagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self presentViewController:_imagePickController animated:YES completion:nil];
}

- (void)selectImageFromMedia
{
    UIImagePickerController *_imagePickController = [[UIImagePickerController alloc] init];
    _imagePickController.delegate = self;
    _imagePickController.allowsEditing = NO;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_imagePickController.sourceType];
        
    }
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:_imagePickController];
    [pop presentPopoverFromRect:CGRectMake(100, 250, 400, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

#pragma mark 图片放大
- (void)imgTapAction:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)[sender view];
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(imageView.image.CGImage));
    if (bitmapData==0) {
        return;
    }
    
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WEIGHT,
                                                             SCREEN_HEIGHT)];
    background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:bgView.frame];
    //要显示的图片，即要放大的图片
    [imgView setImage:imageView.image];
    [bgView addSubview:imgView];
    
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:bgView];//放大过程中的动画
    
}

-(void)closeView{
    [background removeFromSuperview];
}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//保存图片到相册后的反馈 必须调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"%@",error);
    }
}
#pragma mark 相机回掉
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    NSData *mydata = (__bridge_transfer NSData*)bitmapData;
    if(image.size.height>image.size.width){
        upimage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(800, 1200)];
    }
    else{
        upimage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(1200, 800)];
    }
    
    CFDataRef bitmapDataUP = CGDataProviderCopyData(CGImageGetDataProvider(upimage.CGImage));
    
    if(!isTakeMedicalPhoto)
    {
        orderPic.image = image;
        upOrderImg = upimage;
        
        [self checkUpLoad];
    }
    
    else
    {
        //暂时禁止发送按钮
        loadingView.dscpLabel.text = @"上传图片";
        loadingView.hidden = NO;
//        _sendBt.enabled = NO;
//        _sendBt.backgroundColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:205.0/255];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
            
            NSString *uploadUrl = [NSString stringWithFormat:medical_pic_URL];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token",upimage,@"pic", nil];
            
            NSData *responsData = [self loadRequestWithImg:dic urlstring:uploadUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!responsData)
                {
                    alertMsgView(@"无法连接服务器，请检查网络", self);
                    NSLog(@"return nil");
                    loadingView.hidden = YES;
                    return;
                }
                
                NSDictionary *jsonData = parseJsonResponse(responsData);
                
                NSNumber *resault =JsonValue([jsonData objectForKey:@"err"],@"NSNumber");
                if (resault == nil) {
                    alertMsgView(@"服务器维护中，请稍后再试", self);
                    loadingView.hidden = YES;
                    return;
                }
                
                NSInteger err = [resault integerValue];
                if (err > 0) {
                    NSString *errormsg = replaceUnicode(JsonValue([jsonData objectForKey:@"errmsg"],@"NSString"));
                    alertMsgView(errormsg, self);
                    loadingView.hidden = YES;
                    return;
                }
                
                NSDictionary *reDic = [jsonData objectForKey:@"data"];
                imageId = [reDic objectForKey:@"id"];
                if(!imageId)
                {
                    alertMsgView(@"照片上传失败,图片过大", self);
                    loadingView.hidden = YES;
                    return;
                }
                [imageIdArray addObject:imageId];
                
                //恢复发送按钮
//                if(_productId !=nil & _number !=nil& _image != nil)
//                {
//                    _sendBt.enabled = YES;
//                    _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
//                }
                loadingView.hidden = YES;
            });
#pragma mark  照相获取图片ID
        });
        
        _medicalImage = image;
        //动态生成图片
        UIImageView *imageView = [[UIImageView alloc]init];
        if (x > medicalPicView.frame.size.width - 200*SCREEN_WEIGHT/1024) {
            x = 0;
            y = 150*SCREEN_HEIGHT/768 + 50;
        }
        
        imageView.frame = CGRectMake(24*SCREEN_WEIGHT/1024 + x,150*SCREEN_HEIGHT/768 + y, 200*SCREEN_WEIGHT/1024,150*SCREEN_HEIGHT/768);
        UITapGestureRecognizer *longTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapAction:)];
        [imageView addGestureRecognizer:longTap];
        imageView.userInteractionEnabled = YES;
        imageView.image = _medicalImage;
        imageView.tag = imageViewCount;
        
        imageViewCount++;
        
        x = x + imageView.frame.size.width + 48*SCREEN_WEIGHT/1024;
        [medicalPicView addSubview:imageView];
        
    }
    
    isTakeMedicalPhoto = NO;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark 图片压缩
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


#pragma mark 网络请求部分

#pragma mark 上传图片的 post 请求
- (NSData *)loadRequestWithImg:(NSDictionary *)params urlstring:(NSString *)url
{
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"] & ![key isEqualToString:@"token"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
        
    }
    
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"image.jpg\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    [request addValue:[params objectForKey:@"token"] forHTTPHeaderField:@"token"];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = nil;
    NSURLResponse *response = nil;
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *strResp = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strResp);
    
    NSHTTPURLResponse *httpResponse = nil;
    httpResponse = (NSHTTPURLResponse *) response;
    if ([httpResponse statusCode] != 200) {
        NSLog(@"Response error: http status %ld", (long)[httpResponse statusCode]);
        NSString *responseString = nil;
        responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
    }
    
    return returnData;
}
//清除图片
- (void)deletePic
{
    loadingView.dscpLabel.text = @"正在删除";
    loadingView.hidden = NO;
    NSMutableString *deleteId = [[NSMutableString alloc] init];
    for(int i=0; i<imageIdArray.count;i++)
    {
        [deleteId appendFormat:@",%@",imageIdArray[i]];
    }
    if(deleteId.length > 0)
    {
        [deleteId deleteCharactersInRange:NSMakeRange(0, 1)]; //删除首个逗号
    }
    else
    {
        loadingView.hidden = YES;
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",medical_pic_delete_URL,deleteId];
    NSDictionary *tokenDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(strUrl, tokenDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!response) {
                alertMsgView(@"无法连接服务器，请检查网络", self);
                NSLog(@"response is null check");
                return ;
            }
            NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",strResp);
            
            NSDictionary *responseData = parseJsonResponse(response);
            NSNumber *resault = JsonValue([responseData objectForKey:@"err"], @"NSNumber");
            if (resault == nil) {
                alertMsgView(@"服务器维护中，请稍后再试", self);
                return;
            }
            NSInteger err = [resault integerValue];
            if(err > 0)
            {
                alertMsgView(@"图片清除失败", self);
                loadingView.hidden = YES;
                return;
            }
            loadingView.hidden = YES;
            
        });
    });
}

//处理页面消息弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if(isReEditOperate)
        {
            //sleep(2);
    
            [html5Web evaluateJavaScript:[NSString stringWithFormat:@"app_fill_form('%@');",registString] completionHandler:nil];
        }
    });

}

- (void)clearUItext
{
    for (id object in [self.view subviews]) {
        if([object isKindOfClass:[detailView class]])
        {
            detailView *dv = (detailView *)object;
            for(id subobject in [dv subviews])
            {
                if([subobject isKindOfClass:[UITextField class]])
                {
                    UITextField *textFiled = (UITextField *)subobject;
                    textFiled.text = @"";
                }
                if([subobject isKindOfClass:[UIImageView class]])
                {
                    UIImageView *imageview = (UIImageView *)subobject;
                    imageview.image = [[UIImage alloc]init];
                }
                
            }
        }
    }
    [self clearBtnClick];
    //默认选中第一行并实现第一行点击效果
    NSIndexPath *firstpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [leftView selectRowAtIndexPath:firstpath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:leftView didSelectRowAtIndexPath:firstpath];
}

- (void)checkUpLoad
{
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(upOrderImg.CGImage));
    if(productTF.text.length>0 && productId !=nil && numberLable.text.length > 0 && bitmapData>0)
    {
        sendBt.enabled = YES;
        sendBt.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    }
    else
    {
        sendBt.enabled = NO;
        sendBt.backgroundColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![gestureRecognizer.view isKindOfClass:[UITextField class]] & ![touch.view isKindOfClass:[UIButton class]]) {
        [productTF resignFirstResponder];
        [numberLable resignFirstResponder];
        [diseseTF resignFirstResponder];
        
    }

    if([NSStringFromClass([touch.view class])isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    else
    {
        [com dismissTable];
    }
    
    return  YES;
}


@end
