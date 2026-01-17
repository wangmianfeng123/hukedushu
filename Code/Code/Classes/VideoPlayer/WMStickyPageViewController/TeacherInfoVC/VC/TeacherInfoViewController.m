
//
//  TeacherInfoController.m
//  Demo
//
//  Created by Mark on 16/7/25.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//
// 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4-PGC 5-练习题 6-职业路径
#import "TeacherInfoViewController.h"
#import "TeacherInfoCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DetailModel.h"
#import "HKCourseDesCell.h"

#import "HKTeacherCourseVC.h"
#import "HKTeacherSuggestCourseCell.h"
#import "HKteacerSuggestCourseView.h"
#import "VideoPlayVC.h"
#import "TeacherInfoCollectionCell.h"
#import "HKPgcCourseInfoCell.h"
#import "HKPgcCourseHtmlCell.h"
#import "HKTeacherSoftwareInfoCell.h"
#import "HKTeacherCertificateInfoCell.h"
#import "HKTeacherSuggestTagCell.h"
#import "HKDesignCategoryVC.h"
#import "HKCategoryTreeModel.h"

@interface TeacherInfoViewController ()<TeacherInfoCellDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TeacherInfoCollectionCellDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, strong)UICollectionView *contanerView;

@property(nonatomic, strong)UITableView    *tableView;

@property(nonatomic, strong)NSMutableArray<VideoModel*> *suggestCourseArr;

@property(nonatomic, assign)float htmlCellHeigth;

@property(nonatomic, strong)DetailModel *detailModel;


@property (nonatomic , assign)CGFloat cellHeight ;
@property (nonatomic , assign) BOOL isUnfolded ;
@end

static NSString *const kTablewCellIdentifier = @"kTablewCellIdentifier";
static NSString *const kTablewCourseDesCellIdentifier = @"kTablewCourseDesCellIdentifier";

@implementation TeacherInfoViewController


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                          model:(DetailModel*)model
                         course:(HKCourseModel *)course {
    if(self = [super init]){
        self.detailModel = model;
        self.suggestCourseArr = model.recommend_video_list;
    }
    return self;
}



- (void)setTeacherInfoWithModel:(DetailModel*)model {
    self.detailModel = model;
}


- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
    self.suggestCourseArr = detailModel.recommend_video_list;
    [self layoutUI];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger tempType = [self.detailModel.video_type integerValue];
    
    if (HKVideoType_Series == tempType || HKVideoType_PGC == tempType  || HKVideoType_LearnPath == tempType) {
        [self setupTbe];
    }else{
        [self.view addSubview:self.contanerView];
        [self.contanerView reloadData];
    }
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}


- (void)layoutUI {
    NSInteger tempType = [self.detailModel.video_type integerValue];
    if (HKVideoType_Series == tempType || HKVideoType_PGC == tempType  || HKVideoType_LearnPath == tempType) {
        [self.tableView reloadData];
    }else{
        [self.contanerView reloadData];
    }
    [self.view layoutIfNeeded];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_VIDEO_DETAIL_TAB_DETAIL];
    //友盟页面路径统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //友盟页面路径统计
    [MobClick endLogPageView:NSStringFromClass([self class])];
}




- (NSMutableArray*)suggestCourseArr {
    if (!_suggestCourseArr) {
        _suggestCourseArr = [NSMutableArray array];
    }
    return _suggestCourseArr;
}

- (UICollectionViewLayout*)layout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}


- (UICollectionView*)contanerView {
    if (!_contanerView) {
        if (IS_IPAD) {
            _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(iPadContentMargin, 0, iPadContentWidth , SCREEN_HEIGHT - SCREEN_HEIGHT*0.5 -44) collectionViewLayout:[self layout]];

        }else{
            _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W , SCREEN_H - SCREEN_W*9/16 -44) collectionViewLayout:[self layout]];
        }
        [_contanerView registerClass:[TeacherInfoCollectionCell class]  forCellWithReuseIdentifier:NSStringFromClass([TeacherInfoCollectionCell class])];
        [_contanerView registerClass:[HKTeacherSuggestCourseCell class]  forCellWithReuseIdentifier:NSStringFromClass([HKTeacherSuggestCourseCell class])];
        [_contanerView registerClass:[HKteacerSuggestCourseView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKteacerSuggestCourseView"];

        [_contanerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        [_contanerView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTeacherSuggestTagCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKTeacherSuggestTagCell class])];
//        [_contanerView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseDesCell class]) bundle:nil]  forCellWithReuseIdentifier:NSStringFromClass([HKCourseDesCell class])];

        HKAdjustsScrollViewInsetNever(self, _contanerView);
        _contanerView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contanerView.delegate = self;
        _contanerView.dataSource = self;
        _contanerView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        
        self.cellHeight = 50;
        self.isUnfolded = NO;
    }
    return _contanerView;
}


