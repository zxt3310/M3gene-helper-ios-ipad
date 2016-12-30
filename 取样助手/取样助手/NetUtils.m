//
//  NetUtils.m
//  CureMe
//
//  Created by Tim on 12-8-15.
//  Copyright (c) 2012年 Tim. All rights reserved.
//


#import "NetUtils.h"
#import <UIKit/UIKit.h>

#define USER_UNIQUE_ID @"token"
#define NTF_NetNotReachable @"N_netNotReachable"

// 同步请求统一函数
// 默认所有调用此函数的请求，都发送至 medapp.ranknowcn.com/api/m.php
NSData *sendRequest(NSString *phpFile, NSString *post)
{
    NSString *finalPost = [[NSString alloc] initWithFormat:@"%@&version=2.2&deviceid=%@&appid=3&source=apple", post, [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID]];
    NSLog(@"sendRequest: %@", finalPost);
    
    NSDictionary *additionalHeader = nil;
    return sendRequestWithHeaderAndResponse(phpFile, finalPost, additionalHeader, true, false);
}

NSData *sendRequestWithFullURL(NSString *fullURL, NSString *post)
{
    //NSString *finalPost = [NSString stringWithFormat:@"%@&version=2.2&deviceid=%@&appid=3&source=apple", post, [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID]];
   // NSString *finalPost = [post stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *finalPost = [post stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSLog(@"sendRequestWithFullURL:%@ post:%@", fullURL, finalPost);
    
    return sendFullRequest(fullURL, finalPost, nil, true, true);
}

NSData *sendRequestWithFullURLandHeaders(NSString *fullURL, NSString *post ,NSDictionary *additionalHeaders)
{
    //NSString *finalPost = [NSString stringWithFormat:@"%@&version=2.2&deviceid=%@&appid=3&source=apple", post, [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID]];
    // NSString *finalPost = [post stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *finalPost = [post stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSLog(@"sendRequestWithFullURL:%@ post:%@", fullURL, finalPost);
    
    return sendFullRequest(fullURL, finalPost, additionalHeaders, true, false);
}
/*
NSData *sendRequestWithFullURL22(NSString *fullURL, NSString *post)
{
    NSString *finalPost = [NSString stringWithFormat:@"%@&version=2.2&deviceid=%@&appid=3&source=apple", post, [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID]];
    NSLog(@"sendRequestWithFullURL:%@ post:%@", fullURL, finalPost);
    
    return sendFullRequest(fullURL, finalPost, nil, true, false);
}*/

NSData *sendRequestWithFullURLNAP(NSString *fullURL, NSMutableDictionary *respDict)
{
    NSLog(@"sendRequestWithFullURLNAP:%@", fullURL);
    NSDictionary *additionalHeader = nil;
    additionalHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"appid", nil];
    
    return sendGetReqWithHeaderAndRespDict(fullURL, additionalHeader, respDict, false);
}

NSData *sendRequestWithCookie(NSString *phpFile, NSString *post, NSString *cookie, bool saveSetCookie) {
    NSString *finalPost = [[NSString alloc] initWithFormat:@"%@&version=2.2&deviceid=%@&appid=3&source=apple", post, [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID]];
    NSLog(@"sendRequest: %@", finalPost);
    
    NSDictionary *additionalHeader = nil;
    if (cookie && [cookie length] > 0) {
        additionalHeader = [NSDictionary dictionaryWithObjectsAndKeys:cookie, @"Cookie", nil];
    }
    NSData *respData = sendRequestWithHeaderAndResponse(phpFile, finalPost, additionalHeader, true, saveSetCookie);
    
    return respData;
}

