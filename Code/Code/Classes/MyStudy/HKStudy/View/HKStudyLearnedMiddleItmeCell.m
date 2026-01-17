//
//  HomeMyFollowVideoCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKStudyLearnedMiddleItmeCell.h"
#import "UMpopScreenshotView.h"
#import "UIView+SNFoundation.h"
#import "UMpopView.h"
#import "HKArticleDetailVC.h"
#import "UIView+Banner.h"

@interface HKStudyLearnedMiddleItmeCell()

@property (weak, nonatomic) IBOutlet  UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIImageView *day_7_IV;

@end

@implementation HKStudyLearnedMiddleItmeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    
    // 圆角的处理
    [self.imageView addSubview:self.blackView];
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_ffffff];
}

- (void)setModel:(VideoModel *)model {
    _model = model;
    
    if (!model.isMoreModel) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    } else {
        // 空的点击更多
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:imageName(model.cover)];
    }

    self.titleLB.text = model.video_title.length? model.video_title : model.title;
    
    self.blackView.hidden = self.timeLB.hidden = YES;
    if (model.master_count.intValue + model.slave_count.intValue > 0) {
        
        // 系列课
        self.blackView.hidden = self.timeLB.hidden = NO;
        self.timeLB.text = [NSString stringWithFormat:@"已学%@节/共%d节", model.doc_count, model.master_count.intValue + model.slave_count.intValue];
    }
    //  7天权限
    self.day_7_IV.hidden = model.is_show_deadline || model.isMoreModel;
}

@end
