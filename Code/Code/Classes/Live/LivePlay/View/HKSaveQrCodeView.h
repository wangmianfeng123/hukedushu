//
//  HKSaveQrCodeView.h
//  Code
//
//  Created by ivan on 2020/7/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKVersionModel;

@interface HKSaveQrCodeView : UIView

/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);
/** 更新Block*/
@property (nonatomic , copy ) void (^updateBlock)(void);

@property (nonatomic,strong) HKVersionModel *model;


/// 显示 下载弹框
/// @param model
/// @param updateBlock 下载block
+ (void)showDownAppViewWithModel:(nullable HKVersionModel *)model nextBlock:( void (^)(void) )nextBlock;

@end

NS_ASSUME_NONNULL_END

