//
//  HKBookEvaluationView.m
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookEvaluationView.h"
#import "HKCustomMarginLabel.h"
#import "UIButton+Style.h"
#import "UIView+SNFoundation.h"
#import "HKBookModel.h"

@interface HKBookEvaluationView()

@property (nonatomic,strong) HKCustomMarginLabel *tipLB;
///评价
@property (nonatomic,strong) UIButton *evaluationBtn;
///收藏
@property (nonatomic,strong) UIButton *collectBtn;

@end



@implementation HKBookEvaluationView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self setShadowColor];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    
    [self addSubview:self.tipLB];
    [self addSubview:self.collectBtn];
    [self addSubview:self.evaluationBtn];

    UITapGestureRecognizer *commentBottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listeningEvaluationViewClick)];
    [self.tipLB addGestureRecognizer:commentBottomTap];
    
}



- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self setShadowColor];
    }
}



- (void)setShadowColor {
    if (@available(iOS 13.0, *)) {
        UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:[COLOR_E1E7EB colorWithAlphaComponent:0.5] dark:[UIColor clearColor]];
        ;
        [self addShadowWithColor:shadowColor alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    }else{
        [self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5]  alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    }
}



- (void)listeningEvaluationViewClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookEvaluationView:commentLB:)]) {
        [self.delegate  bookEvaluationView:self commentLB:self.tipLB];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.centerY.equalTo(self);
        if (HKBookEvaluationViewType_listening ==  self.evaluationViewType) {
            make.right.equalTo(self.evaluationBtn.mas_left).offset(-18);
        }else{
            make.right.equalTo(self).offset(-PADDING_15);
        }
    }];
    
    self.collectBtn.hidden = (HKBookEvaluationViewType_listening ==  self.evaluationViewType) ?NO : YES;
    self.evaluationBtn.hidden = (HKBookEvaluationViewType_listening ==  self.evaluationViewType) ?NO : YES;
    
    self.collectBtn.right = self.width - 7;
    self.collectBtn.centerY = self.height/2;
    
    self.evaluationBtn.centerY = self.collectBtn.centerY;
    self.evaluationBtn.right = self.collectBtn.left - 5;
}



- (HKCustomMarginLabel*)tipLB {
    if (!_tipLB) {
        _tipLB  = [[HKCustomMarginLabel alloc] init];
        _tipLB.textInsets = UIEdgeInsetsMake(7, 15, 7, 0);
        _tipLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_878CA2 dark:COLOR_A8ABBE];
        _tipLB.font = HK_FONT_SYSTEM(13);
        _tipLB.textAlignment = NSTextAlignmentLeft;
        _tipLB.backgroundColor = COLOR_F8F9FA_333D48;
        _tipLB.clipsToBounds = YES;
        _tipLB.layer.cornerRadius = 14;
        _tipLB.text = @"精选书评可获得纸质书籍哦~";
        _tipLB.userInteractionEnabled = YES;
    }
    return _tipLB;
}



- (UIButton*)evaluationBtn {
    if (!_evaluationBtn) {
        _evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_chat_v2_3" darkImageName:@"ic_chat_v2_3_dark"];
        [_evaluationBtn setImage:image forState:UIControlStateNormal];
        [_evaluationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_evaluationBtn setTitle:@"评价" forState:UIControlStateNormal];
        
        [_evaluationBtn.titleLabel setFont:HK_FONT_SYSTEM(9)];
        [_evaluationBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_evaluationBtn setHKEnlargeEdge:15];
        [_evaluationBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:4];
        _evaluationBtn.tag = 30;
        [_evaluationBtn sizeToFit];
    }
    return _evaluationBtn;
}


- (UIButton*)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_like_v2_3" darkImageName:@"ic_like_v2_3_dark"];
        [_collectBtn setImage:normalImage forState:UIControlStateNormal];
        [_collectBtn setImage:imageName(@"ic_like_pre_v2_3") forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        
        [_collectBtn.titleLabel setFont:HK_FONT_SYSTEM(9)];
        [_collectBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_collectBtn sizeToFit];
        [_collectBtn setHKEnlargeEdge:15];
        [_collectBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:4];
        _collectBtn.tag = 40;
    }
    return _collectBtn;
}


- (void)btnClick:(UIButton*)btn {
    
    if (30 == btn.tag) {
        //评价
        if (self.delegate && [self.delegate respondsToSelector:@selector(bookEvaluationView:commentBtn:)]) {
            [self.delegate bookEvaluationView:self commentBtn:btn];
        }
    }else {
        //收藏
        if (self.delegate && [self.delegate respondsToSelector:@selector(bookEvaluationView:collectBtn:)]) {
            [self.delegate bookEvaluationView:self collectBtn:btn];
        }
    }
}



- (void)setBookModel:(HKBookModel *)bookModel {
    _bookModel = bookModel;
    
    NSString *comment = (bookModel.comment_number>1000) ?@"999+" :[NSString stringWithFormat:@"%ld",(long)bookModel.comment_number];
    comment = (bookModel.comment_number>0) ?comment :@"评价";
    
    NSString *collect = (bookModel.collect_number>1000) ?@"999+" :[NSString stringWithFormat:@"%ld",(long)bookModel.collect_number];
    collect = (bookModel.collect_number>0) ?collect :@"收藏";
    
    [self.evaluationBtn setTitle:comment forState:UIControlStateNormal];
    [self.evaluationBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:4];
    
    [self.collectBtn setTitle:collect forState:UIControlStateNormal];
    self.collectBtn.selected = bookModel.is_collected;
    [self.collectBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:4];
}



@end
