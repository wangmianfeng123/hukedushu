//
//  HKDownloadManager.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKDownloadManager.h"
#import "HKM3U8Parse.h"
#import "HKDownloadDB.h"
#import "AppDelegate.h"
#import "HKDownloadAgent.h"
#import "HKDownloadModel.h"
#import "HKDownloadCore.h"
#import "Reachability.h"
#import "HKBridgeDirectory1_8Model.h"
#import "HKPermissionVideoModel.h"
#import "NSString+MD5.h"
#import "HKM3U8DownloadConfig.h"
#import "AES128Helper.h"

#define HKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static HKDownloadManager *_instance;

@interface HKDownloadManager() <HKDownloadCoreDelegate>

@property (nonatomic, assign)NetworkStatus netStatus;

@property (nonatomic, strong, readonly)AFURLSessionManager *sessionManager;

@property (nonatomic,assign) UIBackgroundTaskIdentifier bgTask;

// 当前正在下载的model
@property (nonatomic, strong)HKDownloadModel *currentDownloadModel;

@property (nonatomic, strong)HKDownloadCore *currentDownloadCore;

@property (nonatomic, strong)HKDownloadModel *updateDownloadModel;// 更新segment url的下载model

// 包括正在下载的Model （所有没完成下载并且不是文件目录的model）   未完成下载并且 isDirectory不等1或者isDirectory不存在的
@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *notFinishArray;  //isFinish = 0 and (isDirectory != 1 or isDirectory is null)

// 下载的历史所有完成的model 且含有切片的视频（所有有效的视频），排除了文件夹目录model
@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *historyDownloadingArray;

// 下载的历史所有完成的目录 （有目录的视频model（带上了子视频）和没目录的单独视频）
@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *directoryArray;  //


// agent delegate
@property (nonatomic, strong)NSMutableArray<HKDownloadAgent *> *agentArray;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic,assign)BOOL isHKDowning;

@end

@implementation HKDownloadManager

- (NSOperationQueue*)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.maxConcurrentOperationCount = 1;
        _downloadQueue.qualityOfService = NSQualityOfServiceBackground;
    }
    return _downloadQueue;
}


#pragma mark <observer 创建代理>
- (void)observerDownload:(_Nonnull id<HKDownloadManagerDelegate>)delegate array:(void(^)(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray))arrayBlock {
    
    // 遍历是否已经添加了同一个代理
    BOOL added = NO;
    for (HKDownloadAgent *agentTemp in self.agentArray) {
        if (delegate && agentTemp.delegate == delegate && agentTemp.modelForDelegate == nil) {
            added = YES;
        }
    }
    
    
    if (!added) {
        //创建下载代理，将delegate设置为下载代理的代理
        HKDownloadAgent *agent = [HKDownloadAgent initManager:self HKDownloadModel:nil delegate:delegate];
        [self.agentArray addObject:agent];
    }
    
    //获取“我的下载”最外层列表数据， 清除children为空的mdoel
    NSMutableArray *directoryArrayTemp = [self clearNullArray];
    !arrayBlock? : arrayBlock(self.notFinishArray, self.historyDownloadingArray,
               directoryArrayTemp);
}

#pragma mark 清楚children为空的mdoel
- (NSMutableArray *)clearNullArray {
    NSMutableArray *arayTemp = [NSMutableArray array];
    for (HKDownloadModel *directory in self.directoryArray) {
        
        if (!directory.isDirectory) {//非目录视频
            [arayTemp addObject:directory];
        } else if (directory.isDirectory && directory.children.count) {
            //有目录视频并且子视频存在
            [arayTemp addObject:directory];
        }
    }
    return arayTemp;
}


// 1.8获取已下载视频目录相关目录信息接口
+ (void)adaptDirInfo1_8 {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *step = [userDefaults valueForKey:@"HKVideoDownloadDirectory1_8"];
    // 尚未处理
    if ([HKAccountTool shareAccount] && step == nil) {
        
        // 预先初始化数据库2
        [HKDownloadDB shareInstance];
        
        NSArray<HKDownloadModel *> *finishModelArray = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:nil];
        
        
        // 拼接参数
        if (finishModelArray.count) {
            NSString *stringIDs = @"";
            NSString *stringTypes = @"";
            
            for (HKDownloadModel *model in finishModelArray) {
                if (!model.isDirectory) {
                    stringIDs = [NSString stringWithFormat:@"%@,%@", stringIDs, model.videoId];
                    stringTypes = [NSString stringWithFormat:@"%@,%@", stringTypes, model.videoType == HKVideoType_PGC? @"2": @"1"];
                }
            }
            
            if (stringIDs.length && [stringIDs hasPrefix:@","]) {
                stringIDs = [stringIDs substringWithRange:NSMakeRange(1, stringIDs.length -1)];
                stringTypes = [stringTypes substringWithRange:NSMakeRange(1, stringTypes.length -1)];
                [HKHttpTool POST:@"/video/get-dir-info" parameters:@{@"video_id" : stringIDs, @"video_type" : stringTypes} success:^(id responseObject) {
                    
                    if (HKReponseOK) {
                        NSMutableArray *modelArray = [HKBridgeDirectory1_8Model mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                        
                        for (HKBridgeDirectory1_8Model *directory in modelArray) {
                            
                            // 上中下和普通视频的不需要目录
                            if (directory.video_type == HKVideoType_UpDownCourse || directory.video_type == HKVideoType_Ordinary) {
                                continue;
                            }
                            
                            // 包装二进制
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            dic[@"data"] = [NSMutableDictionary dictionary];
                            dic[@"data"][@"dir_data"] = directory.dir_data.mj_JSONObject;
                            dic[@"data"][@"dir_list"] = directory.route_dir_list.count? directory.route_dir_list.mj_JSONObject : directory.series_dir_list.mj_JSONObject;
                            
                            directory.dir_data.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:dic]; // 转化二进制
                            
                            // 置空 并且 保存数据
                            directory.dir_data.videoId = @"";
                            directory.dir_data.parent_direct_id = @"";
                            directory.dir_data.parent_direct_type = 0;
                            directory.dir_data.isDirectory = YES;
                            [[HKDownloadDB shareInstance] saveDirectoryModel:directory.dir_data];
                            
                            // 更新panrent_id 和 parent_type
                            HKDownloadModel *updateModel = [[HKDownloadModel alloc] init];
                            updateModel.videoType = directory.video_type;
                            updateModel.videoId = directory.video_id;
                            updateModel.parent_direct_id = directory.dir_data.dir_id;
                            updateModel.parent_direct_type = directory.dir_data.video_type;
                            
                            NSDictionary *param = nil;
                            // 练习课，需要更新type
                            if (directory.video_type == HKVideoType_Practice) {
                                // HKVideoType_Ordinary 改为 HKVideoType_Practice
                                updateModel.videoType = HKVideoType_Ordinary;
                                param = @{@"parent_direct_id" : updateModel.parent_direct_id, @"parent_direct_type" : @(updateModel.parent_direct_type), @"videoType" : @(HKVideoType_Practice)};
                            } else {
                                param = @{@"parent_direct_id" : updateModel.parent_direct_id, @"parent_direct_type" : @(updateModel.parent_direct_type)};
                            }
                            
                            // 先去查询
                            NSArray *arraytemp = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"where userID = '%@' and videoType= %d and videoId = '%@' ", [HKAccountTool shareAccount].ID, updateModel.videoType, updateModel.videoId]];
                            
                            // 查到了再更新
                            if (arraytemp.count == 1) {
                                [[HKDownloadDB shareInstance] savedownloadModel:updateModel dicOrModel:param];
                            }
                            
                        }
                        
                        // 保存偏好属性
                        [userDefaults setValue:@"setted" forKey:@"HKVideoDownloadDirectory1_8"];
                        [userDefaults synchronize];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
            } else {
                // 保存偏好属性
                [userDefaults setValue:@"setted" forKey:@"HKVideoDownloadDirectory1_8"];
                [userDefaults synchronize];
            }
        } else {
            // 保存偏好属性
            [userDefaults setValue:@"setted" forKey:@"HKVideoDownloadDirectory1_8"];
            [userDefaults synchronize];
        }
    }
    
}

