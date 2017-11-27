//
//  CreatControls.m
//  编程测试_demo
//
//  Created by chenglei on 17/5/10.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "CreatControls.h"
#import "Macro.h"


@interface CreatControls ()<CreatControlsProtocol, CommonProtocol, AttributeProtocol >
@property(nonatomic, strong)UIView *clView;

@end
@implementation CreatControls

+ (id)creatControls:(CreatBlock)block
{
    if (block) {
        CreatControls<CreatControlsProtocol> *controls = [CreatControls<CreatControlsProtocol> new];
        block(controls);
        
        return controls.clView;
    }
    return nil;
}

- (CreatControls<CommonProtocol,AttributeProtocol> *)view
{
    // 创建UIView
    self.clView = [UIView new];
    self.clView.backgroundColor = [UIColor whiteColor];

    return self;
}
- (CreatControls<CommonProtocol,AttributeProtocol> *)label
{
    // 创建UILable
    self.clView = [UILabel new];
    self.clView.layer.masksToBounds = YES;// 解决汉字渲染问题
    self.clView.backgroundColor = [UIColor whiteColor];

    return self;
}
- (CreatControls<CommonProtocol,AttributeProtocol> *)textfield
{
    // 创建UITextfield
    UITextField *tf = [UITextField new];
    tf.layer.masksToBounds = YES;
    self.clView = tf;
    self.clView.backgroundColor = [UIColor whiteColor];

    return self;
}
- (CreatControls<CommonProtocol,AttributeProtocol> *)button
{
    // 创建UIButton
    UIButton *btn = [UIButton new];
    btn.titleLabel.layer.masksToBounds = YES;
    self.clView = btn;
    self.clView.backgroundColor = [UIColor whiteColor];

    return self;
}
- (CreatControls<CommonProtocol,AttributeProtocol> *)imgView
{
    // 创建imageView
    UIImageView *imgView = [UIImageView new];
    self.clView = imgView;
    self.clView.backgroundColor = [UIColor whiteColor];

    return self;
}

- (BackColorBlock)backColor
{
    return ^(UIColor *color){
        [self.clView setBackgroundColor:color];
        if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn.titleLabel setBackgroundColor:color];// button的titlelabel背景色与button一致，解决图形渲染问题
        }
        if ([self.clView isKindOfClass:[UITextField class]]) {
//            UITextField *tf = (UITextField *)self.clView;
        }
        return self;
    };
}
- (FrameBlock)rect
{
    return ^(CGRect frame){
        [self.clView setFrame:frame];

        return self;
    };
}
- (TagBlock)tag
{
    return ^(NSInteger tag){
        [self.clView setTag:tag];
        
        return self;
    };

}
- (CornerRadiusBlock)cornerRadius
{
    return ^id(CGFloat radius){
        self.clView.layer.cornerRadius = radius;
        
        return self;
    };
}
- (BorderColorBlock)borderColor
{
    return ^id(CGColorRef colorRef){
        self.clView.layer.borderColor = colorRef;
        
        return self;
    };
}
- (BorderWidthBlock)borderWidth
{
    return ^id(CGFloat width){
        self.clView.layer.borderWidth = width;
        
        return self;
    };
}
- (ImageStrBlock)imgStr
{
    return ^id(NSString *imgStr){
        if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn setImage:[UIImage imageNamed:imgStr] forState:(UIControlStateNormal)];
        }
        if ([self.clView isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *)self.clView;
            [imgView setImage:[UIImage imageNamed:imgStr]];
        }
        
        return self;
    };
}
- (BackImageStrBlock)backImgStr
{
    return ^id(NSString *imgStr){
        if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:(UIControlStateNormal)];
        }
        
        return self;
    };
}


- (TitleBlock)title
{
    return ^(NSString *title){
        if ([self.clView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self.clView;
            [label setText:title];
        }else if ([self.clView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)self.clView;
            [tf setText:title];
        }else if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn setTitle:title forState:(UIControlStateNormal)];
        }

            return self;
    };
}
-(TextColorBlock)titleColor
{
    return ^(UIColor *titleColor){
        if ([self.clView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self.clView;
            [label setTextColor:titleColor];
        }else if ([self.clView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)self.clView;
            [tf setTextColor:titleColor];
        }else if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn setTitleColor:titleColor forState:(UIControlStateNormal)];
        }

        return self;
    };
}
- (PlaceholderBlock)placeholder
{
    return ^(NSString *str){
        if ([self.clView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)self.clView;
            [tf setPlaceholder:str];
        }
        
        return self;
    };
}
- (FontBlock)setFont
{
    return ^(UIFont *font){
        if ([self.clView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self.clView;
            [label setFont:font];
        }else if ([self.clView isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)self.clView;
            [tf setFont:font];
        }else if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            [btn.titleLabel setFont:font];
        }

        return self;
    };
}

- (NumpageBlock)numpage
{
    return ^(NSInteger num){
        if ([self.clView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self.clView;
            [label setNumberOfLines:num];
        }
        
        return self;
    };
}
- (TextMinScaleFactor)minScale
{
    return ^(CGFloat minScale){
        if ([self.clView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self.clView;
            if (label.numberOfLines != 1) {
                return self;
            }
            label.minimumScaleFactor = minScale;
            label.adjustsFontSizeToFitWidth = true;
            
        }else if ([self.clView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)self.clView;
            if (btn.titleLabel.numberOfLines != 1) {
                return self;
            }
            btn.titleLabel.minimumScaleFactor = minScale;
            btn.titleLabel.adjustsFontSizeToFitWidth = true;
        }
        
        return self;
    };
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)left_alignment
{
    [self setAlignment:NSTextAlignmentLeft];
    
    return self;
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)middle_alignment
{
    [self setAlignment:NSTextAlignmentCenter];
    
    return self;
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)right_alignment
{
    [self setAlignment:NSTextAlignmentRight];
    
    return self;
}

- (CreatControls<AttributeProtocol,CommonProtocol> *)bottom_line
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    [self setLineStyleWith:attribtDic];
    
    return self;
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)middle_line
{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    [self setLineStyleWith:attribtDic];
    
    return self;
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)grayline_top
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.clView.width, 1)];
    lineView.backgroundColor = cLineGrayColor;
    [self.clView addSubview:lineView];
    
    return self;
}
- (CreatControls<AttributeProtocol,CommonProtocol> *)grayline_bottom
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.clView.width, 1)];
    lineView.backgroundColor = cLineGrayColor;
    lineView.max_y = self.clView.height + 0.5;
    [self.clView addSubview:lineView];

    return self;
}
// 设置划线，传入参数
- (void)setLineStyleWith:(NSDictionary *)attribtDic
{
    if ([self.clView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self.clView;
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:label.text attributes:attribtDic];
        label.attributedText = attribtStr;
    }else if ([self.clView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self.clView;
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text attributes:attribtDic];
        btn.titleLabel.attributedText = attribtStr;
    }
}

// 传入字体alignment
- (void)setAlignment:(NSTextAlignment)alignment
{
    if ([self.clView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self.clView;
        [label setTextAlignment:alignment];
    }else if ([self.clView isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)self.clView;
        [tf setTextAlignment:alignment];
    }else if ([self.clView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self.clView;
        [btn.titleLabel setTextAlignment:alignment];
    }

}


@end
