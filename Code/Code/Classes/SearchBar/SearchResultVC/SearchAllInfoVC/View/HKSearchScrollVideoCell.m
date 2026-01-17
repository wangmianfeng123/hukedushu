//
//  HKSearchScrollVideoCell.m
//  Code
//
//  Created by Ivan li on 2018/3/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSearchScrollVideoCell.h"
#import "HKShadowImageView.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"


@interface HKSearchScrollVideoCell()

@property (strong, nonatomic)  UIImageView *imageView;

@property (strong, nonatomic)  UILabel *titleLB;
/** 课程数量 */
@property (strong, nonatomic)  HKCustomMarginLabel *countLB;


@end

@implementation HKSearchScrollVideoCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.countLB];
        
        //[self.contentView insertSubview:self.bgImageView belowSubview:self.imageView];
        [self makeConstraints];
    }
    return self;
}




- (void)makeConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-30);
        //make.height.equalTo(@85);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.left.right.equalTo(self.imageView);
    }];
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.bottom.right.equalTo(self.imageView);
    }];
    
    [self.countLB layoutIfNeeded];
    [self.countLB setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
}




- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_image_url]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLB.text = model.title;
    
    if (!isEmpty(model.video_total)) {
        self.countLB.text = [NSString stringWithFormat:@"共%@节",model.video_total];
        self.countLB.hidden = isEmpty(self.countLB.text);
    }
}




- (void)setDefaultImageWithName:(NSString*)name {
    self.imageView.image = imageName(name);
    self.bgImageView.hidden = YES;
}


- (UIImageView*)imageView {
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 5;
    }
    return _imageView;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"13" titleAligment:0];
        _titleLB.numberOfLines = 1;
    }
    return _titleLB;
}


- (HKShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKShadowImageView alloc]init];
        _bgImageView.cornerRadius = 5;
        //_bgImageView.offSet = 5;
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}


- (HKCustomMarginLabel*)countLB {
    if (!_countLB) {
        _countLB  = [[HKCustomMarginLabel alloc] init];
        _countLB.textInsets = UIEdgeInsetsMake(7, 15, 7, 15);
        [_countLB setTextColor:[UIColor whiteColor]];
        _countLB.font = HK_FONT_SYSTEM(12);
        _countLB.textAlignment = NSTextAlignmentLeft;
        _countLB.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        //_countLB.hidden = YES;
    }
    return _countLB;
}






@end