- (AFURLSessionManager *)shareSessionManager {
    return self.sessionManager;
}

- (NSMutableArray *)notFinishArray {
    if (_notFinishArray == nil) {
        _notFinishArray = [NSMutableArray array];
    }
    return _notFinishArray;
}

- (NSMutableArray *)historyDownloadingArray {
    if (_historyDownloadingArray == nil) {
        _historyDownloadingArray = [NSMutableArray array];
    }
    return _historyDownloadingArray;
}

- (NSMutableArray<HKDownloadModel *> *)directoryArray {
    if (_directoryArray == nil) {
        _directoryArray = [NSMutableArray array];
    }
    return _directoryArray;
}

- (void)tb_removeNotFinishFromArray:(HKDownloadModel *)model {
    
    for (HKDownloadModel *tempModel in self.notFinishArray) {
        if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
            HKDownloadModel *tempHoldeModel = tempModel;
            [self.notFinishArray removeObject:tempModel];
            [self download:tempHoldeModel notFinishArray:self.notFinishArray];
            break;
        }
    }
}

- (void)tb_addNotFinishFromArray:(HKDownloadModel *)model {
    
    BOOL add = NO;
    for (HKDownloadModel *tempModel in self.notFinishArray) {
        if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
            add = YES;
            break;
        }
    }
    
    if (!add) {
        [self.notFinishArray insertObject:model atIndex:0];
        [self download:model notFinishArray:self.notFinishArray];
    }
}

- (void)tb_addHistoryDownloadingArray:(HKDownloadModel *)model {
    
    BOOL add = NO;
    for (HKDownloadModel *tempModel in self.historyDownloadingArray) {
        if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
            add = YES;
            break;
        }
    }
    
    if (!add) {
        [self.historyDownloadingArray insertObject:model atIndex:0];
        [self downloaded:model historyArray:self.historyDownloadingArray];
        
        // 目录
        [self tb_addDirectoryArray:model];
    }
}

- (void)tb_removeHistoryDownloadingArray:(HKDownloadModel *)model {
    
    for (HKDownloadModel *tempModel in self.historyDownloadingArray) {
        if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
            HKDownloadModel *tempHoldModel = tempModel;
            [self.historyDownloadingArray removeObject:tempModel];
            [self downloaded:tempHoldModel historyArray:self.historyDownloadingArray];
            
            // 目录
            [self tb_removeDirectoryArray:tempModel];
            break;
        }
    }
}

#pragma 目录
- (void)tb_addDirectoryArray:(HKDownloadModel *)model {
    
    // 不是目录，并且没有完成的直接返回
    if (!model.isDirectory && !model.isFinish) return;
    
    // 普通视频和上中下   （2.17版本 上下课 也支持下载目录）
    //if (model.videoType == HKVideoType_Ordinary || model.videoType == HKVideoType_UpDownCourse || model.isDirectory) {
    if (model.videoType == HKVideoType_Ordinary || model.isDirectory) {
        BOOL add = NO;
        for (HKDownloadModel *tempModel in self.directoryArray) {
            
            // 目录
            if (model.isDirectory && [tempModel.dir_id isEqualToString:model.dir_id] && tempModel.videoType == model.videoType) {
                add = YES;
                break;
            } else if (!model.isDirectory &&[tempModel.videoId isEqualToString:model.videoId] &&
                tempModel.videoType == model.videoType) {
                // 普通目录的视频
                add = YES;
                break;
            }
        }
        if (!add) {
            [self.directoryArray insertObject:model atIndex:0];
            [self downloaded:model directory:self.directoryArray];
        }
    } else {
        
        // 带有目录的子类
        BOOL add = NO;
        HKDownloadModel *directTempModel = nil;
        for (HKDownloadModel *tempModel in self.directoryArray) {
            if ([tempModel.dir_id isEqualToString:model.parent_direct_id] && tempModel.videoType == model.parent_direct_type) {
                if (![tempModel.children containsObject:model]) {
                    [tempModel.children addObject:model];
                    directTempModel = tempModel;
                    // 修改
                    add = YES;
                }
            }
        }
        if (!add) {
            NSLog(@"报错，找不到目录!!!!");
        } else {
            [self downloaded:model directory:self.directoryArray];
        };
    }
    
}

- (void)tb_removeDirectoryArray:(HKDownloadModel *)model {
    
    // 普通视频和上中下
    // v 2.17 修改 上中下 视频带目录
    if (model.videoType == HKVideoType_Ordinary || model.isDirectory) {
    //if (model.videoType == HKVideoType_Ordinary || model.videoType == HKVideoType_UpDownCourse || model.isDirectory) {
        for (HKDownloadModel *tempModel in self.directoryArray) {
            if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
                HKDownloadModel *tempHoldeModel = tempModel;
                [self.directoryArray removeObject:tempModel];
                [self downloaded:tempHoldeModel directory:self.directoryArray];
                break;
            }
        }
    } else {
        
        // 删除 v2.17 之前下载的 上中下 视频
        if ( HKVideoType_UpDownCourse == model.videoType) {
            if (isEmpty(model.parent_direct_id) && isEmpty(model.dir_id)) {
                
                for (HKDownloadModel *tempModel in self.directoryArray) {
                    if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
                        HKDownloadModel *tempHoldeModel = tempModel;
                        [self.directoryArray removeObject:tempModel];
                        [self downloaded:tempHoldeModel directory:self.directoryArray];
                        break;
                    }
                }
                return;
            }
        }

        // 总目录
        for (HKDownloadModel *tempModel in self.directoryArray) {
            if ([tempModel.dir_id isEqualToString:model.parent_direct_id] && tempModel.videoType == model.parent_direct_type) {
                
                // 子目录
                for (HKDownloadModel *subModel in tempModel.children) {
                    if ([subModel.videoId isEqualToString:model.videoId] && subModel.videoType == model.videoType) {
                        HKDownloadModel *tempHoldeModel = subModel;
                        [tempModel.children removeObject:subModel];
                        [self downloaded:tempHoldeModel directory:self.directoryArray];
                        return;
                    }
                }
            }
        }
    }
}


#pragma 代理的agent
- (NSMutableArray *)agentArray {
    if (_agentArray == nil) {
        _agentArray = [NSMutableArray array];
    }
    return _agentArray;
}

+ (id)shareInstance
{
    // 不用使用dispatch_once 是因为用户注销登录第二个账号
    if (_instance == nil) {
        _instance = [[HKDownloadManager alloc] init];
    }
    return _instance;
}


// 以防切换号码重复SessionID
static int SessionID = 2;

- (void)setSessionManager {
    NSURLSessionConfiguration *cfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"com.cainiu.HuKeWang%d", SessionID++]];
    cfig.sessionSendsLaunchEvents = YES;
    //scf.discretionary = YES;
    cfig.discretionary = NO; //系统自动选择最佳网络下载
    cfig.timeoutIntervalForRequest = 20;
    cfig.allowsCellularAccess = YES;
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:cfig];
    _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [_sessionManager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession * _Nonnull session) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.backgroundSessionCompletionHandler)
        {
            appDelegate.backgroundSessionCompletionHandler();
            appDelegate.backgroundSessionCompletionHandler = nil;
        }
    }];
    self.bgTask = UIBackgroundTaskInvalid;
    
    self.isHKDowning = NO;
}


