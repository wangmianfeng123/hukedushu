//
//  HKInternetSchoolCell.m
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKInternetSchoolCell.h"
#import "HKLiveListModel.h"
#import "HKLiveCoverIV.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"
#import "UIView+LayoutSubviewsCallback.h"

@interface HKInternetSchoolCell()

@property (nonatomic, assign) HKLiveType liveType;
/// 折扣价格
@property (nonatomic, strong)UILabel *discountPriceLB;
/// 团购
@property (nonatomic, strong)HKCustomMarginLabel *groupLB;

@end



@implementation HKInternetSchoolCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.discountPriceLB];
    [self.contentView addSubview:self.groupLB];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.nameLabel.textColor = COLOR_7B8196_A8ABBE;
    
    [self makeConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.left.equalTo(self.contentView).offset(PADDING_15);;
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.height.mas_equalTo(153);
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

    [self.groupLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
     }];
    
    [self.discountPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.right.equalTo(self.groupLB.mas_left).offset(-PADDING_10);
        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).offset(2);
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
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"17" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

    
    
- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}
    

- (UILabel*)discountPriceLB {
    if (!_discountPriceLB) {
        _discountPriceLB  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF3221  titleFont:@"13" titleAligment:NSTextAlignmentRight];
        [_discountPriceLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _discountPriceLB;
}


- (HKCustomMarginLabel*)groupLB {
    if (!_groupLB) {
        _groupLB = [[HKCustomMarginLabel alloc]initWithFrame:CGRectMake(0, 0, 32, 18)];
        _groupLB.textAlignment = NSTextAlignmentLeft;
        _groupLB.font = HK_TIME_FONT(11);
        _groupLB.textInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        _groupLB.textColor = COLOR_FF3221;
               
        CGRect rect = CGRectMake(0, 0, 32, 18);
        __block CAShapeLayer *shapeLayer = [_groupLB shapeLayerWithRect:rect lineWidth:0.5 strokeColor:COLOR_FF3221 maskPath:nil];
        [_groupLB.layer addSublayer:shapeLayer];
        
        _groupLB.layoutSubviewsCallback = ^(UIView *view) {
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                           byRoundingCorners:UIRectCornerAllCorners
                                                                 cornerRadii:CGSizeMake(5, 5)];
            shapeLayer.path = maskPath.CGPath;
            shapeLayer.frame = view.bounds;
        };
    }
    return _groupLB;
}




- (void)setModel:(HKLiveListModel *)model {
    
    _model = model;
    _titleLabel.text = model.name;
    _nameLabel.text = model.teacher_name;
    
    [self.iconIV sd_setImageWithURL:HKURL(model.teacher_avator) placeholderImage:imageName(HK_Placeholder)];
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.surface_url]) placeholderImage:imageName(HK_Placeholder)];
    
    [self liveType:model];
    self.coverIV.liveType = self.liveType;
    
    /// 感兴趣人数
    self.coverIV.status = model.view;
    [self.coverIV setHiddenText:NO];
    
    self.coverIV.serLB.text = model.start_live_at_str;
    self.coverIV.serLB.hidden = NO;
    self.coverIV.serLB.font = HK_FONT_SYSTEM(14);
    [self.coverIV setTextFont:HK_FONT_SYSTEM_BOLD(14)];
    
    if (!isEmpty(model.price)) {
        NSString *str = [NSString stringWithFormat:@"¥ %@",model.price];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_FF3221 range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(12) range:NSMakeRange(0,1)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(16) range:NSMakeRange(1,attrString.length-1)];
        self.discountPriceLB.attributedText = attrString;
    }
    float price = [model.price floatValue];
    self.discountPriceLB.hidden = (price <=0);
    
    
    if ((price <=0)) {
        self.groupLB.text = isEmpty(model.price_desc) ?nil : model.price_desc;
        self.groupLB.hidden = isEmpty(model.price_desc);
    }else{
        self.groupLB.text = nil;
        self.groupLB.hidden = YES;
    }
    
    [self.groupLB mas_updateConstraints:^(MASConstraintMaker *make) {
        float price = [self.model.price floatValue];
        if ((price >0)) {
            make.right.equalTo(self.contentView).offset(PADDING_5);
        }else{
            make.right.equalTo(self.contentView).offset(-PADDING_15);
        }
     }];
    
    //self.groupLB.text = isEmpty(model.price_desc) ?nil : model.price_desc;
    //self.groupLB.hidden = isEmpty(model.price_desc);
}


/** 直播状态 */
- (void)liveType:(HKLiveListModel *)model {
    
    //当前直播状态0:未开始，1:开始直播,2:直播结束
    switch (model.live_status) {
        case 0:
        {
            if (model.is_in_a_hour) {
                self.liveType = HKLiveTypeWaiting;
            }else{
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





    // 底部时间
//    self.coverIV.status = model.start_live_at_str;
//    if (model.live_status == HKLiveStatusEnd && ([model.video_id isEqualToString:@"0"] || model.video_id == nil)) {
//        // 直播已经结束，回放视频还没准备好
//        self.coverIV.status = @"直播已结束，回放视频制作中";
//    } if (model.live_status == HKLiveStatusEnd && ![model.video_id isEqualToString:@"0"]) {
//        // 直播已经结束，回放视频已准备好
//        self.coverIV.status = @"直播已结束，可观看回放视频";
//    }
//    // 直播已经结束，不可回放
//    if (!model.can_replay && model.live_status == HKLiveStatusEnd) {
//        self.coverIV.status = @"直播已结束";
//    }
//
//    // 系列课 课程直播节数，公开课节数为1
//    if (model.lession_num.intValue > 1) {
//        self.coverIV.serLB.text = [NSString stringWithFormat:@"系列课 共%@节", model.lession_num];
//        self.coverIV.serLB.hidden = NO;
//    } else {
//        self.coverIV.serLB.hidden = YES;
//    }
