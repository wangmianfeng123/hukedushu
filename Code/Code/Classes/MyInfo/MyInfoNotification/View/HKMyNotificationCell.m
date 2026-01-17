//
//  HKMyInfoNotificationCell.m
//  Code 11
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyNotificationCell.h"



@interface HKMyNotificationCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end


@implementation HKMyNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.lineView.backgroundColor = [self separatorLineBGColor];
}



- (void)setModel:(HKMyNotificationCellModel *)model {
    _model = model;
    self.headerIV.image = imageName(model.avator);
    self.titleLB.text = model.title;
    
    // 有消息
    if (model.count.integerValue > 0) {
        self.countLB.textColor = HKColorFromHex(0xFF7820, 1.0);
        self.countLB.text = [NSString stringWithFormat:@"%@条新消息", model.count];
    } else {
        // 无消息
        self.countLB.textColor = COLOR_A8ABBE_7B8196;// HKColorFromHex(0xA8ABBE, 1.0);
        self.countLB.text = @"暂无新消息";
    }
}



@end






@implementation HKMyNotificationCellModel


@end
