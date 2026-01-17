//
//  HKSeriesCourseCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSeriesCourseCell.h"
#import "VideoModel.h"

@interface HKSeriesCourseCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *courseCountLB;
@property (weak, nonatomic) IBOutlet UIButton *watchCountLB;
@property (weak, nonatomic) IBOutlet UIButton *updatingLB;


@end


@implementation HKSeriesCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 底部所有按钮图标左移 5
    self.courseCountLB.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.watchCountLB.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.updatingLB.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
}

- (void)setModel:(VideoModel *)model {
    
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    
    [self.courseCountLB setTitle:[NSString stringWithFormat:@"%ld节课",(long)model.courseCount] forState:UIControlStateNormal];
    [self.watchCountLB setTitle:[NSString stringWithFormat:@"%ld", (long)model.watch_nums] forState:UIControlStateNormal];
    self.updatingLB.hidden = model.update_status == 0;
    
    // 更新icon图像的大小
    [self.iconIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(IS_IPHONE6PLUS ?165:155);
    }];
}


@end
