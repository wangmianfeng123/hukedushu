//
//  HKPopSignView.h
//  Code
//
//  Created by Ivan li on 2017/11/16.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKPopSignView : UIView


@property (nonatomic,copy)void(^selectBlock)(NSString *str); //选择回调

@end
