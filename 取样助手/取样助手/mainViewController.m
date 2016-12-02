//
//  ViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "mainViewController.h"

@implementation newTabBarController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 60;
    self.tabBar.frame = tabFrame;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:114.0/255 green:176.0/255 blue:248.0/255 alpha:1.];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //if([item isEqual:tabBar.items[1]])
    if ([item.title isEqualToString:@"操作记录"])
    {
       [self.navigationController.navigationBar setHidden:YES];
    }
    else
        [self.navigationController.navigationBar setHidden:NO];
}

@end

@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSString *userName;
    NSString *token;
    NSArray *role;
    UIButton *backBtn;
    
    BOOL allowRegist;
    BOOL allowSendEx;
    BOOL allowSendReport;
    //NSString *cookie;
}

@end

@implementation mainViewController
@synthesize productList = productList;
- (void)loadView
{
    [super loadView];
    _tableView.scrollEnabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (83 + 45), SCREEN_WEIGHT, SCREEN_HEIGHT - 83) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *newsLable = [[UITextField alloc]initWithFrame:CGRectMake(0, 103, SCREEN_WEIGHT, 45)];
    newsLable.backgroundColor = [UIColor colorWithMyNeed:250 green:247 blue:216 alpha:1];
    newsLable.enabled = NO;
    UITextField *contextLable = [[UITextField alloc] initWithFrame:CGRectMake(34, 13, 200, 19)];
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(34, 13, 21, 19)];
    leftImg.image = [UIImage imageNamed:@"喇叭"];
    contextLable.leftView = leftImg;
    contextLable.leftViewMode = UITextFieldViewModeAlways;
    contextLable.text = @"  今日公告";
    contextLable.enabled = NO;
    [newsLable addSubview:contextLable];
    [self.view addSubview:newsLable];
    

    role = [[NSUserDefaults standardUserDefaults] objectForKey:@"role"];
    allowRegist = NO;
    allowSendEx = NO;
    allowSendReport = NO;
    for(int i = 0; i<role.count; i++)
    {
        NSString *str = role[i];
        if([str isEqualToString:@"客户录入"])
        {
            allowRegist = YES;
        }
        if([str isEqualToString:@"样本寄送"])
        {
            allowSendEx = YES;
        }
        if([str isEqualToString:@"报告寄送"])
        {
            allowSendReport = YES;
        }
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self productListRequest];
    [self setNewBar];
    
}

- (instancetype)init
{
    self=[super init];
    if(self)
    {
      
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    

    if(!userName || !token)
    {
        loginViewController *lvc = [[loginViewController alloc] init];
        UINavigationController *unv = [[UINavigationController alloc] initWithRootViewController:lvc];
        [unv.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:18],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
        lvc.placeUserName = userName;
        lvc.delegate = self;
        [self presentViewController:unv animated:YES completion:nil];
    }
    //[self setRightButton];
}

- (void)setNewBar
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 83)];
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:header.frame];
    backimg.backgroundColor = [UIColor whiteColor];
    header.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.5].CGColor;
    header.layer.borderWidth = 0;
    [self.view addSubview:header];
    [header addSubview:backimg];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 8)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    CGRect rect = backBtn.frame;
    rect.origin.x = 30;
    rect.origin.y = 35;
    rect.size.height = 65;
    rect.size.width = 60;
    backBtn.frame = rect;
    [header addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width + 16, 32, SCREEN_WEIGHT - (rect.size.width+8) * 2, 44)];
    titleLabel.text = @"莲和运营后台";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:36];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
}

