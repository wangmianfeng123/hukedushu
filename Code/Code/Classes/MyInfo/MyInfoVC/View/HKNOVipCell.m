//
//  VipCell.m
//  Code
//
//  Created by Ivan li on 2017/9/6.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKNOVipCell.h"


@interface HKNOVipCell()

@property(nonatomic,strong)UIImageView *vipImageView;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UILabel *vipLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *countLabel;

@end



@implementation HKNOVipCell

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
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    WeakSelf;
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_15);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(55/2, 45/2));
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-18);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.vipImageView.mas_right).offset(PADDING_15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(PADDING_20);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.vipLabel.mas_right).offset(0);
        make.top.equalTo(weakSelf.vipLabel);
        //make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_20*2);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.vipLabel);
        make.top.equalTo(weakSelf.vipLabel.mas_bottom).offset(PADDING_5);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-PADDING_20);
    }];
}


- (UIImageView*)vipImageView{
    
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.image = imageName(@"crown_yellow");
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
        _vipLabel = [UILabel labelWithTitle:CGRectZero title:@"成为VIP，为学习加速"
                                 titleColor:COLOR_27323F
                                  titleFont:(@"15") titleAligment:NSTextAlignmentLeft];
    }
    return _vipLabel;
}


- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTitle:CGRectZero title:@"(低至约0.8/天)" titleColor:COLOR_27323F
                                  titleFont:(IS_IPHONE6PLUS ? @"14" :@"13") titleAligment:NSTextAlignmentLeft];
        _priceLabel.hidden = YES;
    }
    NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:[UIColor colorWithHexString:@"#ff353f"]
                                                                                 TotalString:@"(低至约0.8/天)"
                                                                              SubStringArray:@[@"0.8"]];
    [_priceLabel setAttributedText:attributed];
    return _priceLabel;
}


- (UILabel*)countLabel {
    if (!_countLabel) {
        //@"全站海量视频无限学习"
        _countLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                    titleFont:(IS_IPHONE6PLUS ? @"12" :@"11") titleAligment:NSTextAlignmentLeft];
    }
    return _countLabel;
}



- (void)setVideoCount:(NSString *)videoCount {
    _videoCount  = videoCount;
    _countLabel.text = isEmpty(videoCount)? nil :[NSString stringWithFormat:@"%@",videoCount];
}


@end