NSData *sendFullRequest(NSString *fullURL, NSString *post, NSDictionary *additionalHeaders, bool needDispNetState, bool saveSetCookie)
{
    if (needDispNetState) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    NSData *data = nil;
    NSString *postLength = nil;
    NSURLResponse *response = nil;
    NSData *returnData = nil;
    NSHTTPURLResponse *httpResponse = nil;
    NSString *responseString = nil;
    
    @autoreleasepool {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        data = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSData *postData = nil;
        NSString *finalURL = nil;
        postData = data;
        finalURL = fullURL;
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setURL:[NSURL URLWithString:finalURL]];
        
        if (additionalHeaders) {
            NSArray *keys = additionalHeaders.allKeys;
            for (NSString *key in keys) {
                NSString *value = [additionalHeaders objectForKey:key];
                NSLog(@"POST add Header: %@ value: %@", key, value);
                [request addValue:value forHTTPHeaderField:key];
            }
        }
        [request setHTTPMethod:@"POST"];
        //[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] != 200) {
            NSLog(@"Response error: http status %ld", (long)[httpResponse statusCode]);
            responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
        }
        
        if (saveSetCookie) {
            NSDictionary *headers = httpResponse.allHeaderFields;
            NSLog(@"setCookie resp: %@", headers);
            
            NSString *setCookie = [headers objectForKey:@"Set-Cookie"];
            if (setCookie && [setCookie length] > 0) {
                //                [CureMeUtils defaultCureMeUtil].loginCookie = setCookie;
                [[NSUserDefaults standardUserDefaults] setObject:setCookie forKey:@"Set-Cookie"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        // show in the status bar that network activity is starting
        if (needDispNetState) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    
    return returnData;
}

NSData *sendRequestWithData(NSString *url, NSData *data)
{
    if (!data || [data length] <= 0) {
        return nil;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *postLength = nil;
    NSURLResponse *response = nil;
    NSData *returnData = nil;
    NSHTTPURLResponse *httpResponse = nil;
    NSString *responseString = nil;
    
    @autoreleasepool {
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *fullURL = [NSString stringWithFormat:@"%@", url];
        [request setURL:[NSURL URLWithString:fullURL]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] != 200) {
            NSLog(@"Response error: http status %ld", (long)[httpResponse statusCode]);
            responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
        }
        httpResponse = nil;
    }
    
    // show in the status bar that network activity is starting
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return returnData;
}

NSData * sendRequestWithHeaderAndResponse(NSString *phpFile, NSString *post, NSDictionary *additionalHeader, bool needDispNetState, bool saveSetCookie)
{
//    Reachability *reachability = [Reachability reachabilityWithHostname:@"new.medapp.ranknowcn.com"];
//    
//    NSNotification *note = nil;
//    switch ([reachability currentReachabilityStatus]) {
//        case NotReachable:
//            NSLog(@"new.medapp.ranknowcn.com host not reachable");
//            note = [NSNotification notificationWithName:NTF_NetNotReachable object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:note];
//            break;
//        default:
//            break;
//    }
    
    // show in the status bar that network activity is starting
    if (needDispNetState) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    NSData *postData = nil;
    NSString *postLength = nil;
    NSURLResponse *response = nil;
    NSData *returnData = nil;
    NSHTTPURLResponse *httpResponse = nil;
    NSString *responseString = nil;
    
    @autoreleasepool {
        postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *fullURL = [NSString stringWithFormat:@"http://new.medapp.ranknowcn.com/api/%@?rn=%.2f", phpFile, [[[NSDate alloc] init] timeIntervalSince1970]];
        [request setURL:[NSURL URLWithString:fullURL]];
        if (additionalHeader) {
            NSArray *keys = additionalHeader.allKeys;
            for (NSString *key in keys) {
                NSString *value = [additionalHeader objectForKey:key];
                NSLog(@"POST add Header: %@ value: %@", key, value);
                [request addValue:value forHTTPHeaderField:key];
            }
        }
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] != 200) {
            NSLog(@"Response error: http status %ld", (long)[httpResponse statusCode]);
            responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
        }
        
        if (saveSetCookie) {
            NSDictionary *headers = httpResponse.allHeaderFields;
            NSLog(@"setCookie resp: %@", headers);
            
            NSString *setCookie = [headers objectForKey:@"Set-Cookie"];
            if (setCookie && [setCookie length] > 0) {
              //  [CureMeUtils defaultCureMeUtil].loginCookie = setCookie;
            }
        }
        
        // show in the status bar that network activity is starting
        if (needDispNetState) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    
    return returnData;
}


NSData *sendGETRequest(NSString *strUrl, NSDictionary *HTTPAdditionalHeaders)
{
    return sendGetReqWithHeaderAndRespDict(strUrl, HTTPAdditionalHeaders, nil, false);
}

NSData *sendGetReqWithHeaderAndRespDict(NSString *strUrl, NSDictionary *headers, NSMutableDictionary *respDict, bool needDispNetState)
{
    // show in the status bar that network activity is starting
    if (needDispNetState) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    NSData *data = nil;
    @autoreleasepool {
        @try {
            NSURL* url = [NSURL URLWithString:strUrl];
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
            [request setTimeoutInterval:10];
            [request setURL:url];
            [request setHTTPMethod:@"GET"];
            if (headers) {
                NSArray *keys = headers.allKeys;
                for (NSString *key in keys) {
                    NSString *value = [headers objectForKey:key];
                    NSLog(@"GET and header: %@ value: %@", key, value);
                    [request addValue:value forHTTPHeaderField:key];
                }
            }
            
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            //            NSLog(@"sendGetReqWithHeaderAndRespDict request: %@", request);
            data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
            if (!data) {
                NSLog(@"sendSynchronousRequest fail with error: %@", error);
            }
            
            if (respDict) {
                NSArray *keys = response.allHeaderFields.allKeys;
                for (NSString *key in keys) {
                    [respDict setObject:[response.allHeaderFields objectForKey:key] forKey:key];
                }
            }
            
            response = nil;
            
            // show in the status bar that network activity is starting
            if (needDispNetState) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"sendGetReqWithHeaderAndRespDict exception: %@", exception);
        }
        @finally {
        }
    }
    
    return data;
}


