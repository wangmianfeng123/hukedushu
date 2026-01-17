//
//  HKCategoryAlbumModel.m
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCategoryAlbumModel.h"
#import "HKContainerModel.h"


@implementation AlbumSortTagModel

@end



@implementation AlbumSortTagListModel

+ (NSDictionary*)mj_objectClassInArray {
    return  @{@"children" : [AlbumSortTagModel class]};
}

@end


@implementation HKCategoryAlbumModel

+ (NSDictionary*)mj_objectClassInArray {
    return  @{@"album_list" : [HKAlbumModel class], @"label_list" : [AlbumSortTagListModel class],@"labels" : [AlbumSortTagModel class]};
}

@end



