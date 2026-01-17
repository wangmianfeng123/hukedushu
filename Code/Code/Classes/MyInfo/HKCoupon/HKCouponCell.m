//
//  HKCouponCell.m
//  Code
//
//  Created by Ivan li on 2018/1/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCouponCell.h"
#import "HKCouponModel.h"


@interface HKCouponCell()

/** 背景图片*/
@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *priceLabel;
/** 折扣 */
@property(nonatomic,strong)UILabel *discountLabel;
/** 优惠券信息 */
@property(nonatomic,strong)UILabel *couponInfoLabel;
/** 有限期 */
@property(nonatomic,strong)UILabel *timeLabel;
/** 网站使用提示 */
@property(nonatomic,strong)UILabel *tipLabel;



@end

@implementation HKCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)initCellWithTableView:(UITableView *)tableView  {
    
    HKCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKCouponCell"];
    if (!cell) {
        
        cell = [[HKCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKCouponCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.bgImageView];
    
    [self.bgView addSubview:self.priceLabel];
    
    [self.bgView addSubview:self.discountLabel];
    
    [self.bgView addSubview:self.couponInfoLabel];
    
    [self.bgView addSubview:self.timeLabel];
    
    [self.bgView addSubview:self.tipLabel];
}




- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
    
}

- (void)makeConstraints {
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(_bgView);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgImageView.mas_centerY).offset(-PADDING_10);
        //make.centerX.equalTo(_bgImageView);
        make.right.left.equalTo(_bgImageView);
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(PADDING_5);
        make.right.left.equalTo(_bgImageView);
//        make.centerX.equalTo(_priceLabel.mas_centerX);
    }];
    
    [_couponInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView.mas_right).offset(PADDING_10);
        make.top.equalTo(_bgView).offset(PADDING_10);
        make.right.equalTo(_bgView.mas_right).offset(-PADDING_10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_couponInfoLabel);
        make.top.equalTo(_couponInfoLabel.mas_bottom).offset(PADDING_5);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_couponInfoLabel);
        make.right.equalTo(_bgView);
        make.top.equalTo(_timeLabel.mas_bottom).offset(PADDING_15);
        make.bottom.mas_lessThanOrEqualTo(_bgView.mas_bottom).offset(-1);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UIImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
}


- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:(IS_IPHONE6PLUS?@"22":@"20")
                                titleAligment:NSTextAlignmentCenter];
    }
    return _priceLabel;
}


- (UILabel*)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:nil titleAligment:NSTextAlignmentCenter];
        _discountLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ?14 :12);
    }
    return _discountLabel;
}


- (UILabel*)couponInfoLabel {
    if (!_couponInfoLabel) {
        _couponInfoLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _couponInfoLabel.numberOfLines = 2;
    }
    return _couponInfoLabel;
}


- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        
    }
    return _timeLabel;
}

- (UILabel*)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _tipLabel;
}




- (void)setModel:(HKCouponModel *)model {
    
    BOOL isGray = [model.is_gray isEqualToString:@"1"]? YES:NO;
    _bgImageView.image = imageName(isGray ?@"coupon_gray" :@"coupon_red");
    
    if (!isEmpty(model.discount)) {
        NSString *str = [NSString stringWithFormat:@"¥ %@",model.discount];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(12) range:NSMakeRange(0,1)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS?22:20) range:NSMakeRange(1,attrString.length-1)];
        _priceLabel.attributedText = attrString;
    }
    _discountLabel.text = [NSString stringWithFormat:@"满%@可用",model.satisfy_amount];// @"满20可用";
    _couponInfoLabel.text = model.title;
    
    if (!isEmpty(model.expire_time)) {
        NSString *strTime = [NSString stringWithFormat:@"有效期：%@",model.expire_time]; //@"有效期：20111100";
        
        NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:strTime];
        if ([model.expire_time isEqualToString:@"今日到期"]) {
            [timeString addAttribute:NSForegroundColorAttributeName value:COLOR_ff3b30 range:NSMakeRange(4, timeString.length-4)];
        }else{
            [timeString addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(4, timeString.length-4)];
        }
        _timeLabel.attributedText = timeString;
    }
    _tipLabel.text = @"注：请至网站上使用优惠券哦～";
}


@end
