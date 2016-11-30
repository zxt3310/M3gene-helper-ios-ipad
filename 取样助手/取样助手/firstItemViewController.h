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
#import <WebKit/WebKit.h>
@interface firstItemViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *webViewHtml5;

    LoadingView *loadingView;
}
@property NSString *token;
@property NSString *urlStr;

@end
