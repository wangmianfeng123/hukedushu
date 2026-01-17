//
//  HKImageTextVC.h
//  Code
//
//  Created by eon Z on 2022/4/24.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKImageTextVC : HKBaseVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model;
- (void)setVideoInfoWithModel:(DetailModel*)videlDetailModel ;
@end

NS_ASSUME_NONNULL_END
