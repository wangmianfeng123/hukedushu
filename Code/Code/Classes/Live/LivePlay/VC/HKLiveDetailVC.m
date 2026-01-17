//
//  HKLiveCourseVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.1
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveDetailVC.h"
#import "HKLiveCoursePlayer.h"
#import "HKLiveCourseTeacherInfoCell.h"
#import "HKLiveCourseInfoDesCell.h"
#import "HKLiveDetailModel.h"
#import "UMpopView.h"
#import "HKLivingPlayVC2.h"
#import "HKTeacherCourseVC.h"
#import "Reachability.h"
#import "HKRecCourseCell.h"

#define  teacherInfoIndex 0 // 教师信息
#define  recCourseIndex 1 // 推荐课程
#define  courseInfoIndex 2 // 详情信息


@interface HKLiveDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, assign)ZFPlayerPlaybackState playState; // 播放状态

@property (nonatomic, assign)CGFloat htmlHeight;

@property (nonatomic, assign)NSInteger internetStatus;

@end

@implementation HKLiveDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMySettingView];
    
    self.internetStatus = [HkNetworkManageCenter shareInstance].networkStatus;
    [self networkObserver];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)initMySettingView {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.estimatedRowHeight = 0.0;
    tableView.estimatedSectionFooterHeight = 0.0;
    tableView.estimatedSectionHeaderHeight = 0.0;
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
    tableView.delegate= self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveCourseTeacherInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveCourseTeacherInfoCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveCourseInfoDesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveCourseInfoDesCell class])];
    [tableView registerClass:[HKRecCourseCell class] forCellReuseIdentifier:NSStringFromClass([HKRecCourseCell class])];
    
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, tableView);
    tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, (IS_IPHONE_X ?70 :50) + KNavBarHeight64, 0);
     
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.course.recommends.count? 3 : self.model? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (indexPath.row == teacherInfoIndex) { // 教师信息
        HKLiveCourseTeacherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveCourseTeacherInfoCell class])];
        cell.headerIVTapBlock = ^{
            
            [weakSelf pushToTeacherCourseVC:weakSelf.model.teacher.teacher_id];
        };
        cell.followTeacherClickBlock = ^{
            [weakSelf followTeacherToServer];
        };
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == recCourseIndex && self.model.course.recommends.count) { // 推荐教程
        HKRecCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKRecCourseCell class])];
        WeakSelf;
        cell.didSelectedRecBlock = ^(VideoModel *model) {
            !weakSelf.didSelectedRecBlock? : weakSelf.didSelectedRecBlock(model);
        };
        cell.recommends = self.model.course.recommends;
        return cell;
    }  else {
        HKLiveCourseInfoDesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveCourseInfoDesCell class])];
        NSUInteger indexTemp = self.model.course.recommends.count? courseInfoIndex : courseInfoIndex - 1;
        cell.htmlHeightBlock = ^(float height) {
            if (height > weakSelf.htmlHeight) {
                weakSelf.htmlHeight = height;
                NSLog(@"%f", height);

                NSIndexPath *index = [NSIndexPath indexPathForRow:indexTemp inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        cell.model = self.model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return (114 - 25) + self.model.courseNameHeight;
    
    if (indexPath.row == teacherInfoIndex) {
        
        CGFloat teacherHegith = 157 + self.model.teacher.contentHeight + self.model.teacher.organization_name_height;
        // 只有一个的时候去掉，详情高度
        teacherHegith = self.model.series_courses.count > 0? teacherHegith - 50 : teacherHegith;
        return teacherHegith;
    } else if (indexPath.row == recCourseIndex && self.model.course.recommends.count) {
        return 180.0;
    }else {
        return self.htmlHeight;
    }
}

// 进入直播间或者回放
- (void)gotoLivingVCOrPlayBack {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    // 正在直播并且需要付费，并且没有报名
    if (self.model.live.live_status == HKLiveStatusLiving && !self.model.live.isEnroll && self.model.live.price.doubleValue > 0) {
        showTipDialog(@"请至网站付费报名哦~");
        return;
    }
    
    if (self.model.live.live_status != HKLiveStatusEnd) {
        
        // 报名了直接进入
        if (self.model.isEnroll) {
            HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
            vc.live_id = self.model.live.ID;
            [self pushToOtherController:vc];
        } else {
            [self userEnroll:YES];
        }
    } else if (self.model.live.video_id.intValue != 0 && self.model.live.live_status == HKLiveStatusEnd) {
        
        // 回放
        
        if (!self.model.isEnroll) {
            
            // 收费的
            if (self.model.course.price.doubleValue > 0) {
                showTipDialog(@"请至网站付费报名哦~");
            } else {
                
                // 免费的直接报名 并且
                [self userEnrollToServer:NO complete:^{
//                    [weakSelf playLookbackServer];
                }];
            }
            
        } else {
            // 已经报名直接播放
//            [self playLookbackServer];
        }
        
        NSLog(@"点击回放按钮");
    }
    
}


// 进入直播间
- (void)enterLivingVC {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    // 是否已经报名 222
    if (self.model.isEnroll) {
        
        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
        vc.live_id = self.model.live.ID;
        [self pushToOtherController:vc];
        
    } else if (self.model.live.price.doubleValue > 0) {
        showTipDialog(@"请至网站付费报名哦~");
    } else {
        [self userEnrollToServer:YES  complete:nil];
    }
    
}


- (void)pushToTeacherCourseVC:(NSString *)teacherId {
    
    if (isEmpty(teacherId)) {
        NSLog(@"教师id为空!");
        return;
    }
    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
    vc.teacher_id = teacherId;
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
        
    };
    [self pushToOtherController:vc];
}

#pragma mark <友盟分享>
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
//    popView.delegate = self;
    [popView createUIWithModel:model];
}

