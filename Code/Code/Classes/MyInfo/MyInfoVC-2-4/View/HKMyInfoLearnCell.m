//
//  HKMyInfoLearnCell.m
//  Code
//
//  Created by yxma on 2020/11/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKMyInfoLearnCell.h"
#import "HKMyInfoUserModel.h"

@interface HKMyInfoLearnCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *guildLabel;

@end

@implementation HKMyInfoLearnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
}

-(void)setModel:(HKMyInfoGuideLearnModel *)model{
    _model = model;
    NSArray * arry = [model.title componentsSeparatedByString:@","];
    if (arry.count == 2) {
        self.titleLabel.text = arry[0];
        self.guildLabel.text = arry[1];
    }
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_url]]];
}

@end
