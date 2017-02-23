//
//  uploadViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//
#define ScreenHigh [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//#define navigationBar self.navigationController.navigationBar.frame.size.height
#define toolBar [UIApplication sharedApplication].statusBarFrame.size.height

#import "uploadIphoneViewController.h"


@interface uploadIphoneViewController ()<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    
    UIImagePickerController *_imagePickController;
    BOOL isTakeMedicalPhoto; //是否拍病例
    NSString *imageId;
    NSMutableArray *imageIdArray; //图片 id 串
    UITableViewCell *cell4; //客户病例行
    NSString *index;
    UIImage *upimage; //处理后的上传图片 病例图
   
    UIView *background; //放大图片view
    BOOL allowRigest; //是否允许录入
    UITextField *productTF;
    
    float x;
    float y;
    
    NSInteger imageViewCount; //病例图view TAG计数
}
@end

@implementation uploadIphoneViewController

@synthesize cell = cell;
@synthesize productPicker = productPick;
@synthesize animateLoadView = animateLoadView;
@synthesize token = token;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        isTakeMedicalPhoto = NO;
        imageIdArray = [[NSMutableArray alloc] init];
        animateLoadView = [[UIImageView alloc] init];
        token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        cell4 = [[UITableViewCell alloc]init];
        allowRigest = YES;
        x = 0;
        y = 0;
        
        _productId = @"";
        _number = @"";
        _registString = @"";
        _productName = @"";
  
        imageViewCount = 10;  //从10开始
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"订单录入";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT,SCREEN_HEIGHT - SCREEN_HEIGHT/12.35) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    float topY = 320;
    if (ScreenHigh > 480.0) {
        topY += 40;
    }
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(ScreenWidth/2.5, topY, 80, 70)];
    _loadingView.hidden = YES;
    [self.view addSubview:_loadingView];
    
    
    //上传按钮
    _sendBt = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/12.35,SCREEN_WEIGHT/2, SCREEN_HEIGHT/12.35)];
    [_sendBt setTitle:@"确认上传" forState:UIControlStateNormal];
    [_sendBt setBackgroundColor:[UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1]];
    _sendBt.enabled = NO;
    [_sendBt addTarget:self action:@selector(sendBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBt];
    
    
    //取消按钮
    UIButton *cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, SCREEN_HEIGHT - SCREEN_HEIGHT/12.35, SCREEN_WEIGHT/2,SCREEN_HEIGHT/12.35)];
    [cancelBt setTitle:@"暂存到草稿箱" forState:UIControlStateNormal];
    [cancelBt setBackgroundColor:[UIColor colorWithRed:88.0/255 green:207.0/255 blue:225.0/255 alpha:1]];
    [cancelBt addTarget:self action:@selector(cancelBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBt];

    
    //照相机
    _imagePickController = [[UIImagePickerController alloc] init];
    _imagePickController.delegate = self;
    _imagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickController.allowsEditing = NO;
    
    //产品选择picker
    productPick = [[UIPickerView alloc] initWithFrame:CGRectMake(0,NAVIGATIONBAR_HEIGHT, SCREEN_WEIGHT, SCREEN_HEIGHT/3)];
    productPick.delegate = self;
    productPick.dataSource = self;
    [productPick setBackgroundColor:[UIColor whiteColor]];
    productPick.showsSelectionIndicator = YES;
    productPick.hidden = YES;
    [self.view addSubview:productPick];
    
    [self checkUpLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView部分

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (indexPath.row == 0) {
        height = SCREEN_HEIGHT/10.42;
    }
    else if (indexPath.row == 3)
    {
        height = SCREEN_HEIGHT/3.39;
    }
    else if (indexPath.row == 4)
    {
        height = SCREEN_HEIGHT/2.43;
    }
    else
    {
        height = SCREEN_HEIGHT/6.18;
    }
    
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifer = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        
        //标签 tag 1
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/13.89, SCREEN_HEIGHT/26.68,SCREEN_WEIGHT/2.37,SCREEN_HEIGHT/47.64)];
        nameLable.tag = 1;
        nameLable.font = [UIFont fontWithName:TEXTFONT size:14];
        nameLable.hidden = YES;
        [cell.contentView addSubview:nameLable];
        
        //扫码按钮 6
        _scanBt = [UIButton buttonWithType:UIButtonTypeSystem];             //[[UIButton alloc] initWithFrame:CGRectMake(260, 30, 100, 40)];
        [_scanBt setTitle:@"扫码" forState:UIControlStateNormal];
        _scanBt.titleLabel.font = MYBUTTONFONT;
        _scanBt.frame = CGRectMake(SCREEN_WEIGHT/1.33, SCREEN_HEIGHT/30, SCREEN_WEIGHT/5.36, SCREEN_HEIGHT/26.68);
        [_scanBt setBackgroundColor:MYBUTTONCOLOR];
        _scanBt.tintColor = [UIColor whiteColor];
        _scanBt.tag = 6;
        _scanBt.hidden = YES;
        [_scanBt addTarget:self action:@selector(scanBtClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_scanBt];
        
        //拍照按钮  tag 2
        _photoBt = [UIButton buttonWithType:UIButtonTypeSystem];             //[[UIButton alloc] initWithFrame:CGRectMake(260, 30, 100, 40)];
        [_photoBt setTitle:@"拍照" forState:UIControlStateNormal];
        _photoBt.frame = CGRectMake(SCREEN_WEIGHT/1.33, SCREEN_HEIGHT/30, SCREEN_WEIGHT/5.36, SCREEN_HEIGHT/26.68);
        [_photoBt setBackgroundColor:MYBUTTONCOLOR];
        _photoBt.titleLabel.font = MYBUTTONFONT;
        _photoBt.tintColor = [UIColor whiteColor];
        _photoBt.tag = 2;
        [_photoBt addTarget:self action:@selector(photoBtClick) forControlEvents:UIControlEventTouchUpInside];
        _photoBt.hidden = YES;
        [cell.contentView addSubview:_photoBt];
        
        //条形码  tag  3
        UILabel *numberLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT-SCREEN_WEIGHT/1.59)/2, SCREEN_HEIGHT/11, SCREEN_WEIGHT/1.59, SCREEN_HEIGHT/30.32)];
        numberLable.textAlignment = NSTextAlignmentCenter;
        numberLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
        numberLable.tag = 3;
        numberLable.hidden = YES;
        numberLable.text = _number;
        [cell.contentView addSubview:numberLable];
        
        
        //拍照图片  tag 4
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2.62 - 20, SCREEN_HEIGHT/14.82, SCREEN_WEIGHT/4.08 + 40, SCREEN_WEIGHT/4.08 +40)];
        UITapGestureRecognizer *longTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:longTap];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 4;
        imageView.hidden = YES;
        imageView.image = _upOrderImg;
        [cell.contentView addSubview:imageView];
        
        //产品选择 tag 5
        productTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/3.61, SCREEN_HEIGHT/30.32, SCREEN_WEIGHT/1.99, SCREEN_HEIGHT/26.68)];
        productTF.borderStyle = UITextBorderStyleLine;
        productTF.textAlignment = NSTextAlignmentCenter;
        productTF.layer.borderColor = [UIColor blackColor].CGColor;
        productTF.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
        productTF.placeholder = @"点击选择";
        productTF.delegate = self;
        productTF.inputView = productPick;
        productTF.text = _productName;
        productTF.tag = 5;
        productTF.hidden = YES;
        [cell.contentView addSubview:productTF];
        
        //清除按钮 tag 7
        UIButton *clearBt = [[UIButton alloc] initWithFrame:_scanBt.frame];
        [clearBt setTitle:@"清除" forState:UIControlStateNormal];
        clearBt.backgroundColor = [UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1];
        clearBt.tintColor = [UIColor whiteColor];
        clearBt.titleLabel.font = MYBUTTONFONT;
        clearBt.tag = 7;
        [clearBt addTarget:self action:@selector(clearBtClick) forControlEvents:UIControlEventTouchUpInside];
        clearBt.hidden = YES;
        [cell.contentView addSubview:clearBt];
    }
    
    //产品选择
    if(indexPath.row == 0)
    {
        UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:1];
        nameLable.frame = CGRectMake(SCREEN_WEIGHT/13.89, SCREEN_HEIGHT/26.68,SCREEN_WEIGHT/6.696,SCREEN_HEIGHT/47.64);
        nameLable.text = @"产品选择";
        nameLable.hidden = NO;
        UITextField *uTF = (UITextField *)[cell.contentView viewWithTag:5];
        uTF.text = _productName;
        uTF.hidden = NO;
    }
    
    //检验扫码
    else if(indexPath.row == 1)
    {

        UILabel *numberLable = (UILabel *)[cell.contentView viewWithTag:3];
        numberLable.hidden = NO;
        numberLable.text = _number;
        UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:1];
        nameLable.text = @"检验单条码";
        nameLable.hidden = NO;
        UIButton *scan = (UIButton *)[cell.contentView viewWithTag:6];
        scan.hidden = NO;
    }
    
    //检验单照片
    else if(indexPath.row == 2)
    {
        
        UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:1];
        nameLable.text = @"检验单录入";
        nameLable.hidden = NO;
        UIButton *photo = (UIButton *)[cell.contentView viewWithTag:2];
        photo.hidden = NO;
        [photo setTitle:@"录入" forState:UIControlStateNormal];
        [photo removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [photo addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //检验单录入
    else if (indexPath.row == 3)
    {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:4];
        imageView.hidden = NO;
        imageView.image = _upOrderImg;
        
        UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:1];
        nameLable.text = @"检验单图片";
        nameLable.hidden = NO;
        UIButton *photo = (UIButton *)[cell.contentView viewWithTag:2];
        photo.hidden = NO;
    }
    
    //病例拍照
    else
    {
        cell4 = cell;
        UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:1];
        nameLable.text = @"拍客户病例(最多6张)";
        nameLable.hidden = NO;
        
        UIButton *clear = (UIButton *)[cell.contentView viewWithTag:7];
        clear.hidden = NO;
        
        UIButton *photo = (UIButton *)[cell.contentView viewWithTag:2];
        photo.frame = CGRectMake(clear.frame.origin.x - clear.frame.size.width - 10, clear.frame.origin.y, clear.frame.size.width, clear.frame.size.height);
        [photo removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [photo addTarget:self action:@selector(medicalPhotoClick) forControlEvents:UIControlEventTouchUpInside];
        photo.hidden = NO;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark Cell 按钮事件
- (void)medicalPhotoClick
{
    if(cell4.contentView.subviews.count >= 13)
    {
        alertMsgView(@"最多拍摄6张图片", self);
        return;
    }
    isTakeMedicalPhoto = YES;
    [self photoBtClick];
}

- (void)scanBtClick
{
    _svc = [[scanViewController alloc] init];
    
    _svc.delegate = self;
    [self.navigationController pushViewController:_svc animated:YES];
    
}
//拍照按钮
- (void)photoBtClick
{
    UIAlertController *uac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

//录入按钮点击
- (void)registe{
    
    if(_productName.length==0 || _number.length==0)
    {
        alertMsgView(@"请扫码或选择产品名称", self);
        return;
    }
    if(!allowRigest)
    {
        alertMsgView(@"该订单已存在，请勿反复提交", self);
    }
    
    orderRegisteViewController *orvc = [[orderRegisteViewController alloc] init];
    orvc.transDelegate = self;
    
    //orvc.orderUrl = [NSString stringWithFormat:@"%@/%@/%@?token=%@",orderComplate_URL,_number,_productId,token];
    
    NSString *isblank;
    if (_registString.length >0) {
        orvc.registStr = _registString;
        isblank = @"0";
    }
    else
        isblank = @"1";
    
    orvc.orderUrl = [NSString stringWithFormat:@"%@/%@/%@?token=%@&search=%@",orderComplate_URL,_number,_productId,token,isblank];

    [self.navigationController pushViewController:orvc animated:YES];
}

- (void)transRegistString:(NSString *)registStr
{
    _registString = registStr;
}

//清除按钮点击事件
- (void)clearBtClick
{
    if(!_medicalImage)
    {
        return;
    }
    for (int i = 10 ; i< imageViewCount ; i++)
    {
        UIImageView *imageView = (UIImageView *)[cell4.contentView viewWithTag:i];
        [imageView removeFromSuperview];
    }
    _medicalImage = nil;
    [self deletePic];
    imageViewCount = 10;
    x = 0;
    y = 0;
    [imageIdArray removeAllObjects];
//    _sendBt.enabled = NO;
//    _sendBt.backgroundColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:1];
}

#pragma mark PickView部分
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _productList.count+1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return @"请选择产品";
    }
    NSDictionary *productDic = _productList[row - 1];
    NSString *productName = [productDic objectForKey:@"name"];
    return productName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        return;
    }
    
    NSDictionary *productDic = _productList[row - 1];
    _productName = [productDic objectForKey:@"name"];
    _productId = [productDic objectForKey:@"id"];
    self.productPicker.hidden = YES;
    
    NSString *alert = [self isAllowSend];
    if(!alert)
    {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }
    
    [self.tableView reloadData];
    
}


