//
//  HKPlayerPlayRate.m
//  Code
//
//  Created by Ivan li on 2019/12/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalPlayerPlayRate.h"

@implementation ZFHKNormalPlayerPlayRate

+ (NSString*)normalPlayerPlayRate {
    
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    NSString *rate = @"1.0x";
    if (0 == state) {
        NSInteger index = [HKNSUserDefaults integerForKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
        switch (index) {
                case 0:
                // 默认倍速 1
                    rate = @"1.0x";
                    break;
                
                case 1:
                    rate = @"0.75x";
                    break;
                
                case 2:
                    rate = @"1.0x";
                    break;
                
                case 3:
                    rate = @"1.25x";
                    break;
                
                case 4:
                    rate = @"1.5x";
                    break;
                
                case 5:
                    rate = @"2.0x";
                    break;
                
                case 6:
                    rate = @"3.0x";
                break;
                
            default:
                break;
        }
        return rate;
    }else{
        return rate;
    }
}



+ (CGFloat)normalPlayerPlayRateFloat {
    
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    CGFloat rate = 1.0;
    if (0 == state) {
        NSInteger index = [HKNSUserDefaults integerForKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
        switch (index) {
                case 0:
                // 默认倍速 1
                    rate = 1.0;
                    break;
                
                case 1:
                    rate = 0.75;
                    break;
                
                case 2:
                    rate = 1.0;
                    break;
                
                case 3:
                    rate = 1.25;
                    break;
                
                case 4:
                    rate = 1.5;
                    break;
                
                case 5:
                    rate = 2.0;
                    break;
                
                case 6:
                    rate = 3.0;
                    break;
                
            default:
                break;
        }
//        if (index>0) {
//            rate = ((index -1) * 0.25) + 0.75;
//        }
        return rate;
    }else{
        return rate;
    }
}




+ (NSString*)normalPlayerPlayRateWithIndex:(NSInteger)index {
    NSString *rate = @"1.0x";
    switch (index) {
           case 0:
               rate = @"0.75x";
               break;
           
           case 1:
               rate = @"1.0x";
               break;
           
           case 2:
               rate = @"1.25x";
               break;
           
           case 3:
               rate = @"1.5x";
               break;
           
           case 4:
               rate = @"2.0x";
               break;
            
            case 5:
                rate = @"3.0x";
            break;
           
       default:
           break;
    }
    return rate;
}





+ (NSInteger)normalPlayerPlayRateIndexWithRateStr:(NSString*)rateStr {
    
    if ([rateStr isEqualToString:@"0.75x"]) {
        return 1;
    }
    
    if ([rateStr isEqualToString:@"1.0x"]) {
        return 2;
    }
    
    if ([rateStr isEqualToString:@"1.25x"]) {
        return 3;
    }
    
    if ([rateStr isEqualToString:@"1.5x"]) {
        return 4;
    }
    
    if ([rateStr isEqualToString:@"2.0x"]) {
        return 5;
    }
    if ([rateStr isEqualToString:@"3.0x"]) {
        return 6;
    }
    return 2;
}




+ (NSInteger )normalPlayerPlayRateIndex {
    
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    if (0 == state) {
        // 开启了记录倍速
        NSInteger index = [HKNSUserDefaults integerForKey:HKPlayerPlayRate];
        if (0 == index) {
            // 默认倍速 1
            index = 2;
        }
        [HKNSUserDefaults synchronize];
        return index;
    }else{
        return 2;
    }
}



///存储播放速率（编号）
+ (void)saveNormalPlayerPlayRate:(NSInteger)selected {
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    if (0 == state) {
        [HKNSUserDefaults setInteger:selected forKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
    }
}

@end