- (instancetype)init {
    if (self = [super init]) {

        [self setSessionManager];
        // 进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onEnterForegound)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        // 进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        // 关闭进程
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseAllTask)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        // 成功登录
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(destroyManagerInstance)
                                                     name:HKLoginSuccessNotification
                                                   object:nil];
        
        // 注销登录
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(destroyManagerInstance)
                                                     name:HKLogoutSuccessNotification
                                                   object:nil];
        
        // 网络监测
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkNotification:)
                                                     name:KNetworkStatusNotification
                                                   object:nil];
        NSLog(@"=================5 %@",[NSDate date]);
        //文件夹目录model isFinish = 0 ，真正的视频model isFinish= 1
        // 查询所有的有效model
        NSArray *array = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and isFinish = 1 order by pkid DESC", [HKAccountTool shareAccount].ID]];
        self.historyDownloadingArray = [array mutableCopy];
//        for (int i = 0; i < self.historyDownloadingArray.count; i++) {
//            HKDownloadModel *modelTemp = self.historyDownloadingArray[i];
//            NSArray *segmentsArray = [[HKDownloadDB shareInstance] query:@"HKSegmentModel" Clazz:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"WHERE videoID = '%@' and videoType = %d", modelTemp.videoId, modelTemp.videoType]];
//            modelTemp.segments = [segmentsArray mutableCopy];
//        }
        NSLog(@"=================5.1 %@",[NSDate date]);
        //枚举器
            NSEnumerator *enumerator=[self.historyDownloadingArray objectEnumerator];
            while (enumerator.nextObject) {
                HKDownloadModel *modelTemp = enumerator.nextObject;
                NSArray *segmentsArray = [[HKDownloadDB shareInstance] query:@"HKSegmentModel" Clazz:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"WHERE videoID = '%@' and videoType = %d", modelTemp.videoId, modelTemp.videoType]];
                modelTemp.segments = [segmentsArray mutableCopy];
            }
        


        NSLog(@"=================6 %@",[NSDate date]);
        
        

         //尚未完成的
        NSArray *notFinishArray = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and isFinish = 0 and (isDirectory != 1 or isDirectory is null) order by pkid DESC", [HKAccountTool shareAccount].ID]];
        self.notFinishArray = [notFinishArray mutableCopy];
        NSLog(@"=================6.1 %@",[NSDate date]);
        NSEnumerator *notFinishEnumer=[self.notFinishArray objectEnumerator];
        while (notFinishEnumer.nextObject) {
            HKDownloadModel *modelTemp = notFinishEnumer.nextObject;
            NSArray *segmentsArray = [[HKDownloadDB shareInstance] query:@"HKSegmentModel" Clazz:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"WHERE videoID = '%@' and videoType = %d", modelTemp.videoId, modelTemp.videoType]];
            modelTemp.segments = [segmentsArray mutableCopy];
        }

//        for (int i = 0; i < self.notFinishArray.count; i++) {
//            HKDownloadModel *modelTemp = self.notFinishArray[i];
//            NSArray *segmentsArray = [[HKDownloadDB shareInstance] query:@"HKSegmentModel" Clazz:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"WHERE videoID = '%@' and videoType = %d", modelTemp.videoId, modelTemp.videoType]];
//            modelTemp.segments = [segmentsArray mutableCopy];
//        }
        NSLog(@"=================7 %@",[NSDate date]);

        // 总目录
        // 2.17 版本 修改 （HKVideoType_UpDownCourse 需要下载目录 ）
        //下载完成的HKVideoType_Ordinary类型的视频 或者 isDirectory = 1的视频
        NSArray *directoryArray = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and ((isFinish = 1 and (videoType = %d or videoType = %d)) or isDirectory = 1) order by pkid DESC", [HKAccountTool shareAccount].ID, (int)HKVideoType_Ordinary, (int)HKVideoType_Ordinary]];
        
        
        // 上下节课
        //完成的有上下集的视频 或者 isDirectory = 1
        NSArray *upDownArray = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and ((isFinish = 1 and (videoType = %d or videoType = %d)) or isDirectory = 1) order by pkid DESC", [HKAccountTool shareAccount].ID, (int)HKVideoType_UpDownCourse, (int)HKVideoType_UpDownCourse]];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (HKDownloadModel *model in upDownArray) {
            if (isEmpty(model.parent_direct_id) && isEmpty(model.dir_id)) {
                [arr addObject:model];
            }
        }
        
        self.directoryArray =  [directoryArray mutableCopy];
        [self.directoryArray addObjectsFromArray:arr];
        
        /// v2.16
        //NSArray *directoryArray = [[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and ((isFinish = 1 and (videoType = %d or videoType = %d)) or isDirectory = 1) order by pkid DESC", [HKAccountTool shareAccount].ID, (int)HKVideoType_Ordinary, (int)HKVideoType_UpDownCourse]];
        //[self.directoryArray addObjectsFromArray:directoryArray];

        NSLog(@"=================8 %@",[NSDate date]);

        //遍历数组将isDirectory = 1的文件夹 通过用户id和已经完成的字段和parent_direct_id，parent_direct_type 添加子视频
        for (int i = 0; i < self.directoryArray.count; i++) {
            HKDownloadModel *model = self.directoryArray[i];
            
            // 加载子目录
            if (model.isDirectory) {
                NSMutableArray *children = [[[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and isFinish = 1 and parent_direct_id = '%@' and parent_direct_type = %d", [HKAccountTool shareAccount].ID, model.dir_id, model.videoType]] mutableCopy];
                model.children = children;
            }
        }
        NSLog(@"=================9 %@",[NSDate date]);

        // WIFI状态下 开启一个下载
//        NSInteger status = [self networkStatus];
//        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            [self downloadNextWaitingTask];
//        }

    }
    return self;
}

- (NSInteger)networkStatus {
    
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn currentReachabilityStatus] == NotReachable) {
        //无网
        NSLog(@"NotReachable");
        return NotReachable;
    } else if([conn currentReachabilityStatus] == ReachableViaWiFi) {
        //WiFi
        NSLog(@"WiFi");
        return ReachableViaWiFi;
    } else {
        //4G
        NSLog(@"4G");
        return ReachableViaWWAN;
    }
}

- (void)networkNotification:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    
    switch ([HkNetworkManageCenter shareInstance].networkStatus) {
        case AFNetworkReachabilityStatusUnknown: case AFNetworkReachabilityStatusNotReachable:
        {   // 无网络
            [self GPRSPauseAllTask];
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {   // wifi 切换4g 自动暂停所有下载
            if (AFNetworkReachabilityStatusReachableViaWWAN != [HkNetworkManageCenter shareInstance].frontNetworkStatus) {
                [self GPRSPauseAllTask];
            }
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            [self startAllFailedTask];
        }
            break;
            
        default:
            break;
    }
    self.netStatus = status;
}



#pragma mark 解决用户换号登录，直接清空manager对象重新赋值
- (void)destroyManagerInstance {
    [self pauseAllTask];
    //[self.sessionManager invalidateSessionCancelingTasks:YES];
    [self.sessionManager invalidateSessionCancelingTasks:YES resetSession:YES];
    _sessionManager = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 置空对象
        _instance = nil;
    });
    
}

- (void)_onEnterForegound
{
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
    }
    self.bgTask = UIBackgroundTaskInvalid;
}

