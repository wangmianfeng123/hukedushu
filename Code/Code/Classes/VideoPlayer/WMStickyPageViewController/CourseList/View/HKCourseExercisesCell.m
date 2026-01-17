//
//  HKCourseExercisesCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/4/16.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKCourseExercisesCell.h"
#import "HKImageTextIV.h"

@interface HKCourseExercisesCell()
@property (weak, nonatomic) IBOutlet UIImageView *lefticonIV;
@property (weak, nonatomic) IBOutlet UIImageView *localCacheIV;

@property (nonatomic, strong)HKImageTextIV *animationIV;

@end

@implementation HKCourseExercisesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.animationIV];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.lefticonIV);
    }];
}

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _animationIV;
}


- (void)setModel:(HKCourseModel *)model {
    _model = model;

    self.animationIV.isAnimation = model.currentWatching;// 正在播放
    [self.animationIV text:@"" hiddenIfTextEmpty:NO];
    self.animationIV.hidden = !model.currentWatching;
    self.lefticonIV.hidden = !self.animationIV.hidden;
    self.localCacheIV.hidden = !model.islocalCache; // 缓存
    
    // 标题
    self.titleLB.text = model.title.length? model.title : model.video_title;
    
    if (model.currentWatching) {
        // 正在播放的
        self.titleLB.textColor = HKColorFromHex(0xFF3221, 1.0);
    } else if (model.is_study) {
        
        // 已经学习过的
        self.titleLB.textColor =  self.isLandScape ? [UIColor whiteColor] : COLOR_A8ABBE_7B8196;
    } else {
        // 普通正常的
        self.titleLB.textColor = self.isLandScape ? [UIColor whiteColor] : COLOR_27323F_EFEFF6;
    }

    
//    if (model.currentWatching) {
//
//        // 正在播放的
//        self.titleLB.textColor = HKColorFromHex(0xFF3221, 1.0);
//    } else if (model.is_study) {
//
//        // 已经学习过的
//        self.titleLB.textColor = HKColorFromHex(0xA8ABBE, 1.0);
//    } else {
//        // 普通正常的
//        self.titleLB.textColor = HKColorFromHex(0x27323F, 1.0);
//    }
    
    // 修正偏移量
    CGFloat constant = !self.localCacheIV.hidden? 45.0 : 0.0;
    [self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(-constant);
    }];
    
    // 左侧的联系图标 ic_practice_v2_10 , ic_practice_filled_v2_10
    if (model.is_studied && !model.currentWatching) {
        if (self.isLandScape) {
            self.lefticonIV.image = imageName(@"ic_practice_v2_10_dark");
        }else{
            self.lefticonIV.image = imageName(@"ic_practice_filled_v2_10");
        }
    } else {
        if (self.isLandScape) {
            self.lefticonIV.image = [UIImage imageNamed:@"ic_practice_v2_10_dark"];
        }else{
            self.lefticonIV.image = [UIImage hkdm_imageWithNameLight:@"ic_practice_v2_10" darkImageName:@"ic_practice_v2_10_dark"];
        }
    }
}

@end
