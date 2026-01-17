
//
//  HKSearchAllInfoVC.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchAllInfoVC.h"
#import "HKSearchAllInfoCell.h"
#import "HKSearchCourseCell.h"
#import "HKSearchAllInfoModel.h"
#import "HKTeacherDetailVC.h"
#import "VideoPlayVC.h"
#import "HKSearchPgcCell.h"
#import "HKSearchAlbumCell.h"
#import "SeriseCourseCollectionCell.h"


@interface HKSearchAllInfoVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HKBaseSearchTeacCellDelegate>

@property(nonatomic, strong)UICollectionView *contanerView;

@property(nonatomic, strong)NSMutableArray *courseArr;

@property(nonatomic, copy)NSString *keyWord;

@property(nonatomic, assign)NSInteger pageSize;

@property(nonatomic, strong)HKSearchAllInfoModel *allINfoModel;

@end


@implementation HKSearchAllInfoVC


- (instancetype)initWithKeyWord:(NSString *)keyWord {
    
    if (self = [super init]) {
        self.keyWord = keyWord;
        self.pageSize = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVideoAndTeacherByWord:self.keyWord page:@"1"];
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
    self.view.backgroundColor = bgColor;
    [self.view addSubview:self.contanerView];
    [self refreshUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick event:UM_RECORD_SEARCH_PAGE_ALL_TAB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)courseArr {
    if (!_courseArr) {
        _courseArr = [NSMutableArray array];
    }
    return _courseArr;
}




- (UICollectionViewLayout*)layout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = PADDING_5;
    return layout;
}


- (UICollectionView*)contanerView {
    
    if (!_contanerView) {
        
        _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight44-kHeight49) collectionViewLayout:[self layout]];
        [_contanerView registerClass:[HKSearchAllInfoCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchAllInfoCell class])];
        [_contanerView registerClass:[HKSearchCourseCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchCourseCell class])];
        
        [_contanerView registerClass:[HKBaseSearchTeacCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKBaseSearchTeacCell class])];
        [_contanerView registerClass:[HKSearchCourseCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchCourseCell class])];
        [_contanerView registerClass:[HKSearchPgcCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchPgcCell class])];
        
        [_contanerView registerClass:[HKSearchAlbumCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchAlbumCell class])];
        [_contanerView registerClass:[SeriseCourseCollectionCell class]  forCellWithReuseIdentifier:NSStringFromClass([SeriseCourseCollectionCell class])];
        [_contanerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
        _contanerView.backgroundColor = bgColor;
        _contanerView.delegate = self;
        _contanerView.dataSource = self;
        
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _contanerView);
        [_contanerView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _contanerView.tb_EmptyDelegate = self;
    }
    return _contanerView;
}


#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger count = 0;
    if ((self.allINfoModel.teacher_list.count)) {
        count++;
    }
    if (self.courseArr.count>0) {
        count++;
    }
    return count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (0==section && self.allINfoModel.teacher_list.count>0)? self.allINfoModel.teacher_list.count : self.courseArr.count;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return (0==indexPath.section && self.allINfoModel.teacher_list.count>0)? CGSizeMake(SCREEN_WIDTH, 90+160) : CGSizeMake(SCREEN_WIDTH, 120);
    NSInteger count=0;
    if (0==indexPath.section){
        count = self.allINfoModel.teacher_list[indexPath.row].video_list.count;
    }
    return (0==indexPath.section && self.allINfoModel.teacher_list.count>0)? CGSizeMake(SCREEN_WIDTH,(count>0? 90+160 :90)) : CGSizeMake(SCREEN_WIDTH, 120);
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (0 ==indexPath.section && self.allINfoModel.teacher_list.count>0) {
        UICollectionReusableView *footer = nil;
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
            headView.backgroundColor = bgColor;
            footer = headView;
            return footer;
        }
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return (0==section && self.allINfoModel.teacher_list.count>0)? CGSizeMake(SCREEN_WIDTH, PADDING_10) : CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    if (0 == indexPath.section && self.allINfoModel.teacher_list.count>0) {
        HKSearchAllInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchAllInfoCell class]) forIndexPath:indexPath];
        cell.userInfo = self.allINfoModel.teacher_list[indexPath.row];
        cell.delegate = self;
        // 嵌套cell的点击
        cell.homeMyFollowVideoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                        videoName:model.video_titel
                                                 placeholderImage:model.img_cover_url
                                                       lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
            [weakSelf pushToOtherController:VC];
        };
        
        cell.avatorClickBlock = ^{
            [MobClick event:UM_RECORD_DETAIL_TEACHER];
            HKTeacherDetailVC *vc = [[HKTeacherDetailVC alloc] init];
            vc.teacher_id = weakSelf.allINfoModel.teacher_list[indexPath.row].teacher_id;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                weakSelf.allINfoModel.teacher_list[indexPath.row].is_follow = is_follow;
                [weakSelf.contanerView reloadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else{
        HKSearchCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchCourseCell class]) forIndexPath:indexPath];
        cell.model = self.courseArr[indexPath.row];//weakSelf.allINfoModel.list[indexPath.row];
        return cell;
    }
}



