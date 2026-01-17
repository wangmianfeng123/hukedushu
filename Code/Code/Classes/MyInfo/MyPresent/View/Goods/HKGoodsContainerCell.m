//
//  HKGoodsContainerCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKGoodsContainerCell.h"
#import "HKGoodsCell.h"

@interface HKGoodsContainerCell()<UICollectionViewDelegate, UICollectionViewDataSource, HKGoodsCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HKGoodsContainerCell

- (void)setDataSource:(NSMutableArray<HKGoodsModel *> *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setpCollectionView];
}

- (void)setpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 13 * 2 - 10) * 0.5, 220);
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKGoodsCell class])];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKGoodsCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    // 设置选中的model
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 执行代理
    [MobClick event:UM_RECORD_SINGLE_MALL_DETAIL];
    HKGoodsModel *model = self.dataSource[indexPath.row];
    if (model.stock.intValue > 0 && [self.delegate respondsToSelector:@selector(HKOtherVIPSelected:)]) {
        [self.delegate HKOtherVIPSelected:model];
    }
    
}

#pragma mark <HKGoodsCellDelegate>
- (void)HKGoodsClick:(HKGoodsModel *)model {
    // 调用代理
    if (model.stock.intValue > 0 && [self.delegate respondsToSelector:@selector(HKOtherVIPClick:)]) {
        [self.delegate HKOtherVIPClick:model];
    }
}

@end
