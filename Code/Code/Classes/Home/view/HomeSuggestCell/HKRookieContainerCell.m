//
//  HKRookieContainerCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKRookieContainerCell.h"
#import "HKRookieCell.h"

@interface HKRookieContainerCell()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end


@implementation HKRookieContainerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 5;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;
    // 注册cell
    [self.collectionView registerClass:[HKRookieCell class] forCellWithReuseIdentifier:NSStringFromClass([HKRookieCell class])];
}

- (void)setRookieArray:(NSMutableArray<SoftwareModel *> *)rookieArray {
    _rookieArray = rookieArray;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.rookieArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKRookieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKRookieCell class]) forIndexPath:indexPath];
    cell.model = self.rookieArray[indexPath.row];
    return  cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - 13 * 2 - 2 * 5) / 3.0;
    return CGSizeMake(width, 115);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:UM_RECORD_HOME_BEGINNER_VIDEO];
    !self.rookieBlock? : self.rookieBlock(indexPath, self.rookieArray[indexPath.row]);
}

@end
