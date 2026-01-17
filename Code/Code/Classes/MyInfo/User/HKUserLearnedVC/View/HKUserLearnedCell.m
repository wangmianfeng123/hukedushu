//
//  HKUserLearnedCell.m
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserLearnedCell.h"
#import "VideoModel.h"
#import "HomeVideloCell.h"
#import "VideoModel.h"
  
#import "HKAlbumShadowImageView.h"
#import "UIImage+SNFoundation.h"


@implementation HKUserLearnedCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.deadlineLabel];
    [self.contentView addSubview:self.progressLabel];
    
    [self.contentView addSubview:self.scanLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView insertSubview:self.bgImageView belowSubview:self.iconImageView];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    
    self.categoryLabel.textColor = COLOR_A8ABBE_7B8196;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    
    self.sizeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.progressLabel.textColor = COLOR_A8ABBE_7B8196;
    
    self.scanLabel.textColor = COLOR_A8ABBE_7B8196;
    self.courseLabel.textColor = COLOR_A8ABBE_7B8196;
    self.deadlineLabel.textColor = COLOR_A8ABBE_7B8196;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.top.equalTo(_iconImageView).offset(-PADDING_10);
        //make.right.bottom.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.videoType == HKVideoType_PGC) {
            make.left.equalTo(self.contentView).offset(45/2);
            make.top.equalTo(self.contentView).offset(47/2);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?155:145);
        }else{
            make.left.equalTo(self.contentView).offset(PADDING_15);
            make.top.equalTo(self.contentView).offset(16);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
        }
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(24);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-PADDING_5);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-PADDING_5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.lessThanOrEqualTo(self.iconImageView).offset(-8).priorityHigh();
    }];
    
    
    [_deadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).mas_offset(-5);
        make.left.equalTo(self.titleLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
    [_scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseLabel);
        make.left.equalTo(self.courseLabel.mas_right).offset(PADDING_15);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-1);
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.model.videoType == HKVideoType_PGC) {
            make.top.equalTo(self.courseLabel.mas_bottom).offset(PADDING_5);
            make.left.equalTo(self.courseLabel);
        }else{
            make.top.equalTo(self.timeLabel.mas_bottom).offset(PADDING_5);
            make.left.equalTo(self.timeLabel);
        }
    }];
}




- (UILabel*)deadlineLabel {
    
    if (!_deadlineLabel) {
        _deadlineLabel  = [[UILabel alloc] init];
        [_deadlineLabel setTextColor:COLOR_A8ABBE];
        _deadlineLabel.textAlignment = NSTextAlignmentCenter;
        _deadlineLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 12:11];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_EEF5FF];
        _deadlineLabel.backgroundColor = bgColor;
        _deadlineLabel.clipsToBounds = YES;
        _deadlineLabel.layer.cornerRadius = 10;
    }
    return _deadlineLabel;
}


- (void)setDeadlineTitleByModel:(VideoModel *)model {
    
    //is_show_deadline; //is_show_deadline:是否显示7天有效 1-显示 0-不显示
    if ([model.is_show_deadline isEqualToString:@"1"]) {
        _deadlineLabel.text = @"七天有效";
        _deadlineLabel.hidden = NO;
    }else{
        _deadlineLabel.text = nil;
        _deadlineLabel.hidden = YES;
    }
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
    }
    return _iconImageView;
}


- (HKAlbumShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKAlbumShadowImageView alloc]init];
        //_bgImageView.offSet = 5;
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(IS_IPHONE6PLUS ? 15:14, UIFontWeightMedium);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_A8ABBE];
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [[UILabel alloc] init];
        [_sizeLabel setTextColor:COLOR_A8ABBE];
        _sizeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:COLOR_A8ABBE];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}


- (UILabel*)progressLabel {
    
    if (!_progressLabel) {
        _progressLabel  = [[UILabel alloc] init];
        [_progressLabel setTextColor:COLOR_A8ABBE];
        _progressLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _progressLabel.hidden = YES;
    }
    return _progressLabel;
}


- (UILabel*)scanLabel {
    
    if (!_scanLabel) {
        _scanLabel  = [[UILabel alloc] init];
        [_scanLabel setTextColor:COLOR_A8ABBE];
        _scanLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _scanLabel;
}

- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel  = [[UILabel alloc] init];
        [_courseLabel setTextColor:COLOR_A8ABBE];
        _courseLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _courseLabel;
}



- (void)setModel:(VideoModel *)model {
    
    _model = model;
    [self setDeadlineTitleByModel:model];
    
    _bgImageView.hidden = (model.videoType == HKVideoType_PGC) ?NO :YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];

    _scanLabel.text = isEmpty(model.study_num) ?nil  :[NSString stringWithFormat:@"%@人观看",model.study_num];
    _titleLabel.text = [NSString stringWithFormat:@"%@",([model.type integerValue] == 2) ?model.title :model.video_titel];
    _timeLabel.text = isEmpty(model.video_duration) ?nil  :[NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    _progressLabel.text = isEmpty(model.study_info) ?nil  :[NSString stringWithFormat:@"%@",model.study_info];
    _courseLabel.text = isEmpty(model.curriculum_total) ?nil  :[NSString stringWithFormat:@"%@节课",model.curriculum_total];
}


@end





