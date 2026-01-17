//
//  HKAchieveTool.h
//  Code
//
//  Created by Ivan li on 2018/12/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKCertificateModel;

NS_ASSUME_NONNULL_BEGIN


@interface HKAchieveTool : NSObject

/**  证书 勋章 弹窗 */
+ (void)setDialogWithModel:(HKCertificateModel*)model;
+ (void)setMedalViewWithModel:(HKCertificateModel*)model;
@end

NS_ASSUME_NONNULL_END
