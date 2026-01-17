//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.2
//

#import "HKStudyLearnedMiddleCell.h"
#import "HKStudyLearnedMiddleItmeCell.h"
#import "HKMyFollowVC.h"


@interface HKStudyLearnedMiddleCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (nonatomic, strong)NSMutableArray<VideoModel *> *videos;

@end


@implementation HKStudyLearnedMiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

- (IBAction)moreBtnClick:(id)sender {
    !self.moreBtnClickBlock? : self.moreBtnClickBlock();
}

- (void)setModel:(HKMyLearningCenterModel *)model {
    _videos = model.recentStudiedList;
    // 刷新CollectionView
    [self.contentCollectionView reloadData];
    
    // 显示隐藏更多字符串
    [self.moreBtn setTitle: !model.hasMore? @"    " : @"更多" forState:UIControlStateNormal];
}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = 8.0;
    layout.itemSize = CGSizeMake(312 * 0.5, 195 * 0.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 15)];
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentCollectionView setCollectionViewLayout:layout];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyLearnedMiddleItmeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKStudyLearnedMiddleItmeCell class])];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.separator.backgroundColor = COLOR_F8F9FA_333D48;
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"myStudy_study") darkImage:imageName(@"myStudy_study_dark")];
    self.iconIV.image = image;
}


#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKStudyLearnedMiddleItmeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKStudyLearnedMiddleItmeCell class]) forIndexPath:indexPath];
    cell.model = self.videos[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return IS_IPAD? CGSizeMake(120, 115) : CGSizeMake(194 * 0.5, 80);
    return CGSizeMake(194 * 0.5, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.videoSelectedBlock? : self.videoSelectedBlock(indexPath, self.videos[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
