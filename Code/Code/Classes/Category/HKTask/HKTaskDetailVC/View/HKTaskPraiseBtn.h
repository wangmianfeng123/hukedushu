//
//  HKTaskPraiseBtn.h
//  Code
//
//  Created by Ivan li on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKTaskDetailModel;

@protocol HKTaskPraiseBtnDelegate <NSObject>

- (void)hktaskPraiseBtnClick:(UIButton*)sender;

@end



@interface HKTaskPraiseBtn : UIButton

@property(nonatomic,weak)id <HKTaskPraiseBtnDelegate> delegate;

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *titleLB;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong)HKTaskDetailModel *model;


@end
