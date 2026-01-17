//
//  HKSearchAlbumCell.m
//  Code
//
//  Created by Ivan li on 2018/3/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSearchAlbumCell.h"
#import "SeriseCourseTagView.h"
#import "SeriseCourseModel.h"
#import "HKAlbumTagView.h"
#import "HKContainerModel.h"
#import "HKShadowImageView.h"


@interface HKSearchAlbumCell ()


@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *lineView;//分割线

@property(nonatomic,strong)HKAlbumTagView  *followView; //收藏人数

@property(nonatomic,strong)HKAlbumTagView  *exerciseView; //练习数量

@property(nonatomic,strong)UIImageView *userImageView;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//昵称
/** 阴影图片 */
//@property(nonatomic,strong)HKAlbumShadowImageView *albumShadowImageView;

@property(nonatomic,strong)HKShadowImageView *albumShadowImageView;

/** 收藏数 */
@property(nonatomic,strong)UILabel *collectLabel;
/** 教程数 */
@property(nonatomic,strong)UILabel *courseLabel;
/** 收藏 右侧分割线 */
@property(nonatomic,strong)UILabel *collectLineLB;

@end



@implementation HKSearchAlbumCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame ];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.userNameLabel];
    
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.courseLabel];
    
    [self.contentView addSubview:self.collectLineLB];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView insertSubview:self.albumShadowImageView belowSubview:self.iconImageView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(23);
        //make.top.equalTo(weakSelf.contentView.mas_top).offset(35/2);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(PADDING_10);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?150:150*Ratio);
        make.height.mas_equalTo(IS_IPHONE6PLUS ?95:95*Ratio);
    }];
    
    [_albumShadowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(PADDING_15);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(7.5);
        make.left.equalTo(weakSelf.titleLabel);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userImageView.mas_right).offset(PADDING_5);
        make.centerY.equalTo(weakSelf.userImageView);
    }];
    
//    [_collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-PADDING_15);
//        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_15);
//    }];
//
//    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.height.equalTo(weakSelf.collectLabel);
//        make.left.equalTo(weakSelf.collectLabel.mas_right).offset(PADDING_15);
//    }];
    
    [_collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-PADDING_15);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_15);
    }];
    
    
    [_collectLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.collectLabel.mas_right).offset(7.5);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(8);
        make.centerY.equalTo(weakSelf.collectLabel);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(weakSelf.collectLabel);
        make.left.equalTo(weakSelf.collectLineLB.mas_right).offset(7.5);
    }];
    
//    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
//        make.left.right.equalTo(weakSelf.contentView);
//    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 3;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_eeeeee;
    }
    return _lineView;
}


- (UIImageView*)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.image = imageName(HK_Placeholder);
        _userImageView.clipsToBounds = YES;
        _userImageView.layer.cornerRadius = PADDING_25/2;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}


- (UILabel*)userNameLabel {
    
    if (!_userNameLabel) {
        _userNameLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196
                                       titleFont:IS_IPHONE6PLUS ? @"14":@"13" titleAligment:NSTextAlignmentLeft];
    }
    return _userNameLabel;
}


//- (HKAlbumTagView*)followView {
//    if (!_followView) {
//        _followView = [[HKAlbumTagView alloc]initWithFrame:CGRectZero];
//    }
//    return _followView;
//}
//
//
//
//- (HKAlbumTagView*)exerciseView {
//    if (!_exerciseView) {
//        _exerciseView = [[HKAlbumTagView alloc]initWithFrame:CGRectZero];
//    }
//    return _exerciseView;
//}


//- (HKAlbumShadowImageView*)albumShadowImageView {
//    if (!_albumShadowImageView) {
//        _albumShadowImageView = [[HKAlbumShadowImageView alloc]init];
//        _albumShadowImageView.offSet = 5;
//    }
//    return _albumShadowImageView;
//}


- (HKShadowImageView*)albumShadowImageView {
    if (!_albumShadowImageView) {
        _albumShadowImageView = [[HKShadowImageView alloc]init];
        //_albumShadowImageView.offSet = 3;
        _albumShadowImageView.offSet = 4.5;
        _albumShadowImageView.hidden = YES;
    }
    return _albumShadowImageView;
}


- (UILabel*)collectLabel {
    
    if (!_collectLabel) {
        _collectLabel = [UILabel new];
        [_collectLabel setTextColor:COLOR_A8ABBE_7B8196];
        _collectLabel.textAlignment = NSTextAlignmentLeft;
        _collectLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _collectLabel;
}


- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel = [UILabel new];
        [_courseLabel setTextColor:COLOR_A8ABBE_7B8196];
        _courseLabel.textAlignment = NSTextAlignmentLeft;
        _courseLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _courseLabel;
}


- (UILabel*)collectLineLB {
    if (!_collectLineLB) {
        _collectLineLB  = [[UILabel alloc] init];
        _collectLineLB.backgroundColor = COLOR_CFCFD9;
    }
    return _collectLineLB;
}



- (void)setModel:(HKAlbumModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    _userNameLabel.text = model.username;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    _collectLabel.text = [NSString stringWithFormat:@"%@人收藏",model.collect_num];
    _courseLabel.text = [NSString stringWithFormat:@"%@节课",model.video_num];
}



- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",videoModel.name];
    
    _userNameLabel.text = videoModel.username;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.avator] placeholderImage:imageName(HK_Placeholder)];
    _collectLabel.text = [NSString stringWithFormat:@"收藏数：%@",videoModel.collect_num];
    _courseLabel.text = [NSString stringWithFormat:@"教程数：%@",videoModel.video_num];
}


@end