//文本框不可手动编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.productPicker.hidden = NO;
    return  NO;
}




#pragma mark 按钮事件


- (void)sendBtClick
{
    _loadingView.dscpLabel.text = @"正在上传";
    _loadingView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        NSString *uploadUrl = [NSString stringWithFormat:orderUpload_URL];
        
        NSMutableString *upImageId = [[NSMutableString alloc] init];
        for (int i = 10; i<imageIdArray.count; i++) {
            [upImageId appendFormat:@"%@,",imageIdArray[i]];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",_productId,@"product",_number,@"order_code",_upOrderImg,@"pic",upImageId,@"medical_pics", nil];
        
        NSData *responsData = [self loadRequestWithImg:dic urlstring:uploadUrl];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            _loadingView.hidden = YES;
            
            if(!responsData)
            {
                NSLog(@"return nil");
                return;
            }
            
            NSDictionary *jsonData = parseJsonResponse(responsData);

            NSString *resault =[NSString stringWithFormat:@"%@",[jsonData objectForKey:@"err"]];
            
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
                    
                    if(_isReEditOperate)
                    {
                        NSArray *arry = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
                        NSMutableArray *operateArray = [[NSMutableArray alloc]initWithArray:arry];
                        [operateArray removeObjectAtIndex:_deleteIndex];
                        arry = [operateArray copy];
                        [[NSUserDefaults standardUserDefaults] setObject:arry forKey:[NSString stringWithFormat:@"CACHE_%@",_userName]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self.refreshDeletage refresh:arry];
                    }
                    
                    [self clearText];
                    [self checkUpLoad];
                }];
            }
            
        });
    });
}

