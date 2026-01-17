//
//  DCFeatureHeaderView.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureHeaderView.h"

#import "DCFeatureTitleItem.h"


CGFloat const DCMargin = 15;

@interface DCFeatureHeaderView ()
/* 属性标题 */
@property (strong , nonatomic)UILabel *headerLabel;
/* 底部View */
@property (strong , nonatomic)UIView *bottomView;



@end

@implementation DCFeatureHeaderView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _headerLabel = [UILabel new];
    _headerLabel.font = [UIFont systemFontOfSize:15];
    _headerLabel.textColor = COLOR_27323F;
    [self addSubview:_headerLabel];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [self addSubview:_bottomView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        make.centerY.mas_equalTo(self);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DCMargin);
        make.right.mas_equalTo(-DCMargin);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark - Setter Getter Methods
- (void)setHeadTitle:(DCFeatureTitleItem *)headTitle
{
    _headTitle = headTitle;
    _headerLabel.text = headTitle.attrname;
}


- (void)setHeaderName:(NSString *)headerName
{
    _headerName = headerName;
    _headerLabel.text = headerName;
}




@end
