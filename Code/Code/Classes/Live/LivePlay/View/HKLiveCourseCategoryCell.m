//
//  HKLiveCourseCategoryCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/12/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseCategoryCell.h"
#import "HKImageTextIV.h"
#import "HKLiveListModel.h"

@interface HKLiveCourseCategoryCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *canPlayBackBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftCons;

@property (nonatomic,strong) HKImageTextIV *isLiveView ;
@property (nonatomic,strong) HKImageTextIV *leftAnimationView;

@end

@implementation HKLiveCourseCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.isLiveView.isAnimation = YES;
    self.isLiveView.liveAnimationType = HKLiveAnimationType_videoDetail;
    self.isLiveView.isRemoveRoundedCorner = YES;
    
    self.leftAnimationView.isAnimation = YES;
    self.leftAnimationView.liveAnimationType = HKLiveAnimationType_videoDetail;
    self.leftAnimationView.isRemoveRoundedCorner = YES;
    
    // 圆角
    self.canPlayBackBtn.clipsToBounds = YES;
    self.canPlayBackBtn.layer.cornerRadius = self.canPlayBackBtn.height * 0.5;
    
    [self.contentView addSubview:self.isLiveView ];
    [self.contentView addSubview:self.leftAnimationView];
    
    [self.isLiveView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.leftAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLB);
        make.left.mas_equalTo(15 + 10);
    }];
}


- (HKImageTextIV*)isLiveView  {
    if (!_isLiveView) {
        _isLiveView = [[HKImageTextIV alloc]init];
        _isLiveView.isRemoveRoundedCorner = YES;
        _isLiveView.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _isLiveView;
}

- (HKImageTextIV*)leftAnimationView {
    if (!_leftAnimationView) {
        _leftAnimationView = [[HKImageTextIV alloc]init];
        _leftAnimationView.isRemoveRoundedCorner = YES;
        _leftAnimationView.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _leftAnimationView;
}


- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    
    // 尚未开始，追加“未开始”
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.start_live_at.integerValue];
    NSDate* nowDate = [NSDate date];
    NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
    if (model.live_status == HKLiveStatusNotStart && ![model.start_live_at_str containsString:@"未开始"] && time > 0) {
        model.start_live_at_str = [NSString stringWithFormat:@"%@ 未开始", model.start_live_at_str];
    }
    
    self.titleLB.text = model.title;
    self.startTimeLB.text = model.start_live_at_str;
    
    if (model.can_replay && model.live_status == HKLiveStatusEnd) {
        self.canPlayBackBtn.hidden = NO;
    } else {
        self.canPlayBackBtn.hidden = YES;
    }
    
//
    // 当前播放选中的
    self.titleLB.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    self.startTimeLB.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    if (model.isCurrent) {
        self.titleLB.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        self.startTimeLB.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_FF3221 dark:COLOR_FFB600];
        self.titleLB.textColor = textColor;
        self.startTimeLB.textColor = textColor;
    } else if (model.has_study) {// 已学
        self.titleLB.textColor = COLOR_A8ABBE_7B8196;
        self.startTimeLB.textColor = COLOR_A8ABBE_7B8196;
    } else {
        // 普通的
        self.titleLB.textColor = COLOR_27323F_EFEFF6;
        self.startTimeLB.textColor = COLOR_A8ABBE_7B8196;
    }
    
    self.isLiveView.hidden = (model.live_status != HKLiveStatusLiving);
    [self.isLiveView hideText:NO hideAnimation:YES];
    
    // 添加正在播放的动画
    [self.leftAnimationView text:@"" hiddenIfTextEmpty:NO];
    self.leftAnimationView.hidden = !model.isCurrent;
    
    // 移动标题的间距
    if (!self.leftAnimationView.hidden) {
        self.titleLeftCons.constant = 35.0 + 22;
    } else {
        self.titleLeftCons.constant = 35.0;
    }
}


@end
