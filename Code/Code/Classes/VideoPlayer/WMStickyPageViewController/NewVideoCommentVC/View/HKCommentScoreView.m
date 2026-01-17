//
//  HKCommentScoreView.m
//  Code
//
//  Created by Ivan li on 2018/5/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCommentScoreView.h"
#import "HKCustomMarginLabel.h"
#import "NewCommentModel.h"



@interface HKCommentScoreView()

/** 分数 */
@property (nonatomic,strong) UILabel *scoreLabel;
/** 难度等级 */
@property (nonatomic,strong) HKCustomMarginLabel *levelLabel;
/** 评价按钮 */
@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,strong) UILabel *bottomLine;
@property (nonatomic, strong) UIButton * commentTopRightBtn;

@end



@implementation HKCommentScoreView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
        self.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return self;
}


- (void)createUI {
//    self.hidden = YES;
    [self addSubview:self.scoreLabel];
    [self addSubview:self.levelLabel];
    [self addSubview:self.commentBtn];
    [self addSubview:self.commentTopRightBtn];

    [self addSubview:self.bottomLine];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {

    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.width.mas_lessThanOrEqualTo(120);
        make.centerY.equalTo(self);
    }];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.scoreLabel.mas_right).offset(6);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self);
    }];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(160 * 0.5, 54 * 0.5));
    }];
    [_commentTopRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentBtn.mas_right);
        make.bottom.equalTo(_commentBtn.mas_top).offset(5);
        make.width.equalTo(@(45));
        make.height.equalTo(@(15));
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}



- (UILabel*)scoreLabel {
    
    if (!_scoreLabel) {
        _scoreLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_FF7820
                                    titleFont:nil
                                titleAligment:NSTextAlignmentLeft];
        _scoreLabel.font = HK_FONT_SYSTEM_WEIGHT(22, UIFontWeightSemibold);
    }
    return _scoreLabel;
}


- (UILabel*)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:nil
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _bottomLine.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bottomLine;
}



- (HKCustomMarginLabel*)levelLabel {
    
    if (!_levelLabel) {
        _levelLabel = [HKCustomMarginLabel new];
        _levelLabel.textColor = COLOR_7B8196_27323F;
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = HK_FONT_SYSTEM(13);
        _levelLabel.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE] ;
        _levelLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _levelLabel.clipsToBounds = YES;
        _levelLabel.layer.cornerRadius = 22/2;
    }
    return _levelLabel;
}



- (UIButton*)commentBtn {
    
    if (!_commentBtn) {

        _commentBtn = [UIButton buttonWithTitle:@"我要评论" titleColor:COLOR_ffffff
                                     titleFont:@"13" imageName:nil];
        [_commentBtn.titleLabel setFont:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightMedium)];
        [_commentBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_commentBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:imageTemp forState:UIControlStateHighlighted];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 25/2, 0, 25/2);
        _commentBtn.clipsToBounds = YES;
        _commentBtn.layer.cornerRadius = 54 * 0.5 * 0.5;
    }
    return _commentBtn;
}


- (void)commentBtnClick:(id)sender {
    [MobClick endEvent:UM_RECORD_DETAIL_PAGE_EVALUATETAB_SCOREEVALUATE];
    self.commentScoreViewBlock ?self.commentScoreViewBlock(sender) : nil;
}

-(void)setScore:(NSNumber *)score{
    _scoreLabel.attributedText = [self attributeCommentScore:[NSString stringWithFormat:@"%@",score]];
}

-(void)setDiff:(NSString *)diff{
    _levelLabel.text = diff;
}

//- (void)setModel:(NewCommentHeadModel *)model {
//    self.hidden = NO;
//    _model = model;
//    _scoreLabel.attributedText = [self attributeCommentScore:model.score];
//    _levelLabel.text = [NSString stringWithFormat:@"%@",model.diff];
//}


- (NSMutableAttributedString *)attributeCommentScore:(NSString*)score {
    if (isEmpty(score)) {
        return nil;
    }
    NSString *tempScore = [NSString stringWithFormat:@"%.2f",[score floatValue]];
    NSString *contentString = [NSString stringWithFormat:@"%@分", tempScore];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_WEIGHT(22, UIFontWeightSemibold) range:NSMakeRange(0, tempScore.length-1)];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightSemibold) range:NSMakeRange(tempScore.length, 1)];
    return attrString;
}

- (UIButton*)commentTopRightBtn {
    
    if (!_commentTopRightBtn) {
        _commentTopRightBtn = [UIButton buttonWithTitle:@"得虎课币" titleColor:COLOR_ffffff
                                      titleFont:@"8" imageName:nil];
        [_commentTopRightBtn.titleLabel setFont:HK_FONT_SYSTEM(8)];
        [_commentTopRightBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        
        UIColor *color = [UIColor colorWithHexString:@"#FF755A"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FF4265"];
        //UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(45, 15) gradientColors:@[(id)color,(id)color1] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_commentTopRightBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        [_commentTopRightBtn setBackgroundImage:imageTemp forState:UIControlStateHighlighted];
        [_commentTopRightBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentTopRightBtn.clipsToBounds = YES;
        _commentTopRightBtn.layer.cornerRadius = 7.5;
        _commentTopRightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _commentTopRightBtn.layer.borderWidth = 1.0;
    }
    return _commentTopRightBtn;
}

//- (void)commentBtnClick:(id)sender {
//    self.commentEmptyViewBlock ?self.commentEmptyViewBlock(sender) : nil;
//}

@end
