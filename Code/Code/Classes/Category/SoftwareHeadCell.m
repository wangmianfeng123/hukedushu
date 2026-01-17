

//
//  SoftwareHeadCell.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SoftwareHeadCell.h"
#import "SoftwareModel.h"

@interface SoftwareHeadCell ()

@property(nonatomic,strong)UIImageView     *iconImageView;

@end


@implementation SoftwareHeadCell




- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = imageName(@"soft_head");
    }
    return _iconImageView;
}

- (void)setModel:(SoftwareModel *)model {
    //[_iconImageView sd_setImageWithURL:model.small_img_url placeholderImage:imageName(HK_Placeholder)];
}

@end
