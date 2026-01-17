//
//  HKCourseListCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCourseDonwloadCell.h"
#import <YYText/YYText.h>
#import "HKDownloadCourseVC.h"

@interface HKCourseDonwloadCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIView *seprarator;

/** 加锁 图片*/
@property (strong, nonatomic) UIImageView *lockImageView;

@property (nonatomic, strong)UIColor *normalColor;
@property (nonatomic, strong)UIColor *selectedColor;
@property (weak, nonatomic) IBOutlet UIImageView *localCacheIV;
@property (nonatomic, strong)UIColor *studyedColor;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleLBConstraint;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleRightConstraint;

@property (nonatomic, strong)HKCourseModel *model;
@property (weak, nonatomic) IBOutlet UIButton *needStudyLocalBtn;

@property (nonatomic, copy)void(^deleteBtnClickBlock)(HKCourseModel *model);

@property (nonatomic, strong)YYLabel *titleYY;

@end

@implementation HKCourseDonwloadCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 初始化颜色
//    UIColor *normalColor = HKColorFromHex(0x333333, 1.0);
//    self.normalColor = normalColor;
//    UIColor *selectedColor = HKColorFromHex(0xff7c00, 1.0);
//    self.selectedColor = selectedColor;
//    UIColor *studyedColor = HKColorFromHex(0x999999, 1.0);
//    self.studyedColor = studyedColor;
    
    
    UIColor *normalColor = COLOR_27323F_EFEFF6;
    self.normalColor = normalColor;
    UIColor *selectedColor = HKColorFromHex(0xff7c00, 1.0);
    self.selectedColor = selectedColor;
    UIColor *studyedColor = COLOR_A8ABBE_7B8196;
    self.studyedColor = studyedColor;
    
    [self.contentView addSubview:self.lockImageView];
    [self.contentView addSubview:self.titleYY];
    
    self.needStudyLocalBtn.clipsToBounds = YES;
    self.needStudyLocalBtn.layer.cornerRadius = 6.0;
    self.needStudyLocalBtn.hidden = YES;
    
    // 设置约束
    [self.titleYY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self.titleLB);
        make.right.mas_equalTo(-70);
    }];
    
    self.seprarator.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
}

- (YYLabel *)titleYY {
    if (_titleYY == nil) {
        YYLabel *titleYY = [[YYLabel alloc] init];
        titleYY.font = IS_IPHONE6PLUS? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:11];
        titleYY.textColor = HKColorFromHex(0xA8ABBE, 1.0);
        titleYY.numberOfLines = 1;
        titleYY.textAlignment = NSTextAlignmentCenter;
        _titleYY = titleYY;
    }
    return _titleYY;
}



