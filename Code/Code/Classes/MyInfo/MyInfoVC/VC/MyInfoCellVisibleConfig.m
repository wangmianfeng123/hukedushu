//
//  MyInfoCellVisibleConfig.m
//  Code
//
//  Created by Ivan li on 2018/6/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "MyInfoCellVisibleConfig.h"
#import "CommonFunction.h"

@implementation MyInfoCellVisibleConfig



- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 3:
            return self.isHkShopCellVisible;
            break;
        case 4:
            return self.isShareCellVisible;
            break;
        case 5:
            return self.isServiceCellVisible;
            break;
        case 6:
            return self.isServiceCellVisible;
            break;
        case 7:
            return self.isVersionCellVisible;
            break;
    }
    return 0;
}


- (void)didSelectedRowAtSection:(NSInteger)section {
    
    switch (section) {
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
    }
}



- (BOOL)isServiceCellVisible {
    return YES;
}

- (BOOL)isSetCellVisible {
    return YES;
}

- (BOOL)isVersionCellVisible {
    
    return [CommonFunction isLatestVersion];
}


@end









