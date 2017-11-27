/**
 ArticleListModel.h
 启动引擎
 
 Created by chenglei on 2017/07/21
 Copyright © 2017年 All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "SlideModel.h"
#import "AttachmentModel.h"

@interface ArticleListModel : SlideModel

@property(nonatomic,strong)AttachmentModel *attachment;

@property(nonatomic, copy)NSString *photoId;
@property(nonatomic, copy)NSString *bannerUrl;
@property(nonatomic, copy)NSString *creatorId;
@property(nonatomic, copy)NSString *bannerIsShow;
@property(nonatomic, copy)NSString *companyId;


@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *categoryName;
@property(nonatomic, copy)NSString *updaterId;
@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *categoryCode;


@property(nonatomic, copy)NSString *articleTitle;
@property(nonatomic, copy)NSString *updateDate;
@property(nonatomic, copy)NSString *articleCreateDateFmt;
@property(nonatomic, copy)NSString *articleAuthor;
@property(nonatomic, copy)NSString *articleDesc;


@end

