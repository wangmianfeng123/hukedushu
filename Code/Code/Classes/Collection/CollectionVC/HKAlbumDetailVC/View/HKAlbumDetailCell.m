//
//  HKAlbumDetailCell.m
//  Code
//
//  Created by Ivan li on 2018/8/29.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAlbumDetailCell.h"
#import "VideoModel.h"
#import "VideoModel.h"
#import "HKLineLabel.h"
#import "HKAlbumShadowImageView.h"



@interface HKAlbumDetailCell()

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




@implementation HKAlbumDetailCell


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
    self.categoryLabel.textColor = COLOR_A8ABBE_7B8196;
    self.sizeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(_isShowShadow ? 0:-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_15);
        make.width.mas_equalTo(IS_IPHONE5S ?150:160);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(25 * 0.5);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(13);
        make.left.right.equalTo(weakSelf.titleLabel);
    }];
    
    
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.greaterThanOrEqualTo(weakSelf.sizeLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(weakSelf.categoryLabel.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(-5);
    }];
    
    /****************  PGC  ****************/
    [_techImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(weakSelf.titleLabel);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.techImageView.mas_right).offset(PADDING_5);
        make.centerY.equalTo(weakSelf.techImageView);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-PADDING_10);
        make.left.equalTo(weakSelf.titleLabel.mas_left);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(PADDING_10 * 0.5);
        make.centerY.equalTo(weakSelf.priceLabel);
    }];
    
    [_discountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-13);
        make.centerY.equalTo(weakSelf.oldPriceLabel);
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
        _iconImageView.layer.cornerRadius = PADDING_5;
    }
    return _iconImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_27323F;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [UILabel new];
        _categoryLabel.textColor = COLOR_A8ABBE;
        _categoryLabel.textAlignment = NSTextAlignmentLeft;
        _categoryLabel.font = HK_FONT_SYSTEM(13);
    }
    return _categoryLabel;
}


#pragma mark - 视频大小
- (UILabel*)sizeLabel {
    
    if (!_sizeLabel) {
        _sizeLabel  = [UILabel new];
        _sizeLabel.textColor = COLOR_A8ABBE;
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.font = HK_FONT_SYSTEM(13);
    }
    return _sizeLabel;
}



#pragma mark -时长
- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [UILabel new];
        _timeLabel.textColor = COLOR_A8ABBE;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HK_FONT_SYSTEM(13);
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
    _categoryLabel.hidden = YES;
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
        
        _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.video_duration];
    }else{
        //PGC
        _bgImageView.hidden = NO;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 3;
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
    
    //VIP 课
    _categoryLabel.hidden = showVip;
    _sizeLabel.hidden = showVip;
    _timeLabel.hidden = showVip;
}


@end















