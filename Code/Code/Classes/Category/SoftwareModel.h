//
//  SoftwareModel.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface SoftwareModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *small_img_url;

@property(nonatomic,copy)NSString *route_id;

@property(nonatomic,copy)NSString *tag_id;

@property(nonatomic,copy)NSString *master_video_total; 

@property(nonatomic,copy)NSString *slave_video_total;

@property(nonatomic,copy)NSString *anchor_video_id;

@property(nonatomic,copy)NSString *video_id;

@property (nonatomic, copy)NSString *simple_introduce;

@property (nonatomic, assign)BOOL is_end;

@property (nonatomic, copy)NSString *study_num;

@property (nonatomic, copy)NSString *img_url;

@property (nonatomic,strong) HKMapModel *redirect_package;

@end
