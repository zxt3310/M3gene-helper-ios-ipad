//
//  main.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetUtils.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString* deviceType = devicePlatForm();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
