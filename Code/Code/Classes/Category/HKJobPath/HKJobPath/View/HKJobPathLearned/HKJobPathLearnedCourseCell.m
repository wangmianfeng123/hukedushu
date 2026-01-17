//
//  HKJobPathLearnedCourseCell.m
//  Code
//
//  Created by Ivan li on 2019/6/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathLearnedCourseCell.h"
#import "HKCoverBaseIV.h"
#import "HKJobPathModel.h"
#import "HKCustomMarginLabel.h"

@interface HKJobPathLearnedCourseCell()

@property (strong, nonatomic)  HKCoverBaseIV *imageView;
/** 标题 */
@property (strong, nonatomic)  UILabel *titleLB;


@end



@implementation HKJobPathLearnedCourseCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLB];
        [self makeConstraints];
    }
    return self;
}


- (void)makeConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_10);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(PADDING_5);
    }];
}




- (HKCoverBaseIV*)imageView {
    if (!_imageView) {
        _imageView = [[HKCoverBaseIV alloc]init];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _imageView.textInsets = UIEdgeInsetsMake(2, 4, 2, 0);
        _imageView.textLBHeight = 18;
        _imageView.textFont = HK_FONT_SYSTEM(9);
    }
    return _imageView;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:textColor titleFont:@"11" titleAligment:0];
    }
    return _titleLB;
}



- (void)setModel:(HKJobPathModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    
    //self.imageView.courseCount = model.course_number;
    NSString *str = [NSString stringWithFormat:@"已学%ld节/共%ld节",(long)model.studied_total,(long)model.course_number];
    self.imageView.textLB.text = str;
    self.imageView.textLB.hidden = NO;
    
    self.titleLB.text = model.title;
}


@end
