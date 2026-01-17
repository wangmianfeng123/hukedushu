//
//  BannerModel.m
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id"};
}

@end


@implementation fieldModel

@end



@implementation AdvertParameterModel



@end


@implementation HomeAdvertModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[AdvertParameterModel class]};
    
}

- (NSString *)className {
    NSString * name =_className.length? _className : _class_name;
    if ([name isEqualToString:@"DesignTableVC"]) {
        name = @"HKDesignCategoryVC";
    }
    
    return name;
}


- (NSString *)class_name {
    NSString * name =_class_name.length? _class_name : _className;
    if ([name isEqualToString:@"DesignTableVC"]) {
        name = @"HKDesignCategoryVC";
    }
    return name;
}
@end





@implementation HKMapModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":[AdvertParameterModel class]};
    
}

- (NSString *)className {
    return _className.length? _className : _class_name;
}


- (NSString *)class_name {
    return _class_name.length? _class_name : _className;
}


- (NSString *)ad_id {
    return _ad_id.length? _ad_id : _bannerId;
}


- (NSString *)bannerId {
    return _bannerId.length? _bannerId : _ad_id;
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"bannerId" : @"id"};
}


@end


