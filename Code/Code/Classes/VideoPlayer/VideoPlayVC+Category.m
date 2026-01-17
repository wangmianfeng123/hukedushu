//
//  VideoPlayVC+Category.m
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "VideoPlayVC+Category.h"
#import "HomeServiceMediator.h"
#import "HKDownloadModel.h"
#import "DetailModel.h"
#import "HKDownloadManager.h"
#import "HKSoftwareRecommenVC.h"
#import "HKSoftwareAchieveVC.h"
#import "HKGPRSSwitchView.h"
#import "QFTimePickerView.h"
#import "EventCalendar.h"
#import "BaseVideoViewController.h"
#import "HKAlarmClockView.h"
#import "HKPushNoticeModel.h"
#import "NSString+MD5.h"
#import "HKJobPathModel.h"

@implementation VideoPlayVC (Category)

- (void)addHKSoftwareRecommenVC {
    
    HKSoftwareRecommenVC *VC =  [HKSoftwareRecommenVC new];
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [VC didMoveToParentViewController:self];
}




/** 软件入门 成就 弹窗  */
- (void)setAchieveDialogWithModel:(DetailModel*)model {
    
    WeakSelf;
    __block HKSoftwareAchieveVC *VC =  [HKSoftwareAchieveVC new];
    VC.model = model;
    VC.removeVCBlcok = ^(NSMutableArray *array, NSString *softwareName) {
        [weakSelf setSuggestVideoDialogWithArray:array softwareName:softwareName];
    };
    
    VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addChildViewController:VC];
    VC.view.y = SCREEN_HEIGHT;
    [self.view addSubview:VC.view];
    [VC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        VC.view.y = 0;
    } completion:^(BOOL finished) {
        
    }];
}

/** 软件入门 推荐视频 弹窗  */
- (void)setSuggestVideoDialogWithArray:(NSMutableArray*)array softwareName:(NSString *)softwareName {
    
    WeakSelf;
    __block HKSoftwareRecommenVC *recommenVC = [HKSoftwareRecommenVC new];
    recommenVC.dataArray = array;
    recommenVC.softwareName = softwareName;
    recommenVC.removeVCBlcok = ^(VideoModel *model) {
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                    videoName:nil
                                             placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo
                                                      videoId:model.video_id model:nil];
        VC.videoType = [model.type integerValue];
        [weakSelf pushToOtherController:VC];
    };
    recommenVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addChildViewController:recommenVC];
    recommenVC.view.y = SCREEN_HEIGHT;
    [self.view addSubview:recommenVC.view];
    [recommenVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        recommenVC.view.y = 0;
    } completion:^(BOOL finished) {
        
    }];
}

//@property (nonatomic , strong) void(^callBackSourceBlock)(NSMutableArray * dataArray,NSIndexPath *indexPath);

- (void)loadCatalogueList:(HKVideoType)type resultBlock:(void (^)(NSMutableArray *, NSIndexPath *))resultBlock{
//    self.videoType == HKVideoType_Series ||
//    self.videoType == HKVideoType_UpDownCourse ||
//    self.videoType == HKVideoType_Practice ||
//    self.videoType == HKVideoType_JobPath ||
//    self.videoType == HKVideoType_JobPath_Practice ||
//    self.videoType == HKVideoType_PGC ||
//    (self.detailModel.is_series && (self.detailModel.is_buy_series == 1))

    // 根据视频类型加载  1，软件入门  2，系列课，3上中下的课 4- pgc
    if ( HKVideoType_JobPath == type || HKVideoType_JobPath_Practice == type) {//职业路径 职业路径练习题
        [self loadJobPathNewDataBlock:resultBlock];
    } else if ( HKVideoType_Series == type ||  HKVideoType_UpDownCourse == type ||  HKVideoType_PGC == type) {//系列课 有上下集的pgc
        [self loadNewDataSeriesBlock:resultBlock];
    }else if (self.detailModel.is_series){
        [self loadNewData:YES resultBlock:resultBlock];
    }
}


