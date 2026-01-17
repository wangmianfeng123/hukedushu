//
//  HKStudyTagVC.m
//  Code
//
//  Created by Ivan li on 2018/5/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagVC.h"
#import "HKStudyTagCell.h"
#import "HKCollectionHeaderLayout.h"
#import "HKStudyTagHeadView.h"
#import "HKStudyTagBottomView.h"
#import "HKStudyTagModel.h"
#import "HKStudyTagSelectGuideView.h"
#import "AppDelegate.h"
#import "HKStudyTagHeader.h"
#import "HKStudyrRecommendVC.h"
#import "BannerModel.h"
#import "HKH5PushToNative.h"


@interface HKStudyTagVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) HKStudyTagBottomView *bottomView;

@property (nonatomic,strong) NSMutableArray<HKStudyTagModel*> *dataArray;
/** yes--有选择的标签 */
@property (nonatomic,assign) BOOL isSelect;

@property(nonatomic,assign)NSInteger page;

@property (nonatomic,strong) HKStudyTagHeadView *topView;
/** 选中tag */
@property (nonatomic,strong) NSMutableArray *selectTagArray;
/** 第一次选择标签 */
@property (nonatomic,assign) BOOL isFirstSelectTag;

@property (nonatomic,strong)HKMapModel *mapModel;

@end



@implementation HKStudyTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)createUI {
    
    self.isFirstSelectTag = YES;
    self.isSelect = NO;
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64+5);
        make.height.mas_equalTo(73);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.collectionView reloadData];
    
    [self addObserver:self forKeyPath:@"self.isSelect" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}



/** 回调方法    */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"self.isSelect"]) {
        
        BOOL new = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL old = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
        if (new == old) {
            
        }else{
            UIImage *image = nil;
            if (new) {
                //image = imageName(@"study_tag_start_select");
                
                UIColor *color = [UIColor colorWithHexString:@"#FF9200"];
                UIColor *color1 = [UIColor colorWithHexString:@"#FFA200"];
                UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
                image = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH - 30, 50) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
                
            }else{
                //image = imageName(@"study_tag_start");
                
                UIColor *color = [UIColor colorWithHexString:@"#EFEFF6"];
                UIColor *color1 = [UIColor colorWithHexString:@"#EFEFF6"];
                UIColor *color2 = [UIColor colorWithHexString:@"#EFEFF6"];
                image = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH - 30, 50) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
            }
            [self.bottomView setOkBtnNewBgImage:image isSelect:new];
        }
    }
}



- (void)dealloc {
    //kvo 移除监视self.isSelect属性
    [self removeObserver:self forKeyPath:@"self.isSelect" context:nil];
}


- (HKStudyTagHeadView*)topView {
    if (!_topView) {
        _topView = [[HKStudyTagHeadView alloc]initWithFrame:CGRectZero];
    }
    return _topView;
}


- (HKStudyTagBottomView*)bottomView {
    if (!_bottomView) {
        WeakSelf;
        _bottomView = [[HKStudyTagBottomView alloc]initWithFrame:CGRectZero];
        _bottomView.hidden = YES;
        _bottomView.okbtnClickBlock = ^{
            StrongSelf;
            __block NSMutableArray<HKStudyTagModel*> *arr = [NSMutableArray array];
            __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [strongSelf.dataArray enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.is_select) {
//                    [arr addObject:obj];
//                    [dict setValue:obj forKey:[NSString stringWithFormat:@"%ld",idx]];
//                }
//            }];
            
            [strongSelf.dataArray enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj.children enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.is_select) {
                        [arr addObject:obj];
                        [dict setValue:obj forKey:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                    }
                }];
            }];
            
            
            if (arr.count) {
                [strongSelf saveStudyTagToServer:arr];
            }
            if (dict) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    HK_NOTIFICATION_POST_DICT(HKSelectStudyTagNotification, nil, dict);
                });
            }
            
            if ([strongSelf.mapModel.className isEqualToString:@"HomeVideoVC"] && (YES == strongSelf.isFirstSelectTag)) {
                //选中 第一个 tabbar
                [CommonFunction pushTabVCWithCurrectVC:strongSelf index:0];
            }else{
                [HKH5PushToNative runtimePush:strongSelf.mapModel.className arr:strongSelf.mapModel.list currectVC:strongSelf];
            }
        };
    }
    return _bottomView;
}



