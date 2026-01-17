//
//  HKSearchCourseVC.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchCourseVC.h"
#import "HKTeacherCourseVC.h"
#import "VideoPlayVC.h"
#import "HKBaseSearchTeacCell.h"
#import "HKSearchCourseCell.h"
#import "HKSearchCourseModel.h"
#import "HKSearchTeacherModel.h"

#import "SeriseCourseCollectionCell.h"
#import "HKSearchPgcCell.h"
#import "HKSearchAlbumCell.h"
#import "HKSearchAllInfoCell.h"
#import "HKSearchAllInfoModel.h"
#import "TagModel.h"
#import "HKSearchScrollCell.h"
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>
#import "HKAlbumDetailVC.h"
#import "HKContainerModel.h"
#import "HKAlbumListModel.h"

#import "HKDropMenu.h"
#import "HKDropMenuModel.h"
#import "HKSearchSoftwareCell.h"
#import "HKSearchBaseSoftWareCell.h"
#import "HKSearchArticleCell.h"
#import "HKSearchCourseBottomView.h"
#import "HKArticleModel.h"
#import "HKSearchRecommendArticleCell.h"
#import "HKSearchRecommendAlbumCell.h"
#import "HKArticleDetailVC.h"
#import "NSArray+Bounds.h"
#import "HKLiveCourseVC.h"
#import "HKBookModel.h"
#import "HKSearchLiveCell.h"
#import "HKSearchBookCell.h"
#import "HKListeningBookVC.h"
#import "SeriseCourseiPadCell.h"
#import "SeriseCourseiPadCell.h"


@interface HKSearchCourseVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HKBaseSearchTeacCellDelegate,HKDropMenuDelegate>

@property(nonatomic,strong)UICollectionView *contanerView;
/** 普通视频 */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** 系列课 */
@property(nonatomic,strong)NSMutableArray *seriseArr;
/** 讲师 */
//@property(nonatomic,strong)NSMutableArray *teacherArr;

@property(nonatomic,copy)NSString *keyWord;

@property(nonatomic,assign)NSInteger category; //区分搜索 讲师  课程

@property(nonatomic,assign)NSInteger pageSize; //分页数

@property(nonatomic,assign)NSInteger totalPage;//总页数

@property(nonatomic,strong)HKSearchCourseModel *coursemodel;
/**推荐第一页 数据 */
@property(nonatomic,strong)HKSearchCourseModel *recommendCourseModel;

@property(nonatomic,strong)NSMutableDictionary *tagDict;// 保存标签

@property(nonatomic,assign)NSInteger setCount;

@property(nonatomic,assign)NSUInteger selectIndex;//排序：0-默认 1-最新 2-最热

@property (nonatomic,strong)HKDropMenu *dropMenu;
/** 底部提示更换搜索词 View */
@property (nonatomic,strong)HKSearchCourseBottomView *courseBottomView;
/** 筛选标签 */
@property (nonatomic, strong)NSMutableArray<TagModel*> *filterArr;
/** 排序标签 */
@property (nonatomic, strong)NSMutableArray<TagModel*> *orderArr;

@end




@implementation HKSearchCourseVC


- (instancetype)initWithKeyWord:(NSString *)keyWord  category:(SearchResult)category {
    
    if (self = [super init]) {
        self.keyWord = keyWord;
        self.category = category;
        self.pageSize = 1;
        self.setCount = SetupCountOnce;
        
        if (category == SearchResultTeacher) {
            //self.emptyText = @"呀！没有找到课程呢~换个关键词试试";
        }else{
            self.emptyText = @"呀！没有找到课程呢~换个关键词试试";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self uMengEvent:self.category];
    
    if (self.category == SearchResultLiveCourse) {
        [MobClick event: searchpage_livetab];
    }else if (self.category == SearchResultReadBook){
        [MobClick event: searchpage_booktab];
    }
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)creatUI {
    
    if (self.category == SearchResultCourese) {
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
        self.view.backgroundColor = bgColor;
    }else{
        self.view.backgroundColor = COLOR_FFFFFF_333D48;
    }
    [self.view addSubview:self.contanerView];
    [self refreshUI];
    [self getVideoOrTeacherByWord:self.keyWord page:@"1" category:self.category];
    if (self.category == SearchResultSerise) {
        [self.contanerView setContentInset:UIEdgeInsetsMake(0, 10, kHeight40, 10)];
    }
//    if (self.category == SearchResultCourese && IS_IPAD) {
//    }
}


- (HKSearchCourseBottomView*)courseBottomView {
    
    if (!_courseBottomView) {
        _courseBottomView = [[HKSearchCourseBottomView alloc]init];
    }
    return _courseBottomView;
}


- (void)setupPullMenu {
    
    [self setMenuConfigWithArr:self.filterArr orderArr:self.orderArr];
}


- (HKDropMenu*)dropMenu {
    if (!_dropMenu) {
        _dropMenu = [[HKDropMenu alloc]initWithFrame:CGRectZero];
    }
    return _dropMenu;
}


- (void)setMenuConfigWithArr:(NSMutableArray <TagModel*> *)filterArr  orderArr:(NSMutableArray <TagModel*> *)orderArr {
    
    HKDropMenuModel *configuration = [[HKDropMenuModel alloc]init];
    configuration.recordSeleted = YES;
    configuration.originType = 1;
    //configuration.titles = [HKDropMenuModel searchMenuArray:filterArr sortArray:[self sortArray]];
    
    NSArray *array = nil;
    if (self.category == SearchResultAlbum) {
       array = @[@"默认排序",@"收藏人数",@"教程数量"];
    }
    else if (self.category == SearchResultTeacher) {
        array = @[@"课程数",@"学习数"];
    }
    for (int i = 0; i<array.count; i++) {
        TagModel *tagModel = [TagModel new];
        tagModel.value = [array by_ObjectAtIndex:i];
        tagModel.key = i;
        [orderArr addObject:tagModel];
    }
    
    configuration.titles = [HKDropMenuModel searchMenuArray:filterArr sortArray:orderArr];
    [self setUpDropMenuWithConfig:configuration];
}



#pragma mark - 设置 menu
- (void)setUpDropMenuWithConfig:(HKDropMenuModel*)configuration {
    
    HKDropMenu *dropMenu = [HKDropMenu creatDropMenuWithConfiguration:configuration frame:CGRectMake(0, 0,SCREEN_WIDTH, 44) dropMenuTitleBlock:^(HKDropMenuModel * _Nonnull dropMenuModel) {
        
    } dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
        
    }];
    dropMenu.titleViewBackGroundColor = COLOR_FFFFFF_3D4752;
    dropMenu.delegate = self;
    dropMenu.durationTime = 0.5;
    
    self.dropMenu = dropMenu;
    [self.view addSubview:dropMenu];
}



