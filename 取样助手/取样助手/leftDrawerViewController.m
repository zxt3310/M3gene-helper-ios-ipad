//
//  leftDrawerViewController.m
//  UFanDrawer
//
//  Created by zxt on 15/8/21.
//  Copyright (c) 2015年 zxt. All rights reserved.
//

#import "leftDrawerViewController.h"

@interface leftDrawerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    mainViewControllerIpad *MainVc;
}
//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation leftDrawerViewController

-(void)loadView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.scrollEnabled = NO;
    self.view = self.tableView;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];  
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = @[@"",@"",@"",@"",@"",@""];
    self.itemsMenu = @[@"",@"我的订单",@"订单进度",@"草稿箱",@"操作记录",@"注销"];
    self.itemsImageName =@[@"",WDDD_IMG,WDDD_IMG,CGX_IMG,CZJL_IMG/*,WDXX_IMG,WDKH_IMG*/,WDKH_IMG];
    // Do any additional setup after loading the view.
    
    MainVc = (mainViewControllerIpad *)_mainVc;
    
    UILabel *versionLb = [[UILabel alloc] initWithFrame:CGRectMake(150, SCREEN_HEIGHT - 100, 200, 30)];
    versionLb.textAlignment = NSTextAlignmentCenter;
    NSDictionary *appInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [appInfoDic objectForKey:@"CFBundleShortVersionString"];
//    NSString *app_build = [appInfoDic objectForKey:@"CFBundleVersion"];
//    app_version = [app_version stringByAppendingString:[NSString stringWithFormat:@" build%@",app_build]];
    if ([longin_URL containsString:@"dev"]) {
        app_version = [app_version stringByAppendingString:@" Beta"];
    }
    versionLb.text = [NSString stringWithFormat:@"版本%@",app_version];
    versionLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    versionLb.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
    [self.view addSubview:versionLb];
    
    lastUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    lastToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(100*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768 - 15, 150*SCREEN_WEIGHT/1024, 22)];
        titleLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        titleLable.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        titleLable.tag = 1;
        [cell.contentView addSubview:titleLable];
        
        UILabel *userNameLb = [[UILabel alloc]initWithFrame:CGRectMake(200, 60, 88, 30)];
        userNameLb.font = titleLable.font;
        userNameLb.textColor = titleLable.textColor;
        userNameLb.hidden = YES;
        userNameLb.tag = 3;
        [cell.contentView addSubview:userNameLb];
        
        UIButton *passWordResign = [UIButton buttonWithType:UIButtonTypeSystem];
        passWordResign.frame = CGRectMake(300, 60, 88, 30);
        passWordResign.titleLabel.font = titleLable.font;
        [passWordResign setTitle:@"修改密码" forState:UIControlStateNormal];
        passWordResign.titleLabel.textColor = [UIColor colorWithMyNeed:120 green:167 blue:255 alpha:1];
        [passWordResign addTarget:self action:@selector(pswdBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        passWordResign.hidden = YES;
        passWordResign.tag = 4;
        [cell.contentView addSubview:passWordResign];
        
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60*SCREEN_WEIGHT/1024, 39*SCREEN_HEIGHT/768 - 15, 27*SCREEN_WEIGHT/1024, 27*SCREEN_HEIGHT/768)];   //侧边栏图标
        cellImageView.tag = 2;
        [cell.contentView addSubview:cellImageView];
        
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(46, titleLable.frame.origin.y + titleLable.frame.size.height + 10, self.view.frame.size.width - 46, 1)];
        lineLable.layer.borderWidth = 1;
        lineLable.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
        [cell.contentView addSubview:lineLable];
        if (indexPath.row == 0) {
            lineLable.hidden = YES;
            userNameLb.hidden = NO;
        }
    }
    
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
    title.text = (NSString *)self.itemsMenu[indexPath.row];       //设置cell文字
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];  //点击时颜色
    cell.backgroundColor = nil;  //cell背景色
    UIImageView *leftImg = (UIImageView *)[cell.contentView viewWithTag:2];
    
    leftImg.image =[UIImage imageNamed:self.itemsImageName[indexPath.row]];
    
    if(indexPath.row == 0)
      {
          UILabel *nameLb = (UILabel *)[cell.contentView viewWithTag:3];
          nameLb.text = lastUser;
          
          UIButton *btn = (UIButton *)[cell.contentView viewWithTag:4];
          btn.hidden = NO;
          
          leftImg.frame = CGRectMake(55*SCREEN_WEIGHT/1024, 33*SCREEN_HEIGHT/768, 82*SCREEN_WEIGHT/1024, 82*SCREEN_HEIGHT/768);
          leftImg.image = [UIImage imageNamed:@"touxiang"];
          cell.backgroundColor = [UIColor colorWithMyNeed:236 green:236 blue:236 alpha:1];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }

    return cell;
}
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return  142*SCREEN_HEIGHT/768;
    }

    return 61*SCREEN_HEIGHT/768;
}

