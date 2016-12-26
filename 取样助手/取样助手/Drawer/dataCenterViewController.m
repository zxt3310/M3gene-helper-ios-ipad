//
//  dataCenterViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/12/23.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "dataCenterViewController.h"

@interface dataCenterViewController ()
{
    UITableView *tableview;
    NSArray *dataList;
    LoadingView *loadingView;
    
}

@end

@implementation dataCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableview = [[UITableView alloc] init];
    tableview.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.view = tableview;
    
    //loading 动画
    float topY = SCREEN_HEIGHT/3;
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((SCREEN_WEIGHT- 80)/2, topY, 80, 70)];
    loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    
    [self dataListRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(100, cell.frame.origin.y + cell.frame.size.height/2 - 8, SCREEN_WEIGHT/3, 16)];
        titleLb.font = font;
        titleLb.tag = 10;
        [cell.contentView addSubview:titleLb];
        
        UILabel *sizeLb = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x + titleLb.frame.size.width + 20, titleLb.frame.origin.y, 200, 16)];
        sizeLb.tag = 20;
        sizeLb.font = font;
        [cell.contentView addSubview:sizeLb];
        
        UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(sizeLb.frame.origin.x + sizeLb.frame.size.width + 20, sizeLb.frame.origin.y, 300, 16)];
        timeLb.font = font;
        timeLb.tag = 30;
        [cell.contentView addSubview:timeLb];
        
        UIImageView *pdfImg = [[UIImageView alloc] initWithFrame:CGRectMake(70, titleLb.frame.origin.y - 2, 20, 20)];
        pdfImg.image = [UIImage imageNamed:@"pdf"];
        [cell.contentView addSubview:pdfImg];
        
    }
    
    NSDictionary *dataDic = JsonValue(dataList[indexPath.row],@"NSDictionary");
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    NSString *nameStr = JsonValue([dataDic objectForKey:@"name"],@"NSString");
    titleLabel.text = nameStr;
    
    UILabel *siziLb = (UILabel *)[cell.contentView viewWithTag:20];
    NSNumber *dataSize = JsonValue([dataDic objectForKey:@"size"], @"NSNumber");
    CGFloat a = [dataSize floatValue]/1000000;
    if (a<1) {
        siziLb.text = [NSString stringWithFormat:@"文件大小：%.0f Kb",a*1000];
    }
    else
    {
        siziLb.text = [NSString stringWithFormat:@"文件大小：%.2f Mb",a];
    }
    
    UILabel *timeLb = (UILabel *)[cell.contentView viewWithTag:30];
    NSString *timeSt = JsonValue([dataDic objectForKey:@"date"], @"NSString");
    timeLb.text = [NSString stringWithFormat:@"上传时间：%@",timeSt];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = JsonValue(dataList[indexPath.row],@"NSDictionary");

    NSString *str = [dataDic objectForKey:@"download"];
    NSString *urlSt = [[NSString stringWithFormat:@"%@%@",dataCenter_URL,str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DataCenterWebViewController *fivc = [[DataCenterWebViewController alloc]init];
    fivc.urlString = urlSt;
    [self.navigationController pushViewController:fivc animated:YES];
}

- (void)dataListRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/m/api/disk",dataCenter_URL];   // @"http://gzh.gentest.ranknowcn.com/m/api/disk";
    
    loadingView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
    
        NSData *response = sendGETRequest(urlStr, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (!response) {
                loadingView.hidden = YES;
                alertMsgView(@"无法连接服务器，请检查网络", self);
                return ;
            }
            
            NSDictionary *jsonData = parseJsonResponse(response);
            
            if (!jsonData) {
                loadingView.hidden = YES;
                alertMsgView(@"服务器维护中，请稍后再试", self);
                return;
            }
            
            NSNumber *result = JsonValue([jsonData objectForKey:@"err"], @"NSNumber");
            if (result == nil) {
                loadingView.hidden = YES;
                alertMsgView(@"服务区维护中，请稍后再试", self);
                return;
            }
            
            NSInteger err = [result integerValue];
            if (err > 0) {
                
                NSString *errMsg = JsonValue([jsonData objectForKey:@"errmsg"], @"NSString");
                
                loadingView.hidden = YES;
                alertMsgView(errMsg, self);
                
                return;
            }
            
            dataList = JsonValue([jsonData objectForKey:@"files"],@"NSArray");
            
            [tableview reloadData];
            
            Reachability *reach = [Reachability reachabilityForInternetConnection];
            if(reach.isReachableViaWiFi)
            {
                [self updateData];
            }
            
        });
    });
    
}

- (void)updateData
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    
    __block float sizeOfAll;
    __block float a;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        NSMutableDictionary *currentHashDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *currentFileUrl = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *currentFileSize = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i<dataList.count ;i++) {
            NSDictionary *dataDic = dataList[i];
            NSString *md5Str = [dataDic objectForKey:@"hash"];
            NSString *fileName = [dataDic objectForKey:@"name"];
            NSString *fileUrl = [dataDic objectForKey:@"download"];
            NSString *fileSize = [dataDic objectForKey:@"size"];
            sizeOfAll += [fileSize floatValue];
            
            [currentHashDic setObject:md5Str forKey:fileName]; //setValue:md5Str forKey:fileName];
            [currentFileUrl setObject:fileUrl forKey:fileName];
            [currentFileSize setObject:fileSize forKey:fileName];
        }
        
        NSDictionary *lastHashDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileHash"];
        NSDictionary *lastFileUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileUrl"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        loadingView.dscpLabel.text = @"同步中";
        });
        //更新有变化的文件缓存
        
        for (NSString *key in currentHashDic.allKeys)
        {
            NSInteger size = [[currentFileSize objectForKey:key] floatValue];
            a = size/sizeOfAll + a;
            if (![[lastHashDic objectForKey:key] isEqual:[currentHashDic objectForKey:key]]) {
                
                NSString *fileUrlStr = [currentFileUrl objectForKey:key];
                
                NSString *urlStr = [[NSString stringWithFormat:@"%@%@",dataCenter_URL,fileUrlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.cache changeUpdateState];
                
                NSURLResponse *response = nil;
                [FFNSURLConnectionForHttps sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] returningResponse:&response error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    loadingView.dscpLabel.text = [NSString stringWithFormat:@"同步中%.0f%%",a*100];
                });
            }
        }
        
        //清除清单以外的文件缓存
        
        for (NSString *key in lastHashDic.allKeys)
        {
            if (![currentHashDic objectForKey:key]) {
                NSString *fileUrlStr = [lastFileUrl objectForKey:key];
                NSString *urlStr = [[NSString stringWithFormat:@"%@%@",dataCenter_URL,fileUrlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.cache.cacheTime = 1;
                
                NSURLResponse *response = nil;
                [FFNSURLConnectionForHttps sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] returningResponse:&response error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadingView.dscpLabel.text = @"同步完成";
            [UIView animateWithDuration:1 animations:^{
                loadingView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                   
                    loadingView.alpha = 1;
                    loadingView.hidden = YES;
                }
            }];

            
            [[NSUserDefaults standardUserDefaults] setObject:currentHashDic forKey:@"fileHash"];
            [[NSUserDefaults standardUserDefaults] setObject:currentFileUrl forKey:@"fileUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    });
}


@end
