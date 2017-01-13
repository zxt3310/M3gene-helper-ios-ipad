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
#import "mainViewController.h"
#import "draftViewController.h"
#import "oprateRecordVC.h"
#import "passWordEditView.h"
//#import "Address.h"

@interface leftDrawerViewController : UFanBasicViewController <loginUpdateToken>


{
    NSString* lastUser;
    NSString* lastToken;
    UIImageView *cellImageView;
    UINavigationController *unv;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *itemsMenu;
@property (nonatomic, strong) NSArray *itemsImageName;
@property (nonatomic, strong) UITableView *tableView;
@property id <loginUpdateToken> mainVc;
@end