#pragma mark - 将学习兴趣保存后台
- (void)saveStudyTagToServer:(NSMutableArray<HKStudyTagModel*>*)arr {
    
    __block NSMutableString *tag = [NSMutableString new];
    __block NSInteger count = arr.count;
    [arr enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isEmpty(obj.classId)) {
            NSString *temp = [NSString stringWithFormat:@"%@,",obj.classId];
            if (count-1 == idx) {
                //最后一个不带隔开 标点符号 （,）
                temp = obj.classId;
            }
            [tag appendString:temp];
        }
    }];
    
    //class *用户选择的分类，多个分类用英文, 隔开
    // v2.11 之前版本
    //NSDictionary *dict = @{@"class":tag};
    
    // v2.11
    NSDictionary *dict = @{@"intentions":tag};
    [HKHttpTool POST:HOME_ADD_INTEREST baseUrl:BaseUrl parameters:dict success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (NSMutableArray<HKStudyTagModel*>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
//    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
//        StrongSelf;
//        strongSelf.page = 1;
//        [strongSelf getServerDataWithpage:@"1"];
//    }];
    [self getServerDataWithpage:@"1"];
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




#pragma mark - 后台数据 (学习兴趣列表)

- (void)getServerDataWithpage:(NSString*)page {
    WeakSelf;
    NSDictionary *dict = @{@"page":page};
    [HKHttpTool POST:HOME_INTEREST baseUrl:BaseUrl parameters:dict success:^(id responseObject) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *selectArr = [responseObject[@"data"]objectForKey:@"in_intention_list"];
            if (selectArr.count) {
                strongSelf.isSelect = YES;
            }
            strongSelf.selectTagArray = selectArr;
            
            NSMutableArray<HKStudyTagModel*> *array = [HKStudyTagModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"]objectForKey:@"intention_list"]];
//            [array enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.is_select) {
//                    strongSelf.isSelect = YES;
//                    *stop = YES;
//                }
//            }];
            if ([page isEqualToString:@"1"]) {
                strongSelf.dataArray = array;
            }else{
                [strongSelf.dataArray addObjectsFromArray:array];
            }
            ///查找 选中tag
            [selectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger value = [obj integerValue];
                [strongSelf.dataArray enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.children enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (value == [obj.classId integerValue]) {
                            obj.is_select = YES;
                        }
                    }];
                }];
            }];
            
            self.mapModel = [HKMapModel mj_objectWithKeyValues:[responseObject[@"data"]objectForKey:@"redirect_package"]];
            
            strongSelf.bottomView.hidden = NO;
            [strongSelf.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        StrongSelf
        [strongSelf tableHeaderEndRefreshing];
        if (0 == strongSelf.dataArray.count) {
            [strongSelf.collectionView reloadData];
        }
    }];
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        HKCollectionHeaderLayout *layout = [[HKCollectionHeaderLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 10;
        layout.interitemSpacing = 10;
        layout.headerViewHeight = 30;
        layout.itemHeight = IS_IPHONE6PLUS ?32 :27;
        layout.labelFont = HK_FONT_SYSTEM(13);
        layout.itemContentMargin = IS_IPHONE6PLUS ?15 :12.5;
        //layout.itemInset = IS_IPHONE5S ? UIEdgeInsetsMake(0, 25, 0, 5) :UIEdgeInsetsMake(0, IS_IPAD? 50 :(IS_IPHONE6PLUS ?60 :50), 0, 5);
        layout.itemInset = IS_IPHONE5S ? UIEdgeInsetsMake(0, 25, 0, 5) :UIEdgeInsetsMake(0, IS_IPAD? 50 :(75/2), 0, 5);

        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //_collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[HKStudyTagCell class] forCellWithReuseIdentifier:NSStringFromClass([HKStudyTagCell class])];
        
        [_collectionView registerClass:[HKStudyTagHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKStudyTagHeader class])];
        
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _collectionView);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    }
    return _collectionView;
}




#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray[section].children.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKStudyTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKStudyTagCell class]) forIndexPath:indexPath];
    HKStudyTagModel *model = self.dataArray[indexPath.section];
    cell.model = model.children[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        HKStudyTagHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:NSStringFromClass([HKStudyTagHeader class]) forIndexPath:indexPath];
        
        HKStudyTagModel *model = self.dataArray[indexPath.section];
        headerView.title.text = model.name;
        return headerView;
    }
    return [UICollectionReusableView new];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NSInteger row = indexPath.row;
    
    [self.dataArray[indexPath.section].children enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        HKStudyTagModel *model = obj;
        if (row == idx) {
            model.is_select = !model.is_select;
        }
    }];
    
    __block BOOL is_selected = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.children enumerateObjectsUsingBlock:^(HKStudyTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_select) {
                is_selected = YES;
                *stop = YES;
            }
        }];
    }];
    
    self.isSelect = is_selected;
    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}



#pragma mark - <HorizontalCollectionLayoutDelegate>
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return @"字体设计";
}

@end








