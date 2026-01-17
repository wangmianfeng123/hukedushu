//
//  HKOtherVipMidCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKComingCategoryCell.h"
#import "HKComingCategoryInCell.h"
#import "HKVipPrivilegeModel.h"


@interface HKComingCategoryCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)HKVipPrivilegeModel *selectedModel; // 当前选中的model

@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *dataSource;

// 数据集合
@property (nonatomic, strong)NSMutableArray *headerArray;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSMutableArray *desArray;

@end

@implementation HKComingCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setpCollectionView];
    
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    self.collectionView.backgroundColor = COLOR_F8F9FA_333D48;
}

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model {
    _dataSource = dataSource;
    
    // 权益
    self.titleName.text = @"包含即将上线的分类";
    self.titleName.textColor = COLOR_27323F_EFEFF6;

    [self.collectionView reloadData];
}

- (void)setpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 * 2 - 2 * 8 - 0.1) / 3.0, IS_IPHONEMORE4_7INCH? 50 : 45);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKComingCategoryInCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKComingCategoryInCell class])];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 25, 0)];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKComingCategoryInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKComingCategoryInCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



@end
