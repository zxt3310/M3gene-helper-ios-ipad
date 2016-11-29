//
//  orderRegisteViewController.m
//  取样助手
//
//  Created by 张信涛 on 16/11/5.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "orderRegisteViewController.h"
#import "publicMethod.h"

@interface orderRegisteViewController ()

@end

@implementation orderRegisteViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    
    NSURL *url = [NSURL URLWithString:_orderUrl];
    
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    //NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];  //获取链接标题
    self.title = @"订单完善";
    [self setBackButton];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)setBackButton
{
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBt setTitle:@" 返回" forState:UIControlStateNormal];
    [backBt setImage:[UIImage imageNamed:deviceImageSelect(@"iconBack.png")] forState:UIControlStateNormal];
    backBt.titleLabel.font = [UIFont systemFontOfSize:16];
    backBt.tintColor = [UIColor blackColor];
    backBt.frame = CGRectMake(0, 0, 55, 18);
    [backBt setHidden:NO];
    [backBt addTarget:self action:@selector(backBtClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBt];
    
}


- (void)backBtClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"确定退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert addAction:ula];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
