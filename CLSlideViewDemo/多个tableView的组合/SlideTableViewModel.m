//
//  SlideTableViewModel.m
//  QiDongYinQing
//
//  Created by chenglei on 17/7/21.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "SlideTableViewModel.h"
#import "SlideModel.h"

@interface SlideTableViewModel ()
@property(nonatomic,assign)SlideTableParamStyle paramStyle;// 参数类型，默认有页数
@end
@implementation SlideTableViewModel{
    __block Class _modelClass;
}

- (instancetype)initWithModelCLass:(Class)modelClass style:(SlideTableParamStyle)style
{
    self = [super init];
    if (self) {
        _modelClass = modelClass;
        self.paramStyle = style;
        
        [self cl_initialize];
    }
    return self;
}

- (void)cl_initialize
{
    racWeak(self);
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        racStrong(self);
        [RequestModel clReturnRequestDataWith:x cache:^(id cache) {
            self.messageArray = [_modelClass mj_objectArrayWithKeyValuesArray:cache];
            
        } data:^(id data) {
            self.messageArray = [_modelClass mj_objectArrayWithKeyValuesArray:data];

        } failure:^(id error) {
            [self.failureSubject sendNext:error];
            
        }];
    }];

}

#pragma mark ---- getter
- (RACCommand *)requestCommand
{
    if (!_requestCommand) {
        racWeak(self);
        _requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            racStrong(self);
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                RequestModel *model = [RequestModel new];
                
                [HttpManger GET:self.pathUrl parameters:input responseCache:^(id responseCache) {
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

        }];
    }
    return _requestCommand;
}
- (RACSubject *)failureSubject
{
    if (!_failureSubject) {
        _failureSubject = [RACSubject subject];
    }
    return _failureSubject;
}
- (NSMutableArray *)allArray
{
    if (!_allArray) {
        _allArray = [NSMutableArray array];
        for (int i = 0; i < 20; i ++) {
            [_allArray insertObject:@[] atIndex:0];
        }
    }
    return _allArray;
}

@end
