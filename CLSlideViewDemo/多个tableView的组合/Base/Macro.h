//
//  Macro.h
//  CLSlideViewDemo
//
//  Created by 程磊 on 2017/11/27.
//  Copyright © 2017年 程磊. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#pragma mark ---- 第三方类
// RAC
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
// MJ
#import <MJRefresh/MJRefresh.h>
#import "MJExtension.h"

// SDWebimage
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
//
#import "HttpManger.h"
#import "RequestModel.h"
#import "UIView+Additions.h"
#import "CreatControls.h"


// RAC中的weakself、strongself
#define racWeak(object)   @weakify(object);
#define racStrong(object)  @strongify(object);


#pragma mark 字符串和数组异常判断
#define IsStrEmpty(_ref)                   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref)isEqualToString:@""]) || ([(_ref)isEqualToString:@"{}"]))


// CLLog输出不同的打印信息
#ifdef DEBUG
#define stringDate ({\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];\
[dateFormatter stringFromDate:[NSDate date]];\
})
#define DString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define CLLog(...) printf("[时间:%s]\n[文件名:%s]\n[函数名:%s]\n[行号:%d]\n%s\n\n", [stringDate UTF8String] ,[DString UTF8String] ,__FUNCTION__,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define CLLog(...)
#endif


#define k5_6_6P_X(small, medium, big, x)  (iPhoneX ? x : k5_6_6P(small, medium, big))
// 5、6、6P三个机型分别取值
#define k5_6_6P(small, medium, big)  (kScreenWidth == 320 ? small : (kScreenWidth == 375 ? medium : big))
// 字体大小
#define kSystemFontOfSize(value)  [UIFont systemFontOfSize:value]
// 拼接字符串
#define kStringWithFormat(str1, str2) [NSString stringWithFormat:@"%@%@", str1, str2]
#define kString(str) [NSString stringWithFormat:@"%@", str]


// 16进制颜色
#define UIColorRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
// RGB颜色
#define RGBA(r,g,b,a) ([UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)])


// 项目主打色（青绿色）
#define cMainGreenColor     UIColorRGB(0x24b6b4,1.0f)
// 主要的红色
#define cRedColor UIColorRGB(0xef3a1b,1.0f)
// 绿色
#define cGreenColor [UIColor greenColor]
// 白色
#define cWhiteColor [UIColor whiteColor]
// 透明
#define cClearColor [UIColor clearColor]
// 黑色
#define cBlackColor [UIColor blackColor]
// 大标题的黑色，深黑
#define cHeadTitleBlackColor UIColorRGB(0x000000, 1.0f)
// 普通标题黑色
#define cGeneralTitleBlackColor UIColorRGB(0x333333, 1.0f)
#define cColor_444444   UIColorRGB(0x444444, 1.0f)
#define cColor_555555 UIColorRGB(0x555555, 1.0f)
// 黑灰色_666666
#define cColor_666666 UIColorRGB(0x666666, 1.0f)
// 黑灰色_777777
#define cColor_777777 UIColorRGB(0x777777, 1.0f)
// 黑灰色_888888
#define cColor_888888 UIColorRGB(0x888888, 1.0f)
// 主要的灰色
#define cMainGrayColor UIColorRGB(0x999999,1.0f)
// 文字浅灰色
#define cLightTitleGrayColor UIColorRGB(0xcccccc, 1.0f)
// 浅灰色
#define cLightGrayColor UIColorRGB(0xeeeeee, 1.0f)
// cell被点击背景色
#define cSeleteCellBackColor RGB(217, 217, 217, 1.f)
// 背景淡灰色
#define cBackGroupColor    UIColorRGB(0xf8f8f8, 1.0f)
// 灰色线颜色
#define cLineGrayColor    UIColorRGB(0xefefef, 1.0f)
// 标的标签灰色
#define cBiaoqianGrayColor    UIColorRGB(0x6a797e, 1.0f)
// 主要的青色
#define cMainCyanColor RGBA(11, 180, 181, 1.f)
// 浅青色
#define cLightCyanColor    UIColorRGB(0x08acc7, 1.0f)
// 深青色
#define cDeepCyanColor    UIColorRGB(0x216ea4, 1.0f)
// 浅绿色
#define cLightGreenColor RGB(80, 210, 194, 1.f)

// 深灰蓝色
#define cDeepGrayBlueColor    UIColorRGB(0x2f5ea4, 1.0f)
// 橙红色
#define cOrangeRedColor          UIColorRGB(0xff6600, 1.0f)
// 橙色
#define cOrangeColor          UIColorRGB(0xff9933, 1.0f)


#define cBlueColor            UIColorRGB(0x2ea5e5, 1.0f) // 靛蓝色

#endif /* Macro_h */
