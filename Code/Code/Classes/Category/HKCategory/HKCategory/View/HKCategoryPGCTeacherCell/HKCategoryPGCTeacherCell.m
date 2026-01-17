//
//  HKPGCTeacherCell.m
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryPGCTeacherCell.h"
#import "HKPGCTeacherIconCell.h"


@interface HKCategoryPGCTeacherCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@end

@implementation HKCategoryPGCTeacherCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.contentCollectionView];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}



- (void)setSeriesArr:(NSMutableArray<HKcategoryChilderenModel *> *)seriesArr {
    
    _seriesArr = seriesArr;
    // 刷新CollectionView
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.contentCollectionView reloadData];
}


//- (void)setSeriesArr:(NSMutableArray<VideoModel *> *)seriesArr {
//    _seriesArr = seriesArr;
//    // 刷新CollectionView
//    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
//    if ([self.contentCollectionView cellForItemAtIndexPath:indexPath2]) {
//        [self.contentCollectionView scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
//    [self.contentCollectionView reloadData];
//}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(95, 230/2);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [_contentCollectionView registerClass:[HKPGCTeacherIconCell class] forCellWithReuseIdentifier:NSStringFromClass([HKPGCTeacherIconCell class])];
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.seriesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPGCTeacherIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKPGCTeacherIconCell class]) forIndexPath:indexPath];
    //cell.model = self.seriesArr[indexPath.row];
    cell.childerenModel = self.seriesArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.CategoryPGCTeacherSelectBlock? : self.CategoryPGCTeacherSelectBlock(indexPath, self.seriesArr[indexPath.row]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
@end
