//
//  ViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/26.
//  Copyright © 2016年 xxx. All rights reserved.
//

#define ORDER_TAG 100
#define VIP_TAG 101
#define PAY_TAG 102
#define PROCES_TAG 103

#import "mainViewController.h"


@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    
    BOOL allowInputGBK;
    BOOL allowRegist;
    BOOL allowSendEx;
    BOOL allowSendReport;
    CustomURLCache *urlCache;
    
    NSArray *dataList;
    //NSString *cookie;
    LoadingView *loadingView;
}

@end

@implementation mainViewController
@synthesize userName = userName;
@synthesize token = token;
@synthesize role = role;
@synthesize productList = productList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (61 + 35), SCREEN_WEIGHT, SCREEN_HEIGHT - 61) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dataListRequest];
    
    UITextField *newsLable = [[UITextField alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WEIGHT, 35)];
    newsLable.backgroundColor = [UIColor colorWithMyNeed:250 green:247 blue:216 alpha:1];
    newsLable.enabled = NO;
    UITextField *contextLable = [[UITextField alloc] initWithFrame:CGRectMake(34, 10, 200, 19)];
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(34, 10, 21, 19)];
    leftImg.image = [UIImage imageNamed:@"喇叭"];
    contextLable.leftView = leftImg;
    contextLable.leftViewMode = UITextFieldViewModeAlways;
    contextLable.text = @"  今日公告";
    contextLable.enabled = NO;
    [newsLable addSubview:contextLable];
    [self.view addSubview:newsLable];
    
    
    role = [[NSUserDefaults standardUserDefaults] objectForKey:@"role"];
    allowInputGBK = YES;
    allowRegist = NO;
    allowSendEx = NO;
    allowSendReport = NO;
    for(int i = 0; i<role.count; i++)
    {
        NSString *str = role[i];
        if([str isEqualToString:@"贵宾卡录入"])
        {
            allowInputGBK = YES;
        }
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
    
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(475, 270, 80, 70)];
    loadingView.loadingImage.backgroundColor = [UIColor whiteColor];
    loadingView.loadingImage.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.dscpLabel.textColor = [UIColor blackColor];
    loadingView.alpha = 1;
    loadingView.dscpLabel.text = @"同步中";
    //loadingView.hidden = YES;
    [self.view addSubview:loadingView];
    
    
}

- (instancetype)init
{
    self=[super init];
    if(self)
    {
        urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                     diskCapacity:1000 * 1024 * 1024
                                                         diskPath:nil
                                                        cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
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
        lvc.leftdelegate = self.leftVc;
        [self presentViewController:unv animated:YES completion:nil];
    }
    else
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self checkUpdata];
        });
    }
}

