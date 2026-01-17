//
//  HKPgcCategoryCell.m
//  Code
//
//  Created by Ivan li on 2017/12/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPgcCategoryCell.h"
#import "HKPgcCategoryModel.h"
#import "HKLineLabel.h"

@interface HKPgcCategoryCell()

@property(nonatomic,strong)UIImageView *iconImageView;
/** 讲师头像 */
@property(nonatomic,strong)UIImageView *techImageView;
/** 视频标题 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *nameLabel;
/** 当前售价 */
@property(nonatomic,strong)UILabel *priceLabel;
/** 原价 */
//@property(nonatomic,strong)UILabel *oldPriceLabel;
@property(nonatomic,strong)HKLineLabel *oldPriceLabel;
/** 折扣标签 */
@property(nonatomic,strong)UIImageView *discountImageView;

@end


@implementation HKPgcCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    
    HKPgcCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKPgcCategoryCell"];
    if (!cell) {
        cell = [[HKPgcCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKPgcCategoryCell"];
    }
    return cell;
}




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
    [self.contentView addSubview:self.techImageView];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.oldPriceLabel];
    [self.contentView addSubview:self.discountImageView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(PADDING_15);
        make.left.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
    }];
    
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
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(PADDING_10);
        make.centerY.equalTo(weakSelf.priceLabel);
    }];
    
    [_discountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-13);
        make.centerY.equalTo(weakSelf.oldPriceLabel);
    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
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


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ? 16:15);
    }
    return _titleLabel;
}

- (UILabel*)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _nameLabel.font = HK_FONT_SYSTEM(12);
    }
    return _nameLabel;
}


- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor colorWithHexString:@"ff6600"] titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.font = HK_FONT_SYSTEM(15);
    }
    return _priceLabel;
}



- (HKLineLabel*)oldPriceLabel {
    
    if (!_oldPriceLabel) {
        _oldPriceLabel  = [HKLineLabel new];
        _oldPriceLabel.textColor = COLOR_999999;
        _oldPriceLabel.strikeThroughEnabled = YES;
        _oldPriceLabel.strikeThroughColor = COLOR_999999;
        //[HKLineLabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _oldPriceLabel.font = HK_FONT_SYSTEM(15);
    }
    return _oldPriceLabel;
}




- (void)setModel:(HKPgcCourseModel *)model {
    
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    _nameLabel.text = model.name;
    _priceLabel.text = model.now_price;
    [_techImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    if (!isEmpty(model.discount_price)) {
        _oldPriceLabel.text = model.discount_price;
    }
    _discountImageView.hidden = isEmpty(model.discount_price);
}

@end