#pragma mark Json parse methods
NSDictionary *parseJsonString(NSString *str)
{
    if (!str || str.length <= 0)
        return nil;
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
}

NSDictionary *parseJsonResponse(NSData *response)
{
    if (!response)
        return nil;
    
    if ([response length] <= 0) {
        return nil;
    }

   
    
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
}

/*
NSDictionary *parseJsonString(NSString *str)
{
    if (!str || str.length <= 0)
        return nil;
    
    JSONDecoder *decoder = [CureMeUtils defaultCureMeUtil].jsonDecoder;
    
    NSMutableDictionary *parseResult = nil;
    
    NSError *error = nil;
    parseResult = [decoder objectWithUTF8String:(const unsigned char*)[str UTF8String] length:[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding] error:&error];
    
    //    NSLog(@"JsonData %@ from string: %@", parseResult, str);
    
    return parseResult;
}

NSDictionary *parseJsonResponse(NSData *response)
{
    if (!response)
        return nil;
    
    JSONDecoder *decoder = [CureMeUtils defaultCureMeUtil].jsonDecoder;
    
    NSMutableDictionary *parseResult = nil;
    if ([response length] <= 0) {
        return parseResult;
    }
    
    parseResult = [decoder objectWithData:response];
    
    return parseResult;
}
*/
/*
void updateIOSPushInfo()
{
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_TOKEN];
    NSString *uniID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_UNIQUE_ID];
    
    if (!uniID || !pushToken)
        return;
    
    NSString *post = [[NSString alloc] initWithFormat:@"action=updiospush&userid=%ld&token=%@", (long)[[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] integerValue], pushToken];
    NSData *response = sendRequest(@"m.php", post);
    
    NSString *strResp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"action=updiospush resp: %@", strResp);
    
    NSDictionary *jsonData = parseJsonResponse(response);
    if (!jsonData || jsonData.count <= 0) {
        NSLog(@"action=updiospush json invalid: %@", strResp);
        return;
    }
    
    NSNumber *result = [jsonData objectForKey:@"result"];
    if (!result || result.integerValue != 1) {
        NSString *error = [jsonData objectForKey:@"msg"];
        NSLog(@"action=updiospush result invalid: %@", error);
        return;
    }
}
 */

id JsonValue(id value, NSString *defaultClass)
{
    if (!value) {
        if (!defaultClass || [defaultClass length] <= 0)
            return nil;
        
        return [[NSClassFromString(defaultClass) alloc] init];
    }
    
    if ([value isKindOfClass:[NSNull class]])
        return [[NSClassFromString(defaultClass) alloc] init];
    
    return value;
}

NSDate* convertDateFromString(NSString *sdate, NSString *format)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:sdate];
    return date;
}

NSString* convertStringFromDate(NSDate *date, NSString *format)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString* removeHTML(NSString *html)
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
    /*
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    return plainText;*/
}

NSString* urlEncode(NSString *str)
{
    if (!str || str.length==0)
        return @"";
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    NSInteger sourceLen = strlen((const char *)source);
    for (NSInteger i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

NSString* replaceUnicode(NSString *unicodeStr)
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                        mutabilityOption:NSPropertyListImmutable
                                                                  format:NULL
                                                        errorDescription:NULL];
    //NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}



#pragma mark 上传图片的 post 请求
NSData* loadRequestWithImg(NSDictionary *params,NSString *url)
{
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"] & ![key isEqualToString:@"token"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
        
    }
    
    
    if(image)
    {
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png

        [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"image.jpg\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    if(image)
    {
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content;
    if(image)
    {
       content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    }
  
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    [request addValue:[params objectForKey:@"token"] forHTTPHeaderField:@"token"];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = nil;
    NSURLResponse *response = nil;
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *strResp = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strResp);
    
    NSHTTPURLResponse *httpResponse = nil;
    httpResponse = (NSHTTPURLResponse *) response;
    if ([httpResponse statusCode] != 200) {
        NSLog(@"Response error: http status %ld", (long)[httpResponse statusCode]);
        NSString *responseString = nil;
        responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
    }
    
    return returnData;
}





#pragma mark FFNSURLConnectionForHttps
@implementation FFNSURLConnectionForHttps
@synthesize connectionResponse = _connectionResponse;
@synthesize connectionError = _connectionError;
@synthesize receiveData = _receiveData;
@synthesize isRequestCompleted = _isRequestCompleted;
@synthesize isRequestExistsError = _isRequestExistsError;
@synthesize ARQueue = _ARQueue;
@synthesize ARCHandler = _ARCHandler;

//void (^completionHandler)(NSURLResponse* response, NSData* data, NSError* connectionError);

- (id) init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)doIdle:(NSTimer *) theTimer
{
    //NSLog(@"FFNSURLConnectionForHttps sendSynchronousRequest timer idle");
}




+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    FFNSURLConnectionForHttps *ep_https_connection = [[FFNSURLConnectionForHttps alloc] init];
    ep_https_connection.isRequestCompleted = NO;
    ep_https_connection.isRequestExistsError = NO;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:ep_https_connection];
    if (conn)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:ep_https_connection selector:@selector(doIdle:) userInfo:nil repeats:YES];
        while (!ep_https_connection.isRequestCompleted) {
            //NSLog(@"loop");
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        [timer invalidate];
        if (response!=nil) *response = ep_https_connection.connectionResponse;
        if (error!=nil) *error = ep_https_connection.connectionError;
        if (ep_https_connection.isRequestExistsError) {
            return nil;
        }
        else{
            return ep_https_connection.receiveData;
        }
    }
    return nil;
}