- (void)loadNewData:(BOOL)isSeries resultBlock:(void (^)(NSMutableArray *, NSIndexPath *))resultBlock{
    @weakify(self);
    [[FWNetWorkServiceMediator sharedInstance] solfwareStartToken:nil videoId:self.detailModel.video_id
                                                        is_Series:isSeries
                                                       completion:^(FWServiceResponse *response) {
                                                           if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                                                               @strongify(self);
                                                               if (![response.data isKindOfClass:[NSDictionary class]]) return;
                                                               NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data[@"path_list"]];
                                                               
                                                               self.dataSource = array;
                                                               NSIndexPath *indexPath = nil;
                                                               
                                                               // 遍历找出正在播放的视频
                                                               for (int i = 0; i < array.count; i++) {
                                                                   HKCourseModel *courseDetial = array[i];
                                                                   NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
                                                                   courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [NSString translation:chatString],courseDetial.title];
                                                                   
                                                                   for (int j = 0; j < courseDetial.children.count; j++) {
                                                                       HKCourseModel *childCourseDetial = courseDetial.children[j];
                                                                       
                                                                       // 添加序列
                                                                       childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                                                                       
                                                                       // 当前观看的视频
                                                                       if ([childCourseDetial.videoId isEqualToString:self.detailModel.video_id]) {
                                                                           childCourseDetial.currentWatching = YES;
                                                                           indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                                                       }
                                                                       
                                                                       
                                                                       // 查找课程缓存状态
                                                                       HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                                                                       // type
                                                                       dowmloadModel.videoType = childCourseDetial.videoType;
                                                                       childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                                                                       
                                                                       // 练习题
                                                                       for (int k = 0; k < childCourseDetial.children.count; k++) {
                                                                           HKCourseModel *exercise = childCourseDetial.children[k];
                                                                           exercise.isExcercises = YES;// 练习题标识符
                                                                           exercise.videoType = HKVideoType_Practice;
                                                                           // 查找练习题缓存状态
                                                                           HKDownloadModel *dowmloadExerciseModel = [HKDownloadModel mj_objectWithKeyValues:exercise.mj_JSONData];
                                                                           // type
                                                                           dowmloadExerciseModel.videoType = exercise.videoType;
                                                                           exercise.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadExerciseModel] != HKDownloadNotExist;
                                                                           
                                                                           // 当前观看的视频
                                                                           if ([exercise.videoId isEqualToString:self.detailModel.video_id]) {
                                                                               exercise.currentWatching = YES; // 当前正在观看的练习题
                                                                               childCourseDetial.expandExcercises = YES; // 展开的课程
                                                                               childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
                                                                               indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                                                                           }
                                                                           
                                                                       }
                                                                       
                                                                   }
                                                               }
                                                               
                                                               if (resultBlock) {
                                                                   resultBlock(self.dataSource,indexPath);
                                                               }
//                                                               if (self.callBackSourceBlock && self.dataSource.count) {
//                                                                   self.callBackSourceBlock(self.dataSource,indexPath);
//                                                               }
//
//                                                               // 移动到相应位置
//                                                               if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
//                                                                   [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                                                               }
                                                           }
                                                           
                                                       } failBlock:^(NSError *error) {

                                                       }];
}

