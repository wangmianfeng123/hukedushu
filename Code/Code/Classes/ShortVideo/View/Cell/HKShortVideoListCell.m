//
//  HKShortVideoListCell.h.m
//  Code
//
//  Created by hanchuangkeji on 2019/3/27.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoListCell.h"

@interface HKShortVideoListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *browseCount;

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@end

@implementation HKShortVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
    
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setShortVideoModel:(HKShortVideoModel *)shortVideoModel {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:shortVideoModel.cover_url]] placeholderImage:imageName(HK_Placeholder)];
    
    NSString *count = [self shortVideoFormatCount:shortVideoModel.playCount.intValue];
    [self.browseCount setTitle:count forState:UIControlStateNormal];

    // 教师信息
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:shortVideoModel.teacher.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = shortVideoModel.teacher.name;
}


- (NSString *)shortVideoFormatCount:(NSInteger)count {
    if (count) {
        if(count < 10000) {
            return [NSString stringWithFormat:@"%ld",(long)count];
        }else {
            return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
        }
    }else{
        return  @"0";
    }
}

@end
