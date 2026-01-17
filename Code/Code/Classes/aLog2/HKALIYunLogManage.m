//
//  HKALIYunLog.m
//  Code
//
//  Created by Ivan li on 2019/3/30.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKALIYunLogManage.h"
#import "AliyunLogProducer/AliyunLogProducer.h"
#import "HKVersionModel.h"
//#import <AliyunLogObjc/AliyunLogObjc.h>
//#import <AliyunLogObjc/Sls.pbobjc.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


NSString *ALI_LOG_TOKEN = @"/site/get-alilog-token";//埋点token获取接口

NSString *ALI_HOST = @"cn-shanghai.log.aliyuncs.com";

NSString *ALI_PROJECT = @"huke";
NSString *ALI_PROJECT_TEST = @"huke-dev";




NSString *BASE_URL = @"https://api.huke88.com";

NSString *ALI_INFO_KEY_Id = @"ALI_INFO_KEY_Id";

NSString *ALI_INFO_KEY_Secret = @"ALI_INFO_KEY_Secret";

NSString *ALI_INFO_KEY_Token = @"ALI_INFO_KEY_Token";

NSString *ALI_INFO_KEY_Expiration = @"ALI_INFO_KEY_Expiration";


static id object;


static HKALIYunLogManage *sharedInstance = nil;


@interface HKALIYunLogManage ()

@property (nonatomic , strong)LogProducerConfig * videoConfig;
@property (nonatomic , strong)LogProducerConfig * recordConfig;
@property (nonatomic , strong)LogProducerConfig * play_timeConfig;
@property (nonatomic , strong)LogProducerConfig * book_Config;
@property (nonatomic , strong)LogProducerConfig * errorConfig;
@property (nonatomic , strong)LogProducerConfig * btn_clickConfig;
@property (nonatomic , strong)LogProducerConfig * short_videoConfig;
@property (nonatomic , strong)LogProducerConfig * pay_trackConfig;
@property (nonatomic , strong)LogProducerConfig * pay_successConfig;

@property (nonatomic , strong)LogProducerClient * videoClient;
@property (nonatomic , strong)LogProducerClient * recordClient;
@property (nonatomic , strong)LogProducerClient * play_timeClient;
@property (nonatomic , strong)LogProducerClient * book_Client;
@property (nonatomic , strong)LogProducerClient * errorClient;
@property (nonatomic , strong)LogProducerClient * btn_clickClient;
@property (nonatomic , strong)LogProducerClient * short_videoClient;
@property (nonatomic , strong)LogProducerClient * pay_trackClient;
@property (nonatomic , strong)LogProducerClient * pay_successClient;


@end


@implementation HKALIYunLogManage

+ (instancetype)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)setBaseConfig {
    self.logModel.AccessKeyId = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Id];
    self.logModel.AccessKeySecret = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Secret];
    self.logModel.SecurityToken = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Token];

    self.logModel.Expiration = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Expiration];

    if (isEmpty(self.logModel.AccessKeyId)) {
        //[self requestLogBaseInfo];
        NSLog(@"请求get-alilog-token");
        

        [HKHttpTool POST:ALI_LOG_TOKEN baseUrl:BASE_URL parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                HKALIYunLogModel *model = [HKALIYunLogModel mj_objectWithKeyValues:responseObject[@"data"]];
                self.logModel = model;

                if (!isEmpty(model.AccessKeyId)) {
                    [HKNSUserDefaults setValue:model.AccessKeyId forKey:ALI_INFO_KEY_Id];
                    [HKNSUserDefaults setValue:model.AccessKeySecret forKey:ALI_INFO_KEY_Secret];
                    [HKNSUserDefaults setValue:model.SecurityToken forKey:ALI_INFO_KEY_Token];
                    [HKNSUserDefaults setValue:model.Expiration forKey:ALI_INFO_KEY_Expiration];
                    [HKNSUserDefaults synchronize];
                }
            }
        } failure:^(NSError *error) {

        }];
    }
}


