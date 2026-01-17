//
//  HKBuyVipView.m
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBuyVipView.h"
#import "HKCategroyVipView.h"
#import "UIView+HKLayer.h"

@interface HKBuyVipView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *txtButton;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic , strong) NSMutableArray * subViewArray;
//@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgvBottomMargin;
@property (weak, nonatomic) IBOutlet UIView *bgV;
@end

@implementation HKBuyVipView

-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [NSMutableArray array];
    }
    return _subViewArray;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer * removeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTapClick)];
    [self.bgView addGestureRecognizer:removeTap];
    [self.buyBtn addCornerRadius:22.5];
    [self.txtButton setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.bgV.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bgvBottomMargin.constant = -330;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.buyBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
    });
}

- (IBAction)buyBtnClick {
    if (self.didSureBtnBlock) {
        
        for (HKCategroyVipView * view in self.subViewArray) {
            if (view.vipModel.is_selected) {
                self.didSureBtnBlock(view.vipModel);
            }
        }
    }
    [self removeTapClick];
}

- (void)removeTapClick{
    self.bgvBottomMargin.constant = -330;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        [self removeFromSuperview];
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.bgV setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:15];
}

- (void)showView{
    self.alpha = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bgvBottomMargin.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    });
}


-(void)setVip_list:(NSArray *)vip_list{
    _vip_list = vip_list;
    for (HKBuyVipModel * vipModel in self.vip_list) {
        vipModel.is_selected = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addCategroyVipView];
    });
}

- (void)addCategroyVipView{
    [self.subViewArray removeAllObjects];
    [self.contentView removeAllSubviews];
    
    if (self.vip_list.count > 1) {
        for (int i = 0; i < 2; i++) {
            HKBuyVipModel * vipModel = self.vip_list[i];
            if (i == 0) {
                vipModel.is_selected = YES;
                [self.buyBtn setTitle:vipModel.button_string forState:UIControlStateNormal];
            }
            HKCategroyVipView * view = [HKCategroyVipView viewFromXib];
            CGFloat h = 105;
            CGFloat margin = 20;
            CGFloat w = (kScreenWidth - margin * 3) * 0.5;
            CGFloat y = 0;
            CGFloat x = margin + (margin + w)*i;
            view.frame = CGRectMake(x, y, w, h);
            view.vipModel = vipModel;
            view.tag = i+ 1;
            view.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:view];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [view addGestureRecognizer:tap];
            [self.subViewArray addObject:view];
        }
    }else{
        HKBuyVipModel * vipModel = self.vip_list[0];
        vipModel.is_selected = YES;
        HKCategroyVipView * view = [HKCategroyVipView viewFromXib];
        CGFloat h = 105;
        CGFloat w = 185;
        CGFloat y = 0;
        CGFloat x = (SCREEN_WIDTH - w) * 0.5;
        view.frame = CGRectMake(x, y, w, h);
        view.backgroundColor = [UIColor clearColor];
        view.vipModel = vipModel;
        view.tag = 1;
        [self.contentView addSubview:view];
        [self.buyBtn setTitle:vipModel.button_string forState:UIControlStateNormal];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [view addGestureRecognizer:tap];
        [self.subViewArray addObject:view];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    for (HKCategroyVipView * view in self.subViewArray) {
        if (tap.view.tag == view.tag) {
            view.is_selected = YES;
            [self.buyBtn setTitle:view.vipModel.button_string forState:UIControlStateNormal];
        }else{
            view.is_selected = NO;
        }
    }
}

- (IBAction)agreeBtnClick {
    if (self.didAgreeBlock) {
        self.didAgreeBlock();
    }
}
@end