- (void)setNewBar
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, 81)];
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
    rect.origin.y = 25;
    rect.size.height = 65;
    rect.size.width = 60;
    backBtn.frame = rect;
    [header addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width + 16, 32, SCREEN_WEIGHT - (rect.size.width+8) * 2, 44)];
    titleLabel.text = @"莲和运营后台";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36];
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
        
        /*
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
         [cell.contentView addGestureRecognizer:tap];*/
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgtapAction:)];
        
        UIImage *gbkImage = [UIImage imageNamed:@"guibinka"];
        UIImageView *gbkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/8-(107*SCREEN_HEIGHT/768)/2, 61*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768)];
        gbkImageView.image = gbkImage;
        [cell.contentView addSubview:gbkImageView];
        
        UILabel *gbkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 186*SCREEN_HEIGHT/768, SCREEN_WEIGHT/4, 25)];
        gbkLabel.text = @"贵宾卡录入";
        gbkLabel.textColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1.0];
        gbkLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        gbkLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:gbkLabel];
        
        UIImage *ddImage = [UIImage imageNamed:@"dingdan"];
        UIImageView *ddImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*3/8-(107*SCREEN_HEIGHT/768)/2, 61*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768)];
        ddImageView.image = ddImage;
        [cell.contentView addSubview:ddImageView];
        
        UILabel *ddLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/4, 186*SCREEN_HEIGHT/768, SCREEN_WEIGHT/4, 25)];
        ddLabel.text = @"订单录入";
        ddLabel.textColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1.0];
        ddLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        ddLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ddLabel];
        
        UIImage *ybImage = [UIImage imageNamed:@"yanbben"];
        UIImageView *ybImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*5/8-(107*SCREEN_HEIGHT/768)/2, 61*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768)];
        ybImageView.image = ybImage;
        [cell.contentView addSubview:ybImageView];
        
        UILabel *ybLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*2/4, 186*SCREEN_HEIGHT/768, SCREEN_WEIGHT/4, 25)];
        ybLabel.text = @"样本寄送";
        ybLabel.textColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1.0];
        ybLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        ybLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ybLabel];
        
        UIImage *bgImage = [UIImage imageNamed:@"jisong"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*7/8-(107*SCREEN_HEIGHT/768)/2, 61*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768, 107*SCREEN_HEIGHT/768)];
        bgImageView.image = bgImage;
        [cell.contentView addSubview:bgImageView];
        
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT*3/4, 186*SCREEN_HEIGHT/768, SCREEN_WEIGHT/4, 25)];
        bgLabel.text = @"报告寄送";
        bgLabel.textColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1.0];
        bgLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        bgLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:bgLabel];
        
        [cell.contentView addGestureRecognizer:tap];
        
    }
    else if(indexPath.row == 1)
    {
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
        title.text = @"我的服务";
        
        UIScrollView *scorll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WEIGHT, 159)];
        scorll.contentSize = CGSizeMake(1100, scorll.frame.size.height);
        [cell.contentView addSubview:scorll];
        
        UILabel *orderLb = [[UILabel alloc] initWithFrame:CGRectMake(50*SCREEN_WEIGHT/1024, 118*SCREEN_HEIGHT/768, 88, 22)];
        orderLb.text = @"我的订单";
        orderLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        [scorll addSubview:orderLb];
        
        UIImageView *orderImg = [[UIImageView alloc] initWithFrame:CGRectMake(56*SCREEN_WEIGHT/1024, 22*SCREEN_HEIGHT/768, 71.3*SCREEN_WEIGHT/1024, 81*SCREEN_HEIGHT/768)];
        orderImg.image = [UIImage imageNamed:@"订单"];
        orderImg.userInteractionEnabled = YES;
        orderImg.tag = ORDER_TAG;
        UITapGestureRecognizer *orderImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderTapAction:)];
        [orderImg addGestureRecognizer:orderImgTap];
        [scorll addSubview:orderImg];
        
        UILabel *myVipCardLb = [[UILabel alloc] initWithFrame:CGRectMake(257*SCREEN_WEIGHT/1024, 118*SCREEN_HEIGHT/768, 110, 22)];
        myVipCardLb.text = @"我的贵宾卡";
        myVipCardLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        [scorll addSubview:myVipCardLb];
        
        UIImageView *vipView = [[UIImageView alloc] initWithFrame:CGRectMake(278*SCREEN_WEIGHT/1024, 27*SCREEN_HEIGHT/768, 71.9*SCREEN_WEIGHT/1024, 71.9*SCREEN_WEIGHT/1024)];
        vipView.image = [UIImage imageNamed:@"贵宾厅"];
        vipView.tag = VIP_TAG;
        vipView.userInteractionEnabled = YES;
        UITapGestureRecognizer *vipImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderTapAction:)];
        [vipView addGestureRecognizer:vipImgTap];

        [scorll addSubview:vipView];
        
        UILabel *myPayMentLb = [[UILabel alloc] initWithFrame:CGRectMake(501*SCREEN_WEIGHT/1024, 118*SCREEN_HEIGHT/768, 88, 22)];
        myPayMentLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];;
        myPayMentLb.text = @"我的款项";
        [scorll addSubview:myPayMentLb];
        
        UIImageView *payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(500*SCREEN_WEIGHT/1024, 26*SCREEN_HEIGHT/768, 87*SCREEN_WEIGHT/1024, 73*SCREEN_HEIGHT/768)];
        payImgView.image = [UIImage imageNamed:@"待收付款项预测"];
        payImgView.tag = PAY_TAG;
        payImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *payImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderTapAction:)];
        [payImgView addGestureRecognizer:payImgTap];
        [scorll addSubview:payImgView];
        
        UILabel *processLb = [[UILabel alloc] initWithFrame:CGRectMake(737*SCREEN_WEIGHT/1024, 118*SCREEN_HEIGHT/768, 88, 22)];
        processLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        processLb.text = @"进度管理";
        [scorll addSubview:processLb];
        
        UIImageView *processImgView = [[UIImageView alloc] initWithFrame:CGRectMake(737 *SCREEN_WEIGHT/1024, 23*SCREEN_HEIGHT/768, 80*SCREEN_WEIGHT/1024, 80*SCREEN_WEIGHT/1024)];
        processImgView.image = [UIImage imageNamed:@"进度中心"];
        processImgView.tag = PROCES_TAG;
        processImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *processImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderTapAction:)];
        [processImgView addGestureRecognizer:processImgTap];
        [scorll addSubview:processImgView];
        
        UILabel *ziLiaoLb = [[UILabel alloc] initWithFrame:CGRectMake(967*SCREEN_WEIGHT/1024,118*SCREEN_HEIGHT/768,88,22)];
        ziLiaoLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];;
        ziLiaoLb.text = @"资料中心";
        [scorll addSubview:ziLiaoLb];
        
        UIImageView *ziliaoImg = [[UIImageView alloc] initWithFrame:CGRectMake(967*SCREEN_WEIGHT/1024, 25*SCREEN_WEIGHT/768,76*SCREEN_WEIGHT/1024, 71*SCREEN_HEIGHT/768)];
        ziliaoImg.image = [UIImage imageNamed:@"ziliao copy 2"];
        ziliaoImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *ziliaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ziliaoTapAction)];
        [ziliaoImg addGestureRecognizer:ziliaoTap];
        [scorll addSubview:ziliaoImg];
        
    }
    else
    {
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
        title.text = @"莲和基因APP二维码";
        
        UILabel *QRcodeForAppleLb = [[UILabel alloc] initWithFrame:CGRectMake(56*SCREEN_WEIGHT/1024, 169*SCREEN_HEIGHT/768, 101, 18)];
        QRcodeForAppleLb.text = @"iphoneApp";
        QRcodeForAppleLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        [cell.contentView addSubview:QRcodeForAppleLb];
        
        UIImageView *QRcodeForApple = [[UIImageView alloc] initWithFrame:CGRectMake(54*SCREEN_WEIGHT/1024, 63*SCREEN_HEIGHT/768, 100*SCREEN_WEIGHT/1024, 100*SCREEN_WEIGHT/1024)];
        QRcodeForApple.image = [UIImage imageNamed:@"iphone03"];
        [cell.contentView addSubview:QRcodeForApple];
        
//        UILabel *QRcodeAndriodLb = [[UILabel alloc] initWithFrame:CGRectMake(195,169*SCREEN_HEIGHT/768, 114, 18)];
//        QRcodeAndriodLb.text = @"AndriodApp";
//        QRcodeAndriodLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
//        [cell.contentView addSubview:QRcodeAndriodLb];
//        
//        UIImageView *QRcodeForAndriod = [[UIImageView alloc] initWithFrame:CGRectMake(196*SCREEN_WEIGHT/1024, 63*SCREEN_HEIGHT/768, 100*SCREEN_WEIGHT/1024, 100*SCREEN_WEIGHT/1024)];
//        QRcodeForAndriod.image = [UIImage imageNamed:@"android05"];
//        [cell.contentView addSubview:QRcodeForAndriod];
        
        UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-1, 26, 2, 161*SCREEN_HEIGHT/768)];
        lineLb.layer.borderWidth = 1;
        lineLb.layer.borderColor = [UIColor colorWithMyNeed:219 green:219 blue:219 alpha:1].CGColor;
        lineLb.backgroundColor = [UIColor colorWithMyNeed:219 green:219 blue:219 alpha:1];
        [cell.contentView addSubview:lineLb];


        UILabel *connectTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(627 *SCREEN_WEIGHT/1024, 23 *SCREEN_HEIGHT/768, 200*SCREEN_WEIGHT/1024, 24)];
        connectTitleLb.text = @"各业务接口人";
        connectTitleLb.font = title.font;
        [cell.contentView addSubview:connectTitleLb];
        
        
        UILabel *connectWLLb = [[UILabel alloc] initWithFrame:CGRectMake(629*SCREEN_WEIGHT/1024, 68*SCREEN_HEIGHT/768, 400, 22)];
        connectWLLb.text = @"网络：蒋英龙（13121185670）";
        connectWLLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        [cell.contentView addSubview:connectWLLb];
        
        UILabel *connectQXLb = [[UILabel alloc] initWithFrame:CGRectMake(629*SCREEN_WEIGHT/1024, 113*SCREEN_HEIGHT/768, 400, 22)];
        connectQXLb.text = @"客服：刘晓平（13521422062）";
        connectQXLb.font = connectWLLb.font;
        [cell.contentView addSubview:connectQXLb];
        
        UILabel *connectKFLb = [[UILabel alloc] initWithFrame:CGRectMake(629*SCREEN_WEIGHT/1024, 158*SCREEN_HEIGHT/768, 400, 22)];
        connectKFLb.text = @"客服电话：   （4006010982）";
        connectKFLb.font = connectWLLb.font;
        [cell.contentView addSubview:connectKFLb];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)myOrderTapAction:(UIGestureRecognizer *)sender;
{
    NSString *urlStr;
    NSString *titleName;
    switch (sender.view.tag) {
        case ORDER_TAG:
            urlStr = SINGLE_ORDER_URL;
            titleName = @"订单管理";
            break;
        case VIP_TAG:
            urlStr = SINGLE_VIP_URL;
            titleName = @"贵宾卡";
            break;
        case PAY_TAG:
            urlStr = SINGLE_PAY_URL;
            titleName = @"我的款项";
            break;
        case PROCES_TAG:
            urlStr = orderProcess_URL;
            titleName = @"进度管理";
            break;
        default:
            break;
    }
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
    NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
    firstItemViewController *fivc = [[firstItemViewController alloc]init];
    fivc.token = token;
    fivc.title = titleName;
    fivc.urlStr = urlStr;
    if(cookieArray.count>0)
    {
        fivc.cookie = cookieArray[0];
    }
    [self.UF_ViewController.navigationController pushViewController:fivc animated:YES];
}