- (void)setReFreshBaseConfig:(void(^)(NSString *AccessKeyId,NSString *AccessKeySecret,NSString *SecurityToken))resultBlock{
    self.logModel.AccessKeyId = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Id];
    self.logModel.AccessKeySecret = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Secret];
    self.logModel.SecurityToken = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Token];
    self.logModel.Expiration = [HKNSUserDefaults objectForKey:ALI_INFO_KEY_Expiration];

    if (isEmpty(self.logModel.AccessKeyId)) {
        //[self requestLogBaseInfo];
        NSLog(@"请求get-alilog-token");
        
        [HKHttpTool POST:ALI_LOG_TOKEN baseUrl:BASE_URL parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                HKALIYunLogModel *model = [HKALIYunLogModel mj_objectWithKeyValues:responseObject[@"data"]];
                self.logModel = model;

                if (!isEmpty(model.AccessKeyId)) {
                    [HKNSUserDefaults setValue:model.AccessKeyId forKey:ALI_INFO_KEY_Id];
                    [HKNSUserDefaults setValue:model.AccessKeySecret forKey:ALI_INFO_KEY_Secret];
                    [HKNSUserDefaults setValue:model.SecurityToken forKey:ALI_INFO_KEY_Token];
                    [HKNSUserDefaults setValue:model.Expiration forKey:ALI_INFO_KEY_Expiration];
                    [HKNSUserDefaults synchronize];
                    if (resultBlock) {
                        resultBlock(model.AccessKeyId,model.AccessKeySecret,model.SecurityToken);
                    }
                }
            }
        } failure:^(NSError *error) {

        }];
    }
}

- (void)removeBaseConfig {
    [HKNSUserDefaults setValue:@"" forKey:ALI_INFO_KEY_Id];
    [HKNSUserDefaults synchronize];
}



- (HKALIYunLogModel *)logModel {
    if (!_logModel) {
        _logModel = [HKALIYunLogModel new];
    }
    return _logModel;
}

- (LogProducerConfig *)configWithLogstoreName:(NSString *)logstoreName {
    LogProducerConfig* config;
    if (HKIsDebug) {
        config = [[LogProducerConfig alloc] initWithEndpoint:ALI_HOST project:ALI_PROJECT_TEST logstore:logstoreName accessKeyID:self.logModel.AccessKeyId accessKeySecret:self.logModel.AccessKeySecret securityToken:self.logModel.SecurityToken] ;
    }else{
        config = [[LogProducerConfig alloc] initWithEndpoint:ALI_HOST project:ALI_PROJECT logstore:logstoreName accessKeyID:self.logModel.AccessKeyId accessKeySecret:self.logModel.AccessKeySecret securityToken:self.logModel.SecurityToken] ;
    }
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *Path = [[paths lastObject] stringByAppendingString:[NSString stringWithFormat:@"/%@-log.dat",logstoreName]];
    //NSString *Path = [[paths lastObject] stringByAppendingString:@"/log.dat"];

    // 设置主题
    [config SetTopic:@"ios"];
    // 每个缓存的日志包的大小上限，取值为1~5242880，单位为字节。默认为1024 * 1024
    [config SetPacketLogBytes:1024*1024];
    // 每个缓存的日志包中包含日志数量的最大值，取值为1~4096，默认为1024
    [config SetPacketLogCount:1024];
    // 被缓存日志的发送超时时间，如果缓存超时，则会被立即发送，单位为毫秒，默认为3000
    [config SetPacketTimeout:3000];
    // 单个Producer Client实例可以使用的内存的上限，超出缓存时add_log接口会立即返回失败
    // 默认为64 * 1024 * 1024
    [config SetMaxBufferLimit:64*1024*1024];
    // 发送线程数，默认为1
    [config SetSendThreadCount:1];
    
    [config SetDropDelayLog:1];
    

    // 1 开启断点续传功能， 0 关闭
    // 每次发送前会把日志保存到本地的binlog文件，只有发送成功才会删除，保证日志上传At Least Once
    [config SetPersistent:0];
    // 持久化的文件名，需要保证文件所在的文件夹已创建。
    [config SetPersistentFilePath:Path];
    // 是否每次AddLog强制刷新，高可靠性场景建议打开
    [config SetPersistentForceFlush:1];
    // 持久化文件滚动个数，建议设置成10。
    [config SetPersistentMaxFileCount:10];
    // 每个持久化文件的大小，建议设置成1-10M
    [config SetPersistentMaxFileSize:1024*1024];
    // 本地最多缓存的日志数，不建议超过1M，通常设置为65536即可
    [config SetPersistentMaxLogCount:65536];

    // 注册 获取服务器时间 的函数
    //[config SetGetTimeUnixFunc:time];
    
    return config;
}