#pragma mark - HKSearchAllInfoCell 代理
- (void)focusTeacher:(id)sender {
    [MobClick event:UM_RECORD_SEARCH_ALL_CONCERN];
    isLogin() ? nil : [self setLoginVC];
}


#pragma mark <UICollectionViewLayouDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (1 == indexPath.section ||self.allINfoModel.teacher_list.count<=0) {
        [MobClick event:UM_RECORD_DETAIL_PAGE_RECOMMEND];
        VideoModel *model = self.courseArr[indexPath.row];//self.allINfoModel.list[indexPath.row];
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                    videoName:model.video_titel
                                             placeholderImage:model.img_cover_url
                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
        [self pushToOtherController:VC];
    }
}


#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
        MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageSize = 1;
            [weakSelf getVideoAndTeacherByWord:weakSelf.keyWord page:@"1"];
        }];
        header.automaticallyChangeAlpha = YES;
        _contanerView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
        header.stateLabel.hidden = NO;
        _contanerView.mj_header.lastUpdatedTimeKey.accessibilityElementsHidden = YES;
        MJRefreshAutoStateFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",(weakSelf.pageSize == 1)? 2: weakSelf.pageSize];
        [weakSelf getVideoAndTeacherByWord:weakSelf.keyWord page:pageNum];
    }];
    _contanerView.mj_footer = footer;
    _contanerView.mj_footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    [footer setTitle:FOOTER_NO_MORE_DATA forState:MJRefreshStateNoMoreData];
}


- (void)tableHeaderEndRefreshing {
    [_contanerView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_contanerView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_contanerView.mj_footer endRefreshing];
}


#pragma mark - 获取视频和教师列表
- (void)getVideoAndTeacherByWord:(NSString*)word page:(NSString*)page {
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:word,@"keyword", page,@"page",nil];
    [HKHttpTool POST:SEARCH_COURSE parameters:parameters success:^(id responseObject) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKSearchAllInfoModel *model =[HKSearchAllInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            if(model.teacher_list.count >0){
                strongSelf.allINfoModel = model;
            }
            NSInteger count = [model.count intValue];
            if ([page isEqualToString:@"1"]) {
                strongSelf.courseArr = model.list;
                if (count >0) {
                    NSDictionary *dict = @{@"courseCount":[NSString stringWithFormat:@"%ld",count],@"index":@"1"};
                    [MyNotification postNotificationName:KSearchResultCountNotification object:nil userInfo:dict];
                }
            }else{
                [strongSelf.courseArr addObjectsFromArray:model.list];
                strongSelf.pageSize++;
            }
            if (strongSelf.courseArr.count >= count || model.list.count == 0){
                [strongSelf tableFooterEndRefreshing];
            }else{
                [strongSelf tableFooterStopRefreshing];
            }
            [strongSelf.contanerView reloadData];
        }else{
            [strongSelf tableFooterStopRefreshing];
        }
    } failure:^(NSError *error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
        if (strongSelf.courseArr.count<1) {
            [strongSelf.contanerView reloadData];
        }else{
            showTipDialog(NETWORK_NOT_POWER);
        }
    }];
}

@end

