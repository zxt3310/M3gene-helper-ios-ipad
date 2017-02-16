//
//  draftViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
#import "NetUtils.h"
#import "uploadIpadViewController.h"
#import "VIPCardViewController-iphone.h"



@interface draftViewControllerIphone : UIViewController <cacheListRefresh>

@property NSArray *productList;
@end
