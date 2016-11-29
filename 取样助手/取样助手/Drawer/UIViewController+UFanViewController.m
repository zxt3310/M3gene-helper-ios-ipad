//
//  UIViewController+UFanViewController.m
//  UFanDrawer
//
//  Created by zxt on 15/8/21.
//  Copyright (c) 2015年 zxt. All rights reserved.
//

#import "UIViewController+UFanViewController.h"

@implementation UIViewController (UFanViewController)



-(UFanViewController *)UF_ViewController {
    
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if ([parentViewController isKindOfClass:[UFanViewController class]]) {
            return (UFanViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
      //  parentViewController.navigationItem.leftBarButtonItem.title = @"返回";
    }
    return nil;
}

@end
