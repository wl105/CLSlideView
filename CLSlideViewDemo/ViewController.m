//
//  ViewController.m
//  CLSlideViewDemo
//
//  Created by 程磊 on 2017/11/27.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import "ViewController.h"
#import "SlideTableView.h"
#import "Macro.h"
#import "ArticleListModel.h"
#import "ArticleListCell.h"


@interface ViewController ()<SlideTableViewDelegate>
@property(nonatomic,strong)SlideTableView *slideView;// 下方的滑动内容
@property(nonatomic,strong)NSMutableArray *titles;// tableView数量
@property(nonatomic,strong)NSMutableArray *paramArray;// 参数数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.slideView];
}

#pragma mark ---- SlideTableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath model:(SlideModel *)model
{
    CLLog(@"%@ ---- %@", tableView, model);
}


#pragma mark ---- Lazyload
- (SlideTableView *)slideView
{
    if (!_slideView) {
        // 文章的URL
        NSString *url = @"http://app.qdyq.com/appapi/article/articleList/1637";
        /**
         CLSlideView使用手册
         
         1、根据titles参数创建滑动页数量
         2、paramentArry是所有页面的URL参数
         3、创建cell类，需继承SlideTableCell类
         4、创建model类，需继承SlideModel类
         5、在block中设置'slideView.pageStr ='，让系统知道代表页数的参数名
         6、其余数据可随意设置，并在代理方法中获得点击事件
         
         */
        
        CGRect rect = CGRectMake(0, 30, self.view.width, self.view.height - 30);// 根据需求设置frame
        _slideView = [[SlideTableView alloc]initWithFrame:rect delegate:self titles:self.titles pathUrl:url paramentArry:self.paramArray cellClass:[ArticleListCell class] model:[ArticleListModel class] block:^(SlideTableView *slideView) {
            
            // 需要提前设置的参数放block里面
            slideView.rowHeight = 120;
            slideView.lineColor = cColor_666666;
            slideView.pageStr = @"page";
            slideView.paramStyle = SlideTableParamHasPageAndRows;
            slideView.showTableIndex = 0;
            
        }];
        
        _slideView.isFootRefres = YES;
        
    }
    return _slideView;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithObjects:@"记账报税", @"工商变更", @"进出口权",@"优惠政策补贴",@"企动创业课堂", nil];
    }
    return _titles;
}

- (NSMutableArray *)paramArray
{
    if (!_paramArray) {
        _paramArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *codes = @[@"jzbs", @"gsbg", @"jckq", @"yhzcbd", @"qdcykt"];
        
        [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 建造参数
            NSDictionary *dic = @{@"searchValue":@"", @"keyCode":@"", @"type":@"", @"categoryCode":codes[idx], @"rows":@"10", @"page":@"1" };
            [_paramArray addObject:dic];
        }];
    }
    return _paramArray;
}
@end
