//
//  HKVideoPlayAliYunConfig.m
//  Code
//
//  Created by Ivan li on 2019/8/29.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKVideoPlayAliYunConfig.h"

@implementation HKVideoPlayAliYunConfig

+ (instancetype)sharedInstance {
    
    static HKVideoPlayAliYunConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


+ (void)hkVideoPlayAliYunConfig:(NSInteger)btnID  showType:(NSInteger)showType {
    [[self class] sharedInstance];
    [[[self class] sharedInstance] setBtnID:btnID];
    [[[self class] sharedInstance] setShowType:btnID];
}


- (void)setBtnID:(NSInteger)btnID {
    _btnID = btnID;
}


- (void)setShowType:(NSInteger)showType {
    _showType = showType;
    switch (showType) {
        case 1:
            if (_btnID) {
                [[HKALIYunLogManage sharedInstance]hkVideoPlayWithBtnId:[NSString stringWithFormat:@"%ld",_btnID] showType:[NSString stringWithFormat:@"%ld",_showType]];
            }
            _showType = 0;
            break;
        case 2:
            if (_btnID) {
                [[HKALIYunLogManage sharedInstance]hkVideoPlayWithBtnId:[NSString stringWithFormat:@"%ld",_btnID] showType:[NSString stringWithFormat:@"%ld",_showType]];
            }
            _showType = 0;
            _btnID = 0;
            break;
            
        default:
            break;
    }
}

-(void)setBtn_type:(NSInteger)btn_type{
    _btn_type = btn_type;
    if (_btnID) {
        [[self class] sharedInstance];
//        [[HKALIYunLogManage sharedInstance]hkVideoPlayWithBtnId:[NSString stringWithFormat:@"%ld",btnID] showType:[NSString stringWithFormat:@"%ld",btn_type]];
    }
}

//统计阿里云统计-首页推荐视频 曝光 点击 播放
+ (void)videoPlayAliYunVideoID:(NSString *)videoID btn_type:(NSInteger)btn_type{
    [[HKALIYunLogManage sharedInstance]hkVideoPlayWithBtnId:videoID showType:[NSString stringWithFormat:@"%ld",btn_type]];
}

@end
