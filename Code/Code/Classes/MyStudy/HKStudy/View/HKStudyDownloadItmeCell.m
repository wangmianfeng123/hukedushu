//
//  HomeMyFollowVideoCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKStudyDownloadItmeCell.h"
#import "UMpopScreenshotView.h"
#import "UIView+SNFoundation.h"
#import "UMpopView.h"
#import "HKArticleDetailVC.h"
#import "UIView+Banner.h"

@interface HKStudyDownloadItmeCell()

@property (weak, nonatomic) IBOutlet  UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UILabel *downloadCountLB;
@property (weak, nonatomic) IBOutlet UIImageView *blueIV;

@end

@implementation HKStudyDownloadItmeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    
    // 圆角的处理
    [self.imageView addSubview:self.blackView];
    [self hkDarkModel];
}

- (void)setModel:(HKDownloadModel *)model {
    _model = model;
    
    self.blueIV.hidden = YES;
    self.downloadCountLB.hidden = YES;
    self.blackView.hidden = self.timeLB.hidden = YES;
    
    if (model.isDownloadingCountModel) {
        
        // 正在下载的
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:imageName(model.img_cover_url)];
        
        self.titleLB.text = model.title;
        self.blueIV.hidden = NO;
        self.downloadCountLB.hidden = NO;
        self.downloadCountLB.text = model.downloadingCount > 99? @"..." : [NSString stringWithFormat:@"%ld", (long)model.downloadingCount];
        
    } else if (model.isMoreModel) {
        
        // 更多的按钮
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:imageName(model.img_cover_url)];
        self.titleLB.text = @"";
    } else {
        // 已经下载好的视频
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url.length? model.img_cover_url : model.imageUrl]] placeholderImage:imageName(HK_Placeholder)];
        self.titleLB.text = model.title.length? model.title : model.name;
        
        // 目录的
        self.blackView.hidden = self.timeLB.hidden = !model.children.count;
        self.timeLB.text = [NSString stringWithFormat:@"共%lu节", (unsigned long)model.children.count];
    }
}


- (void)hkDarkModel {
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_ffffff];
}

@end
