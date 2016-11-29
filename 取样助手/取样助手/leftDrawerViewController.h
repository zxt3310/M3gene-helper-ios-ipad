//
//  leftDrawerViewController.h
//  UFanDrawer
//
//  Created by zxt on 15/8/21.
//  Copyright (c) 2015年 zxt. All rights reserved.
//

#import "UFanBasicViewController.h"
#import "firstItemViewController.h"
#import "UIViewController+UFanViewController.h"
#import "loginViewController.h"
//#import "Address.h"

@interface leftDrawerViewController : UFanBasicViewController


{
    NSString* lastUserPhone;
    NSString* lastToken;
    UIImageView *cellImageView;
    BOOL hasLogin;
    
    
    UINavigationController *unv;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *itemsMenu;
@property (nonatomic, strong) NSArray *itemsImageName;
@property (nonatomic, strong) UITableView *tableView;
@end
