//
//  HKSoftwareCourseCell.m
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareCourseCell.h"
#import "HKCoverBaseIV.h"
#import "HKCustomMarginLabel.h"
#import "HKCoureFinishView.h"

@interface HKSoftwareCourseCell()

@property (strong, nonatomic)  HKCoverBaseIV *imageView;

@property (strong, nonatomic)  UILabel *titleLB;
/** 进度 */
@property (strong, nonatomic)  UILabel *progressLB;


@end



@implementation HKSoftwareCourseCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.progressLB];
        [self makeConstraints];

    }
    return self;
}


- (void)makeConstraints {
        
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-PADDING_10);
        make.height.equalTo(@60);
    }];
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(self.imageView);
    }];
}



- (HKCoverBaseIV*)imageView {
    if(!_imageView){
        _imageView = [HKCoverBaseIV new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 3;
        _imageView.hiddenText = NO;
        _imageView.textLBHeight = 18;
        _imageView.textLB.font = HK_FONT_SYSTEM(9);
        _imageView.textLB.textInsets = UIEdgeInsetsMake(2, 4, 2, 4);
    }
    return _imageView;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_0A1A39 titleFont:@"11" titleAligment:0];
        _titleLB.numberOfLines = 1;
        _titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
    }
    return _titleLB;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:imageName(HK_Placeholder)];
    self.imageView.icon_show = model.icon_show;
    self.imageView.textLB.text = isEmpty(model.title)?nil :model.study_progress;
    self.titleLB.text = model.title;
}



@end








