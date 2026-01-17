//
//  LearnedCell.m
//  Code
//
//  Created by Ivan li on 2017/7/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKLiveLearnedCell.h"
#import "VideoModel.h"
#import "HKAlbumShadowImageView.h"
#import "UIImage+SNFoundation.h"
#import "HKCustomMarginLabel.h"



@implementation HKLiveLearnedCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)createUI {
    
    HK_NOTIFICATION_ADD(@"HKLiveLearnedVC", updateCell:);
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView addSubview:self.selectBtn];
    
    [self.cellBgView addSubview:self.iconImageView];
    [self.cellBgView addSubview:self.titleLabel];
    [self.cellBgView addSubview:self.categoryLabel];
    
    [self.cellBgView addSubview:self.sizeLabel];
    [self.cellBgView addSubview:self.timeLabel];
    [self.cellBgView addSubview:self.deadlineLabel];
    [self.cellBgView addSubview:self.progressLabel];
    
    [self.cellBgView addSubview:self.scanLabel];
    [self.cellBgView addSubview:self.courseLabel];
    //[self.cellBgView insertSubview:self.bgImageView belowSubview:self.iconImageView];
    
    [self makeConstraints];
}


- (void)updateCell:(NSNotification*)noti {
    NSDictionary *dict = noti.userInfo;
    NSInteger  state = [dict[@"isEditing"] integerValue];
    self.isEdit = state;
    if (state) {
        [self updateEditAllConstraints];
    }else{
        [self updateNoEditAllConstraints];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEdit) {
        [self updateEditAllConstraints];
    }else{
        [self makeConstraints];
    }
}



- (void)updateEditAllConstraints {
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_30);
        make.right.top.bottom.equalTo(self.contentView);
    }];
}



- (void)updateNoEditAllConstraints {
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (void)makeConstraints {
    
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellBgView.mas_centerY);
        make.left.equalTo(self.cellBgView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.videoType == HKVideoType_PGC) {
            make.left.equalTo(self.cellBgView).offset(45/2);
            make.top.equalTo(self.cellBgView).offset(16);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?155:145);
        }else{
            make.left.equalTo(self.cellBgView).offset(PADDING_15);
            make.top.equalTo(self.cellBgView).offset(16);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
        }
        make.bottom.equalTo(self.cellBgView).offset(-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellBgView).offset(24);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.cellBgView).offset(-PADDING_5);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.cellBgView).offset(-PADDING_5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.deadlineLabel.mas_bottom).offset(3);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12).priorityLow();
        //make.bottom.lessThanOrEqualTo(self.iconImageView).offset(-8).priorityHigh();
    }];
    
    [_deadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self.titleLabel);
        make.right.lessThanOrEqualTo(self.cellBgView).offset(-1);
        //make.width.mas_equalTo(60);
        //make.height.mas_equalTo(20);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.left.equalTo(self.titleLabel);
    }];
    
    [_scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseLabel);
        make.left.equalTo(self.courseLabel.mas_right).offset(PADDING_15);
        make.right.lessThanOrEqualTo(self.cellBgView.mas_right).offset(-1);
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




- (void)makeConstraints_1 {
    
    WeakSelf;
    [_cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.videoType == HKVideoType_PGC) {
            make.left.equalTo(weakSelf.contentView).offset(45/2);
            make.top.equalTo(weakSelf.contentView).offset(47/2);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?155:145);
        }else{
            make.left.equalTo(weakSelf.contentView).offset(PADDING_15);
            make.top.equalTo(weakSelf.contentView).offset(16);
            make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
        }
        make.bottom.equalTo(weakSelf.contentView).offset(-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(24);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf).offset(-PADDING_5);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf).offset(-PADDING_5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLabel);
        make.bottom.lessThanOrEqualTo(weakSelf.iconImageView).offset(-8).priorityHigh();
    }];
    
    [_deadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.left.equalTo(self.titleLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(22);
        make.left.equalTo(weakSelf.titleLabel.mas_left);
    }];
    
    [_scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.courseLabel);
        make.left.equalTo(weakSelf.courseLabel.mas_right).offset(PADDING_15);
        make.right.lessThanOrEqualTo(weakSelf.contentView.mas_right).offset(-1);
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.model.videoType == HKVideoType_PGC) {
            make.top.equalTo(weakSelf.courseLabel.mas_bottom).offset(PADDING_5);
            make.left.equalTo(weakSelf.courseLabel);
        }else{
            make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(PADDING_5);
            make.left.equalTo(weakSelf.timeLabel);
        }
    }];
}




