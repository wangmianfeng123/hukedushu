//
//  HKVideoDetailBuyPgcView.h
//  Code
//
//  Created by Ivan li on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLineLabel.h"

@class HKCustomMarginLabel;

@class DetailModel;

@class HKLineLabel;


@protocol HKVideoDetailBuyPgcViewDelegate <NSObject>

@optional
- (void)buyPgcCourse:(id)sender;

@end

@interface HKVideoDetailBuyPgcView : UIView
/** 立即购买 */
@property(nonatomic,strong)UIButton *immediateOpenBtn;
/** 价格背景 */
@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)HKCustomMarginLabel *priceLabel;
/** 有效时间 */
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,weak)id <HKVideoDetailBuyPgcViewDelegate> delegate;

@property(nonatomic,strong)DetailModel *model;
/** 划横线 价格 */
@property(nonatomic,strong)HKLineLabel *oldPriceLabel;
/** 折扣 */
@property(nonatomic,strong)HKCustomMarginLabel *discountLabel;
/** VIP 折扣*/
@property(nonatomic,strong)HKCustomMarginLabel *vipDiscountLabel;

@end