- (void)downloadOrDelete:(BOOL)hidden model:(HKCourseModel *)model videoType:(HKVideoType)videoType edit:(BOOL)edit show:(BOOL)show showWhenComplete:(BOOL)delete {
    _model = model;
    
    if (model.currentWatching) {
        self.titleLB.font = [UIFont boldSystemFontOfSize:14];
    }else{
        self.titleLB.font = [UIFont systemFontOfSize:14];
    }
    
    if (model.canNotDown == YES) {
        self.titleLB.textColor = COLOR_A8ABBE_7B8196;
        self.localCacheIV.hidden = YES;
        self.selectedIV.image = imageName(@"ic_no_select_v2.1");
        // 设置文字
        self.titleLB.hidden = NO;
        self.titleYY.hidden = YES;
        if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse) {
            // 系列课
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_LearnPath || videoType == 999) {
            // 软件入门
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_JobPath_Practice || videoType == HKVideoType_JobPath) {
            // 职业路径
            if (model.isExcercises) {
                // 练习题
                self.titleLB.hidden = YES;
                self.titleYY.hidden = NO;
                self.titleYY.attributedText = [self getPraticeString:model.title];
            }else{
                self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
            }
        }
        else if (videoType == HKVideoType_PGC) {
            // pgc
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
            
            self.lockImageView.hidden = !([self.model.is_lock integerValue] == 1);
            [_lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(self.titleLB);
                make.right.equalTo(self.contentView).offset(-13);
            }];
        } else if (videoType == HKVideoType_Practice) {
            // 练习题
            self.titleLB.hidden = YES;
            self.titleYY.hidden = NO;
            self.titleYY.attributedText = [self getPraticeString:model.title];
        }else{
            
        }
    }else{
        // 设置颜色
        self.selectedIV.image = model.isSelectedForDownload? imageName(@"right_green") : imageName(@"cirlce_gray");
        self.selectedBtn.selected = model.isSelectedForDelete;
        
        if (model.isSelectedForDownload || model.currentWatching) {
            self.titleLB.textColor = self.selectedColor;
        }else if (model.is_study){
            self.titleLB.textColor = self.studyedColor;
        }else if (self.isHKDownloadCourseVC && model.islocalCache){
            self.titleLB.textColor = COLOR_A8ABBE_7B8196;
        }else{
            self.titleLB.textColor = self.normalColor;
        }
        
        
        self.selectedIV.hidden = model.islocalCache;
        if (self.isHKDownloadCourseVC && model.islocalCache) {
            self.selectedIV.hidden = NO;
            self.selectedIV.image = imageName(@"ic_no_select_v2.1");
        }
        
        // 缓存标识符
        if (model.islocalCache) {
            self.localCacheIV.hidden = NO;
            
            self.localCacheIV.image = imageName(@"cache_in_local_black");
            if (model.is_study) {
                self.localCacheIV.image = imageName(@"cache_in_local_gray");
            }
            if (model.currentWatching) {// 当前正在观看的视频
                self.localCacheIV.image = imageName(@"cache_in_local_orange");
            }
            
        }else {
            self.localCacheIV.hidden = YES;
        }
        
//        if (model.is_study) {
//            self.titleLB.textColor = self.studyedColor;
//        }
//
//        // 如果是批量下载界面修改下载颜色
//        if (self.isHKDownloadCourseVC && model.islocalCache) {
//            self.titleLB.textColor = COLOR_A8ABBE_7B8196;
//        }
//        
//        if (model.currentWatching) {// 当前正在观看的视频
//            self.titleLB.textColor = self.selectedColor;
//        }
        
        if ([model.title containsString:@"PS动作怎么用"]) {
            NSLog(@"111");
        }
        
        // 设置文字
        self.titleLB.hidden = NO;
        self.titleYY.hidden = YES;
        if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse) {
            // 系列课
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_LearnPath || videoType == 999) {
            // 软件入门
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_JobPath_Practice || videoType == HKVideoType_JobPath) {
            // 职业路径
            if (model.isExcercises) {
                // 练习题
                self.titleLB.hidden = YES;
                self.titleYY.hidden = NO;
                self.titleYY.attributedText = [self getPraticeString:model.title];
            }else{
                self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
            }
        }
        else if (videoType == HKVideoType_PGC) {
            // pgc
            self.titleLB.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
            
            self.lockImageView.hidden = !([self.model.is_lock integerValue] == 1);
            [_lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(self.titleLB);
                make.right.equalTo(self.contentView).offset(-13);
            }];
        } else if (videoType == HKVideoType_Practice) {
            // 练习题
            self.titleLB.hidden = YES;
            self.titleYY.hidden = NO;
            self.titleYY.attributedText = [self getPraticeString:model.title];
        }else{
            
        }
        
        
        // 调整练习题的三级目录
    //    if (videoType == HKVideoType_Practice) {
    //        self.leftTitleLBConstraint.constant = 30;
    //    } else {
    //        self.leftTitleLBConstraint.constant = 15;
    //    }
        self.leftTitleLBConstraint.constant = 15;
        
        
        // 隐藏分割线
        self.seprarator.hidden = hidden;
        
        // 预备删除操作
        if (delete) {
            self.selectedIV.hidden = YES;
            self.selectedBtn.hidden = NO;
            self.localCacheIV.hidden = YES;
        }
        
        // 下载完成后编辑
        if (show) {
            
            // 左边constant增加
            self.titleRightConstraint.constant = 70;
            
            // 正在编辑
            if (edit) {
                self.selectedBtn.hidden = NO;
    //            if (videoType == HKVideoType_Practice) {
    //                self.leftTitleLBConstraint.constant = 25;
    //            } else {
    //                self.leftTitleLBConstraint.constant = 10;
    //            }
                 self.leftTitleLBConstraint.constant = 10;
            } else {
                
                // 普通显示状态
    //            if (videoType == HKVideoType_Practice) {
    //                self.leftTitleLBConstraint.constant = 10;
    //            } else {
    //                self.leftTitleLBConstraint.constant = -5;
    //            }
                self.leftTitleLBConstraint.constant = -5;
                self.selectedBtn.hidden = YES;
            }
        } else {
            self.titleRightConstraint.constant = 70;
        }
        
        // 已经学习
        self.needStudyLocalBtn.hidden = !model.needStudyLocal;
    }
}