- (Log*)rawLog {

    Log* log1 = [[Log alloc] init];
    //平台(10:安卓，11:安卓平板， 20:IOS， 21:IOS平板)
    NSString *platform = IS_IPAD ? @"21" :@"20";
    [log1 PutContent:@"platform" value:platform];

    [log1 PutContent:@"device_number" value:[CommonFunction getUUIDFromKeychain]];////设备号(设备唯一编号)

    //用户ID（登录就传UID， 没登录就传0）
    NSString *userId = [CommonFunction getUserId];
    [log1 PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];
    
    
    //用户属性(1:未登录/2:普通用户/30:VIP用户)
    //vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP  （-1 过期），
    NSString *vipClass = [HKAccountTool shareAccount].vip_class;
    NSString *user_type = @"";
    if (isLogin()) {
        if ( (0 == [vipClass intValue]) || (-1 == [vipClass intValue]) ) {
            user_type = @"2";
        }else{
            user_type = @"30";
        }
    }else{
        user_type = @"1";
    }

    [log1 PutContent:@"user_type" value:user_type];
    
    
    NSString * version = [CommonFunction appCurVersion];
    if (!isEmpty(version)) {
        [log1 PutContent:@"api_version" value:version];
    }
    return log1;
}

/** 统计短视频播放 */
- (void)shortVideoPlayCountLogWithVideoId:(NSString *)videoId {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(videoId)) {
            if (!self.videoConfig) {
                NSString *ALI_STORE = @"app_play_short_video";
                self.videoConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.videoClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.videoConfig callback:on_log_send_done];
            }
            
            Log * log = [self rawLog];
            [log PutContent:@"vid" value:videoId];
            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.videoClient AddLog:log flush:1];
        }
    }
}



/** 短视频相关 统计点击数**/

- (void)shortVideoClickLogWithIdentify:(NSString *)identify {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(identify)) {
            if (!self.recordConfig) {
                NSString *ALI_STORE = @"app-click-record";
                self.recordConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.recordClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.recordConfig callback:on_log_send_done];
            }
            
            Log * log = [self rawLog];
            [log PutContent:@"identify" value:identify];
            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.recordClient AddLog:log flush:1];
        }
    }
}






/**
 统计短视频播放时长

 @param second  秒
 */
- (void)shortVideoPlayTimeLogWithVideoId:(NSString *)videoId second:(NSInteger )second {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (second>1 && !isEmpty(videoId)) {
            
            if (!self.play_timeConfig) {
                NSString *ALI_STORE = @"app_short_video_play_time";
                self.play_timeConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.play_timeClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.play_timeConfig callback:on_log_send_done];
            }
            
            
            Log * log = [self rawLog];
            [log PutContent:@"vid" value:videoId];
            [log PutContent:@"play_time" value:[NSString stringWithFormat:@"%ld",second]];
            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.play_timeClient AddLog:log flush:1];
        }
    }
}


/**
 虎课读书 统计点击数

 @param flag flag 1:列表访问, 2:列表项点击, 3:详情页访问, 4:图书课程播放, 5:分享图书, 6:收藏图书, 7:添加评论
 @param bookId 书ID
 @param courseId  课程ID
 */
- (void)hkBookClickLogWithFlag:(NSString*)flag bookId:(NSString*)bookId  courseId:(NSString*)courseId {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(bookId)) {
            if (!self.book_Config) {
                NSString *ALI_STORE = @"app_book_statistics";
                self.book_Config = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.book_Client = [[LogProducerClient alloc] initWithLogProducerConfig:self.book_Config callback:on_log_send_done];
                
            }
            
            Log * log = [self rawLog];
            [log PutContent:@"book_id" value:bookId];
            [log PutContent:@"course_id" value:courseId];
            
            //用户ID（登录就传UID， 没登录就传0）
            NSString *userId = [CommonFunction getUserId];
            [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];

            if (!isEmpty(flag)) {
                [log PutContent:@"flag" value:flag];
            }
            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.book_Client AddLog:log flush:1];
        }
    }
}


