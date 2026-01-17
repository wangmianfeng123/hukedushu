//
//  HKBookTabMainBannerCell.m
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTabMainBannerCell.h"
#import "HW3DBannerView.h"


@interface HKBookTabMainBannerCell()

@property (nonatomic,strong) HW3DBannerView *scrollView;

@end


@implementation HKBookTabMainBannerCell


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
    
    // 根据设备设置宽高
    CGFloat realHeight = (SCREEN_WIDTH - 30.0) * 240.0 / 690.0;
    
    // 滚动
    self.scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, realHeight) imageSpacing:8 imageWidth:SCREEN_WIDTH - 30];
    _scrollView.initAlpha = 0.5; // 设置两边卡片的透明度
    _scrollView.imageRadius = 5.0; // 设置卡片圆角
    _scrollView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
    // 设置要加载的图片
    self.scrollView.data = @[];
    self.scrollView.autoScrollTimeInterval = 5.0;
    self.scrollView.otherPageControlColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.scrollView.curPageControlColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.scrollView.placeHolderImage = [UIImage imageNamed:HK_Placeholder]; // 设置占位图片
    [self addSubview:self.scrollView];
    
    WeakSelf;
    self.scrollView.clickCenterBlock = ^(NSInteger currentIndex) {
        // 点击中间图片的回调
        if ([weakSelf.delegate respondsToSelector:@selector(homeBanner:didSelectItemAtIndex:)]) {
            [weakSelf.delegate homeBanner:weakSelf.scrollView didSelectItemAtIndex:currentIndex];
        }
        if (weakSelf.didSelectItemblock) {
            weakSelf.didSelectItemblock(weakSelf.scrollView,currentIndex);
        }
    };
}


- (void)setBannerWithUrlArray:(NSArray*)array {
    if (array.count>0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i<array.count; i++) {
            HKMapModel *model = array[i];
            [tempArray addObject:model.img_url];
        }
        self.scrollView.data = tempArray.copy;
    }
}



@end
