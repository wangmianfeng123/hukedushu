//
//  HKRecomandSubVC.m
//  Code
//
//  Created by eon Z on 2021/11/3.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKRecomandSubVC.h"
#import "HomeSuggestCell.h"
#import "UIView+HKExtension.h"
#import "HomeRecommendeCell.h"
#import "HomeRecommendeFooterMoreCell.h"
#import "TagModel.h"
#import "HKDesignCategoryVC.h"
#import "VideoPlayVC.h"

@interface HKRecomandSubVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) NSMutableArray * recommendVideoArray;
@property (nonatomic , assign) BOOL isNetDataRefresh;
@property (nonatomic , assign)BOOL recommend_video_free_play; //新注册用户免费播放

@end

@implementation HKRecomandSubVC


- (instancetype)initWithNetDataRefresh:(BOOL)isNetDataRefresh{
    if ([super init]) {
        _isNetDataRefresh = isNetDataRefresh;
    }
    return self;
}


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)recommendVideoArray{
    if (_recommendVideoArray == nil) {
        _recommendVideoArray = [NSMutableArray array];
    }
    return _recommendVideoArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.collectionView];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.view addSubview:lineView];
    [self loadData];
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10,self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.showsVerticalScrollIndicator =  NO;
        _collectionView.showsHorizontalScrollIndicator =  NO;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(kHeight44, 0, 0, 0);
        [_collectionView registerClass:[HomeSuggestCell class] forCellWithReuseIdentifier:@"HomeSuggestCell"];
        [_collectionView registerClass:[HomeRecommendeCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendeCell"];
        [_collectionView registerClass:[HomeRecommendeFooterMoreCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeRecommendeFooterMoreCell"];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _collectionView);

    }
    return _collectionView;
}

- (void)loadData{
    NSLog(@"-------%@",self.tagM.class_id);
    
    [HKHttpTool POST:@"/home/class-recommend-video" parameters:@{@"class_id":self.tagM.class_id} success:^(id responseObject) {
        if (HKReponseOK) {
            self.recommendVideoArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"][@"recommend_video"]];
            self.dataArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"][@"newest_video"]];
            self.recommend_video_free_play = [responseObject[@"data"][@"recommend_video_free_play"] boolValue];
            [self.collectionView reloadData];
            if (self.isNetDataRefresh) {
                NSLog(@"网络刷新数据");
                
                if (self.recommendVideoArray.count) {
                    for (VideoModel * model in self.recommendVideoArray) {
                        [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:model.ID btn_type:16];
                    }
                }
                if (self.dataArray.count) {
                    for (VideoModel * model in self.dataArray) {
                        [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:model.ID btn_type:16];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-  (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.recommendVideoArray.count == 0 && self.dataArray.count == 0) {
        return 0;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.recommendVideoArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    HomeSuggestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSuggestCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.recommendVideoArray[indexPath.row];
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize recommendCellSize = IS_IPAD? CGSizeMake((SCREEN_WIDTH - 20) / 4.0, 220) : CGSizeMake((SCREEN_WIDTH-20)/2, 161);
    return recommendCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 头部
        if (indexPath.section == 0 || indexPath.section == 1) {
            HomeRecommendeCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendeCell" forIndexPath:indexPath];
            cell.titleLabel.text = indexPath.section ? @"最新上架": @"今日推荐";
            cell.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            cell.rightTitleLabel.text = @"";
            [cell.changeBtn setTitle:@"更多" forState:UIControlStateNormal];
            [cell.changeBtn setImage:[UIImage imageNamed:@"home_my_follow_more"] forState:UIControlStateNormal];
            [cell.changeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            cell.changeBtn.hidden = NO;
//            cell.freeLabel.hidden = indexPath.section ? YES : NO;
            [cell.changeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
            cell.grayLabel.hidden = YES ;
            cell.freeLabel.hidden = self.recommend_video_free_play ? (indexPath.section ? YES : NO) : YES;
            WeakSelf
            cell.changeVideoBlock = ^{
                HKDesignCategoryVC * VC = [[HKDesignCategoryVC alloc] init];
                VC.category = [NSString stringWithFormat:@"%@",weakSelf.tagM.class_id];
                [weakSelf pushToOtherController:VC];
            };
            [cell changeMas_makeConstraints:indexPath.section ? -5 : 0];
            
            return cell;
        }
        return [UICollectionReusableView new];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        // 今日 推荐的尾部
        if (indexPath.section) {
            HomeRecommendeFooterMoreCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeRecommendeFooterMoreCell" forIndexPath:indexPath];
            [cell.changeBtn setTitle:[NSString stringWithFormat:@"更多%@视频",self.tagM.name] forState:UIControlStateNormal];
            [cell.changeBtn setImage:[UIImage imageNamed:@"ic_go_homepage_2_38"] forState:UIControlStateNormal];
            [cell.changeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
            [cell.changeBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
            WeakSelf
            cell.changeVideoBlock = ^{
                HKDesignCategoryVC * VC = [[HKDesignCategoryVC alloc] init];
                VC.category = [NSString stringWithFormat:@"%@",weakSelf.tagM.class_id];
                [weakSelf pushToOtherController:VC];
            };
            return cell;
        }
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    //return section ?CGSizeMake(SCREEN_WIDTH, 40) CGSizeMake(SCREEN_WIDTH, 50);
    return CGSizeMake(SCREEN_WIDTH, 40);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return section ? CGSizeMake(SCREEN_WIDTH, 40) : CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * videoId = nil;
    if (indexPath.section == 0) {
        VideoModel * model = self.recommendVideoArray[indexPath.row];
        videoId = model.ID;
    }else{
        VideoModel * model = self.dataArray[indexPath.row];
        videoId = model.ID;
    }
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
    VC.fromHomeRecommand = YES;
    VC.fromHomeRecommandVideo = YES;
    [self pushToOtherController:VC];
    
    if (videoId.length) {
        [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:videoId btn_type:17];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