#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (_suggestCourseArr.count>0) ? 3 :1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    }else{
        return _suggestCourseArr.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {    
    if (indexPath.section == 0) {
        return CGSizeMake(IS_IPAD ? iPadContentWidth : SCREEN_W, 90);
    } else if (indexPath.section == 1) {
        //return CGSizeMake(SCREEN_W, 180);
        if (self.detailModel.tags.count) {
            return CGSizeMake(IS_IPAD ? iPadContentWidth : SCREEN_W, self.cellHeight + 6);
        }else{
            return CGSizeMake(IS_IPAD ? iPadContentWidth : SCREEN_W, 0.01);
        }
    }else{
        CGFloat w = ((IS_IPAD ? iPadContentWidth : SCREEN_W) -28 -14)/2.0;
        CGFloat h = IS_IPAD ? w * 0.6 : 140;

        return CGSizeMake( w, h);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return UIEdgeInsetsMake(0, 14, 0, 14);
    }
    return UIEdgeInsetsZero;
}

//#pragma mark - Y间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//    if (section == 1) {
//        return 7;
//    }
//    return 0;
//}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (2==indexPath.section) {
//        UICollectionReusableView *header = nil;
//        if (kind == UICollectionElementKindSectionHeader){
//            HKteacerSuggestCourseView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKteacerSuggestCourseView" forIndexPath:indexPath];
//            header = headView;
//            return header;
//        }
//    }
    if (0 ==indexPath.section) {
        UICollectionReusableView *footer = nil;
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            headView.backgroundColor = COLOR_F8F9FA_333D48;
            footer = headView;
            return footer;
        }
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    NSInteger count = collectionView.numberOfSections;
    return ((0==section && count>1)) ? CGSizeMake(SCREEN_W, 7.5) : CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    if (0 == indexPath.section) {
        TeacherInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TeacherInfoCollectionCell class]) forIndexPath:indexPath];
        cell.userInfo = self.detailModel.teacher_info;
        cell.delegate = self;
        cell.avatorClickBlock = ^{
            [MobClick event:UM_RECORD_DETAIL_TEACHER];
            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
            vc.teacher_id = weakSelf.detailModel.teacher_info.teacher_id;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                weakSelf.detailModel.teacher_info.is_follow = is_follow;
                [weakSelf.contanerView reloadData];
            };
            [weakSelf pushToOtherController:vc];
        };
        return cell;
    }else if (indexPath.section ==1){
        HKTeacherSuggestTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKTeacherSuggestTagCell class]) forIndexPath:indexPath];
        cell.dataArray = self.detailModel.tags;
        cell.open = self.isUnfolded;
        WeakSelf
        cell.callBackData = ^(CGFloat h, BOOL isUnfolded) {
            weakSelf.cellHeight = h;
            weakSelf.isUnfolded = isUnfolded;
            [weakSelf.contanerView reloadData];
        };
        cell.didTagBlock = ^(HKcategoryChilderenModel * _Nonnull model) {
            HKDesignCategoryVC * VC = [[HKDesignCategoryVC alloc] init];
            VC.category = model.class_id;
            VC.defaultSelectedTag = model.tag1;
            [self pushToOtherController:VC];
            [MobClick event:detailpage_detailtab_tag];
        };
        return cell;
        
    }else{

        HKTeacherSuggestCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKTeacherSuggestCourseCell class]) forIndexPath:indexPath];
        cell.model = self.suggestCourseArr[indexPath.row];
        return cell;
    }
}


#pragma mark <UICollectionViewLayouDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (2 == indexPath.section) {
        [MobClick event:UM_RECORD_DETAIL_PAGE_RECOMMEND];
        VideoModel *model = self.suggestCourseArr[indexPath.row];
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                    videoName:model.video_titel
                                             placeholderImage:model.img_cover_url
                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark - TeacherInfoCollectionCell 代理
- (void)CollectionCellFocusTeacher:(id)sender {
    isLogin() ? nil : [self setLoginVC];
}



















/******************* 系列课 ***********************/

/** 空视图 代理 */
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    NSInteger tempType = [self.detailModel.video_type integerValue];

    BOOL show = NO;
    if ((tempType == HKVideoType_Series || tempType == HKVideoType_PGC || tempType == HKVideoType_LearnPath) && scrollView == self.tableView) {
        show = YES;
    } else if (scrollView == self.contanerView) {
        show = YES;
    }
    return show;
}


