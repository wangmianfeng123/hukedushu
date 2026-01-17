//
//  HKTeacherDouYinCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/3/27.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTeacherDouYinCell.h"
#import "HKShortVideoModel.h"

@interface HKTeacherDouYinCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *browseCount;


@end

@implementation HKTeacherDouYinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0;
}


- (void)setVideoModel:(HKShortVideoModel *)videoModel {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover_url]] placeholderImage:imageName(@"bg_shortvideo_place_holder")];
    
    NSString *count = [self shortVideoFormatCount:videoModel.playCount.intValue];
    [self.browseCount setTitle:count forState:UIControlStateNormal];

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
