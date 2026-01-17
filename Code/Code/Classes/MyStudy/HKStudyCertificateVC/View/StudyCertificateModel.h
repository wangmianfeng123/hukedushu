//
//  StudyCertificateModel.h
//  Code
//
//  Created by Ivan li on 2018/5/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 学习 证书 model */
@interface StudyCertificateModel : NSObject

@property(nonatomic,copy)NSString *cert_img_url;

@property(nonatomic,copy)NSString *name;
/** 证书 ID */
@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *software_name;

@property(nonatomic,copy)NSString *username;
/** 证书 获得 日期 */
@property(nonatomic,copy)NSString *date;


@end
