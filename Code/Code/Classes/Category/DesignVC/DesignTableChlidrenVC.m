//
//  DesignTableVC.m
//  Code
//
//  Created by Ivan li on 2017/8/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "DesignTableChlidrenVC.h"
#import "FWNetWorkServiceMediator.h"

#import "VideoPlayVC.h"
#import "HomeVideoCollectionCell.h"

#import "VideoServiceMediator.h"
#import "TagModel.h"
#import "HKDropMenu.h"
#import "HKDropMenuModel.h"
#import "HKJobPathModel.h"
#import "HKDesignListCell.h"

@interface DesignTableChlidrenVC ()<TBSrollViewEmptyDelegate, UICollectionViewDelegate, UICollectionViewDataSource>//HKDropMenuDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *category;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)UICollectionView    *collectionView;

@property(nonatomic,copy)NSString  *videoCount; //记录筛选视频数

@property(nonatomic,strong)NSMutableDictionary *tagDict;// 保存标签

@property(nonatomic,assign)NSUInteger selectIndex;// 保存排序 index
@property (nonatomic , assign) NSInteger itemIndex ;//用于进阶，系列课，图文教程筛选
@property(nonatomic,strong)HKDropMenu *dropMenu;

@property(nonatomic,assign)NSInteger page;

@end


@implementation DesignTableChlidrenVC


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                       category:(NSString*)category name:(NSString*)name {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.category = category;
        self.name = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.emptyText = @"呀！没有找到课程呢~";
    self.selectIndex = 2;
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableDictionary*)tagDict {
    if (!_tagDict) {
        _tagDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _tagDict;
}


- (HKDropMenu*)dropMenu {
    if (!_dropMenu) {
        _dropMenu = [[HKDropMenu alloc]initWithFrame:CGRectZero];
    }
    return _dropMenu;
}


- (void)setVideoCount:(NSString *)videoCount {
    _videoCount = videoCount;
    NSString *title = [NSString stringWithFormat:@"%@个教程",isEmpty(videoCount) ?@"0" :videoCount];
    //[self.dropMenu resetFirstMenuTitleWithTitle:title];

    if (self.videoCountCallBack) {
        self.videoCountCallBack([videoCount integerValue]);
    }
}


- (void)creatUI {
    
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.title = self.name;
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self refreshUI];
    //[self setMenuConfigWithArr:nil videoCount:self.videoCount];
}



- (void)setMenuConfigWithArr:(NSMutableArray <TagModel*> *)tagArr  videoCount:(NSString*)videoCount {
    
    HKDropMenuModel *configuration = [[HKDropMenuModel alloc]init];
    configuration.recordSeleted = YES;
    
    configuration.defaultSelectedTag = self.defaultSelectedTag;
    configuration.categoryId = self.category;
    
    configuration.filterClickType = HKDropMenuFilterCellClickTypeQuit;
    
    configuration.titles = [HKDropMenuModel normalMenuArray:tagArr videoCount:[videoCount integerValue]];
    [self setUpDropMenuWithConfig:configuration];
}



#pragma mark - 设置 menu
- (void)setUpDropMenuWithConfig:(HKDropMenuModel*)configuration {
    
//    HKDropMenu *dropMenu = [HKDropMenu creatDropMenuWithConfiguration:configuration frame:CGRectMake(0, KNavBarHeight64,SCREEN_WIDTH, 40) dropMenuTitleBlock:^(HKDropMenuModel * _Nonnull dropMenuModel) {
//        
//    } dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
//        
//    }];
//    dropMenu.delegate = self;
//    dropMenu.durationTime = 0.5;
//    
//    self.dropMenu = dropMenu;
//    [self.view addSubview:dropMenu];
}



#pragma mark -  HKDropMenu  代理;
- (void)dropMenu:(HKDropMenu *)dropMenu dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel {
    if (dropMenuTitleModel.tagId == 0) {
        self.selectIndex = dropMenuTitleModel.cellRow +1;
        [self sortVideoByPage:@"1"];
        [self umRecorded:dropMenuTitleModel.cellRow];
    }else{//内容或者场景
        if (dropMenuTitleModel.cellSeleted == NO) {
            [self.tagDict removeObjectForKey:dropMenuTitleModel.key];
            [self sortVideoByPage:@"1"];
        }else{
            if (dropMenuTitleModel.key.length) {
                NSString *tagId = [NSString stringWithFormat:@"%ld",(long)dropMenuTitleModel.tagId];
                NSString *key = dropMenuTitleModel.key;
                [self.tagDict setObject:tagId forKey:key];
                [self sortVideoByPage:@"1"];
            }
        }
    }
    
}

