//
//  CLViewModel.m
//  CLSlideViewDemo
//
//  Created by 程磊 on 2017/11/27.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import "CLViewModel.h"

@implementation CLViewModel


- (RACSignal *)creatPostCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RequestModel *model = [RequestModel new];
        
        [HttpManger POST:url parameters:parament success:^(id responseObject) {
            NSDictionary *data = (NSDictionary *)responseObject;
            
            CLLog(@"------%@ ~~~~~~~~~ %@  ^^^^^^^^  %@  ",url ,parament, data);
            
            if ([data.allKeys containsObject:@"executeStatus"]) {
                if ([data[@"executeStatus"] intValue] == 0) {// 0是请求成功
                    model.state = CLRefreshSuccessState;
                    if ([data.allKeys containsObject:@"values"]) {
                        if ([data[@"values"] isKindOfClass:[NSDictionary class]]) {
                            if ([[data[@"values"] allKeys] containsObject:@"rows"]) {
                                model.values = data[@"values"][@"rows"];
                            }else{
                                model.values = data[@"values"];
                            }
                        }else{
                            model.values = data[@"values"];
                        }
                    }
                    
                }else{
                    model.state = CLRefreshSuccessDataErrorState;
                    model.errorMsg = data;
                }
            }
            // 发送命令完成
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            model.state = CLRefreshDataFailureState;
            model.error = error;
            
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        }];
        
        return nil;
    }];
    
}
- (RACSignal *)creatPostAndCacheCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RequestModel *model = [RequestModel new];
        
        [HttpManger POST:url parameters:parament responseCache:^(id responseCache) {
            NSDictionary *data = (NSDictionary *)responseCache;
            if ([data.allKeys containsObject:@"executeStatus"]) {
                if ([data[@"executeStatus"] intValue] == 0) {// 0是请求成功
                    model.state = CLRefreshCacheSuccessState;
                    if ([data.allKeys containsObject:@"values"]) {
                        if ([data[@"values"] isKindOfClass:[NSDictionary class]]) {
                            if ([[data[@"values"] allKeys] containsObject:@"rows"]) {
                                model.values = data[@"values"][@"rows"];
                            }else{
                                model.values = data[@"values"];
                            }
                            
                        }else{
                            model.values = data[@"values"];
                        }
                    }
                    
                }
            }
            // 发送命令完成
            [subscriber sendNext:model];
            
        } success:^(id responseObject) {
            NSDictionary *data = (NSDictionary *)responseObject;
            if ([data.allKeys containsObject:@"executeStatus"]) {
                if ([data[@"executeStatus"] intValue] == 0) {// 0是请求成功
                    model.state = CLRefreshSuccessState;
                    if ([data.allKeys containsObject:@"values"]) {
                        if ([data[@"values"] isKindOfClass:[NSDictionary class]]) {
                            if ([[data[@"values"] allKeys] containsObject:@"rows"]) {
                                model.values = data[@"values"][@"rows"];
                            }else{
                                model.values = data[@"values"];
                            }
                            
                        }else{
                            model.values = data[@"values"];
                        }
                    }
                    
                }else{
                    model.state = CLRefreshSuccessDataErrorState;
                    model.errorMsg = data;
                }
            }
            // 发送命令完成
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            model.state = CLRefreshDataFailureState;
            model.error = error;
            
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        }];
        
        return nil;
    }];
    
}

- (RACSignal *)creatGetCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RequestModel *model = [RequestModel new];
        
        [HttpManger GET:url parameters:parament success:^(id responseObject) {
            CLLog(@"%@",responseObject);
            NSDictionary *data = (NSDictionary *)responseObject;
            
            if ([data.allKeys containsObject:@"executeStatus"]) {
                if ([data[@"executeStatus"] intValue] == 0) {// 0是请求成功
                    model.state = CLRefreshSuccessState;
                    if ([data.allKeys containsObject:@"values"]) {
                        if ([data[@"values"] isKindOfClass:[NSDictionary class]]) {
                            if ([[data[@"values"] allKeys] containsObject:@"rows"]) {
                                model.values = data[@"values"][@"rows"];
                            }else {
                                model.values = data[@"values"];
                            }
                            
                        }else{
                            model.values = data[@"values"];
                        }
                    }
                    
                }else{
                    model.state = CLRefreshSuccessDataErrorState;
                    model.errorMsg = data;
                }
            }else{
                model.state = CLRefreshSuccessState;
                model.values = data;
            }
            
            
            // 发送命令完成
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            model.state = CLRefreshDataFailureState;
            model.error = error;
            
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        }];
        
        return nil;
    }];
    
}

@end
