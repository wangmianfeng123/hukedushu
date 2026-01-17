//
//  LevelView.m
//  Code
//
//  Created by Ivan li on 2017/9/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "LevelView.h"

#define COLOR_NO_SELECT [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_7B8196]

#define COLOR_SELECTED [UIColor colorWithHexString:@"#FFF0E6"]

@implementation LevelView



- (id)init {
    
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_333D48;
    self.selectIndex = 0;
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.firstBtn];
    [self addSubview:self.secondBtn];
    
    [self addSubview:self.thirdBtn];
    [self addSubview:self.fourthBtn];
    [self addSubview:self.fifthBtn];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(PADDING_10);
    }];
   
    CGFloat space = (SCREEN_WIDTH - (IS_IPHONE5S ?290 :340))/2;
    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PADDING_10 leadSpacing:space tailSpacing:space];
    
    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn]  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_15);
        make.height.mas_equalTo(PADDING_30);
        make.width.mas_equalTo(IS_IPHONE5S ?50 :PADDING_30*2);
    }];
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"你觉得课程"
                                    titleColor:COLOR_7B8196
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentCenter];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}





- (UIButton*)firstBtn {
    
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithTitle:@"太简单" titleColor:COLOR_7B8196_27323F titleFont:(IS_IPHONE5S ?@"12" :@"13") imageName:nil];
        [_firstBtn addTarget:self action:@selector(buttonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
        _firstBtn.clipsToBounds = YES;
        //_firstBtn.layer.borderWidth = 0.5;
        _firstBtn.layer.cornerRadius = PADDING_15;
        //_firstBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        [_firstBtn setBackgroundColor:COLOR_NO_SELECT];
        _firstBtn.tag = 0;
    }
    return _firstBtn;
}


- (UIButton*)secondBtn {
    
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithTitle:@"简单" titleColor:COLOR_7B8196_27323F titleFont:(IS_IPHONE5S ?@"12" :@"13") imageName:nil];
        [_secondBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        _secondBtn.clipsToBounds = YES;
        //_secondBtn.layer.borderWidth = 0.5;
        _secondBtn.layer.cornerRadius = PADDING_15;
        //_secondBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _secondBtn.tag = 1;
        [_secondBtn setBackgroundColor:COLOR_NO_SELECT];

    }
    return _secondBtn;
}


