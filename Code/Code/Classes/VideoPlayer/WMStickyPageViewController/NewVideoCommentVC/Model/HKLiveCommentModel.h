//
//  HKLiveCommentModel.h
//  Code
//
//  Created by Ivan li on 2020/12/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKCommentUser,HKCommentImageModel;


@interface HKLiveCommentModel : NSObject

@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * score;  //
@property (nonatomic, strong)HKCommentUser * user;  //
@property (nonatomic, copy)NSArray * commentImages    ;  //
@property (nonatomic, strong)NSNumber * commentPraise;  //
@property (nonatomic, strong)NSNumber * canDelete;  //
@property (nonatomic, strong)NSNumber * vipType;  //
@property (nonatomic, copy)NSString * avator;  //
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, copy)NSString * praiseCount;  //
@property (nonatomic, copy)NSString * createdAt;  //
@property (nonatomic, copy)NSString * isStudyComment;  //
@property (nonatomic, strong)NSNumber * imagesCount;  //
@end

@interface HKCommentUser : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, copy)NSString * avator;  //
@end

@interface HKCommentImageModel : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * comment_id;  //
@property (nonatomic, copy)NSString * image_address;  //

@end

NS_ASSUME_NONNULL_END
