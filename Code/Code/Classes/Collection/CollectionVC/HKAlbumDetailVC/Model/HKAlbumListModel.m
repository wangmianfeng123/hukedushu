//
//  HKAlbumModel.m
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKAlbumListModel.h"

@implementation HKAlbumListModel


+ (NSDictionary*)mj_objectClassInArray {
    
    return @{@"video_list":[VideoModel class]};
}

@end
