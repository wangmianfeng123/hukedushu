
//
//  HKContainerModel.m
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKContainerModel.h"


@implementation HKAlbumModel
+ (NSDictionary*)mj_objectClassInArray {
    return  @{@"video":[VideoModel class]};
}

@end

@implementation HKContainerModel

+ (NSDictionary*)mj_objectClassInArray {
    return  @{@"album_list" : [HKAlbumModel class]};
}

@end
