//
//  CollectionCell.m
//  Code
//
//  Created by Ivan li on 2017/8/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CollectionCell.h"
#import "VideoModel.h"
#import "HomeVideloCell.h"
#import "VideoModel.h"
  
#import "DownloadModel.h"
#import "DownloadManager+Utils.h"
#import "DownloadCacher.h"

#import "HKLineLabel.h"
#import "HKAlbumShadowImageView.h"




@interface CollectionCell()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

/******************** PGC *********************/
/** 讲师头像 */
@property(nonatomic,strong)UIImageView *techImageView;

@property(nonatomic,strong)UILabel *nameLabel;
/** 当前售价 */
@property(nonatomic,strong)UILabel *priceLabel;
/** 原价 */
@property(nonatomic,strong)HKLineLabel *oldPriceLabel;
/** 折扣标签 */
@property(nonatomic,strong)UIImageView *discountImageView;


@end




@implementation CollectionCell


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
    [self.contentView addSubview:self.watchLabel];
    
    //PGC
    [self.contentView addSubview:self.techImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.oldPriceLabel];
    [self.contentView addSubview:self.discountImageView];
    
    [self.contentView insertSubview:self.bgImageView belowSubview:self.iconImageView];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.watchLabel.textColor = COLOR_A8ABBE_7B8196;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(_isShowShadow ? 0:-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_10);
        make.top.equalTo(self.contentView).offset(PADDING_10);
        make.bottom.equalTo(self.contentView).offset(-PADDING_10);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(25 * 0.5);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-PADDING_5);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.sizeLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(self.titleLabel);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-PADDING_10);
    }];
    
    /****************  PGC  ****************/
    [_techImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.techImageView.mas_right).offset(PADDING_5);
        make.centerY.equalTo(self.techImageView);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-PADDING_10);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(PADDING_10 * 0.5);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [_discountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.centerY.equalTo(self.oldPriceLabel);
    }];
}


- (HKAlbumShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKAlbumShadowImageView alloc]init];
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}

- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 3.0;
    }
    return _iconImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [[UILabel alloc] init];
        [_categoryLabel setTextColor:COLOR_999999];
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [[UILabel alloc] init];
        [_sizeLabel setTextColor:COLOR_999999];
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        [_timeLabel setTextColor:HKColorFromHex(0xA8ABBE, 1.0)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}



- (UIImageView*)techImageView {
    if (!_techImageView) {
        _techImageView = [[UIImageView alloc]init];
        _techImageView.clipsToBounds = YES;
        _techImageView.layer.cornerRadius = PADDING_25/2;
    }
    return _techImageView;
}

- (UIImageView*)discountImageView {
    if (!_discountImageView) {
        _discountImageView = [[UIImageView alloc]init];
        _discountImageView.image = imageName(@"special_orange");
        _discountImageView.contentMode = UIViewContentModeScaleAspectFit;
        _discountImageView.hidden = YES;
        
    }
    return _discountImageView;
}


- (UILabel*)watchLabel {
    if (!_watchLabel) {
        _watchLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:HKColorFromHex(0xA8ABBE, 1.0) titleFont:nil titleAligment:NSTextAlignmentLeft];
        _watchLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _watchLabel.hidden = YES;
    }
    return _watchLabel;
}

- (UILabel*)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:HKColorFromHex(0x666666, 1.0) titleFont:nil titleAligment:NSTextAlignmentLeft];
        _nameLabel.font = HK_FONT_SYSTEM(13);
    }
    return _nameLabel;
}


- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor colorWithHexString:@"FF7E00"] titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.font = HK_FONT_SYSTEM(13);
    }
    return _priceLabel;
}



- (HKLineLabel*)oldPriceLabel {
    
    if (!_oldPriceLabel) {
        _oldPriceLabel  = [HKLineLabel new];
        _oldPriceLabel.textColor = COLOR_999999;
        _oldPriceLabel.strikeThroughEnabled = YES;
        _oldPriceLabel.strikeThroughColor = COLOR_999999;
        _oldPriceLabel.font = HK_FONT_SYSTEM(11);
    }
    return _oldPriceLabel;
}







- (void)setModel:(VideoModel *)model {
    
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.video_titel];
    _categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
    _sizeLabel.text = [NSString stringWithFormat:@"难度：%@",model.viedeo_difficulty];
    _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
}


- (void)setListModel:(CollectionListModel *)listModel {
    
    _listModel = listModel;
    NSInteger type = [listModel.type integerValue];
    VideoModel *model = (type == 1) ?listModel.class_1 :listModel.class_2;
    [self hiddenControls:type];
    
    if (type == 1) {
        _bgImageView.hidden = YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.video_titel];
//        _categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
//        _sizeLabel.text = [NSString stringWithFormat:@"难度：%@",model.viedeo_difficulty];
        
        //_watchLabel.text = isEmpty(model.watch_nums)? nil :[NSString stringWithFormat:@"%@人观看",model.watch_nums];
        _watchLabel.text = isEmpty(model.video_play)? nil :[NSString stringWithFormat:@"%@人观看",model.video_play];
        _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    }else{
        //PGC
        _bgImageView.hidden = NO;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];
        
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
        _nameLabel.text = model.name;
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.now_price];
        [_techImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
        if (!isEmpty(model.discount_price)) {
            _oldPriceLabel.text = model.discount_price;
        }
        _discountImageView.hidden = isEmpty(model.discount_price);
    }
}


// 1- 普通。 2-PGC
- (void)hiddenControls:(NSInteger)type {
    
    BOOL showVip = !(type == 1);
    BOOL showPgc = !(type == 2);
    //PGC 课
    _techImageView.hidden = showPgc;
    _oldPriceLabel.hidden = showPgc;
    _discountImageView.hidden = showPgc;
    _priceLabel.hidden = showPgc;
    _nameLabel.hidden = showPgc;
    _watchLabel.hidden = showPgc;

    //VIP 课
    _categoryLabel.hidden = showVip;
    _sizeLabel.hidden = showVip;
    _timeLabel.hidden = showVip;
}


@end














