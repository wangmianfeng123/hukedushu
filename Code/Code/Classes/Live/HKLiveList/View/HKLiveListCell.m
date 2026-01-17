//
//  HKLiveListCell.m
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveListCell.h"
#import "HKLiveListModel.h"
  
#import "HKLiveCoverIV.h"


@interface HKLiveListCell()

@property (nonatomic, assign) HKLiveType liveType;

@end



@implementation HKLiveListCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self makeConstraints];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeLabel];
    
    [self.contentView addSubview:self.enrolmentBtn];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLabel];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.typeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.nameLabel.textColor = COLOR_7B8196_A8ABBE;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)makeConstraints {
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.height.mas_equalTo(211);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV.mas_bottom).offset(10);
        make.left.right.equalTo(self.coverIV);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(PADDING_5);
        make.centerY.equalTo(self.iconIV);
    }];
    
    [self.enrolmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160/2, 50/2));
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.iconIV);
    }];

}



- (HKLiveCoverIV*)coverIV {
    if (!_coverIV) {
        _coverIV = [[HKLiveCoverIV alloc]init];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]init];
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 10.0;
    }
    return _iconIV;
}



- (void)iconIVClick:(id)sender {
    self.avatarClickBlock ?self.avatarClickBlock(self.indexPath,self.model) :nil;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 18: 17];
    }
    return _titleLabel;
}

    
    
- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        [_nameLabel setTextColor:HKColorFromHex(0x7B8196, 1.0)];
        
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 12:11];
    }
    return _nameLabel;
}
    


- (UIButton *)enrolmentBtn {
    if (!_enrolmentBtn) {
        _enrolmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enrolmentBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
        [_enrolmentBtn setBackgroundImage:imageName(@"ic_blue_bg") forState:UIControlStateNormal];
        [_enrolmentBtn setBackgroundImage:imageName(@"ic_gray_bg") forState:UIControlStateSelected];
        
        [_enrolmentBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        [_enrolmentBtn setTitle:@"已报名" forState:UIControlStateSelected];
        
        [_enrolmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enrolmentBtn setTitleColor:COLOR_7B8196 forState:UIControlStateSelected];
        [_enrolmentBtn addTarget:self action:@selector(enrolmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _enrolmentBtn.userInteractionEnabled = NO;
        [_enrolmentBtn setHKEnlargeEdge:30];
    }
    return _enrolmentBtn;
}


- (void)enrolmentBtnClick:(UIButton *)btn {
    self.enrolmentBlock ?self.enrolmentBlock(self.indexPath,self.model) :nil;
}





- (UILabel*)typeLabel {
    
    if (!_typeLabel) {
        _typeLabel  = [[UILabel alloc] init];
        [_typeLabel setTextColor:COLOR_A8ABBE];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 14:13);
    }
    return _typeLabel;
}



- (void)updatePadConstraint {
    BOOL isLeftCell = self.indexPath.row % 2 == 0;
    [_coverIV mas_updateConstraints:^(MASConstraintMaker *make) {
        if (IS_IPAD) { // iPad
            if (isLeftCell) {// 左边cell
                make.left.equalTo(self.contentView).mas_offset(16);
                make.right.equalTo(self.contentView).mas_offset(-8);
            } else {// 右边cell
                make.left.equalTo(self.contentView).mas_offset(8);
                make.right.equalTo(self.contentView).mas_offset(-16);
            }
        } else { // iPhone
            make.left.equalTo(self.contentView).mas_offset(16);
            make.right.equalTo(self.contentView).mas_offset(-16);
        }
    }];
}

- (void)setModel:(HKLiveListModel *)model {
    
    _model = model;
    
    _titleLabel.text = model.name;
    _nameLabel.text = model.teacher_name;
    
    [_iconIV sd_setImageWithURL:HKURL(model.teacher_avator) placeholderImage:imageName(HK_Placeholder)];
    self.enrolmentBtn.selected = model.isEnroll;
    
    // 直播结束尚未报名
    if (model.live_status == HKLiveStatusEnd) {
        self.enrolmentBtn.selected = NO;
        [self.enrolmentBtn setTitle:@"观看回放" forState:UIControlStateNormal];
    } else if (!model.isEnroll) {
        // 没结束，已报名
        [self.enrolmentBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    }
    
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.surface_url]) placeholderImage:imageName(HK_Placeholder)];
    [self liveType:model];
    self.coverIV.liveType = self.liveType;
    
    // 底部信息
    self.coverIV.status = model.start_live_at_str;
    if (model.live_status == HKLiveStatusEnd && ([model.video_id isEqualToString:@"0"] || model.video_id == nil)) {
        // 直播已经结束，回放视频还没准备好
        self.coverIV.status = @"直播已结束，回放视频制作中";
    } if (model.live_status == HKLiveStatusEnd && ![model.video_id isEqualToString:@"0"]) {
        // 直播已经结束，回放视频已准备好
        self.coverIV.status = @"直播已结束，可观看回放视频";
    }
    // 直播已经结束，不可回放
    if (!model.can_replay && model.live_status == HKLiveStatusEnd) {
        // 直播已经结束，不可回放
        self.coverIV.status = @"直播已结束";
    }
    
    // 系列课 课程直播节数，公开课节数为1
    if (model.lession_num.intValue > 1) {
        self.coverIV.serLB.text = [NSString stringWithFormat:@"系列课 共%@节", model.lession_num];
        self.coverIV.serLB.hidden = NO;
    } else {
        self.coverIV.serLB.hidden = YES;
    }
    

    
}


/** 直播状态 */
- (void)liveType:(HKLiveListModel *)model {
    
    //当前直播状态0:未开始，1:开始直播,2:直播结束
    switch (model.live_status) {
        case 0:
        {
            if (model.is_in_a_hour) {
                self.liveType = HKLiveTypeWaiting;
            } else if (model.coutDownForLive < 0) {
                // 已经达到规定播放时间
                self.liveType = HKLiveTypePlaying;
            } else{
                self.liveType = HKLiveTypeEnrolment;
            }
        }
            break;
        case 1:
            self.liveType = HKLiveTypePlaying;
            break;
        case 2:
            self.liveType = HKLiveTypePlayEnd;
            break;
    }
}



@end









