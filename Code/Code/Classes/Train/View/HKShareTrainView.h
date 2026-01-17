//
//  HKShareTrainView.h
//  Code
//
//  Created by Ivan li on 2020/12/21.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKShareTrainView : UIView

@property (nonatomic , strong) void(^closeBlock)(void);
@property (nonatomic, copy)NSString *qrCodeURL;

@end

NS_ASSUME_NONNULL_END
