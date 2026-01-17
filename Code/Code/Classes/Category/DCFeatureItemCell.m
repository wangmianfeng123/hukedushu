//
//  DCFeatureItemCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureItemCell.h"

// Controllers

// Models
#import "DCFeatureItem.h"
#import "DCFeatureList.h"
#import "DCSpeedy.h"
// Views

// Vendors

// Categories

// Others

@interface DCFeatureItemCell ()

/* 属性 */
@property (strong , nonatomic)UILabel *attLabel;

@end

@implementation DCFeatureItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI {
    _attLabel = [[UILabel alloc] init];
    _attLabel.textAlignment = NSTextAlignmentCenter;
    _attLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_attLabel];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    [_attLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


#pragma mark - Setter Getter Methods

- (void)setContent:(DCFeatureList *)content {
    
    _content = content;
    _attLabel.text = content.name;
    
    if (content.isSelect) {
        _attLabel.textColor = COLOR_ff7c00;
        _attLabel.backgroundColor = COLOR_FFF6ED;
        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:15 SetBorderWidth:1 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
    }else{
        _attLabel.textColor = COLOR_7B8196;
        _attLabel.backgroundColor = COLOR_F8F9FA;
        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:15 SetBorderWidth:1 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
    }
}



@end


