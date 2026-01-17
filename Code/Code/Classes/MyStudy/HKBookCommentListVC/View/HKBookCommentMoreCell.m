//
//  HKBookCommentMoreCell.m
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentMoreCell.h"
#import "HKBookCommentModel.h"

@interface HKBookCommentMoreCell()

@property (nonatomic, strong)UIImageView *loadArrowIV;

@property (nonatomic, strong)UIView *bgView;
/// 查看更多
@property (nonatomic, strong)UILabel *loadMoreLB;

@end



@implementation HKBookCommentMoreCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.loadMoreLB];
        [self.contentView addSubview:self.loadArrowIV];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(65);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.loadMoreLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(75);
    }];
    
    [self.loadArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loadMoreLB);
        make.left.equalTo(self.loadMoreLB.mas_right).offset(0);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bgView;
}


- (UIImageView *)loadArrowIV {
    if (!_loadArrowIV) {
        _loadArrowIV = [UIImageView new];
        _loadArrowIV.image = imageName(@"ic_go_v2_16");
        _loadArrowIV.userInteractionEnabled = YES;
    }
    return _loadArrowIV;
}


- (UILabel*)loadMoreLB {
    if(!_loadMoreLB){
        _loadMoreLB = [UILabel labelWithTitle:CGRectZero title:@"查看更多评论" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:0];
        _loadMoreLB.userInteractionEnabled = YES;
        
    }
    return _loadMoreLB;
}



- (void)setModel:(HKBookCommentModel *)model {
    _model = model;
    self.loadMoreLB.text = model.expanded ?@"收起" :@"查看更多评论";
    self.loadArrowIV.hidden = model.expanded;
}



- (void)bindViewModel:(HKBookBottomModel *)viewModel {
    self.model = viewModel.model;
}

@end
