//
//  photoViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2016/10/27.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "loginViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface loginViewController ()
{
    
}
@end

@implementation loginViewController

- (instancetype)init{
    self = [super init];
    if(self)
    {
        _username_TF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/4.93, SCREEN_HEIGHT/3.1,SCREEN_WEIGHT/1.67, SCREEN_HEIGHT/13.89)];
        _password_TF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/4.93, SCREEN_HEIGHT/2.24,SCREEN_WEIGHT/1.67, SCREEN_HEIGHT/13.89)];
        _loginBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/4.93, SCREEN_HEIGHT/1.38,SCREEN_WEIGHT/1.67, SCREEN_HEIGHT/13.89)];
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WEIGHT/3.07, SCREEN_HEIGHT/4.19,SCREEN_WEIGHT/2.84, SCREEN_HEIGHT/30.32)];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"登  录";
    self.view.backgroundColor = [UIColor whiteColor];
    _username_TF.borderStyle = UITextBorderStyleRoundedRect;
    _username_TF.layer.borderColor = MYBLUECOLOR.CGColor;
    _username_TF.layer.borderWidth = 1.0f;
    UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 11, 26, 26)];
    userView.image = [UIImage imageNamed:deviceImageSelect(@"用户名.png")];
    _username_TF.leftView = userView;
    _username_TF.text = _placeUserName;
    _username_TF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_username_TF];

    
    _password_TF.borderStyle = UITextBorderStyleRoundedRect;
    _password_TF.layer.borderColor = MYBLUECOLOR.CGColor;
    _password_TF.layer.borderWidth = 1.0f;
    UIImageView *pasView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 11, 26, 26)];
    pasView.image = [UIImage imageNamed:deviceImageSelect(@"密码.png")];
    _password_TF.leftView = pasView;
    _password_TF.leftViewMode = UITextFieldViewModeAlways;
    _password_TF.secureTextEntry = YES;
    [self.view addSubview:_password_TF];
    
    _titleLable.textColor = MYBLUECOLOR;
    _titleLable.attributedText = [[NSAttributedString alloc]initWithString:@"莲和运营后台" attributes:@{
                                                                                                  NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:22],
                                                                                                  
                                                                                                  }];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLable];
     
    
    _loginBt.backgroundColor = MYBLUECOLOR;
    [_loginBt setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBt addTarget:self action:@selector(loginBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBt];
    
    
//    _username_TF.text = @"现场1";
//    _password_TF.text = @"123456";
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginBtClick
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
    NSString *strUrl = [NSString stringWithFormat:longin_URL];
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&iospush=%@",_username_TF.text,_password_TF.text,deviceToken];

    NSData *response = sendRequestWithFullURL(strUrl, post);
        dispatch_async(dispatch_get_main_queue(),^{
            if(!response)
            {
                alertMsgView(@"无法连接服务器，请检查网络", self);
                NSLog(@" response is null check net!");
                return;
            }
            
                NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
                NSLog(@"%@",strResp);
            
            NSDictionary *jsonData = parseJsonResponse(response);
            if(!jsonData)
            {
                alertMsgView(@"服务器维护中，请稍后再试", self);
                return;
            }
            NSNumber *resault = [jsonData objectForKey:@"err"]; //JsonValue([jsonData objectForKey:@"err"],@"NSNumber");
            if (resault == nil) {
                alertMsgView(@"服务器维护中，亲稍后再试", self);
                return;
            }
            NSString *err = [NSString stringWithFormat:@"%@",resault];
            if(![err isEqualToString:@"0"])
            {
                NSString *errormsg = replaceUnicode(JsonValue([jsonData objectForKey:@"errmsg"],@"NSString"));
               // [self alertMsgView:errormsg];
                alertMsgView(errormsg, self);
                return;
            }
            //验证通过后的json
            NSDictionary *data = JsonValue([jsonData objectForKey:@"data"], @"NSDictionary");
            //token字段
            NSString *currentToken =[data objectForKey:@"token"];//  JsonValue([data objectForKey:@"token"], @"NSString");
            //权限字段
            NSArray *operations =[data objectForKey:@"operations"]; //JsonValue([data objectForKey:@"operations"], @"NSArray");
            if(!currentToken)
            {
                alertMsgView(@"登陆失败,获取不到用户标识，请重试", self);
                NSLog(@"Token = NULL Check");
                return;
            }
            [[NSUserDefaults standardUserDefaults] setObject:operations forKey:@"role"];
            [[NSUserDefaults standardUserDefaults] setObject:_username_TF.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:currentToken forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:^{
            
                if(self.delegate)
                {
                    [self.delegate updateToken:currentToken name:_username_TF.text role:operations];
                    [self.leftdelegate updateToken:currentToken name:_username_TF.text role:operations];
                }
            }];
            
        });
    
    });

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (event.allTouches.count > 1) {
        return;
    }
    
    UITouch *touch = event.allTouches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [_username_TF resignFirstResponder];
        [_password_TF resignFirstResponder];
        [self.view resignFirstResponder];
    }

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
@end