- (void)cancelBtClick
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormat stringFromDate:[NSDate date]];
    
    //处理图片数据
    NSData *imgData = UIImagePNGRepresentation(_upOrderImg);
    if(!imgData)
    {
        imgData = [[NSData alloc]init];
    }
    NSArray *cacheArray = @[@"cacheType",@"operateTime",@"productName",@"productId",@"code_number",@"orderPic",@"registStr"];
    NSArray *cacheData = @[@"CACHE_ORDER",timeStr,productTF.text,_productId,_number,imgData,_registString];
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
            [self clearText];
            [self.refreshDeletage refresh:arry];
            [self checkUpLoad];
        }];
    }
}


#pragma mark 代理刷新cell
- (void) refreshCellNumber:(NSString *)code
{
    _number = code;
    _registString = @""; //清空jason字符串防止订单内容串号
    
    NSString *alert = [self isAllowSend];
    [self checkOrderRequest];
    if(!alert)
    {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
}



#pragma mark 调用相机
- (void)selectImageFromCamera
{
    _imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _imagePickController.mediaTypes = @[(NSString *)kUTTypeImage];
    
   // _imagePickController.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    _imagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self presentViewController:_imagePickController animated:YES completion:nil];
    
    
}

- (void)selectImageFromMedia
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_imagePickController.sourceType];
        
    }
    _imagePickController.delegate = self;
    [self presentViewController:_imagePickController animated:YES completion:nil];
}