#pragma mark <Server>
- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    model.live.isEnroll = model.isEnroll;
    model.live.price = model.course.price;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

// 报名观看直播
- (void)userEnroll:(BOOL)isEnterLivingVC {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    // 收费引导去PC购买
    if (self.model.course.price.doubleValue > 0 && !self.model.isEnroll) {
        showTipDialog(@"请至网站付费报名哦~");
    } else if (self.model.course.price.doubleValue > 0 && self.model.isEnroll) {
        showTipDialog(@"报名成功后不可取消哦~");
    } else {
        [self userEnrollToServer:isEnterLivingVC complete:nil];
    }
}

- (void)userEnrollToServer:(BOOL)isEnterLivingVC complete:(void(^)())completeBlock {
    
    if (!self.model.content.live_course_id) return;
    
    NSString *enRollString = self.model.isEnroll? @"0" : @"1";
    
    [HKHttpTool POST:@"live/enroll-or-un-enroll" parameters:@{@"op_type" : enRollString, @"live_course_id" : self.model.content.live_course_id,@"live_catalog_small_id":self.course_id} success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            if (enRollString.intValue == 1) {
                showTipDialog(@"报名成功");
                
                // 注意：针对免费直播，若当前直播距离开播时间不足1h或者正在直播时，报名成功后自动跳转至直播间页面1
                if (!isEnterLivingVC) {
                    // 不做操作
                    
                } else if (self.model.live.live_status == HKLiveStatusLiving || self.model.live.coutDownForLive > 0 || isEnterLivingVC) {
                    HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                    vc.live_id = self.model.live.ID;
                    [self pushToOtherController:vc];
                }
                
            } else {
                showTipDialog(@"取消报名");
            }
            
            // 更新数据
            self.model.isEnroll = enRollString.intValue == 1;
            
            // 更新报名
            self.model.live.isEnroll = self.model.isEnroll;
            !self.refreshBlock? : self.refreshBlock(self.model.live);
            
            !completeBlock? : completeBlock();
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)followTeacherToServer {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    if ([self.model.course.price floatValue]>0) {
        [MobClick event:liveclass_details_followteacher];
    }else{
        [MobClick event:liveclass_free_details_followteacher];
    }
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange followTeacherVideoWithToken:nil teacherId:self.model.teacher.teacher_id type:((self.model.teacher.is_subscription.intValue)? @"1":@"0")completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            // 反向取值
            self.model.teacher.is_subscription = self.model.teacher.is_subscription.intValue? @"0" : @"1";
            
            if (self.model.teacher.is_subscription.intValue) {
                showTipDialog(@"关注成功");
            } else {
                showTipDialog(@"取消关注");
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:teacherInfoIndex inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failBlock:^(NSError *error) {
        
    }];
}


#pragma mark <网络切换变换监听>
- (void)networkObserver {
    [MyNotification addObserver:self
                       selector:@selector(networkNotification:)
                           name:KNetworkStatusNotification
                         object:nil];
}

- (void)networkNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    self.internetStatus = status;
    
    
    // 如果正在播放4g
    if (self.playState == ZFPlayerPlayStatePaused && status == AFNetworkReachabilityStatusReachableViaWWAN) {
        showTipDialog(@"当前没有Wifi，回放会消耗流量哦~");
    }
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


-(void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



@end
