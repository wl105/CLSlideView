//
//  SlideTableView.m
//  QiDongYinQing
//
//  Created by chenglei on 17/7/3.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "SlideTableView.h"
#import "SlideTableCell.h"


static const NSInteger tableViewTag = 100;
static const NSInteger spaceNum = 10;// 按钮间距

@interface SlideTableView ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)SlideTableViewModel *viewModel;

@property(nonatomic,strong)UIScrollView *backView;// tableView顶部按钮存放处
@property(nonatomic,strong)UIView *lineView;// button下的横线
@property(nonatomic,strong)UIScrollView *scrollView;// 存放tableView
//@property(nonatomic,strong)SearchFailureView *failureView;// 没有数据

@property(nonatomic,strong)NSMutableArray *btnArray;// 按钮数组
@property(nonatomic,strong)NSMutableArray *tableArray;// tableView数组
@property(nonatomic,strong)NSMutableArray *btnWidthArray;// 按钮宽度数组
@property(nonatomic,assign)NSInteger allBtnWidth;// 所有按钮总宽度

@property(nonatomic,assign)NowIsRefreshType refreshType;// 当前头部刷新还是尾部刷新
@property(nonatomic,assign)NSInteger pageNum;// 第一页的下标值
@end
@implementation SlideTableView{
    Class _cellClass;
    Class _modelClass;
}

#pragma mark ---- System
+ (void)initialize{
    
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SlideTableViewDelegate>)delegate titles:(NSArray *)titles pathUrl:(NSString *)pathUrl paramentArry:(NSArray *)paramentArry cellClass:(Class)cellClass model:(Class)model block:(SetSlideTabBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置默认值
        [self settingDefaultValues];
        
        // 让外部改变值
        if (block) {
            block(self);
        }
        
        // 赋值
        self.delegate = delegate;
        self.pathUrl = pathUrl;
        self.titles = [titles copy];
        self.paramentArry = [paramentArry mutableCopy];
        _cellClass = cellClass;
        _modelClass = model;
        
        
        // 计算按钮总宽度
        [self calculateAllBtnWidth];
        
        // 监听数据变化并刷新页面
        [self setupRACObserve];
        
        // 创建header
        [self addSubview:self.backView];
        // 创建tableView
        [self addSubview:self.scrollView];
        
    }
    return self;
}

- (void)settingDefaultValues
{
    self.paramStyle = SlideTableParamDefault;
    self.isHeadRefres = YES;
    self.isFootRefres = NO;
    
    
    self.rowHeight = 120;
    self.headHeight = 40;
    self.showTableIndex = 0;
    self.titleColor = cMainGrayColor;
    self.titleSeteColor = cGeneralTitleBlackColor;
    self.headBackColor = cWhiteColor;
    self.font = kSystemFontOfSize(14.f);
    self.lineColor = UIColorRGB(0x0068b7, 1.f);
    
}

- (void)layoutSubviews
{
    if (self.showTableIndex != 0) {
        UIButton *btn = self.btnArray[self.showTableIndex];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refreshControlsWithBtn:btn];
        });
    }
}

