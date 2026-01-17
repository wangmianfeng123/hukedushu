//
//  HKLiveRcommandCell.m
//  Code
//
//  Created by eon Z on 2021/12/15.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveRcommandCell.h"
#import "HKLiveRcommandSubCell.h"
#import "MyCollectionFlowLayout.h"
#import "HKCategoryTreeModel.h"
#import "JKPageControl.h"
#import "AppDelegate.h"

@interface HKLiveRcommandCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong , nonatomic)JKPageControl *pageControl;
@property (nonatomic, assign)int pageCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBtoomMargin;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)int mod;
@end

@implementation HKLiveRcommandCell


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    MyCollectionFlowLayout *layout = [[MyCollectionFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.currentIndexBlock = ^(NSInteger _currentIndex) {
        self.pageControl.currentPage = _currentIndex;
    };
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveRcommandSubCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKLiveRcommandSubCell class])];
    [self.collectionView reloadData];
    
    [self.contentView addSubview:self.pageControl];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+ 6, self.collectionView.width, 20);
}

#pragma mark <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageCount;
    //return 8;
    //return self.model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKLiveRcommandSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKLiveRcommandSubCell class]) forIndexPath:indexPath];
//    NSArray * cardArray = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row * 4 , 4)];
    NSArray * cardArray = [NSArray array];
    if(indexPath.row < self.pageCount - 1){
        cardArray = [self.dataArray subarrayWithRange:NSMakeRange(indexPath.row * 4 , 4)];
    }else{
        cardArray = [self.dataArray subarrayWithRange:NSMakeRange( indexPath.row * 4, self.dataArray.count - indexPath.row * 4 )];
    }
    
    cell.topLabel.text = self.model.title;
    cell.cardArray = cardArray;
    cell.moreBtnBlock = ^{
        if (self.moreBtnBlock) {
            self.moreBtnBlock();
        }
    };
    cell.tapClickBlock = ^(HKLiveListModel * _Nonnull model) {
        if (self.tapClickBlock) {
            self.tapClickBlock(model);
        }
    };
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.model.klass == -1) {//训练营
//        if (self.didCellBlock) {
//            [MobClick event:fenleiye_hukewangxiao_training];
//            self.didCellBlock(self.model.list[indexPath.row], YES);
//        }
//    }else{
//        if (self.didCellBlock) {
//            [MobClick event:fenleiye_hukewangxiao_livestudio];
//            self.didCellBlock(self.model.list[indexPath.row], NO);
//        }
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 15, 0, 0);
//}
//

-(void)setModel:(HKcategoryOnlineSchoolListModel *)model{
    _model = model;
    
    MyCollectionFlowLayout *layout = [[MyCollectionFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.currentIndexBlock = ^(NSInteger _currentIndex) {
        self.pageControl.currentPage = _currentIndex;
    };
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    
    [self.dataArray removeAllObjects];

    if (model.list.count == 0) {
        self.pageCount = 0;
        self.pageControl.hidden = YES;
        return;
    }
    
    self.pageCount = ceil(self.model.list.count / 4.0) ;
    self.pageControl.hidden = self.pageCount > 1? NO : YES;
    self.pageControl.numberOfPages = self.pageCount;

    NSMutableArray * tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:self.model.list];

//    int liveCount = self.pageCount * 4;
//    while (tempArray.count < liveCount) {
//        [tempArray addObjectsFromArray:self.model.list];
//    }
    
    self.dataArray = tempArray;
    
    
    if (self.dataArray.count > 0) {
        if(self.dataArray.count >= 4 ){
            [AppDelegate sharedAppDelegate].cellHeight = 384;
        }else{
            self.mod = self.dataArray.count % 4;
            if(self.mod ==0){
                [AppDelegate sharedAppDelegate].cellHeight = 384;
            }else{
                [AppDelegate sharedAppDelegate].cellHeight = 46 + 10 + (82 * self.mod);
            }
        }
    }
    
    
    [self.collectionView reloadData];
    
//    self.collectionBtoomMargin.constant = self.pageCount > 1? 26 : 0;
    self.collectionBtoomMargin.constant =  0;

}


- (JKPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[JKPageControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
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
        //[self.contentView insertSubview:_pageControl belowSubview:self.contentScrollView];
    }
    return _pageControl;
}

@end
