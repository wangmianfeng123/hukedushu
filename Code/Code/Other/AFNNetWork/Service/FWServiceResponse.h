//
//  FWServiceResponse.h
//  FamousWine
//
//  Created by pg on 15/12/4.
//  Copyright © 2015年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWServiceResponse : NSObject

@property (nonatomic, copy) NSString      *errorCode;     //返回码0:成功 其他失败
@property (nonatomic, copy) NSString      *errorMessage;  //返回错误描述信息
@property (nonatomic, strong) id            tokenObj;       //请求的方法

@property (nonatomic, strong) NSError       *error;         //返回的请求错误信息
@property (nonatomic, copy) NSString        *code;
@property (nonatomic, copy) NSString        *msg;
@property (nonatomic, copy) NSString        *password;

@property (nonatomic, strong) NSDictionary   *data;

@property (nonatomic, strong) NSDictionary  *result;
@property (nonatomic, strong) NSMutableArray   *dataArray;


- (instancetype)initWithJsonData:(id)responseObject;


@end
