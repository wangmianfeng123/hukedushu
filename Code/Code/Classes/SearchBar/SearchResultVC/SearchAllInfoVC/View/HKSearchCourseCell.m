//
//  HKSearchCourseCell.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchCourseCell.h"
#import "VideoModel.h"


@implementation HKSearchCourseCell

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
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.watchLabel];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.categoryLabel.textColor = COLOR_A8ABBE_7B8196;
    self.sizeLabel.textColor = COLOR_A8ABBE_7B8196;
    
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.watchLabel.textColor = COLOR_27323F_EFEFF6;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        //make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_15);
        //make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
        make.size.mas_equalTo(CGSizeMake(156, 96));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top).offset(8);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(25 * 0.5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(7);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    

    [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(-3);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.lessThanOrEqualTo(weakSelf.watchLabel.mas_bottom).offset(3);
        make.left.right.equalTo(weakSelf.titleLabel);
        make.bottom.lessThanOrEqualTo(weakSelf.iconImageView).offset(-8);
    }];
}




- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
//        NSString* path = [[NSBundle mainBundle] pathForResource:@"huke.webp" ofType:nil];
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        _iconImageView.animatedImage = [[FLAnimatedImage alloc]initWithAnimatedGIFData:data];//imageName(@"huke.webp");
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [UILabel new];
        [_categoryLabel setTextColor:COLOR_A8ABBE];
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [UILabel new];
        [_sizeLabel setTextColor:COLOR_A8ABBE];
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [UILabel new];
        [_timeLabel setTextColor:COLOR_A8ABBE];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}


- (UILabel*)watchLabel {
    if (!_watchLabel) {
        _watchLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:nil titleAligment:NSTextAlignmentLeft];
        _watchLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        //_watchLabel.hidden = YES;
    }
    return _watchLabel;
}



- (void)setModel:(VideoModel *)model {
    
    _model = model;
    NSString *url = model.cover_image_url;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:url]] placeholderImage:imageName(HK_Placeholder)];
    _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.time];
    /// v2.17 隐藏
    //_watchLabel.text = isEmpty(model.video_view)? nil :[NSString stringWithFormat:@"%@人观看",model.video_view];
    //_categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
}

@end

