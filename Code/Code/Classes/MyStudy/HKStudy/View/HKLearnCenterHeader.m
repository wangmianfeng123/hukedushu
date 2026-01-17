//
//  HKLearnCenterHeader.m
//  03-基本图形绘制
//
//  Created by hanchuangkeji on 2018/1/29.
//  Copyright © 2018年 xiaomage. All rights reserved.
//

#import "HKLearnCenterHeader.h"
#import "UIView+HKExtension.h"
#import "HKStudyCurvView.h"
#import <YYText/YYText.h>
#import "UIView+SNFoundation.h"



@interface HKAchieveImageBtn : UIButton

@property (nonatomic, strong)UIImageView *bgIV;

@property (nonatomic, strong)UIImageView *leftIV;

@property (nonatomic, strong)UIImageView *rightIV;

@property (nonatomic, strong)UILabel *label;

@end


@implementation HKAchieveImageBtn


- (instancetype)init {
    if (self = [super init]) {
        
        [self addSubview:self.bgIV];
        [self addSubview:self.label];
        [self addSubview:self.leftIV];
        [self addSubview:self.rightIV];
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgIV);
        make.centerX.equalTo(self.bgIV).offset(5);
    }];
    
    [self.leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.label.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.label.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
}


- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.image = imageName(@"myStudy_studybg");
    }
    return _bgIV;
}



- (UIImageView*)leftIV {
    if (!_leftIV) {
        _leftIV = [UIImageView new];
        _leftIV.contentMode = UIViewContentModeScaleAspectFit;
        _leftIV.image = imageName(@"myStudy_medal");
    }
    return _leftIV;
}


- (UIImageView*)rightIV {
    if (!_rightIV) {
        _rightIV = [UIImageView new];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightIV.image = imageName(@"arrow_right_white");

    }
    return _rightIV;
}

- (UILabel*)label {
    if (!_label) {
        _label = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    }
    return _label;
}


- (void)setAchieveCount:(NSString*)count {
    
    if ([count intValue]>0) {
        _label.text = [NSString stringWithFormat:@"%@学习成就",count];
    }
}


@end







@interface HKLearnCenterHeader()


@property (nonatomic, weak)UILabel *courseLB;

@property (nonatomic, weak)YYLabel *titleLB;

@property (nonatomic, weak)HKStudyCurvView *curvView;

@property (nonatomic, strong)HKAchieveImageBtn *studyImage;

@property (nonatomic, weak)UIView *contentainerView;

@end


@implementation HKLearnCenterHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = COLOR_FFFFFF_3D4752;
        
        UIView *contentainerView = [[UIView alloc] init];
//        contentainerView.clipsToBounds = YES;
//        contentainerView.layer.cornerRadius = 5.0;
        contentainerView.backgroundColor = COLOR_FFFFFF_3D4752;
        //contentainerView.frame = CGRectMake(9, 11, UIScreenWidth - 9 * 2, frame.size.height - 2 * 11);
        contentainerView.frame = CGRectMake(0, 0, UIScreenWidth, frame.size.height - 16.0);
        [self addSubview:contentainerView];
        self.contentainerView = contentainerView;
        /** 阴影*/
//        [contentainerView addShadowWithColor:COLOR_E1E7EB alpha:0.8 radius:4 offset:CGSizeMake(0, 2)];
        
        UILabel *label = [[UILabel alloc] init];
        //label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        label.font = [UIFont systemFontOfSize:16.0 ];
        label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        label.textColor = COLOR_27323F_EFEFF6;
        self.courseLB = label;
        
        NSString *str = @"总学习教程";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        label.attributedText = attrString;
        
        [label sizeToFit];
        label.x = 13;
        label.y = IS_IPHONE_X? 34.0 + 20.0 : 34.0;
        [self.contentainerView addSubview:label];
        
        
        YYLabel *labelRight = [[YYLabel alloc] init];
        labelRight.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
        labelRight.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        labelRight.backgroundColor = [UIColor grayColor];
        self.titleLB = labelRight;
        labelRight.text = @"0个";
        labelRight.textAlignment = NSTextAlignmentRight;
        [labelRight sizeToFit];
        labelRight.width = 150;
        labelRight.x = frame.size.width - 13 - labelRight.width;
        labelRight.centerY = label.centerY;
//        [self.contentainerView addSubview:labelRight];
        
        // 分割先
        UIView *separator = [[UIView alloc] init];
        separator.frame = CGRectMake(0, CGRectGetMaxY(labelRight.frame) + 10, frame.size.width, 0.5);
        separator.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1.0];
        separator.hidden = YES;
        [self.contentainerView addSubview:separator];
        
        
        UILabel *label7 = [[UILabel alloc] init];
        label7.font = [UIFont systemFontOfSize:12.0];
        label7.textColor = COLOR_A8ABBE_7B8196;
        label7.text = @"最近7天学习教程数/单位：个";
        [label7 sizeToFit];
        label7.x = 13;
        label7.y = CGRectGetMaxY(separator.frame) + 10;
        [self.contentainerView addSubview:label7];
        
        HKStudyCurvView *view2 = [[HKStudyCurvView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label7.frame) + 30.0, contentainerView.size.width, 143)];
        self.curvView = view2;
        [self.contentainerView addSubview:view2];
        
        [self.contentainerView addSubview:self.studyImage];
        
        /** 阴影*/
        //self.layer.cornerRadius = PADDING_5;
        //[self addShadowWithColor:COLOR_E1E7EB alpha:0.8 radius:5 offset:CGSizeMake(0, 2)];
        
    }
    return self;
}




- (void)setModel:(HKMyLearningCenterModel *)model {
    
    _model = model;
    //self.titleLB.text = [NSString stringWithFormat:@"%@个", model.study_total];
    self.curvView.model = model;
    
    if (!isEmpty(model.study_total)) {
        NSString *str = [NSString stringWithFormat:@"总学习教程 %@个", model.study_total];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(17) range:NSMakeRange(0, attrString.length)];
        self.courseLB.attributedText = attrString;
        [self.courseLB sizeToFit];
    }
    
    [self setAchieveCountWithModel:model ];
}


/** 成就 证书 */
- (void)setAchieveCountWithModel:(HKMyLearningCenterModel *)model {
    
    NSString *total = model.diploma_total;
    if (!isEmpty(total)) {
        NSInteger count = [total intValue];
        if (count >0) {
            _studyImage.hidden = NO;
            [self.studyImage setAchieveCount:model.diploma_total];
            [self.studyImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentainerView);
                make.centerY.equalTo(self.courseLB).offset(-2);
                make.height.equalTo(@28);
            }];
        }
    }
}


- (HKAchieveImageBtn*)studyImage {

    if (!_studyImage) {
        _studyImage = [[HKAchieveImageBtn alloc]init];
        [_studyImage addTarget:self action:@selector(studyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _studyImage.hidden = YES;
    }
    return _studyImage;
}


- (void)studyBtnClick:(id)sender {
    
    if ([self.learnCenterHeaderDelegate respondsToSelector:@selector(hkLearnCenterAchieveClick:)]) {
        [self.learnCenterHeaderDelegate hkLearnCenterAchieveClick:sender];
    }
}


@end


