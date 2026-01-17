//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKHomeFollowV2Cell.h"
#import "HKMyFollowVC.h"
#import "HKMidBigFlowLayout.h"
#import "ZKZoomLayout.h"
#import "HomeMyFollowVideoV3Cell.h"
#import "HKRecommendTxtModel.h"

@interface HKHomeFollowV2Cell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end


@implementation HKHomeFollowV2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    [self setupCollectionView];
}


#pragma mark - 关注 讲师
- (void)focusBtnClick:(UIButton*)btn {
    
}

-(void)setContent_list:(NSMutableArray *)content_list{
    if (content_list.count == 0) {
        return;
    }
    
    _content_list = content_list;
    [self.contentCollectionView reloadData];
}

//- (void)setTeacher_list:(NSMutableArray<HKUserModel *> *)teacher_list {
//    
//    if (teacher_list.count == 0) {
//        return;
//    }
//    
//    _teacher_list = teacher_list;
//    [self.contentCollectionView reloadData];
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 20, 0, 20);
//}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = IS_IPAD ? CGSizeMake(220, 293) : CGSizeMake(210, 280);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    // 解决iPad滚动bug
//    if (IS_IPAD) {
//        self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    }

    [self.contentCollectionView setCollectionViewLayout:layout];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeMyFollowVideoV3Cell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoV3Cell class])];
    self.contentCollectionView.backgroundColor = COLOR_F8F9FA_333D48;
    self.contentCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IS_IPAD ? 293: 280);
}

#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.content_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeMyFollowVideoV3Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoV3Cell class]) forIndexPath:indexPath];
    cell.model = self.content_list[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //!self.homeMyFollowVideoSelectedBlock? : self.homeMyFollowVideoSelectedBlock(indexPath, self.teacher_list[indexPath.row]);

    [MobClick event:shouye_recommend_class];
    
    !self.videoSelectedBlock? : self.videoSelectedBlock(self.content_list[indexPath.row]);
    
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(0, 30, 0, 30);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
        return CGSizeZero;
}

@end