- (void)ziliaoTapAction
{
    dataCenterViewController *dvc = [[dataCenterViewController alloc] init];
    dvc.dataList = dataList;
    dvc.cache = urlCache;
    [self.navigationController pushViewController:dvc animated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.row == 0)
    {
        height = 232 * SCREEN_HEIGHT / 768;
    }
    else if (indexPath.row == 1)
    {
        height = 207 * SCREEN_HEIGHT / 768;
    }
    else
    {
        height = 213 * SCREEN_HEIGHT / 768;
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
    if(point.x <= sender.view.frame.size.width/4)
    {
        if(allowInputGBK)
        {
            VIPCardViewController *vip = [[VIPCardViewController alloc] init];
            vip.token = token;
            vip.userName = userName;
            [self.navigationController pushViewController:vip animated:YES];
        }
        else
        {
            alertMsgView(@"没有相关权限请联系管理员", self);
            return;
        }
    }
    else if(point.x <= sender.view.frame.size.width*2/4)
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
    else if(point.x > sender.view.frame.size.width*3/4)
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

- (void)productListRequest
{
    NSString *strUrl = [NSString stringWithFormat:productList_URL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *response = sendGETRequest(strUrl, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!response) {
                NSLog(@"response is null check");
                
                alertMsgView(@"网络异常，无法获取产品列表", self);
                
                return ;
            }
            NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",strResp);
            
            NSDictionary *responseData = parseJsonResponse(response);
            NSNumber *resault = JsonValue([responseData objectForKey:@"err"], @"NSNumber");
            if (resault == nil) {
                alertMsgView(@"数据异常，稍后再试", self);
                return;
            }
            NSInteger err = [resault integerValue];
            if(err > 0)
            {
                return;
            }
            productList = JsonValue([responseData objectForKey:@"data"], @"NSArray");
        });
    });
}

