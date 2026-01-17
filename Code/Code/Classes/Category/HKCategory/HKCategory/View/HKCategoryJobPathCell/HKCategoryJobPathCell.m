//
//  HKCategoryJobPathCell.m
//  Code
//
//  Created by ivan on 2020/6/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryJobPathCell.h"
#import "UIView+SNFoundation.h"
#import "HKCategoryJobPathModel.h"

@interface HKCategoryJobPathCell()


@property (strong, nonatomic)  UIImageView *imageView;
/** 标题 */
@property (strong, nonatomic)  UILabel *titleLB;
/** 描述 */
@property (strong, nonatomic)  UILabel *descrLB;
/** 课数量 */
@property (strong, nonatomic)  UILabel *courseCountLB;

@end



@implementation HKCategoryJobPathCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.bgIV];
        [self.bgIV addSubview:self.imageView];
        [self.bgIV addSubview:self.titleLB];
        
        [self.bgIV addSubview:self.descrLB];
        [self.bgIV addSubview:self.courseCountLB];
        [self makeConstraints];
        [self hkDarkModel];
    }
    return self;
}


- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.descrLB.textColor = COLOR_7B8196_A8ABBE;
    self.courseCountLB.textColor = COLOR_A8ABBE_7B8196;
}


- (void)setLayerShadowColor {
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    [self addShadowWithColor:self shadowColor:[COLOR_000000 colorWithAlphaComponent:0.5] shadowOpacity:0.4 shadowRadius:10 shadowOffset:CGSizeMake(0,2)];
}



- (void)makeConstraints {
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIV).offset(PADDING_20);
        make.left.equalTo(self.bgIV).offset(IS_IPAD ?35 :PADDING_25);
        make.right.equalTo(self.imageView.mas_left).offset(-5.0);;
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB);
        make.right.equalTo(self.bgIV).offset(IS_IPAD ?-35 :-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.imageView.mas_left).offset(-10.0);
    }];
    
    [self.courseCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descrLB.mas_bottom).offset(10);
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.bgIV);
    }];
}




- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
//        UIImage *image = [UIImage hkdm_imageWithNameLight:@"bg_careerlist_v2_13" darkImageName:@"bg_careerlist_v2_13_dark"];
//        _bgIV.image = image;
    }
    return _bgIV;
}


- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 55/2.0;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"16" titleAligment:0];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _titleLB;
}



- (UILabel*)descrLB {
    if (!_descrLB) {
        _descrLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:0];
        _descrLB.numberOfLines = 2;
        _descrLB.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _descrLB;
}



- (UILabel*)courseCountLB {
    if (!_courseCountLB) {
        _courseCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:0];
    }
    return _courseCountLB;
}



- (void)setModel:(HKCategoryJobPathModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLB.text = isEmpty(model.title)? nil :model.title;
    
    self.descrLB.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:isEmpty(model.descr)?@" ": model.descr LineSpace:5];
    
    NSString *text = [NSString stringWithFormat:@"%d人已学   %ld个章节   %ld节课",[model.study_number intValue],model.chapter_number,model.course_number];
    //NSString *text = [NSString stringWithFormat:@"%ld个章节   %ld节课",model.chapter_number,model.course_number];
    self.courseCountLB.text = text;
}


@end

