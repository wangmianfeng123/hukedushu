//
//  CategoryCell.m
//  Code
////
//  Created by Ivan li on 2017/8/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"

@interface CategoryCell()

@property(nonatomic,strong)UIImageView     *iconImageView;
/** 小角标 */
@property(nonatomic,strong)UIImageView *angleImageView;
/** 分类标题 */
@property(nonatomic,strong)UILabel     *categoryLabel;

@end





@implementation CategoryCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI{
    self.tb_hightedLigthedIndex = CollectionViewIndexFont;
    self.contentView.layer.cornerRadius = PADDING_5;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.angleImageView];
    
//    CALayer * layer1 = [self layer];
//    [layer1 setShadowOffset:CGSizeMake(3, 3)];//阴影偏移量
//    [layer1 setShadowRadius:PADDING_5];
//    [layer1 setShadowOpacity:0.3];//透明度
//    [layer1 setShadowColor:COLOR_666666.CGColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(55*Ratio, 55*Ratio));
    }];
    [_categoryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView);
    }];
    
    [_angleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(45*Ratio, 45*Ratio));
    }];
    
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 55*Ratio/2;
    }
    return _iconImageView;
}


- (UIImageView*)angleImageView {
    if (!_angleImageView) {
        _angleImageView = [UIImageView new];
        _angleImageView.hidden = YES;
        _angleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _angleImageView;
}



- (UILabel*)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor blackColor]
                                        titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _categoryLabel.numberOfLines = 2;
        _categoryLabel.font = HK_FONT_SYSTEM_BOLD(14);
    }
    return _categoryLabel;
}



- (void)setModel:(CategoryModel *)model {
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_url]] placeholderImage:imageName(HK_Placeholder)];
    //[_categoryLabel setBackgroundColor:[UIColor colorWithHexString:model.color]];
    _categoryLabel.text = model.name;
    
    _angleImageView.hidden = isEmpty(model.corner_icon_url);
    if (!isEmpty(model.corner_icon_url)) {
        [_angleImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.corner_icon_url]]];
    }
}

- (void)setImageWithName:(NSString*)name title:(NSString*)title angleImageName:(NSString*)angleImageName {

    _iconImageView.image = imageName(name);
    _categoryLabel.text = title;
    _categoryLabel.textColor = [UIColor colorWithHexString:@"6C6E87"];
    
    if (!isEmpty(angleImageName)) {
        _angleImageView.hidden = NO;
        _angleImageView.image = imageName(angleImageName);
    }else{

    }
}


@end


