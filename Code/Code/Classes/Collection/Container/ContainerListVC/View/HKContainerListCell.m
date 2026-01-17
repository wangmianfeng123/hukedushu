
//
//  HKContainerListCell.m
//  Code
//
//  Created by Ivan li on 2017/11/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKContainerListCell.h"
#import "HKContainerModel.h"
#import "HKAlbumShadowImageView.h"


@interface HKContainerListCell()
/** 封面 */
@property(nonatomic,strong)UIImageView *coverImageView;
/** 头像 */
@property(nonatomic,strong)UIImageView *iconImageView;
/** 专辑标题 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *nameLabel;
/** 收藏数 */
@property(nonatomic,strong)UILabel *collectLabel;
/** 课程数 */
@property(nonatomic,strong)UILabel *couseLabel;

@property(nonatomic,strong)UILabel *lineLabel;

@property(nonatomic,strong)UILabel *bottomLineLabel;
@end



@implementation HKContainerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKContainerListCell";
    HKContainerListCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = [[HKContainerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.collectLabel];
        [self.contentView addSubview:self.couseLabel];
        [self.contentView addSubview:self.lineLabel];
        [self.contentView addSubview:self.bottomLineLabel];
        
        [self.contentView insertSubview:self.bgImageView belowSubview:self.coverImageView];
        [self hkDarkModel];
    }
    return self;
}



- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.couseLabel.textColor = COLOR_A8ABBE_7B8196;
    self.collectLabel.textColor = COLOR_A8ABBE_7B8196;
    self.bottomLineLabel.backgroundColor = [self separatorLineBGColor];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(_coverImageView).offset(-PADDING_10);
//        make.right.bottom.equalTo(_coverImageView);
        make.top.equalTo(_coverImageView).offset(-9);
        make.right.left.bottom.equalTo(_coverImageView);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(PADDING_25);
        make.left.equalTo(self.contentView.mas_left).offset(23);
        make.size.mas_equalTo(CGSizeMake(285/2, 180/2));
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView);
        make.left.equalTo(self.coverImageView.mas_right).offset(25/2);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-1);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self.titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right);
    }];
    
    [_collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(PADDING_20);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
//    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(0.5, 10));
//        make.centerY.equalTo(_collectLabel);
//        make.left.equalTo(_collectLabel.mas_right).offset(8);
//    }];
    
    [_couseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_collectLabel);
        make.left.equalTo(_collectLabel.mas_right).offset(PADDING_15);
    }];
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(33/2);
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 3;
    }
    return _coverImageView;
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
        _iconImageView.layer.cornerRadius = 10;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font =  HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 16:15);
        _titleLabel.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ?16:15) weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _nameLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _nameLabel;
}



- (UILabel*)couseLabel {
    if (!_couseLabel) {
        _couseLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _couseLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _couseLabel;
}



- (UILabel*)collectLabel {
    if (!_collectLabel) {
        _collectLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _collectLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _collectLabel;
}

- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = COLOR_CFCFD9;
    }
    return _lineLabel;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA;
    }
    return _bottomLineLabel;
}


- (void)setModel:(HKAlbumModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    //[_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    _couseLabel.text = [NSString stringWithFormat:@"%@人收藏",isEmpty(model.collect_num) ?@"0" :model.collect_num];
    _collectLabel.text = [NSString stringWithFormat:@"%@节课",isEmpty(model.video_num)? @"0" :model.video_num];
}


@end