- (void)updateToken:(NSString *)currentToken name:(NSString *)name role:(NSArray *)roleArray
{
    allowInputGBK = YES;
    allowRegist = NO;
    allowSendEx = NO;
    allowSendReport = NO;
    token = currentToken;
    userName = name;
    for(int i = 0; i<roleArray.count; i++)
    {
        NSString *str = roleArray[i];
        if([str isEqualToString:@"贵宾卡录入"])
        {
            allowInputGBK = YES;
        }
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


- (void)dataListRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/m/api/disk",dataCenter_URL];   // @"http://gzh.gentest.ranknowcn.com/m/api/disk";
    
    loadingView.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        NSData *response = sendGETRequest(urlStr, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!response) {
                loadingView.hidden = YES;
                alertMsgView(@"无法获取资料文件列表，无法连接服务器，请检查网络", self);
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
            
            Reachability *reach = [Reachability reachabilityForInternetConnection];
            if(reach.isReachableViaWiFi)
            {
                [self updateData];
            }
            else
            {
                loadingView.hidden = YES;
            }
        });
    });
}


- (void)updateData
{
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
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
                request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [FFNSURLConnectionForHttps sendSynchronousRequest:[request copy] returningResponse:&response error:&error];
                if (error) {
                    [currentHashDic removeObjectForKey:key];
                    [currentFileUrl removeObjectForKey:key];
                    continue;
                }
                
                NSString *url = request.URL.absoluteString;
                NSString *fileName = [urlCache cacheRequestFileName:url];
                NSString *otherInfoFileName = [urlCache cacheRequestOtherInfoFileName:url];
                NSString *filePath = [urlCache cacheFilePath:fileName];
                NSString *otherInfoPath = [urlCache cacheFilePath:otherInfoFileName];
                NSDate *date = [NSDate date];
                
                NSLog(@"cache url --- %@ ",url);
                
                //save to cache
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                      response.MIMEType, @"MIMEType",
                                      response.textEncodingName, @"textEncodingName", nil];
                [dict writeToFile:otherInfoPath atomically:YES];
                [data writeToFile:filePath atomically:YES];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                loadingView.dscpLabel.text = [NSString stringWithFormat:@"同步中%.0f%%",a*100];
            });
        }
        
        //清除清单以外的文件缓存
        
        for (NSString *key in lastHashDic.allKeys)
        {
            if (![currentHashDic objectForKey:key]) {
                NSString *fileUrlStr = [lastFileUrl objectForKey:key];
                NSString *urlStr = [[NSString stringWithFormat:@"%@%@",dataCenter_URL,fileUrlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlCache.cacheTime = 1;
                
                NSURLResponse *response = nil;
                [FFNSURLConnectionForHttps sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] returningResponse:&response error:nil];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSUserDefaults standardUserDefaults] setObject:currentHashDic forKey:@"fileHash"];
            [[NSUserDefaults standardUserDefaults] setObject:currentFileUrl forKey:@"fileUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
        });
    });
}

