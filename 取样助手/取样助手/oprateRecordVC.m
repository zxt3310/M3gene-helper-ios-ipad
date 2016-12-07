//
//  oprateRecordVC.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "oprateRecordVC.h"
#import "CMCustomViews.h"
#import "publicMethod.h"
@interface oprateRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadingView *loadingView;
}

@end

@implementation oprateRecordVC

- (instancetype)init{
    self = [super init];
    if(self)
    {
        _tableCount = 0;
    }
    return self;
}
//1
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"操作记录";
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
   
    
    float topY = SCREEN_HEIGHT/3;
//    if (SCREEN_HEIGHT > 480.0) {
//        topY += 40;
//    }
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT-80)/2, topY, 80, 70)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
}
//2
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
}

//3
- (void)viewDidAppear:(BOOL)animated
{
    loadingView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self operationsRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            self.view = self.tableView;
            loadingView.hidden = YES;
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_HEIGHT - TABBAR_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)/4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifer = [NSString stringWithFormat:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell)
    {
        //UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
        
        //操作ID tag 1
        UILabel *IdLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        IdLable.hidden = YES;
        IdLable.tag = 1;
        [cell.contentView addSubview:IdLable];
        
        //操作时间 tag 2
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WEIGHT - 30, 30)];
        timeLable.tag = 2;
        [cell.contentView addSubview:timeLable];
        
        //操作内容 tag 3
        UILabel *operateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WEIGHT - 30, 60)];
        operateLable.tag = 3;
        operateLable.numberOfLines = 0;
        [cell.contentView addSubview: operateLable];
        
        //状态 tag 4
        UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT - 90, 100, 90, 30)];
        statusLable.tag = 4;
        [cell.contentView addSubview:statusLable];
        
        //分割线
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0 ,(SCREEN_HEIGHT - TABBAR_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT)/4-10,SCREEN_WEIGHT, 1)];
        lineLable.layer.borderWidth = 1;
        lineLable.layer.borderColor = [UIColor colorWithMyNeed:171 green:171 blue:171 alpha:1].CGColor;
        lineLable.tag = 5;
        [cell.contentView addSubview:lineLable];
    }
   
    NSDictionary *dic = _tableArry[indexPath.row];
    
    UILabel *IdLable = (UILabel *)[cell.contentView viewWithTag:1];
    IdLable.text = [dic objectForKey:@"id"];
    
    UILabel *timeLable = (UILabel *)[cell.contentView viewWithTag:2];
    timeLable.text = [dic objectForKey:@"time"];
    
    UILabel *operateLable = (UILabel *)[cell.contentView viewWithTag:3];
    operateLable.text = [dic objectForKey:@"message"];
    
    UILabel *statusLable = (UILabel *)[cell.contentView viewWithTag:4];
    NSString *status = [dic objectForKey:@"status"];
    if([status isEqualToString:@"ok"])
    {
        statusLable.text = @"操作成功";
        statusLable.textColor = [UIColor greenColor];
    }
    else if([status isEqualToString:@"error"])
    {
        statusLable.text = @"操作失败";
        statusLable.textColor = [UIColor redColor];
    }
    else
    {
        statusLable.text = @"";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _tableArry[indexPath.row];
    
    NSString *operateId = [dic objectForKey:@"id"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://dev.mapi.lhgene.cn/mobi-cms/h5-opmore/%@?token=%@",operateId,_token];
    
    firstItemViewController *fivc = [[firstItemViewController alloc]init];
    fivc.urlStr = urlStr;
    
    [self.navigationController pushViewController:fivc animated:YES];

}

- (void)operationsRequest
{
    NSString *strUrl = [NSString stringWithFormat:operations_URL];
    
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    
    NSDictionary *additionalHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:token,@"token", nil];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *response = sendGETRequest(strUrl, additionalHeaders);
        
       // dispatch_async(dispatch_get_main_queue(), ^{
        
        if(!response)
        {
            NSLog(@"request failed check");
            return ;
        }
        
        NSDictionary *reponseData = parseJsonResponse(response);
        NSString *resault = JsonValue([reponseData objectForKey:@"err"], @"NSString");
        NSInteger err = [resault integerValue];
        if(err > 0)
        {
            NSString *errormsg = replaceUnicode(JsonValue([reponseData objectForKey:@"errmsg"], @"NSString"));
            alertMsgView(errormsg, self);
            return;
        }
        
        NSArray *dataArray = JsonValue([reponseData objectForKey:@"data"], @"NSArray");
    
        _tableArry = dataArray;
        
     //   });
 //   });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
