//
//  HKAudioHotVC.h
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKAudioHotVC : HKBaseVC

/**0-综合排序 1-最热 2-最新 */
- (instancetype)initWithCategory:(NSString*)category name:(NSString*)name;

@end
