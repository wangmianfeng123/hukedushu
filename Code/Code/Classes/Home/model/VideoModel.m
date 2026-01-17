//
//  VideoModel.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+(NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"teacher":[HKLiveTeachModel class]};
}

//-(NSString *)video_titel{
//    return _video_titel.length ? _video_titel : _title;
//}


- (NSString*)video_titel {
    return isEmpty(_video_titel) ?_video_title :_video_titel;
}

@end


@implementation CollectionListModel

@end


@implementation C4DHeadModel

@end

