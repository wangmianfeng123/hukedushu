//
//  HKContainerTagVC.m
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKContainerTagVC.h"
#import "SeriesCourseTagCell.h"
#import "SeriesCourseTagHeadCell.h"
#import "SeriseCourseModel.h"
#import "HKContainerTagCell.h"
#import "HKContainerTagFlowLayout.h"
#import "HKCollectionViewWaterfallLayout.h"
#import "HKCategoryAlbumModel.h"


@interface HKContainerTagVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HKCollectionViewDelegateWaterfallLayout>

@property(nonatomic,strong)UICollectionView  *collectionView;

@property(nonatomic,strong)NSMutableArray<AlbumSortTagListModel*> *tagModelArr;
/** 顶部提示 */
@property(nonatomic,strong)UILabel  *tipLabel;

@property(nonatomic,strong)HKCategoryAlbumModel *albumModel;


@end

@implementation HKContainerTagVC


- (instancetype)initWithModel:(HKCategoryAlbumModel *)albumModel {
//- (instancetype)initWithModelArray: (NSMutableArray<AlbumSortTagListModel*>*)modelArr {
    
    if (self = [super init]) {
        self.albumModel = albumModel;
        [albumModel.label_list enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AlbumSortTagListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [obj.children enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AlbumSortTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __block AlbumSortTagModel *temp = obj;
                [albumModel.labels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AlbumSortTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.class_id isEqualToString: temp.class_id]) {
                        temp.isSelect = YES;
                        *stop = YES;
                    }
                }];
            }];
            

        }];
        self.tagModelArr = albumModel.label_list;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    self.title = @"筛选教程";
    [self createLeftBarButton];
    //[self rightBarButtonItemWithTitle:@"完成" action:@selector(rightBarBtnAction)];
    [self rightBarButtonItemWithTitle:@"完成" color:COLOR_27323F action:@selector(rightBarBtnAction)];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tipLabel];
    //[self refreshUI];
}

- (void)rightBarBtnAction {
    
}


- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectMake(0,KNavBarHeight64 ,SCREEN_WIDTH, PADDING_35*2) title:@" 请选择合适的标签，最多选择3个"
                                 titleColor:COLOR_666666 titleFont:(IS_IPHONE6PLUS ?@"14":@"12") titleAligment:NSTextAlignmentLeft];
        _tipLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tipLabel;
}


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
//        HKContainerTagFlowLayout *layout = [[HKContainerTagFlowLayout alloc] init];
//        layout.itemSpacing = 1;
//        layout.lineSpacing = 1.5;
//        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
//        layout.colCount = 4;
//        layout.delegate = self;
        
        HKCollectionViewWaterfallLayout *layout = [[HKCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.headerHeight = 1;
        layout.footerHeight = 1;
        layout.minimumColumnSpacing = 2;
        layout.minimumInteritemSpacing = 1;
        layout.columnCount = 4;
        

        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[HKContainerTagCell class] forCellWithReuseIdentifier:@"SeriesCourseTagCell"];
        [_collectionView registerClass:[SeriesCourseTagHeadCell class] forCellWithReuseIdentifier:@"SeriesCourseTagHeadCell"];
        
        _collectionView.backgroundColor = COLOR_F6F6F6;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64+80, 0, 0, 0);
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        if (@available(iOS 11.0, *)) {
//            self.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
//        }
    }
    return _collectionView;
}



- (NSMutableArray<AlbumSortTagListModel*>*)tagModelArr {
    if (!_tagModelArr) {
        _tagModelArr = [NSMutableArray array];
    }
    return  _tagModelArr;
}



#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  _tagModelArr.count;
    //return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tagModelArr[section].children.count;
    //return _tagModelArr.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(self.view.frame.size.width/4, 81);
    }
    return CGSizeMake(self.view.frame.size.width/4, 40);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HKContainerTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeriesCourseTagCell" forIndexPath:indexPath];
    cell.model = _tagModelArr[indexPath.section].children[indexPath.row]; //_tagModelArr[[indexPath row]].children;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (0 == row) {
        return;
    }
    if (_tagModelArr[section].children[row].isSelect  == YES) {
        _tagModelArr[section].children[row].isSelect = !_tagModelArr[section].children[row].isSelect;
    }else{
        __block NSInteger count = 0;
        [_tagModelArr[section].children enumerateObjectsWithOptions:NSEnumerationReverse
                                                         usingBlock:^(AlbumSortTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelect) {
                count++;
                if (count >=3) {
                    *stop = stop;
                }
            }
        }];
        
        if (count >= 3) {
            showTipDialog(@"最多选择3个");
            return;
        }
        _tagModelArr[section].children[row].isSelect = !_tagModelArr[section].children[row].isSelect;
        //self.tagSelectBlock(indexPath, _tagModelArr[row]);
    }
    [collectionView  reloadData];
}




#pragma mark - 刷新
- (void)refreshUI {
    //WeakSelf;
    MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    header.automaticallyChangeAlpha = YES;
    _collectionView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)tableHeaderEndRefreshing {
    [_collectionView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_collectionView.mj_footer endRefreshing];
}






@end
