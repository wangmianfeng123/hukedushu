




//
//  SeriseCourseCell.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriseCourseCollectionCell.h"
#import "SeriseCourseTagView.h"
#import "SeriseCourseModel.h"
#import "HKShadowImageView.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"

@interface SeriseCourseCollectionCell ()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)SeriseCourseTagView *courseTagView;// 课时数

@property(nonatomic,strong)SeriseCourseTagView *watchTagView;//观看数量

@property(nonatomic,strong)UIView *lineView;//分割线
/** 图片阴影 */
//@property(nonatomic,strong)HKShadowImageView *bgImageView;
/** 系列课 更新状态 */
@property(nonatomic,strong)HKCustomMarginLabel *stateLabel;
/** 课程数量 */
@property(nonatomic,strong)HKCustomMarginLabel *countLB;


@end


@implementation SeriseCourseCollectionCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.watchTagView];
    [self.contentView addSubview:self.courseTagView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.countLB];
    
}

//-(void)setFrame:(CGRect)frame{
//    // 往下移动一个分割线
//    frame.origin.x += 5;
//    frame.origin.y += 5;
//    frame.size.height -= 10;
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    if (self.model) {
//        [self homeCellConstraints];
    }else{
        [self searchCellConstraints];
    }
}


/**首页 系列课 约束 */
//- (void)homeCellConstraints {
//
//    WeakSelf;
////    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(_iconImageView).offset(-9);
////        make.right.left.bottom.equalTo(_iconImageView);
////    }];
//
//    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(weakSelf.contentView).offset(15);
//        make.top.equalTo(weakSelf.contentView).offset(6);
//        make.width.mas_equalTo(142 *Ratio);
//        make.bottom.mas_equalTo(weakSelf.contentView).mas_offset(-18);
//    }];
//
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
////        if (IS_IPAD) {
////            make.top.equalTo(weakSelf.bgImageView.mas_top).offset(PADDING_10 * 2);
////        } else {
////            make.top.equalTo(weakSelf.bgImageView.mas_top).offset(PADDING_10);
////        }
//        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(15);
//        make.right.equalTo(weakSelf.contentView).offset(-15);
//    }];
//
//    [_courseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-10);
//        make.left.equalTo(weakSelf.titleLabel).mas_offset(-2);
//        //        make.top.lessThanOrEqualTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_10);
//    }];
//
//    [_watchTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(weakSelf.courseTagView);
//        make.left.equalTo(weakSelf.courseTagView.mas_right).offset(PADDING_10);
//    }];
//
//    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        if (IS_IPAD) {
//            make.bottom.equalTo(weakSelf.watchTagView.mas_top).offset(-PADDING_10 * 2);
//        } else {
//            make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(5);
//        }
//        make.left.equalTo(weakSelf.titleLabel);
//        make.size.mas_equalTo(CGSizeMake(86 * 0.5, 37 * 0.5));
//    }];
//
//    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
//        make.left.right.equalTo(weakSelf.contentView);
//    }];
//
//}


/**搜索 系列课 约束 */
- (void)searchCellConstraints {
//    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_iconImageView).offset(-9);
//        make.right.left.bottom.equalTo(_iconImageView);
//    }];
//    BOOL isLeftCell = self.indexPath.row % 2 == 0;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
//        if (IS_IPAD) {
//            if (isLeftCell) {
//                make.left.equalTo(self.contentView).offset(15);
//                make.right.equalTo(self.contentView).offset(-7.5);
//            }else{
//                make.left.equalTo(self.contentView).offset(7.5);
//                make.right.equalTo(self.contentView).offset(-15);
//            }
//            make.height.mas_equalTo(210 * iPadHRatio);
//        }else{
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo( 210*(IS_IPAD ? iPadHRatio:Ratio));
//        }
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(7);
        make.left.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.courseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(15);
    }];
    
    [self.watchTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.courseTagView);
//        make.left.equalTo(self.courseTagView.mas_right).offset(8);
//        make.height.mas_equalTo(15);
        make.left.equalTo(self.titleLabel).offset(-5);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(15);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.courseTagView);
        make.right.equalTo(self.contentView.mas_right).offset(-37/2);
        make.height.mas_equalTo(16);
    }];
    
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.left.bottom.right.equalTo(self.iconImageView);
    }];
    
    [self.countLB layoutIfNeeded];
    [self.countLB setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode =UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
    }
    return _iconImageView;
}