- (void)_onEnterBackground
{
    UIApplication* application = [UIApplication sharedApplication];
    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
}


- (HKDownloadModel *)HKM3U8ParseSave:(HKDownloadModel *)model {
        
    //v 2.17
//    if (model.segments.count && !isEmpty(model.keyUrl)) {
//        return model;
//    }else{
//        //keyUrl 为空 重新解析
//    }
    
    //获取下载m3u8文件的链接
    NSString *newUrl = [[HKDownloadManager class] refreshContentURLSyn:model];
    if (isEmpty(newUrl)) {
        [model.segments removeAllObjects];
        return model;
    }
    
    NSError *error = nil;
    //v2.17 职业路径
    //通过获取到的m3u8文件的链接拿到ts片段模型
    HKDownloadModel *moelTemp = [[[HKM3U8Parse alloc] init] analyseVideoUrl:newUrl error:&error videoID:model.videoId videoType:model.videoType chapter_id:model.chapter_id section_id:model.section_id career_id:model.career_id];
    
    // 赋值
    model.pkid = moelTemp.pkid;
    //model.segments = moelTemp.segments;
    model.totalDurations = moelTemp.totalDurations;
    model.videoUrl = moelTemp.videoUrl;
    model.keyUrl = moelTemp.keyUrl;
    model.isFinish = moelTemp.isFinish;
    
    // 更新 segment
     NSUInteger segmentCount = moelTemp.segments.count;
     if (model.segments.count == segmentCount ) {
         for (int i = 0; i < segmentCount; i++) {
             // 更换url
             if (!model.segments[i].isFinish) {
                 //更新未下载的切片的链接
                 model.segments[i].url = moelTemp.segments[i].url;
             }
         }
     }else{
         model.segments = moelTemp.segments;
     }
    
    //
    if (moelTemp && model) {
        // ts片段model更新之后重新保存到数据库
        [self saveM3U8listToDB:model];
        return model;
    } else {
        [model.segments removeAllObjects];
        return model;
    }
}


