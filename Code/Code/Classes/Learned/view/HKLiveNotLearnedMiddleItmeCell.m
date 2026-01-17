//
//  HomeMyFollowVideoCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKLiveNotLearnedMiddleItmeCell.h"
#import "UMpopScreenshotView.h"
#import "UIView+SNFoundation.h"
#import "UMpopView.h"
#import "HKArticleDetailVC.h"
#import "UIView+Banner.h"

@interface HKLiveNotLearnedMiddleItmeCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *blackView;

@end

@implementation HKLiveNotLearnedMiddleItmeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    
    // 圆角的处理
    [self.imageView addSubview:self.blackView];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.timeLB.textColor = COLOR_27323F_EFEFF6;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLB.text = model.video_title.length? model.video_title : model.title;
    self.timeLB.text = model.start_live_at;
}

@end
