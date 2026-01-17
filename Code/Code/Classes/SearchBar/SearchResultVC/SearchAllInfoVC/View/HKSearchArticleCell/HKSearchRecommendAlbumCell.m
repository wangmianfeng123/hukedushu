//
//  HKSearchRecommendAlbumCell.m
//  Code
//
//  Created by Ivan li on 2019/4/17.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchRecommendAlbumCell.h"
#import "SeriseCourseTagView.h"
#import "SeriseCourseModel.h"
#import "HKAlbumTagView.h"
#import "HKContainerModel.h"
#import "HKShadowImageView.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKSearchCourseModel.h"


@interface HKSearchRecommendAlbumCell ()


@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *lineView;//分割线

@property(nonatomic,strong)HKAlbumTagView  *followView; //收藏人数

@property(nonatomic,strong)HKAlbumTagView  *exerciseView; //练习数量

@property(nonatomic,strong)UIImageView *userImageView;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//昵称

@property(nonatomic,strong)HKShadowImageView *albumShadowImageView;
/** 收藏数 */
@property(nonatomic,strong)UILabel *collectLabel;
/** 教程数 */
@property(nonatomic,strong)UILabel *courseLabel;
/** 收藏 右侧分割线 */
@property(nonatomic,strong)UILabel *collectLineLB;

@end



@implementation HKSearchRecommendAlbumCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame ];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.userNameLabel];
    
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.courseLabel];
    
    [self.contentView addSubview:self.collectLineLB];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.categoryLb];
    
    [self.contentView addSubview:self.moreBtn];
    
    [self.contentView insertSubview:self.albumShadowImageView belowSubview:self.iconImageView];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.userNameLabel.textColor = COLOR_A8ABBE_7B8196;
    
    self.collectLabel.textColor = COLOR_A8ABBE_7B8196;
    self.courseLabel.textColor = COLOR_A8ABBE_7B8196;
    self.categoryLb.textColor =  COLOR_27323F_EFEFF6;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.categoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.categoryLb);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(23);
        make.top.equalTo(self.categoryLb.mas_bottom).offset(15);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?142.5:142.5*Ratio);
        make.height.mas_equalTo(IS_IPHONE6PLUS ?90:90*Ratio);
    }];
    
    [self.albumShadowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(-9);
        make.right.left.bottom.equalTo(self.iconImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(8);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.5);
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(PADDING_5);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.userImageView);
    }];
    
    [self.collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(-8);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_15);
    }];
    
    
    [self.collectLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectLabel.mas_right).offset(7.5);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(8);
        make.centerY.equalTo(self.collectLabel);
    }];
    
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(self.collectLabel);
        make.left.equalTo(self.collectLineLB.mas_right).offset(7.5);
    }];
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
        [_titleLabel setTextColor:COLOR_27323F];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}

//- (UIView*)lineView {
//    if (!_lineView) {
//        _lineView = [UIView new];
//        _lineView.backgroundColor = COLOR_eeeeee;
//    }
//    return _lineView;
//}


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
        _userNameLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                       titleFont:IS_IPHONE6PLUS ? @"14":@"13" titleAligment:NSTextAlignmentLeft];
    }
    return _userNameLabel;
}




- (UILabel*)collectLabel {
    
    if (!_collectLabel) {
        _collectLabel = [UILabel new];
        [_collectLabel setTextColor:COLOR_A8ABBE];
        _collectLabel.textAlignment = NSTextAlignmentLeft;
        _collectLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _collectLabel;
}


- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel = [UILabel new];
        [_courseLabel setTextColor:COLOR_A8ABBE];
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



- (UILabel*)categoryLb {
    if (!_categoryLb) {
        _categoryLb  = [UILabel labelWithTitle:CGRectZero title:@"专辑"
                                    titleColor:COLOR_27323F
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _categoryLb.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _categoryLb;
}


- (UIButton*)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setHKEnlargeEdge:20];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}


- (void)moreBtnClick:(UIButton*)btn {
    if (self.moreBtnClickBackCall) {
        self.moreBtnClickBackCall();
    }
}

- (void)setMatchModel:(HKTeacherMatchModel *)matchModel {
    _matchModel = matchModel;
    
    HKFirstMatchModel *model = nil;
    if (matchModel.first_match.count) {
        model = matchModel.first_match[0];
    }
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    _userNameLabel.text = model.name;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    _collectLabel.text = [NSString stringWithFormat:@"收藏数：%@",model.collect_num];
    _courseLabel.text = [NSString stringWithFormat:@"教程数：%@",model.video_num];
    
    if (matchModel.match_count >1) {
        NSString *title = [NSString stringWithFormat:@"查看%ld条结果",(long)matchModel.match_count];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moreBtn.hidden = NO;
    }
}


@end
