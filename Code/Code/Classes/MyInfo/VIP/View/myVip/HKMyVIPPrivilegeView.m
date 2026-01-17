//
//  HKMyVIPPrivilegeView.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyVIPPrivilegeView.h"
#import "HKVipPrivilegeModel.h"
#import "HKVipPrivilegeInCell.h"

@interface HKMyVIPPrivilegeView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKMyVIPPrivilegeView

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource {
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
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 * 2 - 2 * 15 - 0.1) / 3.0, IS_IPHONEMORE4_7INCH? 84 : 78);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeInCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class])];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 25, 0)];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKVipPrivilegeInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKVipPrivilegeInCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


@end
