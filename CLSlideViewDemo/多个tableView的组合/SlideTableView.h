//
//  SlideTableView.h
//  QiDongYinQing
//
//  Created by chenglei on 17/7/3.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideModel.h"
#import "SlideTableViewModel.h"
#import "Macro.h"


@protocol SlideTableViewDelegate <NSObject>
@required
/**
 点击cell的代理

 @param tableView tableView
 @param indexPath indexPath
 @param model 值
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath model:(SlideModel *)model;

@optional
/**
 tableView的头部刷新

 @param tableView tableView
 */
- (void)headerWithRefreshWithTableView:(UITableView *)tableView;
/**
 tableView的尾部刷新
 
 @param tableView tableView
 @param x value
 */
- (void)footerWithRefreshWithTableView:(UITableView *)tableView x:(id)x;
/**
 tableView结束拖拽时

 @param offsetY ContentoffsetY
 */
- (void)endDraggingWithContentoffsetY:(NSInteger)offsetY;
@end

@interface SlideTableView : UIView

typedef void(^SetSlideTabBlock)(SlideTableView *slideView);
@property(nonatomic,weak)id<SlideTableViewDelegate> delegate;// 代理

#pragma mark ---- 自定义属性
@property(nonatomic,copy)NSArray *titles;// 文字数组
@property(nonatomic,copy)NSString *pathUrl;// tableView的URL
@property(nonatomic,strong)NSMutableArray *urlJoinArray_head;// URL需要拼接的值（头部）
@property(nonatomic,strong)NSMutableArray *urlJoinArray_Foot;// URL需要拼接的值（尾部）
@property(nonatomic,strong)NSMutableArray *paramentArry;// 不同tableView需要参数的数组
@property(nonatomic,assign)SlideTableParamStyle paramStyle;// 参数类型，默认有页数
@property(nonatomic, copy)NSString *pageStr;// 代表页数的参数Str
@property(nonatomic, assign)NSInteger showTableIndex;// 展示哪一个tableView

@property(nonatomic,assign)BOOL isHeadRefres;// tableView是否添加头部刷新，默认是YES
@property(nonatomic,assign)BOOL isFootRefres;// tableView是否添加尾部刷新，默认是NO

@property(nonatomic,assign)NSInteger rowHeight;// cell高度
@property(nonatomic,assign)NSInteger headHeight;// 按钮区域高度
@property(nonatomic,strong)UIColor *titleColor;// 文字颜色
@property(nonatomic,strong)UIColor *titleSeteColor;// 文字被点击颜色
@property(nonatomic,strong)UIFont *font;// 字体样式
@property(nonatomic,strong)UIColor *headBackColor;// 按钮下面背景颜色
@property(nonatomic,strong)UIColor *lineColor;// 横线颜色

/**
 创建此View

 @param frame CGRect
 @param titles  头部可滑动的文字数组
 @param cellClass cell的类
 @param model model类
 @param pathUrl pathUrl
 @param paramentArry paramentArry
 @param block 在block里面设置slidetableview的属性
 @return View
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SlideTableViewDelegate>)delegate titles:(NSArray *)titles pathUrl:(NSString *)pathUrl paramentArry:(NSArray *)paramentArry cellClass:(Class)cellClass model:(Class)model block:(SetSlideTabBlock)block;

/**
 刷新所有的tableView
 */
- (void)reloadAllTableView;

@end
