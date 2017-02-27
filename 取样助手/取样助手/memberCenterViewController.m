//
//  memberCenterViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2017/2/15.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "memberCenterViewController.h"

@interface memberCenterViewController ()

@end

@implementation memberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    self.view = table;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //图标 tag 1
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(11 * iphone_size_W, 17 * iphone_size_H, 24 * iphone_size_W, 24* iphone_size_H)];
        iconView.tag = 1;
        [cell.contentView addSubview:iconView];
        
        UILabel *listLb = [[UILabel alloc] initWithFrame:CGRectMake(48 * iphone_size_W, 24 * iphone_size_H, 200 * iphone_size_W, 14 * iphone_size_H)];
        listLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        listLb.tag = 2;
        [cell.contentView addSubview:listLb];
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn setTitle:@"登出" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logOutBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.frame = CGRectMake(136 * iphone_size_W, 131 * iphone_size_H, 104 * iphone_size_W, 30 * iphone_size_H);
        [logoutBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:114 blue:226 alpha:1]];
        logoutBtn.layer.cornerRadius = 10;
        logoutBtn.hidden = YES;
        logoutBtn.tag = 3;
        [cell.contentView addSubview:logoutBtn];
    }
    
    UIImageView *view = (UIImageView *)[cell.contentView viewWithTag:1];
   
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:2];
    
    UIButton *buton = (UIButton *)[cell.contentView viewWithTag:3];
    
    if (indexPath.row == 0) {
        view.image = [UIImage imageNamed:@"touxiang"];
        view.frame = CGRectMake(155 *iphone_size_W, 37*iphone_size_H, 66*iphone_size_W, 66*iphone_size_W);
        
        lable.text = (_userName.length > 0)?_userName:@"登录名称";// @"登录名称";
        lable.frame = CGRectMake(0, 123 *iphone_size_H, SCREEN_WEIGHT, 14*iphone_size_H);
        lable.textAlignment = NSTextAlignmentCenter;
        
        cell.backgroundColor = [UIColor colorWithMyNeed:214 green:232 blue:253 alpha:1];
    }
    else if(indexPath.row == 1)
    {
        view.image = [UIImage imageNamed:@"草稿箱"];
        view.frame = CGRectMake(11*iphone_size_W, 33 *iphone_size_H, 24 *iphone_size_W, 24 * iphone_size_W);
        lable.text = @"草稿箱";
        lable.frame = CGRectMake(54 * iphone_size_W, 38 * iphone_size_H, 200 * iphone_size_W, 14* iphone_size_H);
    }
    else if(indexPath.row == 2)
    {
        view.image = [UIImage imageNamed:@"投标纪录"];
        lable.text = @"操作记录";
    }
    else if (indexPath.row == 3)
    {
        view.image = [UIImage imageNamed:@"gg"];
        lable.text = @"公告";
    }
    else if (indexPath.row == 4)
    {
        view.image = [UIImage imageNamed:@"copy2"];
        lable.text = @"修改密码";
    }
    else
    {
        view.hidden = YES;
        lable.hidden = YES;
        buton.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:{
            draftViewControllerIphone *draftView = [[draftViewControllerIphone alloc] init];
            draftView.productList = _productList;
            
            [self.navigationController pushViewController:draftView animated:YES];
        }
            break;
        
        case 2:{
            oprateRecordVC *orvc = [[oprateRecordVC alloc]init];
            orvc.token = _token;
            [self.navigationController pushViewController:orvc animated:YES];
        }
            break;
        case 3:{
            firstItemViewController *fivc = [[firstItemViewController alloc] init];
            fivc.token = _token;
            fivc.title = @"公告";
            fivc.urlStr = news_URL;
            [self.navigationController pushViewController:fivc animated:YES];

        }
            break;
        case 4:{
            passwdChangeViewController *pcvc = [[passwdChangeViewController alloc] init];
            pcvc.token = _token;
            [self.navigationController pushViewController:pcvc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    switch (indexPath.row) {
        case 0:
            height = 169 * iphone_size_H;
            break;
        case 1:
            height = 65 * iphone_size_H;
            break;
        case 2:
            height = 47 * iphone_size_H;
            break;
        case 3:
            height = 47 * iphone_size_H;
            break;
        case 4:
            height = 47 * iphone_size_H;
            break;
        default:
            height = 228 * iphone_size_H;
            break;
    }
    return height;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)logOutBtnClickAction
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
