//
//  HKCatalogueListVC.m
//  Code
//
//  Created by eon Z on 2022/4/27.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKCatalogueListVC.h"
#import "HKHomeAlbumSubCell.h"
#import "HKHomeVipHeader.h"

@interface HKCatalogueListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView * collectionView;

@property (nonatomic , strong) NSMutableArray * dataArray;

@property (nonatomic , strong) NSMutableArray * tempArray;


@property (nonatomic , strong) UILabel * txtLabel;
@end

@implementation HKCatalogueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    [self createUI];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)tempArray{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (void)createUI{
    //COLOR_A8ABBE_7B8196
    UILabel * txtLabel = [UILabel labelWithTitle:CGRectMake(15, 0, 200, 40) title:@"选择小节" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    [self.view addSubview:txtLabel];
    self.txtLabel = txtLabel;
    
    UIButton * closeBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor blackColor] titleFont:@"13" imageName:@""];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH - 33, 11, 18, 18);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage hkdm_imageWithNameLight:@"ic_close_question_dark_2_35" darkImageName:@"ic_close_question_2_35"] forState:UIControlStateNormal];
    [closeBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [self.view addSubview:closeBtn];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    //layout.sectionHeadersPinToVisibleBounds = YES;
    CGFloat w = ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 41) * 0.5;
    layout.itemSize = CGSizeMake(w, IS_IPAD ? (w * (165 + 30) / 270.0 ):160);//270/(165 + 50)
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.showsVerticalScrollIndicator =  YES;
    collectionView.showsHorizontalScrollIndicator =  NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHomeAlbumSubCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKHomeAlbumSubCell class])];
    [collectionView registerClass:[HKHomeVipHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKHomeVipHeader class])];
    
    self.collectionView = collectionView;
    
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (IS_IPAD) {
        self.collectionView.frame = CGRectMake(iPadContentMargin, 40, iPadContentWidth, self.view.height - 40);
    }else{
        self.collectionView.frame = CGRectMake(0, 40, SCREEN_WIDTH, self.view.height - 40);
    }
}



-(void)setDetaiModel:(DetailModel *)detaiModel{
    _detaiModel = detaiModel;
    [self.dataArray removeAllObjects];
    [self.tempArray removeAllObjects];
    
    for (HKCourseModel * secCourse in self.detaiModel.dataSource) {
        HKCourseModel * secM = [secCourse copy];
        [self.tempArray addObject:secM];
    }
    

    if ([self.detaiModel.video_type isEqualToString:@"6"]|| [self.detaiModel.video_type isEqualToString:@"7"] || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        
        for (int k = 0; k < self.tempArray.count; k++) {
            //HKCourseModel *secCourse 一级Model
            HKCourseModel * secCourse = self.tempArray[k];
            NSMutableArray * childArray = [NSMutableArray array];
            for (int i = 0; i < secCourse.children.count; i++) {
                //HKCourseModel *courseModel 二级model
                HKCourseModel *courseModel = secCourse.children[i];
                courseModel.praticeNO = [NSString stringWithFormat:@"%d-%d",k+1,i+1];
                [childArray addObject:courseModel];
                for (int j = 0; j < courseModel.children.count; j++) {
                    //HKCourseModel * model 三级model
                    HKCourseModel * model = courseModel.children[j];
                    model.praticeNO = [NSString stringWithFormat:@"练习%d",j+1];
                    [childArray addObject:model];
                }
            }
            secCourse.children = childArray;
            [self.dataArray addObject:secCourse];
        }
    }else{
        [self.dataArray addObjectsFromArray:self.tempArray];
    }
    
    
    NSIndexPath * index = nil;
    for (int i = 0; i < self.dataArray.count; i++) {
        HKCourseModel *secCourseModel = self.dataArray[i];
        if (secCourseModel.children.count) {
            for (int j = 0; j < secCourseModel.children.count; j++) {
                HKCourseModel * model = secCourseModel.children[j];
                if (model.currentWatching == YES) {
                    index = [NSIndexPath indexPathForRow:j inSection:i];
                }else{
                    model.currentWatching = NO;
                }
            }
        }else{
            if (secCourseModel.currentWatching == YES) {
                index = [NSIndexPath indexPathForRow:i inSection:0];
            }else{
                secCourseModel.currentWatching = NO;
            }
        }
    }
    
    [self.collectionView reloadData];
    if (index) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        });
    }
}

