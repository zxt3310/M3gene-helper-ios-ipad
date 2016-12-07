//
//  scanViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//
#define ScreenHigh  667//[UIScreen mainScreen].bounds.size.height
#define ScreenWidth 375 // [UIScreen mainScreen].bounds.size.width
#import "scanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "publicMethod.h"

@interface scanViewController ()

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    //[_output setRectOfInterest:CGRectMake(0.19, 0.21, 0.33, 0.59)];
    [_output setRectOfInterest:CGRectMake(0.21, 0.19, 0.59, 0.33)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    //设置条码类型
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    //添加扫描画面
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
    {
        _preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        [_output setRectOfInterest:CGRectMake(0.21, 0.48, 0.59, 0.33)];
    }
    else
    {
        _preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        [_output setRectOfInterest:CGRectMake(0.21, 0.19, 0.59, 0.33)];
    }
    
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    [self drawRect:self.view.layer.bounds];
    //开始扫描
    [_session startRunning];

//    UIButton *torchBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    torchBt.frame = CGRectMakeWithAutoSize((ScreenWidth - ScreenWidth/2)/2, ScreenHigh/1.5, ScreenWidth/2, 45);
//    [torchBt setTitle:@"手  电  筒" forState:UIControlStateNormal];
//    torchBt.tintColor = [UIColor whiteColor];
//    [torchBt setBackgroundColor:[UIColor blueColor]];
//    [torchBt addTarget:self action:@selector(torchOnTouchButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:torchBt];
    // Do any additional setup after loading the view.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        NSLog(@"qRcode = %@",stringValue);

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [_delegate refreshCellNumber:stringValue];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawRect:(CGRect)rect
{
    //中间镂空的矩形框
    CGRect cutRect = CGRectMakeWithAutoSize((ScreenWidth-220)/2,124,220,220);
    
    //边长
    CGFloat width = cutRect.size.width;
    
    CGFloat height = cutRect.size.height;
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:cutRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor grayColor].CGColor;
    fillLayer.opacity = 0.7;
    fillLayer.strokeColor = [UIColor whiteColor].CGColor;
   
    // 边界校准线
    const CGFloat lineWidth = 2;
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x - lineWidth/2,
                                                                         cutRect.origin.y - lineWidth/2,
                                                                         cutRect.size.width / 4.0,
                                                                         lineWidth)];
    //        追加路径
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x - lineWidth/2,
                                                                     cutRect.origin.y - lineWidth/2,
                                                                     lineWidth,
                                                                     cutRect.size.height / 4.0)]];
    
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x + width - cutRect.size.width / 4.0 + lineWidth/2,
                                                                     cutRect.origin.y - lineWidth/2,
                                                                     cutRect.size.width / 4.0,
                                                                     lineWidth)]];
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x + width ,
                                                                     cutRect.origin.y - lineWidth/2,
                                                                     lineWidth,
                                                                     cutRect.size.height / 4.0)]];
    
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x - lineWidth/2,
                                                                     cutRect.origin.y + height - cutRect.size.height / 4.0 + lineWidth/2,
                                                                     lineWidth,
                                                                     cutRect.size.height / 4.0)]];
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x - lineWidth/2,
                                                                     cutRect.origin.y + height,
                                                                     cutRect.size.width / 4.0,
                                                                     lineWidth)]];
    
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x + width,
                                                                     cutRect.origin.y + height - cutRect.size.height / 4.0 + lineWidth/2,
                                                                     lineWidth,
                                                                     cutRect.size.height / 4.0)]];
    [linePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(cutRect.origin.x + width - cutRect.size.width / 4.0 + lineWidth/2,
                                                                     cutRect.origin.y + height,
                                                                     cutRect.size.width / 4.0,
                                                                     lineWidth)]];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = linePath.CGPath;// 从贝塞尔曲线获取到形状
    pathLayer.fillColor = [UIColor blueColor].CGColor; //Color.CGColor; // 闭环填充的颜色
    //        pathLayer.lineCap       = kCALineCapSquare;               // 边缘线的类型
    //        pathLayer.strokeColor = [UIColor blueColor].CGColor; // 边缘线的颜色
    //        pathLayer.lineWidth     = 4.0f;                           // 线条宽度
    
    
    //扫描条动画
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(cutRect.origin.x,
                                                                      cutRect.origin.y,
                                                                      cutRect.size.width,
                                                                      lineWidth + 2)];
    line.image = [[UIImage imageNamed:@"line.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    line.tintColor = [UIColor greenColor];
    
    // 上下游走动画
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @0;
    animation.toValue = [NSNumber numberWithFloat:cutRect.size.height];
    animation.autoreverses = NO;
    animation.duration = 1.5;
    animation.repeatCount = FLT_MAX;
    [line.layer addAnimation:animation forKey:nil];
    [self.view addSubview:line];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMakeWithAutoSize((ScreenWidth - 220)/2, 360, 220, 30)];
    lable.numberOfLines = 0;
    lable.text = @"将条码放入框内，即可自动扫描";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable];
    
    [self.view.layer addSublayer:fillLayer];
    [self.view.layer addSublayer:pathLayer];
}


- (void)torchOnTouchButton:(UIButton *)sender{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.tag == 0) {
                
                sender.tag = 1;
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                sender.tag = 0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation *)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if (device.orientation == UIInterfaceOrientationLandscapeLeft) {
        _preview.connection.videoOrientation = UIInterfaceOrientationLandscapeLeft;
        [_output setRectOfInterest:CGRectMake(0.21, 0.48, 0.59, 0.33)];
    }
    else if(device.orientation == UIInterfaceOrientationLandscapeRight)
    {
        _preview.connection.videoOrientation = UIInterfaceOrientationLandscapeRight;
        [_output setRectOfInterest:CGRectMake(0.21, 0.19, 0.59, 0.33)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
