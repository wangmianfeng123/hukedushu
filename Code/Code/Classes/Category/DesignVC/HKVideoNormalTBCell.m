
//
//  HKVideoNormalTBCell.m
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVideoNormalTBCell.h"
#import "VideoModel.h"
#import "DownloadModel.h"
#import "HKCoverBaseIV.h"


@interface HKVideoNormalTBCell()

@end


@implementation HKVideoNormalTBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 18, 0);
    self.tb_hightedLigthedIndex = CollectionViewIndexFont;
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.seapratorView];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectionBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).mas_offset(16);
        make.top.equalTo(weakSelf.contentView).mas_offset(16);
        make.height.mas_equalTo(211);
        make.right.equalTo(weakSelf.contentView).mas_offset(-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(12);
        make.left.equalTo(weakSelf.contentView).offset(13);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-50);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sizeLabel.mas_top);
        make.left.equalTo(_sizeLabel.mas_right).offset(20);
    }];
    
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.contentView).mas_offset(-6);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-8);
    }];
    
    [self.seapratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(8);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
}




- (HKCoverBaseIV *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[HKCoverBaseIV alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5.0;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_333333];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_999999];
        
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        
        _categoryLabel.hidden = YES;
    }
    return _categoryLabel;
}

- (UIButton *)collectionBtn {
    if (_collectionBtn == nil) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:imageName(@"home_collection_normal") forState:UIControlStateNormal];
        [_collectionBtn setImage:imageName(@"home_collection_selected") forState:UIControlStateSelected];
        [_collectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

- (void)collectionBtnClick {
    
    if (isLogin()) {
        self.collectionBtn.selected = !self.collectionBtn.selected;
        CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];//在这里@"transform.rotation"==@"transform.rotation.z"
        NSValue *value1 = [NSNumber numberWithFloat:1.0];
        NSValue *value2 = [NSNumber numberWithFloat:1.3];
        NSValue *value3 = [NSNumber numberWithFloat:1.0];
        anima.values = @[value1,value2,value3];

        CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
        NSValue *valueShake1 = [NSNumber numberWithFloat:-M_PI/180*2];
        NSValue *valueShake2 = [NSNumber numberWithFloat:M_PI/180*2];
        NSValue *valueShake3 = [NSNumber numberWithFloat:-M_PI/180*2];
        NSValue *valueShake4 = [NSNumber numberWithFloat:M_PI/180*2];
        anima2.values = @[valueShake1, valueShake2, valueShake3, valueShake4];

        CAAnimationGroup *groupAnima = [[CAAnimationGroup alloc] init];
        groupAnima.duration = 0.25;
        groupAnima.animations = @[anima, anima2];
        [self.collectionBtn.layer addAnimation:groupAnima forKey:@"groupAnimation"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.25)), dispatch_get_main_queue(), ^{
        !self.collectionBlock? : self.collectionBlock(self.indexPath, self.model);
    });
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

- (UIView *)seapratorView {
    
    if (_seapratorView == nil) {
        _seapratorView = [[UIView alloc] init];
        _seapratorView.backgroundColor = COLOR_F6F6F6;
    }
    return _seapratorView;
}




#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:COLOR_999999];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}





- (void)setModel:(VideoModel *)model {
    
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url_big.length? model.img_cover_url_big : model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.video_titel];
    _categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
    _sizeLabel.text = [NSString stringWithFormat:@"难度：%@",model.viedeo_difficulty];
    _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    
    // 收藏
    self.collectionBtn.selected = model.is_collect;
    // 图文
    self.iconImageView.hasPictext = !model.has_pictext;
    self.iconImageView.courseCount = model.total_course;
}

- (DownloadModel*)downloadModel {
    
    if (!_downloadModel) {
        _downloadModel = [[DownloadModel alloc]init];
    }
    return _downloadModel;
}





@end
