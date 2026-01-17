//
//  HKShareVisibleCellConfig.h
//  Code
//
//  Created by Ivan li on 2018/6/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HKUserModel;

@interface HKShareVisibleCellConfig : NSObject

/** 微信 */
@property (nonatomic, assign) BOOL isWeiXinCellVisible;
/** QQ */
@property (nonatomic, assign) BOOL isQQCellVisible;
/** 微博 */
@property (nonatomic, assign) BOOL isWeiBoCellVisible;

@property (nonatomic, strong) HKUserModel *userM;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
