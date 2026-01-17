//
//  MyDownloadBottomView.h
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HKDownloadBottomViewType) {
    HKDownloadBottomViewType_loading = 1, // 下载页
    HKDownloadBottomViewType_loaded,// 已经下载完成页
};


#pragma mark - 全选回调
typedef void(^AllSelectedBlock)(UIButton *btn);

#pragma mark - 删除回调
typedef void(^ConfirmBlock)();

@interface HKDownloadBottomView : UIView


@property(nonatomic,copy)AllSelectedBlock  allSelectBlock;  //我的下载二级页面底部删除操作的全选按钮

@property(nonatomic,copy)ConfirmBlock  confirmBlock;

@property(nonatomic,strong)UIButton  *checkBoxBtn;

@property(nonatomic,strong)UIButton  *confirmBtn;

@property(nonatomic,strong)UILabel  *lineLabel;
/// 页面类型 （目录下载页， 已下载完成页）
@property(nonatomic,assign)HKDownloadBottomViewType viewType;

/**
 目录页 初始化

 @param frame
 @param viewType 页面类型 （目录下载页， 已下载完成页）
 @return
 */
- (instancetype) initWithFrame:(CGRect)frame  viewType:(HKDownloadBottomViewType)viewType;


// 确认按钮
- (UIButton*)checkBoxBtn;

// 确认按钮标题
- (void)setupconfirmTitle:(NSString *)title;
//- (void)setPurchaseCount:(NSString*)count;

- (void)setupconfirmTextColor:(UIColor *)cololor  selectColor:(UIColor *)selectColor;

@end



//
////
////  MyDownloadBottomView.m
////  Code
////
////  Created by Ivan li on 2017/8/24.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//#import "HKDownloadBottomView.h"
//
//@implementation HKDownloadBottomView
//
//- (instancetype) initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//
//    if (self) {
//        [self createUI];
//    }
//    return self;
//}
//
//- (void)setupconfirmTitle:(NSString *)title {
//    [self.confirmBtn setTitle:title forState:UIControlStateNormal];
//}
//
//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    [self makeConstraints];
//}
//
//
//- (void)createUI {
//
//    self.backgroundColor = [UIColor whiteColor];//RGB(240, 240, 240, 1);
//    [self addSubview:self.checkBoxBtn];
//    [self addSubview:self.confirmBtn];
//    [self addSubview:self.lineLabel];
//}
//
//
//- (void)makeConstraints {
//
//    __weak typeof(self) weakSelf = self;
//    [_checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.equalTo(weakSelf);
//        make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
//    }];
//
//    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(1);
//        make.top.bottom.equalTo(weakSelf);
//        make.centerX.equalTo(weakSelf.mas_centerX);
//    }];
//
//    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(weakSelf);
//        make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
//    }];
//}
//
//
//- (UILabel*)lineLabel {
//
//    if (!_lineLabel) {
//
//        _lineLabel = [UILabel new];
//        _lineLabel.hidden = YES;
//        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
//    }
//    return _lineLabel;
//}
//
//
//- (UIButton*)checkBoxBtn {
//
//    if (!_checkBoxBtn) {
//        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_checkBoxBtn setTitle:@"全选" forState:UIControlStateNormal];
//        [_checkBoxBtn setTitle:@"取消全选" forState:UIControlStateSelected];
//        [_checkBoxBtn setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
//        [_checkBoxBtn setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateSelected];
//        [_checkBoxBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _checkBoxBtn;
//}
//
//
//
//-(void)checkboxClick:(UIButton *)btn {
//
//    btn.selected = !btn.selected;
//    self.confirmBtn.selected = btn.selected;
//
//    self.allSelectBlock ? self.allSelectBlock(btn) : nil;
//}
//
//
//
//- (UIButton*)confirmBtn {
//
//    if (!_confirmBtn) {
//
//        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
//        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#27323F"] forState:UIControlStateSelected];
//        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_confirmBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
//        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
//        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _confirmBtn;
//}
//
//
//- (void)setPurchaseCount:(NSString*)count {
//
//    [self.confirmBtn setTitle:count forState:UIControlStateNormal];
//}
//
//
//- (void)confirmAction:(UIButton *)btn {
//    self.confirmBlock ? self.confirmBlock() : nil;
//}
//
//
//@end
//
