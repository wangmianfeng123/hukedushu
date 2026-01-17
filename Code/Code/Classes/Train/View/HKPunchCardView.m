//
//  HKPunchCardView.m
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKPunchCardView.h"
#import "HKTrainDetailModel.h"
//#import "HKTrainTaskVideoModel.h"
//#import "HKAllTrainTaskModel.h"
//#import "HKTrainTaskModel.h"

@interface HKPunchCardView ()
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArray;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *playVideoImgV;

@end

@implementation HKPunchCardView

+ (HKPunchCardView *)createViewByFrame:(CGRect)frame{
    HKPunchCardView * view = [HKPunchCardView viewFromXib];
    view.frame = frame;
    
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

-(void)tapClick{
    if ([self.delegate respondsToSelector:@selector(punchCardViewDidTaskView:withTaskModel:)]) {
        [self.delegate punchCardViewDidTaskView:self.task_list withTaskModel:self.taskModel];
    }
}

-(void)setTask_list:(HKAllTrainTaskModel *)task_list{
    _task_list = task_list;
    self.taskTypeLabel.text = @"作业打卡";
    self.taskNameLabel.text = task_list.video_title;
    self.taskNameLabel.textColor = [UIColor whiteColor];
    self.taskTypeLabel.backgroundColor = [UIColor colorWithHexString:@"#EFEFF6"];
    self.taskTypeLabel.textColor = [UIColor colorWithHexString:@"#A8ABBE"];
    //self.timeLabel.hidden = YES;
    
    for (int i = 0; i<_imgArray.count; i++) {
        UIImageView * imgV = _imgArray[i];
        if (i == 0) {
            imgV.image = task_list.is_look ? [UIImage imageNamed:@"star_select"] : [UIImage imageNamed:@"star_unselect"];
        }
        if (i == 1) {
            imgV.image = task_list.is_clock ? [UIImage imageNamed:@"star_select"] : [UIImage imageNamed:@"star_unselect"];
        }
        if (i == 2) {
            imgV.image = task_list.is_share ? [UIImage imageNamed:@"star_select"] : [UIImage imageNamed:@"star_unselect"];
        }        
    }
    self.bgView.hidden = NO;
    self.playVideoImgV.hidden = NO;
}

-(void)setTaskModel:(HKTrainTaskModel *)taskModel{
    _taskModel = taskModel;
    self.taskTypeLabel.text = @"特殊任务";
    self.taskNameLabel.text = taskModel.live_name;
    self.taskNameLabel.textColor = [UIColor blackColor];
    self.taskTypeLabel.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    self.taskTypeLabel.textColor = [UIColor colorWithHexString:@"#FF7820"];
    self.timeLabel.text = [NSString stringWithFormat:@"直播时间：%@-%@",taskModel.live_start_at,taskModel.live_end_at];
    for (int i = 0; i<_imgArray.count; i++) {
        UIImageView * imgV = _imgArray[i];
        if (i == 0) {
            imgV.hidden = NO;
            if (taskModel.is_finish) {
                imgV.image = [UIImage imageNamed:@"star_select"];
            }else{
                imgV.image = [UIImage imageNamed:@"star_unselect"];
            }
        }else{
            imgV.hidden = YES;
        }
    }
    
    self.playVideoImgV.hidden = YES;
    self.bgView.hidden = YES;
}

-(void)setDetailModel:(HKTrainDetailModel *)detailModel{
    _detailModel = detailModel;
    if (_task_list) {
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:_detailModel.video.image_url]]];
        
    }
    self.timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",_detailModel.video.time];
    self.timeLabel.textColor = [UIColor whiteColor];
}

@end