#pragma mark -  HKDropMenu  代理;
- (void)dropMenu:(HKDropMenu *)dropMenu dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel {
    
    self.selectIndex = dropMenuTitleModel.cellRow;
    [self searchSortByTag];
}


- (void)dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray {
    [self.tagDict removeAllObjects];
    for (int i = 0; i < tagArray.count; i++) {
        HKDropMenuModel *model = tagArray[i];
        [self.tagDict setObject:@(model.tagId) forKey:[NSString stringWithFormat:@"tag%d",i]];
    }
    [self searchSortByTag];
}


- (void)dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset {
    [self.tagDict removeAllObjects];
}


/** 设置 排序菜单列 名 */
//- (NSArray*)sortArray {
//    NSInteger type = self.category;
//    NSArray *array;
//    if (type == SearchResultCourese) {
//        array = @[@"最新",@"最热"];
//    }
//    else if (type == SearchResultSerise) {
//        array = @[@"最新",@"最热"];
//    }
//    else if (type == SearchResultTeacherOrganiza) {
//        array = @[@"默认排序",@"销量最高",@"价格最高",@"价格最低"];
//    }
//    else if (type == SearchResultAlbum) {
//        array = @[@"默认排序",@"收藏人数",@"教程数量",@"创建时间"];
//    }
//    else if (type == SearchResultTeacher) {
//        array = @[@"课程数",@"学习数"];
//    }
//    else if (type == SearchResultSoftware) {
//        //软件
//        array = @[@"课程数",@"学习数"];
//    }
//    else if (type == SearchResultArticle) {
//        //文章
//        array = @[@"课程数",@"学习数"];
//    }
//    else if (type == SearchResultLiveCourse) {
//        array = @[@"综合",@"最新",@"最热"];
//    }else if (type == SearchResultReadBook) {
//        array = @[@"最新",@"最热"];
//    }
//    return  array;
//}




- (UICollectionViewLayout*)layout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = IS_IPAD ? 0.0 : 0.5;
    layout.minimumInteritemSpacing = 0;
    return layout;
}



- (CGFloat)collectionY{
    
    CGFloat y = kHeight40;
    switch (self.category) {
        case SearchResultSoftware:
            y = 0;
            break;
    }
    return  y;
}



