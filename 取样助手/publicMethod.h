//
//  publicMethod.h
//  取样助手
//
//  Created by 张信涛 on 16/11/2.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WEIGHT [[UIScreen mainScreen] bounds].size.width
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TABBAR_HEIGHT self.tabBarController.tabBar.frame.size.height
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WEIGHT, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WEIGHT, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define CLASS_NUMBER @"NSNumber"
#define CLASS_STRING @"NSString"
#define CLASS_DICTIONARY @"NSDictionary"
#define CLASS_ARRAY @"NSArray"


#define MYBLUECOLOR [UIColor colorWithRed:114.0/255 green:176.0/255 blue:248.0/255 alpha:1]
#define MYBUTTONCOLOR [UIColor colorWithRed:88.0/255 green:207.0/255 blue:225.0/255 alpha:1]


#define TEXTFONT @"STHeitiSC-Light"
#define MYUIFONT [UIFont fontWithName:TEXTFONT size:22]
#define MYBUTTONFONT [UIFont fontWithName:TEXTFONT size:16]

void setIntObjectForKey(NSInteger value,NSString *key);

void setStringObjectForKey(NSString *value,NSString *key);

NSInteger getIntForKey(NSString *key);

NSString* getStringForKey(NSString* key);

NSString* deviceImageSelect (NSString *imageName);

NSDate* getCurrentDate();

void alertMsgView(NSString *alertMsg ,UIViewController *uvc);

@interface UIFont (custom)

+(UIFont*) app_FontSize:(CGFloat) size;
+(UIFont *)app_FontSizeBold:(CGFloat)size;

@end
@interface UIColor (custom)

+(UIColor *) colorWithMyNeed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end

//定义自己的cgmake
CG_INLINE CGRect

CGRectMakeWithAutoSize(CGFloat x, CGFloat y, CGFloat width, CGFloat height)

{
    CGRect rect;
    rect.origin.x = SCREEN_WEIGHT * x/375;
    rect.origin.y = SCREEN_HEIGHT * y/667;
    rect.size.width = SCREEN_WEIGHT * width/375;
    rect.size.height = SCREEN_HEIGHT *height/667;
    return rect;
}