//- (HKShadowImageView*)bgImageView {
//    if (!_bgImageView) {
//        _bgImageView = [[HKShadowImageView alloc]init];
//        _bgImageView.cornerRadius = 5;
//        //_bgImageView.offSet = 3;
//        _bgImageView.offSet = 4.5;
//    }
//    return _bgImageView;
//}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F_EFEFF6];
        _titleLabel.font = HK_FONT_SYSTEM(15);
    }
    return _titleLabel;
}



- (HKCustomMarginLabel*)stateLabel {
    if (!_stateLabel) {
        _stateLabel  = [[HKCustomMarginLabel alloc] init];
        _stateLabel.textInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        [_stateLabel setTextColor:COLOR_A8ABBE_7B8196];
        _stateLabel.font = HK_FONT_SYSTEM(12);
        _stateLabel.clipsToBounds = YES;
        _stateLabel.layer.cornerRadius = 8;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_eeeeee;
        _lineView.hidden = YES;
    }
    return _lineView;
}


- (SeriseCourseTagView*)courseTagView {
    if (!_courseTagView) {
        _courseTagView = [[SeriseCourseTagView alloc]init];
    }
    return _courseTagView;
}


- (SeriseCourseTagView*)watchTagView {
    if (!_watchTagView) {
        _watchTagView = [[SeriseCourseTagView alloc]init];
    }
    return _watchTagView;
}



- (HKCustomMarginLabel*)countLB {
    if (!_countLB) {
        _countLB  = [[HKCustomMarginLabel alloc] init];
        _countLB.textInsets = UIEdgeInsetsMake(7, 15, 7, 15);
        [_countLB setTextColor:[UIColor whiteColor]];
        _countLB.font = HK_FONT_SYSTEM(14);
        _countLB.textAlignment = NSTextAlignmentLeft;
        _countLB.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    }
    return _countLB;
}







//- (void)setModel:(SeriseCourseModel *)model hideLine1:(BOOL)hideLine1 hideLine2:(BOOL)hideLine2{
//    _model = model;
//    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:imageName(HK_Placeholder)];
//    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
//    [_courseTagView setImageWithName:@"" text:[NSString stringWithFormat:@"%@节课", model.lesson_total] isHidden:YES];
//    [_watchTagView setImageWithName:@"" text:[NSString stringWithFormat:@"%@人观看", model.watch_nums] isHidden:YES];
//    //update_status：0-已完结 1-更新中
//    NSString *temp = nil;
//    if ([model.update_status isEqualToString:@"0"]) {
//        temp = @"已完结";
//        [_stateLabel setTextColor:HKColorFromHex(0xA8ABBE, 1.0)];
//         _stateLabel.backgroundColor = HKColorFromHex(0xF3F3F6, 1.0);
//    }else{
//        temp = @"更新中";
//       _stateLabel.backgroundColor = HKColorFromHex(0xFFD710, 1.0);
//        [_stateLabel setTextColor:HKColorFromHex(0xFFFFFF, 1.0)];
//    }
//    _stateLabel.text = temp;
//    //    // 隐藏显示分割线
//    //    self.lineView.hidden = hideLine1;
//    //    self.lineView2.hidden = hideLine2;
//    //    self.lineView2.hidden = !hideLine1;
//}


- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover_image_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",videoModel.title];
    
    //NSString *lesson = [NSString stringWithFormat:@"%@节课",videoModel.lesson_total];
    //NSString *watch = [NSString stringWithFormat:@"%@人看过",videoModel.watch_nums];
    
    /// v2.11
    NSString *lesson = [NSString stringWithFormat:@"%@节课",videoModel.video_total];
    //NSString *watch = [NSString stringWithFormat:@"%@人看过",videoModel.study_total];
    [_courseTagView setImageWithName:nil text:lesson isHidden:YES];
    [_watchTagView setImageWithName:nil text:nil isHidden:YES];
    
//    //update_status：0-已完结 1-更新中
//    NSString *temp = nil;
//    if ([videoModel.update_status isEqualToString:@"0"]) {
//        temp = @"已完结";
//        [_stateLabel setTextColor:COLOR_A8ABBE];
//        _stateLabel.backgroundColor = HKColorFromHex(0xF3F3F6, 1.0);
//    }else{
//        temp = @"更新中";
//        [_stateLabel setTextColor:COLOR_ffffff];
//        _stateLabel.backgroundColor = HKColorFromHex(0xFFD710, 1.0);
//    }
//    _stateLabel.text = temp;
    
    _courseTagView.hidden = YES;
//    _stateLabel.hidden = YES;
    
    _countLB.text = [NSString stringWithFormat:@"共%@节",videoModel.video_total];
}


@end