- (void)hkErrorLogWithCode:(NSString*)code message:(NSString*)message{
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(message) || !isEmpty(code)) {
            if (!self.errorConfig) {
                NSString *ALI_STORE = @"app_error_log";
                self.errorConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.errorClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.errorConfig callback:on_log_send_done];
            }
                    
            Log * log = [self rawLog];
            //用户ID（登录就传UID， 没登录就传0）
            NSString *userId = [CommonFunction getUserId];
            [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];

            if (!isEmpty(message)) {
                [log PutContent:@"message" value:message];
            }
            if (!isEmpty(code)) {
                [log PutContent:@"code" value:code];
            }
            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.errorClient AddLog:log flush:1];
        }
    }
}




- (void)hkVideoPlayWithBtnId:(NSString*)btnId  showType:(NSString*)showType {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(btnId)) {
            if (!self.btn_clickConfig) {
                NSString *ALI_STORE = @"app-btn-click-record";
                self.btn_clickConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.btn_clickClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.btn_clickConfig callback:on_log_send_done];
            }
            
            
            Log * log = [self rawLog];
            [log PutContent:@"btn_id" value:btnId];
            [log PutContent:@"btn_type" value:showType];
            
            //用户ID（登录就传UID， 没登录就传0）
            NSString *userId = [CommonFunction getUserId];
            [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];

            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
            [self.btn_clickClient AddLog:log flush:1];
        }
    }
}


#pragma mark - 推送点击
- (void)hkNotificationWithBtnId:(NSString*)btnId  showType:(NSString*)showType  pushType:(NSString*)pushType {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!isEmpty(btnId)) {
            if (!self.btn_clickConfig) {
                NSString *ALI_STORE = @"app-btn-click-record";
                self.btn_clickConfig = [self configWithLogstoreName:ALI_STORE];
                //创建client
                self.btn_clickClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.btn_clickConfig callback:on_log_send_done];
            }
            
            
            Log * log = [self rawLog];
            [log PutContent:@"btn_id" value:btnId];
            [log PutContent:@"btn_type" value:showType];
            
            //用户ID（登录就传UID， 没登录就传0）
            NSString *userId = [CommonFunction getUserId];
            [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];
            
            if (!isEmpty(pushType)) {
                [log PutContent:@"extra_type" value:pushType];
            }

            // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
           [self.btn_clickClient AddLog:log flush:1];
        }
    }
}







/**
 短视频 统计点击数

 @param flag flag
 1:来源视频按钮点击
 2:推荐视频按钮点击
 3.通过短视频推荐视频跳转视频详情页的视频收藏
 4.通过短视频推荐视频跳转视频详情页的视频播放
 5.通过短视频来源视频跳转视频详情页的视频收藏
 6.通过短视频来源视频跳转视频详情页的视频播放
 */

- (void)hkShortVideoClickLogWithFlag:(NSString*)flag {
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!self.short_videoConfig) {
            NSString *ALI_STORE = @"app_short_video_tag_statistics";
            self.short_videoConfig = [self configWithLogstoreName:ALI_STORE];
            //创建client
            self.short_videoClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.short_videoConfig callback:on_log_send_done];
        }
        
        
        Log * log = [self rawLog];
        //用户ID（登录就传UID， 没登录就传0）
        NSString *userId = [CommonFunction getUserId];
        [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];
        
        if (!isEmpty(flag)) {
            [log PutContent:@"flag" value:flag];
        }

        // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
        [self.short_videoClient AddLog:log flush:1];
    }
}



