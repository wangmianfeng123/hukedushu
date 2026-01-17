//
//  HKNewDeviceTrainModel.h
//  Code
//
//  Created by Ivan li on 2020/11/19.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKNewDeviceTrainModel : NSObject

@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * teacher_qrcode;
@property (nonatomic, copy)NSString * teacher_qrcode_channel;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * display;
@property (nonatomic, copy)NSString * img;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * start;

@end

NS_ASSUME_NONNULL_END
