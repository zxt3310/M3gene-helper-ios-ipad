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

}

- (instancetype)init
{
    self= [super init];
    if (self) {
        _isOperatePage = NO;
    }
    return  self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    webViewHtml5 = [[WKWebView alloc]init];
    webViewHtml5.navigationDelegate = self;
    self.view = webViewHtml5;
    webViewHtml5.UIDelegate = self;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_urlStr]];
    
    if(!_isOperatePage)
    {
        [request addValue:_cookie forHTTPHeaderField:@"Set-Cookie"];
        [request addValue:_token forHTTPHeaderField:@"token"];
        NSLog(@"%@",request.allHTTPHeaderFields);
    }


    [webViewHtml5 loadRequest:[request copy]];
    
    }



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    [webViewHtml5 evaluateJavaScript:@"document.title" completionHandler:^(NSString *titleStr,NSError *error){
        self.title = titleStr;
    }];
    //NSString *title =[webViewHtml5 stringByEvaluatingJavaScriptFromString:@"document.title"];  //获取链接标题
}

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


- (BOOL)navigationShouldPopOnBackButton
{
    if ([webViewHtml5 canGoBack]) {
        [webViewHtml5 goBack];
        return NO;
    }
    else
        return YES;
}

@end


