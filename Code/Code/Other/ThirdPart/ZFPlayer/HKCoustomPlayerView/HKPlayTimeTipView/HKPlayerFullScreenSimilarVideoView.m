//
//  HKPlayerFullScreenSimilarVideoView.m
//  Code
//
//  Created by Ivan li on 2018/4/24.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerFullScreenSimilarVideoView.h"
#import "HKPlayerCollectionView.h"


@interface HKPlayerFullScreenSimilarVideoView() <HKPlayerCollectionViewDelagate>

@property (nonatomic,strong) UILabel *tagLabel;

@property (nonatomic,strong) UIButton *resetBtn;

@property (nonatomic,strong) HKPlayerCollectionView *playerCollectionView;

@end




@implementation HKPlayerFullScreenSimilarVideoView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setCollectView];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setCollectView];
    }
    return self;
}


- (void)setCollectView {
    
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    [self addSubview:self.tagLabel];
    [self addSubview:self.resetBtn];
    [self addSubview:self.playerCollectionView];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(120*Ratio);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.playerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.height.mas_equalTo(245/2);
        make.top.equalTo(_tagLabel.mas_bottom).offset(16);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tagLabel.mas_top);
        make.right.equalTo(self.mas_right).offset(-185/2*Ratio);
        make.size.mas_equalTo(CGSizeMake(110/2, 60/2));
    }];
}



- (HKPlayerCollectionView*)playerCollectionView {
    
    if (!_playerCollectionView) {
        _playerCollectionView = [[HKPlayerCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self layout]];
        _playerCollectionView.playerCollectionViewDelagate = self;
    }
    return _playerCollectionView;
}



- (UICollectionViewFlowLayout*)layout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 25/2;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(330/2, 245/2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}



- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithTitle:CGRectZero title:@"相似推荐" titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}


- (UIButton*)resetBtn {
    
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_resetBtn setBackgroundColor:[UIColor clearColor]];
        [_resetBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        [_resetBtn setImage:imageName(@"hkplayer_reset") forState:UIControlStateNormal];
        [_resetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_resetBtn addTarget:self action:@selector(repeatVidoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}




- (void)hkplayerCollectionCellClick:(NSIndexPath*)index sender:(id)sender collectionView:(UICollectionView *)collectionView {
    
    if ([self.delegate respondsToSelector:@selector(hkplayerFullScreenCellClick:sender:collectionView:)]) {
        [self.delegate hkplayerFullScreenCellClick:index sender:sender collectionView:collectionView];
        [self removeView];
    }
}


- (void)repeatVidoClick:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(hkplayerFullScreenRepeatBtnClick:)]) {
        [self.delegate hkplayerFullScreenRepeatBtnClick:nil];
        [self removeView];
    }
}

- (void)removeView {
//    //移除手势
//    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
//        [self removeGestureRecognizer:ges];
//    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    self.playerCollectionView.dataArray = dataArray;
}


- (void)setModel {
    
    VideoModel *model = [VideoModel new];
    model.video_id = @"12";
    model.title = @"ps教程教材及看";
    model.avatar = @"https://pic.huke88.com/video/cover/2018-03-21/5893BB88-310D-A125-57CF-E6091DED05CB.jpg!/fw/432/format/webp";
    _playerCollectionView.dataArray = @[model,model,model,model,model,model];
}



@end
