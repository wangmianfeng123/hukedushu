//
//  HKSearchRecommendArticleCell.m
//  Code
//
//  Created by Ivan li on 2019/4/17.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchRecommendArticleCell.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKSearchCourseModel.h"

@implementation HKSearchRecommendArticleCell


- (void)createUI {
    [super createUI];
    [self.contentView addSubview:self.categoryLb];
    [self.contentView addSubview:self.moreBtn];
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
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryLb.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.avatorIV.mas_left).offset(-PADDING_5);
    }];
    
    [self.avatorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(120, 74));
    }];
    
    [self.userHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatorIV);
        make.left.equalTo(self.titleLB);
        make.width.height.mas_equalTo(PADDING_20);
    }];
    
    [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.left.equalTo(self.userHeaderIV.mas_right).offset(PADDING_5);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    
    [self.likeCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.right.equalTo(self.avatorIV.mas_left).offset(-17);
        make.left.equalTo(self.userNameLB.mas_right).offset(5).priorityLow();
    }];
    
    [self.readCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userHeaderIV);
        make.right.equalTo(self.likeCountLB.mas_left).offset(-PADDING_10);
    }];
    
    [self.exclusiveIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorIV);
        make.right.equalTo(self.avatorIV).offset(-PADDING_5);
    }];
}



- (UILabel*)categoryLb {
    if (!_categoryLb) {
        _categoryLb  = [UILabel labelWithTitle:CGRectZero title:@"文章"
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
    
    self.exclusiveIV.hidden = !model.is_exclusive;
    
    self.titleLB.text = model.title;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:model.cover_pic] placeholderImage:imageName(HK_Placeholder)];
    
    [self.userHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.userNameLB.text = model.name;
    self.likeCountLB.text = [NSString stringWithFormat:@"%@赞", model.appreciate_num];
    /// v2.17 隐藏
    //self.readCountLB.text = [NSString stringWithFormat:@"%@人阅读", model.show_num];
    
    if (matchModel.match_count >1) {
        NSString *title = [NSString stringWithFormat:@"查看%ld条结果",(long)matchModel.match_count];
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moreBtn.hidden = NO;
    }
}


@end