- (UICollectionView*)contanerView {
    
    if (!_contanerView) {
        _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [self collectionY], SCREEN_WIDTH, SCREEN_HEIGHT-kHeight49-kHeight40) collectionViewLayout:[self layout]];

        [_contanerView registerClass:[HKSearchAllInfoCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchAllInfoCell class])];
        [_contanerView registerClass:[HKSearchScrollCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchScrollCell class])];
        
        [_contanerView registerClass:[HKBaseSearchTeacCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKBaseSearchTeacCell class])];
        [_contanerView registerClass:[HKSearchCourseCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchCourseCell class])];
        [_contanerView registerNib:[UINib nibWithNibName:NSStringFromClass([SeriseCourseiPadCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SeriseCourseiPadCell class])];

        [_contanerView registerClass:[HKSearchPgcCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchPgcCell class])];
        
        [_contanerView registerClass:[HKSearchAlbumCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchAlbumCell class])];
        [_contanerView registerClass:[SeriseCourseCollectionCell class]  forCellWithReuseIdentifier:NSStringFromClass([SeriseCourseCollectionCell class])];
        [_contanerView registerNib:[UINib nibWithNibName:NSStringFromClass([SeriseCourseiPadCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SeriseCourseiPadCell class])];
        [_contanerView registerClass:[HKSearchSoftwareCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchSoftwareCell class])];
        
        [_contanerView registerClass:[HKSearchBaseSoftWareCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchBaseSoftWareCell class])];
        
        [_contanerView registerClass:[HKSearchArticleCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchArticleCell class])];
        
        [_contanerView registerClass:[HKSearchRecommendArticleCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchRecommendArticleCell class])];
        
        [_contanerView registerClass:[HKSearchRecommendAlbumCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKSearchRecommendAlbumCell class])];
        
        [_contanerView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSearchLiveCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKSearchLiveCell class])];
        
        [_contanerView registerClass:[HKSearchBookCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSearchBookCell class])];
        
        [_contanerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKSearchCourseVC"];

//        _contanerView.backgroundColor = (SearchResultCourese == self.category)? COLOR_F6F6F6 :[UIColor whiteColor];
        _contanerView.delegate = self;
        _contanerView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _contanerView);
        
        _contanerView.tb_EmptyDelegate = self;
        [_contanerView setContentInset:UIEdgeInsetsMake(0, 0, kHeight40, 0)];
        
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
//        _contanerView.backgroundColor = (SearchResultCourese == self.category)? bgColor :COLOR_FFFFFF_333D48;
        _contanerView.backgroundColor = COLOR_FFFFFF_3D4752;

    }
    return _contanerView;
}




- (void)showCourseBottomView {
    
    if (SearchResultCourese == self.category) {
        if (!self.courseBottomView.isShow) {
            [self.view addSubview:self.courseBottomView];
            self.courseBottomView.isShow = YES;
            [self.courseBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, IS_IPHONE_X? 60:50));
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.contanerView.mas_bottom).offset(IS_IPHONE_X ?-80 :-59);
            }];
        }
    }
}




#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 5*SCREEN_HEIGHT) {
        [self showCourseBottomView];
    }
}




#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.category == SearchResultCourese) {
        return 6;
    }else{
        return self.dataArr.count>0 ?1 :0;
    }
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.category == SearchResultCourese) {
        return [self numberOfItemsInSection:section];
    }else{
        return self.dataArr.count;
    }
}



-(NSInteger)numberOfItemsInSection:(NSInteger)section {

    NSInteger count = self.dataArr.count;// 普通视频数量
    NSInteger teacherCount = self.recommendCourseModel.teacher_match.is_show;
    NSInteger seriesCount = self.recommendCourseModel.series_list.is_show;
    
    NSInteger softwareCount = self.recommendCourseModel.software_match.is_show;
    
    NSInteger articleCount = self.recommendCourseModel.article_match.is_show;
    
    NSInteger albumCount = self.recommendCourseModel.album_match.is_show;
    
    switch (section) {
        case 0:
            return teacherCount ? 1 :0;
            break;
            
        case 1:
            return softwareCount? 1 :0;
            break;
            
        case 2:
            return seriesCount? 1 :0;
            break;
        case 3:
            return albumCount ? 1 :0;
            break;
        case 4:
            return articleCount ? 1 :0;;
            break;
        case 5:
            return count;
            break;
            
        default:
            return 0;
            break;
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.category == SearchResultCourese) {
        return [self coureseCellSize:indexPath.section];
    }else{
        return  [self collectionViewSizeWithType:self.category];
    }
}



