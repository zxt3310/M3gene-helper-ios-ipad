//
//  draftViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "draftViewController-iphone.h"

@interface draftViewControllerIphone () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    NSArray *cacheList;
    NSString *user;
    NSString *token;
}
@end

@implementation draftViewControllerIphone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿箱";
    self.automaticallyAdjustsScrollViewInsets = NO;
    user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    cacheList = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CACHE_%@",user]];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WEIGHT, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];

    //  [self setNewBar];
}

- (void)setNewBar
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 101)];
    header.layer.shadowColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
    header.layer.shadowRadius = 4;
    header.layer.shadowOpacity = 1;
    header.layer.shadowOffset = CGSizeMake(0, 1);
    
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:header.frame];
    backimg.backgroundColor = [UIColor whiteColor];
    header.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.5].CGColor;
    header.layer.borderWidth = 0;
    [self.view addSubview:header];
    [header addSubview:backimg];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateHighlighted];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 8)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    CGRect rect = backBtn.frame;
    rect.origin.x = 30;
    rect.origin.y = 35;
    rect.size.height = 65;
    rect.size.width = 60;
    backBtn.frame = rect;
    [header addSubview:backBtn];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width + 16, 32, SCREEN_WEIGHT - (rect.size.width+8) * 2, 44)];
    titleLabel.text = @"草稿箱";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36];// boldSystemFontOfSize:36];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cacheList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170*SCREEN_HEIGHT/768;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        CGFloat y = 30 * iphone_size_H;
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        //操作类型  tag 1
        UILabel *typeLable = [[UILabel alloc] initWithFrame:CGRectMake(10*iphone_size_W, y, 100*iphone_size_H, 15)];
        typeLable.font = font;
        typeLable.tag = 1;
        [cell.contentView addSubview:typeLable];
        //客户名 tag 2
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(120 * iphone_size_W, y, 90 * iphone_size_W, 15)];
        nameLable.font = font;
        nameLable.tag = 2;
        [cell.contentView addSubview:nameLable];
        //订单号  tag 3
        UILabel *numberLable = [[UILabel alloc]initWithFrame:CGRectMake(220*iphone_size_W, y, 150 * iphone_size_W, 15)];
        numberLable.font = font;
        numberLable.tag = 3;
        [cell.contentView addSubview:numberLable];
        //操作时间 tag 4
        UILabel *operateTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(220 * iphone_size_W, y + 60, 150*iphone_size_W, 15)];
        operateTimeLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        operateTimeLb.tag = 4;
        [cell.contentView addSubview:operateTimeLb];
        
        //按钮
        UIButton *reSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reSendBtn.frame = CGRectMake(277*SCREEN_WEIGHT/1024, 95*SCREEN_HEIGHT/768, 240*SCREEN_WEIGHT/1024, 40*SCREEN_HEIGHT/768);
        [reSendBtn setTitle:@"编辑上传" forState:UIControlStateNormal];
        reSendBtn.backgroundColor = [UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1];
        reSendBtn.titleLabel.textColor = [UIColor whiteColor];
        reSendBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [reSendBtn addTarget:self action:@selector(resendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:reSendBtn];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160*SCREEN_HEIGHT/768, SCREEN_WEIGHT, 10*SCREEN_HEIGHT/768)];
        lineLabel.backgroundColor = [UIColor colorWithMyNeed:216 green:216 blue:216 alpha:1];
        [cell.contentView addSubview:lineLabel];
    }
    
    NSDictionary *cacheDic = cacheList[indexPath.row];
    
    UILabel *type = (UILabel*)[cell.contentView viewWithTag:1];
    NSString *typeName = [cacheDic objectForKey:@"cacheType"];
    
    if([typeName isEqualToString:@"CACHE_ORDER"])
    {
        type.text = @"【订单录入】";
    }
    else if ([typeName isEqualToString:@"CACHE_YB"])
    {
        type.text = @"【样本寄送】";
    }
    else if ([typeName isEqualToString:@"CACHE_VIP"])
    {
        type.text = @"【贵宾卡录入】";
    }
    else
    {
        type.text = @"【报告寄送】";
    }
    
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:2];
    
    if ([typeName isEqualToString:@"CACHE_ORDER"]) {
        
        NSString *str = [cacheDic objectForKey:@"registStr"];
        NSDictionary *dic = parseJsonString(str);
        name.text = [NSString stringWithFormat:@"客户：%@",[dic objectForKey:@"name"]];
        
        UILabel *number = (UILabel*)[cell.contentView viewWithTag:3];
        number.text = [NSString stringWithFormat:@"订单:%@",[cacheDic objectForKey:@"code_number"]];
    }
    
    if ([typeName isEqualToString:@"CACHE_VIP"]) {
        
        NSDictionary *dic = [cacheDic objectForKey:@"registStr"];
        name.text = [NSString stringWithFormat:@"客户：%@",[dic objectForKey:@"name"]];
        UILabel *number = (UILabel*)[cell.contentView viewWithTag:3];
        number.text = [NSString stringWithFormat:@"卡号:%@",[dic objectForKey:@"code"]];
    }
   
    
    UILabel *time = (UILabel *)[cell.contentView viewWithTag:4];
    time.text = [cacheDic objectForKey:@"operateTime"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"      删   除         ";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertController *uac = [UIAlertController alertControllerWithTitle:nil message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nullable action){return;}];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSMutableArray *arry = [[NSMutableArray alloc]initWithArray:cacheList];
        [arry removeObjectAtIndex:indexPath.row];
        cacheList = [arry copy];
        [[NSUserDefaults standardUserDefaults] setObject:cacheList forKey:[NSString stringWithFormat:@"CACHE_%@",user]];
        [tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    }];
    [uac addAction:cancelAction];
    [uac addAction:cameraAction];
    [self presentViewController:uac animated:YES completion:nil];
}

