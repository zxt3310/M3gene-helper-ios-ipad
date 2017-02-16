//
//  passwdChangeViewController.m
//  取样助手
//
//  Created by Zxt3310 on 2017/2/16.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "passwdChangeViewController.h"

@interface passwdChangeViewController ()
{
    UITextField *oldPwTf;
    UITextField *newPwTf;
    UITextField *confirmPwTf;
}
@end

@implementation passwdChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithMyNeed:230 green:230 blue:230 alpha:1];
    
    UILabel *oldPwLb = [[UILabel alloc] initWithFrame:CGRectMake(22, (25 + 64), 100, 16)];
    oldPwLb.text = @"旧密码:";
    oldPwLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self.view addSubview:oldPwLb];
    
    oldPwTf = [[UITextField alloc] initWithFrame:CGRectMake(-1, (48 + 64), SCREEN_WEIGHT + 2, 40)];
    oldPwTf.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    oldPwTf.leftViewMode = UITextFieldViewModeAlways;
    oldPwTf.font = oldPwLb.font;
    oldPwTf.backgroundColor = [UIColor whiteColor];
    oldPwTf.layer.borderWidth = 0.5;
    oldPwTf.secureTextEntry = YES;
    [self.view addSubview:oldPwTf];
    
    UILabel *newPwLb = [[UILabel alloc] initWithFrame:CGRectMake(22, (98+64), 100, 14)];
    newPwLb.text = @"新密码:";
    newPwLb.font = oldPwLb.font;
    [self.view addSubview:newPwLb];
    
    newPwTf = [[UITextField alloc] initWithFrame:CGRectMake(-1, (122 + 64), SCREEN_WEIGHT + 2, 40)];
    newPwTf.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    newPwTf.leftViewMode = UITextFieldViewModeAlways;
    newPwTf.font = newPwLb.font;
    newPwTf.backgroundColor = [UIColor whiteColor];
    newPwTf.layer.borderWidth = 0.5;
    newPwTf.secureTextEntry = YES;
    [self.view addSubview:newPwTf];
    
    UILabel *confirmPwLb = [[UILabel alloc] initWithFrame:CGRectMake(22, (172 + 64), 100, 14)];
    confirmPwLb.text = @"确   认:";
    confirmPwLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self.view addSubview:confirmPwLb];
    
    confirmPwTf = [[UITextField alloc] initWithFrame:CGRectMake(-1, (196 + 64), SCREEN_WEIGHT + 2, 40)];
    confirmPwTf.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    confirmPwTf.leftViewMode = UITextFieldViewModeAlways;
    confirmPwTf.font = oldPwLb.font;
    confirmPwTf.backgroundColor = [UIColor whiteColor];
    confirmPwTf.layer.borderWidth = 0.5;
    confirmPwTf.secureTextEntry = YES;
    [self.view addSubview:confirmPwTf];

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(22, (276 + 64), SCREEN_WEIGHT - 44, 40);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.tintColor = [UIColor whiteColor];
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn setBackgroundColor:[UIColor colorWithMyNeed:74 green:144 blue:226 alpha:1]];
    [confirmBtn addTarget:self action:@selector(confirmBtClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)confirmBtClickAction
{
    NSString *oldPsw = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pwd"]];
    if (![oldPwTf.text isEqualToString:oldPsw]) {
        oldPwTf.layer.borderColor = [UIColor redColor].CGColor;
        alertMsgView(@"旧密码不匹配",self);
        return;
    }
    else
    {
        oldPwTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (newPwTf.text.length == 0) {
        newPwTf.layer.borderColor = [UIColor redColor].CGColor;
        alertMsgView(@"请输入新密码",self);
        return;
    }
    else
    {
        newPwTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (confirmPwTf.text.length == 0) {
        confirmPwTf.layer.borderColor = [UIColor redColor].CGColor;
        alertMsgView(@"请确认新密码",self);
        return;
    }
    else
    {
        confirmPwTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (![newPwTf.text isEqualToString:confirmPwTf.text]) {
        confirmPwTf.layer.borderColor = [UIColor redColor].CGColor;
        alertMsgView(@"新密码不匹配",self);
        return;
    }
    else
    {
        confirmPwTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
//errLb.text = @"";
    [self changePwdRequest];

}

- (void)changePwdRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?password=%@",CHANGE_PASSWORD_URL,newPwTf.text];
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSData *returnData = sendRequestWithFullURLandHeaders(urlStr, nil, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!returnData) {
                alertMsgView(@"修改失败，网络超时",self);
                return;
            }
            NSDictionary *returnDic = parseJsonResponse(returnData);
            if (!returnDic) {
                alertMsgView(@"修改失败，返回错误数据",self);
                return;
            }
            NSNumber *resault = JsonValue([returnDic objectForKey:@"err"],@"NSNumber");
            if (!resault) {
                alertMsgView(@"修改失败，返回错误数据",self);
                return;
            }
            NSInteger err = [resault integerValue];
            if (err>0) {
                NSString *errmsg = JsonValue([returnDic objectForKey:@"errmsg"],@"NSString");
                alertMsgView(errmsg, self);
                return;
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
                [self.navigationController popViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:newPwTf.text forKey:[NSString stringWithFormat:@"pwd"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            [alert addAction:cacelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        });
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
