//
//  HKAdsCell.m
//  Code
//
//  Created by Ivan li on 2018/1/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAdsCell.h"
#import "BannerModel.h"


@interface HKAdsCell ()
/** 广告 图片 */
@property(strong,nonatomic)UIImageView  *adImageView;

@end


@implementation HKAdsCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self set_DMContentViewBGColor];
        [self.contentView addSubview:self.adImageView];
        
        if (IS_IPAD) {
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.center.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }else{
            [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(PADDING_15*Ratio);
                make.right.equalTo(self.contentView).offset(-PADDING_15*Ratio);
            }];
        }
    }
    return self;
}

- (UIImageView*)adImageView {
    if (!_adImageView) {
        _adImageView = [UIImageView new];
        _adImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _adImageView;
}


- (void)setModel:(HKMapModel *)model {
    
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_url]] placeholderImage:imageName(HK_Placeholder)];
}

@end






