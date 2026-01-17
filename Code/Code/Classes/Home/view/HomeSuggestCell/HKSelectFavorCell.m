//
//  HKSelectFavorCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSelectFavorCell.h"

@interface HKSelectFavorCell()

@property (weak, nonatomic) IBOutlet UIImageView *interestIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@end

@implementation HKSelectFavorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 点击事件
    self.interestIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interestIVClick)];
    [self.interestIV addGestureRecognizer:tap];
    
    self.titleLB.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
    
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)interestIVClick {
    
    !self.clickIVClickBlock? : self.clickIVClickBlock();
}

- (void)clickIVClick {
    
    !self.clickIVClickBlock? : self.clickIVClickBlock();
}

// 隐藏设计兴趣
- (void)setHiddenClick:(BOOL)hidden {
    self.interestIV.hidden = hidden;
}

@end
