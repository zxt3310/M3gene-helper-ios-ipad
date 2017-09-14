//
//  NetUtils.h
//  CureMe
//
//  Created by Tim on 12-8-15.
//  Copyright (c) 2012年 Tim. All rights reserved.
//

#import <sys/utsname.h>
#import <Foundation/Foundation.h>
#import "CustomURLCache.h"

//测试环境
#define longin_URL             @"http://dev.mapi.lhgene.cn:8088/mobi-cms/login"
#define orderUpload_URL        @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/upload"
#define uploadExpress_URL      @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/express"
#define myList_URL             @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/mylist"
#define operations_URL         @"http://dev.mapi.lhgene.cn:8088/mobi-cms/my/operations"
#define expressList_URL        @"http://dev.mapi.lhgene.cn:8088/mobi-cms/const/express"
#define uploadreport_URL       @"http://dev.mapi.lhgene.cn:8088/mobi-cms/report/express"
#define productList_URL        @"http://dev.mapi.lhgene.cn:8088/mobi-cms/const/product"
#define medical_pic_URL        @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/medical-pic-upload"
#define medical_pic_delete_URL @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/medical-pic-delete"
#define orderComplate_URL      @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/h5more"
#define orderCheck_URL         @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/check"
#define myOrderPage_URL        @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance"
#define orderProcess_URL       @"http://dev.mapi.lhgene.cn:8088/app/s/plan4.html"
#define operate_Ditail_URL     @"http://dev.mapi.lhgene.cn:8088/mobi-cms/h5-opmore"
#define gbk_input_URL          @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/bind_card"
#define SINGLE_ORDER_URL       @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance_order"
#define SINGLE_VIP_URL         @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance_card"
#define SINGLE_PAY_URL         @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance"
#define CHANGE_PASSWORD_URL    @"http://dev.mapi.lhgene.cn:8088/mobi-cms/change_password"

#define Tex_check_URL          @"http://dev.mapi.lhgene.cn:8088/app/mindex.html#/mobile/invoice"
#define news_URL               @"http://dev.mapi.lhgene.cn:8088/mobi-cms/bulletinboard"

#define dataCenter_URL         @"http://dev.mapi.lhgene.cn:8088"
#define dataCenter_GET_URL     @"http://dev.mapi.lhgene.cn:8088/m/api/disk"
#define VIPCARD_UPLOAD_URL     @"http://dev.mapi.lhgene.cn:8088/mobi-cms/card/bind"
#define VIPCARD_productList_URL @"http://dev.mapi.lhgene.cn:8088/mobi-cms/card/get_sales_cards"

#define ORGANIZATION_URL        @"http://dev.mapi.lhgene.cn:8088/mobi-cms/order/organization"
#define RecieveORG_URL          @"http://dev.mapi.lhgene.cn:8088/mobi-cms/get_lab_list"
#define SaveUser_URL            @"http://dev.mapi.lhgene.cn:8088/mobi-cms/examinee/save"
#define Search_existorder_URL   @"http://dev.mapi.lhgene.cn:8088/mobi-cms/examinee/search"
#define SearchAllSample         @"http://dev.mapi.lhgene.cn/mobi-cms/pst/sample"
#define SampleTrasport          @"http://dev.mapi.lhgene.cn/mobi-cms/pst/info"