- (void)setModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType {
    [self downloadOrDelete:hidden model:model videoType:videoType edit:NO show:NO showWhenComplete:NO];
}



- (void)showCompeletModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType edit:(BOOL)edit block:(void(^)(HKCourseModel *model))deleteBtnClickBlock {
    _deleteBtnClickBlock = deleteBtnClickBlock;
    [self downloadOrDelete:hidden model:model videoType:videoType edit:edit show:YES showWhenComplete:YES];
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [UIImageView new];
        _lockImageView.image = imageName(@"lock_red");
        //_lockImageView.hidden = YES;
    }
    return _lockImageView;
}


/**
 删除按钮选中点击

 @param sender button
 */
- (IBAction)selectedDeleteBtnClick:(id)sender {
    self.model.isSelectedForDelete = !self.model.isSelectedForDelete;
    !self.deleteBtnClickBlock? : self.deleteBtnClickBlock(self.model);
}


- (NSMutableAttributedString *)getPraticeString:(NSString *)name {

    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *attachment = nil;

    // 练习
    UIButton *leftPratice = [UIButton buttonWithType:UIButtonTypeCustom];
    leftPratice.size = CGSizeMake(17, 17);
    
    if (self.model.canNotDown) {
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_practice_filled_v2_10" darkImageName:@"ic_practice_v2_10_dark"];
        [leftPratice setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        if (self.model.islocalCache) { // 已经下载过了
            /// v2.17 替换
            UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_practice_filled_v2_10" darkImageName:@"ic_practice_v2_10_dark"];
            [leftPratice setBackgroundImage:image forState:UIControlStateNormal];
        } else { // 还没下载过
            UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_practice_v2_10" darkImageName:@"ic_practice_v2_10_dark"];
            [leftPratice setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    
    leftPratice.titleLabel.font = [UIFont systemFontOfSize:12.0];
    attachment =[NSMutableAttributedString yy_attachmentStringWithContent:leftPratice contentMode:UIViewContentModeBottom attachmentSize:leftPratice.size alignToFont:leftPratice.titleLabel.font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString: attachment];

    // 多少练习
    NSString *practiceString = [NSString stringWithFormat:@"  %@", name];
    attachment = [[NSMutableAttributedString alloc] initWithString:practiceString];
    UIColor *color = nil;
    if (self.model.canNotDown) {
        color = COLOR_A8ABBE_7B8196;
    }else{
        if (self.isHKDownloadCourseVC && self.model.islocalCache) {
            color = COLOR_A8ABBE_7B8196;
        } else {
            color = COLOR_27323F_EFEFF6;
        }
    }
    
    
    [attachment addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, practiceString.length)];
    [attachment addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, practiceString.length)];
    [text appendAttributedString:attachment];
    return text;
}

@end