- (HKCustomMarginLabel*)deadlineLabel {
    
    if (!_deadlineLabel) {
        _deadlineLabel  = [[HKCustomMarginLabel alloc] init];
        _deadlineLabel.textColor = COLOR_3D8BFF;
        _deadlineLabel.textAlignment = NSTextAlignmentCenter;
        _deadlineLabel.font = HK_FONT_SYSTEM(12);
        _deadlineLabel.backgroundColor = COLOR_EEF5FF;
        _deadlineLabel.clipsToBounds = YES;
        _deadlineLabel.layer.cornerRadius = 10;
        _deadlineLabel.textInsets = UIEdgeInsetsMake(2, 7, 2, 7);
    }
    return _deadlineLabel;
}


- (void)setDeadlineTitleByModel:(VideoModel *)model {
    
    //is_show_deadline; //is_show_deadline:是否显示7天有效 1-显示 0-不显示
    if ([model.is_show_deadline isEqualToString:@"1"]) {
        _deadlineLabel.text = @"七天内可重复学习";// @"七天有效";
        _deadlineLabel.hidden = NO;
    }else{
        _deadlineLabel.text = nil;
        _deadlineLabel.hidden = YES;
    }
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



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_A8ABBE];
        _categoryLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [[UILabel alloc] init];
        [_sizeLabel setTextColor:COLOR_A8ABBE];
        _sizeLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:COLOR_A8ABBE];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}


- (UILabel*)progressLabel {
    
    if (!_progressLabel) {
        _progressLabel  = [[UILabel alloc] init];
        [_progressLabel setTextColor:COLOR_A8ABBE];
        _progressLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
        _progressLabel.hidden = YES;
    }
    return _progressLabel;
}


- (UILabel*)scanLabel {
    
    if (!_scanLabel) {
        _scanLabel  = [[UILabel alloc] init];
        [_scanLabel setTextColor:COLOR_A8ABBE];
        _scanLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _scanLabel;
}

- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel  = [[UILabel alloc] init];
        [_courseLabel setTextColor:COLOR_A8ABBE];
        _courseLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _courseLabel;
}



- (UIButton*)selectBtn {
    
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_selectBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setEnlargeEdgeWithTop:PADDING_30 right:PADDING_30 bottom:PADDING_30 left:PADDING_5];
    }
    return _selectBtn;
}




- (UIView*)cellBgView {
    if (!_cellBgView) {
        _cellBgView = [UIView new];
    }
    return _cellBgView;
}



- (void)checkboxClick:(UIButton*)btn {
    self.model.isCellSelected = !self.model.isCellSelected;
    btn.selected = self.model.isCellSelected;
    self.learnedCellBlock ?self.learnedCellBlock(self.model) :nil;
}


/**编辑状态下 点击 cell 选中 */
- (void)editSelectRow {
    [self checkboxClick:self.selectBtn];
}



- (void)setModel:(VideoModel *)model {
    
    _model = model;
    [self setDeadlineTitleByModel:model];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 if (image != nil) {
                                     //裁剪图片圆角
                                     self.iconImageView.image = [image roundCornerImageWithRadius:8];
                                 }
    }];

    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _timeLabel.text = isEmpty(model.video_duration) ?nil  :[NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    _progressLabel.text = isEmpty(model.study_info) ?nil  :[NSString stringWithFormat:@"%@",model.study_info];
    
    _courseLabel.text = isEmpty(model.curriculum_total) ?nil  :[NSString stringWithFormat:@"%@节课",model.curriculum_total];
    self.selectBtn.selected = self.model.isCellSelected;
}





@end





