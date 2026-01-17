//
//  HKRefreshTools.m
//  Code
//
//  Created by Ivan li on 2018/4/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKRefreshTools.h"



@implementation HKRefreshTools

NSString *const HK_HeaderIdleText = @"下拉刷新";

NSString *const HK_HeaderPullingText = @"释放更新";

NSString *const HK_HeaderRefreshingText = @"正在加载...";

NSString *const HK_FooterIdleText = @"上拉加载";

NSString *const HK_FooterRefreshingText = @"正在加载...";

NSString *const HK_FooterNoMoreDataText = @"已无更多数据";




+ (void)headerRefreshWithTableView:(id )view completion:(void (^)(void))completion {
    
    MJRefreshStateHeader *headerR = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        completion();
    }];
    
    headerR.automaticallyChangeAlpha = YES;
    headerR.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
    headerR.stateLabel.hidden = NO;
    [headerR setTitle:HK_HeaderIdleText forState:MJRefreshStateIdle];
    [headerR setTitle:HK_HeaderPullingText forState:MJRefreshStatePulling];
    [headerR setTitle:HK_HeaderRefreshingText forState:MJRefreshStateRefreshing];
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        tableview.mj_header = headerR;
        tableview.mj_header.lastUpdatedTimeKey.accessibilityElementsHidden = YES;
        
    } else if ([view isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_header = headerR;
        tableview.mj_header.lastUpdatedTimeKey.accessibilityElementsHidden = YES;
    }
}




+ (void)footerAutoRefreshWithTableView:(id )view completion:(void (^)(void))completion {
    

    MJRefreshAutoStateFooter *footerR= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        completion();
    }];
    [footerR setTitle:HK_FooterIdleText forState:MJRefreshStateIdle];
    [footerR setTitle:HK_FooterRefreshingText forState:MJRefreshStateRefreshing];
    [footerR setTitle:HK_FooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        tableview.mj_footer = footerR;
        tableview.mj_footer.automaticallyHidden = YES;
        tableview.mj_footer.automaticallyChangeAlpha = YES;
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_footer = footerR;
        tableview.mj_footer.automaticallyHidden = YES;
        tableview.mj_footer.automaticallyChangeAlpha = YES;
    }
}





+ (void)gifHeaderRefreshWithTableView:(id )view completion:(void (^)(void))completion {
    
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        completion();
    }];
    //如果不隐藏这个会默认 图片在最左边不是在中间
    headerView.lastUpdatedTimeLabel.hidden= YES;
    
//    NSString *title = @"\n虎课网";;
//    NSString *stateString1 = [NSString stringWithFormat:@"%@\n下拉更新...",title];
//    NSString *stateString2 = [NSString stringWithFormat:@"%@\n松开更新...",title];
//    NSString *stateString3 = [NSString stringWithFormat:@"%@\n更新中...",title];
//    [headerView setTitle:stateString1 forState:MJRefreshStateIdle];
//    [headerView setTitle:stateString2 forState:MJRefreshStatePulling];
//    [headerView setTitle:stateString3 forState:MJRefreshStateRefreshing];
    
    [headerView setTitle:HK_HeaderIdleText forState:MJRefreshStateIdle];
    [headerView setTitle:HK_HeaderPullingText forState:MJRefreshStatePulling];
    [headerView setTitle:HK_HeaderRefreshingText forState:MJRefreshStateRefreshing];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d", i]];
        if (image != nil) {
            [refreshingImages addObject:image];
        }
    }
    [headerView setImages:refreshingImages forState:MJRefreshStateIdle];
    
    [headerView setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [headerView setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        tableview.mj_header = headerView;
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_header = headerView;
    }
    
}




+ (void)shortVideoFooterAutoRefreshWithTableView:(id )view completion:(void (^)(void))completion {
    
    MJRefreshAutoStateFooter *footerR= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        completion();
    }];
    
    footerR.refreshingTitleHidden = YES;
    [footerR setTitle:@" " forState:MJRefreshStateIdle];
    [footerR setTitle:@" " forState:MJRefreshStateRefreshing];
    [footerR setTitle:@" " forState:MJRefreshStateNoMoreData];
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        tableview.mj_footer = footerR;
        tableview.mj_footer.automaticallyHidden = YES;
        tableview.mj_footer.automaticallyChangeAlpha = YES;
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_footer = footerR;
        tableview.mj_footer.automaticallyHidden = YES;
        tableview.mj_footer.automaticallyChangeAlpha = YES;
    }
}






+ (void)headerEndRefreshing:(id )view {
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        [tableview.mj_header endRefreshing];
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        [tableview.mj_header endRefreshing];
    }
}




+ (void)FooterEndRefreshNoMoreData:(id )view {
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        [tableview.mj_footer endRefreshingWithNoMoreData];
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        [tableview.mj_footer endRefreshingWithNoMoreData];
    }
}




+ (void)footerStopRefreshing:(id )view {
    
    if ([view isKindOfClass:[UITableView class]]) {
        
        UITableView *tableview = (UITableView *)view;
        [tableview.mj_footer endRefreshing];
        
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        [tableview.mj_footer endRefreshing];
    }
}






@end