- (void)checkUpdata
{
    //蒲公英
    //NSString *urlStr = [NSString stringWithFormat:PGY_UPDATE_Check_VERSION_URL];
    //NSString *post = [NSString stringWithFormat:@"aId=%@&_api_key=%@",PGY_UPDATE_API_aId,PGY_UPDATE_API_apiKey];
    
    //改用苹果官方store接口判断版本
    NSString *urlStr = [NSString stringWithFormat:@"%@?id=%@",appStore_Version_POST_URL,app_Id];// @"http://itunes.apple.com/cn/lookup?id=1203188094";
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSData *responseData = sendRequestWithFullURL(urlStr, nil);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!responseData) {
                NSLog(@"netWork doesn't work");
                return ;
            }
            
            NSDictionary *returnDic = parseJsonResponse(responseData);
            if (!returnDic) {
                NSLog(@"return Wrong Data");
                return;
            }
            
            NSNumber *resault = JsonValue([returnDic objectForKey:@"resultCount"],@"NSDictionary");
            if (!resault) {
                NSLog(@"return Wrong Data Check API");
                return;
            }
            
            NSInteger code = [resault integerValue];
            if (code == 0) {
                NSString *errmsg = @"fail to check version";//JsonValue([returnDic objectForKey:@"message"], @"NSString");
                NSLog(@"%@",errmsg);
                return;
            }
        
            //NSArray *versionArray = JsonValue([JsonValue([returnDic objectForKey:@"data"],@"NSDictionary") objectForKey:@"list"], @"NSArray");
            // NSString *newVersion = [versionArray[0] objectForKey:@"appVersion"]; //新版本
            NSArray *stroeInfoDic = JsonValue([returnDic objectForKey:@"results"],@"NSDictionary");
            if (stroeInfoDic.count == 0) {
                NSLog(@"this app is not exist in appstore");
                return;
            }
            NSString *newVersion = [stroeInfoDic[0] objectForKey:@"version"];
            NSString *updateUrl = [stroeInfoDic[0] objectForKey:@"trackViewUrl"];
            NSDictionary *appInfoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *current_version = [appInfoDic objectForKey:@"CFBundleShortVersionString"]; //当前版本
            NSArray *new_ver_arry = [newVersion componentsSeparatedByString:@"."];
            NSArray *cur_ver_arry = [current_version componentsSeparatedByString:@"."];
            
            if ([new_ver_arry[0] integerValue] > [cur_ver_arry[0] integerValue] || [new_ver_arry[1] integerValue] > [cur_ver_arry[1] integerValue])
            {
                UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"消息" message:@"有重要版本需要更新，忽略会导致无法使用" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[updateUrl stringByReplacingOccurrencesOfString:@"https" withString:@"itms-apps"]]];
                    [self presentViewController:alertCtr animated:YES completion:nil];
                }];
                [alertCtr addAction:agreeAction];
                //[self presentViewController:alertCtr animated:YES completion:nil];
                UIViewController *viewC = [[UIApplication sharedApplication] keyWindow].rootViewController;
                [viewC presentViewController:alertCtr animated:YES completion:nil];
            }
            else if ([new_ver_arry[2] integerValue] > [cur_ver_arry[2] integerValue])
            {
                UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"消息" message:@"有可用的新版本,建议更新" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[updateUrl stringByReplacingOccurrencesOfString:@"https" withString:@"itms-apps"]]];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
                [alertCtr addAction:agreeAction];
                [alertCtr addAction:cancelAction];
                [self presentViewController:alertCtr animated:YES completion:nil];
            }
        });
    
 //   });
}

@end
