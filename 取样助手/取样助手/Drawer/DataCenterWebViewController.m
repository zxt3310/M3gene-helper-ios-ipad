//
//  DataCenterWebControllerViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/12/22.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "DataCenterWebViewController.h"

@interface DataCenterWebViewController ()
{
    UIWebView *html5View;
    LoadingView *loadingView;
}

@end

@implementation DataCenterWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    html5View = [[UIWebView alloc]init];
    html5View.delegate = self;
    self.view = html5View;
    html5View.scalesPageToFit = YES;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_urlString]];
    
    [request addValue:_cookie forHTTPHeaderField:@"Set-Cookie"];
    [request addValue:_token forHTTPHeaderField:@"token"];
    //request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [html5View loadRequest:[request copy]];
    
    //loading 动画
    float topY = SCREEN_HEIGHT/3;
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT- 80)/2, topY, 80, 70)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)navigationShouldPopOnBackButton
{
    if ([html5View canGoBack]) {
        [html5View goBack];
        return NO;
    }
    else
        return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    loadingView.dscpLabel.text = @"正在下载";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    loadingView.hidden = NO;
    
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    loadingView.hidden = YES;
}
@end
