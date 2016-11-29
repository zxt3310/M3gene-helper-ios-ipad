//
//  firstItemViewController.h
//  UFanDrawer
//
//  Created by zxt on 15/8/22.
//  Copyright (c) 2015年 zxt. All rights reserved.
//
#import "UFanBasicViewController.h"
#import "UFanViewController.h"
#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "CMCustomViews.h"
@interface firstItemViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webViewHtml5;
    BOOL hasLogin;
    NSString *lastToken;
    NSString *lastUserPhone;
    WebViewJavascriptBridge *jsBridge;
    LoadingView *loadingView;
}
@property (strong, nonatomic) IBOutlet UIWebView *html5WebView;
@property (nonatomic, strong) NSURL *strURL;
@end
