//
//  HKMyLiveCell.m
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKMyLiveCell.h"
#import "HKMyLiveModel.h"
#import "UIView+HKLayer.h"
#import "HKImageTextIV.h"

@interface HKMyLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UIImageView *teacherIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *teacherIcon2;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImgV;
@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画

@end

@implementation HKMyLiveCell

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKLiveAnimationType_videoDetail;
    }
    return _animationIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.teacherIcon1.hidden = YES;
    self.teacherIcon2.hidden = YES;
    self.teacherName.hidden = YES;
    
    [self.imgV addCornerRadius:5];
    [self.teacherIcon1 addCornerRadius:10];
    [self.teacherIcon2 addCornerRadius:10];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.editLabel.textColor = COLOR_A8ABBE_7B8196;
    self.teacherName.textColor = COLOR_7B8196_A8ABBE;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
   
    [self.contentView insertSubview:self.animationIV belowSubview:self.titleLabel];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.teacherIcon1);
        make.left.mas_equalTo(SCREEN_WIDTH - 80);
    }];
}

-(void)setModel:(HKMyLiveModel *)model{
    _model = model;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLabel.text = model.name;
    self.timeLabel.text = model.start_live_at;
    
    if (model.teacher.count == 1) {
        self.teacherIcon1.hidden = NO;
        self.teacherIcon2.hidden = YES;
        self.teacherName.hidden = NO;
        HKLiveTeachModel * teach = model.teacher[0];
        [self.teacherIcon1 sd_setImageWithURL:[NSURL URLWithString:teach.avator] placeholderImage:imageName(HK_Placeholder)];
        self.teacherName.text = teach.name;
    }else if (model.teacher.count >=2){
        self.teacherIcon1.hidden = NO;
        self.teacherIcon2.hidden = NO;
        self.teacherName.hidden = YES;
        HKLiveTeachModel * teach = model.teacher[0];
        [self.teacherIcon1 sd_setImageWithURL:[NSURL URLWithString:teach.avator] placeholderImage:imageName(HK_Placeholder)];
        HKLiveTeachModel * teach1 = model.teacher[1];
        [self.teacherIcon2 sd_setImageWithURL:[NSURL URLWithString:teach1.avator] placeholderImage:imageName(HK_Placeholder)];
    }else{
        self.teacherIcon1.hidden = YES;
        self.teacherIcon2.hidden = YES;
        self.teacherName.hidden = YES;
    }
        // 正在播放的动画
    self.animationIV.isAnimation = [model.live_status isEqualToString:@"1"] ? YES : NO;// 正在播放
        [self.animationIV text:@"直播中" hiddenIfTextEmpty:NO];
    self.animationIV.hidden = [model.live_status isEqualToString:@"1"] ? NO : YES;
}


-(void)setVideoModel:(VideoModel *)videoModel{
    _videoModel = videoModel;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:_videoModel.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLabel.text = _videoModel.name;
    self.timeLabel.text = _videoModel.recentStudy;
    
    self.editLabel.hidden = NO;
    self.editImgV.hidden = NO;
    self.editLabel.text = [NSString stringWithFormat:@"已学%@节/共%@节",videoModel.studyNum,videoModel.lession_num];
    
    if (_videoModel.teacher.count == 1) {
        self.teacherIcon1.hidden = NO;
        self.teacherIcon2.hidden = YES;
        self.teacherName.hidden = NO;
        HKLiveTeachModel * teach = _videoModel.teacher[0];
        [self.teacherIcon1 sd_setImageWithURL:[NSURL URLWithString:teach.avator] placeholderImage:imageName(HK_Placeholder)];
        self.teacherName.text = teach.name;
    }else if (_videoModel.teacher.count >=2){
        self.teacherIcon1.hidden = NO;
        self.teacherIcon2.hidden = NO;
        self.teacherName.hidden = YES;
        HKLiveTeachModel * teach = _videoModel.teacher[0];
        [self.teacherIcon1 sd_setImageWithURL:[NSURL URLWithString:teach.avator] placeholderImage:imageName(HK_Placeholder)];
        HKLiveTeachModel * teach1 = _videoModel.teacher[1];
        [self.teacherIcon2 sd_setImageWithURL:[NSURL URLWithString:teach1.avator] placeholderImage:imageName(HK_Placeholder)];
    }else{
        self.teacherIcon1.hidden = YES;
        self.teacherIcon2.hidden = YES;
        self.teacherName.hidden = YES;
    }
    self.animationIV.hidden = YES ;
}
@end
