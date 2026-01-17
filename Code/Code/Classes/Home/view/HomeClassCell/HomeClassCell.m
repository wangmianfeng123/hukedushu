//
//  HomeClassCell.m
//  Code
//
//  Created by Ivan li on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeClassCell.h"
#import "UIView+SNFoundation.h"
#import "CategoryModel.h"
#import "HKVerticalHomeBtn.h"
#import "UIView+SNFoundation.h"


@interface HomeClassCell ()
/* 图片 */
@property (strong , nonatomic)UIImageView *classImageView;
/* 价格 */
@property (strong , nonatomic)UILabel *titleLabel;

@end


@implementation HomeClassCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (UIImageView *)toastImg{
    if (_toastImg == nil) {
        _toastImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast"]];
        [self.contentView addSubview:_toastImg];
    }
    return _toastImg;
}


- (void)setUpUI {
    // 设置高亮的圆角
    self.tb_cornerRadius = 3.0;
    
    [self addSubview:self.classImageView];
//    [self addSubview:self.titleLabel];
    [self addSubview:self.btn];
}

#pragma mark - 布局
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.toastImg.center = CGPointMake(self.width * 0.5, -12);
    
}



- (UIImageView*)classImageView {
    if (!_classImageView) {
        _classImageView = [[UIImageView alloc] init];
        _classImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _classImageView;
}


- (HKVerticalHomeBtn *)btn {
    if (_btn == nil) {
        _btn = [HKVerticalHomeBtn buttonWithType:UIButtonTypeCustom];
        _btn.userInteractionEnabled = NO;
        _btn.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 14 * iPadHRatio : 12.0 * Ratio];
        [_btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    }
    return _btn;
}




- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithTitle:CGRectZero title:@"new" titleColor:[UIColor whiteColor] titleFont:@"12" titleAligment:NSTextAlignmentCenter];
        _tagLabel.backgroundColor = [UIColor blueColor];
        _tagLabel.clipsToBounds = YES;
        _tagLabel.layer.cornerRadius = 6;
    }
    return _tagLabel;
}





- (void)setModel:(HomeCategoryModel *)model {
    
    _model = model;
    [self.btn setTitle:model.name forState:UIControlStateNormal];
    
    [self.btn showTagWithTitle:model.corner_word];
    [_classImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.icon_url]] placeholderImage:imageName(HK_Placeholder)
                              completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.btn setImage:image forState:UIControlStateNormal];
    }];
    
}




@end
