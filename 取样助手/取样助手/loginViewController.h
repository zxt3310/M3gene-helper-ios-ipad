//
//  photoViewController.h
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtils.h"
#import "publicMethod.h"

@protocol loginUpdateToken <NSObject>
- (void)updateToken:(NSString *)token name:(NSString *)name role:(NSArray *)roleArray;
@end

@interface loginViewController : UIViewController

@property UITextField *username_TF;
@property UITextField *password_TF;
@property UIButton *loginBt;
@property UILabel *titleLable;
@property NSString *placeUserName;

@property id <loginUpdateToken> delegate;
@property id <loginUpdateToken> leftdelegate;
@end
