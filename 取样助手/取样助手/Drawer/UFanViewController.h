//
//  UFanViewController.h
//  UFanDrawer
//
//  Created by zxt on 15/8/21.
//  Copyright (c) 2015年 zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicMethod.h"
@interface UFanViewController : UIViewController
{
  
    BOOL hasLogin;
}

@property (nonatomic, strong)  UIViewController *centerViewController;
@property (nonatomic, strong)  UIViewController *leftDrawerViewController;
@property (nonatomic, strong) UIViewController  *rightDrawerViewController;

//阴影
@property (nonatomic, assign)  BOOL showShadow;

-(instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController;

- (void)closeDrawerAnimtaion:(BOOL)animatied complete:(void(^)(BOOL finished))completion;

- (void)triggerLeftDrawer;

- (void)disMissLeftDrawer;

- (void)sethasLogin:(BOOL) hasLogin1;

- (BOOL)gethasLogin;
@end
