//
//  NetUtils.h
//  CureMe
//
//  Created by Tim on 12-8-15.
//  Copyright (c) 2012年 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
#define longin_URL            @"http://dev.mapi.lhgene.cn/mobi-cms/login"
#define orderUpload_URL        @"http://dev.mapi.lhgene.cn/mobi-cms/order/upload"
#define uploadExpress_URL     @"http://dev.mapi.lhgene.cn/mobi-cms/order/express"
#define myList_URL            @"http://dev.mapi.lhgene.cn/mobi-cms/order/mylist"
#define operations_URL        @"http://dev.mapi.lhgene.cn/mobi-cms/my/operations"
#define expressList_URL       @"http://dev.mapi.lhgene.cn/mobi-cms/const/express"
#define uploadreport_URL      @"http://dev.mapi.lhgene.cn/mobi-cms/report/express"
#define productList_URL       @"http://dev.mapi.lhgene.cn/mobi-cms/const/product"
#define medical_pic_URL        @"http://dev.mapi.lhgene.cn/mobi-cms/order/medical-pic-upload"
#define medical_pic_delete_URL @"http://dev.mapi.lhgene.cn/mobi-cms/order/medical-pic-delete"
#define orderComplate_URL     @"http://dev.mapi.lhgene.cn/mobi-cms/order/h5more"
#define orderCheck_URL        @"http://dev.mapi.lhgene.cn/mobi-cms/order/check"
 */

#define longin_URL            @"http://mapi.lhgene.cn/mobi-cms/login"
#define orderUpload_URL        @"http://mapi.lhgene.cn/mobi-cms/order/upload"
#define uploadExpress_URL     @"http://mapi.lhgene.cn/mobi-cms/order/express"
#define myList_URL            @"http://mapi.lhgene.cn/mobi-cms/order/mylist"
#define operations_URL        @"http://mapi.lhgene.cn/mobi-cms/my/operations"
#define expressList_URL       @"http://mapi.lhgene.cn/mobi-cms/const/express"
#define uploadreport_URL      @"http://mapi.lhgene.cn/mobi-cms/report/express"
#define productList_URL       @"http://mapi.lhgene.cn/mobi-cms/const/product"
#define medical_pic_URL        @"http://mapi.lhgene.cn/mobi-cms/order/medical-pic-upload"
#define medical_pic_delete_URL @"http://mapi.lhgene.cn/mobi-cms/order/medical-pic-delete"
#define orderComplate_URL     @"http://mapi.lhgene.cn/mobi-cms/order/h5more"
#define orderCheck_URL        @"http://mapi.lhgene.cn/mobi-cms/order/check"

#define WDDD_IMG @"订单查看订单"
#define CGX_IMG  @"草稿箱"
#define CZJL_IMG @"投标纪录"
#define WDXX_IMG @"消息"
#define WDKH_IMG @"客户"

id JsonValue(id value, NSString *defaultClass);

void updateIOSPushInfo();

NSDate* convertDateFromString(NSString *sdate, NSString *format);

NSString* convertStringFromDate(NSDate *date, NSString *format);

NSString* removeHTML(NSString *html);

NSString* urlEncode(NSString *str);

NSString* replaceUnicode(NSString *unicodeStr);

#pragma mark POST methods:

NSData *sendRequestWithFullURL(NSString *fullURL, NSString *post);

NSData *sendRequestWithFullURLandHeaders(NSString *fullURL, NSString *post ,NSDictionary *additionalHeaders);

//NSData *sendRequestWithFullURL22(NSString *fullURL, NSString *post);
NSData *sendRequestWithFullURLNAP(NSString *fullURL, NSMutableDictionary *respDict);
NSData *sendFullRequest(NSString *fullURL, NSString *post, NSDictionary *additionalHeaders, bool needDispNetState, bool saveSetCookie);

// Send synchronous request
NSData *sendRequest(NSString *phpFile, NSString *post);
NSData *sendRequestWithCookie(NSString *phpFile, NSString *post, NSString *cookie, bool saveSetCookie);


NSData *sendRequestWithData(NSString *url, NSData *data);

NSData *sendRequestWithHeaderAndResponse(NSString *phpFile, NSString *post, NSDictionary *additionalHeaders, bool needDispNetState, bool saveSetCookie);

#pragma mark GET methods:
// Send synchronous GET request
NSData *sendGETRequest(NSString *url ,NSDictionary *HTTPAdditionalHeaders);

NSData *sendGetReqWithHeaderAndRespDict(NSString *strUrl, NSDictionary *headers, NSMutableDictionary *respDict, bool needDispNetState);

#pragma mark Json parse methods:
// Parse response string to JSon dictionary
NSDictionary *parseJsonResponse(NSData *response);

NSDictionary *parseJsonString(NSString *str);

NSData* loadRequestWithImg(NSDictionary *params,NSString *url);

