//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.2
//

#import "HKLiveNotLearnedMiddleCell.h"
#import "HKLiveNotLearnedMiddleItmeCell.h"
#import "HKMyFollowVC.h"


@interface HKLiveNotLearnedMiddleCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end


@implementation HKLiveNotLearnedMiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

- (void)setVideos:(NSMutableArray<VideoModel *> *)videos {
    
    if (!videos.count) {
        videos = [NSMutableArray array];
        
        for (int i = 0; i < 10; i++) {
            VideoModel *model = [[VideoModel alloc] init];
            model.title = @"111111";
            model.video_titel = @"22222";
            model.cover_url = @"http://img95.699pic.com/photo/40140/2893.jpg_wh300.jpg";
            model.video_url = model.cover_url;
            model.cover_img_url = model.cover_url;
            model.img_cover_url = model.cover_url;
            model.img_cover_url_big = model.cover_url;
            [videos addObject:model];
        }
    }
    
    
    _videos = videos;
    
    // 刷新CollectionView
    [self.contentCollectionView reloadData];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.itemSize = CGSizeMake(312 * 0.5, 195 * 0.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentCollectionView setCollectionViewLayout:layout];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveNotLearnedMiddleItmeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKLiveNotLearnedMiddleItmeCell class])];
    self.contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
}



#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKLiveNotLearnedMiddleItmeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKLiveNotLearnedMiddleItmeCell class]) forIndexPath:indexPath];
    cell.model = self.videos[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return IS_IPAD? CGSizeMake(110, 91) : CGSizeMake(97, 80);
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
