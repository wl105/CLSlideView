//
//  CLViewModel.h
//  CLSlideViewDemo
//
//  Created by 程磊 on 2017/11/27.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface CLViewModel : NSObject

/**
 创建POST的相关命令
 
 @param url URL
 @param parament 参数
 @param input 执行命令时，传入的值
 @return RACSignal
 */
- (RACSignal *)creatPostCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input;
/**
 创建POST的相关命令，带有缓存
 
 @param url URL
 @param parament 参数
 @param input 执行命令时，传入的值
 @return RACSignal
 */
- (RACSignal *)creatPostAndCacheCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input;
/**
 创建GET的相关命令
 
 @param url URL
 @param parament 参数
 @param input 执行命令时，传入的值
 @return RACSignal
 */
- (RACSignal *)creatGetCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input;
/**
 创建GET的相关命令，带有缓存
 
 @param url URL
 @param parament 参数
 @param input 执行命令时，传入的值
 @return RACSignal
 */
- (RACSignal *)creatGetAndCacheCommandWithUrl:(NSString *)url parament:(NSDictionary *)parament input:(id)input;

@end
