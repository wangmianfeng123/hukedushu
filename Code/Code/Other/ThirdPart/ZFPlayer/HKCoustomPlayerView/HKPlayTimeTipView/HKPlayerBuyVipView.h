//
//  HKBuyVipView.h
//  Code
//
//  Created by Ivan li on 2018/9/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKZFNormalPlayerShareBtn,HKPermissionVideoModel;



@protocol HKBuyVipViewDelegate <NSObject>
@optional
- (void)hKBuyVipViewShareAction:(id)sender;

- (void)hKBuyVipViewBuyVipAction:(UIButton*)sender;

- (void)hKBuyVipViewCollectVideoAction:(UIButton*)sender;

@end


@interface HKPlayerBuyVipView : UIView 

@property (nonatomic, strong) UIButton             *bottomVipBtn;

@property (nonatomic, strong) UIButton             *buyVipBtn;

@property (nonatomic, strong) UIButton             *collectBtn;

@property (nonatomic, strong) UILabel              *buyVipTipLabel; //提示无会员，不能继续观看视频

@property (nonatomic, strong)HKZFNormalPlayerShareBtn     *playerShareBtn;

@property (nonatomic, strong)HKPermissionVideoModel *permissionVideoModel;

@property (nonatomic, strong)DetailModel    *detailModel;

@property (nonatomic,weak)id <HKBuyVipViewDelegate>  delegate;

- (instancetype)initWithModel:(HKPermissionVideoModel*)permissionModel  detailModel:(DetailModel*)detailModel;

@end








