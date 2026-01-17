//
//  DCFeatureSelectionViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureSelectionViewController.h"


#import "DCFeatureItem.h"
#import "DCFeatureTitleItem.h"
#import "DCFeatureList.h"
// Views

#import "DCFeatureItemCell.h"
#import "DCFeatureHeaderView.h"
#import "DCCollectionHeaderLayout.h"

// Vendors
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
//#import "UIViewController+XWTransition.h"
// Categories

// Others

#define NowScreenH SCREEN_HEIGHT * 0.8

@interface DCFeatureSelectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate,UITableViewDelegate,UITableViewDataSource>

/* contionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray <DCFeatureItem *> *featureAttr;
/* 选择属性 */
@property (strong , nonatomic)NSMutableArray *seleArray;
/* 商品选择结果Cell */

@end

static NSInteger num_;

static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";
static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";
static NSString *const DCFeatureChoseTopCellID = @"DCFeatureChoseTopCell";
@implementation DCFeatureSelectionViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DCCollectionHeaderLayout *layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = 10;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}



#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFeatureAlterView];
    [self setUpBase];
    [self setUpBottonView];
}

#pragma mark - initialize

- (void)setUpBase {
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.collectionView.backgroundColor = self.view.backgroundColor;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    _featureAttr = [DCFeatureItem mj_objectArrayWithFilename:@"ShopItem.plist"];
//    self.collectionView.frame = CGRectMake(0, 64,SCREEN_WIDTH,400);
//
//    
//    if (_lastSeleArray.count == 0) return;
//    for (NSString *str in _lastSeleArray) {//反向遍历
//        for (NSInteger i = 0; i < _featureAttr.count; i++) {
//            for (NSInteger j = 0; j < _featureAttr[i].list.count; j++) {
//                if ([_featureAttr[i].list[j].infoname isEqualToString:str]) {
//                    _featureAttr[i].list[j].isSelect = YES;
//                    [self.collectionView reloadData];
//                }
//            }
//        }
//    }

}

#pragma mark - 底部按钮
- (void)setUpBottonView {
    NSArray *titles = @[@"清空",@"确认"];
    CGFloat buttonH = 50;
    CGFloat buttonW = SCREEN_WIDTH / titles.count;
    CGFloat buttonY = 464;//NowScreenH - buttonH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttton setTitle:titles[i] forState:0];
        buttton.backgroundColor = (i == 0) ? [UIColor redColor] : [UIColor orangeColor];
        CGFloat buttonX = buttonW * i;
        buttton.tag = i;
        buttton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.view addSubview:buttton];
        [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button {
    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {//未选择全属性警告
        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [self dismissFeatureViewControllerWithTag:button.tag];
    
}

#pragma mark - 弹出弹框
- (void)setUpFeatureAlterView
{
//    XWInteractiveTransitionGestureDirection direction = XWInteractiveTransitionGestureDirectionDown;
//    __weak typeof(self)weakSelf = self;
//    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
//        [weakSelf dismissViewControllerAnimated:YES completion:^{
//            [weakSelf dismissFeatureViewControllerWithTag:100];
//        }];
//    } edgeSpacing:0];
}



#pragma mark - 退出当前界面
- (void)dismissFeatureViewControllerWithTag:(NSInteger)tag {
    __weak typeof(self)weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
//        if (![weakSelf.cell.chooseAttLabel.text isEqualToString:@"有货"]) {//当选择全属性才传递出去
//        }
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            if (_seleArray.count == 0) {
                NSMutableArray *numArray = [NSMutableArray arrayWithArray:_lastSeleArray];
                NSDictionary *paDict = @{
                                         @"Tag" : [NSString stringWithFormat:@"%zd",tag],
                                         @"Num" : [NSString stringWithFormat:@"%zd",num_],
                                         @"Array" : numArray
                                         };
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"itemSelectBack" object:nil userInfo:dict];
            }else{
                NSDictionary *paDict = @{
                                         @"Tag" : [NSString stringWithFormat:@"%zd",tag],
                                         @"Num" : [NSString stringWithFormat:@"%zd",num_],
                                         @"Array" : _seleArray
                                         };
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:paDict];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"itemSelectBack" object:nil userInfo:dict];
            }
        });
    }];
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _featureAttr[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    cell.content = _featureAttr[indexPath.section].list[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        headerView.headTitle = _featureAttr[indexPath.section].attr;
        return headerView;
    }else {

        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

//    //限制每组内的Item只能选中一个(加入质数选择)
//    if (_featureAttr[indexPath.section].list[indexPath.row].isSelect == NO) {
//        for (NSInteger j = 0; j < _featureAttr[indexPath.section].list.count; j++) {
//            _featureAttr[indexPath.section].list[j].isSelect = NO;
//        }
//    }
//    _featureAttr[indexPath.section].list[indexPath.row].isSelect = !_featureAttr[indexPath.section].list[indexPath.row].isSelect;
//    //section，item 循环讲选中的所有Item加入数组中 ，数组mutableCopy初始化
//    _seleArray = [@[] mutableCopy];
//    for (NSInteger i = 0; i < _featureAttr.count; i++) {
//        for (NSInteger j = 0; j < _featureAttr[i].list.count; j++) {
//            if (_featureAttr[i].list[j].isSelect == YES) {
//                [_seleArray addObject:_featureAttr[i].list[j].infoname];
//            }else{
//                [_seleArray removeObject:_featureAttr[i].list[j].infoname];
//                [_lastSeleArray removeAllObjects];
//            }
//        }
//    }
//    //刷新tableView和collectionView
//    [self.collectionView reloadData];
}


#pragma mark - <HorizontalCollectionLayoutDelegate>
//#pragma mark - 自定义layout必须实现的方法
//- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
//    return _featureAttr[indexPath.section].list[indexPath.row].infoname;
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