- (void)setupRACObserve
{
    racWeak(self);
    // 数据更新
    [RACObserve(self.viewModel, messageArray) subscribeNext:^(id x) {
        racStrong(self);
        if (x == nil) {
            return;
        }
        
        UITableView *tableView = self.tableArray[self.viewModel.index];

        if (self.refreshType == FooterIsRefreshType) {
            if (self.paramStyle == SlideTableParamOnlyHasRows) {
                [self.viewModel.allArray replaceObjectAtIndex:self.viewModel.index withObject:x];
            }
            if (self.paramStyle == SlideTableParamHasPageAndRows) {
                NSMutableArray *dataArr = [self.viewModel.allArray[self.viewModel.index] mutableCopy];
                [dataArr addObjectsFromArray:x];
                [self.viewModel.allArray replaceObjectAtIndex:self.viewModel.index withObject:dataArr];
            }
            
            if ([self.delegate respondsToSelector:@selector(footerWithRefreshWithTableView:x:)]) {
                // 尾部刷新时，将请求结束数据个数返回
                [self.delegate footerWithRefreshWithTableView:tableView x:@(self.viewModel.messageArray.count)];
            }
            [tableView.mj_footer endRefreshing];

        }else if(self.refreshType == HeaderIsRefreshType){
            [self.viewModel.allArray replaceObjectAtIndex:self.viewModel.index withObject:x];

            [tableView.mj_header endRefreshing];

        }
        // 刷新UI
        [tableView reloadData];
        
        // 当前显示页面数据为空时
        NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
        if ([self.viewModel.allArray[index] count] == 0) {
            UITableView *tableView_1 = self.tableArray[index];

            
        }else if ([self.viewModel.allArray[index] count] != 0){

        }
        
    }];
    
    // 请求失败
    [[self.viewModel.failureSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id x) {
        racStrong(self)
        
        UITableView *tableView = self.tableArray[self.viewModel.index];
        if (self.refreshType == HeaderIsRefreshType) {
            [tableView.mj_header endRefreshing];
            
            // 头部刷新失败，参数page 归为初始值
            [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageZeroType)];
        }
        if (self.refreshType == HeaderIsRefreshType) {
            [tableView.mj_footer endRefreshing];
            
            // 尾部刷新失败，参数page -1
            [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageReduceType)];
        }

    }];
    
    [RACObserve(self, paramentArry) subscribeNext:^(id x) {
        racStrong(self)
        if (!x) {
            return;
        }
        
        // 记录page下标初始值
        if (self.paramStyle == SlideTableParamHasPageAndRows && self.paramentArry.count > 0) {
            NSDictionary *dic = self.paramentArry[0];
            if ([dic.allKeys containsObject:self.pageStr]) {
                self.pageNum = [dic[self.pageStr] integerValue];
            }
        }
 
    }];
}

- (void)calculateAllBtnWidth
{
    for (int i = 0; i < self.btnWidthArray.count; i++) {
        self.allBtnWidth += [self.btnWidthArray[i] integerValue];
    }
    
}

/**
 根据刷新情况改变参数中的page页数值

 @param index 刷新tableView的tag
 @param type 刷新情况
 */
- (void)changePageNumWithIndex:(NSInteger)index type:(SlideTablePageType)type
{
    if (self.paramStyle != SlideTableParamHasPageAndRows) {
        return;
    }
    if (self.paramentArry.count <= index) {
        return;
    }
    NSMutableDictionary *dic = [self.paramentArry[index] mutableCopy];
    if (![dic.allKeys containsObject:self.pageStr]) {
        return;
    }
    
    NSInteger page = [dic[self.pageStr] integerValue];
    if (type == SlideTablePageAddType) {
        page ++;
    }
    if (type == SlideTablePageReduceType) {
        page --;
    }
    if (type == SlideTablePageZeroType) {
        page = self.pageNum;
    }
    // 改变字典的page值
    [dic setValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:self.pageStr];
    // 改变整个参数数组
    [self.paramentArry replaceObjectAtIndex:index withObject:dic];
    
}

- (void)reloadAllTableView
{    
    // 串行异步线程
    dispatch_queue_t queue = dispatch_queue_create("com.serial.com",  DISPATCH_QUEUE_SERIAL);
    // 先刷新显示页面的tableView数据
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UITableView *tableView = self.tableArray[index];
    dispatch_async(queue, ^{
        [self tableViewHeaderBeginRefreshing:tableView];
    });
    
    for (int i = 0; i < self.tableArray.count; i ++) {
        if (i == index) {
            break;
        }
        tableView = self.tableArray[i];
        dispatch_async(queue, ^{
            // 延时请求
            [NSThread sleepForTimeInterval:0.5f];

            [self tableViewHeaderBeginRefreshing:tableView];
        });

    }
}

- (void)tableViewHeaderBeginRefreshing:(UITableView *)tableView
{
    // 请求数据
    self.viewModel.index = tableView.tag - tableViewTag;
    self.refreshType = HeaderIsRefreshType;
    
    self.viewModel.pathUrl = kStringWithFormat(self.pathUrl, self.urlJoinArray_head[self.viewModel.index]);
    if (self.paramStyle == SlideTableParamOnlyHasRows) {
        [self.viewModel.requestCommand execute:nil];
        
    }else if (self.paramStyle == SlideTableParamHasPageAndRows){
        // 头部刷新，参数page 归为初始值
        [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageZeroType)];
        [self.viewModel.requestCommand execute:self.paramentArry[self.viewModel.index]];
        
    }

}