// 更新m3u8的url, 防止过期
- (void)refreshContentURL:(HKDownloadModel *)model block:(void(^)(NSString *video_url, int videoType))completecBlock {
    
    // PCG
    if (model.videoType == HKVideoType_PGC) {
        
        [HKHttpTool POST:@"/pgc/play" parameters:@{@"video_id" : model.videoId} success:^(id responseObject) {
            if (HKReponseOK) {
                // 可以下载
                NSString *is_download = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_download"]];
                if (is_download.length && [is_download isEqualToString:@"1"]) {
                    NSString *video_url = responseObject[@"data"][@"video_url"];
                    completecBlock(video_url, model.videoType);
                } else {
                    completecBlock(nil, model.videoType);
                }
            }
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        NSString *url = nil;
        NSDictionary *param = nil;
        if(model.videoType == HKVideoType_JobPath || model.videoType == HKVideoType_JobPath_Practice ) {
            //url = CAREER_VIDEO_PLAY;
            // v2.21
            url = VIDEO_DOWNLOAD;
            param = @{@"chapter_id" : model.chapter_id, @"section_id" : model.section_id, @"video_id" : model.videoId, @"career_id" : model.career_id};
        }else{
            url = VIDEO_DOWNLOAD;//@"video/video-play";
            param = @{@"video_id" : model.videoId};
        }
        
        // 普通的
        [HKHttpTool POST:url parameters:param success:^(id responseObject) {
            
            if (HKReponseOK) {
                // 可以下载
                // v2.17
                HKPermissionVideoModel *permissionModel = [HKPermissionVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
                if (permissionModel.can_download) {
                    completecBlock(permissionModel.video_url, model.videoType);
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


// 更新segment的url, 防止过期
+ (void)updateSegmentsURLSave:(HKDownloadModel *)model block:(void(^)(BOOL completed, HKDownloadModel *model ))updateSegmentsComplete {
    
    NSString *newVideoUrl = [[HKDownloadManager class] refreshContentURLSyn:model];
    
    NSError *error = nil;
    // v2.17 适应 职业路径下载
    HKDownloadModel *modelTemp = [[[HKM3U8Parse alloc] init] analyseVideoUrl:newVideoUrl error:&error videoID:model.videoId videoType:model.videoType chapter_id:model.chapter_id section_id:model.section_id career_id:model.career_id];
            
    // 防止网站内容修改报错
    if (modelTemp.segments.count != model.segments.count) {
        // 切片数量有变化 重新下载
        updateSegmentsComplete(NO, modelTemp);
    } else {
        for (int i = 0; i < model.segments.count; i++) {
            
            HKSegmentModel *oldSegmentModel = model.segments[i];
            // 更换url并且更新数据库
            if (!model.segments[i].isFinish) {
                oldSegmentModel.url = modelTemp.segments[i].url;
                [[HKDownloadDB shareInstance] saveSegmentModel:oldSegmentModel dicOrModel:@{@"url" : oldSegmentModel.url}];
            }
        }
        updateSegmentsComplete(YES, model);
    }
}


// 先检查是否已经存在同model同delegate的agent
- (BOOL)alreadyHasAgent:(id<HKDownloadManagerDelegate>)delegate downloadModel:(HKDownloadModel *)downloadModel{
    BOOL hasAgent= NO;
    for (int i = 0; i < self.agentArray.count; i++) {
        HKDownloadAgent *agentTemp = self.agentArray[i];
        if ([agentTemp.modelForDelegate.videoId isEqualToString:downloadModel.videoId] && agentTemp.modelForDelegate.videoType == downloadModel.videoType  && agentTemp.delegate == delegate) {
            hasAgent = YES;
            break;
        }
    }
    return hasAgent;
}

#pragma mark <初始化model>
- (HKDownloadModel *)modelWithSegments:(HKDownloadModel *)downloadModel ignoreSegments:(BOOL)ignore{

        // 1.6版本之前的数据
        if (downloadModel.saveInCache) {
            return downloadModel;
        }
        
        if (!downloadModel.segments.count) {//下载的视频ts片段不存在

            // 先去内存查询该对象
            for (int i = 0; i < self.notFinishArray.count; i++) {
                HKDownloadModel *modelTemp = self.notFinishArray[i];
                if ([modelTemp.videoId isEqualToString:downloadModel.videoId] && modelTemp.videoType == downloadModel.videoType) {
                    downloadModel = modelTemp;
                    
                    // 已经解析完毕  正在下载中的
                    if (downloadModel.segments.count) {
                        return downloadModel;
                    }
                }
            }
            
            for (int i = 0; i < self.historyDownloadingArray.count; i++) {
                HKDownloadModel *modelTemp = self.historyDownloadingArray[i];
                if ([modelTemp.videoId isEqualToString:downloadModel.videoId] && modelTemp.videoType == downloadModel.videoType) {
                    downloadModel = modelTemp;
                    if (downloadModel.segments.count) {
                        return downloadModel;
                    }
                }
            }
            
            // 目录
            for (int i = 0; i < self.directoryArray.count; i++) {
                HKDownloadModel *modelTemp = self.directoryArray[i];
                if (modelTemp.isDirectory && [modelTemp.dir_id isEqualToString:downloadModel.dir_id] && modelTemp.videoType == downloadModel.videoType) {
                    downloadModel = modelTemp;
                    return downloadModel;
                }
            }
            
            // 删除的是无需重新数据库初始化
            if (ignore) {
                return downloadModel;
            }
            
            // 数据库查询
            HKDownloadModel *downloadModelTemp = [[[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoID = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, downloadModel.videoId, downloadModel.videoType]] firstObject];
            
            // 继续查询segments
            if (downloadModelTemp) {
                NSArray *M3U8SegmentList = [[HKDownloadDB shareInstance] query:@"HKSegmentModel" Clazz:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"where videoID = '%@' and videoType = %d order by indexSegment", downloadModelTemp.videoId, downloadModelTemp.videoType]];
                downloadModel.segments = [M3U8SegmentList mutableCopy];
                downloadModel.isFinish = downloadModelTemp.isFinish;
                downloadModel.downloadPercent = downloadModelTemp.downloadPercent;
                downloadModel.videoType = downloadModelTemp.videoType;
                            
                // 已经解析
               downloadModel = [self updateSegmentUrlWithModel:downloadModel ignoreUpdate:ignore];
               return downloadModel;
            } else {
                // 解析
                downloadModel = [self updateSegmentUrlWithModel:downloadModel ignoreUpdate:ignore];
                return downloadModel;
            }
        } else {
            //下载的视频ts片段已经存在
            downloadModel = [self updateSegmentUrlWithModel:downloadModel ignoreUpdate:ignore];
            return downloadModel;
        }
}



/// 更新下载ts片段的url
- (HKDownloadModel*)updateSegmentUrlWithModel:(HKDownloadModel*)oldModel ignoreUpdate:(BOOL)ignore {
    if (ignore) {
        return oldModel;
    }
    oldModel = [self HKM3U8ParseSave:oldModel];
    return oldModel;
}



//下载前条件判断
- (void)downloadModel:(HKDownloadModel *)downloadModel withDelegate:(id<HKDownloadManagerDelegate>)delegate {
    
    // 判断储存剩余储存空间 150M
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long space) {
        long spaceLeft = space/1024/1024;
        if (spaceLeft < 150) {
            [self pauseAllTask];//暂停所有任务
            dispatch_async(dispatch_get_main_queue(), ^{
                showTipDialog(@"存储空间不足，请稍后再试...");
            });
        }
    }];
    
    NSLog(@"11321321");
    
    // 子线程运行耗时操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        // 防止多线程同个解析同时运行出错
        @synchronized(self) {
            // 先判断是否已经解析保存在数据库 初始化
            HKDownloadModel *model = [self modelWithSegments:downloadModel ignoreSegments:NO];
            
            // 无效的model
            if (!model) return;
            
            // 生成代理
            if (delegate) {
                // 先检查是否已经存在同model同delegate的agent
                BOOL hasAgent = [self alreadyHasAgent:delegate downloadModel:model];
                
                if (!hasAgent) {
                    HKDownloadAgent *agent = [HKDownloadAgent initManager:self HKDownloadModel:model delegate:delegate];
                    [self.agentArray addObject:agent];
                }
            }
            
            // 重新获取新的
//            if (!model.url.length) {
//                [[HKDownloadManager shareInstance] refreshContentURL:model block:^(NSString *video_url, int videoType) {
//                    model.url = video_url;
//                }];
//            }
            
            // 已经下载完成直接执行代理
            if (model.isFinish) {
                [self didFinishedDownload:model];
                return;
            }
            
            // 添加到未完成的队列
            [self tb_addNotFinishFromArray:model];
            
            // 当前有正在下载的model
            if (self.currentDownloadModel && !([self.currentDownloadModel.videoId isEqualToString:model.videoId] && self.currentDownloadModel.videoType == model.videoType)) {
                
                // 执行等待代理
                [self waitingDownload:model];
                
            } else {
                
                // 当前正在下载为同一个
                if ([self.currentDownloadModel.videoId isEqualToString:model.videoId] && self.currentDownloadModel.videoType == model.videoType) return;
                // 开启下载
                [self beginDownloadM3u8WithModel:model];
            }
        };
    });
}



/// 真正开始下载
- (void)beginDownloadM3u8WithModel:(HKDownloadModel *)model {
    
    self.isHKDowning = YES;
    HKM3U8DownloadConfig *dlConfig = HKM3U8DownloadConfig.new;
    /*单个媒体下载的文件并发数控制*/
    dlConfig.maxConcurrenceCount = 2;
    
    HKDownloadCore *currentDownloadCore = [[HKDownloadCore alloc] initWithConfig:dlConfig downloadDstRootPath:nil sessionManager:self.sessionManager progressBlock:^(CGFloat progress) {
        
    } resultBlock:^(NSError * _Nullable error, NSString * _Nullable relativeUrl) {
        
    } downloadModel:model];
    currentDownloadCore.delegate = self;
    
    // 执行代理
    [self beginDownload:model];
    
    [self.downloadQueue addOperation:currentDownloadCore];
    
    self.currentDownloadModel = model;
    self.currentDownloadCore = currentDownloadCore;
    
    
//    HKDownloadCore *currentDownloadCore = [[HKDownloadCore alloc] init];
//    currentDownloadCore.delegate = self;
//    // 执行代理
//    [self beginDownload:model];
//    //[currentDownloadCore downloadModel:model];
//    self.currentDownloadModel = model;
//    self.currentDownloadCore = currentDownloadCore;
}



//保存视频的ts片段model存入数据库中
- (BOOL)saveM3U8listToDB:(HKDownloadModel *)downloadModel {
    BOOL saveSuccess = [[HKDownloadDB shareInstance] savedownloadModel:downloadModel dicOrModel:nil];
    return saveSuccess;
}

#pragma  删除 model 或 者目录
- (void)deleteSingleModel:(void (^)(BOOL, HKDownloadModel *))deletModelBlock modelReal:(HKDownloadModel *)modelReal isOperationByDirect:(BOOL)Direct openNext:(BOOL)next{
//    [self pauseTask:modelReal openNext:next completeBlock:^{
//        // 删除数据库的记录
//        [[HKDownloadDB shareInstance] didDeletedDownload:modelReal delete:^(BOOL success, HKDownloadModel *model) {
//            !deletModelBlock? : deletModelBlock(success, model);
//            // 代理
//            if(success) [self didDeletedDownload:model openNext:next];
//        }];
//    }];
    
    [self pauseTask:modelReal openNext:next completeBlock:^(BOOL completed) {
        // 删除数据库的记录
        [[HKDownloadDB shareInstance] didDeletedDownload:modelReal delete:^(BOOL success, HKDownloadModel *model) {
            !deletModelBlock? : deletModelBlock(success, model);
            // 代理
            //if(success) [self didDeletedDownload:model openNext:completed ?YES :next];
            if(success) [self didDeletedDownload:model openNext:next];
        }];
    }];
}

- (void)deletedDownload:(HKDownloadModel *)model delete:(void (^)(BOOL, HKDownloadModel *))deletModelBlock {
    
    HKDownloadModel *modelReal = [self modelWithSegments:model ignoreSegments:YES];
    
    // 删除目录
    if (modelReal.isDirectory) {
        // 已经完成的
        NSMutableArray *childrenTemp = [modelReal.children mutableCopy];
        for (HKDownloadModel *childModel in childrenTemp) {
            [self deleteSingleModel:nil modelReal:childModel isOperationByDirect:YES openNext:NO];
        }
        !deletModelBlock? : deletModelBlock(YES, model);
        
    } else {
        
        // 单个目录
        [self deleteSingleModel:deletModelBlock modelReal:modelReal isOperationByDirect:NO openNext:NO];
    }
}



- (void)deletedDownloadArr:(NSMutableArray <HKDownloadModel*> *)modelArr {
    
    __block BOOL isDownload = NO;
    __block BOOL isNeedNext = NO;
    NSUInteger count = modelArr.count;
    
    [modelArr enumerateObjectsUsingBlock:^(HKDownloadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HKDownloadModel *model = obj;
        HKDownloadModel *modelReal = [self modelWithSegments:model ignoreSegments:YES];
        
        if (NO == isDownload) {
            if ([modelReal.videoId isEqualToString:self.currentDownloadModel.videoId] && modelReal.videoType == self.currentDownloadModel.videoType) {
                // 删除的视频 包含正在下载的
                isDownload = YES;
            }
        }
        if (idx == count -1 && isDownload) {
            isNeedNext = YES; // 需要开启下一个下载
        }
        // 删除目录
        if (modelReal.isDirectory) {
            // 已经完成的
            NSMutableArray *childrenTemp = [modelReal.children mutableCopy];
            for (HKDownloadModel *childModel in childrenTemp) {
                [self deleteSingleModel:nil modelReal:childModel isOperationByDirect:YES openNext:isNeedNext];
            }
        } else {
            // 单个目录
            [self deleteSingleModel:nil modelReal:modelReal isOperationByDirect:NO openNext:isNeedNext];
        }
    }];
}



#pragma mark 开启下一个正在等待的任务
- (void)downloadNextWaitingTask {
    
    //if (self.currentDownloadModel && self.currentDownloadCore) return;
    if (self.currentDownloadModel) return;

    HKDownloadModel *model = nil;
    for (int i = (int)self.notFinishArray.count - 1; i >= 0; i--) {
        HKDownloadModel *modelTemp = self.notFinishArray[i];
        if (modelTemp.status == HKDownloadWaiting || modelTemp.status == HKDownloading) {
            model = modelTemp;
            break;
        }
    }
    
    // 开启下载
    if (model) {
        [self downloadModel:model withDelegate:nil];
    }else{
        //无视频可下
        self.isHKDowning = NO;
    }
}


#pragma  mark session 停止当前某个task任务
- (void)sessionPauseForCurrent {
    
    self.isHKDowning = NO;
    
    if (!self.currentDownloadCore.isCancelled) {
        [self.currentDownloadCore cancel];
        self.currentDownloadModel = nil;
        self.currentDownloadCore = nil;
    }
    //[self.downloadQueue cancelAllOperations];
}




- (void)pauseTask:(HKDownloadModel *)model openNext:(BOOL)next completeBlock:(void(^)(BOOL completed))pauseTaskBlock {
//- (void)pauseTask:(HKDownloadModel *)model openNext:(BOOL)next completeBlock:(void (^)())pauseTaskBlock {
    
    
    // 没有在未完成队列是不能暂停的
    BOOL isNotFinishModel = NO;
    for (int i = 0; i < self.notFinishArray.count; i++) {
        HKDownloadModel *modelTemp = self.notFinishArray[i];
        if ([modelTemp.videoId isEqualToString:model.videoId] && modelTemp.videoType == model.videoType) {
            isNotFinishModel = YES;
        }
    }
    if (!isNotFinishModel) {
        !pauseTaskBlock? : pauseTaskBlock(NO);
        return;
    }
    
    // 取消正在下载的
    BOOL isDownload = NO;
    HKDownloadModel *modelReal = [self modelWithSegments:model ignoreSegments:YES];
    if ([modelReal.videoId isEqualToString:self.currentDownloadModel.videoId] && modelReal.videoType == self.currentDownloadModel.videoType) {
        modelReal.status = HKDownloadPause;
        [self sessionPauseForCurrent];
        isDownload = YES;
    }
    
    // 执行代理
    if (nil == pauseTaskBlock) {
        [self didPausedDownload:modelReal openNext:next];
    }
    !pauseTaskBlock? : pauseTaskBlock(isDownload);
}

// 设置已经观看
- (void)changeNeedStudyLocal:(HKDownloadModel *)model {
    if (!model || model.isDirectory) return;
    
    for (HKDownloadModel *tempModel in self.historyDownloadingArray) {
        if ([tempModel.videoId isEqualToString:model.videoId] && tempModel.videoType == model.videoType) {
            tempModel.needStudyLocal = NO;
            [[HKDownloadDB shareInstance] savedownloadModel:tempModel dicOrModel:@{@"needStudyLocal" : @NO}];
            break;
        }
    }
}


/// 流量暂停下载
- (void)GPRSPauseAllTask {
    
    [self sessionPauseForCurrent];
    for (int i = 0; i < self.notFinishArray.count; i++) {
        // 改变所有状态为暂停
        HKDownloadModel *model = self.notFinishArray[i];
        // 更新数据库
        if (model.status != HKDownloadPause) {
            // 执行代理
            model.status = HKDownloadFailed;
            [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status)}];
            // 执行代理
            [self performAgent:@selector(didPausedDownload:) arguments:@[model]];
        }
    }
}


// 暂停所有的下载
- (void)pauseAllTask {
        
    [self sessionPauseForCurrent];
    for (int i = 0; i < self.notFinishArray.count; i++) {
        // 改变所有状态为暂停
        HKDownloadModel *model = self.notFinishArray[i];
        
        // 执行代理
        [self didPausedDownload:model openNext:NO];
    }
}

// 开始所有的下载
- (void)startAllTask {
    
    for (int i = 0; i < self.notFinishArray.count; i++) {
        // 改变所有状态为暂停
        HKDownloadModel *model = self.notFinishArray[i];
        if (model.status == HKDownloadPause || model.status == HKDownloadFailed) {
            // 执行代理
            [self waitingDownload:model];
        }
    }
    
    // 开启下一个下载
    [self downloadNextWaitingTask];
}



// 开始所有失败的下载
- (void)startAllFailedTask {
    for (int i = 0; i < self.notFinishArray.count; i++) {
        HKDownloadModel *model = self.notFinishArray[i];
        if (model.status == HKDownloadFailed) {
            // 执行代理
            [self waitingDownload:model];
        }
    }
    // 开启下一个下载
    [self downloadNextWaitingTask];
}


#pragma mark <异常异常的agent>
- (void)removeAgent:(HKDownloadAgent *)agent model:(HKDownloadModel *)stopModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (stopModel == nil) {
            
            // 直接移除指定agent
            [self.agentArray removeObject:agent];
        } else {
            
            // 移除异常的agent
            NSMutableArray *removeArray = [NSMutableArray array];
            for (HKDownloadAgent *agent in self.agentArray) {
                if (agent.modelForDelegate && [agent.modelForDelegate.videoId isEqualToString:stopModel.videoId] && agent.modelForDelegate.videoType == stopModel.videoType) {
                    [removeArray addObject:agent];
                }
            }
            [self.agentArray removeObjectsInArray:removeArray];
        }
    });
}

