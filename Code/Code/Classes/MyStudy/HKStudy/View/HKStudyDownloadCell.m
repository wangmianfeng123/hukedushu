//
//  HKHomeFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.2
//

#import "HKStudyDownloadCell.h"
#import "HKStudyDownloadItmeCell.h"
#import "HKMyFollowVC.h"


@interface HKStudyDownloadCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TBSrollViewEmptyDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic, strong)NSMutableArray<VideoModel *> *videos;

@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *models;

/** 下载的数据 */
@property (nonatomic, strong)NSMutableArray *historyArray; // 已经下载
@property (nonatomic, strong)NSMutableArray *notFinishArray; // 正在下载
@property (nonatomic, strong)NSMutableArray *directoryArray; // 目录

@property (weak, nonatomic) IBOutlet UIImageView *studyIconIV;

@end


@implementation HKStudyDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.moreBtn.userInteractionEnabled = NO;
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

- (void)setHistory:(NSMutableArray *)historyArray notFinish:(NSMutableArray *)notFinishArray diretory:(NSMutableArray *)directoryArray {
    self.historyArray = historyArray;
    self.notFinishArray = notFinishArray;
    self.directoryArray = directoryArray;
    
    
    // 处理正在的数组
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 正在下载的封装model
    if (notFinishArray.count) {
        
        HKDownloadModel *dowloadingModel = nil;
        for (HKDownloadModel *model in notFinishArray) {
            if (model.status == HKDownloading) {
                dowloadingModel = model;
                break;
            } else if (model.status != HKDownloadFailed || model.status != HKDownloadPause) {
                dowloadingModel = model;
            }
        }
        if (dowloadingModel == nil) {
            dowloadingModel = notFinishArray.lastObject;
        }
        
        HKDownloadModel *allNotFinishModel = [[HKDownloadModel alloc] init];
        allNotFinishModel.img_cover_url = @"pic_download_v2_13";
        allNotFinishModel.downloadingCount = notFinishArray.count;
        allNotFinishModel.isDownloadingCountModel = YES;
        allNotFinishModel.title = dowloadingModel.name;
        [dataArray addObject:allNotFinishModel];
    }
    
    // 已经下载的目录封装
    if (directoryArray.count) {
        for (int i = 0; i < 8 && i < directoryArray.count; i++) {
            [dataArray addObject:directoryArray[i]];
        }
    }
    
    // 更多的按钮封装
    if (directoryArray.count > 8) {
        HKDownloadModel *modelModel = [[HKDownloadModel alloc] init];
        modelModel.img_cover_url = @"check_more_cell_image";
        modelModel.isMoreModel = YES;
        [dataArray addObject:modelModel];
    }
    self.models = dataArray;

    
    // 显示隐藏更多字符串
    [self.moreBtn setTitle: directoryArray.count <= 8? @"    " : @"更多" forState:UIControlStateNormal];
    
    // 刷新CollectionView
    [self.contentCollectionView reloadData];
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
    [self.contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyDownloadItmeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKStudyDownloadItmeCell class])];
    self.contentCollectionView.tb_EmptyDelegate = self;
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.separator.backgroundColor = COLOR_F8F9FA_333D48;
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"myStudy_download") darkImage:imageName(@"myStudy_download_dark")];
    self.studyIconIV.image = image;
}

#pragma mark <TBSrollViewEmptyDelegate>
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return NO;
}


#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKStudyDownloadItmeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKStudyDownloadItmeCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return IS_IPAD? CGSizeMake(120, 100) : CGSizeMake(194 * 0.5, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.modelSelectedBlock? : self.modelSelectedBlock(indexPath, self.models[indexPath.row]);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
