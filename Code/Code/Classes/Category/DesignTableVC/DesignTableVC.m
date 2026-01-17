
//
//  HkDesignTableVC.m
//  Code
//
//  Created by Ivan li on 2019/8/1.
//  Copyright © 2019 pg. All rights reserved.
//

#import "DesignTableVC.h"
#import "HKSearchCourseVC.h"
#import "HKSoftwareVipCell.h"
#import "HKSoftwareNewOnlineVC.h"
#import "HKSoftwareGrayView.h"
#import "UIBarButtonItem+Extension.h"
#import "VideoPlayVC.h"
#import "WMPageController+Category.h"
#import "NSString+MD5.h"
#import "HKDropMenu.h"
#import "HKDropMenuModel.h"
#import "HkDesignTableDropMenu.h"
#import "HkDesignJobPathCell.h"
#import "DesignTableChlidrenVC.h"
#import "VideoServiceMediator.h"
#import "HKJobPathModel.h"
#import "HKJobPathCourseVC.h"
#import "HKDesignTypeModel.h"

#import "HKVIPCategoryVC.h"
#import "ZWMGuideView.h"


@interface DesignTableVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HkDesignTableDropMenuDelegate,DesignTableChlidrenVCDelegate,ZWMGuideViewDataSource,ZWMGuideViewLayoutDelegate>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property (nonatomic,assign)BOOL isFisrt;

@property (nonatomic,strong) UIButton *retryBtn;

@property (nonatomic,strong)HkDesignTableDropMenu *designTableDropMenu;


@property (nonatomic,weak)DesignTableChlidrenVC *designTableVC;
/// 职业路径
@property (nonatomic,strong)NSMutableArray *jobArr;

@property (nonatomic,strong)NSMutableArray *videoArr;
@property (strong, nonatomic) ZWMGuideView *guideView;

@end


@implementation DesignTableVC


- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       category:(NSString*)category
                           name:(NSString*)name {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.category = category;
        self.name = name;
    }
    return self;
}

-(void)setTypeModel:(HKDesignTypeModel *)typeModel{
    _typeModel = typeModel;
    self.title = typeModel.name;
    self.category = [NSString stringWithFormat:@"%@",typeModel.class_id];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    
}

- (void)createUI {
    
    [self setLeftBarButtonItem];
    self.hk_hideNavBarShadowImage = YES;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}



/*************************  UICollectionView **************************/

- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, kWMHeaderViewHeight);
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kWMHeaderViewHeight);
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        
        [_contentCollectionView registerClass:[HkDesignJobPathCell class] forCellWithReuseIdentifier:NSStringFromClass([HkDesignJobPathCell class])];
        HKAdjustsScrollViewInsetNever(self, _contentCollectionView);
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    HkDesignJobPathCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HkDesignJobPathCell class]) forIndexPath:indexPath];
    cell.videoSelectedBlock = ^(NSIndexPath *indexPath, HKJobPathModel *jobPathModel) {

        @strongify(self);
        if (isEmpty(jobPathModel.career_type)) {
            // 职业路径
            HKJobPathCourseVC *VC = [HKJobPathCourseVC new];
            [VC setJobPathModel:jobPathModel];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            [MobClick event:UM_RECORD_LIST_RECOMMOND_CARRERPATH];
        }else{
            // c4d
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:jobPathModel.video_title placeholderImage:jobPathModel.cover lookStatus:LookStatusInternetVideo videoId:jobPathModel.video_id model:nil];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            [MobClick event:UM_RECORD_LIST_RECOMMOND_SOFTWARE];
        }
    };
    cell.didVipBlock = ^{
        HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
        //VC.class_type = self.classType;
        [self.navigationController pushViewController:VC animated:YES];
    };
    cell.seriesArr = self.jobArr;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [UICollectionReusableView new];
}

/*************************  UICollectionView **************************/



/*************************  UIViewController **************************/
static CGFloat const kWMMenuViewHeight = 40 * 2+10;
//static CGFloat const kWMHeaderViewHeight = 162+20;
static CGFloat const kWMHeaderViewHeight = 140;

