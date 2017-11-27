# CLSlideView
几部操作完成网易、凤凰今日头条等新闻页面

### 正文
原谅我小小的标题党一下，最终创建的UI效果如图，
展示的cell只有一种，适合文章之类的新闻展示，如果需要开发类似网易、凤凰新闻UII，请使用此控件封装`https://github.com/rayonCheng/CLSlidePageView_Simple`，自定义创建
![test](https://t101-6.yunpan.360.cn/s1/800-600.9990aa5a8687657ffc83097608b22b4b0fb54b2e_shbt_101_shbt6_t.3204a2.jpg?st=5QsGXXGc6WLSWl7bSv1l3w&e=1511884800&mt=png&ecstoken=2093072914.7.a0d58df6.2529400742.15117693882400668.1511769388)

- 头部区域会自动适配，逻辑与主流新闻APP相似，UI效果我会努力升级
- 下部的tableView能够上拉、下拉刷新，可配置

####使用说明
- 导入`多个tableView的组合`文件夹，在相应类`#import "SlideTableView.h" #import "Macro.h"`
```
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
```