#pragma mark 查询model的状态，不包含segments
- (HKDownloadStatus)queryStatus:(HKDownloadModel *)model {
    model = [[[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"where userID = '%@' and videoID = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, model.videoId, model.videoType]] firstObject];
    
    if (model) {
        return (int)model.status;
    } else {
        return HKDownloadNotExist;
    }
}

#pragma mark 查询model的状态，不包含segments
- (HKDownloadModel *)queryWidthID:(NSString *)videId videoType:(int)videoType {
    HKDownloadModel *model = [[[HKDownloadDB shareInstance] query:@"HKDownloadModel" Clazz:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"where userID = '%@' and videoID = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, videId, videoType]] firstObject];
    return model;
}

#pragma mark <HKDownloadCoreDelegate>
- (void)beginDownload:(HKDownloadModel *)model {
    
    model.status = HKDownloading;
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status)}];
    [self performAgent:@selector(beginDownload:) arguments:@[model]];
}

- (void)waitingDownload:(HKDownloadModel *)model {
    
    // 更新数据库
    model.status = HKDownloadWaiting;
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status)}];
    [self performAgent:@selector(waitingDownload:) arguments:@[model]];
}

- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress {
    
    // 第几个
    NSString *index = @"0";
    for (int i = 0; i < self.notFinishArray.count; i++) {
        HKDownloadModel *modelTemp = self.notFinishArray[i];
        if ([modelTemp.videoId isEqualToString:model.videoId] && modelTemp.videoType == model.videoType) {
            index = [NSString stringWithFormat:@"%d", i];
            break;
        }
    }
    
    [self performAgent:@selector(download:progress:index:) arguments:@[model, progress, index]];
}

