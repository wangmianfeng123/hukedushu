//
//  HomeCategoryCell.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "HomeCategoryCell.h"
#import "HomeClassCell.h"
#import "MJExtension.h"
#import "UIView+SNFoundation.h"
#import "CategoryModel.h"
//#import "DesignTableVC.h"
#import "HKMoreClickCollectionView.h"
#import "HKHomeJobPathGuideView.h"
#import "JKPageControl.h"


@interface HomeCategoryCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak , nonatomic)UIScrollView *contentScrollView;

//@property (weak , nonatomic)UIPageControl *pageControl;
@property (strong , nonatomic)JKPageControl *pageControl;

//@property (weak , nonatomic)HKHomeArticleGuideView *articleGuideView;

@property (weak , nonatomic)HKHomeJobPathGuideView  *jobPathGuideView;
@property (nonatomic, strong) UIView * campGuidView;

@end

//static NSString *const HomeCategoryCellID = @"HomeCategoryCellID";
static NSString *const DCGoodsSurplusCellID = @"DCGoodsSurplusCell";

@implementation HomeCategoryCell

#pragma mark - lazyload

- (UIView *)campGuidView{
    if (_campGuidView == nil) {
        _campGuidView = [[UIView alloc] init];
        _campGuidView.backgroundColor = [UIColor redColor];
        _campGuidView.size = CGSizeMake(20, 20);
    }
    return _campGuidView;
}

- (JKPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[JKPageControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        _pageControl.numberOfPages  = 0;
        _pageControl.currentPage = 0;
        _pageControl.itemSize  = CGSizeMake(18, 18);
        _pageControl.itemMargin = 5;
        _pageControl.style = JKPageControlStyleImage;
        _pageControl.normalImage = [UIImage hkdm_imageWithNameLight:@"ic_change_dis" darkImageName:@"ic_change_dis_dark"];
        _pageControl.selectImage = [UIImage imageNamed:@"ic_change_sle"];
        _pageControl.direction = JKPageControlDirectionHorizontal;
        //_pageControl.center = CGPointMake(self.width * 0.5, self.height - 15);
        _pageControl.backgroundColor = [UIColor clearColor];
        [self.contentView insertSubview:_pageControl belowSubview:self.contentScrollView];
    }
    return _pageControl;
}

//- (UIPageControl *)pageControl {
//    if (_pageControl == nil) {
//        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
//        pageControl.numberOfPages = 0;
//        pageControl.currentPage = 0;
//
//        pageControl.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
//        pageControl.center = CGPointMake(self.width * 0.5, self.height - 12.5);
//        UIColor *tintColor = [UIColor hkdm_colorWithColorLight:HKColorFromHex(0xE9EAEB, 1.0) dark:COLOR_7B8196];
//        pageControl.pageIndicatorTintColor = tintColor;
//        pageControl.currentPageIndicatorTintColor = HKColorFromHex(0xFFD200, 1.0);
//
//        [self.contentView insertSubview:pageControl belowSubview:self.contentScrollView];
////        [self.contentView bringSubviewToFront:pageControl];
////        [self.contentView addSubview:pageControl];
////        pageControl.backgroundColor = [UIColor redColor];
//        _pageControl = pageControl;
//    }
//    return _pageControl;
//}

- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.frame = self.bounds;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator= NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.pageDataArray.count, self.bounds.size.height);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.clipsToBounds = NO;
        [self.contentView addSubview:scrollView];
        _contentScrollView = scrollView;
    }
    return _contentScrollView;
}

- (void)setPageDataArray:(NSMutableArray<PageCategoryModel *> *)pageDataArray {
    _pageDataArray = pageDataArray;
    [self setUpUI];
    self.pageControl.numberOfPages = pageDataArray.count;
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    // 根据数据添加collectionView
    if (self.contentScrollView.subviews.count) {
        [self.contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    for (int i = 0; i < self.pageDataArray.count; i++) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        CGFloat wdith = IS_IPAD ? (UIScreenWidth - 200.1) / 8.0: (UIScreenWidth - 30.1) / 4.0;
        //CGFloat wdith = IS_IPAD?  (UIScreenWidth - 30.1) / 5.0 : (UIScreenWidth - 30.1) / 4.0;
        layout.itemSize = CGSizeMake(wdith, IS_IPAD ? 80 * iPadHRatio : 66 * Ratio);
        UICollectionView *collectionView = [[HKMoreClickCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentScrollView addSubview:collectionView];
        collectionView.scrollEnabled = NO;
        collectionView.frame = self.bounds;
        collectionView.x = self.bounds.size.width * i;
        collectionView.y = 5;
        collectionView.height = (IS_IPAD ? 80 * iPadHRatio : 66 * Ratio) * 2 + 7 + 8;
        collectionView.contentInset =  IS_IPAD ? UIEdgeInsetsMake(7, 100, 0, 100): UIEdgeInsetsMake(7, 15, 0, 15);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.clipsToBounds = NO;
        //        collectionView.backgroundColor = [UIColor orangeColor];
        
        [collectionView registerClass:[HomeClassCell class] forCellWithReuseIdentifier:DCGoodsSurplusCellID];
        [collectionView reloadData];
        if (i == 0) {
            self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(collectionView.frame)+5, SCREEN_WIDTH, 25);
        }
    }
    
    
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width * self.pageDataArray.count, self.bounds.size.height);
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    
//    if (self.pageDataArray.count > 1) {
//        [self pageControl];
//    }
    self.pageControl.hidden = self.pageDataArray.count > 1 ? NO :YES;
}

