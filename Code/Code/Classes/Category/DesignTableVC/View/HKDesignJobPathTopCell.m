//
//  HKDesignJobPathTopCell.m
//  Code
//
//  Created by LBB on 2020/12/20.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDesignJobPathTopCell.h"
#import "UIView+HKLayer.h"
#import "HKJobPathModel.h"

@interface HKDesignJobPathTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasStudyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HKDesignJobPathTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView addShadowCornerRadius:5 shadowOffset:CGSizeMake(0, 0) shadowRadius:3];
    [self.iconImgV addCornerRadius:25];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.hasStudyLabel.textColor = COLOR_A8ABBE_7B8196;
    self.courseLabel.textColor = COLOR_A8ABBE_7B8196;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    
}

- (void)setModel:(HKJobPathModel *)model {
    _model = model;
    
    if (!isEmpty(model.career_type)) {
        NSString *str = nil;
        if (!isEmpty(model.master_video_total)) {
            str = [NSString stringWithFormat:@"%@课   ",model.master_video_total];
        }
        if (!isEmpty(model.slave_video_total)) {
            if (isEmpty(str)) {
                str = [NSString stringWithFormat:@"%@练习",model.slave_video_total];
            }else{
                str = [str stringByAppendingFormat:@"%@练习",model.slave_video_total];
            }
        }
        self.titleLabel.text = model.video_title;
        self.courseLabel.text = str;
        self.courseLabel.hidden = YES;
        
    }else{
        self.titleLabel.text = model.title;
        NSString *str = model.course_number ?[NSString stringWithFormat:@"共%ld节",(long)model.course_number] : @"";
        self.courseLabel.text = str;
        self.courseLabel.hidden = isEmpty(str);
    }
    
    self.hasStudyLabel.text = [NSString stringWithFormat:@"%@人已学",model.study_number];
    [self.iconImgV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:HK_PlaceholderImage];
//        //高斯模糊
//        [self.coverIV setImageToBlur:image
//                          blurRadius:35
//                     completionBlock:^(NSError *error){
//                         NSLog(@"The blurred image has been setted");
//                     }];
}

@end
