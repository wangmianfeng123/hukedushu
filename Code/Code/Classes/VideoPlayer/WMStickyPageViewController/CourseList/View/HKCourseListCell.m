//
//  HKCourseListCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCourseListCell.h"
#import "HKImageTextIV.h"
#import "HKLeftRightBtn.h"

@interface HKCourseListCell()

@property (nonatomic, weak)NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIView *seprarator;

/** 加锁 图片*/
@property (strong, nonatomic) UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet HKLeftRightBtn *expandExcerseBtn;

@property (weak, nonatomic) IBOutlet UIImageView *localCacheIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localCacheConstraint;

@property (nonatomic, assign)BOOL btnTransformMakeRotation; // 按钮的旋转

@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong)UIColor *studyedColor;
@property (nonatomic, strong)UIColor *normalColor;
@property (nonatomic, strong)UIColor *selectedColor;

@end

@implementation HKCourseListCell

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _animationIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 正在播放的动画
    //[self addSubview:self.animationIV];
    [self.contentView insertSubview:self.animationIV belowSubview:self.titleLB];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(12);
    }];
    
    // 初始化颜色
//    UIColor *normalColor = HKColorFromHex(0x27323F, 1.0);
//    self.normalColor = normalColor;
//    UIColor *selectedColor = HKColorFromHex(0xFF3221, 1.0);
//    self.selectedColor = selectedColor;
//    UIColor *studyedColor = HKColorFromHex(0xA8ABBE, 1.0);
//    self.studyedColor = studyedColor;
    
    UIColor *normalColor = COLOR_27323F_EFEFF6;
    self.normalColor = normalColor;
    UIColor *selectedColor = HKColorFromHex(0xFF3221, 1.0);
    self.selectedColor = selectedColor;
    UIColor *studyedColor = COLOR_A8ABBE_7B8196;
    self.studyedColor = studyedColor;
    
    [self.contentView addSubview:self.lockImageView];
    
    self.expandExcerseBtn.clipsToBounds = YES;
    self.expandExcerseBtn.layer.cornerRadius = self.expandExcerseBtn.height * 0.5;
    self.expandExcerseBtn.layer.borderWidth = 0.5;
    self.expandExcerseBtn.layer.borderColor = HKColorFromHex(0xFF3221, 1.0).CGColor;
    [self.expandExcerseBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateSelected];
    [self.expandExcerseBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    
    // 扩大点击范围5.0
    [self.expandExcerseBtn setHKEnlargeEdge:5];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}

