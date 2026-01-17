//
//  HKProductBookCommentVC.h
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKProductBookCommentVC : HKBaseVC

- (void)allRedBtnClicked;

@property (nonatomic, copy)void(^unread_msg_totalBlock)(NSString *unread_msg_total, int index);

@property (nonatomic, assign)int index;

@end

NS_ASSUME_NONNULL_END
