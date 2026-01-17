//
//  HKSearchSoftwareCell.m
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchSoftwareCell.h"
#import "HKCustomMarginLabel.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKSearchCourseModel.h"


@implementation HKSearchSoftwareCell



- (void)createUI {
    [super createUI];
    [self.contentView addSubview:self.categoryLb];
    [self.contentView addSubview:self.moreBtn];
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
}



- (void)makeConstraints {
    
    
    [self.categoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.categoryLb);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.categoryLb.mas_bottom).offset(PADDING_20);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(3);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(PADDING_15/2);
        make.right.lessThanOrEqualTo(self.contentView);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.studyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.iconImageView).offset(-3);
        //make.right.equalTo(self.contentView).offset(-PADDING_5);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.studyCountLabel.mas_right).offset(PADDING_15/2);
        make.width.mas_equalTo(0.5);
        make.top.equalTo(self.studyCountLabel).offset(2);
        make.bottom.equalTo(self.studyCountLabel).offset(-2);
    }];
    
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.studyCountLabel);
        make.left.equalTo(self.lineLabel.mas_right).offset(PADDING_15/2);
    }];
    
    [self.exerciseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.studyCountLabel);
        make.left.equalTo(self.courseLabel.mas_right).offset(45/2);
        make.right.lessThanOrEqualTo(self.contentView).offset(-PADDING_5);
    }];
}


- (UILabel*)categoryLb {
    if (!_categoryLb) {
        _categoryLb  = [UILabel labelWithTitle:CGRectZero title:@"软件"
                                    titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _categoryLb.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _categoryLb;
}


- (UIButton*)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setHKEnlargeEdge:20];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}


- (void)moreBtnClick:(UIButton*)btn {
    if (self.moreBtnClickBackCall) {
        self.moreBtnClickBackCall();
    }
}




- (void)setMatchModel:(HKTeacherMatchModel *)matchModel {
    _matchModel = matchModel;
    
    HKFirstMatchModel *model = nil;
    if (matchModel.first_match.count) {
        model = matchModel.first_match[0];
    }
    
    self.titleLabel.text = model.title;
    self.studyCountLabel.text = [NSString stringWithFormat:@"%@人已学", model.study_num];
    self.courseLabel.text = [NSString stringWithFormat:@"%@课",model.master_curriculum];
    self.exerciseLabel.text = [NSString stringWithFormat:@"%@练习",model.slave_curriculum];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.app_small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    
    ///** is_end：1-已完结 0-更新中*/3
    if ([model.is_end isEqualToString:@"1"]) {
        self.stateLabel.text = @"已完结";
        self.stateLabel.textColor = COLOR_A8ABBE_27323F;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_7B8196];
        self.stateLabel.backgroundColor = bgColor;
    }else{
        self.stateLabel.text = @"更新中";
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.backgroundColor = COLOR_FFD710;
    }
    
    if (matchModel.match_count >1) {
        NSString *title = [NSString stringWithFormat:@"查看%ld条结果",(long)matchModel.match_count];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moreBtn.hidden = NO;
    }
}



@end