- (UIButton*)thirdBtn {
    
    if (!_thirdBtn) {
        _thirdBtn = [UIButton buttonWithTitle:@"适中" titleColor:COLOR_7B8196_27323F titleFont:(IS_IPHONE5S ?@"12" :@"13") imageName:nil];
        [_thirdBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        _thirdBtn.clipsToBounds = YES;
        //_thirdBtn.layer.borderWidth = 0.5;
        _thirdBtn.layer.cornerRadius = PADDING_15;
        //_thirdBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _thirdBtn.tag = 2;
        [_thirdBtn sizeToFit];
        [_thirdBtn setBackgroundColor:COLOR_NO_SELECT];
    }
    return _thirdBtn;
}

- (UIButton*)fourthBtn {
    
    if (!_fourthBtn) {
        _fourthBtn = [UIButton buttonWithTitle:@"有点难" titleColor:COLOR_7B8196_27323F titleFont:(IS_IPHONE5S ?@"12" :@"13") imageName:nil];
        [_fourthBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        _fourthBtn.clipsToBounds = YES;
        //_fourthBtn.layer.borderWidth =0.5;
        _fourthBtn.layer.cornerRadius = PADDING_15;
        //_fourthBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _fourthBtn.tag = 3;
        [_fourthBtn setBackgroundColor:COLOR_NO_SELECT];
    }
    return _fourthBtn;
}

- (UIButton*)fifthBtn {
    
    if (!_fifthBtn) {
        _fifthBtn = [UIButton buttonWithTitle:@"太难了" titleColor:COLOR_7B8196_27323F titleFont:(IS_IPHONE5S ?@"12" :@"13") imageName:nil];
        
        [_fifthBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        _fifthBtn.clipsToBounds = YES;
        //_fifthBtn.layer.borderWidth = 0.5;
        _fifthBtn.layer.cornerRadius = PADDING_15;
        //_fifthBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        _fifthBtn.tag = 4;
        [_fifthBtn setBackgroundColor:COLOR_NO_SELECT];
    }
    return _fifthBtn;
}



- (void)buttonPressed:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];
    
    if (index == 0) {
        _levelType = ((_levelType == LevelTypeVeryEasySelected) ? LevelTypeVeryEasy  :LevelTypeVeryEasySelected );
        [self setButtonsBackground];
    }
    if (index == 1) {
        _levelType = ((_levelType == LevelTypeEasySelected) ?LevelTypeEasy  : LevelTypeEasySelected);
        [self setButtonsBackground];
    }
    if (index == 2) {
        _levelType = ((_levelType == LevelTypeMiddleSelected) ? LevelTypeMiddle : LevelTypeMiddleSelected);
        [self setButtonsBackground];
    }
    if (index == 3) {
        _levelType = ((_levelType == LevelTypeHardSelected) ? LevelTypeHard : LevelTypeHardSelected);
        [self setButtonsBackground];
    }
    
    if (index == 4) {
        _levelType = ((_levelType == LevelTypeVeryHardSlected) ? LevelTypeVeryHard : LevelTypeVeryHardSlected);
        [self setButtonsBackground];
    }
}




- (void)setButtonsBackground
{

    NSInteger selectIndex = _levelType / 2;
    self.selectIndex = selectIndex + 1;
    //NSDictionary *dict =  @{@"selectIndex": [NSString stringWithFormat:@"%ld",(long)self.selectIndex]};
    //[MyNotification postNotificationName:KCommentLevelNotification object:nil userInfo:dict];
        if (selectIndex == 0) {
            
            [self.firstBtn setBackgroundColor:COLOR_SELECTED];
            [self.secondBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.thirdBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fourthBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fifthBtn setBackgroundColor:COLOR_NO_SELECT];
            
            [self.firstBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fourthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fifthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];

        }else if (selectIndex == 1){
            
            [self.secondBtn setBackgroundColor:COLOR_SELECTED];
            [self.firstBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.thirdBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fourthBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fifthBtn setBackgroundColor:COLOR_NO_SELECT];
            
            [self.firstBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fourthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fifthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            
        }else if (selectIndex == 2) {
            
            [self.thirdBtn setBackgroundColor:COLOR_SELECTED];
            [self.firstBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.secondBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fourthBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fifthBtn setBackgroundColor:COLOR_NO_SELECT];
            
            [self.firstBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
            [self.fourthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fifthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            
        }
        else if (selectIndex == 3){
            
            [self.fourthBtn setBackgroundColor:COLOR_SELECTED];
            [self.firstBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.secondBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.thirdBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fifthBtn setBackgroundColor:COLOR_NO_SELECT];
            
            [self.firstBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fourthBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
            [self.fifthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
        }
        else if (selectIndex == 4) {
            
            [self.fifthBtn setBackgroundColor:COLOR_SELECTED];
            [self.firstBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.secondBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.thirdBtn setBackgroundColor:COLOR_NO_SELECT];
            [self.fourthBtn setBackgroundColor:COLOR_NO_SELECT];
            
            [self.firstBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fourthBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
            [self.fifthBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
        }
}





- (void)setCommentType:(HKCommentType)commentType {
    _commentType = commentType;
    
    switch (commentType) {
        case HKCommentType_VideoComment:
        {
            self.titleLabel.text = @"你觉得课程";
        }
            break;
        case HKCommentType_BookComment:
        {
            self.titleLabel.text = @"你觉得这本书怎么样？";
        }
            break;
        default:
            break;
    }
}





@end
