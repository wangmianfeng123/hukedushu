//
//  HKInternetRcommandCell.m
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKInternetRcommandCell.h"
#import "HKInternetSubCell.h"
#import "HKCategoryTreeModel.h"

@interface HKInternetRcommandCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong,nonatomic)UICollectionView *collectionView;

@end

@implementation HKInternetRcommandCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        //layout.itemSize = CGSizeMake(250/2, 138);
        layout.itemSize = CGSizeMake(180, self.height-10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKInternetSubCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKInternetSubCell class])];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _collectionView;
}

#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKInternetSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKInternetSubCell class]) forIndexPath:indexPath];
    cell.isTrain = self.model.klass;
    cell.liveModel = self.model.list[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.klass == -1) {//训练营
        if (self.didCellBlock) {
            [MobClick event:fenleiye_hukewangxiao_training];
            self.didCellBlock(self.model.list[indexPath.row], YES);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

-(void)setModel:(HKcategoryOnlineSchoolListModel *)model{
    _model = model;
    [self.collectionView reloadData];
}
@end
