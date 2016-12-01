//
//  uploadViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scanViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetUtils.h"
#import "CMCustomViews.h"
#import "publicMethod.h"

@interface uploadViewController : UIViewController <refreshCellNuber>

@property id <tabBarSwitchDelegate> switchDelegate;

@property scanViewController *svc;
@property (nonatomic) UITableView *tableView;

@property UIButton *scanBt;  //扫描按钮
@property UIButton *photoBt; //拍照按钮
@property NSString *number; //检验单条码

@property UIImageView *imageView;

@property UIImage *image;  //检验单图片
@property UIImage *medicalImage; //病例图片

@property LoadingView *loadingView;

@property UITableViewCell *cell;

@property UIButton *sendBt;

@property UIPickerView *productPicker;
@property NSArray *productList;
@property NSString *productName;
@property NSString *productId;

@property UIImageView *animateLoadView;
@end
