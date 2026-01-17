//
//  vipBgCell.m
//  Code
//
//  Created by Ivan li on 2017/9/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "vipBgCell.h"

@interface vipBgCell()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIImageView *iconImageViewSmall;

@end

@implementation vipBgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)createUI {
    
    self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#2f2f2f"];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.iconImageViewSmall];
    [self.iconImageView addSubview:self.titleLabel];
    [self.iconImageView addSubview:self.priceLabel];
    [self.iconImageView addSubview:self.infoLabel];
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(23, 15, 15, 15));
    }];
    
    [self.iconImageViewSmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(_iconImageView.mas_top).offset(17);
        make.left.mas_equalTo(_iconImageView.mas_left).offset(15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageViewSmall);
        make.left.equalTo(self.iconImageViewSmall).offset(8);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.iconImageView).mas_offset(-23);
        make.bottom.equalTo(weakSelf.iconImageView).mas_offset(17);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_20);
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-35);
    }];
}


- (UIImageView*)iconImageViewSmall {
    if (!_iconImageViewSmall) {
        _iconImageViewSmall = [[UIImageView alloc]init];
        _iconImageViewSmall.image = imageName(@"all_platform_avator");
    }
    return _iconImageViewSmall;
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = imageName(@"vip_bg");
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"全站通VIP"
                                    titleColor:[UIColor whiteColor]
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    }
    return _titleLabel;
}



- (UILabel*)priceLabel {
    if (!_priceLabel) {
        _priceLabel  = [UILabel labelWithTitle:CGRectZero title:@"¥298/年"
                                    titleColor:[UIColor colorWithHexString:@"#333333"]
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19:18];
    }
    return _priceLabel;
}


- (UILabel*)infoLabel {
    if (!_infoLabel) {
        _infoLabel  = [UILabel labelWithTitle:CGRectZero title:@"全站教程，无限学习，无限下载"
                                    titleColor:[UIColor colorWithHexString:@"#333333"]
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15];
    }
    return _infoLabel;
}



@end