- (CGSize)coureseCellSize:(NSInteger)section {
    
    switch (section) {
        case 0:
            return CGSizeMake(SCREEN_WIDTH, 120);
            break;
            
        case 1:
            return CGSizeMake(SCREEN_WIDTH, 127);
            break;
            
        case 2:
            return CGSizeMake(SCREEN_WIDTH, IS_IPAD ? 175 + 75 : 175 );
            break;
            
        case 3:
            return CGSizeMake(SCREEN_WIDTH, 322/2);
            break;
            
        case 4:
            return CGSizeMake(SCREEN_WIDTH, 150);
            break;
            
        case 5:
            
            if (IS_IPAD) {
                return CGSizeMake(SCREEN_WIDTH * 0.5 , 210 * iPadHRatio +55);
            }else{
                return CGSizeMake(SCREEN_WIDTH , 112+30);
            }
            
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}




- (CGSize)collectionViewSizeWithType:(SearchResult)type {
    
    CGSize size = CGSizeZero;
    switch (type) {
        case SearchResultTeacher:
            size = CGSizeMake(SCREEN_WIDTH, 90);
            break;
        case SearchResultCourese:
            break;
            
        case SearchResultSerise:{
            // 524 +16 +20 - 420
            //size = CGSizeMake(SCREEN_WIDTH, 210*Ratio +70);
            if (IS_IPAD) {
                size = CGSizeMake((SCREEN_WIDTH - 20) * 0.5, 210 * iPadHRatio +55);
            }else{
                size = CGSizeMake(SCREEN_WIDTH - 20, 210*Ratio +55);
            }
            break;
        }
            
        case SearchResultTeacherOrganiza:
            size = CGSizeMake(SCREEN_WIDTH, 120);
            break;
            
        case SearchResultAlbum:
            size = CGSizeMake(SCREEN_WIDTH, 120);
            break;
            
        case SearchResultSoftware:
            size = CGSizeMake(SCREEN_WIDTH, 100);
            break;
            
        case SearchResultArticle:
            size = CGSizeMake(SCREEN_WIDTH, 224/2);
            break;
            
        case SearchResultReadBook:
            size = CGSizeMake(SCREEN_WIDTH, 130);
            break;
            
        case SearchResultLiveCourse:
            size = CGSizeMake(SCREEN_WIDTH, 150);
            break;
    }
    return size;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    return  [self setCellWithType:self.category collectionView:collectionView cellForItemAtIndexPath:indexPath];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (SearchResultCourese == self.category) {
        //NSInteger seriesCount = self.seriseArr.count;
        //NSInteger teacherCount = self.teacherArr.count;
        //if (seriesCount>0 || teacherCount>0) {
            UICollectionReusableView *footer = nil;
            if (kind == UICollectionElementKindSectionFooter) {
                UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKSearchCourseVC" forIndexPath:indexPath];
                headView.backgroundColor = COLOR_F8F9FA_333D48;
                footer = headView;
                return footer;
            }
        //}
    }
    return [UICollectionReusableView new];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (self.category == SearchResultCourese) {
       return  [self coureseCellFootViewSize:section];
    }
    return CGSizeZero;
}


- (CGSize)coureseCellFootViewSize:(NSInteger)section {
    
    NSInteger teacherCount = self.recommendCourseModel.teacher_match.is_show;
    NSInteger seriesCount = self.recommendCourseModel.series_list.is_show;
    
    NSInteger softwareCount = self.recommendCourseModel.software_match.is_show;
    NSInteger articleCount = self.recommendCourseModel.article_match.is_show;
    NSInteger albumCount = self.recommendCourseModel.album_match.is_show;
    
    switch (section) {
        case 0:
            return CGSizeMake(SCREEN_WIDTH, teacherCount ?8 :0);
            break;
            
        case 1:
            return CGSizeMake(SCREEN_WIDTH, softwareCount ?8 :0);
            break;
            
        case 2:
            return CGSizeMake(SCREEN_WIDTH, seriesCount ?8 :0);
            break;
            
        case 3:
            return CGSizeMake(SCREEN_WIDTH, albumCount ?8 :0);
            break;
            
        case 4:
            return CGSizeMake(SCREEN_WIDTH, articleCount ?8 :0);
            break;
        default:
            return CGSizeZero;
            break;
    }
}


/** cell 赋值 */
- (UICollectionViewCell *)setCellWithType:(SearchResult)type  collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    if ( SearchResultCourese == type) {
        
        switch (indexPath.section) {
            case 0:
            {
                HKSearchAllInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchAllInfoCell class]) forIndexPath:indexPath];
                if (self.recommendCourseModel.teacher_match.first_match.count) {
                    cell.matchModel = self.recommendCourseModel.teacher_match.first_match[0];
                }
                cell.teacherMatchModel = self.recommendCourseModel.teacher_match;
                //self.coursemodel.teacher_list[indexPath.row];
                cell.delegate = self;
                // 嵌套cell的点击
                cell.homeMyFollowVideoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
                    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                                videoName:model.video_titel
                                                         placeholderImage:model.img_cover_url
                                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model searchkey:nil searchIdentify:nil];
                    [weakSelf pushToOtherController:VC];
                };
                
                cell.avatorClickBlock = ^{
                    [MobClick event:UM_RECORD_DETAIL_TEACHER];
                    [MobClick event:um_searchpage_videotab_teacher];
                    
                    //防止越界
                    if ((weakSelf.recommendCourseModel.teacher_match.first_match.count >= indexPath.row+1)) {
                        
                        HKFirstMatchModel * model = weakSelf.recommendCourseModel.teacher_match.first_match[0];
                        if (model.is_live == 1) {
                            [MobClick event:searchpage_all_teacher_live];
                            //进入直播详情页
                            HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
                            VC.course_id = model.live_catalog_small_id;
                            [weakSelf pushToOtherController:VC];
                        }else{
                            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                            vc.teacher_id = weakSelf.recommendCourseModel.teacher_match.first_match[indexPath.row].ID;
                            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                                
                                weakSelf.recommendCourseModel.teacher_match.first_match[indexPath.row].is_follow = is_follow;
                                //weakSelf.coursemodel.teacher_list[indexPath.row].is_follow = is_follow;
                                [weakSelf.contanerView reloadData];
                            };
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                    }
                };
                cell.moreBtnClickBackCall = ^{
                    [weakSelf.delegate switchTabIndex:5 model:nil];
                };
                return cell;
                
            }
                break;
                
            case 1:
            {
                HKSearchSoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchSoftwareCell class]) forIndexPath:indexPath];
                
                cell.moreBtnClickBackCall = ^{
                    [weakSelf.delegate switchTabIndex:2 model:nil];
                };
                cell.matchModel = self.recommendCourseModel.software_match;
               
                return cell;
            }
                break;
                
            case 2:
            {

                HKSearchScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchScrollCell class]) forIndexPath:indexPath];
                cell.seriesArr = self.seriseArr;
                cell.serieslistModel = self.recommendCourseModel.series_list;
                cell.searchScrollVideoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
                    //if (indexPath.row>=3) {
                      //  [weakSelf.delegate switchTabIndex:1 model:model];
                    //}else{
                        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                                    videoName:model.video_titel
                                                             placeholderImage:model.img_cover_url
                                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:model
                                                                    searchkey:nil searchIdentify:nil];
                        [weakSelf pushToOtherController:VC];
                    //}
                    [MobClick event:um_searchpage_videotab_series];
                };
                cell.moreBtnClickBackCall = ^{
                    [weakSelf.delegate switchTabIndex:1 model:nil];
                };
                return cell;
                
            }
                break;
                
            case 3:
            {
                HKSearchRecommendAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchRecommendAlbumCell class]) forIndexPath:indexPath];
                cell.matchModel = self.recommendCourseModel.album_match;
                return cell;
                
            }
                break;
                
            case 4:
            {
                HKSearchRecommendArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchRecommendArticleCell class]) forIndexPath:indexPath];
                cell.matchModel = self.recommendCourseModel.article_match;
                return cell;
            }
                break;
                
            case 5:
            {
                if (IS_IPAD) {
                    SeriseCourseiPadCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeriseCourseiPadCell class]) forIndexPath:indexPath];
                    cell.index = indexPath;
                    cell.model = self.dataArr[indexPath.row];
                    return cell;

                }else{
                    HKSearchCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchCourseCell class]) forIndexPath:indexPath];
                    cell.model = self.dataArr[indexPath.row];
                    return cell;
                }
            }
                break;
                
            default:
                return [UICollectionViewCell new];
                break;
        }
        
    }
    else if (SearchResultSerise == type ) {
        if (IS_IPAD) {
            SeriseCourseiPadCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeriseCourseiPadCell class]) forIndexPath:indexPath];
            cell.videoModel = self.dataArr[indexPath.row];
            return cell;
        }else{
            SeriseCourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeriseCourseCollectionCell class]) forIndexPath:indexPath];