- (void)loadJobPathNewDataBlock:(void (^)(NSMutableArray *, NSIndexPath *))resultBlock {
    @weakify(self);
    NSDictionary *param = @{@"chapter_id" : self.detailModel.chapterId, @"section_id" : self.detailModel.sectionId, @"video_id" : self.detailModel.video_id};
    
    [HKHttpTool POST:JOBPATH_DETAIL parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            @strongify(self);
            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return;
            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"chapterPath"]];
            self.dataSource = array;
            
            
            // 顶部章节
            HKJobPathModel *model = [HKJobPathModel mj_objectWithKeyValues:responseObject[@"data"][@"chapterInfo"]];
            NSString *text = [NSString stringWithFormat:@"%@ %@",model.chapter_sort,model.title];
            
            NSIndexPath *indexPath = nil;
            
            // 遍历找出正在播放的视频
            for (int i = 0; i < array.count; i++) {
                HKCourseModel *courseDetial = array[i];
                courseDetial.isJobPath = YES;
                //courseDetial.videoType = HKVideoType_JobPath;
                courseDetial.title = [NSString stringWithFormat:@"%@",courseDetial.title];
                
                for (int j = 0; j < courseDetial.children.count; j++) {
                    HKCourseModel *childCourseDetial = courseDetial.children[j];
                    //childCourseDetial.videoType = HKVideoType_JobPath;
                    childCourseDetial.isJobPath = YES;
                    // 添加序列
                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                    
                    // 当前观看的视频
                    if ([childCourseDetial.videoId isEqualToString:self.detailModel.video_id]) {
                        childCourseDetial.currentWatching = YES;
                        indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    }
                    
                    // 查找课程缓存状态
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                    // type
                    dowmloadModel.videoType = childCourseDetial.videoType;
                    childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 练习题
                    for (int k = 0; k < childCourseDetial.slaves.count; k++) {
                        HKCourseModel *exercise = childCourseDetial.slaves[k];
                        exercise.isJobPath = YES;
                        exercise.isExcercises = YES;// 练习题标识符
                        //exercise.videoType = HKVideoType_JobPath;
                        
                        // 查找练习题缓存状态
                        HKDownloadModel *dowmloadExerciseModel = [HKDownloadModel mj_objectWithKeyValues:exercise.mj_JSONData];
                        // type
                        dowmloadExerciseModel.videoType = exercise.videoType;
                        exercise.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadExerciseModel] != HKDownloadNotExist;
                        
                        // 当前观看的视频
                        if ([exercise.videoId isEqualToString:self.detailModel.video_id]) {
                            exercise.currentWatching = YES; // 当前正在观看的练习题
                            childCourseDetial.expandExcercises = YES; // 展开的课程
                            childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
                            indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                        }
                    }
                }
            }
            
            if (resultBlock) {
                resultBlock(self.dataSource,indexPath);
            }
//            // 移动到相应位置
//            if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
//                [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
            
        }
    } failure:^(NSError *error) {
    }];

}

- (void)loadNewDataSeriesBlock:(void (^)(NSMutableArray *, NSIndexPath *))resultBlock {
    @weakify(self);
    if ([self.detailModel.video_type integerValue] == HKVideoType_PGC) {
        self.dataSource = self.detailModel.dir_list;
        __block int i = 0;
        __block NSIndexPath *indexPath = nil;
        [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.praticeNO = @"";
            
            // 当前正在观看
            if ([obj.video_id isEqualToString:self.detailModel.video_id]) {
                obj.currentWatching = YES;
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:obj.mj_JSONData];
            // type
            dowmloadModel.videoType = obj.videoType;
            dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : obj.video_id;
            obj.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
            
            i++;
            
        }];
        if (resultBlock) {
            resultBlock(self.dataSource,indexPath);
        }
        
//        if (indexPath) {
//            [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
        
    }else{
        [[FWNetWorkServiceMediator sharedInstance] seriesCourseToken:nil videoId:self.detailModel.video_id
                                                           videoType:self.detailModel.video_type
                                                          completion:^(FWServiceResponse *response) {
                                                              
                                                              if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                                                                  @strongify(self);
                                                                  NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data];
                                                                  
                                                                  self.dataSource = array;
                                                                  NSIndexPath *indexPath = nil;
                                                                  // 遍历找出正在播放的视频
                                                                  for (int i = 0; i < array.count; i++) {
                                                                      HKCourseModel *courseDetial = array[i];
                                                                      courseDetial.praticeNO = @"";
                                                                      
                                                                      // 正在观看的系列课
                                                                      if ([courseDetial.video_id isEqualToString:self.detailModel.video_id]) {
                                                                          courseDetial.currentWatching = YES;
                                                                          indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                                      }
                                                                      // 查找缓存
                                                                      HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:courseDetial.mj_JSONData];
                                                                      // type
                                                                      dowmloadModel.videoType = courseDetial.videoType;
                                                                      dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : courseDetial.video_id;
                                                                      courseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                                                                      
                                                                  }
                                                                  if (resultBlock) {
                                                                      resultBlock(self.dataSource,indexPath);
                                                                  }
                                                                  
//                                                                  if (indexPath) {
//                                                                      [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                                                                  }
                                                              }
                                                          } failBlock:^(NSError *error) {
                                                          }];
    }
}

@end

