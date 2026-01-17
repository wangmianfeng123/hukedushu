//
//  HKVipHeaderView.m
//  Code
//
//  Created by eon Z on 2021/11/8.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVipHeaderView.h"
#import "UIView+HKLayer.h"
#import "HKUserModel.h"
#import "GKCycleScrollView.h"
#import "HKVIPPriceView.h"

@interface HKVipHeaderView () <GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) HKUserModel * userModel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation HKVipHeaderView


-(GKCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {//(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * 255.0/375.0)
        _cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectZero];
        _cycleScrollView.frame = IS_IPHONE ? CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 255.0/375.0 - 60 -35) : CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * 150.0/375.0 - 60 -35);
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.isAutoScroll = NO;
        _cycleScrollView.isInfiniteLoop = NO;
        _cycleScrollView.leftRightMargin = 10 * Ratio;
        _cycleScrollView.topBottomMargin = 8 * Ratio ;
    }
    return _cycleScrollView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.centerView.backgroundColor = [UIColor clearColor];
    self.bottomView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bottomLabel.textColor = [UIColor colorWithHexString:@"#858994"];
    [self.headerView addCornerRadius:20];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#DBC1A2"];
    self.topView.backgroundColor =[UIColor hkdm_colorWithColorLight:[UIColor colorWithHexString:@"3D414D"] dark:[UIColor colorWithHexString:@"#3D4752"]];
        
    [self.centerView addSubview:self.cycleScrollView];
    [self setUserInfo];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tap];
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotifi);

}

- (void)loginSuccessNotifi {
    [self setUserInfo];
}


- (void)tapClick{
    if (self.didHeaderBlock) {
        self.didHeaderBlock();
    }
}

- (void)setUserInfo{
    self.userModel = [HKAccountTool shareAccount];

    [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.userModel.avator] placeholderImage:HK_PlaceholderImage];
    self.nameLabel.text = isLogin() ? [NSString stringWithFormat:@"%@(学号：%@)",self.userModel.username,self.userModel.ID] : @"点击登录";
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    for (int i = 0; i < self.dataArray.count; i++) {
        HKBuyVipModel * model= self.dataArray[i];
        if (model.isFlag == YES) {
            self.cycleScrollView.defaultSelectIndex = i;
        }
    }
    [self.cycleScrollView reloadData];
}

- (void)refreshData{
    [self.cycleScrollView reloadData];
}



//#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArray.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.imageView.layer.cornerRadius = 10;
        cell.imageView.layer.masksToBounds = YES;
        cell.fromVip = YES;
    }
    // 设置数据
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    HKBuyVipModel * model= self.dataArray[index];
    cell.currentIndex = cycleScrollView.currentSelectIndex;
    cell.model = model;
    if (model.isFlag) {
        cell.imageView.image = [UIImage imageNamed:@"bg_vipcard_2_38"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"bg_vipcard_bottom_2_38"];
    }
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    // (SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40) * 210 /
    //CGSizeMake(210.0 * Ratio, 150 * Ratio);
    return IS_IPHONE ? CGSizeMake(210.0 * Ratio, 150 * Ratio) : CGSizeMake((SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40) * 210 / 150, (SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40));
}

// cell滑动时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index{
    NSLog(@"------------ %ld",index);
    for (int i = 0; i < self.dataArray.count; i++) {
        HKBuyVipModel * model= self.dataArray[i];
        if (index == i) {
            model.isFlag = YES;
            self.cycleScrollView.defaultSelectIndex = i;
        }else{
            model.isFlag = NO;
        }
    }
    
    
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView scrollingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex ratio:(CGFloat)ratio{
    NSLog(@"----%s----",__func__);
}

// cell点击时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"------------ %ld",index);
    [cycleScrollView scrollToCellAtIndex:index animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cycleScrollView reloadData];
        if ([self.delegate respondsToSelector:@selector(vipHeaderViewDidScrollToPage:)]) {
            [self.delegate vipHeaderViewDidScrollToPage:index];
        }
    });
    
}
//
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"------------ ");
    [self.cycleScrollView reloadData];
    if ([self.delegate respondsToSelector:@selector(vipHeaderViewDidScrollToPage:)]) {
        [self.delegate vipHeaderViewDidScrollToPage:cycleScrollView.currentSelectIndex];
    }
}


//- (void)setupUI {
//
//    //self.automaticallyAdjustsScrollViewInsets = NO;
//
//    self.pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 130 / 375.0)];
//    self.pageFlowView.delegate = self;
//    self.pageFlowView.dataSource = self;
//    self.pageFlowView.minimumPageAlpha = 0.01;
//    self.pageFlowView.isCarousel = NO;
//    self.pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
//    self.pageFlowView.isOpenAutoScroll = NO;
//    self.pageFlowView.topBottomMargin = 10;
//    self.pageFlowView.leftRightMargin = 10;
//    self.pageFlowView.backgroundColor = [UIColor clearColor];
//
//    [self.pageFlowView reloadData];
//
//    [self.centerView addSubview:self.pageFlowView];
//
//}
//
//
//#pragma mark NewPagedFlowView Delegate
//- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
//    //(0, 0, 210.0 * Ratio, 128.0 * Ratio)
//    return CGSizeMake(210.0 * Ratio, 128.0 * Ratio);
//}
//
//- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
//
//    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
//}
//
//- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
//
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
//    for (int i = 0; i < self.dataArray.count; i++) {
//        HKBuyVipModel * model= self.dataArray[i];
//        if (pageNumber == i) {
//            model.isFlag = YES;
//        }else{
//            model.isFlag = NO;
//        }
//    }
//
////    [self.pageFlowView reloadData];
//    if ([self.delegate respondsToSelector:@selector(vipHeaderViewDidScrollToPage:)]) {
//        [self.delegate vipHeaderViewDidScrollToPage:pageNumber];
//    }
//}
//
//#pragma mark NewPagedFlowView Datasource
//- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
//    return self.dataArray.count;
//
//}
//
//- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
//    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
//    if (!bannerView) {
//        bannerView = [[PGIndexBannerSubiew alloc] init];
//        bannerView.tag = index;
//        bannerView.layer.cornerRadius = 4;
//        bannerView.layer.masksToBounds = YES;
//    }
//    //在这里下载网络图片
//    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
//    bannerView.mainImageView.image = self.imageArray[index];
//
//    HKBuyVipModel * model= self.dataArray[index];
//    bannerView.model = model;
//    if (model.is_selected) {
//        bannerView.mainImageView.image = [UIImage imageNamed:@"bg_vipcard_2_38"];
//    }else{
//        bannerView.mainImageView.image = [UIImage imageNamed:@"bg_vipcard_bottom_2_38"];
//    }
//    return bannerView;
//}
//
//-(void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView{
//    NSLog(@"------------ %ld",pageNumber);
//    for (int i = 0; i < self.dataArray.count; i++) {
//        HKBuyVipModel * model= self.dataArray[i];
//        if (pageNumber == i) {
//            model.isFlag = YES;
//            //self.cycleScrollView.defaultSelectIndex = i;
//        }else{
//            model.isFlag = NO;
//        }
//    }
//}




@end