- (UITableView*)tableView {

    if (!_tableView) {
        if (IS_IPAD) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(iPadContentMargin, 0, iPadContentWidth, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.5 -44)
                                                     style:UITableViewStyleGrouped];
            _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPadContentWidth, CGFLOAT_MIN)];

        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - SCREEN_W*9/16 -44)
                                                     style:UITableViewStyleGrouped];
            _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, CGFLOAT_MIN)];

        }
        
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;
        
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, CGFLOAT_MIN)];

        [_tableView registerClass:[TeacherInfoCell class] forCellReuseIdentifier:kTablewCellIdentifier];
        [_tableView registerClass:[HKPgcCourseInfoCell class] forCellReuseIdentifier:NSStringFromClass([HKPgcCourseInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseDesCell class]) bundle:nil] forCellReuseIdentifier:kTablewCourseDesCellIdentifier];
        [_tableView registerClass:[HKTeacherSoftwareInfoCell class] forCellReuseIdentifier:NSStringFromClass([HKTeacherSoftwareInfoCell class])];
        
        [_tableView registerClass:[HKTeacherCertificateInfoCell class]  forCellReuseIdentifier:NSStringFromClass([HKTeacherCertificateInfoCell class])];

        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _tableView.frame = self.view.bounds;
    if (IS_IPAD) {
        _tableView.frame = CGRectMake(iPadContentMargin, 0, iPadContentWidth, SCREEN_HEIGHT - SCREEN_HEIGHT * 0.5 -44);
    }else{
        _tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - SCREEN_W*9/16 -44);
    }
}


