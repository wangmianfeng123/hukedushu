//
//  HomeMyFollowVideoCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeMyFollowVideoV2Cell.h"
#import "UIView+SNFoundation.h"
#import "UIView+HKLayer.h"

@interface HomeMyFollowVideoV2Cell()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UIImageView *coverIV1;
@property (weak, nonatomic) IBOutlet UILabel *titleLB1;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV2;
@property (weak, nonatomic) IBOutlet UILabel *titleLB2;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@property (weak, nonatomic) IBOutlet UIView *video1View;
@property (weak, nonatomic) IBOutlet UIView *video2View;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

@end

@implementation HomeMyFollowVideoV2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.backgroudView addCornerRadius:8];
    //self.contentView.backgroundColor = [UIColor clearColor];
    
    
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
//
//    [self.backgroudView addCornerRadius:5.0];
//
////    self.coverIV1.clipsToBounds = YES;
////    self.coverIV1.layer.cornerRadius = 5.0;
//
//    self.coverIV2.clipsToBounds = YES;
//    self.coverIV2.layer.cornerRadius = 5.0;
//
//    // 添加阴影
////    [self.backgroudView addShadowWithColor:COLOR_E1E7EB alpha:0.8 radius:5 offset:CGSizeMake(0, 2)];
//////    self.backgroudView.backgroundColor = [UIColor greenColor];
////    self.backgroudView.clipsToBounds = YES;
////    self.backgroudView.layer.cornerRadius = 5.0;
//    // 设置视频点击事件
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap:)];
//    [self.video1View addGestureRecognizer:tap1];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTap:)];
//    [self.video2View addGestureRecognizer:tap2];
//
//    // 关注按钮样式
//    self.followBtn.clipsToBounds = YES;
//    self.followBtn.layer.cornerRadius = self.followBtn.height * 0.5;
//    [self.followBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_EFEFF6_7B8196] forState:UIControlStateSelected];
//    UIColor *textColor =[UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_27323F];
//    [self.followBtn setTitleColor:textColor forState:UIControlStateSelected];
//
//    self.backgroudView.backgroundColor = [UIColor clearColor];
//    [self hkDarkModel];
}

- (void)hkDarkModel {
//    self.nameLB.textColor = COLOR_27323F_EFEFF6;
//    self.desLB.textColor = COLOR_7B8196_A8ABBE;
//    self.titleLB1.textColor = COLOR_27323F_EFEFF6;
//    self.titleLB2.textColor = COLOR_27323F_EFEFF6;
//
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
//
//    self.bgIV.image = [UIImage hkdm_imageWithNameLight:@"bg_teacher" darkImageName:@"bg_teacher_dark"];
}


- (IBAction)followBtnClick:(id)sender {
    !self.followTeacherSelectedBlock? : self.followTeacherSelectedBlock(nil, self.model);
}

- (void)videoViewTap:(UIGestureRecognizer *)tap {
    
//    if (tap.view == self.video1View && self.model.video_list.count >= 1) {
//        !self.videoSelectedBlock? : self.videoSelectedBlock(self.model.video_list[0]);
//    } else if (tap.view == self.video2View && self.model.video_list.count >= 2) {
//            !self.videoSelectedBlock? : self.videoSelectedBlock(self.model.video_list[1]);
//    }
}

- (void)setModel:(HKUserModel *)model {
    // 第一个视频
    if (model.video_list.count >= 1) {
        self.coverIV2.hidden = NO;
        self.titleLB2.hidden = NO;
        VideoModel *videoModel = model.video_list[0];
        [self.coverIV1 sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.img_cover_url_big]] placeholderImage:imageName(HK_Placeholder)];
        self.titleLB1.text = videoModel.video_title;
    }
}


@end
