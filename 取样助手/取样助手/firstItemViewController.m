//
//  firstItemViewController.m
//  UFanDrawer
//
//  Created by zxt on 15/8/22.
//  Copyright (c) 2015年 zxt. All rights reserved.
//

#import "firstItemViewController.h"
#import "UIViewController+UFanViewController.h"
#import "CMCustomViews.h"

#define UFSCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UFSCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
@implementation firstItemViewController
{
    UIButton *orderBt;
    UIButton *zixunBt;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0,-60) forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:142.0/255 green:126.0/255 blue:188.0/255 alpha:.99];

    
    //loading 动画
    float topY = 180;
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        topY += 40;
    }
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(UFSCREEN_WIDTH/2.5, topY, 80, 70)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    
    hasLogin = NO;
   
    
    _html5WebView.delegate = self;
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"hasLoginState" object:nil];
 
    
    if([_strURL.absoluteString containsString:[NSString stringWithFormat:@"http://mapi.lhgene.cn/m/product"]])
    {
    orderBt = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 44, SCREEN_WEIGHT/2, 44)];
    [orderBt setTitle:@"预约取样" forState:UIControlStateNormal];
    [orderBt setTitleColor:[UIColor colorWithMyNeed:74 green:108 blue:204 alpha:1] forState:UIControlStateNormal];
    orderBt.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
    orderBt.backgroundColor = [UIColor colorWithMyNeed:242 green:240 blue:254 alpha:1];
    [orderBt addTarget:self action:@selector(orderBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBt];
    
    zixunBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2, SCREEN_HEIGHT - 44, SCREEN_WEIGHT/2, 44)];
    [zixunBt setTitle:@"在线咨询" forState:UIControlStateNormal];
    zixunBt.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
    zixunBt.backgroundColor = [UIColor colorWithMyNeed:242 green:240 blue:254 alpha:1];
    [zixunBt setTitleColor:[UIColor colorWithMyNeed:135 green:126 blue:188 alpha:1] forState:UIControlStateNormal];
    [zixunBt addTarget:self action:@selector(zixunBtClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:zixunBt];
    
    }
    
    _html5WebView.scalesPageToFit = YES;
    [_html5WebView loadRequest:[NSURLRequest requestWithURL:_strURL]];
    

}

- (void)orderBtClick
{
    return;
}

- (void)zixunBtClick
{
    return;
}

- (void)setLeftBarButtonItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
         self.navigationItem.leftBarButtonItem = item;
    
    
  
}

- (void)leftAction{
    
    
        if ([_html5WebView canGoBack])
             {
                 [_html5WebView goBack];
             }

    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    lastUserPhone = getStringForKey(@"userPhoneNo");
    lastToken = getStringForKey(@"token");
    if (lastToken !=nil & lastUserPhone !=nil)
    {
        hasLogin = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    if(hasLogin & ![_strURL.absoluteString isEqual:ZXZX_PAGE])
//    {
//        NSString *str = [NSString stringWithFormat:@"%@?token=%@",_strURL.absoluteString,lastToken];
//        NSURL *str_URL_withToken = [[NSURL alloc] initWithString:str];
//        _strURL = str_URL_withToken;
//    }
    
    NSLog(@"WebViewController URL: %@", _strURL);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    loadingView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
    NSString *title =[_html5WebView stringByEvaluatingJavaScriptFromString:@"document.title"];  //获取链接标题
    if(title.length>12)
    {
        title = [[title substringWithRange:NSMakeRange(0, 11)] stringByAppendingString:@"..."];
    }
    
    
    self.navigationItem.title = title;
    
    
    if([_html5WebView canGoBack])
    {
        [self setLeftBarButtonItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if([_html5WebView.request.URL.absoluteString containsString:[NSString stringWithFormat:@"http://mapi.lhgene.cn/m/product"]])
    {
        orderBt.hidden = NO;
        zixunBt.hidden = NO;
    }

    
    loadingView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    loadingView.hidden = YES;
}



-(void)receivedNotif:(NSNotification *)notification {
    hasLogin = YES;
}

@end