-(void)setIsFromLandScape:(BOOL)isFromLandScape{
    _isFromLandScape =isFromLandScape;
    if (_isFromLandScape == YES) {
        UIColor *normalColor = [UIColor whiteColor];
        self.normalColor = normalColor;
        UIColor *studyedColor = [UIColor whiteColor];
        self.studyedColor = studyedColor;
        UIColor *selectedColor = HKColorFromHex(0xFF3221, 1.0);
        self.selectedColor = selectedColor;
        self.backgroundColor = [UIColor clearColor];
        //self.expandExcerseBtn.backgroundColor = [UIColor clearColor];
        [self.expandExcerseBtn setBackgroundColor:[UIColor clearColor]];
        self.expandExcerseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        //[self.expandExcerseBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateSelected];
        [self.expandExcerseBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];

    }else{
        //self.expandExcerseBtn.backgroundColor = COLOR_FFFFFF_3D4752;
        self.backgroundColor = [UIColor clearColor];
        [self.expandExcerseBtn setBackgroundColor:[UIColor clearColor]];
        self.expandExcerseBtn.layer.borderColor = HKColorFromHex(0xFF3221, 1.0).CGColor;
        [self.expandExcerseBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateSelected];
        [self.expandExcerseBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        //self.expandExcerseBtn.backgroundColor = [UIColor clearColor];

    }
}


- (IBAction)expandExerciseBtnClick:(id)sender {
    !self.expandExerciseBlock? : self.expandExerciseBlock(self.model);
    self.btnTransformMakeRotation = !self.btnTransformMakeRotation;
    
    [MobClick event:UM_RECORD_DETAIL_EXERCISE];;
    // 旋转动画
    [UIView animateWithDuration:0.2 animations:^{
        
        if (self.btnTransformMakeRotation) {
            self.expandExcerseBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.expandExcerseBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        }
    }];
}


- (void)setModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType{
    _model = model;
    
    // 设置颜色
    self.titleLB.textColor = self.normalColor;
    self.countLB.textColor = self.studyedColor;
    
    // 缓存标识符
    if (model.islocalCache) {
        self.localCacheIV.hidden = NO;
        
        // 软件入门
        if (videoType == HKVideoType_LearnPath || videoType == HKVideoType_Practice) {
            self.localCacheConstraint.constant = 15;
        } else {
            self.localCacheConstraint.constant = -72;
        }
        
//        if (model.is_study) {
//            self.localCacheIV.image = imageName(@"cache_in_local_gray");
//        }
//        if (model.currentWatching) {// 当前正在观看的视频
//            self.localCacheIV.image = imageName(@"cache_in_local_orange");
//        }
    }else {
        self.localCacheIV.hidden = YES;
    }
    
    if (model.is_study) {
        self.titleLB.textColor = self.studyedColor;
        self.countLB.textColor = self.studyedColor;
    }
    
    if (model.currentWatching) {// 当前正在观看的视频
        self.titleLB.textColor = self.selectedColor;
        self.countLB.textColor = self.studyedColor;
    }
    
    // 设置文字
    if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse) {
        // 系列课
        self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
    }else if (videoType == HKVideoType_LearnPath || videoType == HKVideoType_Practice || videoType == HKVideoType_Ordinary) {
        // 软件入门
        self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
    }else if (videoType == HKVideoType_PGC) {
        // pgc
        self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
        self.lockImageView.hidden = !([self.model.is_lock integerValue] == 1);
        [_lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(self.titleLB);
            make.right.equalTo(self.contentView).offset(-13);
        }];
    }
    
    NSInteger salveCount = [model.salve_video_total integerValue];
    salveCount = salveCount ?salveCount : model.slave_count;
    
    self.countLB.text = [NSString stringWithFormat:@"%ld节练习题", salveCount];
    self.countLB.hidden = salveCount ?NO :YES;
    self.countLB.hidden = YES;
    // 隐藏分割线
    self.seprarator.hidden = YES;
    
    //****************** 版本2.11 ****************
    // 展开练习题
    if (videoType == HKVideoType_LearnPath && !model.isExcercises && model.children.count) {
        self.expandExcerseBtn.hidden = NO;
    } else {
        self.expandExcerseBtn.hidden = YES;
    }
    
    // 设置练习按钮
    NSString *btnTitle = nil;
    if (model.slave_count) {
        btnTitle = [NSString stringWithFormat:@"%ld节练习",model.slave_count];
    }else{
        btnTitle = model.slave_string;
    }
    [self.expandExcerseBtn setTitle:btnTitle forState:UIControlStateNormal];
    self.expandExcerseBtn.selected = model.isPlayingExpandExcercises;
    
    if (model.isPlayingExpandExcercises) {
        // 选中的
        self.expandExcerseBtn.layer.borderColor = HKColorFromHex(0xFF3221, 1.0).CGColor;
        [self.expandExcerseBtn setImage:imageName(@"ic_down_red_v2_10") forState:UIControlStateNormal];
    } else {
        // 非当前选中
        
        
        if (_isFromLandScape == YES) {
            //UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_down_black_v2_10" darkImageName:@""];
            [self.expandExcerseBtn setImage:[UIImage imageNamed:@"ic_down_black_v2_10_dark"] forState:UIControlStateNormal];
            self.expandExcerseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        }else{
            UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_down_black_v2_10" darkImageName:@"ic_down_black_v2_10_dark"];
            [self.expandExcerseBtn setImage:image forState:UIControlStateNormal];
            self.expandExcerseBtn.layer.borderColor = COLOR_27323F_EFEFF6.CGColor;
        }
    }
    
    // 正在播放的动画
    self.animationIV.isAnimation = model.currentWatching;// 正在播放
    [self.animationIV text:@"" hiddenIfTextEmpty:NO];
    self.animationIV.hidden = !model.currentWatching;
    
    // 更新约束
    CGFloat constant = 0.0;
    // 既有联系又有缓存
    if (!self.expandExcerseBtn.hidden && !self.localCacheIV.hidden) {
        //constant = 98.0 + 44.5 + 2.0;
        //v2.17
        constant = 98.0 + 44.5 + 10;
    } else if (!self.expandExcerseBtn.hidden && self.localCacheIV.hidden) {
        
        // 只有练习没有缓存
        constant = 100.0;
    } else if (self.expandExcerseBtn.hidden && !self.localCacheIV.hidden) {
        
        // 没有练习只有缓存
        constant = 98.0;
    } else {
        
        // 既没有练习也没有缓存
        constant = 18;
    }
    
    [self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(-constant);
    }];
    
    //****************** 版本2.11 ****************
    
}


- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [UIImageView new];
        _lockImageView.image = imageName(@"lock_red");
        //_lockImageView.hidden = YES;
    }
    return _lockImageView;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    // iOS 13 之后横竖屏切换的时候 self.contentView 会变化，有一个体验不好的效果
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    //[self updateConstraints];
    //[self layoutIfNeeded];
}

@end
