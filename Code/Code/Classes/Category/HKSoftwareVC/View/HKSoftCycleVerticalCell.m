//
//  HKSoftCycleVerticalCell.m
//  Code
//
//  Created by yxma on 2020/8/31.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSoftCycleVerticalCell.h"
#import "ELCycleVerticalView.h"
#import "UIView+HKLayer.h"
#import "HKBookModel.h"

#define  txtLength 10

@interface HKSoftCycleVerticalCell ()<ELCycleVerticalViewDelegate>
@property (nonatomic, strong) NSMutableArray * txtArray;
@end

@implementation HKSoftCycleVerticalCell

- (NSMutableArray *)txtArray{
    if (!_txtArray) {
        _txtArray = [NSMutableArray array];
    }
    return _txtArray;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.contentView removeAllSubviews];
    [self.txtArray removeAllObjects];
    for (int i = 0; i<dataArray.count; i++) {
        if (i<10) {
            HKUserFetchCerModel * model = self.dataArray[i];
            NSString * cerName  = model.name;
            if (model.name.length>txtLength) {
                cerName = [NSString stringWithFormat:@"%@...",[model.name substringToIndex:txtLength]];
            }
            
            NSString * userName = model.username;
            if (model.username.length > txtLength) {
                userName = [NSString stringWithFormat:@"%@...",[model.username substringToIndex:txtLength]];
            }
            NSString * txt = [NSString stringWithFormat:@"%@获得%@证书",userName,cerName];
            [self.txtArray addObject:txt];
        }
    }
    
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(PADDING_15, 5, SCREEN_WIDTH - 2 * PADDING_15, 24)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    [self.contentView addSubview:bgView];
    [bgView addCornerRadius:12];
    
    ELCycleVerticalView *cycVerticalView = [[ELCycleVerticalView alloc] initWithFrame:CGRectMake(20, 0, bgView.width - 2 * 20, 24)];
    cycVerticalView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    cycVerticalView.delegate = self;
    [bgView addSubview:cycVerticalView];
    [cycVerticalView configureShowTime:2 animationTime:1
                             direction:ELCycleVerticalViewScrollDirectionUp
                       backgroundColor:[UIColor clearColor]
                             textColor:[UIColor colorWithHexString:@"#7B8196"]
                                  font:[UIFont systemFontOfSize:12]
                         textAlignment:NSTextAlignmentLeft];
    cycVerticalView.dataSource = self.txtArray;
}

- (void)elCycleVerticalView:(ELCycleVerticalView *)view didClickItemIndex:(NSInteger)index{
    NSLog(@"%ld", (long)index);
    [MobClick event:ruanjianrumen_lunbo];
    HKUserFetchCerModel * model = self.dataArray[index];
    if (self.itemClickBlock) {
        self.itemClickBlock(model);
    }
}

@end