- (void)leftAction{
    [self.UF_ViewController triggerLeftDrawer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   if(!cell)
   {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
       UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(33, 15, 300, 36)];
       titleLable.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
       titleLable.tag = 1;
       [cell.contentView addSubview:titleLable];
       
       UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 3)];
       lineLable.layer.borderWidth = 1;
       lineLable.layer.borderColor = [UIColor colorWithMyNeed:224 green:224 blue:224 alpha:0.7].CGColor;
       lineLable.layer.shadowColor = [UIColor colorWithMyNeed:155 green:155 blue:155 alpha:1].CGColor;
       lineLable.layer.shadowOpacity = 1;
       lineLable.layer.shadowRadius = 5;
       lineLable.layer.shadowOffset = CGSizeMake(0, 1);
       lineLable.tag = 2;
       [cell.contentView addSubview:lineLable];
   }
    
   if(indexPath.row == 0)
   {
       UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
       title.text = @"常用功能";
       
       UILabel *line = (UILabel *)[cell.contentView viewWithTag:2];
       line.hidden = YES;
       
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgtapAction:)];
       
       UIImage *luruImage = [UIImage imageNamed:@"dingdanluruCopy"];
       UIImageView *luruImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 53*SCREEN_HEIGHT/768, SCREEN_WEIGHT/3, 190*SCREEN_HEIGHT/768)];
       luruImageView.image = luruImage;
       [cell.contentView addSubview:luruImageView];
       
       UIImageView *yangbenImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/3, 53*SCREEN_HEIGHT/768, SCREEN_WEIGHT/3, 190*SCREEN_HEIGHT/768)];
       yangbenImgView.image = [UIImage imageNamed:@"jisongyangben"];
       [cell.contentView addSubview:yangbenImgView];
       
       UIImageView *reportImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*2/3, 53*SCREEN_HEIGHT/768, SCREEN_WEIGHT/3, 190*SCREEN_HEIGHT/768)];
       reportImgView.image = [UIImage imageNamed:@"jisongbaogao"];
       [cell.contentView addSubview:reportImgView];
       
       [cell.contentView addGestureRecognizer:tap];

   }
   else if(indexPath.row == 1)
   {
       UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
       title.text = @"资料中心";
   }
   else
   {
       UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
       title.text = @"各业务接口人";
       
       UILabel *contectLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 89*SCREEN_HEIGHT/768, SCREEN_WEIGHT, 40)];
       contectLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
       contectLable.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
       contectLable.textAlignment = NSTextAlignmentCenter;
       contectLable.text = @"网络：赵刚（13800138000）    权限：张鹏（13800138000）    客服：刘小平（13800138000）";
       [cell.contentView addSubview:contectLable];
   }
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.row == 0)
    {
        height = 262 * SCREEN_HEIGHT / 768;
    }
    else if (indexPath.row == 1)
    {
        height = 193 * SCREEN_HEIGHT / 768;
    }
    else
    {
        height = 165 * SCREEN_HEIGHT / 768;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (void)ImgtapAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.view];
    if(point.x <= sender.view.frame.size.width/3)
    {
        if(allowRegist)
            {
                uploadIpadViewController *uivc = [[uploadIpadViewController alloc]init];
                uivc.productList = productList;
                uivc.token = token;
                uivc.userName = userName;
                [self.UF_ViewController.navigationController pushViewController:uivc animated:YES]; 

            }
            else
            {
                alertMsgView(@"没有相关权限请联系管理员", self);
                return;
            }
    }
    else if(point.x > sender.view.frame.size.width*2/3)
    {
        if(allowSendReport)
            {
                _svc = [[sendViewController alloc] init];
                _svc.title = @"报告寄送";
                _svc.isSendExpress = NO;
                [self.UF_ViewController.navigationController pushViewController:_svc animated:YES];
            }
            else
            {
                alertMsgView(@"没有相关权限请联系管理员", self);
                return;
            }
    }
    else
    {
        if(allowSendEx)

            {
                _svc = [[sendViewController alloc] init];
                _svc.title = @"样本寄送";
                _svc.isSendExpress = YES;

                [self.UF_ViewController.navigationController pushViewController:_svc animated:YES];
            }
            else
            {
                alertMsgView(@"没有相关权限请联系管理员", self);
                return;
            }
        
    }
}

- (void)tabBarSwitch
{
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    
}

- (void)setRightButton
{
    UIButton *logoutBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutBt setTitle:userName forState:UIControlStateNormal];
    logoutBt.tintColor = [UIColor blackColor];
    logoutBt.frame = CGRectMakeWithAutoSize(0, 0, 60, 14);
    [logoutBt setHidden:NO];
    [logoutBt addTarget:self action:@selector(logoutBtClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBt];
}

- (void)logoutBtClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"确定登出莲和助手？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        loginViewController *lvc = [[loginViewController alloc] init];
        lvc.placeUserName = userName;
        lvc.delegate = self;
        UINavigationController *unc = [[UINavigationController alloc]initWithRootViewController:lvc];
        [unc.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:18],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
        [self presentViewController:unc animated:YES completion:nil];
    
    }];
    
    [alert addAction:ula];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)productListRequest
{
    NSString *strUrl = [NSString stringWithFormat:productList_URL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(strUrl, nil);
        if (!response) {
            NSLog(@"response is null check");
            dispatch_async(dispatch_get_main_queue(), ^{
            alertMsgView(@"网络异常，无法获取产品列表", self);});
            
            return ;
        }
        NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strResp);
        
        NSDictionary *responseData = parseJsonResponse(response);
        NSString *resault = JsonValue([responseData objectForKey:@"err"], @"NSString");
        NSInteger err = [resault integerValue];
        if(err > 0)
        {
            return;
        }
        productList = JsonValue([responseData objectForKey:@"data"], @"NSArray");
    });
}

- (void)updateToken:(NSString *)currentToken name:(NSString *)name role:(NSArray *)roleArray
{
    allowRegist = NO;
    allowSendEx = NO;
    allowSendReport = NO;
    self->token = currentToken;
    userName = name;
    for(int i = 0; i<roleArray.count; i++)
    {
        NSString *str = roleArray[i];
        if([str isEqualToString:@"客户录入"])
        {
            allowRegist = YES;
        }
        if([str isEqualToString:@"样本寄送"])
        {
            allowSendEx = YES;
        }
        if([str isEqualToString:@"报告寄送"])
        {
            allowSendReport = YES;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
