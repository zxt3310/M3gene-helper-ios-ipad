//
//  scanExpressViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//
#define ScreenHigh [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "sendResaultViewController.h"

@interface sendResaultViewController ()

@end

@implementation sendResaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *resaultLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, 175, 50)];
    resaultLable.text = _resaultString;
    [self.view addSubview:resaultLable];
    
    
    UIButton *resignBt = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 100,587, 90, 50)];
    [resignBt setTitle:@"再次签到" forState:UIControlStateNormal];
    [resignBt setBackgroundColor:[UIColor blueColor]];
    [resignBt addTarget:self action:@selector(resignBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignBt];
    
    UIButton *checkBt = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 10, 587, 90, 50)];
    [checkBt setTitle:@"查看" forState:UIControlStateNormal];
    [checkBt setBackgroundColor:[UIColor blueColor]];
    [checkBt addTarget:self action:@selector(checkBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resignBtClick
{
  //  id abc = self.navigationController ;
   [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)checkBtClick
{
    [self.switchDelegate tabBarSwitch];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
