

//
//  StarView.m
//  Code
//
//  Created by Ivan li on 2017/9/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "StarView.h"
  


#define  KCommentPlaceholder  @"课程怎么样？说说你的学习心得吧（至少5个字）"

#define imageName_normal  @"ic_goodreputation_normal_v2_9"

#define imageName_selected @"ic_goodreputation_pressed_v2_9"

@implementation StarView



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
        make.top.equalTo(self).offset(PADDING_20);
    }];
    
    /** @param axisType 布局方向 * @param fixedSpacing 两个item之间的间距(最左面的item和左边, 最右边item和右边都不是这个)
     * @param leadSpacing 第一个item到父视图边距 * @param tailSpacing 最后一个item到父视图边距*/
    CGFloat space = (SCREEN_WIDTH - 200 -48)/2;
    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:space tailSpacing:space];
    
    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn]  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"点击星星评分"
                                    titleColor:COLOR_7B8196
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM(13);
    }
    return _titleLabel;
}



- (UIButton*)firstBtn {
    
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.tag = 0;
        [_firstBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [_firstBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
        [_firstBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstBtn;
}


- (UIButton*)secondBtn {
    
    if (!_secondBtn) {
        _secondBtn = [UIButton new];
        [_secondBtn addTarget:self action:@selector(buttonPressed:)forControlEvents:UIControlEventTouchUpInside];
        _secondBtn.tag = 1;
        [_secondBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [_secondBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
    }
    return _secondBtn;
}


- (UIButton*)thirdBtn {
    
    if (!_thirdBtn) {
        _thirdBtn = [UIButton new];
        [_thirdBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];

        _thirdBtn.tag = 2;
        [_thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [_thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
        
    }
    return _thirdBtn;
}

- (UIButton*)fourthBtn {
    
    if (!_fourthBtn) {
        _fourthBtn = [UIButton new];
        [_fourthBtn addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];

        _fourthBtn.tag = 3;
        [_fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [_fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
        
    }
    return _fourthBtn;
}

- (UIButton*)fifthBtn {
    
    if (!_fifthBtn) {
        _fifthBtn = [UIButton new];
        
        [_fifthBtn addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        _fifthBtn.tag = 4;
        [_fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [_fifthBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
    }
    return _fifthBtn;
}




- (UIImage*)submitNomalBgImage {
    if (!_submitNomalBgImage) {
        UIColor *color = RGB(210, 210, 210, 1);
        _submitNomalBgImage = [UIImage createImageWithColor:color];
    }
    return _submitNomalBgImage;
}




- (void)submitAction:(id)sender {
    
    if ([self.deletate respondsToSelector:@selector(submitComment:comment:)]) {
        [self.deletate submitComment:self.selectIndex comment:nil];
    }
}



- (void)buttonPressed:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];
    
    if (index == 0) {
        _starType = ((_starType == StarTypeVeryEasySelected) ? StarTypeVeryEasy  :StarTypeVeryEasySelected );
        [self setButtonsBackground];
    }
    if (index == 1) {
        _starType = ((_starType == StarTypeEasySelected) ?StarTypeEasy  : StarTypeEasySelected);
        [self setButtonsBackground];
    }
    if (index == 2) {
        _starType = ((_starType == StarTypeMiddleSelected) ? StarTypeMiddle : StarTypeMiddleSelected);
        [self setButtonsBackground];
    }
    if (index == 3) {
        _starType = ((_starType == StarTypeHardSelected) ? StarTypeHard : StarTypeHardSelected);
        [self setButtonsBackground];
    }
    if (index == 4) {
        _starType = ((_starType == StarTypeVeryHardSlected) ? StarTypeVeryHard : StarTypeVeryHardSlected);
        [self setButtonsBackground];
    }
}




- (void)setButtonsBackground {
    
    NSInteger selectIndex = _starType / 2;
    self.selectIndex = selectIndex + 1;
    
    if (selectIndex == 0) {
        
        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.secondBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        
    }else if (selectIndex == 1) {
        
        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        
    }else if (selectIndex == 2) {
        
        
        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        
    }else if (selectIndex == 3){
        
        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
        
    }else if (selectIndex == 4) {
        
        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
        [self.fifthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
    }
    
    NSString *text = nil;
    switch (selectIndex) {
        case 0:
            text = @"糟糕";
            //(HKCommentType_VideoComment == self.commentType )?@"非常差":@"糟糕";
            break;
        case 1:
            text = @"较差";
            //(HKCommentType_VideoComment == self.commentType )?@"差" :@"较差";
            break;
        case 2:
            text = @"还行";
            //(HKCommentType_VideoComment == self.commentType )?@"一般":@"还行";
            break;
        case 3:
            text = @"推荐";
            //(HKCommentType_VideoComment == self.commentType )?@"好" :@"推荐";
            break;
        case 4:
            text = @"太棒啦";
            //(HKCommentType_VideoComment == self.commentType )?@"非常好" :@"太棒啦";
            break;
            
        default:
            break;
    }
    self.titleLabel.text = text;
}




- (void)setCommentType:(HKCommentType)commentType {
    _commentType = commentType;
    
    switch (commentType) {
        case HKCommentType_VideoComment:
        {
            self.titleLabel.text = @"点击星星评分";
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








