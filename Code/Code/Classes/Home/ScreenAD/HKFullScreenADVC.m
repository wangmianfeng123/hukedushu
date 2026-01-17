
//
//  HKFullScreenADVC.m
//  Code
//
//  Created by Ivan li on 2018/9/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKFullScreenADVC.h"
#import "HKFullScreenAdView.h"
#import "BannerModel.h"
#import "HKH5PushToNative.h"
#import "HKAdWindow.h"
#import "AppDelegate.h"



@interface HKFullScreenADVC ()

@property(nonatomic,assign)BOOL isTimeOut;

@end

@implementation HKFullScreenADVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置背景图
    UIImageView *imageView = [UIImageView new];
//    imageView.frame = self.view.bounds;
    imageView.image = [HKFullScreenAdView getLaunchImage];//[HKFullScreenAdView getLaunchImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.7 * 183 / 266.0));
    }];
    [self fullScreenAdRequest];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** 广告信息请求 */
- (void)fullScreenAdRequest {
    
    self.isTimeOut = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isTimeOut) {
            [HKAdWindow closeADWindow];
            [self postNotice];
        }
    });

    [HKHttpTool POST:ADVERTISING_INIT_ADS parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            self.isTimeOut = NO;
            [self setFullScreenAdView:responseObject];
        }else{
            [HKAdWindow closeADWindow];
            [self postNotice];
        }
    } failure:^(NSError *error) {
        [HKAdWindow closeADWindow];
        [self postNotice];
    }];
}



- (void)setFullScreenAdView:(NSDictionary*)responseObject {
    
    __block HKMapModel *model = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"ad"]];
    HKFullScreenAdView *adView = [[HKFullScreenAdView alloc] init];
    adView.tag = 2121;
    adView.duration = 3;
    adView.waitTime = 1;
//    adView.waitTime = model.img_url.length ? 2:1;
    adView.skipType = SkipButtonTypeNormalTimeAndText;
    adView.adImageTapBlock = ^(NSString *content) {
        // 测试 UI 跳转
        /*
         if (DEBUG) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"app_1" ofType:@"json"];
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            HKMapModel *adsModel = [HKMapModel mj_objectWithKeyValues:[jsonDict objectForKey:@"JP_Data"]];
            if (!isEmpty(adsModel.class_name)) {
                [HKH5PushToNative runtimePush:adsModel.class_name arr:adsModel.list currectVC:[AppDelegate sharedAppDelegate].window.rootViewController];
            }
        }
         
         if (DEBUG) {
         for (AdvertParameterModel *temp in model.redirect_package.list) {
         temp.value = @"https://www.baidu.com/";
         }
         }
         
        */
        
        if (!isEmpty(model.redirect_package.class_name)) {
            [HKALIYunLogManage sharedInstance].button_id = @"1";
            [[HomeServiceMediator sharedInstance] advertisClickCount:model.ad_id];
            [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:[AppDelegate sharedAppDelegate].window.rootViewController];
        }
    };
    
    adView.hkAdViewDismissBlock = ^(BOOL isActivity) {
        if (!isActivity) {
            [self postNotice];
        }
        [HKAdWindow closeADWindow];
    };
    
    NSString *url = model.img_url;
    //@"http://s8.mogucdn.com/p2/170223/28n_4eb3la6b6b0h78c23d2kf65dj1a92_750x1334.jpg";
    if (!isEmpty(url)) {
        [adView reloadAdImageWithUrl:url]; // 加载广告图
        [self.view addSubview:adView];
    }else{
        [self.view addSubview:adView];
        [HKAdWindow closeADWindow];
    }
}

- (void)postNotice{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeADWindow" object:nil];
//    });
}


@end







