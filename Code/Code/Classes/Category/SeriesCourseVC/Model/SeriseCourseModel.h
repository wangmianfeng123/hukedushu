//
//  SeriseCourseModel.h
//  Code
//
//  Created by Ivan li on 2017/10/25.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriseCourseModel : NSObject
//update_status：0-已完结 1-更新中；watch_nums：观看次数

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *video_id;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *cover; ///图片路径

@property(nonatomic,copy)NSString *summary;

@property(nonatomic,copy)NSString *watch_nums;

@property(nonatomic,copy)NSString *update_status; //更新

@property(nonatomic,copy)NSString *lesson_total;  //教程数量
/** 总课时*/
@property(nonatomic,assign)NSInteger total_course;
/** 已更新课时*/
@property(nonatomic,assign)NSInteger update_course;
// 图文教程
@property(nonatomic,assign)BOOL has_pictext;

@end




@interface SeriseTagModel : NSObject

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *name;
/** 标记 标签选中 */
@property(nonatomic,assign)BOOL isSelected;
/**  专辑ID */
@property(nonatomic,copy)NSString *label_id;

@end


@interface SeriseListModel : NSObject

@property (nonatomic, strong)NSMutableArray <SeriseTagModel*> *lesson_class;
@property (nonatomic, strong)NSMutableArray <SeriseCourseModel*> *lesson_list;

@end









//"lesson_class": [
//                 {
//                     "id": "6",
//                     "name": "平面设计"
//                 },
//                 {
//                     "id": "7",
//                     "name": "电商设计"
//                 }
//                 ],
//"lesson_list": [
//                {
//
//                },
//                {
//                    "title": "摄影后期APP推荐-Snapseed",
//                    "cover": "http://pic.huke88.com/lesson/cover/2017-09-30/0E9C371D-FCAB-025F-377F-5F86F51461C1.jpg",
//                    "summary": "本套教程介绍一款十分好用的图片处理app。。.实用性非常高。",
//                    "watch_nums": "379",
//                    "update_status": "0",
//                    "lesson_total": "7"
//                }











