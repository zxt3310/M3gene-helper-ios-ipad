//
//  dataCenterViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/12/23.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtils.h"
#import "publicMethod.h"
#import "DataCenterWebViewController.h"
#import "Reachability.h"
#import "CustomURLCache.h"

@interface dataCenterViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property CustomURLCache *cache;

@end
