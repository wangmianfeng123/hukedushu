//
//  HKvipImage.m
//  Code
//
//  Created by Ivan li on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKvipImage.h"

@implementation HKvipImage


/**
 评论内容中  用户VIP 图片

 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
+ (UIImage*)comment_vipImageWithType:(NSString*)type {
    UIImage *image = nil;
    
    switch ([type intValue]) {
        case HKVipType_No:
            break;
            
        case HKVipType_Separator:
            image = imageName(@"ic_vip_round_classify");
            break;
            
        case HKVipType_OneYear:
            image = imageName(@"ic_vip_round_quanzhantong");
            break;
            
        case HKVipType_WholeLife:
            image = imageName(@"ic_vip_round_zhongshen");
            break;
            
        case HKVipType_Group:
            image = imageName(@"ic_vip_round_taocan");
            break;
            
        case HKVipType_Separator5Days:
            image = imageName(@"ic_vip_round_classify");
            break;
    }
    
    return image;
}



/**
 用户VIP 图片 （用户中心）
 
 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
+ (UIImage*)user_vipImageWithType:(NSString *)type {
    UIImage *image = nil;
    
    switch ([type intValue]) {
        case HKVipType_No:
            break;
            
        case HKVipType_Separator:
            image = imageName(@"vip_part");
            break;
            
        case HKVipType_OneYear:
            image = imageName(@"vip_all");
            break;
            
        case HKVipType_WholeLife:
            image = imageName(@"vip_all_whole_life");
            break;
            
        case HKVipType_Group:
            image = imageName(@"ic_vip_taocan");
            break;
            
        case HKVipType_Separator5Days:
            image = imageName(@"vip_part");
            break;
    }
    return  image;
}


/*
switch ([type intValue]) {
    case 0:
        break;
    case 1:
        image = imageName(@"vip_part");
        break;
    case 2:
        image = imageName(@"vip_all");
        break;
    case 3:
        image = imageName(@"vip_all_whole_life");
        break;
    case 4:
        image = imageName(@"ic_vip_taocan");
        break;
}
*/


@end











