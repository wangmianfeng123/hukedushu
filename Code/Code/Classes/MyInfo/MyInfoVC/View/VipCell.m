//
//  VipCell.m
//  Code
//
//  Created by Ivan li on 2017/9/6.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "VipCell.h"



@interface VipCell()

@property(nonatomic,strong)UIImageView *vipImageView;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UILabel *vipLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *countLabel;

@property(nonatomic,strong)UILabel *vipTipLabel;

@end



@implementation VipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}


- (void)createUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [self.contentView addSubview:self.vipImageView];
    [self.contentView addSubview:self.vipLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.vipTipLabel];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    WeakSelf;
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45/2, 37/2));
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-18);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.vipTipLabel mas_makeConstraints:^(MASConstraintMaker *make) { make.right.mas_equalTo(weakSelf.arrowImageView.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(weakSelf.arrowImageView);
    }];
    
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.vipImageView.mas_right).offset(13);
//        make.right.top.bottom.mas_equalTo(weakSelf.contentView);
//        make.right.mas_equalTo(weakSelf.contentView);
//        make.height.mas_equalTo(18.0);
        make.centerY.mas_equalTo(_vipImageView);
    }];
    
//    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.vipLabel.mas_right).offset(0);
//        make.top.equalTo(weakSelf.vipLabel);
//        //make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_20*2);
//    }];
//
//    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.vipLabel);
//        make.top.equalTo(weakSelf.vipLabel.mas_bottom).offset(PADDING_5);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-PADDING_20);
//    }];
}


- (UILabel *)vipTipLabel {
    
    if (_vipTipLabel == nil) {
        _vipTipLabel = [[UILabel alloc] init];
        _vipTipLabel.font = [UIFont systemFontOfSize:11];
        _vipTipLabel.textColor = HKColorFromHex(0xFF6400, 1.0);
    }
    return _vipTipLabel;
}

- (UIImageView*)vipImageView{
    
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.image = imageName(@"crown_yellow_small");
    }
    return _vipImageView;
}

- (UIImageView*)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = imageName(@"arrow_right_gray");
    }
    return _arrowImageView;
}



- (UILabel*)vipLabel {
    
    if (!_vipLabel) {
        
        UILabel *label = [UILabel new];
        label.text = @"VIP中心";
        label.textColor = COLOR_27323F;
        [label setTextAlignment:NSTextAlignmentLeft];
        _vipLabel = label;
        _vipLabel.font = HK_FONT_SYSTEM(15);
    }
    return _vipLabel;
}


- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTitle:CGRectZero title:@"(低至约0.8/天)"
                                 titleColor:[UIColor colorWithHexString:@"#333333"]
                                  titleFont:(IS_IPHONE6PLUS ? @"14" :@"13") titleAligment:NSTextAlignmentLeft];
        
    }
    
    NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:[UIColor colorWithHexString:@"#ff353f"]
                                                                                 TotalString:@"(低至约0.8/天)"
                                                                              SubStringArray:@[@"0.8"]];
    [_priceLabel setAttributedText:attributed];
    _priceLabel.hidden = YES;
    return _priceLabel;
}


- (UILabel*)countLabel {
    
    if (!_countLabel) {
        _countLabel = [UILabel labelWithTitle:CGRectZero title:@"全站海量视频无限学习"
                                   titleColor:COLOR_27323F
                                    titleFont:(IS_IPHONE6PLUS ? @"15" :@"14") titleAligment:NSTextAlignmentLeft];
        
    }
    _countLabel.hidden = YES;
    return _countLabel;
}

- (void)setStringVipTip:(NSString *)tipString {
    if (tipString.length > 0) {
        self.vipTipLabel.hidden = NO;
        self.vipTipLabel.text = tipString;
    } else {
        self.vipTipLabel.hidden = YES;
    }
}



@end
