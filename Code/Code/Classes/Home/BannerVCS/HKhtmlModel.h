//
//  HKhtmlModel.h
//  Code
//
//  Created by Ivan li on 2018/8/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKMedalImgModel,HKMedalInfoModel,HKUserInfoModel,HKMedalModel;

@interface HKhtmlModel : NSObject


@property(nonatomic,copy)NSString *h5_url;

@property(nonatomic,assign)NSInteger num;


@end


@interface HKMedalModel : NSObject
@property (nonatomic , strong) HKMedalImgModel * images;
@property (nonatomic , strong) HKMedalInfoModel * medalInfo;
@property (nonatomic , strong) HKUserInfoModel * userInfo;

@end


@interface HKMedalImgModel : NSObject
@property (nonatomic , copy) NSString * backgroundImg;
@property (nonatomic , copy) NSString * logo;
@property (nonatomic , copy) NSString * qrCode;
@end


@interface HKMedalInfoModel : NSObject
@property (nonatomic , copy) NSString * completed_icon;
@property (nonatomic , copy) NSString * desc;
@property (nonatomic , copy) NSString * levelImg;
@property (nonatomic , copy) NSString * name;
@property (nonatomic , assign) int level;
@property (nonatomic , assign) int order;
@end


@interface HKUserInfoModel : NSObject
@property (nonatomic , copy) NSString * avatar;
@property (nonatomic, copy)NSString * username;  //
@end
