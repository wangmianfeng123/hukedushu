//
//  HKRookieCell.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKRookieCell.h"
#import "SoftwareModel.h"
#import <YYText/YYText.h>
#import <YYText/YYTextContainerView.h>



@interface HKRookieCell()

@property(nonatomic,strong)UIImageView     *iconImageView;
@property(nonatomic,strong)UILabel     *categoryLabel;

@property(nonatomic,strong)YYLabel     *courseNumLabel;
@property(nonatomic,strong)UILabel     *exerciseNumLabel;
@property(nonatomic,strong)UILabel     *lineLabel;

@end


@implementation HKRookieCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 6.0;
    self.layer.borderColor = HKColorFromHex(0xeeeeee, 1.0).CGColor;
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.iconImageView];
    [self addSubview:self.categoryLabel];
    
    [self addSubview:self.courseNumLabel];
    [self addSubview:self.exerciseNumLabel];
    [self addSubview:self.lineLabel];
}

- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(PADDING_15);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.height.mas_lessThanOrEqualTo(PADDING_20*2);
    }];
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
    }];
    [_courseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.categoryLabel.mas_bottom).offset(6);
        make.centerX.equalTo(weakSelf);
    }];
    
//    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(1);
//        make.height.mas_equalTo(10);
//        make.centerY.equalTo(weakSelf.courseNumLabel);
//        make.centerX.equalTo(weakSelf);
//    }];
    
    [_exerciseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.courseNumLabel);
        make.left.equalTo(weakSelf.lineLabel.mas_right).offset(8);
        make.right.equalTo(weakSelf);
    }];

}





- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:HKColorFromHex(0x27323F, 1.0)
                                        titleFont:IS_IPHONE6PLUS ?@"16" :@"15" titleAligment:NSTextAlignmentCenter];
    }
    return _categoryLabel;
}

- (YYLabel *)courseNumLabel {
    
    if (!_courseNumLabel) {
        _courseNumLabel = [[YYLabel alloc] init];
        _courseNumLabel.font = IS_IPHONE6PLUS? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:11];
        _courseNumLabel.textColor = HKColorFromHex(0xA8ABBE, 1.0);
        _courseNumLabel.numberOfLines = 1;
        _courseNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _courseNumLabel;
}


- (UILabel*)exerciseNumLabel {
    
    if (!_exerciseNumLabel) {
        _exerciseNumLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:HKColorFromHex(0xA8ABBE, 1.0)
                                         titleFont:IS_IPHONE6PLUS ?@"12" :@"11" titleAligment:NSTextAlignmentLeft];
        _exerciseNumLabel.numberOfLines = 1;
        _exerciseNumLabel.hidden = YES;
    }
    return _exerciseNumLabel;
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = HKColorFromHex(0xEFEFF6, 1.0);
    }
    return _lineLabel;
}



- (void)setModel:(SoftwareModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    _categoryLabel.text = model.name;
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:11];
    NSMutableAttributedString *attachment = nil;
    
    // 多少人观看
    NSString *countString = [NSString stringWithFormat:@"%@课  ", model.master_video_total];
    attachment = [[NSMutableAttributedString alloc] initWithString:countString];
    [attachment addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, countString.length)];
    [attachment addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:NSMakeRange(0, countString.length)];
    [text appendAttributedString:attachment];
    
    // 嵌入 分割线2
    
    UIImage *image = [UIImage coustomSizeImageWithColor:HKColorFromHex(0xEFEFF6, 1.0) size:CGSizeMake(1, 9)];
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeBottom attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString: attachment];
    
    // 多少练习
    NSString *practiceString = [NSString stringWithFormat:@"  %@练习", model.slave_video_total];
    attachment = [[NSMutableAttributedString alloc] initWithString:practiceString];
    [attachment addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, practiceString.length)];
    [attachment addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:NSMakeRange(0, practiceString.length)];
    [text appendAttributedString:attachment];
    
    _courseNumLabel.attributedText = text;
    
    _exerciseNumLabel.text =[NSString stringWithFormat:@"%@练习", model.slave_video_total];
}

@end

















