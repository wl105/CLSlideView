/**
 ArticleListCell.m
 启动引擎
 
 Created by chenglei on 2017/07/21
 Copyright © 2017年 All rights reserved.
 */

#import "ArticleListCell.h"
#import "ArticleListModel.h"
#import "Macro.h"


@interface ArticleListCell ()
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *imgView;// 图片
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *messageLb;
@property(nonatomic,strong)UILabel *authorLb;// 回答数
@property(nonatomic,strong)UILabel *timeLb;// 时间

@end
@implementation ArticleListCell

#pragma mark ---- System
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;// 点击cell无显示效果
        self.contentView.backgroundColor = cBackGroupColor;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.imgView];
    [self.backView addSubview:self.titleLb];
    [self.backView addSubview:self.messageLb];
    [self.backView addSubview:self.authorLb];
    [self.backView addSubview:self.timeLb];
    
}

- (void)setModel:(SlideModel *)model
{
    ArticleListModel *listModel = (ArticleListModel *)model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:listModel.attachment.fillFilePath] placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
    self.titleLb.text = listModel.articleTitle;
    self.messageLb.text = listModel.articleDesc;
    self.authorLb.text = IsStrEmpty(listModel.articleAuthor) ? @"企动引擎" : listModel.articleAuthor;
    self.timeLb.text = [[listModel.articleCreateDateFmt componentsSeparatedByString:@" "] firstObject];
    
    [self.authorLb sizeToFit];
    [self.timeLb sizeToFit];
    self.timeLb.x = self.authorLb.max_x + 10;
    
}


#pragma mark ---- Lazy
- (UIView *)backView
{
    if (!_backView) {
        CGRect rect = CGRectMake(0, 10, self.contentView.width, self.contentView.height - 10);
        _backView = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.view.rect(rect).backColor(cWhiteColor);
        }];
        
    }
    return _backView;
}
- (UIImageView *)imgView
{
    if (!_imgView) {
        CGRect rect = CGRectMake(0, 0, 120, 90);
        _imgView = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.imgView.rect(rect);
        }];
        _imgView.centerY = self.backView.height / 2;
        _imgView.max_x = self.backView.width - 15;
        
    }
    return _imgView;
}
- (UILabel *)titleLb
{
    if (!_titleLb) {
        CGRect rect = CGRectMake(15, 10, self.imgView.x - 20, 20);
        _titleLb = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.label.rect(rect).backColor(cWhiteColor).titleColor(cGeneralTitleBlackColor).setFont([UIFont boldSystemFontOfSize:14.0f]);
        }];
        _titleLb.numberOfLines = 1;
        
    }
    return _titleLb;
}
- (UILabel *)messageLb
{
    if (!_messageLb) {
        CGRect rect = CGRectMake(self.titleLb.x, self.titleLb.max_y + 3, self.titleLb.width, 40);
        _messageLb = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.label.rect(rect).backColor(cWhiteColor).titleColor(UIColorRGB(0x444444, 1.f)).setFont(kSystemFontOfSize(13.f));
        }];
        _messageLb.numberOfLines = 2;
        
    }
    return _messageLb;
}

- (UILabel *)authorLb
{
    if (!_authorLb) {
        CGRect rect = CGRectMake(self.titleLb.x, self.messageLb.max_y + 5, 0, 15);
        _authorLb = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.label.rect(rect).backColor(cWhiteColor).titleColor(cMainGrayColor).setFont(kSystemFontOfSize(12.f));
        }];
    }
    return _authorLb;
}
- (UILabel *)timeLb
{
    if (!_timeLb) {
        CGRect rect = CGRectMake(0, self.authorLb.y, 0, self.authorLb.height);
        _timeLb = [CreatControls creatControls:^(CreatControls<CreatControlsProtocol> *controls) {
            controls.label.rect(rect).backColor(cWhiteColor).titleColor(cMainGrayColor).setFont(kSystemFontOfSize(12.f));
        }];
    }
    return _timeLb;
}


@end