- (void)didFailedDownload:(HKDownloadModel *)model {
    
    // 判断储存剩余储存空间 150M
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long space) {
        long spaceLeft = space/1024/1024;
        if (spaceLeft < 150) {
            [self pauseAllTask];
            dispatch_async(dispatch_get_main_queue(), ^{
                showTipDialog(@"存储空间不足，请稍后再试...");
            });
        }
    }];
    
    model.status = HKDownloadFailed;
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status)}];
    
    [self performAgent:@selector(didFailedDownload:) arguments:@[model]];
    
    // 清空当前下载的Model
    self.currentDownloadCore = nil;
    self.currentDownloadModel = nil;
    
    // 开启下一个下载
    [self downloadNextWaitingTask];
}

- (void)didFinishedDownload:(HKDownloadModel *)model {
    
    model.status = HKDownloadFinished;
    model.isFinish = YES;
    model.needStudyLocal = YES;
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status), @"isFinish" : @YES, @"needStudyLocal" : @YES}];
    
    // 移除
    [self tb_removeNotFinishFromArray:model];
    
    [self tb_addHistoryDownloadingArray:model];
    
    self.currentDownloadModel = nil;
    self.currentDownloadCore = nil;
    
    [self performAgent:@selector(didFinishedDownload:) arguments:@[model]];
    
    // 开启下一个下载
    [self downloadNextWaitingTask];
}

- (void)didDeletedDownload:(HKDownloadModel *)model openNext:(BOOL)next {
    
    // 移除历史记录
    if (model.isFinish) {
        [self tb_removeHistoryDownloadingArray:model];
    } else {
        [self tb_removeNotFinishFromArray:model];
    }
    
    // 还原下载
    model.isFinish = NO;
    model.segments = nil;
    model.downloadPercent = 0.0;
    
    [self performAgent:@selector(didDeletedDownload:) arguments:@[model]];
    
    
    // 子线程删除文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 删除文件夹
        NSString *deletePath = nil;
        
        // 1.6版本
        if (model.saveInCache) {
            NSString *temp = [CommonFunction getM3U8LocalUrlWithVideoUrl:model.videoUrl];
            deletePath = [NSString stringWithFormat:@"%@/%@", kLibraryCache, temp];
        } else {
            
            // 1.7版本
            BOOL isDirectory1_7 = YES;
            BOOL exist1_7 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/download/%@", HKDocumentPath, model.videoId] isDirectory:&isDirectory1_7];
            if (exist1_7) {
                deletePath = [NSString stringWithFormat:@"%@/download/%@", HKDocumentPath, model.videoId];
            } else {
                
                // 1.8版本
                deletePath = [NSString stringWithFormat:@"%@/download/%@_%d", HKDocumentPath, model.videoId, model.videoType];
            }
            
        }
        
        BOOL isDirectory = YES;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:deletePath isDirectory:&isDirectory];
        if (exist) {
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
        }
    });
    
    // 开启下一个下载
    if (next) {
        [self downloadNextWaitingTask];
    }
}

- (void)didPausedDownload:(HKDownloadModel *)model openNext:(BOOL)next {
    
    // 更新数据库
    model.status = HKDownloadPause;
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:@{@"status" : @(model.status)}];
    [self performAgent:@selector(didPausedDownload:) arguments:@[model]];
    
    // 开启下一个下载
    if (next) {
        [self downloadNextWaitingTask];
    }
}

#pragma makr 完成与为完成数据

- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array {
    [self performAgent:@selector(download:notFinishArray:) arguments:@[model, [array mutableCopy]]];
}

- (void)downloaded:(HKDownloadModel *)model historyArray:(NSMutableArray<HKDownloadModel *> *)array {
    [self performAgent:@selector(downloaded:historyArray:) arguments:@[model, [array mutableCopy]]];
}

// 目录
- (void)downloaded:(HKDownloadModel *)model directory:(NSMutableArray<HKDownloadModel *> *)array {
    
    // 如果children为空就不返回
    NSMutableArray *childrenNotNullArray = [self clearNullArray];
    [self performAgent:@selector(downloaded:directory:) arguments:@[model, childrenNotNullArray]];
}



#pragma mark <完成了某个切片>
- (void)didFinishModel:(HKDownloadModel *)downloadModel Segment:(HKSegmentModel *)segmentModel {
    // 记录数据库已经完成的切片
    segmentModel.isFinish = YES;
    [[HKDownloadDB shareInstance] segmentDownloadFinsh:segmentModel];
    
    [self performAgent:@selector(didFinishModel:Segment:) arguments:@[downloadModel, segmentModel]];
}

#pragma mark <遍历代理>
- (void)performAgent:(SEL)action arguments:(NSArray *)arguments {
    
    // 防止多线程操作 for出错 mark 1122
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.agentArray.count; i++) {
            HKDownloadAgent *agent = self.agentArray[i];
            
            // 单个
            if (agent.modelForDelegate) {
                HKDownloadModel *tempModel = [arguments firstObject];
                
                // 执行代理
                if ([agent.modelForDelegate.videoId isEqualToString:tempModel.videoId] && agent.modelForDelegate.videoType == tempModel.videoType) {
                    [agent excuteFunc:action arguments:arguments];
                }
            }else {
                
                // 全局的
                [agent excuteFunc:action arguments:arguments];
            }
        }
    });
}

- (BOOL)savedownloadModel:(HKDownloadModel *)model dicOrModel:(id)dicOrModel {
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:dicOrModel];
    return YES;
}

#pragma mark <保存目录的封面>
- (BOOL)saveDirectoryModel:(HKDownloadModel *)directModel {
    
    // 添加入数据库和内存
    [[HKDownloadDB shareInstance] saveDirectoryModel:directModel];
    [self tb_addDirectoryArray:directModel];
    return YES;
}

// 兼容1.6版本的
- (void)saveModelBefore1_6:(HKDownloadModel *)model {
    [[HKDownloadDB shareInstance] savedownloadModel:model dicOrModel:nil];
    [self.historyDownloadingArray addObject:model];
}

#pragma mark - 批量保存下载model, 稍后再解析segments
- (void)saveArrayParseLater:(NSArray<HKDownloadModel *> *)array block:(void(^)())saveBlock {
    
    WeakSelf;
    void(^block)() = ^() {
        
        // 加入为为下载的队列
        for (HKDownloadModel *model in array) {
            [weakSelf tb_addNotFinishFromArray:model];
        }
        
        // 开启下一个的下载任务
        [weakSelf downloadNextWaitingTask];
    };
    
    //开始下载
    [[HKDownloadDB shareInstance] saveModelArray:array block:block];
}



+ (NSString*)videoUrlWithModel:(HKDownloadModel *)model {
    NSString *url = nil;
    if (model.videoType == HKVideoType_PGC) {
        url = [NSString stringWithFormat:@"%@%@", BaseUrl, @"/pgc/play"];
    }else if (model.videoType == HKVideoType_JobPath || model.videoType == HKVideoType_JobPath_Practice) {
        //url = [NSString stringWithFormat:@"%@%@", BaseUrl, CAREER_VIDEO_PLAY];
        // v2.20
        url = [NSString stringWithFormat:@"%@%@", BaseUrl, VIDEO_DOWNLOAD];
    }else {
        url = [NSString stringWithFormat:@"%@%@", BaseUrl, VIDEO_DOWNLOAD];
    }
    return url;
}