//            cell.indexPath = indexPath;
            cell.videoModel = self.dataArr[indexPath.row];
            return cell;
        }
        
    }
    else if (SearchResultTeacherOrganiza == type  ) {
        
        HKSearchPgcCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchPgcCell class]) forIndexPath:indexPath];
        cell.searchVideoModel = self.dataArr[indexPath.row];
        return cell;
        
    }
    else if (SearchResultAlbum == type) {
        HKSearchAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchAlbumCell class]) forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
        
    }else if (SearchResultTeacher == type ){
        HKBaseSearchTeacCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKBaseSearchTeacCell class]) forIndexPath:indexPath];
        cell.userInfo = self.dataArr[indexPath.row];
        cell.delegate = self;
        
        cell.avatorClickBlock = ^{
            [MobClick event:UM_RECORD_DETAIL_TEACHER];
            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
            vc.teacher_id = weakSelf.coursemodel.teacher_list[indexPath.row].teacher_id;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                weakSelf.coursemodel.teacher_list[indexPath.row].is_follow = is_follow;
                [weakSelf.contanerView reloadData];
            };
            [weakSelf pushToOtherController:vc];
        };
        return cell;
    }else if (SearchResultSoftware == type ){
        
        HKSearchBaseSoftWareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchBaseSoftWareCell class]) forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
        
    }else if (SearchResultArticle == type ){
        HKSearchArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchArticleCell class]) forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    else if (type == SearchResultReadBook){
        
        HKSearchBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchBookCell class]) forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row];
        return cell;
        
//        HKSearchBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchBookCell class]) forIndexPath:indexPath];
//        cell.model = self.dataArr[indexPath.row];
//        return cell;
    }else if (type == SearchResultLiveCourse){
        HKSearchLiveCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSearchLiveCell class]) forIndexPath:indexPath];
        cell.videoModel = self.dataArr[indexPath.row];
        return cell;
    }
    else {
        return [UICollectionViewCell new];
    }
}





#pragma mark - HKBaseSearchTeacCell 代理
- (void)focusTeacher:(id)sender {
    if (SearchResultTeacher == self.category) {
        [MobClick event:UM_RECORD_SEARCH_PAGE_TEACHER_CONCERN];
    }
    isLogin() ? nil : [self setLoginVC];
}


