//
//  HKLiveCourseInfoCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseInfoCell.h"
#import "UIView+HKLayer.h"

@interface HKLiveCourseInfoCell()

@property (nonatomic, strong) UILabel *l_titleLB;
@property (strong, nonatomic) UILabel *l_timeLB;
@property (strong, nonatomic) UILabel *l_numberLB;
@property (strong, nonatomic) UILabel *l_canSeeLB;

@property (nonatomic, strong)UIButton *liveBtn;// 直播标识
@property (nonatomic, strong)UIButton *downBtn;// 直播标识

@end

@implementation HKLiveCourseInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initMyCell];
    }
    return self;
}

- (void)initMyCell {
    
    // 初始化直播标识
    UIButton *liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    liveBtn.userInteractionEnabled = NO;
    self.liveBtn = liveBtn;
    [liveBtn setBackgroundColor:HKColorFromHex(0xFFEAE8, 1.0)];
    liveBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [liveBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateNormal];
    liveBtn.clipsToBounds = YES;
    [liveBtn setContentEdgeInsets:UIEdgeInsetsMake(4.5, 7, 4.5, 7)];
    liveBtn.layer.cornerRadius = 10.0;
    
    
    // 初始化直播标识
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downBtn = downBtn;
    //[downBtn setBackgroundColor:HKColorFromHex(0xFFEAE8, 1.0)];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [downBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    downBtn.clipsToBounds = YES;
    [downBtn setContentEdgeInsets:UIEdgeInsetsMake(4.5, 7, 4.5, 7)];
    //downBtn.layer.cornerRadius = 10.0;
    [downBtn addCornerRadius:10.0 addBoderWithColor:COLOR_27323F_EFEFF6];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.downBtn];
    
    // 标题
    self.l_titleLB = [[UILabel alloc] init];
    self.l_titleLB.textColor = COLOR_27323F_EFEFF6;
    self.l_titleLB.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.l_titleLB.text = @"";
    self.l_titleLB.numberOfLines = 0;
    [self addSubview:self.l_titleLB];
    [self.l_titleLB addSubview:self.liveBtn];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.l_titleLB);
    }];
    
    
    
    [self.l_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-35);
        make.top.mas_equalTo(self).offset(18);
    }];
    
//    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.l_titleLB.mas_right);
//        make.centerY.mas_equalTo(self.l_titleLB);
//    }];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = COLOR_F8F9FA_333D48;
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(7);
        make.left.bottom.right.mas_equalTo(self);
    }];
    
    // 时间
    self.l_timeLB = [[UILabel alloc] init];
    self.l_timeLB.text = @"";
    self.l_timeLB.textColor = COLOR_7B8196_A8ABBE;
    self.l_timeLB.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.l_timeLB];
    [self.l_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.l_titleLB);
        make.bottom.mas_equalTo(separator.mas_top).offset(-12);
    }];
    
    // 报名人数
    self.l_numberLB = [[UILabel alloc] init];
    self.l_numberLB.text = @"";
    self.l_numberLB.textColor = COLOR_A8ABBE_7B8196;
    self.l_numberLB.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.l_numberLB];
    [self.l_numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.l_timeLB);
        make.left.mas_equalTo(self.l_timeLB.mas_right).offset(15);
    }];
    
    // 可以回看
    self.l_canSeeLB = [[UILabel alloc] init];
    UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_27323F];
    self.l_canSeeLB.textColor = textColor;
    
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_A8ABBE];
    self.l_canSeeLB.backgroundColor = bgColor;
    self.l_canSeeLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.l_canSeeLB];
    self.l_canSeeLB.text = @"可回放";
    self.l_canSeeLB.textAlignment = NSTextAlignmentCenter;
    [self.l_canSeeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.l_numberLB);
        make.right.mas_equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(51, 20));
    }];
    self.l_canSeeLB.clipsToBounds = YES;
    self.l_canSeeLB.layer.cornerRadius = 10.0;
    
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.l_canSeeLB);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initMyCell];
}

- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    
    self.l_timeLB.text = model.live.start_live_at_str;
    self.l_numberLB.text = [NSString stringWithFormat:@"%@人报名", model.course.enrolment_people];
    
    self.l_canSeeLB.hidden = model.playback <= 0;
    
    // 嵌入 UIView
    NSString *btnStr = model.course.price.doubleValue > 0? @"收费" : @"免费";
    
    self.l_canSeeLB.hidden = model.course.price.doubleValue > 0? YES : NO;
    
    self.downBtn.hidden = model.course.price.doubleValue > 0? NO : YES;
    
    [self.liveBtn setTitle:btnStr forState:UIControlStateNormal];
    
    // 标题
    NSString *practiceString = model.course.name;
    practiceString = [NSString stringWithFormat:@"          %@", practiceString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:practiceString];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium] range:NSMakeRange(0, practiceString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, practiceString.length)];
    self.l_titleLB.attributedText = attributedString;
    
    [self.l_titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.courseNameHeight);
    }];
}

- (void)downBtnClick{
    if (self.downBtnBlock) {
        self.downBtnBlock();
    }
}
@end
