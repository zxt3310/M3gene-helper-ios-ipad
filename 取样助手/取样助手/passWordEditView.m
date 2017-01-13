//
//  passWordEditView.m
//  取样助手
//
//  Created by Zxt3310 on 2017/1/13.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "passWordEditView.h"

@implementation passWordEditView
{
    UITextField *oldTf;
    UITextField *newTf;
    UITextField *confirmTf;
    UILabel *errLb;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithMyNeed:110 green:110 blue:110 alpha:0.5];
        UIView *pswView = [[UIView alloc] initWithFrame:CGRectMake(483*SCREEN_WEIGHT/1024 + 50, 180*SCREEN_HEIGHT/768, 440*SCREEN_WEIGHT/1024, 300*SCREEN_HEIGHT/768)];
        pswView.backgroundColor = [UIColor whiteColor];
        pswView.layer.cornerRadius = 20;
        [self addSubview:pswView];
        
        UIButton *cacelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cacelBtn.frame = CGRectMake(20, 20, 50, 20);
        [cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cacelBtn addTarget:self action:@selector(cancelBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [pswView addSubview:cacelBtn];
        
        UILabel *oldLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 65, 66, 25)];
        oldLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:22];
        oldLb.text = @"旧密码";
        [pswView addSubview:oldLb];
        
        oldTf = [[UITextField alloc] initWithFrame:CGRectMake(150, 58, 200, 40)];
        oldTf.layer.borderWidth = 1;
        oldTf.secureTextEntry = YES;
        [pswView addSubview:oldTf];
        
        UILabel *newLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 125, 66, 25)];
        newLb.font = oldLb.font;
        newLb.text = @"新密码";
        [pswView addSubview:newLb];
        
        newTf = [[UITextField alloc] initWithFrame:CGRectMake(150, 118, 200, 40)];
        newTf.layer.borderWidth = 1;
        newTf.secureTextEntry = YES;
        [pswView addSubview:newTf];
        
        UILabel *confirmLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 185, 66, 25)];
        confirmLb.text = @"确   认";
        confirmLb.font = newLb.font;
        [pswView addSubview:confirmLb];
        
        confirmTf = [[UITextField alloc] initWithFrame:CGRectMake(150, 178, 200, 40)];
        confirmTf.layer.borderWidth = 1;
        confirmTf.secureTextEntry = YES;
        [pswView addSubview:confirmTf];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(150, 238, 150, 40);
        [sendBtn setTitle:@"修改密码" forState:UIControlStateNormal];
        sendBtn.titleLabel.textColor = [UIColor whiteColor];
        sendBtn.backgroundColor = MYBLUECOLOR;
        [sendBtn addTarget:self action:@selector(sendBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [pswView addSubview:sendBtn];
        
        errLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 280, 20)];
        errLb.font = [UIFont systemFontOfSize:16];
        errLb.textAlignment = NSTextAlignmentCenter;
        errLb.textColor = [UIColor redColor];
        [pswView addSubview:errLb];
    }
    return self;
}

- (void)cancelBtnClickAction
{
    [UIView animateWithDuration:.4 animations:^{
        self.alpha = 0;
        
    }completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}

- (void)sendBtnClickAction
{
    NSString *oldPsw = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pwdfor%@",_userName]];
    if (![oldTf.text isEqualToString:oldPsw]) {
        oldTf.layer.borderColor = [UIColor redColor].CGColor;
        errLb.text = @"密码不匹配";
        return;
    }
    else
    {
        oldTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (newTf.text.length == 0) {
        newTf.layer.borderColor = [UIColor redColor].CGColor;
        errLb.text = @"请输入新密码";
        return;
    }
    else
    {
        newTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (confirmTf.text.length == 0) {
        confirmTf.layer.borderColor = [UIColor redColor].CGColor;
        errLb.text = @"请确认新密码";
        return;
    }
    else
    {
        confirmTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (![newTf.text isEqualToString:confirmTf.text]) {
        confirmTf.layer.borderColor = [UIColor redColor].CGColor;
        errLb.text = @"新密码不匹配";
        return;
    }
    else
    {
        confirmTf.layer.borderColor = [UIColor blackColor].CGColor;
    }
    errLb.text = @"";
    [self changePwdRequest];
}

- (void)changePwdRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?password=%@",CHANGE_PASSWORD_URL,newTf.text];
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSData *returnData = sendRequestWithFullURLandHeaders(urlStr, nil, headerDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!returnData) {
                errLb.text = @"修改失败，网络超时";
                return;
            }
            NSDictionary *returnDic = parseJsonResponse(returnData);
            if (!returnDic) {
                errLb.text = @"修改失败，返回错误数据";
                return;
            }
            NSNumber *resault = JsonValue([returnDic objectForKey:@"err"],@"NSNumber");
            if (!resault) {
                errLb.text = @"修改失败，返回错误数据";
                return;
            }
            NSInteger err = [resault integerValue];
            if (err>0) {
                NSString *errmsg = JsonValue([returnDic objectForKey:@"errmsg"],@"NSString");
                errLb.text = errmsg;
                return;
            }
            errLb.text = @"修改成功";
            [[NSUserDefaults standardUserDefaults] setObject:newTf.text forKey:[NSString stringWithFormat:@"pwdfor%@",_userName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self cancelBtnClickAction];
            
        });
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