- (NSMutableArray<HomeCategoryModel *> *)findPageModelBy:(UICollectionView *)collectionView {
    // 遍历找出分页
    for (int i = 0; i < self.pageDataArray.count; i++) {
        if (collectionView == self.contentScrollView.subviews[i]) {
            return self.pageDataArray[i].list;
        }
    }
    
    return [NSMutableArray array];
}

// 第几组
- (int)findPageGroupBy:(UICollectionView *)collectionView {
    // 遍历找出分页
    for (int i = 0; i < self.pageDataArray.count; i++) {
        if (collectionView == self.contentScrollView.subviews[i]) {
            return i;
        }
    }
    return 0;
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        int i = self.contentScrollView.contentOffset.x / scrollView.width;
        self.pageControl.currentPage = i;
    }
}

#pragma mark - <UICollectionViewDataSource>
#pragma mark - CollectionViewDataSource
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return _dataArray.count;
//}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (IS_IPAD) {
        if ([self findPageModelBy:collectionView].count > 16) {
            return 16;
        }
        return [self findPageModelBy:collectionView].count;
    }else{
        if ([self findPageModelBy:collectionView].count > 8) {
            return 8;
        }
        return [self findPageModelBy:collectionView].count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSurplusCellID forIndexPath:indexPath];
    
    cell.model = [self findPageModelBy:collectionView][indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeCategoryCell:x:y:rect:cell:)]) {
        // 音频
//         if ([cell.model.class_type isEqualToString:@"6"]) {
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 if (cell.btn.height>1) {
//                     CGRect rect = [cell.btn.superview convertRect:cell.btn.frame toView:nil];
//                     //NSLog(@"rect-- %f --- %f",rect.origin.x,rect.origin.y);
//                     [self.delegate HomeCategoryCell:cell.model x:cell.x y:cell.y rect:rect cell:cell];
//                 }
//             });
//         }
    }
    int group = [self findPageGroupBy:collectionView];
    if (group == 0 && indexPath.row == 1) {
        BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"obtainFreeCamp"];
        cell.toastImg.hidden = show ? NO : YES;
    }else{
        cell.toastImg.hidden = YES;
    }

    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if (IS_IPAD) {
//        return UIEdgeInsetsMake(0, 50, 0, 50);
//    }
//    return UIEdgeInsetsZero;
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    CGPoint tempPoint = [self.jobPathGuideView convertPoint:point fromView:self];
    if ([self.jobPathGuideView pointInside:tempPoint withEvent:event]) {
        // 超出父控件范围 点击
        return self.jobPathGuideView;
    }
    return view;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(HomeCategoryCell:index:)]) {
        
        HomeCategoryModel *model = [self findPageModelBy:collectionView][indexPath.row];
//        if ([model.class_type isEqualToString:@"8"]) {
//            //8-文章
//            [self.articleGuideView closeViewClick];
//        }
        [self.delegate HomeCategoryCell:[self findPageModelBy:collectionView][indexPath.row] index:indexPath.row];
        int group = [self findPageGroupBy:collectionView];
#warning TODO 金刚区每屏数量调整，埋点位置需要调整
        [self mobClickEvent:indexPath.row group:(int)group];
        
        if (group == 0 && indexPath.row == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"obtainFreeCamp"];
            [NSUserDefaults standardUserDefaults];
        }
    }
}


- (void)mobClickEvent:(NSInteger)row group:(int)group {
    
    if (group == 0) {
        switch (row) {
            case 0:
                [MobClick event:UM_RECORD_HOME_CATEGORY_ZITI];
                break;
            case 1:
                [MobClick event:UM_RECORD_HOME_CATEGORY_HAIBAO];
                break;
            case 2:
                [MobClick event:UM_RECORD_HOME_CATEGORY_RUANJIAN];
                break;
            case 3:
                [MobClick event:UM_RECORD_HOME_CATEGORY_ZONGHE];
                break;
            case 4:
                [MobClick event:UM_RECORD_HOME_CATEGORY_C4D];
                break;
            case 5:
                [MobClick event:UM_RECORD_HOME_ICON_6];
                break;
            case 6:
                [MobClick event:UM_RECORD_HOME_ICON_7];
                break;
            case 7:
                [MobClick event:UM_RECORD_HOME_ICON_8];
                break;
            case 8:
                [MobClick event:UM_RECORD_SHOUYE_ICON9];
                break;
            case 9:
                [MobClick event:UM_RECORD_SHOUYE_ICON10];
                break;
            case 10:
                [MobClick event:UM_RECORD_SHOUYE_ICON11];
                break;
            case 11:
                [MobClick event:UM_RECORD_SHOUYE_ICON12];
                break;
            case 12:
                [MobClick event:UM_RECORD_SHOUYE_ICON13];
                break;
            case 13:
                [MobClick event:SHOUYE_ICON14];
                break;
            case 14:
                [MobClick event:SHOUYE_ICON15];
                break;
            case 15:
                [MobClick event:SHOUYE_ICON16];
                break;
            default:
                break;
        }
    }  else if (group == 1) {
        switch (row) {
            case 0:
                [MobClick event:UM_RECORD_SHOUYE_ICON9];
                break;
            case 1:
                [MobClick event:UM_RECORD_SHOUYE_ICON10];
                break;
            case 2:
                [MobClick event:UM_RECORD_SHOUYE_ICON11];
                break;
            case 3:
                [MobClick event:UM_RECORD_SHOUYE_ICON12];
                break;
            case 4:
                [MobClick event:UM_RECORD_SHOUYE_ICON13];
                break;
            case 5:
                [MobClick event:SHOUYE_ICON14];
                break;
            case 6:
                [MobClick event:SHOUYE_ICON15];
                break;
            case 7:
                [MobClick event:SHOUYE_ICON16];
                break;                
            default:
                break;
        }
    }
}


@end

















