//
//  HKOtherProtocolCell.h
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKOtherProtocolCell : UITableViewCell

@property(nonatomic,strong)UIButton *agreementBtn;

@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)UIView *grayView;

@property(nonatomic,copy)void(^agreementBtnClickBlock)();

@property(nonatomic,copy)void(^selectBtnClickBlock)(BOOL isSelect);

@end

NS_ASSUME_NONNULL_END
