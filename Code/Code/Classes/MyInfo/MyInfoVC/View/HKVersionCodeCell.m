//
//  HKVersionCodeCell.m
//  Code
//
//  Created by Ivan li on 2018/5/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKVersionCodeCell.h"
#import "UIView+SNFoundation.h"


@interface HKVersionCodeCell()

@property (nonatomic,strong) UIImageView *rightIV;

@property (nonatomic,strong) UILabel *versionLabel;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation HKVersionCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString *identif = @"HKVersionCodeCell";
    HKVersionCodeCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKVersionCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}


- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.versionLabel];
    [self.contentView addSubview:self.rightIV];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(35);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.rightIV.mas_left).offset(-4);
        make.left.equalTo(self.bgView.mas_left).offset(PADDING_20);
    }];
    
    [_rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-PADDING_15);
        make.centerY.equalTo(self.bgView);
    }];
    [self setBgViewCorner];
}




/** 设置背景 左侧圆角 */
- (void)setBgViewCorner {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(_bgView.height/2, 0)];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame       = _bgView.bounds;
    borderLayer.path        = maskPath.CGPath;
    _bgView.layer.mask = borderLayer;
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_EBF3FF;
    }
    return _bgView;
}


- (UILabel *)versionLabel {
    
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = HK_FONT_SYSTEM(12);
        _versionLabel.textColor = COLOR_3D8BFF;
        _versionLabel.text = @"当前有新版本可以升级哦";
    }
    return _versionLabel;
}



- (UIImageView*)rightIV{
    
    if (!_rightIV) {
        _rightIV = [[UIImageView alloc]initWithImage:imageName(@"arrow_blue")];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightIV;
}


- (void)setVersion:(NSString*)version {
    _versionLabel.text = version;
}


@end
