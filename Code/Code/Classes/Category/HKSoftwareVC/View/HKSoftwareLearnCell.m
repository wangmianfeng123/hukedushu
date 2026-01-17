//
//  HKSoftwareLearnCell.m
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareLearnCell.h"
#import "HKSearchScrollVideoCell.h"
#import "HKSoftwareCourseCell.h"

@interface HKSoftwareLearnCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation HKSoftwareLearnCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentCollectionView];
    }
    return self;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"最近在学的软件" titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(13);
    }];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(102);
    }];
}




- (void)setSeriesArr:(NSMutableArray<VideoModel *> *)seriesArr {
    _seriesArr = seriesArr;
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.contentCollectionView reloadData];
}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //layout.itemSize = CGSizeMake(250/2, 138);
        layout.itemSize = CGSizeMake(110, 102);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [_contentCollectionView registerClass:[HKSoftwareCourseCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSoftwareCourseCell class])];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.seriesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKSoftwareCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSoftwareCourseCell class]) forIndexPath:indexPath];
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}
@end
