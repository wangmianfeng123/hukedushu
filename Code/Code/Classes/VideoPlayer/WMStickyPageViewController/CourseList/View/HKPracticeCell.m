//
//  HKPracticeCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/1/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPracticeCell.h"


@interface HKPracticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *localCacheIV;

@end

@implementation HKPracticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setModel:(HKPracticeModel *)model {
    _model =  model;
    
    self.titleLB.text = model.title;
    
    // 设置看过的颜色
    if (model.is_study) {
        self.titleLB.textColor = HKColorFromHex(0x999999, 1.0);
    }else {
        self.titleLB.textColor = HKColorFromHex(0x333333, 1.0);
    }
    
    // 缓存标识符
    if (model.isLocalCache) {
        self.localCacheIV.hidden = NO;
        self.localCacheIV.image = imageName(@"cache_in_local_black");
        if (model.is_study) {
            self.localCacheIV.image = imageName(@"cache_in_local_gray");
        }
    }else {
        self.localCacheIV.hidden = YES;
    }
}

@end
