//
//  HKSearchSortView.m
//  Code
//
//  Created by eon Z on 2022/1/12.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKSearchSortView.h"

#import "HKDropMenuModel.h"

@interface HKSearchSortView ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *sortContentView;

@property (weak, nonatomic) IBOutlet UIButton *filtrateBtn;
// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation HKSearchSortView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self createUI];
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createUI{
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.sortContentView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.filtrateBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [self.sortContentView addSubview:self.scrollView];
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, self.height)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //_scrollView.backgroundColor = [UIColor brownColor];
    }
    return _scrollView;
}

-(void)setTitles:(NSMutableArray *)titles{
    _titles = titles;
    HKDropMenuModel * sortMenuModel = titles[0];
    self.dataArray = sortMenuModel.dataArray;
    [self resetUI];
}

- (IBAction)filtrateBtnClick {
    if (self.titles.count > 1) {
        if ([self.delegate respondsToSelector:@selector(searchSortViewDidfiltrateBtn:)]) {
            [self.delegate searchSortViewDidfiltrateBtn:self.titles[1]];
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    for (int i = 0; i < self.dataArray.count; i ++ ) {
        HKDropMenuModel * dropMenuModel = self.dataArray[i];
        dropMenuModel.titleSeleted = i == btn.tag ? YES : NO;
        if (i == btn.tag) {
            if ([self.delegate respondsToSelector:@selector(searchSortViewDidSortBtn:)]) {
                [self.delegate searchSortViewDidSortBtn:dropMenuModel];
            }
        }
    }
    [self resetUI];
}

- (void)resetUI{
    for (UIButton * btn in self.scrollView.subviews) {
        [btn removeAllSubviews];
    }
    
    CGFloat contentW = 10;
    for (int i = 0; i < self.dataArray.count; i++) {
        HKDropMenuModel * dropMenuModel = self.dataArray[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:dropMenuModel.titleSeleted ? [UIColor colorWithHexString:@"#FF7820"]:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        //[btn setBackgroundColor:[UIColor purpleColor]];
        [btn setTitle:dropMenuModel.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake(contentW, 0, dropMenuModel.menuWidth, 44);
        btn.tag = i;
        contentW = contentW + dropMenuModel.menuWidth;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.scrollView setContentSize:CGSizeMake(contentW, self.height)];
}

@end
