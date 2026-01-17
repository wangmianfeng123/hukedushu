//
//  HKCategoryBookNewCell.m
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKCategoryBookNewCell.h"
#import "UIView+Banner.h"
#import "HKCustomMarginLabel.h"


@interface HKCategoryBookNewCell()

@property (strong, nonatomic)  UIImageView *coverIV;

@property (strong, nonatomic)  UILabel *freeLB;

@property (strong, nonatomic)  UIImageView *listenIV;

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  HKCustomMarginLabel *descrLB;

@property (strong, nonatomic)  UILabel *timeLB;

@property (strong, nonatomic)  UILabel *learnCountLB;
/// 推荐
@property (strong, nonatomic)  UILabel *recomLB;
/// 推荐背景
@property (strong, nonatomic)  UIImageView *recomBgIV;

@property (strong, nonatomic)  UIImageView *shadowIV;

@end



@implementation HKCategoryBookNewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.shadowIV];
    
    [self.contentView addSubview:self.freeLB];
    
    [self.contentView addSubview:self.listenIV];
    [self.contentView addSubview:self.titleLB];
    
    [self.contentView addSubview:self.descrLB];
    [self.contentView addSubview:self.timeLB];
    
    [self.contentView addSubview:self.learnCountLB];
    [self.contentView addSubview:self.recomBgIV];
    
    [self.contentView addSubview:self.recomLB];
    
    [self.recomBgIV addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight]; // 切除了左上，右下
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 105));
    }];
    
    [self.listenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverIV).offset(-4);
        make.bottom.equalTo(self.coverIV).offset(-7);
    }];
    
    [self.freeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV).offset(4);
        make.centerY.equalTo(self.listenIV);
        make.size.mas_equalTo(CGSizeMake(25, 14));
    }];
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.coverIV);
    }];
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(3);
    }];
    
    
    [self.learnCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverIV);
        make.left.equalTo(self.titleLB);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.learnCountLB);
        make.left.equalTo(self.learnCountLB.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
    }];
    
    
    [self.recomBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverIV);
    }];
    
    [self.recomLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recomBgIV);
        make.centerY.equalTo(self.recomBgIV);
    }];
    
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.coverIV);
    }];
    
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.timeLB.textColor = COLOR_A8ABBE_7B8196;
    self.descrLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_A8ABBE];
    self.descrLB.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}



- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFit;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}



- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.image = imageName(@"hk_book_shadow_black");
        _shadowIV.clipsToBounds = YES;
        _shadowIV.layer.cornerRadius = 5.0;
    }
    return _shadowIV;
}



- (UIImageView*)listenIV {
    if (!_listenIV) {
        _listenIV = [UIImageView new];
        _listenIV.image = imageName(@"ic_video_v2_14");
    }
    return _listenIV;
}




- (UIImageView*)recomBgIV {
    if (!_recomBgIV) {
        _recomBgIV = [UIImageView new];
        _recomBgIV.image = [self bgImage];
        [_recomBgIV sizeToFit];
    }
    return _recomBgIV;
}




- (UIImage*)bgImage {
    // 主编推荐
    UIColor *color = [UIColor colorWithHexString:@"#FF6363"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ed6f65"];
    UIColor *color2 = [UIColor colorWithHexString:@"#f19742"];
    UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(50, 17) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    return image;
}


- (UILabel*)recomLB {
    if (!_recomLB) {
        _recomLB = [UILabel labelWithTitle:CGRectZero title:@"主编推荐" titleColor:COLOR_ffffff titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _recomLB.font = HK_FONT_SYSTEM_WEIGHT(10, UIFontWeightSemibold);
        [_recomLB sizeToFit];
    }
    return _recomLB;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightMedium);
        _titleLB.numberOfLines = 2;
    }
    return _titleLB;
}



- (UILabel*)learnCountLB {
    if (!_learnCountLB) {
        _learnCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _learnCountLB;
}



- (UILabel*)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        
//        // 圆角
//        _timeLB.clipsToBounds = YES;
//        _timeLB.layer.cornerRadius = 5.0;
//        _timeLB.layer.borderColor = [UIColor whiteColor].CGColor;
//        _timeLB.layer.borderWidth = 1.0;
    }
    return _timeLB;
}



- (UILabel*)freeLB {
    if (!_freeLB) {
        _freeLB = [UILabel labelWithTitle:CGRectZero title:@"免费" titleColor:COLOR_ffffff titleFont:nil titleAligment:NSTextAlignmentCenter];
        [_freeLB setFont:HK_FONT_SYSTEM_WEIGHT(9, UIFontWeightSemibold)];
        _freeLB.backgroundColor = [UIColor clearColor];
        // 圆角
        _freeLB.clipsToBounds = YES;
        _freeLB.layer.cornerRadius = 5.0;
        _freeLB.layer.borderColor = [UIColor whiteColor].CGColor;
        _freeLB.layer.borderWidth = 1.0;
    }
    return _freeLB;
}




- (HKCustomMarginLabel*)descrLB {
    if (!_descrLB) {
        _descrLB  = [[HKCustomMarginLabel alloc] init];
        _descrLB.textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        _descrLB.textColor =  COLOR_7B8196;
        _descrLB.font = HK_FONT_SYSTEM(11);
        _descrLB.textAlignment = NSTextAlignmentLeft;
        _descrLB.backgroundColor = COLOR_F8F9FA;
        _descrLB.clipsToBounds = YES;
        _descrLB.layer.cornerRadius = 5;
        _descrLB.hidden = YES;
        _descrLB.numberOfLines = 2;
    }
    return _descrLB;
}



- (void)setModel:(HKBookModel *)model {
    
    _model = model;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];

    self.freeLB.hidden = !model.is_free;
    
    self.titleLB.text = model.title;
    
    self.timeLB.text = [NSString stringWithFormat:@"时长 %@", model.time];
    
    self.learnCountLB.text = [NSString stringWithFormat:@"%@人已学", model.listen_number];
    
    self.descrLB.text = model.short_introduce;
    
    self.descrLB.hidden = isEmpty(model.short_introduce);
    
    self.recomLB.hidden = !model.is_recommend;
    
    self.recomBgIV.hidden = !model.is_recommend;
    
}

@end

