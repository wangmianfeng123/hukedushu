//
//  HKCarouselCell.m
//  Code
//
//  Created by Ivan li on 2021/6/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCarouselCell.h"
#import "XBTextLoopView.h"
#import "ELCycleVerticalView.h"
#import "UIView+HKLayer.h"
#import "HKBookModel.h"
#import "HKMonmentTypeModel.h"

#define  txtLenth 10

@interface HKCarouselCell ()<ELCycleVerticalViewDelegate>
@property (nonatomic , strong) XBTextLoopView *loopView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSMutableArray * txtArray;
@property (nonatomic, strong) NSMutableArray * messageArray;

@end

@implementation HKCarouselCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSMutableArray *)txtArray{
    if (!_txtArray) {
        _txtArray = [NSMutableArray array];
    }
    return _txtArray;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.contentView removeAllSubviews];
    [self.txtArray removeAllObjects];
    [self.messageArray removeAllObjects];
    
    
    for (int i = 0; i<dataArray.count; i++) {
        HKCarouselModel * model = self.dataArray[i];
        NSString * userName = model.username;
        if (model.username.length > txtLenth) {
            userName = [NSString stringWithFormat:@"%@...  ",[model.username substringToIndex:txtLenth]];
        }
        NSString * txt = [NSString stringWithFormat:@"%@  %@",userName,model.message];
        [self.txtArray addObject:txt];
        [self.messageArray addObject:model.message];
    }
    
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(PADDING_15, 15, SCREEN_WIDTH - 2 * PADDING_15, 24)];
    bgView.backgroundColor = COLOR_F8F9FA_333D48;
    [self.contentView addSubview:bgView];
    [bgView addCornerRadius:12];
    
    UILabel * label = [UILabel labelWithTitle:CGRectMake(bgView.width - 110, 0, 100, 24) title:@"100%回复" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentRight];
    [bgView addSubview:label];
    
    ELCycleVerticalView *cycVerticalView = [[ELCycleVerticalView alloc] initWithFrame:CGRectMake(10, 0, bgView.width - 110, 24)];
    cycVerticalView.backgroundColor = [UIColor clearColor];
    cycVerticalView.delegate = self;
    [bgView addSubview:cycVerticalView];
    [cycVerticalView configureShowTime:2 animationTime:1
                             direction:ELCycleVerticalViewScrollDirectionUp
                       backgroundColor:[UIColor clearColor]
                             textColor:[UIColor colorWithHexString:@"#7B8196"]
                                  font:[UIFont systemFontOfSize:12]
                         textAlignment:NSTextAlignmentLeft];
    cycVerticalView.messageArray = self.messageArray;
    cycVerticalView.dataSource = self.txtArray;
}

- (void)elCycleVerticalView:(ELCycleVerticalView *)view didClickItemIndex:(NSInteger)index{
    NSLog(@"%ld", (long)index);
    HKCarouselModel * model = self.dataArray[index];
    if (self.didItemBlock) {
        self.didItemBlock(model);
    }
}


@end
