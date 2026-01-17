//
//  HKNewLearnerCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewLearnerCell.h"

@implementation HKNewLearnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 加大字号
    if (IS_IPHONEMORE4_7INCH) {
        self.nameLB.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        
        self.desLB.font = [UIFont systemFontOfSize:14.0];
        self.countLB.font = [UIFont systemFontOfSize:12.0];
        self.courseLB.font = [UIFont systemFontOfSize:12.0];
        self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    // 完结 圆角
    self.self.updateBtn.clipsToBounds = YES;
    self.updateBtn.layer.cornerRadius = 5.0;
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.desLB.textColor = COLOR_A8ABBE_7B8196;
    self.countLB.textColor = COLOR_A8ABBE_7B8196;
    
    self.courseLB.textColor = COLOR_A8ABBE_7B8196;
    self.sepMidView.backgroundColor = COLOR_A8ABBE_7B8196;
    self.sepBtmView.backgroundColor = COLOR_F8F9FA_3D4752;
}


- (void)setModel:(SoftwareModel *)model {
    
    _model = model;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    
    self.nameLB.text = model.name;
    
    self.desLB.text = model.simple_introduce;
    
    // 是否完结
    if (model.is_end) {
        [self.updateBtn setTitle:@"已完结" forState:UIControlStateNormal];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_27323F];
        [self.updateBtn setTitleColor:textColor forState:UIControlStateNormal];
        
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_7B8196];
        [self.updateBtn setBackgroundColor:bgColor];
    } else {
        
        [self.updateBtn setTitle:@"更新中" forState:UIControlStateNormal];
        [self.updateBtn setTitleColor:HKColorFromHex(0xFFFFFF, 1.0) forState:UIControlStateNormal];
        [self.updateBtn setBackgroundColor:HKColorFromHex(0xFFD710, 1.0)];
        
    }
    
    // 多少人观看
    NSString *countString = [NSString stringWithFormat:@"%@人已学", [self parseCountString:model.study_num]];
    self.countLB.text = countString;
    
    NSString *courseString = [NSString stringWithFormat:@"%@课  %@练习", model.master_video_total, model.slave_video_total];
    self.courseLB.text = courseString;
    
}

- (NSString *)parseCountString:(NSString *)count {
    NSString *stringTemp = count;
    if (count.integerValue > 10000) {
        stringTemp = [NSString stringWithFormat:@"%.1fw", count.integerValue / 10000.0];
    }
    return stringTemp;
}


@end