+ (NSMutableURLRequest*)mutableURLRequestWithModel:(HKDownloadModel *)model url:(NSString*)url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Bearer-%@",[HKAccountTool shareAccount].access_token] forHTTPHeaderField:USERR_TOKEN];
    [request setValue:APP_TYPE forHTTPHeaderField:@"app-type"];
    [request setValue:API_VERSION forHTTPHeaderField:@"api-version"];
    [request setValue:STRING_TABLET forHTTPHeaderField:@"is-tablet"];
    NSString *param = [NSString stringWithFormat:@"video_id=%@", model.videoId];//设置参数
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setSafeObject:model.videoId forKey:@"video_id"];
    NSLog(@"USERR_TOKEN=====%@",[NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]]);
    
    if (model.videoType == HKVideoType_JobPath || model.videoType == HKVideoType_JobPath_Practice) {
        // 职业路径
        param = [NSString stringWithFormat:@"video_id=%@&chapter_id=%@&section_id=%@&career_id=%@", model.videoId, model.chapter_id, model.section_id,model.career_id];
        
        [paramDic setSafeObject:model.videoId forKey:@"video_id"];
        [paramDic setSafeObject:model.chapter_id forKey:@"chapter_id"];
        [paramDic setSafeObject:model.section_id forKey:@"section_id"];
        [paramDic setSafeObject:model.career_id forKey:@"career_id"];
    }
    
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    // 加密
    request = [[self class] requestVerificatSign:request url:url paramDic:paramDic];

    [request setHTTPBody:data];
    
    return request;
}


#pragma mark - 同步请求  下载权限m3u8
+ (NSString *)refreshContentURLSyn:(HKDownloadModel *)model {
    
    NSString *m3u8String = nil;
    //1--创建请求
    //（https://api.huke88.com/v5/video/download）
    //下载接口下载获取m3u8文件的链接
    NSString *url = [self videoUrlWithModel:model];
    NSMutableURLRequest *request = [self mutableURLRequestWithModel:model url:url];
    
    // 2 --连接服务器
    NSError *err;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    NSString *result = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *responseCode = [NSString stringWithFormat:@"%@",[response objectForKey:@"code"]];
    
    if ([responseCode isEqualToString:@"1"] && model.videoType == HKVideoType_PGC) {
        // 可以下载
        NSString *is_download = [NSString stringWithFormat:@"%@", response[@"data"][@"is_download"]];
        if (is_download.length && [is_download isEqualToString:@"1"]) {
            NSString *video_url = response[@"data"][@"video_url"];
            m3u8String = video_url;
        }
    } else if ([responseCode isEqualToString:@"1"]) {
        // v2.17 可以下载
        HKPermissionVideoModel *permissionModel = [HKPermissionVideoModel mj_objectWithKeyValues:response[@"data"]];
        if (permissionModel.can_download) {
            m3u8String = permissionModel.video_url;
        }
        
        if (permissionModel.business_code != 200) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                showTipDialog([NSString stringWithFormat:@"%@", permissionModel.business_message]);
//            });
            dispatch_async(dispatch_get_main_queue(), ^{
                closeWaitingDialog();

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    showTipDialog([NSString stringWithFormat:@"%@", permissionModel.business_message]);
                });
            });
        }

    }else{
        // 输出错误信息
        if (response[@"msg"] && ![responseCode isEqualToString:@"1"] && ![responseCode isEqualToString:@"-1"] && ![responseCode isEqualToString:@"1001"]
            &&  ![responseCode isEqualToString:@"-2"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                showTipDialog([NSString stringWithFormat:@"%@", response[@"msg"]]);
//            });
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                closeWaitingDialog();

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    showTipDialog([NSString stringWithFormat:@"%@", response[@"msg"]]);
                });
            });
        }
    }
    return m3u8String;
}




/** 签名加密 验证 */
+ (NSMutableURLRequest *)requestVerificatSign:(NSMutableURLRequest *)request url:(NSString*)url paramDic:(NSMutableDictionary *)param{
    
//    NSString *diviceString = [CommonFunction getUUIDFromKeychain];
//    [request setValue:diviceString forHTTPHeaderField:DEVICE_NUM];
    
    
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionary];
    NSString * device_id = [CommonFunction getUUIDFromKeychain];
//    if (!isEmpty(device_id)) {
        [headerDic setSafeObject:device_id forKey:DEVICE_NUM];
//    }
    
    if ([headerDic allKeys].count > 0) {
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:headerDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        
        NSData *data = [[NSData alloc]initWithBase64EncodedString:@"aHVrZTIwMjEwNzIyMjE0Nw==" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if(data == nil) return nil;
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *decrStr = [AES128Helper aesEncrypt:jsonString key:string];
        if (!isEmpty(decrStr)) {
            [request setValue:decrStr forHTTPHeaderField:@"sign-info"];
        }
    }
    
    
    
    
//    // 设置加密
//    NSString *relativeString = [url stringByReplacingOccurrencesOfString:BaseUrl withString:@""];// contoller action
//    NSDate *date = [NSDate date];
//    NSString *timeInt = [NSString stringWithFormat:@"%ld", (long)date.timeIntervalSince1970];
//    NSString *jsonString = [NSString stringWithFormat:@"{\"private_key\":\"@WSXNHY^dfisl8217\",\"visit_time\":\"%@\",\"device_num\":\"%@\",\"data\":{\"ios_post_data_num\":%d},\"visit\":\"%@\"}",timeInt, diviceString, 1, relativeString];
//    NSString *stringMD5 = [NSString md5:jsonString];
//    [request setValue:stringMD5 forHTTPHeaderField:@"sign"];
//    [request setValue:timeInt forHTTPHeaderField:@"visit-time"];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setSafeObject:@"device-num" forKey:@"device-num"];
    
    [dic addEntriesFromDictionary:param];
    //按字母顺序排序
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    for (NSInteger i = 0; i < 8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    NSString * privateKey = @"o71orZ8cb8Y7STSa";
    

    NSString * md5Key =@"";
    for (NSString * key in sortedArray) {
        md5Key = [NSString stringWithFormat:@"%@%@=%@&",md5Key,key,randomString];
    }
    
    NSString *stringMD5 = [NSString md5:md5Key];
    NSString * nwStr = [NSString stringWithFormat:@"%@%@",stringMD5,privateKey];
    NSString * sign = [NSString md5:nwStr];

    

    [request setValue:sign forHTTPHeaderField:@"sign"];
    [request setValue:randomString forHTTPHeaderField:@"nonce-str"];
    return request;
}



/** 保存播放进度 */
- (void)saveVideoProgress:(HKDownloadModel *)model dicOrModel:(id)dicOrModel {
    
    HKDownloadModel *downModel = [self queryWidthID:model.videoId videoType:model.videoType];
    if (!isEmpty(downModel)) {
        [self savedownloadModel:model dicOrModel:dicOrModel];
    }else{
        
    }
}

/** 记忆播放 */
// 保存或更新记忆播放
- (BOOL)saveOrUpdateSeekModel:(HKSeekTimeModel *)model {
    return [[HKDownloadDB shareInstance] saveOrUpdateSeekModel:model];
}
// 查询记忆播放
- (HKSeekTimeModel *)querySeekModel:(HKSeekTimeModel *)model {
    return [[HKDownloadDB shareInstance] querySeekModel:model];
}
/** 记忆播放 */



@end
