//
//  HKMoreCoinCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMoreCoinCell.h"

@interface HKMoreCoinCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *isFinishBtn;

@end

@implementation HKMoreCoinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isFinishBtn.clipsToBounds = YES;
    self.isFinishBtn.layer.borderWidth = 1.0;
    self.isFinishBtn.layer.cornerRadius = self.isFinishBtn.height * 0.5;
    [self.isFinishBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [self.isFinishBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
    [self.isFinishBtn setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateSelected];
    [self.isFinishBtn setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateNormal];
}

- (void)setModel:(HKPresentHeaderMoreCoinModel *)model {
    _model = model;
    self.titleLB.text = model.title;
    
    // 设置右侧的btn
    self.isFinishBtn.selected = model.is_finish;
    if (model.is_finish) {
        
        [self.isFinishBtn setImage:nil forState:UIControlStateNormal];
        
        self.isFinishBtn.layer.borderColor = HKColorFromHex(0xdddddd, 1.0).CGColor;
        [self.isFinishBtn setTitle:@"已完成" forState:UIControlStateNormal];
    }else {
        
        if (model.coinCount.intValue >= 10) {
            [self.isFinishBtn setImage:imageName(@"present_coin_more_10") forState:UIControlStateNormal];
        }else {
            [self.isFinishBtn setImage:imageName(@"present_coin_less_10") forState:UIControlStateNormal];
        }
        
        self.isFinishBtn.layer.borderColor = HKColorFromHex(0xff6600, 1.0).CGColor;
        [self.isFinishBtn setTitle:[NSString stringWithFormat:@"+%@虎课币", model.coinCount] forState:UIControlStateNormal];
    }
}


- (void)setFrame:(CGRect)frame {
    // 往下移动一个分割线
    frame.origin.y += 1;
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
