//
//  TBCollectionHighLightedCell.h.m
//  TBScrollViewEmpty
//
//  Created by 汤彬 on 2017/11/11.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBHighLightedCell.h"

@interface TBHighLightedCell()

@property (nonatomic, weak)UIView *hightedLigthedBackGround;

@end

@implementation TBHighLightedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (UIView *)hightedLigthedBackGround {
    if (_hightedLigthedBackGround == nil) {
        UIView *hightedLigthedBackGround = [[UIView alloc] init];

        // 默认灰色 透明度为0.5
        hightedLigthedBackGround.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        hightedLigthedBackGround.frame = self.bounds;
        hightedLigthedBackGround.hidden = YES;
        [self addSubview:hightedLigthedBackGround];
        _hightedLigthedBackGround = hightedLigthedBackGround;
    }
    return _hightedLigthedBackGround;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    // 设置高亮颜色
//    if (self.hightedLigthedColor) {
//        self.hightedLigthedBackGround.backgroundColor = self.hightedLigthedColor;
//    }
//
//    // 设置圆角
//    if (self.tb_cornerRadius > 0) {
//        self.hightedLigthedBackGround.clipsToBounds = YES;
//        self.hightedLigthedBackGround.layer.cornerRadius = self.tb_cornerRadius;
//    }
//
//    // 设置偏移量
//    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.tb_hightedLigthedInset)) {
//        self.hightedLigthedBackGround.x = self.hightedLigthedBackGround.x + self.tb_hightedLigthedInset.left;
//        self.hightedLigthedBackGround.y = self.hightedLigthedBackGround.y + self.tb_hightedLigthedInset.top;
//        self.hightedLigthedBackGround.width = self.hightedLigthedBackGround.width - self.tb_hightedLigthedInset.right;
//        self.hightedLigthedBackGround.height = self.hightedLigthedBackGround.height - self.tb_hightedLigthedInset.bottom;
//        // 置空
//        self.tb_hightedLigthedInset = UIEdgeInsetsZero;
//    }
//
//    // 添加到指定层
//    if (highlighted) {
//        switch (self.tb_hightedLigthedIndex) {
//            case 0:
//                [self sendSubviewToBack:self.hightedLigthedBackGround];
//                break;
//            case 1:
//                [self bringSubviewToFront:self.hightedLigthedBackGround];
//                break;
//            case 2:
//                [self.contentView addSubview:self.hightedLigthedBackGround];
//                [self.contentView sendSubviewToBack:self.hightedLigthedBackGround];
//                break;
//            default:
//                break;
//        }
//        self.hightedLigthedBackGround.hidden = NO;
//    }else {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 0.2), dispatch_get_main_queue(), ^{
//            self.hightedLigthedBackGround.hidden = YES;
//        });
//    }
}

@end
