//
//  HKvipImage.h
//  Code
//
//  Created by Ivan li on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKvipImage : UIImage


/**
 用户VIP 图片 （用户中心）
 
 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
+ (UIImage*)user_vipImageWithType:(NSString *)type;
    
    
/**
 评论内容中  用户VIP 图片
 
 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
+ (UIImage*)comment_vipImageWithType:(NSString*)type;

@end
