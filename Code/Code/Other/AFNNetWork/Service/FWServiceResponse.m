//
//  FWServiceResponse.m
//  FamousWine
//
//  Created by pg on 15/12/4.
//  Copyright © 2015年 pg. All rights reserved.
//

#import "FWServiceResponse.h"

@implementation FWServiceResponse


- (instancetype)initWithJsonData:(id)responseObject {
    if (self = [super init]) {
        self.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        self.msg  = [responseObject objectForKey:@"msg"];
        self.data = [responseObject objectForKey:@"data"];
    }
    return self;
}


@end
