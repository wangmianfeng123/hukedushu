//
//  HKAttentionBottomCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKAttentionBottomCell.h"
#import "HKInterestCell.h"
#import "HKMomentDetailModel.h"

@interface HKAttentionBottomCell ()<UICollectionViewDelegate,UICollectionViewDataSource,HKInterestCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKAttentionBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    [self setupCollectionView];

}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(135, 170);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    // 解决iPad滚动bug
//    if (IS_IPAD) {
//        self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    }

    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKInterestCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKInterestCell class])];
    self.collectionView.backgroundColor = COLOR_F8F9FA_333D48;
}


#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKInterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKInterestCell class]) forIndexPath:indexPath];
    HKrecommendUserModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
        return CGSizeZero;
}

-(void)interestCellDidHeaderBtn:(HKrecommendUserModel *)model{
    if ([self.delegate respondsToSelector:@selector(attentionBottomCellDidHeader:)]) {
        [self.delegate attentionBottomCellDidHeader:model];
    }
}

- (void)interestCellDidAttentionBtn:(HKrecommendUserModel *)model{
    if ([self.delegate respondsToSelector:@selector(attentionBottomCellDidAttention:)]) {
        [self.delegate attentionBottomCellDidAttention:model];
    }
}
@end
