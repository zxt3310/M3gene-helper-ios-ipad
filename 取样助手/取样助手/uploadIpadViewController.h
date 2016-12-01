//
//  uploadIpadViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/11/25.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
#import "scanViewController.h"
#import "NetUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <WebKit/WebKit.h>
#import "CMCustomViews.h"

@interface uploadIpadViewController : UIViewController <WKUIDelegate>
@property NSArray *productList;
@property NSString *token;
@property NSString *userName;

@property NSString *productId; //产品ID
@property NSString *productName; //产品名字
@property NSString *number; //条码
@property NSString *registString; //录入信息字符串
@property UIImage *upOrderImg; //压缩后上传的检验单图片

@end
