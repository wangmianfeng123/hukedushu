//
//  HKJobPathCourseListBottomView.m
//  Code
//
//  Created by Ivan li on 2019/6/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseListBottomView.h"
#import "UIImage+Helper.h"
  
#import "UIButton+ImageTitleSpace.h"
#import "HKJobPathModel.h"


@interface HKJobPathCourseListBottomView()

@property (nonatomic,strong) UIButton *studyBtn;
/** 课程数量 */
@property (nonatomic,strong) UILabel *courseLB;
/** 上次学习记录 */
@property (nonatomic,strong) UILabel *recordLB;

@property (nonatomic,strong) UIButton *goOnBtn;

@end



@implementation HKJobPathCourseListBottomView



//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self createUI];
//    }
//    return self;
//}
//
//
//- (instancetype)init {
//    if (self = [super init]) {
//        [self createUI];
//    }
//    return  self;
//}



- (void)createUI {
    
    if (HKJobPathCourseListBottomViewType_Study ==  self.viewType) {
        [self addSubview:self.studyBtn];
    }else {
        [self addSubview:self.courseLB];
        [self addSubview:self.recordLB];
        [self addSubview:self.goOnBtn];
    }
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    if (HKJobPathCourseListBottomViewType_Study ==  self.viewType) {
        [self.studyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }else {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
        
        [self.courseLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.top.equalTo(self).offset(10);
        }];
        
        [self.goOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(IS_IPHONE_X ?-7.5 :0);
            make.right.equalTo(self).offset(-30);
        }];
        
        [self.recordLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.courseLB);
            make.top.equalTo(self.courseLB.mas_bottom).offset(5);
            //make.bottom.equalTo(self).offset(-10);
            make.right.lessThanOrEqualTo(self.goOnBtn.mas_left).offset(-1);
        }];
    }
}



- (UILabel*)courseLB {
    if (!_courseLB) {
        _courseLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF7820 titleFont:@"15" titleAligment:0];
        _courseLB.font = HK_FONT_SYSTEM_BOLD(15);
    }
    return _courseLB;
}


- (UILabel*)recordLB {
    if (!_recordLB) {
        _recordLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF7820 titleFont:@"13" titleAligment:0];
    }
    return _recordLB;
}


- (UIButton*)goOnBtn {
    if (!_goOnBtn) {
        
        _goOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goOnBtn addTarget:self action:@selector(goOnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goOnBtn setHKEnlargeEdge:20];
        
        [_goOnBtn setBackgroundImage:imageName(@"ic_goondownload_v2_13") forState:UIControlStateNormal];
        [_goOnBtn setBackgroundImage:imageName(@"ic_goondownload_v2_13") forState:UIControlStateHighlighted];
        
//        UIColor *color = [UIColor colorWithHexString:@"#FFB600"];
//        UIColor *color1 = [UIColor colorWithHexString:@"#FFA100"];
//        UIColor *color2 = [UIColor colorWithHexString:@"#FF8A00"];
//
//        [_goOnBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
//        [_goOnBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
//        [_goOnBtn setTitleColor:COLOR_ffffff forState:UIControlStateHighlighted];
//        [_goOnBtn setTitle:@"继续学习" forState:UIControlStateNormal];
//        [_goOnBtn setTitle:@"继续学习" forState:UIControlStateHighlighted];
//
//        _goOnBtn .clipsToBounds = YES;
//        _goOnBtn.layer.cornerRadius = 11.5;
//
//        [_goOnBtn setImage:imageName(@"ic_go_right_v2_13") forState:UIControlStateNormal];
//        [_goOnBtn setImage:imageName(@"ic_go_right_v2_13") forState:UIControlStateHighlighted];
//
//        [_goOnBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:6];
//
//        [_goOnBtn gradientButtonWithSize:CGSizeMake(82, 23) colorArray:@[color2,color1,color] percentageArray:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
    }
    return _goOnBtn;
}



- (void)goOnBtnClick:(UIButton*)btn {
    if (self.goOnBtnClickBlock) {
        self.goOnBtnClickBlock(self.model);
    }
}



- (UIButton*)studyBtn {
    if (!_studyBtn) {
        
        _studyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_studyBtn addTarget:self action:@selector(studyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_studyBtn setHKEnlargeEdge:20];
        
        [_studyBtn.titleLabel setFont:HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightMedium)];
        [_studyBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_studyBtn setTitleColor:COLOR_ffffff forState:UIControlStateHighlighted];
        
        [_studyBtn setTitle:@"开始学习" forState:UIControlStateNormal];
        [_studyBtn setTitle:@"开始学习" forState:UIControlStateHighlighted];
        _studyBtn .clipsToBounds = YES;
        _studyBtn.layer.cornerRadius = 19;
        
        UIColor *color = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA100"];
        UIColor *color2 = [UIColor colorWithHexString:@"#FF8A00"];
        
        [_studyBtn gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH-60, 38) colorArray:@[color2,color1,color] percentageArray:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
    }
    return _studyBtn;
}


- (void)studyBtnClick:(UIButton*)btn {
    
    if (self.studyBtnClickBlock) {
        self.studyBtnClickBlock(self.model);
    }
}




- (void)setModel:(HKJobPathStudyedModel *)model {
    _model = model;
    
    if (HKJobPathCourseListBottomViewType_Study ==  self.viewType) {
        
    }else {
        NSString *course = [NSString stringWithFormat:@"已学%ld节/共%ld节",(long)model.studiedCount,(long)model.total_count];
        self.courseLB.text = course;
        
        NSString *record = [NSString stringWithFormat: @"上次学到 %@ %@",model.lastStudied.chapter_title,model.lastStudied.video_title];
        self.recordLB.text = record;
    }
}




- (void)removeJobPathCourseListBottomView {
    [self removeFromSuperview];
}

@end

