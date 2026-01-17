//
//  HKPhoneLoginViewModel.h
//  Code
//
//  Created by ivan on 2020/6/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPhoneLoginViewModel : NSObject

+ (RACSignal *)signalLoginWithWithPhone:(NSString *)phone code:(NSString *)code;

+ (RACSignal *)signalLoginWithUnionId:(NSString*)unionId
                                 name:(NSString*)name
                               openid:(NSString*)openid
                              iconurl:(NSString*)iconurl
                           clientType:(NSString*)clientType
                         registerType:(NSString*)registerType
                           jsonString:(NSString*)string;


+ (RACSignal *)signalUMSocialLoginForPlatform:(UMSocialPlatformType)platformType
                  currentViewController:(UIViewController*)currentViewController;

@end

NS_ASSUME_NONNULL_END
