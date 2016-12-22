//
//  DataCenterWebControllerViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/22.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPViewController.h"

@interface DataCenterWebViewController : UIViewController<UIWebViewDelegate>

@property NSString *urlString;
@property NSString *token;
@property NSString *cookie;

@end