#pragma mark ---- UITableViewDelegate、UITableViewDataSource
// 分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.allArray[tableView.tag - tableViewTag] count];
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifierStr = [NSString stringWithFormat:@"identifierStr_%ld_%ld", (long)indexPath.section, indexPath.row];
    [tableView registerClass:_cellClass forCellReuseIdentifier:identifierStr];
    
    SlideTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr forIndexPath:indexPath];
    return cell;
}


// cell赋值方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SlideTableCell *myCell = (SlideTableCell *)cell;
    
    myCell.model = self.viewModel.allArray[tableView.tag - tableViewTag][indexPath.row];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:(tableView.tag - tableViewTag)];
    myCell.path = path;
}

// 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:model:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath model:self.viewModel.allArray[tableView.tag - tableViewTag][indexPath.row]];
    }
}

#pragma mark ---- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 结束减速
    if (scrollView == self.scrollView) {
        NSInteger offset = scrollView.contentOffset.x / scrollView.width;
        [self refreshControlsWithBtn:self.btnArray[offset]];
    }
    
}

// scrollView结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 结束拖拽时，记录tableView的contentOffset
    if (scrollView != self.scrollView && scrollView != self.backView) {
        if ([self.delegate respondsToSelector:@selector(endDraggingWithContentoffsetY:)]) {
            [self.delegate endDraggingWithContentoffsetY:scrollView.contentOffset.y];
        }
    }
    
}

// 点击按钮或者划动底层scrollView时
- (void)refreshControlsWithBtn:(UIButton *)btn
{
    // 如果当前tableView没有数据则头部刷新
    UITableView *tableView = self.tableArray[btn.tag];
    // 如果header一直在刷新则先结束刷新
    if (tableView.mj_header.isRefreshing) {
        [tableView.mj_header endRefreshing];
    }
    
    // tableview上没有cell
    if (tableView.contentSize.height == 0) {
        if (tableView.mj_header == nil) {
            CLLog(@"=================");
        }
        [tableView.mj_header beginRefreshing];
        
    }
    
    // scrollView滑动、横线滑动
    [UIView animateWithDuration:0.5f animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width * (btn.tag), 0);
        
        self.lineView.width = [self getStrWidthWithStr:self.titles[btn.tag] andFont:self.font.pointSize];
        self.lineView.centerX = btn.centerX;

    }];
    
    // 点击button或滑动scrollView，切换文字、背景的颜色
    btn.selected = YES;
    [btn setTitleColor:self.titleSeteColor forState:(UIControlStateNormal)];
    for (UIButton *button in self.btnArray) {
        if (button != btn) {
            button.selected = NO;
            [button setTitleColor:self.titleColor forState:(UIControlStateNormal)];
        }
    }
    
    // 被点击的按钮尽量处在中间
    [UIView animateWithDuration:0.5f animations:^{
        if (self.allBtnWidth > self.backView.width) {
            
            if (btn.centerX > self.backView.width / 2) {
                if (self.allBtnWidth - btn.centerX > self.backView.width / 2) {
                    self.backView.contentOffset = CGPointMake(btn.centerX - self.backView.width / 2, 0);
                    
                }else{
                    self.backView.contentOffset = CGPointMake((self.allBtnWidth - self.backView.width), 0);
                }
                
            }else{
                self.backView.contentOffset = CGPointZero;
                
            }
        }

    }];
    
}


