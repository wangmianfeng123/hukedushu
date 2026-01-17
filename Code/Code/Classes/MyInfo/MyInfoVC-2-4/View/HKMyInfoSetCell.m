//
//  HKMyInfoSetCell.m
//  Code
//
//  Created by Ivan li on 2018/9/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyInfoSetCell.h"
#import "HKMyInfoSetChildCell.h"
#import "HKMyInfoUserModel.h"
#import <TBScrollViewEmpty/TBEmptyView.h>



@implementation HKMyInfoSetCell

#pragma mark TBScrollViewEmpty
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return NO;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


- (void)setDataArr:(NSMutableArray<HKMyInfoMapPushModel *> *)dataArr {
    _dataArr = dataArr;
    
    if ([[CommonFunction getAPPStatus] isEqualToString:@"1"]) {
        HKMyInfoMapPushModel * flagM = nil;
        for (HKMyInfoMapPushModel * mdoel in dataArr) {
            if ([mdoel.title isEqualToString:@"优惠券"]) {
                flagM = mdoel;
            }
        }
        if (flagM) {
            [_dataArr removeObject:flagM];
        }
    }
    
    
    
    [self.collectionView reloadData];

}



- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tb_EmptyDelegate = self;
        
        _collectionView.scrollEnabled = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        [_collectionView registerClass:[HKMyInfoSetChildCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyInfoSetChildCell class])];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _collectionView;
}





#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKMyInfoSetChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyInfoSetChildCell class]) forIndexPath:indexPath];
    cell.mapModel = self.dataArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKMyInfoMapPushModel *model = self.dataArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(myInfoSetCellClickAction:indexPath:)]) {
        [self.delegate myInfoSetCellClickAction:model indexPath:indexPath];
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        NSInteger count = self.dataArr.count;
        if (count) {
            CGFloat W = (SCREEN_WIDTH - 20)/count;
            W = (W <90) ?90 :W;
            return CGSizeMake(W, 160/2);
        }else{
            return CGSizeMake(90, 160/2);
        }
    }else{
        CGFloat W = (SCREEN_WIDTH - 20)/4;
        return CGSizeMake(W, 160/2 * Ratio);
    }
}





- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


@end



