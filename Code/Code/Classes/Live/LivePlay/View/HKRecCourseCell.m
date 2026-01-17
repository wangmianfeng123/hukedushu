//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKRecCourseCell.h"
#import "HomeMyFollowVideoCell.h"
#import "HKMyFollowVC.h"

@interface HKRecCourseCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end


@implementation HKRecCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.backgroundColor = [UIColor whiteColor];
        [self setupCollectionView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}


- (void)setRecommends:(NSArray<VideoModel *> *)recommends {
    _recommends = recommends;
    [self.contentCollectionView reloadData];
}


- (void)setupCollectionView {
    
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.text = @"推荐课程";
    [self addSubview:titleLB];
    titleLB.textColor = COLOR_27323F_EFEFF6;
    titleLB.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = 8.0;
    layout.itemSize = CGSizeMake(312 * 0.5, 195 * 0.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:collectionView];
    self.contentCollectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLB.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
        make.top.mas_equalTo(titleLB.mas_bottom).offset(13);
    }];
    collectionView.backgroundColor = COLOR_FFFFFF_3D4752;

    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeMyFollowVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class])];
    
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
}



#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeMyFollowVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeMyFollowVideoCell class]) forIndexPath:indexPath];
    cell.model = self.recommends[indexPath.row];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(312 * 0.5, 122);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *model = self.recommends[indexPath.row];
    !self.didSelectedRecBlock? : self.didSelectedRecBlock(model);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


@end