-(void)setVideoCount:(int)videoCount{
    self.txtLabel.text = [NSString stringWithFormat:@"选择小节(%d)",videoCount];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    // 课程
    if ([self.detaiModel.video_type isEqualToString:@"6"] || [self.detaiModel.video_type isEqualToString:@"7"]|| (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        return self.dataArray.count;
    }else{
        if (self.dataArray.count) {
            return 1;
        }
        return 0;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.detaiModel.video_type isEqualToString:@"6"] || [self.detaiModel.video_type isEqualToString:@"7"]|| (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        HKCourseModel *secCourse = self.dataArray[section];
        return secCourse.children.count;
    }else{
        return self.dataArray.count;
    }
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HKHomeAlbumSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHomeAlbumSubCell" forIndexPath:indexPath];
    cell.isVideoDetail = YES;
    cell.numberLabel.hidden = NO;
    
    // 系列课
    NSInteger type = [self.detaiModel.video_type integerValue];
    
    // 课程
    if ([self.detaiModel.video_type isEqualToString:@"6"]|| [self.detaiModel.video_type isEqualToString:@"7"] || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        HKCourseModel *secCourseModel = self.dataArray[indexPath.section];
        HKCourseModel *courseModel = secCourseModel.children[indexPath.row];
        [cell setModel:courseModel videoType:type];
        cell.numberLabel.text = courseModel.praticeNO;
    }else{
        HKCourseModel *seriesCourseModel = self.dataArray[indexPath.row];
        [cell setModel:seriesCourseModel videoType:type];
        cell.numberLabel.text = [NSString stringWithFormat:@"第%ld节",indexPath.row + 1];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // 课程
    HKCourseModel *seriesCourseModel = nil;
    NSIndexPath * index = nil;
    
    if ([self.detaiModel.video_type isEqualToString:@"6"]|| [self.detaiModel.video_type isEqualToString:@"7"] || (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        HKCourseModel *secCourse = self.dataArray[indexPath.section];
        seriesCourseModel = secCourse.children[indexPath.row];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            HKCourseModel *secCourseModel = self.dataArray[i];
            for (int j = 0; j < secCourseModel.children.count; j++) {
                HKCourseModel * model = secCourseModel.children[j];
                if ([model.video_id isEqualToString:seriesCourseModel.video_id]) {
                    model.currentWatching = YES;
                    index = [NSIndexPath indexPathForRow:j inSection:i];
                }else{
                    model.currentWatching = NO;
                }
            }
        }
    }else{
        seriesCourseModel = self.dataArray[indexPath.row];
        for (int i = 0; i < self.dataArray.count; i++) {
            HKCourseModel *secCourseModel = self.dataArray[i];
            if ([secCourseModel.video_id isEqualToString:seriesCourseModel.video_id]) {
                secCourseModel.currentWatching = YES;
                index = [NSIndexPath indexPathForRow:i inSection:0];
            }else{
                secCourseModel.currentWatching = NO;
            }
        }
    }
    
    if (index) {
        [self.collectionView reloadData];
        if (self.didItemBlock) {
            self.didItemBlock(seriesCourseModel);
        }
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HKHomeVipHeader *vipHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKHomeVipHeader class]) forIndexPath:indexPath];
        HKCourseModel * seriesCourseModel = self.dataArray[indexPath.section];
        vipHeader.titleLabel.text = seriesCourseModel.title;
        vipHeader.backgroundColor = COLOR_F8F9FA_333D48;
        vipHeader.moreBtn.hidden = YES;
        return vipHeader;
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.detaiModel.video_type isEqualToString:@"6"] || [self.detaiModel.video_type isEqualToString:@"7"]|| (self.detaiModel.is_series && (self.detaiModel.is_buy_series == 1))) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeZero;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)closeBtnClick{
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

@end
