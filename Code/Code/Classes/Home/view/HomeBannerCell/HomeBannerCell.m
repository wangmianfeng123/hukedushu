//
//  HomeBannerCell.m
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeBannerCell.h"
#import "SDCycleScrollView.h"
//#import "ScrollButtonView.h"
#import "BannerModel.h"
#import "CategoryModel.h"

@interface HomeBannerCell()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)SDCycleScrollView *bannerView;



@end


@implementation HomeBannerCell




- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self.contentView addSubview:self.bannerView];
}


- (SDCycleScrollView*)bannerView {
    
    if (!_bannerView) {
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,   IS_IPAD? 248 * iPadRatio : 155)
                                                delegate:self
                                            placeholderImage:imageName(HK_Placeholder)];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.autoScrollTimeInterval = 5.0;
        
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _bannerView.pageDotImage  =  [UIImage imageNamed:@"banner_gray"];
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"banner_select"];
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerView;
}


- (void)setBannerWithUrlArray:(NSArray*)array {
    
    if (array.count>0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i<array.count; i++) {
            
            //BannerModel *model = array[i];
            HKMapModel *model = array[i];
            [tempArray addObject:model.img_url];
        }
        self.bannerView.imageURLStringsGroup = tempArray;
    }
}


- (void)setClassArr:(NSMutableArray *)classArr {
    _classArr = classArr;
    
    NSMutableArray *titleArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *classArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<classArr.count; i++) {
        
        HomeCategoryModel *model = classArr[i];
        if (isEmpty(model.name)) {
            [titleArray addObject:@"1"];
        }else{
            [titleArray addObject:model.name];
        }
        
        if (isEmpty(model.icon_url)) {
            [imageArray addObject:@"1"];
        }else{
            //[imageArray addObject:@"1"];
            [imageArray addObject:model.icon_url];
        }
        
//        if (isEmpty(model.className)) {
//            [classArray addObject:@"1"];
//        }else{
//            [classArray addObject:model.className];
//        }
    }
//    [self setScorllView:titleArray images:imageArray];
}


//#pragma mark - 创建滚动视图
//- (void)setScorllView:(NSMutableArray*)titles  images:(NSMutableArray*)images {
//    
//    //NSArray * titles =  @[@"字体设计",@"海报设计",@"综合设计",@"软件基础"]; //@[@"字体设计",@"海报设计",@"综合设计",@"软件基础",@"C4D教程",@"字体设计",@"C4D教程",@"字体设计"];
//    //NSArray * images = @[@"ziti",@"haibao",@"zonghe",@"ruanjian"];
//    ScrollButtonView * topView = [[ScrollButtonView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 100)
//                                                           andTitlesArr:titles
//                                                            andImageArr:images
//                                                            andTapBlock:^(NSInteger index) {
//                                                                //点击按钮的回调
//                                                                //NSLog(@"%ld",index);
//                                                                if ([self.delegate respondsToSelector:@selector(homeBannerSelectBtnToIndex:)]) {
//                                                                    [self.delegate homeBannerSelectBtnToIndex:index];
//                                                                }
//    }];
//    [self.contentView addSubview:topView];
//    WeakSelf;
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.bannerView.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
//    }];
//}






#pragma mark -- 点击第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(homeBanner:didSelectItemAtIndex:)]) {
        [self.delegate homeBanner:cycleScrollView didSelectItemAtIndex:index];
    }
}


#pragma mark -- 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
    
    if ([self.delegate respondsToSelector:@selector(homeBanner:didScrollToIndex:)]) {
        [self.delegate homeBanner:cycleScrollView didScrollToIndex:index];
    }
    
}




@end
