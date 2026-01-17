//
//  HKMomentTopCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentTopCell.h"
#import "HKMomentDetailModel.h"

@interface HKMomentTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@end

@implementation HKMomentTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = COLOR_F8F9FA_333D48;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.rightImgV.image = [UIImage hkdm_imageWithNameLight:@"ic_go_detail_2_31" darkImageName:@"ic_go_detail_dark_2_31"];
}

-(void)setVideoModel:(HKMonmentVideoModel *)videoModel{
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover]] placeholderImage:HK_PlaceholderImage];
    self.titleLabel.text = videoModel.title;
}
@end
