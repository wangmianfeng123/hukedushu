
//
//  HKSearchArticleCell.m
//  Code
//
//  Created by Ivan li on 2019/4/9.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchArticleCell.h"
#import "HKArticleModel.h"
#import "UIImage+SNFoundation.h"


@interface HKSearchArticleCell()


@end

@implementation HKSearchArticleCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.avatorIV];
    
    [self.contentView addSubview:self.userHeaderIV];
    [self.contentView addSubview:self.userNameLB];
    
    [self.contentView addSubview:self.likeCountLB];
    [self.contentView addSubview:self.readCountLB];
    [self.contentView addSubview:self.exclusiveIV];
    
    [self.readCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.likeCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.userNameLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    
    self.userNameLB.textColor = COLOR_A8ABBE_7B8196;
    self.likeCountLB.textColor = COLOR_A8ABBE_7B8196;
    self.readCountLB.textColor = COLOR_A8ABBE_7B8196;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.avatorIV.mas_left).offset(-PADDING_5);
    }];
    
    [self.avatorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(120, 74));
    }];
    
    [self.userHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatorIV);
        make.left.equalTo(self.titleLB);
        make.width.height.mas_equalTo(PADDING_20);
    }];
    
    [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.left.equalTo(self.userHeaderIV.mas_right).offset(PADDING_5);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    
    [self.likeCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.right.equalTo(self.avatorIV.mas_left).offset(-17);
        make.left.equalTo(self.userNameLB.mas_right).offset(5).priorityLow();
    }];
    
    [self.readCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.right.equalTo(self.likeCountLB.mas_left).offset(-PADDING_10);
    }];
    
    [self.exclusiveIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorIV);
        make.right.equalTo(self.avatorIV).offset(-PADDING_5);
    }];
    

}




- (UILabel*)titleLB {
    
    if (!_titleLB) {
        _titleLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:COLOR_27323F
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLB.font = HK_FONT_SYSTEM(16);
        _titleLB.numberOfLines = 1;
    }
    return _titleLB;
}



- (UIImageView*)avatorIV {
    if (!_avatorIV) {
        _avatorIV = [UIImageView new];
        _avatorIV.contentMode = UIViewContentModeScaleAspectFit;
        _avatorIV.clipsToBounds = YES;
        _avatorIV.layer.cornerRadius = 5.0;
    }
    return _avatorIV;
}



- (UIImageView*)userHeaderIV {
    if (!_userHeaderIV) {
        _userHeaderIV = [UIImageView new];
        _userHeaderIV.contentMode = UIViewContentModeScaleAspectFit;
        _userHeaderIV.clipsToBounds = YES;
        _userHeaderIV.layer.cornerRadius = PADDING_10;
    }
    return _userHeaderIV;
}


- (UIImageView*)exclusiveIV {
    if (!_exclusiveIV) {
        _exclusiveIV = [UIImageView new];
        _exclusiveIV.hidden = YES;
        _exclusiveIV.image = imageName(@"ic_exclusive_v210");
    }
    return _exclusiveIV;
}


- (UILabel*)userNameLB {
    
    if (!_userNameLB) {
        _userNameLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                 titleColor:COLOR_A8ABBE
                                  titleFont:nil
                              titleAligment:NSTextAlignmentLeft];
        _userNameLB.font = HK_FONT_SYSTEM(11);
    }
    return _userNameLB;
}


- (UILabel*)readCountLB {
    
    if (!_readCountLB) {
        _readCountLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:COLOR_A8ABBE
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentRight];
        _readCountLB.font = HK_FONT_SYSTEM(11);
    }
    return _readCountLB;
}


- (UILabel*)likeCountLB {
    
    if (!_likeCountLB) {
        _likeCountLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_A8ABBE
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentRight];
        _likeCountLB.font = HK_FONT_SYSTEM(11);
    }
    return _likeCountLB;
}






- (void)setModel:(HKArticleModel *)model {
    _model = model;
    self.titleLB.text = model.title;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_pic]] placeholderImage:imageName(HK_Placeholder)];
    
    self.exclusiveIV.hidden = !model.is_exclusive;
    [self.userHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.userNameLB.text = model.name;
    self.likeCountLB.text = [NSString stringWithFormat:@"%@赞", model.appreciate_num];
    /// v 2.17 隐藏
    //self.readCountLB.text = [NSString stringWithFormat:@"%ld人阅读", (long)model.show_num];
}



- (void)injected {
    
    self.titleLB.text = @"短发方式";
    [self.avatorIV sd_setImageWithURL:nil placeholderImage:HK_PlaceholderImage];
    
    self.exclusiveIV.hidden = NO;
    
    [self.userHeaderIV sd_setImageWithURL:nil placeholderImage:HK_PlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    self.userNameLB.text = @"短发方式";
    self.likeCountLB.text = [NSString stringWithFormat:@"%@赞", @"11"];
    self.readCountLB.text = [NSString stringWithFormat:@"%@人阅读", @"11"];
}

@end
