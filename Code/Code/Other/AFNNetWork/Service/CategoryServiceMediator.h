//
//  CategoryServiceMediator.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryServiceMediator : NSObject

+ (CategoryServiceMediator *)sharedInstance;

#pragma mark -  //软件入门(学习路径)列表页
- (void)softwareList:(void (^)(FWServiceResponse *response))completion failBlock:(Failure)failBlock;


#pragma mark - //系列课列表页
- (void)seriseCourseListWithClassId:(NSString*)classId  completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock;

@end
