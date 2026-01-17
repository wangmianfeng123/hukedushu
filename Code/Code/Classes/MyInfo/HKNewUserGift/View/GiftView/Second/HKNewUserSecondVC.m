
//
//  HKNewUserSecondVC.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserSecondVC.h"
#import "HKNewUserSecondView.h"
#import <UMShare/UMShare.h>
#import "HKHomeGiftModel.h"


@interface HKNewUserSecondVC ()<HKNewUserSecondViewDelegate>

@property (nonatomic,strong) HKNewUserSecondView *secondView;

@property (nonatomic,strong)ShareModel  *shareM;

@property (nonatomic,strong)HKHomeGiftModel *giftM;

@end

@implementation HKNewUserSecondVC

- (instancetype)initWithModel:(HKHomeGiftModel *)model {
    if (self = [super init]) {
        self.giftM = model;
        self.shareM = model.share_data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



+ (void)presentHKNewUserSecondVC:(HKHomeGiftModel *)model {
    
    UIViewController *topVC = [CommonFunction topViewController];
    
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([HKNewUserSecondVC class])]) {
        return;
    }else{
        HKNewUserSecondVC *VC = [[HKNewUserSecondVC alloc]initWithModel:model];
        UINavigationController *loginVC = [[UINavigationController alloc]initWithRootViewController:VC];
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (nil != topVC) {
            [topVC presentViewController:loginVC animated:YES completion:nil];
        }
    }
}


- (void)closeAction {
    
    showCustomViewDialogWithText(Tomorrow_Can_Get_Gift, 3, 50);
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)createUI {
    self.view.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
    [self.view addSubview:self.secondView];
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (HKNewUserSecondView*)secondView {
    WeakSelf;
    if (!_secondView) {
        _secondView = [[HKNewUserSecondView alloc]init];
        _secondView.delegate = self;
        _secondView.hkNewUserFirstViewBlock = ^(NSString *title) {
            [weakSelf closeAction];
        };
        _secondView.model = self.giftM;
    }
    return _secondView;
}


#pragma mark HKNewUserSecondView delegate

- (void)newUserShare:(HKNewUserSecondView*)view  btn:(UIButton*)btn platform:(UMSocialPlatformType)platform {
    
    /** 1-web  2-图片 */
    NSString *share_type = self.shareM.share_type;
    
    if ([share_type isEqualToString:@"1"] || isEmpty(share_type)) {
        [self shareHtmlWithModel:self.shareM platformType:platform];
    }else if ([share_type isEqualToString:@"2"]) {
        [self shareImageToPlatformType:platform shareModel:self.shareM];
    }
}




#pragma mark - 分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType shareModel:(ShareModel*)shareModel {
    
    WeakSelf;
    __block ShareModel *_shareModel = shareModel;
    NSString *img_url = _shareModel.img_url;
    
    if (isEmpty(img_url) && (_shareModel.share_image == nil)) {
        return;
    }
    
    if (!isEmpty(img_url)) {
        if ([img_url containsString:@"/webp"]) {
            if ([img_url containsString:@".jpg"]) {
                
                NSRange range = [img_url rangeOfString:@".jpg"];
                img_url  = [img_url substringToIndex:range.location+4];
                
            }else if ([img_url containsString:@".gif"]) {
                
                NSRange range = [img_url rangeOfString:@".gif"];
                img_url = [img_url substringToIndex:range.location+4];
                
            }else{
                
            }
        }
    }
    
    //设置分享内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:(_shareModel.share_image != nil) ?_shareModel.share_image :img_url];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            showTipDialog(Cancel_Share);
        }else{
            StrongSelf;
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享成功
                [strongSelf uMShareWebSucess:shareModel];
            }else{
                //分享失败
                [strongSelf uMShareWebFail:shareModel];
            }
        }
    }];
}






#pragma mark -  友盟网页分享
- (void)UMshareWebToPlatformType:(UMSocialPlatformType)platformType  model:(ShareModel*)model image:(UIImage*)image {
    
    //创建网页内容对象
    NSString* thumbURL = nil; //微信分享 图片路径为 http  微博 https
    if (platformType == UMSocialPlatformType_WechatSession ||platformType == UMSocialPlatformType_WechatTimeLine) {
        if ([model.img_url containsString:@"https"]) {
            thumbURL = [model.img_url stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        }
    }else{
        thumbURL = model.img_url;
    }
    if (UMSocialPlatformType_Sina == platformType) {
        if ([thumbURL containsString:@"/webp"]) {
            if ([thumbURL containsString:@".jpg"]) {
                
                NSRange range = [thumbURL rangeOfString:@".jpg"];
                thumbURL  = [thumbURL substringToIndex:range.location+4];
            }else if ([thumbURL containsString:@".gif"]) {
                NSRange range = [thumbURL rangeOfString:@".gif"];
                thumbURL = [thumbURL substringToIndex:range.location+4];
            }else{
            }
        }
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:model.info
                                                                         thumImage:(image==nil) ?thumbURL :image];
    shareObject.webpageUrl = model.web_url;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObject;
    //调用分享接口
    WeakSelf;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        StrongSelf;
        if (error) {
            showTipDialog(Cancel_Share);
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享成功
                [strongSelf uMShareWebSucess:model];
            }else{
                [strongSelf uMShareWebFail:model];
            }
        }
    }];
}


#pragma mark -  1-先下载图片  2-分享html
- (void)shareHtmlWithModel:(ShareModel*)model  platformType:(UMSocialPlatformType)platformType {
    WeakSelf;
    NSString *url = model.img_url;
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        StrongSelf;
        [strongSelf UMshareWebToPlatformType:platformType model:model image:image];
    }];
}



- (void)uMShareWebSucess:(ShareModel*)model {
    
    [self shareSucessWithModel:model];
}


- (void)uMShareWebFail:(ShareModel*)model {
    showTipDialog(Share_Fail);
}


#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        [self.secondView setShareSucessView];
    } failure:^(NSError *error) {
        
    }];
}



@end



