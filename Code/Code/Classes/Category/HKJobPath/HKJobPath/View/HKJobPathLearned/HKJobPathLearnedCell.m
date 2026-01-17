//
//  HKJobPathLearnedCell.m
//  Code
//
//  Created by Ivan li on 2019/6/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathLearnedCell.h"
#import "HKJobPathLearnedCourseCell.h"
#import "HKJobPathModel.h"
#import "HKJobPathVipView.h"

@interface HKJobPathLearnedCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic , strong) UIView * lineView;
@property (nonatomic , strong) HKJobPathVipView * vipView;
@end

@implementation HKJobPathLearnedCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentCollectionView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"最近在学" titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightSemibold);
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _lineView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat top = self.showAllVip ? 13 + 70 : 13;
    
    if (self.showAllVip) {
        [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(PADDING_15);
            make.right.equalTo(self.contentView).offset(-PADDING_15);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(70);
        }];
    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(top);
    }];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(90);
    }];
    
    [_lineView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(5);
    }];
}

-(void)setShowAllVip:(BOOL)showAllVip{
    _showAllVip = showAllVip;
    [self.vipView removeFromSuperview];
    if (showAllVip) {
        self.vipView = [HKJobPathVipView viewFromXib];
        [self addSubview:self.vipView];
        WeakSelf
        self.vipView.vipBlcok = ^{
            if (weakSelf.vipClickBlock) {
                weakSelf.vipClickBlock();
            }
        };
    }
}


- (void)setSeriesArr:(NSMutableArray<HKJobPathModel *> *)seriesArr {
    _seriesArr = seriesArr;
    [self setNeedsLayout];
    if (seriesArr.count){
        // 刷新CollectionView
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
            [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    [self.contentCollectionView reloadData];
    
}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        layout.itemSize = CGSizeMake(117, 90);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [_contentCollectionView registerClass:[HKJobPathLearnedCourseCell class] forCellWithReuseIdentifier:NSStringFromClass([HKJobPathLearnedCourseCell class])];
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.seriesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKJobPathLearnedCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKJobPathLearnedCourseCell class]) forIndexPath:indexPath];
    cell.model = self.seriesArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.videoSelectedBlock? : self.videoSelectedBlock(indexPath, self.seriesArr[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
