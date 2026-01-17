
//
//  LearnedPgcCell.m
//  Code
//
//  Created by Ivan li on 2018/9/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "LearnedPgcCell.h"
#import "HKAlbumShadowImageView.h"
#import "UIImage+SNFoundation.h"




@implementation LearnedPgcCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView addSubview:self.iconImageView];
    [self.cellBgView addSubview:self.titleLabel];
    
    [self.cellBgView addSubview:self.progressLabel];
    [self.cellBgView addSubview:self.courseLabel];
    [self.cellBgView insertSubview:self.bgImageView belowSubview:self.iconImageView];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellBgView).offset(45/2);
        make.top.equalTo(self.cellBgView).offset(16);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?155:145);
        make.bottom.equalTo(self.cellBgView).offset(-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellBgView).offset(24);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_5);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.left.equalTo(self.titleLabel);
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.courseLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self.courseLabel);
    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        //_iconImageView.clipsToBounds = YES;
        //_iconImageView.layer.cornerRadius = PADDING_5;
    }
    return _iconImageView;
}


- (HKAlbumShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKAlbumShadowImageView alloc]init];
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)progressLabel {
    
    if (!_progressLabel) {
        _progressLabel  = [[UILabel alloc] init];
        [_progressLabel setTextColor:COLOR_A8ABBE];
        _progressLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _progressLabel;
}




- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel  = [[UILabel alloc] init];
        [_courseLabel setTextColor:COLOR_A8ABBE];
        _courseLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _courseLabel;
}




- (UIView*)cellBgView {
    if (!_cellBgView) {
        _cellBgView = [UIView new];
    }
    return _cellBgView;
}




- (void)setModel:(VideoModel *)model {
    
    _model = model;
    WeakSelf;
    _bgImageView.hidden = (model.videoType == HKVideoType_PGC)?NO :YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 if (image != nil){
                                     StrongSelf;
                                     //裁剪图片圆角
                                     strongSelf.iconImageView.image = [image roundCornerImageWithRadius:8];
                                 }
                             }];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _progressLabel.text = isEmpty(model.study_info) ?nil  :[NSString stringWithFormat:@"%@",model.study_info];
    _courseLabel.text = isEmpty(model.curriculum_total) ?nil  :[NSString stringWithFormat:@"%@节课",model.curriculum_total];
    
}


@end





