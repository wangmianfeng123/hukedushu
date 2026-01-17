//
//  MyInfoCellVisibleConfig.h
//  Code
//
//  Created by Ivan li on 2018/6/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MyInfoCellVisibleType){
    MyInfoCellVisibleType_None = 0,
    MyInfoCellVisibleType_Shop = 1, //商城
    MyInfoCellVisibleType_Share,    //分享
    MyInfoCellVisibleType_Service, //客服
    MyInfoCellVisibleType_Set, //设置
    MyInfoCellVisibleType_Version //版本
};


@interface MyInfoCellVisibleConfig : NSObject

/** 虎课商城 */
@property (nonatomic, assign) BOOL isHkShopCellVisible;
/** 分享 */
@property (nonatomic, assign) BOOL isShareCellVisible;
/** 客服小姐 */
@property (nonatomic, assign) BOOL isServiceCellVisible;
/** 设置 */
@property (nonatomic, assign) BOOL isSetCellVisible;
/** 更新版本 */
@property (nonatomic, assign) BOOL isVersionCellVisible;


- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
