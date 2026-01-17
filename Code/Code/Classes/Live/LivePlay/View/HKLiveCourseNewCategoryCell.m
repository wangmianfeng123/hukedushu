//
//  HKLiveCourseNewCategoryCell.m
//  Code
//
//  Created by ivan on 2020/5/19.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveCourseNewCategoryCell.h"
#import "HKLiveDetailModel.h"
#import "HKImageTextIV.h"
#import "HKLiveListModel.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"

@interface HKLiveCourseNewCategoryCell()

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  UILabel *startTimeLB;

@property (nonatomic,strong) HKImageTextIV *nowLiveView;

@property (nonatomic,strong) HKImageTextIV *leftAnimationView;
/// 视频状态
@property (strong, nonatomic)  HKCustomMarginLabel *typeLB;
/// 回放上传LB
@property (strong, nonatomic)  UILabel *uploadLB;

//@property (nonatomic , strong) HKCustomMarginLabel * freeLabel;
@property (nonatomic , strong) UIImageView * recentFlagImg;
@end

@implementation HKLiveCourseNewCategoryCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.leftAnimationView];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.startTimeLB];
    [self.contentView addSubview:self.uploadLB];
    [self.contentView addSubview:self.nowLiveView];
    [self.contentView addSubview:self.typeLB];
    [self.contentView addSubview:self.recentFlagImg];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (_model.isCurrent) {
//            make.left.equalTo(self.leftAnimationView.mas_right).offset(-8);
//        }else{
            make.left.equalTo(self.contentView).offset(38);
//        }
        make.top.equalTo(self.contentView).offset(17);
        make.right.lessThanOrEqualTo(self.contentView).inset(5);
    }];
    
    
    
    [self.startTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(38);
        make.right.lessThanOrEqualTo(self.uploadLB.mas_left).offset(-2);
    }];
    
    
    [self.typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.titleLB);
        //make.right.equalTo(self.contentView).offset(-PADDING_15);
        
        make.centerY.equalTo(self.startTimeLB.mas_centerY);
        make.left.equalTo(self.startTimeLB.mas_right).offset(5);
    }];
    
    [self.uploadLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startTimeLB);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.nowLiveView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.startTimeLB);
        make.right.mas_equalTo(self.contentView).offset(-3);
    }];
    
    [self.recentFlagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerY.equalTo(self.titleLB);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
//    [self.leftAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.uploadLB.mas_left).offset(0);
//        make.centerY.equalTo(self.uploadLB);
//    }];
}


- (HKImageTextIV*)nowLiveView  {
    if (!_nowLiveView) {
        _nowLiveView = [[HKImageTextIV alloc]init];
        _nowLiveView.isRemoveRoundedCorner = YES;
        _nowLiveView.liveAnimationType = HKLiveAnimationType_videoDetail;
        _nowLiveView.backgroundColor = COLOR_FFFFFF_333D48;
    }
    return _nowLiveView;
}


//- (HKImageTextIV*)leftAnimationView  {
//    if (!_leftAnimationView) {
//        _leftAnimationView = [[HKImageTextIV alloc]init];
//        _leftAnimationView.isRemoveRoundedCorner = YES;
//        _leftAnimationView.liveAnimationType = HKLiveAnimationType_videoDetail;
//        _leftAnimationView.backgroundColor = COLOR_FFFFFF_333D48;
//    }
//    return _leftAnimationView;
//}



- (UILabel*)titleLB {
    if (!_titleLB) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_FF3221 dark:COLOR_FFB600];
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:textColor titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        //抗压缩的优先级
        [_titleLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLB;
}


- (UILabel*)startTimeLB {
    if (!_startTimeLB) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_FF3221 dark:COLOR_FFB600];
        _startTimeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:textColor titleFont:@"13" titleAligment:NSTextAlignmentLeft];
        [_startTimeLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _startTimeLB;
}



- (UILabel*)uploadLB {
    if (!_uploadLB) {
        _uploadLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentLeft];
        [_uploadLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        //_uploadLB.hidden = YES;
    }
    return _uploadLB;
}



- (HKCustomMarginLabel*)typeLB {
    if (!_typeLB) {
        _typeLB  = [[HKCustomMarginLabel alloc] init];
        _typeLB.textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        _typeLB.textColor =  [UIColor colorWithHexString:@"#0CC098"];
        _typeLB.font = HK_FONT_SYSTEM(10);
        _typeLB.textAlignment = NSTextAlignmentCenter;
        //_typeLB.backgroundColor = COLOR_FFEAE8;
        _typeLB.clipsToBounds = YES;
        _typeLB.layer.cornerRadius = 5;
        _typeLB.layer.borderWidth = 1.0;
        _typeLB.layer.borderColor = [UIColor colorWithHexString:@"#0CC098"].CGColor;
        _typeLB.hidden = NO;
    }
    return _typeLB;
}