#pragma mark ---- Setter
- (void)setIsHeadRefres:(BOOL)isHeadRefres
{
    _isHeadRefres = isHeadRefres;
    
    // 取两数组个数少的，避免下标越界
    NSInteger count = MIN(self.titles.count, MAX(self.paramentArry.count, _urlJoinArray_head.count));
    
    for (int i = 0; i < count; i ++) {
        UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:i + tableViewTag];
        
        if (isHeadRefres == NO) {
            if (tableView.mj_header != nil) {
                tableView.mj_header = nil;
            }
        }else{
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                // 反馈的代理
                if ([self.delegate respondsToSelector:@selector(headerWithRefreshWithTableView:)]) {
                    [self.delegate headerWithRefreshWithTableView:tableView];
                }
                // 请求数据
                self.viewModel.index = tableView.tag - tableViewTag;
                self.refreshType = HeaderIsRefreshType;
                
                self.viewModel.pathUrl = kStringWithFormat(self.pathUrl, self.urlJoinArray_head[self.viewModel.index]);
                if (self.paramStyle == SlideTableParamOnlyHasRows) {
                    [self.viewModel.requestCommand execute:nil];
                    
                }else if (self.paramStyle == SlideTableParamHasPageAndRows){
                    // 头部刷新，参数page 归为初始值
                    [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageZeroType)];

//                    self.viewModel.pathUrl = self.pathUrl;
                    [self.viewModel.requestCommand execute:self.paramentArry[self.viewModel.index]];
                    
                }
                
            }];
            // 默认刷新第一个tableView数据
            if (i == 0) {
                [tableView.mj_header beginRefreshing];
                
            }

        }
    }

}

- (void)setIsFootRefres:(BOOL)isFootRefres
{
    _isFootRefres = isFootRefres;
    
    // 取两数组个数少的，避免下标越界
    NSInteger count = MIN(self.titles.count, MAX(self.paramentArry.count, _urlJoinArray_head.count));
    for (int i = 0; i < count; i ++) {
        UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:i + tableViewTag];
        
        if (isFootRefres == YES) {
            if (tableView.mj_footer == nil) {
                tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                    
                    self.viewModel.index = tableView.tag - tableViewTag;
                    self.refreshType = FooterIsRefreshType;
                    
                    self.viewModel.pathUrl = kStringWithFormat(self.pathUrl, self.urlJoinArray_Foot[self.viewModel.index]);
                    if (self.paramStyle == SlideTableParamOnlyHasRows) {
                        [self.viewModel.requestCommand execute:nil];
                        
                    }else if (self.paramStyle == SlideTableParamHasPageAndRows){
                        // 尾部刷新，参数page +1
                        [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageAddType)];
                        
//                        self.viewModel.pathUrl = self.pathUrl;
                        [self.viewModel.requestCommand execute:self.paramentArry[self.viewModel.index]];
                        
                    }
                    
                }];

            }
        }else{
            if (tableView.mj_footer != nil) {
                tableView.mj_footer = nil;
            }
        }
    }

}

/**
 计算一行文字宽度
 */
- (CGFloat)getStrWidthWithStr:(NSString *)str andFont:(CGFloat)fontFloat
{
    UIFont *font = [UIFont systemFontOfSize:fontFloat];
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return rect.size.width;
}

