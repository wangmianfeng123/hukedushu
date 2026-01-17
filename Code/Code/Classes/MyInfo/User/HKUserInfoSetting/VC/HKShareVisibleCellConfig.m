//
//  HKShareVisibleCellConfig.m
//  Code
//
//  Created by Ivan li on 2018/6/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKShareVisibleCellConfig.h"
#import <UMShare/UMShare.h>

@implementation HKShareVisibleCellConfig



- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 3:
            return (self.isWeiXinCellVisible );
            break;
        case 4:
            return (self.isQQCellVisible );
            break;
        case 5:
            return (self.isWeiBoCellVisible );
            break;
    }
    return 0;
}




- (BOOL)isWeiXinCellVisible {
    if (nil == self.userM) {
        return NO;
    }
    return [WXApi isWXAppInstalled];
}

- (BOOL)isQQCellVisible {
    if (nil == self.userM) {
        return NO;
    }
    return [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ];
}

- (BOOL)isWeiBoCellVisible {
    if (nil == self.userM) {
        return NO;
    }
    return [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Sina];
}




@end
