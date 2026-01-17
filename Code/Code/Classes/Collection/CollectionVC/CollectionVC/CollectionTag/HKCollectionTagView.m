//
//  HKCollectionTagView.m
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCollectionTagView.h"

@interface HKCollectionTagView()

@property(nonatomic,strong)UIButton     *allCourseBtn;

@end

@implementation HKCollectionTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {
    self.backgroundColor = COLOR_F6F6F6;
    [self addSubview:self.allCourseBtn];
}

- (void)makeConstraints {
    WeakSelf;
    [_allCourseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(PADDING_20);
        make.left.equalTo(weakSelf).offset(PADDING_15);
        make.height.mas_equalTo(PADDING_30);
        make.width.mas_equalTo(105);
    }];
    [self setBtnTitleAndImageEdges];
}

#pragma mark - 标题 图片位置偏移
- (void)setBtnTitleAndImageEdges {
    [_allCourseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_allCourseBtn.imageView.image.size.width, 0, _allCourseBtn.imageView.image.size.width)];
    [_allCourseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _allCourseBtn.titleLabel.bounds.size.width+5, 0, -_allCourseBtn.titleLabel.bounds.size.width-5)];
}


- (UIButton*)allCourseBtn {
    if (!_allCourseBtn) {
        _allCourseBtn = [UIButton buttonWithTitle:@"VIP教程"
                                       titleColor:COLOR_666666
                                        titleFont:IS_IPHONE6PLUS ?@"16":@"15"
                                        imageName:@"arrow_right_gray"];
        [_allCourseBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _allCourseBtn.clipsToBounds = YES;
        _allCourseBtn.layer.cornerRadius = PADDING_15;
        _allCourseBtn.layer.borderWidth = 0.6;
        _allCourseBtn.layer.borderColor = COLOR_999999.CGColor;
        
    }
    return _allCourseBtn;
}


- (void)btnClickAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(collectionTagAction:)]) {
        [self.delegate collectionTagAction:sender];
    }
}

- (void)setTagBtnByTitle:(NSString*)title {
    
    [_allCourseBtn setTitle:title forState:UIControlStateNormal];
    [self setBtnTitleAndImageEdges];
}



@end