#pragma mark <UICollectionViewLayouDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    WeakSelf;

    switch (self.category) {
        case SearchResultCourese:
        {
            switch (indexPath.section) {
                case 0:{
                    
                }
                    break;
                case 2:{
                    // 系列课
                    return ;
                }
                break;
                    
                case 1:{
                    // 软件
                    if (self.recommendCourseModel.software_match.first_match.count) {
                        NSString *videoId = self.recommendCourseModel.software_match.first_match[0].video_id;
                        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                                    videoName:nil
                                                             placeholderImage:nil
                                                                   lookStatus:LookStatusInternetVideo videoId:videoId model:nil
                                                                    searchkey:nil searchIdentify:nil];
                        [self pushToOtherController:VC];
                        [MobClick event:um_searchpage_videotab_software];
                    }
                }
                    break;
                case 3:{
                    //专辑
                    if (self.recommendCourseModel.album_match.first_match.count) {
                        HKAlbumModel *tempModel = [HKAlbumModel new];
                        tempModel.album_id = self.recommendCourseModel.album_match.first_match[0].ID;
                        HKAlbumDetailVC *VC = [[HKAlbumDetailVC alloc]initWithAlbumModel:tempModel isMyAblum:NO];
                        
                        [self pushToOtherController:VC];
                    }
                }
                    break;
                case 4:{
                    // 文章
                    if (self.recommendCourseModel.article_match.first_match.count) {
                        HKArticleModel *articleModel = [HKArticleModel new];
                        
                        articleModel.ID = self.recommendCourseModel.article_match.first_match[0].ID;
                        
                        HKArticleDetailVC *VC = [[HKArticleDetailVC alloc] init];
                        VC.model = articleModel;
                        [self pushToOtherController:VC];
                    }
                }
                    break;
                case 5:{
                    if (self.dataArr.count) {
                        VideoModel *model = self.dataArr[indexPath.row];
                        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                                    videoName:model.video_titel
                                                             placeholderImage:model.img_cover_url
                                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:model
                                                                    searchkey:self.recommendCourseModel.keyword searchIdentify:self.recommendCourseModel.identify];
                        [self pushToOtherController:VC];
                        [MobClick event:um_searchpage_videotab_video];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
        case SearchResultSerise: {
            VideoModel *model = self.dataArr[indexPath.row];
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                        videoName:model.video_titel
                                                 placeholderImage:model.img_cover_url
                                                       lookStatus:LookStatusInternetVideo videoId:model.video_id model:model
                                                        searchkey:nil searchIdentify:nil];
            [self pushToOtherController:VC];
            [MobClick event:um_searchpage_seriestab_click];
        }
            break;
            
        case SearchResultTeacherOrganiza:{
            VideoModel *model = self.dataArr[indexPath.row];
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                        videoName:model.video_titel
                                                 placeholderImage:model.img_cover_url
                                                       lookStatus:LookStatusInternetVideo videoId:model.video_id model:model
                                                        searchkey:nil searchIdentify:nil];
            if (SearchResultTeacherOrganiza == self.category){
                //PGC
                VC.videoType = HKVideoType_PGC;
            }
            [self pushToOtherController:VC];
        }
            break;
            
        case SearchResultAlbum: {
            // 专辑
            VideoModel *model = self.dataArr[indexPath.row];
            HKAlbumModel *tempModel = [HKAlbumModel new];
            tempModel.album_id = model.album_id;
            HKAlbumDetailVC *VC = [[HKAlbumDetailVC alloc]initWithAlbumModel:tempModel isMyAblum:NO];
            
            [self pushToOtherController:VC];
            [MobClick event:um_searchpage_albumtab_click];
        }
            break;
            
        case SearchResultTeacher:
        {
            if (0 == self.coursemodel.teacher_list.count) {
                return;
            }
            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
            vc.teacher_id = self.coursemodel.teacher_list[indexPath.row].teacher_id;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                weakSelf.coursemodel.teacher_list[indexPath.row].is_follow = is_follow;
                [weakSelf.contanerView reloadData];
            };
            [self pushToOtherController:vc];
            [MobClick event:um_searchpage_teachertab_click];
        }
            break;
            
        case SearchResultSoftware:{
            VideoModel *model = self.dataArr[indexPath.row];
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                        videoName:model.video_titel
                                                 placeholderImage:model.img_cover_url
                                                       lookStatus:LookStatusInternetVideo videoId:model.video_id model:model
                                                        searchkey:nil searchIdentify:nil];
            [self pushToOtherController:VC];
            [MobClick event:um_searchpage_softwaretab_click];
        }
            break;
            
        case SearchResultArticle:{
            
            HKArticleModel *articleModel = self.dataArr[[indexPath row]];
            HKArticleDetailVC *VC = [[HKArticleDetailVC alloc] init];
            VC.model = articleModel;
            [self pushToOtherController:VC];
            [MobClick event:um_searchpage_articletab_click];
        }
            break;
        case SearchResultReadBook:{
            
            HKBookModel * bookModel = self.dataArr[indexPath.row];
            HKListeningBookVC *bookVC = [HKListeningBookVC new];
            bookVC.courseId = bookModel.course_id;
            bookVC.bookId = bookModel.book_id;
            [weakSelf pushToOtherController:bookVC];
            [MobClick event:searchpage_booktab_book];
            
        }
            break;
        case SearchResultLiveCourse:{
            VideoModel * model = self.dataArr[indexPath.row];
            HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
            VC.course_id = model.live_small_catalog_id;
            [self pushToOtherController:VC];
            [MobClick event:searchpage_livetab_liveclass];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.contanerView completion:^{
        StrongSelf;
        strongSelf.pageSize = 1;
        [strongSelf getVideoOrTeacherByWord:strongSelf.keyWord page:@"1" category:strongSelf.category];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.contanerView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(strongSelf.pageSize == 1)? 2: strongSelf.pageSize];
        [strongSelf getVideoOrTeacherByWord:strongSelf.keyWord page:pageNum category:strongSelf.category];
    }];
    
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


