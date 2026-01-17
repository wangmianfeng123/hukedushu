//
//  HKScrollTextCell.m
//  Code
//
//  Created by ivan on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKScrollTextCell.h"
#import <SDCycleScrollView.h>
#import "HKAchievementModel.h"
#import "NSMutableAttributedString+HKAttributed.h"
#import "HKScrollTextChildCell.h"
#import "HKCustomMarginLabel.h"



@interface HKScrollTextCell ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@end


@implementation HKScrollTextCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF_3D4752;
        [self.contentView addSubview:self.cycleScrollView];
    }
    return self;
}



- (SDCycleScrollView*)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 13, SCREEN_WIDTH-30, 24) delegate:self placeholderImage:nil];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"ddd");
        };
        _cycleScrollView.titleLabelBackgroundColor = COLOR_FFF0E6;
        _cycleScrollView.titleLabelTextColor = COLOR_FF7820;
        _cycleScrollView.titleLabelTextFont = HK_FONT_SYSTEM(12);
        [_cycleScrollView setRoundedCorners:UIRectCornerAllCorners radius:12];
    }
    return _cycleScrollView;
}


- (void)setTitlesArray:(NSMutableArray<HKAchievementModel *> *)titlesArray {
    _titlesArray = titlesArray;
    if (DEBUG) {
        NSMutableArray *titles = [NSMutableArray new];
        [titlesArray enumerateObjectsUsingBlock:^(HKAchievementModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [NSString stringWithFormat:@"%@获得%@证书",obj.username,obj.name];
            
            NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:HK_FONT_SYSTEM(12)Color:COLOR_7B8196 TotalString:str
                                                                                   SubStringArray:@[@"获得",@"证书"]];
            [titles addObject:attributed];
        }];
        _cycleScrollView.titlesGroup = [titles copy];
    }
}




- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    
    return [HKScrollTextChildCell class];
}


- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
        
    HKScrollTextChildCell *childCell = (HKScrollTextChildCell*)cell;
    childCell.textLB.attributedText = view.titlesGroup[index];
    
}


@end
