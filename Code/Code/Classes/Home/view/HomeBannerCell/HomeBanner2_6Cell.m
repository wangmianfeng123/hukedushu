//
//  HomeBanner2_6Cell.m
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeBanner2_6Cell.h"
#import "BannerModel.h"
#import "CategoryModel.h"
#import "GKCycleScrollViewItemCell.h"
#import "GKCycleScrollView.h"
#import "XHPageControl.h"


@interface HomeBanner2_6Cell()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate,XHPageControlDelegate>
@property (nonatomic, strong)UIImageView *bgIV;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;
@property(nonatomic,strong) XHPageControl *pageControl;

@end


@implementation HomeBanner2_6Cell

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.clipsToBounds = YES;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    // 添加背景
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.image = imageName(@"");
    bgIV.frame = self.bounds;
    bgIV.height = self.bounds.size.height * 0.65;
    [self addSubview:bgIV];
    self.bgIV = bgIV;
    
    [self showOrHiddenBackGroundView];
    [self addSubview:self.cycleScrollView];
    [self createPageControl];
}

-(GKCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {//(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * 255.0/375.0)
        _cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectZero];
        _cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IS_IPAD ? SCREEN_WIDTH * 0.5 * 240.0 / 690.0:(SCREEN_WIDTH - 30.0) * 240.0 / 690.0);
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.isAutoScroll = YES;
        _cycleScrollView.isInfiniteLoop = YES;
        _cycleScrollView.leftRightMargin = 8;
        if (IS_IPHONE) {
            _cycleScrollView.topBottomMargin = 8;
        }
    }
    return _cycleScrollView;
}

//创建页码指示器
-(void)createPageControl{
    [_pageControl removeFromSuperview];
    _pageControl = nil;
    //    if (self.dataArray.count <= 1) return;
    _pageControl = [[XHPageControl alloc] init];
    _pageControl.frame=CGRectMake((self.frame.size.width - 200)/2, self.frame.size.height - 25, 200, 25);
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.controlSpacing = 10;
    _pageControl.numberOfPages = self.dataArray.count;
    _pageControl.currentBkImg = [UIImage imageNamed:@"banner_select"];
    _pageControl.otherBkImg = [UIImage imageNamed:@"banner_gray"];
    _pageControl.currentColor = [UIColor clearColor];
    _pageControl.otherColor = [UIColor clearColor];
    _pageControl.delegate = self;
    _pageControl.hidden = YES;
    [self addSubview:_pageControl];
}


- (void)setBannerWithUrlArray:(NSArray*)array {
    if (array.count>0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i<array.count; i++) {
            HKMapModel *model = array[i];
            [tempArray addObject:model.img_url];
        }
        
        self.dataArray = tempArray;
        self.pageControl.numberOfPages = 0;
        self.pageControl.numberOfPages = self.dataArray.count;
        [self.cycleScrollView reloadData];
    }
    self.pageControl.hidden = self.dataArray.count >1 ? NO : YES;
}


//#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArray.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    cell.fromVip = NO;
    
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.imageView.layer.cornerRadius = 5.0;
        cell.imageView.layer.masksToBounds = YES;
    }
    // 设置数据
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.dataArray[index]]]];
    //https://pic.huke88.com/client/a-dvertise/images/202211/7qv0bbycb0th01elog4hkbpeh1tluaw9.gif!/format/webp
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://pic.huke88.com/video/cover/2021-12-29/27D7806D-4743-581A-9C6F-3C25399E14B5.gif!/fw/750"]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    if (IS_IPAD) {
        return CGSizeMake(SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5 * 240.0 / 690.0);
    }else{
        return CGSizeMake(SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30.0) * 240.0 / 690.0);
    }
}

// cell滑动时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
}


// cell点击时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"------------ %ld",index);
    //点击中间图片的回调
    if ([self.delegate respondsToSelector:@selector(homeBannerDidSelectItemAtIndex:)]) {
        [self.delegate homeBannerDidSelectItemAtIndex:index];
    }
}



- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self showOrHiddenBackGroundView];
    }
}

- (void)showOrHiddenBackGroundView {
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        self.bgIV.hidden = (DMUserInterfaceStyleDark == mode) ? YES :NO;
    }else{
        self.bgIV.hidden = NO;
    }
}

@end