- (void)searchSortByTag{
    self.pageSize = 1;
    [self getVideoOrTeacherByWord:self.keyWord page:@"1" category:self.category];
}



#pragma mark - 获取视频或者教师列表
- (void)getVideoOrTeacherByWord:(NSString*)word page:(NSString*)page category:(SearchResult)category {
    
    WeakSelf;
    NSString *url = nil;
    NSDictionary *parameters = nil;
    
    parameters = [self getParametersWithType:category page:page word:word];
    url = [self getUrlWithType:category];
    
    if ([page integerValue]>= 2 && (category == SearchResultCourese)) {
        // 推荐下拉URL
        url = SEARCH_VIDEO_PULL;
    }
    
    [HKHttpTool POST:url parameters:parameters success:^(id responseObject) {
        
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        
        if (HKReponseOK) {
            
            [strongSelf setModelWithType:category dict:responseObject page:page];
            
            if (strongSelf.setCount == SetupCountOnce) {
                if (SearchResultSoftware != category) { // 软件tab 无筛选
                    [strongSelf setupPullMenu];//创建排序 筛选导航
                }
                strongSelf.setCount = SetupCountSecond;
            }
            
            [strongSelf.contanerView reloadData];
            if ([page isEqualToString:@"1"] && strongSelf.dataArr.count>0) {
                //滚动到顶部
                if (strongSelf.contanerView.visibleCells.count) {
                    [strongSelf.contanerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                    atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                }
            }
        }else{
            [strongSelf tableFooterStopRefreshing];
        }

    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
        if (strongSelf.dataArr.count<1) {
            [strongSelf.contanerView reloadData];
        }
    }];
}



/**  设置 URL  */
- (NSString *)getUrlWithType:(SearchResult)type {
    
    NSString *url = nil;
    if (type == SearchResultCourese) {
        url = SEARCH_RECOMMEND;
    }
    else if (type == SearchResultSerise) {
        url = SEARCH_SERIES;
    }
    else if (type == SearchResultTeacherOrganiza) {
        url = SEARCH_PGC;
    }
    else if (type == SearchResultAlbum) {
        url = SEARCH_ALBUM;
    }
    else if (type == SearchResultTeacher) {
        url = SEARCH_TEACHER;
    }else if (SearchResultSoftware == type ){
        url = SEARCH_SOFTWARE;
    }else if (SearchResultArticle == type ){
        url = SEARCH_ARTICLE;
    }else if (SearchResultReadBook == type ){
        url = SEARCH_readBook;
    }else if (SearchResultLiveCourse == type ){
        url = SEARCH_Live;
    }
    return url;
}




/**  设置 参数  */
- (NSDictionary *)getParametersWithType:(SearchResult)type  page:(NSString*)page  word:(NSString*)word {
 
    NSDictionary *parameters = nil;
    NSString *tag = nil;
    if (self.tagDict.count) {
        tag = self.tagDict[[NSString stringWithFormat:@"tag0"]];
    }
    
    //tag = (isEmpty(tag)?@"0":tag);
    tag = (isEmpty(tag)?@"":tag);
    
    if (type == SearchResultTeacher) {
        NSString *selectIndex = [NSString stringWithFormat:@"%ld",self.selectIndex];
        // V2.11 以前
        //parameters = [NSDictionary dictionaryWithObjectsAndKeys:word,@"keyword",selectIndex,@"sort",tag,@"class_id",nil];
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:word,@"keyword",selectIndex,@"sort",tag,@"class_id", nil];
        
    }else{
        NSString *selectIndex = [NSString stringWithFormat:@"%ld",self.selectIndex];
        // V2.11 以前
        //parameters = [NSDictionary dictionaryWithObjectsAndKeys:word,@"keyword", page,@"page",selectIndex,@"sort",tag,@"class_id",nil];
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:word,@"keyword", page,@"page",selectIndex,@"sort",tag,@"class_id",nil];
    }
    
    return parameters;
}








