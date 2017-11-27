//
//  HttpManger.m
//  111
//
//  Created by chenglei on 16/9/2.
//  Copyright © 2016年 chenglei. All rights reserved.
//

#import "HttpManger.h"
#import <AFNetworking/AFNetworking.h>
#import "Macro.h"


@implementation HttpManger
/**
 在没有对类做任何操作的情况下，+load 方法会被默认执行，并且是在 main 函数之前执行的
 */
+ (void)load{
}

/**
+ initialize 方法类似一个懒加载，如果没有使用这个类，那么系统默认不会去调用这个方法，且默认只加载一次；
+ initialize 的调用发生在 +init 方法之前
 */
+ (void)initialize
{
    // 设置AFHTTPSessionManager相关属性
    [PPNetworkHelper setRequestTimeoutInterval:5.0f];
    [PPNetworkHelper setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager) {
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/x-www-form-urlencoded", nil];

//        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }];
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(HttpNetworkStatus)networkStatus {
    
    return [PPNetworkHelper networkStatusWithBlock:networkStatus];
}

+ (void)cancelAllRequest
{
    [PPNetworkHelper cancelAllRequest];
}

+ (void)cancelRequestWithURL:(NSString *)URL
{
    [PPNetworkHelper cancelRequestWithURL:URL];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [PPNetworkCache getAllHttpCacheSize];
}

+ (void)removeAllHttpCache
{
    return [PPNetworkCache removeAllHttpCache];
}

+ (NSURLSessionTask *)GET:(NSString *)URL parameters:(id)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    NSString *urlStr = [HttpManger generateNewUrlWithURL:URL parameters:parameters];
    
    return [PPNetworkHelper GET:urlStr parameters:parameters success:success failure:failure];
}

+ (NSURLSessionTask *)GET:(NSString *)URL parameters:(id)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    NSString *urlStr = [HttpManger generateNewUrlWithURL:URL parameters:parameters];
    
    return [PPNetworkHelper GET:urlStr parameters:parameters responseCache:responseCache success:success failure:failure];
}

+ (NSURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    
    NSString *urlStr = [HttpManger generateNewUrlWithURL:URL parameters:parameters];
    
    return [PPNetworkHelper POST:urlStr parameters:parameters success:success failure:failure];
}

+ (NSURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    NSString *urlStr = [HttpManger generateNewUrlWithURL:URL parameters:parameters];
    
    return [PPNetworkHelper POST:urlStr parameters:parameters responseCache:responseCache success:success failure:failure];
}


+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name filePath:(NSString *)filePath progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    return [PPNetworkHelper uploadFileWithURL:URL parameters:parameters name:name filePath:filePath progress:progress success:success failure:failure];
}

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    return [PPNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:progress success:success failure:failure];
}

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void (^)(NSString *))success failure:(HttpRequestFailed)failure
{
    return [PPNetworkHelper downloadWithURL:URL fileDir:fileDir progress:progress success:success failure:failure];
}

// 为了需要，生成新的URL
+ (NSString *)generateNewUrlWithURL:(NSString *)url parameters:(id)parameters
{
    // URL转码，防止其中有空字符串及中文
    NSString *url_utf8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CLLog(@"URL地址：%@ ", url_utf8);
    [HttpManger setHeaderCookieWithURL:url_utf8];
    
    
    return url_utf8;
}
// 在cookie中sessionId有变化时，更新请求头的cookie
+ (void)setHeaderCookieWithURL:(NSString *)urlStr
{
    //获取cookie
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *oldCookie = [ud objectForKey:@"kCookieJSESSIONID"];
    [ud synchronize];

    if (IsStrEmpty(oldCookie)) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        NSMutableString *muStr = [NSMutableString stringWithCapacity:10];
        [cookies enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSHTTPCookie *cookie = obj;
            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                if (muStr.length > 0) {
                    [muStr appendString:@";"];
                }
                [muStr appendString:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value]];
            }
            
        }];
        [ud setValue:muStr forKey:@"kCookieJSESSIONID"];
        [ud synchronize];
        [PPNetworkHelper setValue:muStr forHTTPHeaderField:@"Cookie"];
        CLLog(@"arr: %@", muStr);

    }else{
        [PPNetworkHelper setValue:oldCookie forHTTPHeaderField:@"Cookie"];
    }
    
        CLLog(@"old-sessionId: %@", oldCookie);
    
    
}

@end
