//
//  RequestModel.h
//  QiDongYinQing
//
//  Created by chenglei on 17/7/13.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

// 请求数据的状态
typedef NS_ENUM(NSUInteger, CLRefreshDataStatus) {
    CLHeaderRefresh_HasMoreData = 0, // 头部刷新，有新消息
    CLHeaderRefresh_HasNoMoreData,  // 头部刷新，没有消息
    CLFooterRefresh_HasMoreData,       // 尾部刷新，有新消息
    CLFooterRefresh_HasNoMoreData,   // 尾部刷新，没有消息
    
    CLRefreshEndNeedLoginState = 90,  // 未登录
    //    CLRefreshLoginOverdueState,          // 登录过期
    
    CLRefreshCacheSuccessState = 100, // 缓存的成功信息
    CLRefreshCacheFailureState,            // 缓存的错误信息
    CLRefreshSuccessState,                   // 请求成功
    CLRefreshSuccessDataErrorState,     // 发送请求成功，但数据出现错误
    CLRefreshDataFailureState               // 发送请求失败
};

typedef void(^CacheDataBlock)(id cache);
typedef void(^SuccessDataBlock)(id data);
typedef void(^FailureDataBlock)(id error);

@interface RequestModel : NSObject

@property(nonatomic,assign)CLRefreshDataStatus state;// 请求结果状态
@property(nonatomic,strong)id values;// 请求成功的值
@property(nonatomic,strong)id errorMsg;// 请求错误信息
@property(nonatomic,strong)NSError *error;// 请求失败error


+ (void)clReturnRequestDataWith:(id)x cache:(CacheDataBlock)cache data:(SuccessDataBlock)data failure:(FailureDataBlock)failure;

@end
