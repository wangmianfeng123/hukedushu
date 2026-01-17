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
    [self.iconImageView addSubview:self.titleLabel];
    [self.iconImageView addSubview:self.priceLabel];
    [self.iconImageView addSubview:self.infoLabel];
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView).offset(PADDING_30);
        make.left.equalTo(weakSelf.iconImageView).offset(PADDING_30);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.iconImageView.mas_right).offset(-PADDING_15);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_20);
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-35);
    }];
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
                                    titleColor:[UIColor colorWithHexString:@"#333333"]
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19:18];
        [_titleLabel sizeToFit];
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
