//
//  HKStudyMedalCell.m
//  Code
//
//  Created by Ivan li on 2018/9/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyMedalCell.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKCustomMarginLabel.h"
#import "HKMyLearningCenterModel.h"
#import "BannerModel.h"




@implementation HKStudyBtn


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.layer.cornerRadius = PADDING_5;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
    [self setTitleColor:COLOR_27323F forState:UIControlStateNormal];
    
    [self addSubview:self.tagLB];
    [self layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(-4);
        make.right.equalTo(self.mas_right).offset(5);
        make.height.equalTo(@15);
    }];
}



- (HKCustomMarginLabel*)tagLB {
    if (!_tagLB) {
        _tagLB = [[HKCustomMarginLabel alloc] init];
        _tagLB.textInsets = UIEdgeInsetsMake(2, 10, 2, 10);
        _tagLB.textColor = [UIColor whiteColor];
        _tagLB.font = HK_FONT_SYSTEM(11);
        _tagLB.clipsToBounds = YES;
        _tagLB.layer.cornerRadius = 15/2;
        _tagLB.textAlignment = NSTextAlignmentLeft;
        _tagLB.backgroundColor = COLOR_FF3221;
        _tagLB.hidden = YES;
    }
    return _tagLB;
}


- (void)setTagText:(NSString *)tagText {
    _tagText = tagText;
    if (!isEmpty(tagText)) {
        self.tagLB.text = tagText;
        _tagLB.hidden = NO;
    }else{
        _tagLB.hidden = YES;
    }
}


@end






@implementation HKStudyMedalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    
    HKStudyMedalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKStudyMedalCell"];
    if (!cell) {
        cell = [[HKStudyMedalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKStudyMedalCell"];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_F8F9FA;
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(4);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_10);
        make.right.equalTo(self.contentView.mas_centerX).offset(-PADDING_5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.leftBtn);
        make.left.equalTo(self.contentView.mas_centerX).offset(PADDING_5);
        make.right.equalTo(self.contentView).offset(-PADDING_10);
    }];
}




- (HKStudyBtn*)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [HKStudyBtn new];
        _leftBtn.tag = 100;
        [_leftBtn setImage:imageName(@"ic_mystudy_medal") forState:UIControlStateNormal];
        [_leftBtn setImage:imageName(@"ic_mystudy_medal") forState:UIControlStateHighlighted];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}


- (HKStudyBtn*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HKStudyBtn new];
        _rightBtn.tag = 102;
        [_rightBtn setImage:imageName(@"myStudy_heart") forState:UIControlStateNormal];
        [_rightBtn setImage:imageName(@"myStudy_heart") forState:UIControlStateHighlighted];
        [_rightBtn setTitle:@"学习兴趣" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}




- (void)leftBtnClick {
    
    self.hkStudyMedalCellBlock? self.hkStudyMedalCellBlock(100) :nil;
}



- (void)rightBtnClick {
    self.hkStudyMedalCellBlock ?self.hkStudyMedalCellBlock(102) :nil;
}



- (void)setModel:(HKMyLearningCenterModel *)model {
    
    _model = model;
    NSString *title = @"勋章成就";
//    NSInteger achieveCount = model.achievement_info.completedAchieveCount;
//    if (model.achievement_info.completedAchieveCount) {
//        title = [NSString stringWithFormat:@"%ld%@",(long)achieveCount,title];
//    }
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
    
    NSString *tag = nil;
    NSInteger unclaimedAchieveCount = model.achievement_info.unclaimedAchieveCount;
    if (unclaimedAchieveCount) {
        tag = [NSString stringWithFormat:@"领取%ld个奖励",(long)unclaimedAchieveCount];
    }
    [self.leftBtn setTagText:tag];
}


@end








