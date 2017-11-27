//
//  RequestModel.m
//  QiDongYinQing
//
//  Created by chenglei on 17/7/13.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 重写forUndefinedKey方法，避免model参数和请求数据中不一样而引发的问题
}

+ (void)clReturnRequestDataWith:(id)x cache:(CacheDataBlock)cache data:(SuccessDataBlock)data failure:(FailureDataBlock)failure
{
    RequestModel *model = (RequestModel *)x;
    switch (model.state) {
        case CLRefreshCacheSuccessState:
        {
            if (cache) {
                cache(model.values);
            }
        }
            break;
        case CLRefreshCacheFailureState:
        {
            // 缓存了错误的信息（比如缓存了：errormMsg）
        }
            break;

        case CLRefreshSuccessState:
        {
            if (data) {
                data(model.values);
            }
        }
            break;
        case CLRefreshSuccessDataErrorState:
        {            
            if ([model.errorMsg isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic_msg = model.errorMsg;
                if (failure) {
                    failure(dic_msg);
                }

            }
        }
            break;
        case CLRefreshDataFailureState:
        {
            /*
            if (![model.error.localizedDescription isEqualToString:@"已取消"]) {// 取消请求
                [MBProgressHUD showError:@"服务器请求失败！！！"];
            }
            */
            if (failure) {
                failure(model.error);
            }
            
        }
            break;

        default:
            break;
    }

}


@end
