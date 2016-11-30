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
    UIColor *starColor;
    UIColor *midColor;
    UIColor *endColor;
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
    self.itemsMenu = @[@"",@"我的订单",@"草稿箱",@"操作记录",@"我的消息",@"我的客户"];
    self.itemsImageName =@[@"",WDDD_IMG,CGX_IMG,CZJL_IMG,WDXX_IMG,WDKH_IMG];
    // Do any additional setup after loading the view.
    
    
    hasLogin = NO;
    lastUserPhone =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNo"];
    lastToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (lastToken !=nil & lastUserPhone !=nil)
    {
        hasLogin = YES;
    }

    starColor = [UIColor colorWithRed:114.0/255 green:97.0/255 blue:179.0/255 alpha:1];
    midColor =  [UIColor colorWithRed:140.0/255 green:121.0/255 blue:214.0/255 alpha:1];
    endColor = [UIColor whiteColor];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"ReloadView" object:nil];
    
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
        
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60*SCREEN_WEIGHT/1024, 39*SCREEN_HEIGHT/768 - 15, 27*SCREEN_WEIGHT/1024, 27*SCREEN_HEIGHT/768)];   //侧边栏图标
        cellImageView.tag = 2;
        [cell.contentView addSubview:cellImageView];
        
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(46, titleLable.frame.origin.y + titleLable.frame.size.height + 10, self.view.frame.size.width - 46, 1)];
        lineLable.layer.borderWidth = 1;
        lineLable.layer.borderColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1].CGColor;
        [cell.contentView addSubview:lineLable];
        if (indexPath.row == 0) {
            lineLable.hidden = YES;
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
          leftImg.frame = CGRectMake(55*SCREEN_WEIGHT/1024, 33*SCREEN_HEIGHT/768, 82*SCREEN_WEIGHT/1024, 82*SCREEN_HEIGHT/768);
          leftImg.image = [UIImage imageNamed:@"touxiang"];
          cell.backgroundColor = [UIColor colorWithMyNeed:236 green:236 blue:236 alpha:1];
          
          cell.userInteractionEnabled = NO;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1)
    {
    
        [self.UF_ViewController closeDrawerAnimtaion:YES complete:^(BOOL finished)
        {
            if(finished)
            {
                firstItemViewController *fivc = [[firstItemViewController alloc]init];
                fivc.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                fivc.urlStr = @"http://dev.mapi.lhgene.cn/app";
                [self.UF_ViewController.navigationController pushViewController:fivc animated:YES];
            }
            else
                return ;
        }];
    }
//    else
//    {       
//        if(!hasLogin)
//        {
//            
//        }
//        else
//        {
//            @try {
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhoneNo"];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//            @catch (NSException *exception)
//            {
//                [self alertMsgView:exception.reason];
//            }
//            @finally
//            {
//                [self alertMsgView:@"您已成功注销"];
//                
//              //  NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadView" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateToken" object:nil];
//
//            }
//        }
//    }
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

-(void)receivedNotif:(NSNotification *)notification {
    hasLogin = !hasLogin;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)loginPushReport:(NSString *)token
{
    
}

@end