//正式环境
//#define longin_URL              @"http://mapi.lhgene.cn:8088/mobi-cms/login"
//#define orderUpload_URL         @"http://mapi.lhgene.cn:8088/mobi-cms/order/upload"
//#define uploadExpress_URL       @"http://mapi.lhgene.cn:8088/mobi-cms/order/express"
//#define myList_URL              @"http://mapi.lhgene.cn:8088/mobi-cms/order/mylist"
//#define operations_URL          @"http://mapi.lhgene.cn:8088/mobi-cms/my/operations"
//#define expressList_URL         @"http://mapi.lhgene.cn:8088/mobi-cms/const/express"
//#define uploadreport_URL        @"http://mapi.lhgene.cn:8088/mobi-cms/report/express"
//#define productList_URL         @"http://mapi.lhgene.cn:8088/mobi-cms/const/product"
//#define medical_pic_URL         @"http://mapi.lhgene.cn:8088/mobi-cms/order/medical-pic-upload"
//#define medical_pic_delete_URL  @"http://mapi.lhgene.cn:8088/mobi-cms/order/medical-pic-delete"
//#define orderComplate_URL       @"http://mapi.lhgene.cn:8088/mobi-cms/order/h5more"
//#define orderCheck_URL          @"http://mapi.lhgene.cn:8088/mobi-cms/order/check"
//#define myOrderPage_URL         @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance"
//#define orderProcess_URL        @"http://mapi.lhgene.cn:8088/app/s/plan4.html"
//#define operate_Ditail_URL      @"http://mapi.lhgene.cn:8088/mobi-cms/h5-opmore"
//#define gbk_input_URL           @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/bind_card"
//#define SINGLE_ORDER_URL        @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance_order"
//#define SINGLE_VIP_URL          @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance_card"
//#define SINGLE_PAY_URL          @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/salefinance"
//#define CHANGE_PASSWORD_URL     @"http://mapi.lhgene.cn:8088/mobi-cms/change_password"
//
//#define Tex_check_URL           @"http://mapi.lhgene.cn:8088/app/mindex.html#/mobile/invoice"
//#define news_URL                @"http://mapi.lhgene.cn:8088/mobi-cms/bulletinboard"
//
//#define dataCenter_URL          @"http://mapi.lhgene.cn:8088"
//#define dataCenter_GET_URL      @"http://mapi.lhgene.cn:8088/m/api/disk"
//#define VIPCARD_UPLOAD_URL      @"http://mapi.lhgene.cn:8088/mobi-cms/card/bind"
//#define VIPCARD_productList_URL @"http://mapi.lhgene.cn:8088/mobi-cms/card/get_sales_cards"
//
//#define ORGANIZATION_URL        @"http://mapi.lhgene.cn:8088/mobi-cms/order/organization"
//#define RecieveORG_URL          @"http://mapi.lhgene.cn:8088/mobi-cms/get_lab_list"
//#define SaveUser_URL            @"http://mapi.lhgene.cn:8088/mobi-cms/examinee/save"
//#define Search_existorder_URL   @"http://mapi.lhgene.cn:8088/mobi-cms/examinee/search"
//#define SearchAllSample         @"http://mapi.lhgene.cn/mobi-cms/pst/sample"
//#define SampleTrasport          @"http://mapi.lhgene.cn/mobi-cms/pst/info"
//获取store最新版本
#define appStore_Version_POST_URL @"http://itunes.apple.com/cn/lookup"
//苹果提供的应用唯一id（检测更新用）
#define app_Id @"1203188094"
//蒲公英更新api参数(暂不使用)
#define PGY_UPDATE_Check_VERSION_URL @"http://www.pgyer.com/apiv1/app/builds"
#define PGY_UPDATE_API_aId     @"bbd5c1b921fb7cfc84ae6c79819f3bf3"
#define PGY_UPDATE_API_apiKey  @"766057af41e8975d6bfa93d276b024db"

#define WDDD_IMG @"订单查看订单"
#define CGX_IMG  @"草稿箱"
#define CZJL_IMG @"投标纪录"
#define WDXX_IMG @"消息"
#define WDKH_IMG @"客户"
#define GONGGAO_IMG @"gg"

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


#pragma mark FFNSURLConnectionForHttps
@interface FFNSURLConnectionForHttps : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLResponse *connectionResponse;
@property (strong, nonatomic) NSError *connectionError;
@property (strong, nonatomic) NSMutableData *receiveData;
@property (assign, nonatomic) BOOL isRequestCompleted;
@property (assign, nonatomic) BOOL isRequestExistsError;
@property (strong, nonatomic) NSOperationQueue* ARQueue;
@property (strong, nonatomic) void (^ARCHandler)(NSURLResponse* response, NSData* data, NSError* connectionError);

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error;
+ (void)sendAsynchronousRequest:(NSURLRequest*) request
                          queue:(NSOperationQueue*) queue
              completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

- (void)doIdle:(NSTimer *)theTimer;

@end

NSString* devicePlatForm();
