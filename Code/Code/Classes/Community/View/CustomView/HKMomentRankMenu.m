//
//  HKMomentRankMenu.m
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentRankMenu.h"
#import "UIView+HKLayer.h"
#import "HKMonmentTypeModel.h"
#import "UIView+HKLayer.h"

@interface HKMomentRankMenu ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filtrateBtnH;
@property (nonatomic , strong) NSMutableArray * dataArray;
@end

@implementation HKMomentRankMenu

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _selectedTitleColor = [UIColor colorWithHexString:@"#FF7820"];
    _selectedBgColor = [UIColor colorWithHexString:@"#FFF0E6"];
    [self.filtrateBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    
}


- (IBAction)filtrateBtnClick {
    if ([self.delegate respondsToSelector:@selector(momentRankMenuDidfiltrateBtn)]) {
        [self.delegate momentRankMenuDidfiltrateBtn];
    }
}

-(void)setIsRequestion:(BOOL)isRequestion{
    _isRequestion = isRequestion;
    if (self.isRequestion) {
        self.filtrateBtnH.constant = 30;
        [self.filtrateBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [self.filtrateBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
        [self.filtrateBtn addCornerRadius:15];
        [self.filtrateBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
        [self.filtrateBtn setTitle:@"我要提问" forState:UIControlStateNormal];
        [self.filtrateBtn setImage:[UIImage imageNamed:@"ic_ask_community_2_33"] forState:UIControlStateNormal];
        [self.filtrateBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
    }else{
        [self.filtrateBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        [self.filtrateBtn setTitle:@"按分类筛选" forState:UIControlStateNormal];
        [self.filtrateBtn setImage:[UIImage imageNamed:@"funnel_gray"] forState:UIControlStateNormal];
        [self.filtrateBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    }
}

-(void)setNeedFiltrateBtn:(BOOL)needFiltrateBtn{
    _needFiltrateBtn = needFiltrateBtn;
    if (self.isRequestion) {
        self.filtrateBtn.hidden = NO;
    }else{
        self.filtrateBtn.hidden = needFiltrateBtn ? NO : YES;
    }
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
}

-(void)setSelectedBgColor:(UIColor *)selectedBgColor{
    _selectedBgColor = selectedBgColor;
}


-(void)setTypeArray:(NSArray *)typeArray{
    _typeArray = typeArray;
    CGFloat w = 70;
    CGFloat h = 25;
    [self.dataArray removeAllObjects];
    for (int i = 0 ; i < typeArray.count; i++) {
        HKMonmentTagModel * model = typeArray[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(70, 25);
        btn.frame = CGRectMake(15+(w + 10) * i, 12.5, w, h);
        btn.tag = i;
        [btn addCornerRadius:12.5];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
            [btn setBackgroundColor:self.selectedBgColor];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#7B8196"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#F8F9FA"]];
        }
        [self addSubview:btn];
        [self.dataArray addObject:btn];
    }
}

- (void)rankBtnClick:(UIButton *)sender {
    for (UIButton * btn in self.dataArray) {
        if (sender.tag == btn.tag) {
            [btn setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
            [btn setBackgroundColor:self.selectedBgColor];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#7B8196"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#F8F9FA"]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(momentRankMenuDidRankBtn:)]) {
        [self.delegate momentRankMenuDidRankBtn:sender.tag];
    }
}

@end
