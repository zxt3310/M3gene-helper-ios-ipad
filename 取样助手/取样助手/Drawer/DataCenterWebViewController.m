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

    [html5View loadRequest:[request copy]];
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *titleStr = [html5View stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = titleStr;
}
@end
