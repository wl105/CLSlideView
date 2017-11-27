//
//  SlideTableViewModel.h
//  QiDongYinQing
//
//  Created by chenglei on 17/7/21.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

typedef NS_ENUM(NSUInteger, SlideTableParamStyle) {
    SlideTableParamHasPageAndRows = 1,// 参数中有页数、条数
    SlideTableParamOnlyHasRows,// 参数中只有条数，没有页数
    SlideTableParamDefault = SlideTableParamHasPageAndRows
    
};
typedef NS_ENUM(NSUInteger, NowIsRefreshType) {
    NoRefreshType = 1000,// 没有刷新
    HeaderIsRefreshType,// 头部刷新
    FooterIsRefreshType,// 尾部刷新
    
};
typedef NS_ENUM(NSUInteger, SlideTablePageType) {
    SlideTablePageAddType = 10,// 页数加1
    SlideTablePageReduceType,// 页数减1
    SlideTablePageZeroType// 页数归为初始值
    
};

@interface SlideTableViewModel : NSObject
@property(nonatomic,strong)RACCommand *requestCommand;// 请求数据
@property(nonatomic,strong)RACSubject *failureSubject;// 请求失败

// 数据源(多个tableView的总数组)
@property(nonatomic,strong)NSMutableArray *allArray;// 所有tableView数据数组
@property(nonatomic,strong)NSArray *messageArray;// 接收请求数据数组

@property(nonatomic,assign)NSInteger index;// 记录当前是哪一个tableView在请求数据
@property(nonatomic,copy)NSString *pathUrl;// 请求时地址

// 初始化方法
- (instancetype)initWithModelCLass:(Class)modelClass style:(SlideTableParamStyle)style;

@end