#pragma mark ---- Lazyload
- (UIView *)backView
{
    if (!_backView) {
        CGRect rect = CGRectMake(0, 0, self.width, self.headHeight);
        _backView = [[UIScrollView alloc]initWithFrame:rect];
        _backView.backgroundColor = cBackGroupColor;
        _backView.showsHorizontalScrollIndicator = NO;
        _backView.showsVerticalScrollIndicator = NO;
        
        // 根据按钮数量及文字长度设置cgrect
        int width_x = 0;
        for (int i = 0; i < self.titles.count; i ++) {
            CGRect rect;
            
            if (self.allBtnWidth >= _backView.width) {
                rect = CGRectMake(width_x, 0, [self.btnWidthArray[i] intValue], _backView.height);
                width_x += [self.btnWidthArray[i] intValue];

                _backView.contentSize = CGSizeMake(self.allBtnWidth , 0);
            }else{
                int num = _backView.width - self.allBtnWidth;
                rect = CGRectMake(width_x, 0, [self.btnWidthArray[i] intValue] + num/self.titles.count, _backView.height -1);
                width_x += rect.size.width;
                
                _backView.contentSize = CGSizeMake(_backView.width , 0);
            }
            // 创建按钮
            UIButton *btn = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
                controls.button.rect(rect).backColor(self.headBackColor).title(self.titles[i]).titleColor(self.titleColor).tag(i).setFont(self.font);
            }];
            [_backView addSubview:btn];
            
            // 默认第一个button是点击状态
            if (i == 0) {
                btn.selected = YES;
                [btn setTitleColor:self.titleSeteColor forState:(UIControlStateNormal)];

            }
            // 存储button数组
            [self.btnArray addObject:btn];
            
            racWeak(self)
            [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                racStrong(self)
                
                [self refreshControlsWithBtn:btn];
            }];
        }
        
        // 创建横线
        [_backView addSubview:self.lineView];

    }
    return _backView;
}
- (UIView *)lineView
{
    if (!_lineView) {
        int width = [self getStrWidthWithStr:self.titles[0] andFont:self.font.pointSize];
        CGRect rect = CGRectMake(0, self.backView.height - 2, width, 2);
        _lineView = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.view.rect(rect).backColor(self.lineColor);
        }];
        UIButton *btn = self.btnArray[0];
        _lineView.centerX = btn.centerX;
    }
    return _lineView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0, self.backView.max_y, self.width, self.height - self.backView.height}];
        _scrollView.contentSize = CGSizeMake(self.width * self.titles.count, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self layoutTableView];
    }
    return _scrollView;
}

- (void)layoutTableView
{
    for (int i = 0; i < self.titles.count; i ++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:(CGRect){i * self.width, 0, _scrollView.width, _scrollView.height} style:(UITableViewStylePlain)];
        tableView.backgroundColor = cBackGroupColor;
        tableView.tag = i + tableViewTag;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = self.rowHeight;
        tableView.separatorStyle = NO; // 隐藏tableView分割线
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 反馈的代理
            if ([self.delegate respondsToSelector:@selector(headerWithRefreshWithTableView:)]) {
                [self.delegate headerWithRefreshWithTableView:tableView];
            }
            // 请求数据
            self.viewModel.index = tableView.tag - tableViewTag;
            self.refreshType = HeaderIsRefreshType;
            
            self.viewModel.pathUrl = kStringWithFormat(self.pathUrl, self.urlJoinArray_head[self.viewModel.index]);
            if (self.paramStyle == SlideTableParamOnlyHasRows) {
                [self.viewModel.requestCommand execute:nil];
                
            }else if (self.paramStyle == SlideTableParamHasPageAndRows){
                // 头部刷新，参数page 归为初始值
                [self changePageNumWithIndex:self.viewModel.index type:(SlideTablePageZeroType)];
                [self.viewModel.requestCommand execute:self.paramentArry[self.viewModel.index]];
                
            }
            
        }];
        // 默认刷新第一个tableView数据
        if (i == 0) {
            [tableView.mj_header beginRefreshing];
        }
        
        [_scrollView addSubview:tableView];
        [self.tableArray addObject:tableView];
    }
    
}


- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _btnArray;
}
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _tableArray;
}

- (NSMutableArray *)btnWidthArray
{
    if (!_btnWidthArray) {
        _btnWidthArray = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < self.titles.count; i ++) {
            NSInteger width = [self getStrWidthWithStr:self.titles[i] andFont:self.font.pointSize] + spaceNum*2;
            [_btnWidthArray addObject:@(width)];
            
        }
    }
    return _btnWidthArray;
}

- (SlideTableViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SlideTableViewModel alloc] initWithModelCLass:_modelClass style:self.paramStyle];
    }
    return _viewModel;
}
- (NSMutableArray *)urlJoinArray_head
{
    if (!_urlJoinArray_head) {
        _urlJoinArray_head = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < self.titles.count; i ++) {
            [_urlJoinArray_head addObject:@""];
        }
    }
    return _urlJoinArray_head;
}
- (NSMutableArray *)urlJoinArray_Foot
{
    if (!_urlJoinArray_Foot) {
        _urlJoinArray_Foot = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < self.titles.count; i ++) {
            [_urlJoinArray_Foot addObject:@""];
        }
    }
    return _urlJoinArray_Foot;
}

@end
