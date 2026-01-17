
//
//  HomeVideoCollectionCell.m
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeVideoCollectionCell.h"
#import "VideoModel.h"

#import "HKCoverBaseIV.h"

@interface HomeVideoCollectionCell()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic , strong) HKCustomMarginLabel * updateLabel;
@end



@implementation HomeVideoCollectionCell

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        //_coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 5.0;
    }
    return _coverImageView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self makeConstraints];
    }
    return self;
}

-(HKCustomMarginLabel *)updateLabel{
    if (_updateLabel == nil) {
        _updateLabel  = [[HKCustomMarginLabel alloc] init];
        _updateLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _updateLabel.textColor = [UIColor colorWithHexString:@"#3D8BFF"];
        _updateLabel.font = HK_FONT_SYSTEM(11);
        _updateLabel.textAlignment = NSTextAlignmentCenter;
        _updateLabel.backgroundColor = [UIColor colorWithHexString:@"#EEF5FF"];
        _updateLabel.clipsToBounds = YES;
        _updateLabel.layer.cornerRadius = 7.5;
    }
    return _updateLabel;
}


- (void)createUI {
    self.tb_hightedLigthedInset = UIEdgeInsetsMake(0, 0, 18, 0);
    self.tb_hightedLigthedIndex = CollectionViewIndexFont;
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.seapratorView];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectionBtn];
    [self.contentView addSubview:self.updateLabel];
    [self hkDarkModel];
    
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor =[UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_7B8196];
    self.sizeLabel.textColor =[UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_7B8196];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}


- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        //make.top.equalTo(weakSelf.contentView);
        //make.height.mas_equalTo(211);
        make.height.mas_equalTo(IS_IPAD ? 143 : 211);
        make.left.equalTo(self.contentView).mas_offset(5);
        make.right.equalTo(self.contentView).mas_offset(-5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(7);
        make.left.equalTo(self.iconImageView);
        make.right.equalTo(self.iconImageView.mas_right);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.mas_top);
        make.left.equalTo(self.sizeLabel.mas_right).offset(20);
    }];
    
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_lessThanOrEqualTo(CGSizeMake(25, 25));
        //make.right.mas_equalTo(self.contentView).mas_offset(-6);
        //make.centerY.mas_equalTo(self.timeLabel).mas_offset(-5);
        make.bottom.equalTo(self.sizeLabel);
        make.right.mas_equalTo(self.iconImageView);
    }];
    
    [self.seapratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(8);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
}

- (UIView *)seapratorView {
    
    if (_seapratorView == nil) {
        _seapratorView = [[UIView alloc] init];
        _seapratorView.hidden = YES;
        _seapratorView.backgroundColor = COLOR_F6F6F6;
    }
    return _seapratorView;
}




- (HKCoverBaseIV*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[HKCoverBaseIV alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5.0;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _titleLabel;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_A8ABBE];
        
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
        //[_collectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_collectionBtn setHKEnlargeEdge:25];
    }
    return _collectionBtn;
}



- (void)collectionBtnClick {
    
    [MobClick event:UM_RECORD_HOME_NEW_COLLECT_VIDEO];
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
        [_sizeLabel setTextColor:COLOR_A8ABBE];
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
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





- (void)updatePadConstraint {
//    BOOL isLeftCell = (self.indexPath.row + 1) % 4 == 1;
//    BOOL isRightCell = (self.indexPath.row + 1) % 4 == 0;
    WeakSelf;
    [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (IS_IPAD) { // iPad
//            if (isLeftCell) {// 左边cell
//                make.left.equalTo(weakSelf.contentView).mas_offset(16);
//                make.right.equalTo(weakSelf.contentView).mas_offset(-8);
//            } else if (isRightCell) {// 右边cell
//                make.left.equalTo(weakSelf.contentView).mas_offset(8);
//                make.right.equalTo(weakSelf.contentView).mas_offset(-16);
//            }else{
//                make.left.equalTo(weakSelf.contentView).mas_offset(12);
//                make.right.equalTo(weakSelf.contentView).mas_offset(-12);
//            }
//        } else { // iPhone
            make.left.equalTo(weakSelf.contentView).mas_offset(5);
            make.right.equalTo(weakSelf.contentView).mas_offset(-5);
//        }
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconImageView);
    }];
    
    if (self.model.is_normal_video) {
        [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.left.equalTo(self.titleLabel);
        }];
    }else{
        [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
            make.left.equalTo(self.titleLabel).offset(50);
        }];
    }
    
    [self.updateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.sizeLabel.mas_centerY);
        make.height.mas_equalTo(15);
    }];
}

- (void)setModel:(VideoModel *)model {
    
    _model = model;
    NSString *url = model.img_cover_url.length? model.img_cover_url : model.img_cover_url_big;
//    url = [NSString stringWithFormat:@"%@!/fw/720/format/webp",url];
    NSLog(@"model.img_cover_url =====1 %@",url);
    [self.coverImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:url]) placeholderImage:[UIImage createImageWithColor:COLOR_F8F9FA_333D48]];
        
    self.iconImageView.courseCount = model.total_course;
    // 图文
    self.iconImageView.hasPictext = !model.has_pictext;

    _titleLabel.text = [NSString stringWithFormat:@"%@",model.video_titel];
    _categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
    
    if (self.model.is_normal_video) {
        _sizeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    }else{
        _sizeLabel.text = [NSString stringWithFormat:@"共%@节课",model.video_total];
    }
    
    
    /// v2.17 隐藏观看人数
    //_timeLabel.text = [NSString stringWithFormat:@"%@人观看",model.video_play];
    
    // 收藏
    self.collectionBtn.selected = model.is_collect;
    
    // 根据实际更新设置iPhone iPad的约束
    [self updatePadConstraint];
    
    if ([self.model.is_end isEqualToString:@"1"]) {
        self.updateLabel.text = @"已完结";
    }else{
        self.updateLabel.text = @"更新中";
    }
    self.updateLabel.hidden = self.model.is_normal_video ? YES : NO;
}





@end
