//
//  HKOneYearProtocolCell.h
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKOneYearProtocolCell : UITableViewCell
@property (nonatomic, assign) BOOL isOpenAutoBuy;
@property (nonatomic, copy) void(^seletBtnBlock)(BOOL selected);
@property(nonatomic,copy)void(^agreementBtnBlock)();
@property(nonatomic,copy)void(^autoBuyBtnBlock)();
//@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
