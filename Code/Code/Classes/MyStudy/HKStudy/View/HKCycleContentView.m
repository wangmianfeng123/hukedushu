//
//  HKCycleContentView.m
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCycleContentView.h"
#import "HKFollowTeacherModel.h"

@interface HKCycleContentView ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HKCycleContentView

-(void)setFollowVideoModel:(HKFollowVideoModel *)followVideoModel{
    _followVideoModel = followVideoModel;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:followVideoModel.img_cover_url]]];
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:followVideoModel.teacher_avator]];
    self.nameLabel.text = followVideoModel.teacher_name;
    self.descLabel.text = followVideoModel.title;
}

- (IBAction)lookBtnClick {
    if (self.lookBlock) {
        self.lookBlock();
    }
}

@end
