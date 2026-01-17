//
//  HomeVideloCell.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeVideloCell.h"
#import "VideoModel.h"
  

#import "DownloadModel.h"
#import "DownloadManager+Utils.h"
#import "DownloadCacher.h"


@implementation HomeVideloCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(PADDING_10);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_10);
        make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_10);
        //make.width.mas_equalTo(SCREEN_WIDTH/3+PADDING_20);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sizeLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        //[_titleLabel setTextColor:RGB(92, 92, 92, 1)];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];

        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [[UILabel alloc] init];
        [_sizeLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}




- (void)downloadAction:(UIButton*)sender {
    self.btnClickBlock ? self.btnClickBlock(self.downloadModel): nil;
}



- (void)setModel:(VideoModel *)model {
    
    _model = model;
    //self.downloadModel = [[DownloadModel alloc]init];
//    self.downloadModel.url = model.video_url;
//    self.downloadModel.name = model.video_titel;
//    self.downloadModel.category = model.video_application;
//    self.downloadModel.hardLevel = model.viedeo_difficulty;
//    self.downloadModel.imageUrl = model.img_cover_url;
//    self.downloadModel.videoDuration = model.video_duration;
//    self.downloadModel.videoId = model.video_id;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.video_titel];
    _categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
    _sizeLabel.text = [NSString stringWithFormat:@"难度：%@",model.viedeo_difficulty];
    _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
}

- (DownloadModel*)downloadModel {
    
    if (!_downloadModel) {
        _downloadModel = [[DownloadModel alloc]init];
    }
    return _downloadModel;
}


@end