+ (void)sendAsynchronousRequest:(NSURLRequest*) request
                          queue:(NSOperationQueue*) queue
              completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler {
    FFNSURLConnectionForHttps *ep_https_connection = [[FFNSURLConnectionForHttps alloc] init];
    ep_https_connection.isRequestCompleted = NO;
    ep_https_connection.isRequestExistsError = NO;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:ep_https_connection];
    if (conn)
    {
        ep_https_connection.ARQueue = queue;
        ep_https_connection.ARCHandler = handler;
    }
    else
    {
        if (queue && handler) {
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:@"The connection is failed to be created." forKey:NSLocalizedDescriptionKey];
            NSError *aError = [NSError errorWithDomain:@"sendAsynchronousRequestErrorDomain" code:-1000 userInfo:userinfo];
            [queue addOperationWithBlock:^()
             {
                 handler(nil, nil, aError);
             }];
        }
    }
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"FFNSURLConnectionForHttps didReceiveResponse");
    _connectionResponse = response;
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        
        _receiveData = [[NSMutableData alloc] initWithCapacity:expected];
    }
    else {
        NSLog(@"FFNSURLConnectionForHttps fail, %@", response);
        [connection cancel];
        _receiveData = nil;
        _isRequestExistsError = YES;
        _isRequestCompleted = YES;
        if (_ARQueue && _ARCHandler) {
            NSDictionary *userinfo = [NSDictionary dictionaryWithObject:@"The response statusCode is invalid." forKey:NSLocalizedDescriptionKey];
            NSError *aError = [NSError errorWithDomain:@"sendAsynchronousRequestErrorDomain" code:-999 userInfo:userinfo];
            [_ARQueue addOperationWithBlock:^()
             {
                 _ARCHandler(response, nil, aError);
             }];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"FFNSURLConnectionForHttps didReceiveData");
    if (data == nil) {
        NSLog(@"data is nil, FFNSURLConnectionForHttps");
        return;
    }
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    //NSLog(@"FFNSURLConnectionForHttps connectionDidFinishLoading");
    _isRequestCompleted = YES;
    _isRequestExistsError = NO;
    
    
    if (_ARQueue && _ARCHandler) {
        [_ARQueue addOperationWithBlock:^()
         {
             _ARCHandler(_connectionResponse, _receiveData, nil);
         }];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FFNSURLConnectionForHttps didFailWithError: %@", error);
    _connectionError = error;
    _isRequestCompleted = YES;
    _isRequestExistsError = NO;
    _receiveData = nil;
    if (_ARQueue && _ARCHandler) {
        [_ARQueue addOperationWithBlock:^()
         {
             _ARCHandler(_connectionResponse, nil, error);
         }];
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //[challenge.sender cancelAuthenticationChallenge:challenge];
    /*if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
     NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
     [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
     } else {
     [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
     }*/
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    return;
    /*
     static CFArrayRef certs;
     if (!certs) {
     NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:API_URL_STR ofType:@"der"]];
     //SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
     SecCertificateRef rootcert = SecCertificateCreateWithData(NULL,(__bridge CFDataRef)certData);
     const void *array[1] = { rootcert };
     certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
     //CFRelease(rootcert);    // for completeness, really does not matter
     }
     
     SecTrustRef trust = [[challenge protectionSpace] serverTrust];
     int err;
     SecTrustResultType trustResult = 0;
     err = SecTrustSetAnchorCertificates(trust, certs);
     
     if (err == noErr) {
     err = SecTrustEvaluate(trust,&trustResult);
     }
     //CFRelease(trust);
     BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
     
     if (trusted) {
     [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
     }else{
     [challenge.sender cancelAuthenticationChallenge:challenge];
     }
     */
}

@end