//筛选菜单确定按钮
- (void)dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray {
    
    [self.tagDict removeAllObjects];
    for (int i = 0; i < tagArray.count; i++) {
        HKDropMenuModel *model = tagArray[i];
        NSString *tagId = [NSString stringWithFormat:@"%ld",(long)model.tagId];
        NSString *key = model.key;
        if (tagId.length && key.length) {
            [self.tagDict setObject:tagId forKey:key];
        }else{
            if (model.level >= 3) {
                [self.tagDict setObject:tagId forKey:@"video_tag_id"];
            }
        }
            
    }
    [self sortVideoByPage:@"1"];
}


/** 重置筛选 */
- (void)dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset {
    [self.tagDict removeAllObjects];
    self.defaultSelectedTag = nil;
}

//- (void)dropMenu:(HKDropMenu *)dropMenu withParam:(HKFiltrateModel *)model{
//    if (self.tagDict.count) {
//        if (model.not_easy.length) {
//            [self.tagDict setValue:@"1" forKey:@"not_easy"];
//        }else{
//            [self.tagDict removeObjectForKey:@"not_easy"];
//        }
//        
//        if (model.split_group.length) {
//            [self.tagDict setValue:@"1" forKey:@"split_group"];
//        }else{
//            [self.tagDict removeObjectForKey:@"split_group"];
//        }
//        
//        if (model.has_pictext.length) {
//            [self.tagDict setValue:@"1" forKey:@"has_pictext"];
//        }else{
//            [self.tagDict removeObjectForKey:@"has_pictext"];
//        }
//        
//        [self filterVideoListWithClassName:self.category sort:[NSString stringWithFormat:@"%lu",(unsigned long)self.selectIndex] page:@"1" tags:self.tagDict itemIndex:self.itemIndex];
//    }else{
//        if (model.not_easy.length) {
//            [self.tagDict setValue:@"1" forKey:@"not_easy"];
//        }else{
//            [self.tagDict removeObjectForKey:@"not_easy"];
//        }
//        if (model.split_group.length) {
//            [self.tagDict setValue:@"1" forKey:@"split_group"];
//        }else{
//            [self.tagDict removeObjectForKey:@"split_group"];
//        }
//        if (model.has_pictext.length) {
//            [self.tagDict setValue:@"1" forKey:@"has_pictext"];
//        }else{
//            [self.tagDict removeObjectForKey:@"has_pictext"];
//        }
//        [self filterVideoListWithClassName:self.category sort:[NSString stringWithFormat:@"%lu",(unsigned long)self.selectIndex] page:@"1" tags:self.tagDict itemIndex:self.itemIndex];
//    }
//}


#pragma mark - 友盟统计
- (void)umRecorded:(NSUInteger)btnIndex {
    
    switch (btnIndex) {
        case 0:
            [MobClick event:UM_RECORD_LIST_DEFAULT_SORT];
            break;
        case 1:
            [MobClick event:UM_RECORD_LIST_NEW_SORT];
            break;
        case 2:
            [MobClick event:UM_RECORD_LIST_HOT_SORT];
            
        case 3:
            [MobClick event:UM_RECORD_LIST_HARD_SORT];
            
        case 4:
            [MobClick event:UM_RECORD_LIST_EASY_SORT];
            break;
    }
}



#pragma mark - 按所选tag值  筛选视频
- (void)sortVideoByPage:(NSString*)page {
    
//    NSString *tagStr = [NSString string];
    if (self.tagDict.count) {
//        for (int i = 0; i<self.tagDict.count; i++) {
//            NSString *str = self.tagDict[[NSString stringWithFormat:@"tag%d",i]];
//
//            tagStr = [tagStr stringByAppendingString:str];
//            tagStr = [tagStr stringByAppendingString:@","];
//        }
        [self filterVideoListWithClassName:self.category sort:[NSString stringWithFormat:@"%lu",(unsigned long)self.selectIndex] page:page tags:self.tagDict itemIndex:self.itemIndex];
    }else{
        // 如果有默认选择tag
        
        if (!isEmpty(self.defaultSelectedTag)) {
            //NSString *str = self.defaultSelectedTag;
            //tagStr = [tagStr stringByAppendingString:str];
            
            
//            NSArray * paramArray = [self.defaultSelectedTag componentsSeparatedByString:@","];
//            for (int i = 0; i<paramArray.count; i++) {
//                if (i == 0) {
//                    [self.tagDict setValue:paramArray[0] forKey:@"tag_id"];
//                }
//                if (i == 1) {
//                    [self.tagDict setValue:paramArray[1] forKey:@"video_tag_id"];
//                }
//            }
        }
        // tagStr = 2731,2747
        
        
        [self filterVideoListWithClassName:self.category sort:[NSString stringWithFormat:@"%lu",(unsigned long)self.selectIndex] page:page tags:self.tagDict itemIndex:self.itemIndex];
    }
    
}




