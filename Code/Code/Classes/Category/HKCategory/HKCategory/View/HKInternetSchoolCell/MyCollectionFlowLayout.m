//
//  MyCollectionFlowLayout.m
//  PageCollectionViewDemo
//
//  Created by Caolu on 2019/3/13.
//  Copyright © 2019 RoadCompany. All rights reserved.
//

#import "MyCollectionFlowLayout.h"
#import "AppDelegate.h"
//#import "UIView+Extension.h"

//    layout.itemSize = CGSizeMake(self.width-95-20, 69.9);

//static CGFloat const kItemWidth = 70.f;     // item宽高
//static CGFloat const kPaddingMid = 30.f;    // item间距
//static CGFloat const kPaddingLeft = 20.f;   // 最左边item左边距


@interface MyCollectionFlowLayout()<UIScrollViewDelegate, UICollectionViewDelegate> {
    NSInteger _pageCapacity;    // 每页可以完整展示的item个数
    NSInteger _currentIndex;    // 当前页码（滑动前）
    CGFloat kItemWidth ;
    CGFloat kItemHeight ;
    CGFloat kPaddingMid ;
    CGFloat kPaddingLeft ;
}

@end

@implementation MyCollectionFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    kItemWidth = IS_IPAD ? (SCREEN_WIDTH - 95-30)* 0.65 : SCREEN_WIDTH - 95-30;
    kItemHeight = [AppDelegate sharedAppDelegate].cellHeight;
    //kItemHeight = 384; // 82 * 4 + 46 = 374 + 10(上下阴影间距) = 384
    
    kPaddingMid = 5.0;
    kPaddingLeft = 10.0;
    
    
    self.collectionView.delegate = self;
    
    // 计算paddingRight
    CGFloat paddingRight = 0.0;
    
    // item个数
    // collectionView调用reloadData后，layout会重新prepareLayout
    NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    // item间距
    self.minimumInteritemSpacing = 0.1;
    self.minimumLineSpacing = kPaddingMid;
    self.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    
    // 每页可以完整显示的items个数
    NSInteger pageCapacity = (NSInteger)(collectionViewWidth - kPaddingLeft + kPaddingMid) / (NSInteger)(kItemWidth + kPaddingMid);
    _pageCapacity = pageCapacity;
    
    // 完整显示所有items的总页数
    NSInteger pages = itemsCount / pageCapacity;
    NSInteger remainder = itemsCount % pageCapacity;
    if (remainder == 0) {
        paddingRight = collectionViewWidth - pageCapacity * (kItemWidth + kPaddingMid) + kPaddingMid - kPaddingLeft;
    } else {
        paddingRight = collectionViewWidth - remainder * (kItemWidth + kPaddingMid) + kPaddingMid - kPaddingLeft;
        pages ++;
    }
    
    self.sectionInset = UIEdgeInsetsMake(0, kPaddingLeft, 0, paddingRight);
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    NSInteger index = (NSInteger)proposedContentOffset.x / (NSInteger)(_pageCapacity * (kItemWidth + kPaddingMid));

    NSInteger remainder = (NSInteger)proposedContentOffset.x % (NSInteger)(_pageCapacity * (kItemWidth + kPaddingMid));

    if (remainder > 10 && velocity.x > 0.3) {
        index ++;
    }

    if (velocity.x < -0.3 && index > 0) {
        index --;
    }
    
    // 保证一次只滑动一页
    index = MAX(index, _currentIndex - 1);
    index = MIN(index, _currentIndex + 1);

    CGPoint point = CGPointMake(0, 0);
    if (index > 0) {
        point.x = index * _pageCapacity * (kItemWidth + kPaddingMid);
    }

    return point;
}

#pragma mark --- UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    /*
//     * 分子scrollView.contentOffset.x为什么要+kItemWidth ？？
//     * 消除scrollView在摆动的时候的误差，此时contentOffset.x比预期减少了10左右像素，导致_currentIndex比预期小1
//     */
//    _currentIndex = (NSInteger)(scrollView.contentOffset.x + kItemWidth) / (NSInteger)(_pageCapacity * (kItemWidth + kPaddingMid));
//    if (self.currentIndexBlock) {
//        self.currentIndexBlock(_currentIndex);
//
//    }
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
     * 分子scrollView.contentOffset.x为什么要+kItemWidth ？？
     * 消除scrollView在摆动的时候的误差，此时contentOffset.x比预期减少了10左右像素，导致_currentIndex比预期小1
     */
    _currentIndex = (NSInteger)(scrollView.contentOffset.x + kItemWidth) / (NSInteger)(_pageCapacity * (kItemWidth + kPaddingMid));
    if (self.currentIndexBlock) {
        self.currentIndexBlock(_currentIndex);
    }
}


@end
