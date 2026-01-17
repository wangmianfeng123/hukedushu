//
//  HKDayTaskCell.m
//  Code
//
//  Created by yxma on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDayTaskCell.h"
#import "HKTrainDetailModel.h"
#import "UIView+HKLayer.h"

@interface HKDayTaskCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startImgV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descRightMargin;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *topRightBtn;

@end

@implementation HKDayTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.descLabel.textColor = COLOR_A8ABBE_7B8196;
    self.coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.menuView addCornerRadius:10];
    self.menuView.hidden = YES;
}

-(void)setTaskDetailModel:(HKDayTaskModel *)taskDetailModel{
    _taskDetailModel = taskDetailModel;
}

-(void)setModel:(HKTrainTaskModel *)model{
    _model = model;
    self.titleLabel.text = model.live_name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.live_start_at,model.live_end_at];
    self.descLabel.text = @"进入直播间听课才算完成";
    self.startImgV.image = model.is_finish ? [UIImage imageNamed:@"star_select"]:[UIImage imageNamed:@"star_unselect"];
    self.timeLabelH.constant = 20;
    self.descLabelTopMargin.constant = 5;
    self.descRightMargin.constant = 15;
    self.leftImgV.image = nil;
    self.coverView.hidden = YES;
    
    self.topRightBtn.hidden = YES;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        self.titleLabel.text = @"教学视频";
        self.descLabel.text = @"观看教学视频才算完成";
        self.startImgV.image = self.taskDetailModel.sp_task_list.is_look ? [UIImage imageNamed:@"star_select"]:[UIImage imageNamed:@"star_unselect"];
        self.timeLabelH.constant = 20;
        self.timeLabel.text = [NSString stringWithFormat:@"时长：%@",self.taskDetailModel.sp_task_list.time];
        self.descLabelTopMargin.constant = 5;
        self.descRightMargin.constant = 15;
        [self.leftImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.taskDetailModel.sp_task_list.video_image_url]] placeholderImage:imageName(HK_Placeholder)];
        self.coverView.hidden = NO;
        self.topRightBtn.hidden = YES;
    }else if (indexPath.row == 1){
        self.titleLabel.text = @"作业上传";
        self.descLabel.text = @"若移动端没有作品保存可使用电脑提交";
        self.startImgV.image = self.taskDetailModel.sp_task_list.is_clock ? [UIImage imageNamed:@"star_select"]:[UIImage imageNamed:@"star_unselect"];
        self.timeLabelH.constant = 0;
        self.descLabelTopMargin.constant = 0;
        self.coverView.hidden = YES;
        if (self.taskDetailModel.sp_task_list.task_image_url.length) {
            [self.leftImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.taskDetailModel.sp_task_list.task_image_url]] placeholderImage:imageName(HK_Placeholder)];
            self.descRightMargin.constant = 150;
            self.topRightBtn.hidden = NO;
        }else{
            self.leftImgV.image = nil;
            self.descRightMargin.constant = 20;
            self.topRightBtn.hidden = YES;
        }
    }else{
        self.titleLabel.text = @"作品分享";
        self.descLabel.text = @"分享作业求赞，点赞越多排名越靠前";
        self.startImgV.image = self.taskDetailModel.sp_task_list.is_share ? [UIImage imageNamed:@"star_select"]:[UIImage imageNamed:@"star_unselect"];
        self.timeLabelH.constant = 0;
        self.descLabelTopMargin.constant = 0;
        self.descRightMargin.constant = 15;
        self.leftImgV.image = nil;
        self.coverView.hidden = YES;
        self.topRightBtn.hidden = YES;
    }
}

- (IBAction)topRightBtnClick {
    self.menuView.hidden = !self.menuView.hidden;
}

- (IBAction)enlargeBtnClick {
    self.menuView.hidden = YES;
    if (self.didEnlargeBlock) {
        self.didEnlargeBlock();
    }
}

- (IBAction)deleteBtnClick {
    self.menuView.hidden = YES;
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}
@end
