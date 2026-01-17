//
//  HKTaskTopView.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTaskTopView.h"
#import "HKPunchCardView.h"
#import "HKTrainDetailModel.h"
#import "UIView+HKLayer.h"

@interface HKTaskTopView ()<HKPunchCardViewDelegate>{
    CGFloat topMargin;
    NSInteger itemCount ;
    CGFloat centerMargin;
    CGFloat h;
}
@property (nonatomic, strong) UIView * bgView;

@end

@implementation HKTaskTopView

-(UIView*)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

-(void)setDetailModel:(HKTrainDetailModel *)detailModel{
    _detailModel = detailModel;
    [self.bgView removeAllSubviews];
    [self createSubViews];
}

- (void)createSubViews{
    [self addSubview:self.bgView];
    
    itemCount  = _detailModel.task_list.list.count;
    topMargin = 20;
    centerMargin = 10;
    h = 102;
    
    CGFloat leftMargin = 15;
    CGFloat x = leftMargin;
    CGFloat w = SCREEN_WIDTH - 4 * leftMargin;
    CGFloat y= 0;
    
    self.bgView.frame = CGRectMake(leftMargin, topMargin, SCREEN_WIDTH - 2*leftMargin, topMargin * 2 + itemCount * h+ 190 + itemCount*centerMargin);
    [self.bgView addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#56E1A7"].CGColor,(id)[UIColor colorWithHexString:@"#33CEB2"].CGColor]];
    
    //特殊任务
    for (int i = 0; i< _detailModel.task_list.list.count; i++) {
        y = topMargin +(centerMargin + h)*i;
        HKPunchCardView * subV= [HKPunchCardView createViewByFrame:CGRectMake(x, y, w, h)];
        subV.taskModel = _detailModel.task_list.list[i];
        subV.frame = CGRectMake(x, y, w, h);
        subV.delegate = self;
        [self.bgView addSubview:subV];
    }

    if (_detailModel.task_list.list.count == 0) {
        y = topMargin;
    }else{
        y += centerMargin + h;
    }
    
    //作业打卡
    HKPunchCardView * subV= [HKPunchCardView createViewByFrame:CGRectMake(x, y, w, 190)];
    subV.task_list = _detailModel.task_list;
    subV.detailModel = self.detailModel;
    subV.delegate = self;
    subV.frame = CGRectMake(x, y, w, 190);
    [self.bgView addSubview:subV];
}

- (CGFloat)cellHight{
    CGFloat height = topMargin * 2 + itemCount * h + itemCount*centerMargin+topMargin + 190;
    return height;
}

-(void)punchCardViewDidTaskView:(HKAllTrainTaskModel *)allModel withTaskModel:(HKTrainTaskModel *)taskModel{
    if (self.punchViewClickBlock) {
        self.punchViewClickBlock(allModel, taskModel);
    }
}
@end