- (UICollectionView*)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = IS_IPAD? CGSizeMake((SCREEN_WIDTH - 20) * 0.25, (SCREEN_WIDTH - 20) * 0.25 * 0.9) : CGSizeMake((SCREEN_WIDTH - 20) * 0.5, (SCREEN_WIDTH - 20) * 0.5 * 352/337.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        // 兼容iOS11
        //_collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64 + 40 + 10, 0, kHeight49, 0);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, KTabBarHeight49+40, 10);
        
        HKAdjustsScrollViewInsetNever(self, _collectionView);
        _collectionView.tb_EmptyDelegate = self;
        // 注册cell
        [_collectionView registerClass:[HomeVideoCollectionCell class] forCellWithReuseIdentifier:@"HomeVideoCollectionCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDesignListCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKDesignListCell class])];
    }
    return _collectionView;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKDesignListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDesignListCell class]) forIndexPath:indexPath];
    VideoModel *model = self.dataArray[[indexPath row]];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event: list_video_prime];

    VideoModel *model = self.dataArray[indexPath.row];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo
                                                  videoId:model.video_id
                                                    model:model];
    [self pushToOtherController:VC];
}

#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf sortVideoByPage:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        //NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.dataArray.count/HomePageSize+1];
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.page];
        [strongSelf sortVideoByPage:pageNum];
        
    }];
//    [self.collectionView.mj_header beginRefreshing];
}


- (void)tableHeaderEndRefreshing {
    [self.collectionView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
}



- (void)collectOrQuitVideo:(VideoModel *)model index:(NSIndexPath *)indexPath{
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange collectOrQuitVideoWithToken:nil videoId:model.video_id type:model.is_collect? @"2" : @"1" videoType:HKVideoType_Ordinary postNotification:YES completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if (!model.is_collect) {
                model.is_collect = YES;
                [MBProgressHUD showSuccessMessage:@"收藏成功" imageName:@"right_red"];
            }else{
                model.is_collect = NO;
                [MBProgressHUD showSuccessMessage:@"取消收藏" imageName:@"right_red"];
            }
            [self.collectionView reloadData];
        }else{
            showTipDialog(response.msg);
        }
    } failBlock:^(NSError *error) {
        
    }];
}



#pragma mark - 筛选视频
- (void)filterVideoListWithClassName:(NSString*)className
                                sort:(NSString*)sort
                                page:(NSString*)page
                                tags:(NSDictionary * )tagDic
                           itemIndex:(NSInteger)index{
    
    if ([page isEqualToString:@"1"]) {
        self.page = 1;
    }
    
    @weakify(self);
    [[VideoServiceMediator sharedInstance] filterVideoListWithClass:className sort:sort page:page tags:tagDic
     completion:^(FWServiceResponse *response) {
         @strongify(self);
         
         [self tableHeaderEndRefreshing];
         if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
             if (isEmpty(self.title)) {
                 self.title = [response.data objectForKey:@"class_name"];//标题
             }
             NSString *count =  [response.data objectForKey:@"count"];
             NSString *total_page =  [response.data objectForKey:@"total_page"];
             self.videoCount = count;
             
             NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
             
             if ([page isEqualToString:@"1"]) {
                 self.dataArray = array;
                 
                 NSMutableArray *jobArr = [HKJobPathModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"career"]];
                 if ([self.delegate respondsToSelector:@selector(designTableChlidren:jobArr:videoArr:c4dArr:title:)]) {
                     [self.delegate designTableChlidren:self jobArr:jobArr videoArr:array c4dArr:nil title:self.title];
                 }
                 
             } else {
                 [self.dataArray addObjectsFromArray:array];
             }
             
             if (page.intValue >= total_page.intValue){
                 [self tableFooterEndRefreshing];
             }else{
                 [self tableFooterStopRefreshing];
             }
             
             if ([page isEqualToString:@"1"] && self.dataArray.count>0) {
                 //滚动到顶部
                 if (self.collectionView.visibleCells.count) {
                     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                 atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                 }
             }
             [self.collectionView reloadData];
             self.page ++;
         }else{
             [self tableFooterStopRefreshing];
         }
         
     } failBlock:^(NSError *error) {
         @strongify(self);
         [self tableHeaderEndRefreshing];
         [self tableFooterStopRefreshing];
         if (self.dataArray.count<1) {
             if ([self.delegate respondsToSelector:@selector(designTableChlidren:jobArr:videoArr:c4dArr:title:)]) {
                 [self.delegate designTableChlidren:self jobArr:nil videoArr:nil c4dArr:nil title:self.title];
             }
             [self.collectionView reloadData];
         }
     }];
}




@end