//NSArray *cacheArray = @[@"cacheType",@"operateTime",@"productName",@"productId",@"code_number",@"orderPic",@"registStr"];

- (void)resendBtnClick:(UIButton *)sender;
{
    NSIndexPath *index = [tableview indexPathForCell:(UITableViewCell *)sender.superview.superview];
    NSDictionary *dic = cacheList[index.row];
    if ([[dic objectForKey:@"cacheType"]isEqualToString:@"CACHE_ORDER"]) {
        uploadIphoneViewController *upLoadView = [[uploadIphoneViewController alloc]init];
        upLoadView.userName = user;
        upLoadView.productName = [dic objectForKey:@"productName"];
        upLoadView.productId = [dic objectForKey:@"productId"];
        upLoadView.number = [dic objectForKey:@"code_number"];
        upLoadView.registString = [dic objectForKey:@"registStr"];
        upLoadView.token = token;
        NSData *imgData = [dic objectForKey:@"orderPic"];
        upLoadView.upOrderImg = [UIImage imageWithData:imgData];
        upLoadView.refreshDeletage = self;
        upLoadView.productList = self.productList;
        upLoadView.deleteIndex = index.row;
        upLoadView.isReEditOperate = YES;
        [self.navigationController pushViewController:upLoadView animated:YES];
    }
    else if ([[dic objectForKey:@"cacheType"] isEqualToString:@"CACHE_VIP"])
    {
        NSDictionary *contentDic = [dic objectForKey:@"registStr"];
        VIPCardViewControllerIphone *vip = [[VIPCardViewControllerIphone alloc] init];
        vip.userName = user;
        for(NSString *key in contentDic.allKeys)
        {
            [vip setValue:[contentDic objectForKey:key] forKey:key];
        }
        vip.isReEditOperate = YES;
        vip.refreshDelegate = self;
        vip.deleteIndex = index.row;
        vip.token = token;
        [self.navigationController pushViewController:vip animated:YES];
    }
    
}

- (void)refresh:(NSArray *)array
{
    cacheList = array;
    [tableview reloadData];
}

@end



