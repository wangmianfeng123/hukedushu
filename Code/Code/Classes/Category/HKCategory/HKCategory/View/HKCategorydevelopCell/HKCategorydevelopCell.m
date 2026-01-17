//
//  HKCategorydevelopCell 	 Cell.m
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategorydevelopCell.h"
#import "HKCategoryTreeModel.h"



//@interface HKCategorydevelopCell()
//
//@property (nonatomic,strong) UILabel *titleLabel;
//
//@end
//
//@implementation HKCategorydevelopCell
//
//
//- (instancetype)initWithFrame:(CGRect)frame {
//
//    if (self = [super initWithFrame:frame]) {
//
//        [self createUI];
//    }
//    return self;
//}
//
//
//
//- (void)createUI {
//    self.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:self.titleLabel];
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.contentView);
//        make.top.equalTo(self.contentView).offset(12);
//        make.bottom.equalTo(self.contentView).offset(-PADDING_5);
//    }];
//}
//
//
//
//- (UILabel*)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
//                                      titleFont:@"14" titleAligment:NSTextAlignmentLeft];
//    }
//    return _titleLabel;
//}
//
//
//
//- (void)setChilderenModel:(HKcategoryChilderenModel *)childerenModel {
//
//    _childerenModel = childerenModel;
//    _titleLabel.text = childerenModel.video_title;
//}
//
//
//
//@end




#import "HKCategorydevelopCell.h"
#import "HKCategoryTreeModel.h"
#import "HKCustomMarginLabel.h"


@interface HKCategorydevelopCell()

/** 软件标题 */
@property(nonatomic,strong)HKCustomMarginLabel *titleLabel;

@property(nonatomic,strong)UIView *bgView;

@end



@implementation HKCategorydevelopCell

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
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLabel];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.left.equalTo(self.contentView);
    }];
        
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}




- (HKCustomMarginLabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[HKCustomMarginLabel alloc] init];
        _titleLabel.textInsets = UIEdgeInsetsMake(0, 7, 0, 7);
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_27323F];
        _titleLabel.textColor = textColor;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightSemibold);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];
        _bgView.backgroundColor = bgColor;
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = PADDING_5;
    }
    return _bgView;
}




- (void)setChilderenModel:(HKcategoryChilderenModel *)childerenModel {
    
    _childerenModel = childerenModel;
    if (childerenModel.is_more) {
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_go_v2_18" darkImageName:@"ic_go_v2_18_dark"];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_27323F];
        NSMutableAttributedString *attributedStr = [NSMutableAttributedString mutableAttributedString:@"更多" font:HK_FONT_SYSTEM(12) titleColor:textColor image:image bounds:CGRectMake(0,1, 5, 7)];
        _titleLabel.attributedText = attributedStr;
    }else{
        _titleLabel.text = childerenModel.name;
    }
}


- (void)showBottomLine:(NSInteger)row {
    
}


@end