- (void)applePayWithStep:(NSString *)step stepDesc:(NSString *)step_desc payInfo:(NSString *)pay_info vipType:(NSString *)vip_type{
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        
        if (!self.pay_trackConfig) {
            NSString *ALI_STORE = @"app-pay-track-log";
            self.pay_trackConfig = [self configWithLogstoreName:ALI_STORE];
            //创建client
            self.pay_trackClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.pay_trackConfig callback:on_log_send_done];
        }
        
        Log * log = [self rawLog];
        //用户ID（登录就传UID， 没登录就传0）
        NSString *userId = [CommonFunction getUserId];
        [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];
        
        if (!isEmpty(step)) {
            [log PutContent:@"step" value:step];
        }
        if (!isEmpty(step_desc)) {
            [log PutContent:@"step_desc" value:step_desc];
        }
        if (!isEmpty(pay_info)) {
            [log PutContent:@"pay_info" value:pay_info];
        }
        if (!isEmpty(vip_type)) {
            [log PutContent:@"vip_type" value:vip_type];
        }
        // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
        [self.pay_trackClient AddLog:log flush:1];
    }
}

- (void)applePayWithOrder_id:(NSString *)order_id payPrice:(NSString *)price{
    if (isEmpty(self.logModel.AccessKeyId)) {
        [self setBaseConfig];
    }else{
        if (!self.pay_successConfig) {
            NSString *store = @"app_pay_success_track";
            self.pay_successConfig = [self configWithLogstoreName:store];
            //创建client
            self.pay_successClient = [[LogProducerClient alloc] initWithLogProducerConfig:self.pay_successConfig callback:on_log_send_done];
        }
        
        
        Log * log = [self rawLog];
        //用户ID（登录就传UID， 没登录就传0）
        NSString *userId = [CommonFunction getUserId];
        [log PutContent:@"uid" value:(isEmpty(userId)? @"0" :userId)];
        
        if (!isEmpty(order_id)) {
            [log PutContent:@"order_id" value:order_id];
        }
        if (!isEmpty(price)) {
            [log PutContent:@"price" value:price];
        }
                
        if (!isEmpty([HKInitConfigManger sharedInstance].channel)) {
            if ([[HKInitConfigManger sharedInstance].channel isEqualToString:@"hukeAPP"]) {
                /// 默认渠道 不统计
                NSString *nullStr = @" ";
                [log PutContent:@"channel" value:nullStr];;
            }else{
                [log PutContent:@"channel" value:[HKInitConfigManger sharedInstance].channel];
            }
        }
        
        if (!isEmpty(self.button_id)) {
            [log PutContent:@"button_id" value:self.button_id];
        }
        // addLog第二个参数flush，是否立即发送，1代表立即发送，不设置时默认为0
       [self.pay_successClient AddLog:log flush:1];
    }
}

void on_log_send_done(const char * config_name, log_producer_result result, size_t log_bytes, size_t compressed_bytes, const char * req_id, const char * message, const unsigned char * raw_buffer, void * userparams) {
    if (result == LOG_PRODUCER_OK) {
        printf("send success, config : %s, result : %d, log bytes : %d, compressed bytes : %d, request id : %s \n", config_name, (result), (int)log_bytes, (int)compressed_bytes, req_id);
    }else if (result == LOG_PRODUCER_SEND_UNAUTHORIZED){
        printf("send fail   , config : %s, result : %d, log bytes : %d, compressed bytes : %d, request id : %s \n, error message : %s\n", config_name, (result), (int)log_bytes, (int)compressed_bytes, req_id, message);
        
        HKALIYunLogManage *sharedInstance = [HKALIYunLogManage sharedInstance];
        [[HKALIYunLogManage sharedInstance] removeBaseConfig];
        [[HKALIYunLogManage sharedInstance] setReFreshBaseConfig:^(NSString *AccessKeyId, NSString *AccessKeySecret, NSString *SecurityToken) {
            [[HKALIYunLogManage sharedInstance].videoConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].recordConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].play_timeConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].book_Config ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].errorConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].btn_clickConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].short_videoConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [sharedInstance.pay_trackConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
            [[HKALIYunLogManage sharedInstance].pay_successConfig ResetSecurityToken:AccessKeyId accessKeySecret:AccessKeySecret securityToken:SecurityToken];
        }];
    }else {
        printf("send fail   , config : %s, result : %d, log bytes : %d, compressed bytes : %d, request id : %s \n, error message : %s\n", config_name, (result), (int)log_bytes, (int)compressed_bytes, req_id, message);
    }
}

@end








@implementation HKALIYunLogModel


@end



