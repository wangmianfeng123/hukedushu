
//
//  HKVideoNormalTBCell.m
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVideoNormalTBiPadCell.h"
#import "VideoModel.h"
#import "DownloadModel.h"
#import "HKCoverBaseIV.h"


@interface HKVideoNormalTBiPadCell()

@end


@implementation HKVideoNormalTBiPadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.seapratorView];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectionBtn];
    
    // 右侧的cell
    [self.contentView addSubview:self.iconImageView2];
    [self.contentView addSubview:self.titleLabel2];
    [self.contentView addSubview:self.categoryLabel2];
    [self.contentView addSubview:self.seapratorView2];
    [self.contentView addSubview:self.sizeLabel2];
    [self.contentView addSubview:self.timeLabel2];
    [self.contentView addSubview:self.collectionBtn2];
    
    // 添加点击手势
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel)];
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tap0];
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:tap1];
    self.sizeLabel.userInteractionEnabled = YES;
    [self.sizeLabel addGestureRecognizer:tap2];
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel2)];
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel2)];
    UITapGestureRecognizer *tap12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel2)];
    UITapGestureRecognizer *tap13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapModel2)];
    self.iconImageView2.userInteractionEnabled = YES;
    [self.iconImageView2 addGestureRecognizer:tap10];
    self.titleLabel2.userInteractionEnabled = YES;
    [self.titleLabel2 addGestureRecognizer:tap11];
    self.sizeLabel2.userInteractionEnabled = YES;
    [self.sizeLabel2 addGestureRecognizer:tap12];
    self.timeLabel2.userInteractionEnabled = YES;
    [self.timeLabel2 addGestureRecognizer:tap13];
}

- (void)tapModel {
    !self.tapModelBlock? : self.tapModelBlock(self.model);
}

- (void)tapModel2 {
    !self.tapModelBlock? : self.tapModelBlock(self.model2);
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
        make.right.equalTo(weakSelf.contentView.mas_centerX).mas_offset(-8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(12);
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.right.equalTo(_iconImageView);
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
        make.right.mas_equalTo(self.iconImageView).mas_offset(6);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-8);
    }];
    
    [self.seapratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(8);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
    // 右侧
    [_iconImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_centerX).mas_offset(8);
        make.top.equalTo(weakSelf.contentView).mas_offset(16);
        make.height.mas_equalTo(211);
        make.right.equalTo(weakSelf.contentView).mas_offset(-16);
    }];
    
    [_titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView2.mas_bottom).offset(12);
        make.left.equalTo(weakSelf.iconImageView2);
        make.right.equalTo(_iconImageView2);
    }];
    
    [_categoryLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel2.mas_bottom).offset(PADDING_10);
        make.left.right.equalTo(weakSelf.titleLabel2);
    }];
    
    [_sizeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel2.mas_bottom).offset(PADDING_10);
        make.left.equalTo(weakSelf.titleLabel2);
    }];
    
    [_timeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sizeLabel2.mas_top);
        make.left.equalTo(_sizeLabel2.mas_right).offset(20);
    }];
    
    [self.collectionBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.iconImageView2).mas_offset(6);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-8);
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

#pragma mark -右侧的cell
- (HKCoverBaseIV *)iconImageView2 {
    if (!_iconImageView2) {
        _iconImageView2 = [[HKCoverBaseIV alloc]init];
        _iconImageView2.clipsToBounds = YES;
        _iconImageView2.layer.cornerRadius = 5.0;
    }
    return _iconImageView2;
}



- (UILabel*)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2  = [[UILabel alloc] init];
        [_titleLabel2 setTextColor:COLOR_333333];
        _titleLabel2.textAlignment = NSTextAlignmentLeft;
        _titleLabel2.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _titleLabel2;
}



- (UILabel*)categoryLabel2 {
    
    if (!_categoryLabel2) {
        _categoryLabel2  = [[UILabel alloc] init];
        [_categoryLabel2 setTextColor:COLOR_999999];
        
        _categoryLabel2.textAlignment = NSTextAlignmentLeft;
        _categoryLabel2.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        
        _categoryLabel2.hidden = YES;
    }
    return _categoryLabel2;
}

- (UIButton *)collectionBtn2 {
    if (_collectionBtn2 == nil) {
        _collectionBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn2 setImage:imageName(@"home_collection_normal") forState:UIControlStateNormal];
        [_collectionBtn2 setImage:imageName(@"home_collection_selected") forState:UIControlStateSelected];
        [_collectionBtn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [_collectionBtn2 addTarget:self action:@selector(collectionBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn2;
}

#pragma mark - 视频大小
- (UILabel*)sizeLabel2 {
    
    if (!_sizeLabel2) {
        _sizeLabel2  = [[UILabel alloc] init];
        [_sizeLabel2 setTextColor:[UIColor colorWithHexString:@"#999999"]];
        _sizeLabel2.textAlignment = NSTextAlignmentLeft;
        _sizeLabel2.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _sizeLabel2;
}

#pragma mark -时长
- (UILabel*)timeLabel2 {
    
    if (!_timeLabel2) {
        _timeLabel2  = [[UILabel alloc] init];
        [_timeLabel2 setTextColor:COLOR_999999];
        _timeLabel2.textAlignment = NSTextAlignmentLeft;
        _timeLabel2.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _timeLabel2.numberOfLines = 2;
    }
    return _timeLabel2;
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


- (void)collectionBtnClick2 {
    
    if (isLogin()) {
        self.collectionBtn2.selected = !self.collectionBtn2.selected;
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
        [self.collectionBtn2.layer addAnimation:groupAnima forKey:@"groupAnimation"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.25)), dispatch_get_main_queue(), ^{
        !self.collectionBlock2? : self.collectionBlock2(self.indexPath2, self.model2);
    });
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

- (void)setModel2:(VideoModel *)model2 {
    _model2 = model2;
    
    _iconImageView2.hidden = NO;
    _titleLabel2.hidden = NO;
    _sizeLabel2.hidden = NO;
    _timeLabel2.hidden = NO;
    self.collectionBtn2.hidden = NO;
    if (model2) {
        // 防止单数的时候为空
        VideoModel *model = model2;
        // 右侧的cell
        [_iconImageView2 sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url_big.length? model.img_cover_url_big : model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
        _titleLabel2.text = [NSString stringWithFormat:@"%@", model.video_titel];
        _categoryLabel2.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
        _sizeLabel2.text = [NSString stringWithFormat:@"难度：%@",model.viedeo_difficulty];
        _timeLabel2.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
        
        // 收藏
        self.collectionBtn2.selected = model.is_collect;
        // 图文
        self.iconImageView2.hasPictext = !model.has_pictext;
        self.iconImageView2.courseCount = model.total_course;
    } else {
        _iconImageView2.hidden = YES;
        _titleLabel2.hidden = YES;
        _sizeLabel2.hidden = YES;
        _timeLabel2.hidden = YES;
        self.collectionBtn2.hidden = YES;
    }

}

- (DownloadModel*)downloadModel {
    
    if (!_downloadModel) {
        _downloadModel = [[DownloadModel alloc]init];
    }
    return _downloadModel;
}





@end