- (void)func:(void (^)())block
{
   
}

- (void)pswdBtnClickAction
{
    passWordEditView *pev = [[passWordEditView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pev.userName = lastUser;
    pev.token = lastToken;
    [[UIApplication sharedApplication].keyWindow addSubview:pev];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    
    [self.UF_ViewController closeDrawerAnimtaion:YES complete:^(BOOL finished)
    {
        if(finished)
        {
            if([self.itemsMenu[indexPath.row] isEqualToString:@"我的订单"])
            {
                NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
                NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
                firstItemViewController *fivc = [[firstItemViewController alloc]init];
                fivc.token = lastToken;
                fivc.title = @"订单管理";
                fivc.urlStr = myOrderPage_URL;
                if(cookieArray.count>0)
                {
                   fivc.cookie = cookieArray[0];
                }
                [self.UF_ViewController.navigationController pushViewController:fivc animated:YES];
            }
            else if ([self.itemsMenu[indexPath.row] isEqualToString:@"订单进度"])
            {
                NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
                NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
                firstItemViewController *fivc = [[firstItemViewController alloc]init];
                fivc.token = lastToken;
                fivc.title = @"订单进度";
                fivc.urlStr = orderProcess_URL;
                if(cookieArray.count>0)
                {
                    fivc.cookie = cookieArray[0];
                }
                [self.UF_ViewController.navigationController pushViewController:fivc animated:YES];

            }
            else if([self.itemsMenu[indexPath.row] isEqualToString:@"草稿箱"])
            {
                mainViewControllerIpad *mv = (mainViewControllerIpad *)self.mainVc;
                
                draftViewController *dvc = [[draftViewController alloc]init];
                
                dvc.productList = mv.productList;
                
                [self.UF_ViewController.navigationController pushViewController:dvc animated:YES];
            }
            else if ([self.itemsMenu[indexPath.row] isEqualToString:@"操作记录"])
            {
                oprateRecordVC *orvc = [[oprateRecordVC alloc]init];
                orvc.token = lastToken;
                [self.navigationController pushViewController:orvc animated:YES];
            }
            else if([self.itemsMenu[indexPath.row] isEqualToString:@"注销"])
            {
                @try {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                @catch (NSException *exception)
                {
                    [self alertMsgView:exception.reason];
                }
                @finally
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadView" object:nil];
                    [self.mainVc updateToken:nil name:lastUser role:nil];
    
                }
            
                loginViewController *lvc = [[loginViewController alloc] init];
                UINavigationController *unv1 = [[UINavigationController alloc] initWithRootViewController:lvc];
                [unv1.navigationBar setTitleTextAttributes:
                 @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:18],
                   NSForegroundColorAttributeName:[UIColor blackColor]}];
                lvc.delegate = self.mainVc;
                lvc.leftdelegate = self;
                lvc.placeUserName = lastUser;
                [self presentViewController:unv1 animated:YES completion:nil];
                
            }
            else
                alertMsgView(@"该功能尚未开放，敬请期待", self);
        }
        else
            return ;
    }];
    
}

- (void)alertMsgView:(NSString *)alertMsg
{
    if(alertMsg)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ula];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)updateToken:(NSString *)token name:(NSString *)name role:(NSArray *)roleArray
{
    lastUser = name;
    lastToken = token;
    [self.tableView reloadData];
}

@end
