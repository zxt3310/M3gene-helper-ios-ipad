//
//  publicMethod.m
//  取样助手
//
//  Created by 张信涛 on 16/11/2.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "publicMethod.h"


void setIntObjectForKey(NSInteger value,NSString *key)
{
    if (!key || [key length] <= 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

void setStringObjectForKey(NSString *value,NSString *key)
{
    if (!key || [key length] <= 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

NSInteger getIntForKey(NSString *key)
{
    if (!key || [key length] <= 0) {
        return 0;
    }
    
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
    
}


NSString* getStringForKey(NSString* key)
{
    if (!key || [key length] <= 0) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


NSString* deviceImageSelect (NSString *imageName)
{
    NSMutableArray *arry = [[NSMutableArray alloc]init];
    NSMutableString *string = [NSMutableString stringWithString:imageName];
    int n = 0;
    for (int i = 0; i < imageName.length; i++) {
        arry[i] = [imageName substringWithRange:NSMakeRange(i, 1)];
        if([arry[i]  isEqual: @"."])
        {
            n = i;
            break;
        }
    }
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        return imageName;
    }
    else if(IS_IPHONE_6)
    {
        [string insertString:@"@2x" atIndex:n];
    }
    else if(IS_IPHONE_6P)
    {
        [string insertString:@"@3x" atIndex:n];
    }
    else
    {
        [string insertString:@"@3x" atIndex:n];
    }
    
    NSLog(@"loading image %@",string);
    
    return [string copy];
}

void alertMsgView(NSString *alertMsg ,UIViewController *uvc)
{
    if(alertMsg)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ula = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ula];
        [uvc presentViewController:alert animated:YES completion:nil];
    }
    
}

@implementation UIFont (custom)

+(UIFont *)app_FontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FZXDXJW--GB1-0" size:SCREEN_WEIGHT * size/375];
}

+(UIFont *)app_FontSizeBold:(CGFloat)size
{
    return [UIFont fontWithName:@"FZXDXJW--GB1-0-Bold" size:SCREEN_WEIGHT * size/375];
}

@end

@implementation UIColor (custom)

+(UIColor *) colorWithMyNeed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}
@end