- (void)prepareSetup {
    
    self.controllerType = WMStickyPageControllerType_ordinary;
    
    self.menuItemWidth = self.view.width;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuViewHeight = kWMMenuViewHeight;
    self.maximumHeaderViewHeight = self.jobArr.count ?kWMHeaderViewHeight : 0;
    self.minimumHeaderViewHeight = 0;
    [self reloadData];
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"showCategoryGuidView"];
    if (!show) {
        [self.guideView show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showCategoryGuidView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


#pragma mark - 重置 高度
- (void)reSetHeaderViewHeight {
    self.maximumHeaderViewHeight = self.jobArr.count ?kWMHeaderViewHeight : 0;
    self.minimumHeaderViewHeight = 0;
}


- (NSMutableArray*)jobArr {
    if (!_jobArr) {
        _jobArr = [NSMutableArray array];
    }
    return _jobArr;
}

- (NSMutableArray*)videoArr {
    if (!_videoArr) {
        _videoArr = [NSMutableArray array];
    }
    return _videoArr;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    // 设置VC
    
    @weakify(self);
    if (_viewcontrollers == nil) {
        DesignTableChlidrenVC *VC = [[DesignTableChlidrenVC alloc]initWithNibName:nil bundle:nil category:self.category name:self.name];
        VC.delegate = self;
        VC.videoCountCallBack = ^(NSInteger videoCount) {
            @strongify(self);
            [self.designTableDropMenu setVideoCount:videoCount];
        };
        
        VC.defaultSelectedTag = self.defaultSelectedTag;
        _viewcontrollers = @[VC];
        self.designTableVC = VC;
    }
    return _viewcontrollers;
}


#pragma mark - DesignTableChlidrenVCDelegate
- (void)designTableChlidren:(DesignTableChlidrenVC*_Nullable)vc jobArr:(NSMutableArray*_Nullable)jobArr  videoArr:(NSMutableArray*_Nullable)videoArr  c4dArr:(NSMutableArray*_Nonnull)c4dArr title:(NSString*_Nonnull)title {
    
    self.title = title;
    if (0 == self.jobArr.count) {
        self.jobArr = jobArr;
    }
    self.videoArr = videoArr;
    
    if (!self.isFisrt) {
        self.isFisrt = YES;
        [self.view addSubview:self.contentCollectionView];
        [self prepareSetup];
    }
    [self reSetHeaderViewHeight];
    [self.contentCollectionView reloadData];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return self.viewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    //pageController.menuView.backgroundColor = COLOR_ffffff;
    [pageController.menuView addSubview:self.designTableDropMenu];
    
    
    
    

    return CGRectMake(0, self.maximumHeaderViewHeight+kWMMenuViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return nil;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, self.maximumHeaderViewHeight, SCREEN_WIDTH, kWMMenuViewHeight);
}


/*************************  UIViewController **************************/


#pragma mark - 刷新
- (void)refreshUI {

}


- (void)tableHeaderEndRefreshing {
    [_contentCollectionView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_contentCollectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_contentCollectionView.mj_footer endRefreshing];
}


- (void)showOrHiddenRetryBtn:(BOOL)showOrHidden {
    self.retryBtn.hidden = !showOrHidden;
}



- (UIButton*)retryBtn {
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryBtn.titleLabel.font = HK_FONT_SYSTEM(16);
        
        [_retryBtn setTitle:@"重试" forState:UIControlStateNormal];
        [_retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置背景
        [_retryBtn setBackgroundImage:[UIImage imageNamed:@"general_btn_bg"] forState:UIControlStateNormal];
        [_retryBtn sizeToFit];
        _retryBtn.hidden = YES;
        [self.view addSubview:_retryBtn];
        _retryBtn.center = self.view.center;
    }
    return _retryBtn;
}


- (void)retryBtnClick:(UIButton*)btn {
    [self.designTableVC refreshUI ];
}



- (HkDesignTableDropMenu*)designTableDropMenu {
    
    if (!_designTableDropMenu) {
        _designTableDropMenu = [[HkDesignTableDropMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWMMenuViewHeight)];
        _designTableDropMenu.delegate = self;
        _designTableDropMenu.categoryId = self.category;
        _designTableDropMenu.defaultTag = self.defaultSelectedTag;
        [_designTableDropMenu createUI];
    }
    return _designTableDropMenu;
}


//下拉菜单选中排序。。。
- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu
                 selectIndex:(NSInteger)selectIndex
          dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel {
    
    if (!self.designTableVC) {
        return;
    }
    [self.designTableVC dropMenu:dropMenu dropMenuTitleModel:dropMenuTitleModel];
}

//筛选菜单确定按钮
- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray {
    if (!self.designTableVC) {
        return;
    }
    [self.designTableVC dropMenu:dropMenu tagArray:tagArray];
}
/** 重置筛选 */
- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset {
    if (!self.designTableVC) {
        return;
    }
    [self.designTableVC dropMenu:dropMenu reset:reset];
}

- (void)categoryReusableView:(HkDesignTableDropMenu*)categoryReusableView
                    dropMenu:(HKDropMenu *)dropMenu itemIndex:(NSInteger)itemIndex {
    if (!self.designTableVC) {
        return;
    }
    [self setContentViewContentOffset:self.maximumHeaderViewHeight];
}


-(void)categoryReusableView:(HkDesignTableDropMenu *)categoryReusableView dropMenu:(HKDropMenu *)dropMenu withParam:(HKFiltrateModel *)model{
    [self.designTableVC dropMenu:dropMenu withParam:model];
}

- (ZWMGuideView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[ZWMGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _guideView.dataSource = self;
        _guideView.delegate = self;
    }
    return _guideView;
}


#pragma mark -- ZWMGuideViewDataSource（必须实现的数据源方法）
- (NSInteger)numberOfItemsInGuideMaskView:(ZWMGuideView *)guideMaskView{
    return 1;

}
- (UIView *)guideMaskView:(ZWMGuideView *)guideMaskView viewForItemAtIndex:(NSInteger)index{
    return self.menuView;

}
- (NSString *)guideMaskView:(ZWMGuideView *)guideMaskView descriptionLabelForItemAtIndex:(NSInteger)index{
    return @"新增筛选栏，快速找到目标课程！";
}

#pragma mark -- ZWMGuideViewLayoutDelegate
- (CGFloat)guideMaskView:(ZWMGuideView *)guideMaskView cornerRadiusForItemAtIndex:(NSInteger)index
{
    return 8;
}
- (UIEdgeInsets)guideMaskView:(ZWMGuideView *)guideMaskView insetsForItemAtIndex:(NSInteger)index{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
@end

