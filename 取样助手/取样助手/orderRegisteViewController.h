//
//  orderRegisteViewController.h
//  取样助手
//
//  Created by 张信涛 on 16/11/5.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registTranslaterProtocol <NSObject>
- (void)transRegistString:(NSString *)registStr;
@end

@interface orderRegisteViewController : UIViewController <UIWebViewDelegate>
@property id <registTranslaterProtocol> transDelegate;
@property NSString *orderUrl;
@property NSString *registStr;
@end
