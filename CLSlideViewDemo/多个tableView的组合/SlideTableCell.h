//
//  SlideTableCell.h
//  QiDongYinQing
//
//  Created by chenglei on 17/7/3.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideModel.h"
#import "Macro.h"
#import "CLViewModel.h"

@interface SlideTableCell : UITableViewCell
@property (nonatomic, strong) CLViewModel *viewModel;

@property(nonatomic,strong)SlideModel *model;
@property (nonatomic, copy) NSIndexPath *path;// section-tableView下标， row-cell下标

@end