#pragma mark 相机回掉
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    NSData *mydata = (__bridge_transfer NSData*)bitmapData;
    
    upimage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(800, 1200)];

    CFDataRef bitmapDataUP = CGDataProviderCopyData(CGImageGetDataProvider(upimage.CGImage));

    if(!isTakeMedicalPhoto)
    {
        _image = image;
        _upOrderImg = upimage;
        
        NSString *alert = [self isAllowSend];
        if(!alert)
        {
            _sendBt.enabled = YES;
            _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
        }
        
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
   
    else
    {
        //暂时禁止发送按钮
        _loadingView.dscpLabel.text = @"上传图片";
        _loadingView.hidden = NO;
        _sendBt.enabled = NO;
        _sendBt.backgroundColor = [UIColor colorWithRed:205.0/255 green:205.0/255 blue:205.0/255 alpha:205.0/255];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        
            NSString *uploadUrl = [NSString stringWithFormat:medical_pic_URL];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",upimage,@"pic", nil];
            
            NSData *responsData = [self loadRequestWithImg:dic urlstring:uploadUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!responsData)
                {
                    NSLog(@"return nil");
                    _loadingView.hidden = YES;
                    return;
                }
                
                NSDictionary *jsonData = parseJsonResponse(responsData);
                
                NSString *resault =[NSString stringWithFormat:@"%@",[jsonData objectForKey:@"err"]];
                
                NSInteger err = [resault integerValue];
                if (err > 0) {
                    NSString *errormsg = replaceUnicode(JsonValue([jsonData objectForKey:@"errmsg"],@"NSString"));
                    alertMsgView(errormsg, self);
                    _loadingView.hidden = YES;
                    return;
                }
                
                NSDictionary *reDic = [jsonData objectForKey:@"data"];
                imageId = [reDic objectForKey:@"id"];
                if(!imageId)
                {
                    alertMsgView(@"照片上传失败,图片过大", self);
                    _loadingView.hidden = YES;
                    return;
                }
            [imageIdArray addObject:imageId];
            
            //恢复发送按钮
            if(_productId !=nil & _number !=nil& _image != nil)
            {
                _sendBt.enabled = YES;
                _sendBt.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
            }
            _loadingView.hidden = YES;
            });
    #pragma mark  照相获取图片ID
          });
        
        _medicalImage = image;
        //动态生成图片
        UIImageView *imageView = [[UIImageView alloc]init];
        if (x > SCREEN_WEIGHT * 0.8) {
            x = 0;
            y = SCREEN_WEIGHT/4.17 + 20;
        }
        
        imageView.frame = CGRectMake(SCREEN_WEIGHT/14.26 + x,SCREEN_HEIGHT/11.32 + y, SCREEN_WEIGHT/4.17,SCREEN_WEIGHT/4.17);
        UITapGestureRecognizer *longTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:longTap];
        imageView.userInteractionEnabled = YES;
        imageView.image = _medicalImage;
        imageView.tag = imageViewCount;
        
        imageViewCount++;
       
        x = x + imageView.frame.size.width + SCREEN_WEIGHT/14.42;
        [cell4.contentView addSubview:imageView];
        
    }
    
    
    isTakeMedicalPhoto = NO;

    [self->_imagePickController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self->_imagePickController dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark 上传检查

- (void)checkUpLoad
{
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(_upOrderImg.CGImage));
    if(_productName.length>0 && _productId.length>0 && _number.length > 0 && bitmapData>0)
    {
        _sendBt.enabled = YES;
        _sendBt.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
    }
    else
    {
        _sendBt.enabled = NO;
        _sendBt.backgroundColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1];
    }
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

