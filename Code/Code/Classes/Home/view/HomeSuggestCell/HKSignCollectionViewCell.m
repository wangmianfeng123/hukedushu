//
//  HKSignCollectionViewCell.m
//  Code
//
//  Created by eon Z on 2021/8/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKSignCollectionViewCell.h"
#import "HKHomeSignCell.h"
#import "UIView+HKLayer.h"
#import "HKHomeSignModel.h"

@interface HKSignCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation HKSignCollectionViewCell

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.closeBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_close_interest_2_37" darkImageName:@"ic_close_interest_dark_2_37"] forState:UIControlStateNormal];
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.topRightLabel.textColor = COLOR_27323F_EFEFF6;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.bgView addCornerRadius:5 addBoderWithColor:COLOR_EFEFF6_333D48];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    CGFloat w = IS_IPAD ? (SCREEN_WIDTH - 15 * 2 - 15 *2 - 15 * 5) /6.0 : (SCREEN_WIDTH - 15 * 2 - 15 *2 - 15) * 0.5;
    layout.itemSize = CGSizeMake(w, 50);
    self.collectionView.collectionViewLayout = layout;
    
    _collectionView.showsVerticalScrollIndicator =  NO;
    _collectionView.showsHorizontalScrollIndicator =  NO;
    _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    _collectionView.bounces = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        /// 解决高度不准确问题 大概少了 64
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHomeSignCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKHomeSignCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKHomeSignCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeSignCell class]) forIndexPath:indexPath];
    
    HKHomeSignModel * signModel = self.dataArray[indexPath.row];
    if (signModel.isMore == YES) {
        cell.signLabel.text = @"更多";
        cell.signLabel.textColor = COLOR_27323F_EFEFF6;
        cell.signLabel.backgroundColor = COLOR_FFFFFF_3D4752;
        cell.signLabel.layer.borderColor = COLOR_27323F_EFEFF6.CGColor;
    }else{
        cell.signModel = signModel;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HKHomeSignModel * model = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(signCollectionViewCellDidSgin:)]) {
        [self.delegate signCollectionViewCellDidSgin:model];
    }
}

- (IBAction)closeBtnClick {
    if (self.didCloseBlock) {
        self.didCloseBlock();
    }
}

-(void)setSignArray:(NSMutableArray *)signArray{
    [self.dataArray removeAllObjects];
    HKHomeSignModel * model = [[HKHomeSignModel alloc] init];
    model.isMore = YES;
    if (signArray.count>5) {
        NSArray * arry = [signArray subarrayWithRange:NSMakeRange(0, 5)];
        [self.dataArray addObjectsFromArray:arry];
        [self.dataArray addObject:model];
    }else{
        [self.dataArray addObjectsFromArray:signArray];
        [self.dataArray addObject:model];
    }
    [self.collectionView reloadData];
}
@end
