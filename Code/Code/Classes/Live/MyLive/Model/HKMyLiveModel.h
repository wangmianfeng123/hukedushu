//
//  HKMyLiveModel.h
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKMyLiveModel : NSObject
@property (nonatomic, copy)NSString * isStudy;  //
@property (nonatomic, copy)NSString * hasStudy;  //
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * smallid;  //
@property (nonatomic, copy)NSString * name;  //
@property (nonatomic, copy)NSString * type;  //
@property (nonatomic, copy)NSString * start_live_at;  //
@property (nonatomic, copy)NSString * end_live_at;  //
@property (nonatomic, copy)NSString * className;  //
@property (nonatomic, copy)NSString * live_status;  //
@property (nonatomic, copy)NSString * cover;  //

@property (nonatomic, strong)NSArray * teacher;  //

@end


@interface HKLiveTeachModel : NSObject
@property (nonatomic, copy)NSString * name;  //
@property (nonatomic, copy)NSString * avator;  //
@property (nonatomic, copy)NSString * uid;  //

@end

@interface HKClassListModel : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic , copy)NSString * name;
@property (nonatomic , strong) NSNumber * classVal;
/** 标签选中状态 */
@property (nonatomic , assign) BOOL tagSeleted;

@end

NS_ASSUME_NONNULL_END
