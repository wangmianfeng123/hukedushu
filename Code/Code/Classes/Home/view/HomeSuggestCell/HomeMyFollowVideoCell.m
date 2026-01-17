//
//  HomeMyFollowVideoCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeMyFollowVideoCell.h"


@interface HomeMyFollowVideoCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end

@implementation HomeMyFollowVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
}

- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url_big]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLB.text = model.video_title.length? model.video_title : model.title;
}

@end