/** json 解析 页数判断 */
- (void)setModelWithType:(SearchResult)type dict:(id)dict page:(NSString*)page {
    
    HKSearchCourseModel *model =[HKSearchCourseModel mj_objectWithKeyValues:[dict objectForKey:@"data"]];
    self.coursemodel = model;
    // 总的页数
    self.totalPage = [model.total_page intValue];
    if ([page isEqualToString:@"1"]) {
        self.recommendCourseModel = model;
        // 筛选 排序标签
        self.orderArr = model.order_list;
        self.filterArr = model.filter_list;
        
        if (type == SearchResultCourese) {
            self.dataArr = model.video_list.list;
            self.seriseArr = model.series_list.video_list;
        }
        else if (type == SearchResultSerise) {
            self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
        }
        else if (type == SearchResultTeacherOrganiza) {
            self.dataArr = model.course_list;
        }
        else if (type == SearchResultAlbum) {
            self.dataArr = model.album_list;
        }
        else if (type == SearchResultTeacher) {
            self.dataArr = model.teacher_list;
        }
        else if (type == SearchResultSoftware) {
            self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
        }
        else if (type == SearchResultArticle) {
            self.dataArr = [HKArticleModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
        }
        else if (type == SearchResultReadBook){
            self.dataArr = [HKBookModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
        }
        else if (type == SearchResultLiveCourse){
            self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
        }
        if (self.updateTitleCallBack && model.page_info.total_count) {
            self.updateTitleCallBack(model.page_info.total_count);
        }
    }else{
        
        if (type == SearchResultCourese) {
            [self.dataArr addObjectsFromArray: model.list];
        }
        else if (type == SearchResultSerise) {
            NSMutableArray *arr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray: arr];
        }
        else if (type == SearchResultTeacherOrganiza) {
            [self.dataArr addObjectsFromArray: model.course_list];
        }
        else if (type == SearchResultAlbum) {
            [self.dataArr addObjectsFromArray: model.album_list];
        }
        else if (type == SearchResultTeacher) {
            [self.dataArr addObjectsFromArray: model.teacher_list];
        }
        else if (type == SearchResultSoftware) {
            NSMutableArray *arr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
        }
        else if (type == SearchResultArticle) {
            NSMutableArray *arr = [HKArticleModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
        }
        else if (type == SearchResultReadBook){
            //self.dataArr = [HKBookModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            
            NSMutableArray *arr = [HKBookModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
        }
        else if (type == SearchResultLiveCourse){
            //self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            NSMutableArray *arr = [VideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
        }
        //self.pageSize++;
    }
    
//    if ([page intValue] >= self.totalPage) {
//        [self tableFooterEndRefreshing];
//    }else{
//        [self tableFooterStopRefreshing];
//    }
    
    //v2.11
    if (type == SearchResultAlbum) {
        if ([page intValue] >= self.totalPage) {
            [self tableFooterEndRefreshing];
        }else{
            [self tableFooterStopRefreshing];
        }
        
    }else if(type == SearchResultCourese) {
        if (1 == [page intValue]) {
            if ([page intValue] >= model.video_list.page_info.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
        }else{
            if ([page intValue] >= model.page_info.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
        }
    }else{
        
        if ([page intValue] >= model.page_info.page_total) {
            [self tableFooterEndRefreshing];
        }else{
            [self tableFooterStopRefreshing];
        }
    }
    
    self.pageSize++;
}







- (NSMutableArray*)seriseArr {
    if (!_seriseArr) {
        _seriseArr = [NSMutableArray array];
    }
    return _seriseArr;
}


- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableDictionary*)tagDict {
    if (!_tagDict) {
        _tagDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _tagDict;
}


- (NSMutableArray<TagModel*>*)filterArr {
    if (!_filterArr) {
        _filterArr = [NSMutableArray array];
    }
    return _filterArr;
}


- (NSMutableArray<TagModel*>*)orderArr {
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}



/** 友盟统计 */
- (void)uMengEvent:(SearchResult)type {
    
    if (type == SearchResultCourese) {
        [MobClick event:UM_RECORD_SEARCH_PAGE_VIDEO_TAB];
    }
    else if (type == SearchResultSerise) {
        [MobClick event:UM_RECORD_SEARCHPAGE_XILIEKETAB];
    }
    else if (type == SearchResultTeacherOrganiza) {
        [MobClick event:UM_RECORD_SEARCHPAGE_PGCTAB];
    }
    else if (type == SearchResultAlbum) {
        [MobClick event:UM_RECORD_SEARCHPAGE_ZHUANJITAB];
    }
    else if (type == SearchResultTeacher) {
        [MobClick event:UM_RECORD_SEARCH_PAGE_TEACHER_TAB];
    }else if (SearchResultSoftware == type ) {
        [MobClick event:um_searchpage_softwaretab];
    }else if (SearchResultArticle == type ){
        [MobClick event:um_searchpage_articletab];
    }
}





@end