- (void)setupTbe {
    
    [self.view addSubview:self.tableView];
    BOOL isBuy = [self.detailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
    if ([self.detailModel.video_type integerValue] == HKVideoType_PGC && isBuy) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger tempType = [self.detailModel.video_type integerValue];
    if ( HKVideoType_Series == tempType  ||  HKVideoType_PGC == tempType) {
        return 1;
    }
    if (HKVideoType_LearnPath == tempType) {
        return 3;
    }
    return 0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 只有系列课才有教程简介
    NSInteger type = [self.detailModel.video_type integerValue];
    if (type == 1) {
        if (1 == section) {
            return (self.detailModel.obtain_info.app_obtain.count >0) ? 1 :0;
        }
        return 1; //软件入门
    }else if (type == 2) {
        return 2; //系列课
    }else if (type == 4){
        return 3; //pgc
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    @weakify(self);
    NSInteger type = [self.detailModel.video_type integerValue];
    NSInteger row = indexPath.row;
    CGFloat height = 0;
    
    if (type == 1) {
        // 软件入门
        switch (indexPath.section) {
            case 0:
            {
                height = [tableView fd_heightForCellWithIdentifier:kTablewCellIdentifier configuration:^(TeacherInfoCell *cell) {
                    @strongify(self);
                    [self configureCell:cell atIndexPath:[indexPath row] model:self.detailModel.teacher_info];
                }];
            }
                break;
                
            case 1: {
                
                height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HKTeacherCertificateInfoCell class]) configuration:^(id cell) {
                    @strongify(self);
                    [self configureHKTeacherCertificateInfoCell:(HKTeacherCertificateInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];
                }];
            }
                break;
                
            case 2:{
                // 软件入门
                height = [tableView fd_heightForCellWithIdentifier:@"HKTeacherSoftwareInfoCell" configuration:^(id cell) {
                    @strongify(self);
                    [self configureHKTeacherSoftwareInfoCell:(HKTeacherSoftwareInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];
                }];
            }
                break;
                
            default:
                break;
        }
        return height;
    }
    
    if (0 == row) {
        
        height = [tableView fd_heightForCellWithIdentifier:kTablewCellIdentifier
                                             configuration:^(TeacherInfoCell *cell) {
            @strongify(self);
            [self configureCell:cell atIndexPath:[indexPath row] model:self.detailModel.teacher_info];
        }];
        
    }else if(1 == row){
        if (4 == type){ //PGC
            height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HKPgcCourseInfoCell class]) configuration:^(id cell) {
                @strongify(self);
                [self configureHKPgcCourseInfoCell:cell atIndexPath:[indexPath row] model:self.detailModel];
            }];
        }else if(1 == type) {
            // 软件入门
            height = [tableView fd_heightForCellWithIdentifier:@"HKTeacherSoftwareInfoCell" configuration:^(id cell) {
                @strongify(self);
                [self configureHKTeacherSoftwareInfoCell:(HKTeacherSoftwareInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];
            }];

        }else if(2 == type) {
            // 系列课
            height = [tableView fd_heightForCellWithIdentifier:kTablewCourseDesCellIdentifier configuration:^(HKCourseDesCell *cell) {
                @strongify(self);
                [self configureCourseDesCell:cell atIndexPath:indexPath.row model:self.detailModel];
            }];
        }
    }else {
        height = self.htmlCellHeigth;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    NSInteger type = [self.detailModel.video_type integerValue];
    UITableViewCell *cell = nil;
    
    if (type == 1) {
        // 软件入门
        switch (indexPath.section) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:kTablewCellIdentifier];
                if (!cell) {
                    cell = [[TeacherInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kTablewCellIdentifier];
                }
                [self configureCell:(TeacherInfoCell *)cell atIndexPath:[indexPath row] model:self.detailModel.teacher_info];
                ((TeacherInfoCell *)cell).avatorClickBlock = ^{
                    @strongify(self);
                    [MobClick event:UM_RECORD_DETAIL_TEACHER];
                    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                    vc.teacher_id = self.detailModel.teacher_info.teacher_id;
                    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                        self.detailModel.teacher_info.is_follow = is_follow;
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [self pushToOtherController:vc];
                };
            }
                break;
                
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTeacherCertificateInfoCell class])];
                [self configureHKTeacherCertificateInfoCell:(HKTeacherCertificateInfoCell *)cell atIndexPath:[indexPath row] model:self.detailModel];
            }
                break;
                
            case 2:{
                // 软件入门
                cell = [HKTeacherSoftwareInfoCell initCellWithTableView:tableView];
                [self configureHKTeacherSoftwareInfoCell:(HKTeacherSoftwareInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    
    
    if (indexPath.row == 0) {// 教师资料
        cell = [tableView dequeueReusableCellWithIdentifier:kTablewCellIdentifier];
        if (!cell) {
            cell = [[TeacherInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kTablewCellIdentifier];
        }
        [self configureCell:(TeacherInfoCell *)cell atIndexPath:[indexPath row] model:self.detailModel.teacher_info];
        ((TeacherInfoCell *)cell).avatorClickBlock = ^{
            @strongify(self);
            [MobClick event:UM_RECORD_DETAIL_TEACHER];
            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
            vc.teacher_id = self.detailModel.teacher_info.teacher_id;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                self.detailModel.teacher_info.is_follow = is_follow;
                [self.tableView reloadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };

    }else if (indexPath.row == 1) {
        // 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4--PGC 课

        if (type == 4){ //PGC
            cell = [HKPgcCourseInfoCell initCellWithTableView:tableView];
            [self configureHKPgcCourseInfoCell:(HKPgcCourseInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];
        }else if(type == 1) {

            cell = [HKTeacherSoftwareInfoCell initCellWithTableView:tableView];
            [self configureHKTeacherSoftwareInfoCell:(HKTeacherSoftwareInfoCell*)cell atIndexPath:[indexPath row] model:self.detailModel];

        }else if(type == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:kTablewCourseDesCellIdentifier];
            [self configureCourseDesCell:((HKCourseDesCell *)cell) atIndexPath:indexPath.row model:self.detailModel];
            ((HKCourseDesCell *)cell).videoDetailModel = self.detailModel;

        }
    }else{

        HKPgcCourseHtmlCell *pgcCell = [HKPgcCourseHtmlCell initCellWithTableView:tableView detailModel:self.detailModel];
        pgcCell.htmlHeightBlock = ^(float height) {
            @strongify(self);
            if(height > 0){
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.htmlCellHeigth = height;
            }
        };
        cell = pgcCell;
    }

    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 判断webView所在的cell是否可见，如果可见就layout
    NSArray *cells = self.tableView.visibleCells;
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[HKPgcCourseHtmlCell class]]) {
            HKPgcCourseHtmlCell *webCell = (HKPgcCourseHtmlCell *)cell;
            [webCell.webView setNeedsLayout];
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 给Cell赋值 用于计算cell的高度
/** 讲师介绍 */
- (void)configureCell:(TeacherInfoCell *)cell atIndexPath:(NSInteger)indexPath  model:(HKUserModel *)model {
    cell.delegate = self;
    cell.userInfo = model;
}

/** 系列课 课程 详情 */
- (void)configureCourseDesCell:(HKCourseDesCell *)cell atIndexPath:(NSInteger)indexPath  model:(DetailModel *)model {

    cell.fd_enforceFrameLayout = YES;//ios 10.2 需设置 creash
    cell.videoDetailModel = model;
}

/** PGC 课程 详情 */
- (void)configureHKPgcCourseInfoCell:(HKPgcCourseInfoCell *)cell atIndexPath:(NSInteger)indexPath  model:(id)model {
    //cell.coursrInfo = model;
    cell.model = model;
}

/** 软件 入门 课程 详情 */
- (void)configureHKTeacherSoftwareInfoCell:(HKTeacherSoftwareInfoCell *)cell atIndexPath:(NSInteger)indexPath  model:(id)model {
    cell.videoDetailModel = model;
}


/** 软件 入门证书 */
- (void)configureHKTeacherCertificateInfoCell:(HKTeacherCertificateInfoCell *)cell atIndexPath:(NSInteger)indexPath  model:(id)model {
    cell.model = model;
}

#pragma mark - TeacherInfoCell 代理
- (void)focusTeacher:(id)sender {
    isLogin() ? nil : [self setLoginVC];
}




@end