//- (HKCustomMarginLabel *)freeLabel{
//    if (_freeLabel == nil) {
//        _freeLabel = [[HKCustomMarginLabel alloc] init];
//        _freeLabel.textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
//        _freeLabel.textColor =  [UIColor colorWithHexString:@"#0CC098"];
//        _freeLabel.font = HK_FONT_SYSTEM(10);
//        _freeLabel.textAlignment = NSTextAlignmentCenter;
//        _freeLabel.backgroundColor = COLOR_FFFFFF_3D4752;
//        _freeLabel.clipsToBounds = YES;
//        _freeLabel.layer.cornerRadius = 4;
//        _freeLabel.layer.borderWidth = 1.0;
//        _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CC098"].CGColor;
//        _freeLabel.hidden = NO;
//    }
//    return _freeLabel;
//}


- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    
    // 尚未开始，追加“未开始”
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.start_live_at.integerValue];
    NSDate* nowDate = [NSDate date];
    NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
    if (model.live_status == HKLiveStatusNotStart && time > 0) {
        //model.start_live_at_str = [NSString stringWithFormat:@"%@ 未开始", model.start_live_at_str];
    }
        
    self.titleLB.text = model.title;
    self.startTimeLB.text = model.start_live_at_str;
            
    self.titleLB.font =  [self titleLBFontWitModel:model];
    self.startTimeLB.font = [self startTimeLBFontWithModel:model];
    
    self.titleLB.textColor = [self titleLBTextColorWitModel:model];
    self.startTimeLB.textColor = [self startTimeLBTextColorWithModel:model];
    
    if (model.free_learn) {
        self.typeLB.text = @"免费试学";
        self.typeLB.hidden = NO;
    }else{
        self.typeLB.text = nil;
        self.typeLB.hidden = YES;
    }
    
    [self showOrHiddenUploadLBWithModel:model];
    
    self.nowLiveView.isAnimation = (HKLiveStatusLiving == model.live_status);
    
    [self.leftAnimationView text:@"" hiddenIfTextEmpty:NO];
    
    self.recentFlagImg.hidden = [model.recently_play intValue] ? NO : YES;
    //self.leftAnimationView.isAnimation = model.isCurrent;
}


/// uploadLB 的显示
- (void)showOrHiddenUploadLBWithModel:(HKLiveDetailModel *)model {
    switch (model.live_status) {
        case HKLiveStatusNotStart:{
            self.uploadLB.text = @"未开始";
            //self.uploadLB.hidden = NO;
        }
        break;
        
        case HKLiveStatusLiving:{
            self.uploadLB.text = @"直播中";
            self.uploadLB.textColor = COLOR_FF3221;

            //self.uploadLB.hidden = YES;
        }
        break;
            
        case HKLiveStatusEnd:{
            // 直播结束
            if (model.can_replay) {
                //self.uploadLB.hidden = NO;
                if (isEmpty(model.video_id) || (0 == [model.video_id intValue])) {
                    // 回放未上传
                    self.uploadLB.text = @"回放上传中";
                }else{
                    self.uploadLB.text = @"观看回放";
                }
            }else{
                self.uploadLB.text = @"已结束";
                //self.uploadLB.hidden = YES;
            }
        }
            break;
            
        default:
            //self.uploadLB.hidden = YES;
            break;
    }
}


- (UIFont*)titleLBFontWitModel:(HKLiveDetailModel *)model  {
    UIFont *font = model.isCurrent ? HK_FONT_SYSTEM_WEIGHT(15.0, UIFontWeightMedium) : HK_FONT_SYSTEM(15.0);
    return font;
}


- (UIFont*)startTimeLBFontWithModel:(HKLiveDetailModel *)model  {
    UIFont *font = model.isCurrent ? HK_FONT_SYSTEM_WEIGHT(13.0, UIFontWeightMedium) : HK_FONT_SYSTEM(13.0);
    return font;
}



- (UIColor*)titleLBTextColorWitModel:(HKLiveDetailModel *)model  {
    
    UIColor *textColor = nil;
    if (model.isCurrent) {
        textColor = [UIColor hkdm_colorWithColorLight:COLOR_FF3221 dark:COLOR_FFB600];
        self.titleLB.textColor = textColor;
    } else if (model.has_study) {// 已学
        textColor = COLOR_A8ABBE_7B8196;
    } else {
        // 普通的
        textColor = COLOR_27323F_EFEFF6;
    }
    return textColor;
}



- (UIColor*)startTimeLBTextColorWithModel:(HKLiveDetailModel *)model  {
    
    UIColor *textColor = nil;
    // 当前播放选中的
    if (model.isCurrent) {
        textColor = [UIColor hkdm_colorWithColorLight:COLOR_FF3221 dark:COLOR_FFB600];
    } else if (model.has_study) {// 已学
        textColor = COLOR_A8ABBE_7B8196;
    } else {
        // 普通的
        textColor = COLOR_A8ABBE_7B8196;
    }
    return textColor;
}

- (UIImageView *)recentFlagImg{
    if (_recentFlagImg == nil) {
        _recentFlagImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_recently_contents_2_39"]];
    }
    return _recentFlagImg;
}


@end