//#pragma mark 保存图片到document
//- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
//{
//    NSData* imageData = UIImagePNGRepresentation(tempImage);
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    // Now we get the full path to the file
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    // and then we write it out
//    [imageData writeToFile:fullPathToFile atomically:NO];
//}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



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

- (void)deletePic
{
    _loadingView.dscpLabel.text = @"正在删除";
    _loadingView.hidden = NO;
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
    {   _loadingView.hidden = YES;
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",medical_pic_delete_URL,deleteId];
    NSDictionary *tokenDic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(strUrl, tokenDic);
        dispatch_async(dispatch_get_main_queue(), ^{
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
            alertMsgView(@"图片清除失败", self);
            _loadingView.hidden = YES;
            return;
        }
        _loadingView.hidden = YES;
        
        });
    });
}

//检查订单是否重复
- (void)checkOrderRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?order_code=%@",orderCheck_URL,_number];
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(urlStr, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
           if(!response)
           {
               NSLog(@"send Faild");
               return ;
           }
            
            NSDictionary *responseData = parseJsonResponse(response);
            
            NSString *errStr = JsonValue([responseData objectForKey:@"err"],@"NSString");
            
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

#pragma mark 图片点击放大
//图片点击事件
//点击图片后的方法(即图片的放大全屏效果)
- (void) tapAction:(UITapGestureRecognizer *)sender
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,(NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT)/2, SCREEN_WEIGHT,
                                                             SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT - SCREEN_HEIGHT/12.35)];
    background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:bgView.frame];
    //要显示的图片，即要放大的图片
    UIImageView *imageView = (UIImageView *)sender.view;
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

- (NSString *)isAllowSend
{
    NSString *alertMsg;
    if (!_productId) {
        alertMsg = @"请选择产品";
    }
    else if (!_number){
        alertMsg = @"请扫码";
    }
    else if (!_image) {
        alertMsg = @"请拍摄检验单";
    }

    return alertMsg;
}

- (void)clearText{
    _upOrderImg = [UIImage new];
    _number = @"";
    _productName = @"";
    _registString = @"";
    [self clearBtClick];
    [_tableView reloadData];
}

@end
