
//
//  UMpopView.m
//  Code
//
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
////

#import "UMpopView.h"
#import "UMShareCell.h"
#import "HKWechatLoginShareCallback.h"
#import <ZFPlayer/ZFLandscapeWindow.h>
@class UMpopScreenshotHeadView;


#define itemWH (SCREEN_WIDTH - (cols - 1) * margin*Ratio) / cols

static NSInteger const cols = 3; //列

static CGFloat margin = 65; //间隔

static CGFloat cancleHeight = PADDING_25*2 ; //取消按钮高度

static CGFloat headViewHeight = 55 ; //头视图高度

static CGFloat cancleViewHeight = 50 ; //底部取消视图高度

static CGFloat animationTime = 0.25; //动画时间。从下面移动到上面

static NSInteger const minimumLineSpacing = PADDING_20; //20-item 竖间距



@interface UMpopView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    NSTimer *_timer;
}

@property(nonatomic,strong)UICollectionView *contanerView;

@property(nonatomic,strong)UIView *maskView; //背景视图

@property(nonatomic,strong)UMShareCell *cell;

@property(nonatomic,strong)UIButton *cancleBtn;

@property(nonatomic,strong)UIView  *cancleView;

@property(nonatomic,assign)CGFloat bgViewHeith;

@end



static UMpopView *_instance = nil;

@implementation UMpopView


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}



- (void)createUIWithModel:(ShareModel*)shareModel {
    
    if (![UMpopView isHaveSharePlatform]) {
        showTipDialog(@"暂时不能分享");
        return;
    }
    
    if (self.shareModel) {
        self.shareModel = nil;
    }
    self.shareModel = shareModel;
    [self setSharePlatform];
    [self setUI];
    [self showPickView];
}

- (void)dealloc {
    TT_INVALIDATE_TIMER(_timer);
    NSLog(@"dealloc pop");
}


#pragma mark - 检查客户端是否支持分享
- (BOOL)isSupportClientShare:(NSInteger)clientCode {
    //    UMSocialPlatformType_QQ; -- UMSocialPlatformType_Sina --UMSocialPlatformType_WechatSession;
    
    if (UMSocialPlatformType_WechatSession  == clientCode || UMSocialPlatformType_WechatTimeLine  == clientCode) {
        return [WXApi isWXAppSupportApi];
    }
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}

BOOL isSupportClientShare(NSInteger clientCode) {
    if (UMSocialPlatformType_WechatSession  == clientCode || UMSocialPlatformType_WechatTimeLine  == clientCode) {
        return [WXApi isWXAppSupportApi];
    }
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}



+ (BOOL)isHaveSharePlatform {
    if ( isSupportClientShare(UMSocialPlatformType_QQ) || isSupportClientShare(UMSocialPlatformType_WechatSession)
        || isSupportClientShare(UMSocialPlatformType_Qzone) || isSupportClientShare(UMSocialPlatformType_WechatTimeLine)
        || isSupportClientShare(UMSocialPlatformType_Sina)){
        
        return YES;
    }else{
        return NO;
    }
}





#pragma mark - 初始化 已安装的平台
- (void)setSharePlatform {
    
    if (self.imageArr.count) {
        [self.imageArr removeAllObjects];
    }
    if (self.textArr.count) {
        [self.textArr removeAllObjects];
    }
    if (self.platformArr.count) {
        [self.platformArr removeAllObjects];
    }
    
    if (self.shareModel.channel_list.count) {
        //遍历可分享平台
        for (SocialChannelModel *model in self.shareModel.channel_list ) {
            [self setPlatformWithModel:model];
        }
    }else{
        [self setAllPlatform];
    }
}


/** 创建可分享平台 */
- (void)setPlatformWithModel:(SocialChannelModel*)model {
    
    NSString *channel = model.channel;
    if ([channel isEqualToString:@"1"] &&[self isSupportClientShare:UMSocialPlatformType_QQ]) {
        [self.imageArr addObject:@"um_qq_login"];
        [self.textArr addObject:@"QQ"];
        [self.platformArr addObject:@"4"];
    }
    
    if ([channel isEqualToString:@"2"] && [self isSupportClientShare:UMSocialPlatformType_Qzone]) {
        [self.imageArr addObject:@"um_qqzone"];
        [self.textArr addObject:@"QQ空间"];
        [self.platformArr addObject:@"5"];
    }
    
    if ([channel isEqualToString:@"3"] && [self isSupportClientShare:UMSocialPlatformType_WechatSession]) {
        [self.imageArr addObject:@"um_wechat"];
        [self.textArr addObject:@"微信"];
        [self.platformArr addObject:@"1"];
    }
    
    if ([channel isEqualToString:@"4"] && [self isSupportClientShare:UMSocialPlatformType_WechatTimeLine]) {
        [self.imageArr addObject:@"um_wechat_friend"];
        [self.textArr addObject:@"朋友圈"];
        [self.platformArr addObject:@"2"];
    }
    
    if ([channel isEqualToString:@"5"] && [self isSupportClientShare:UMSocialPlatformType_Sina]) {
        [self.imageArr addObject:@"um_weibo"];
        [self.textArr addObject:@"微博"];
        [self.platformArr addObject:@"0"];
    }
}


/** 创建全部分享平台 */
- (void)setAllPlatform {
    
    if ([self isSupportClientShare:UMSocialPlatformType_QQ]) {
        [self.imageArr addObject:@"um_qq_login"];
        [self.textArr addObject:@"QQ"];
        [self.platformArr addObject:@"4"];
    }
    
    if ([self isSupportClientShare:UMSocialPlatformType_Qzone]) {
        [self.imageArr addObject:@"um_qqzone"];
        [self.textArr addObject:@"QQ空间"];
        [self.platformArr addObject:@"5"];
    }
    
    if ([self isSupportClientShare:UMSocialPlatformType_WechatSession]) {
        [self.imageArr addObject:@"um_wechat"];
        [self.textArr addObject:@"微信"];
        [self.platformArr addObject:@"1"];
    }
    
    if ([self isSupportClientShare:UMSocialPlatformType_WechatTimeLine]) {
        [self.imageArr addObject:@"um_wechat_friend"];
        [self.textArr addObject:@"朋友圈"];
        [self.platformArr addObject:@"2"];
    }
    
    if ([self isSupportClientShare:UMSocialPlatformType_Sina]) {
        [self.imageArr addObject:@"um_weibo"];
        [self.textArr addObject:@"微博"];
        [self.platformArr addObject:@"0"];
    }
}


- (NSMutableArray*)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray*)textArr {
    if (!_textArr) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

- (NSMutableArray*)platformArr {
    if (!_platformArr) {
        _platformArr = [NSMutableArray array];
    }
    return _platformArr;
}



- (void)setUI {
    self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
    self.frame = [self frontWindow].bounds;
    
    UIView *frontWindow = [self frontWindow];
    
    [frontWindow addSubview:self];
    
    [self addSubview:self.maskView];
    [self fuzzy];
    
    headViewHeight = 55;
    UMpopHeadView *headerView = [[UMpopHeadView alloc]initWithFrame:CGRectZero];
    [self.maskView addSubview:headerView];
    
    [self.maskView addSubview:self.contanerView];
    [self.maskView addSubview:self.cancleView];
}

#pragma mark - FrontWindow
- (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported;
        if(![window isKindOfClass:[ZFLandscapeWindow class]]){
            windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        }else{
            windowLevelSupported = YES;
        }
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrientation == UIDeviceOrientationLandscapeRight || currentOrientation == UIDeviceOrientationLandscapeLeft) {
        self.contanerView.x = STATUS_BAR_XH;
    }else{
        self.contanerView.x = 0;
    }    
    self.cancleBtn.frame= CGRectMake(0, 0, self.width, cancleHeight);
    
    
    //    switch (currentOrientation) {
    //        case UIInterfaceOrientationLandscapeLeft: case UIInterfaceOrientationLandscapeRight:
    //        {
    //            // 全屏时 清除分享页面
    //            [self immediateRemoveView];
    //        }
    //            break;
    //        default:
    //            break;
    //    }
}



//毛玻璃
-(void)fuzzy{
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = self.maskView.bounds;
    [self.maskView addSubview:view];
}


- (UIView*)maskView {
    
    if (!_maskView) {
        NSInteger count = self.imageArr.count;
        NSInteger rows = (count - 1) / cols + 1; //计算有多少行
        _bgViewHeith = IS_IPAD ?240 :210; // itemWH * rows + headViewHeight + cancleViewHeight + ((rows<=1)? 0 :minimumLineSpacing) +40;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, kScreenWidth, _bgViewHeith)];
        _maskView.backgroundColor = COLOR_F8F9FA_3C4651;
        
    }
    return _maskView;
}



- (UIView*)cancleView {
    if (!_cancleView) {
        _cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.maskView.height-cancleViewHeight, kScreenWidth, cancleViewHeight)];
        [_cancleView addSubview:self.cancleBtn];
        _cancleView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _cancleView;
}


- (UIButton *)cancleBtn{
    
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithTitle:@"取消" titleColor:COLOR_27323F_EFEFF6 titleFont:@"17" imageName:nil];
        _cancleBtn.frame= CGRectMake(0, 0, self.width, cancleHeight);
        _cancleBtn.backgroundColor = [UIColor whiteColor];
        [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_27323F];
    }
    return _cancleBtn;
}


- (void)cancleAction {
    [self hidePickView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch =  [touches anyObject];
    if ([touch.view isKindOfClass:[UMpopHeadView class]]) {
        
    }else{
        [self hidePickView];
    }
}


//显示
- (void)showPickView {
    [UIView animateWithDuration:animationTime animations:^{
        CGRect rect = CGRectMake(0, self.height - _bgViewHeith , kScreenWidth, _bgViewHeith);
        self.maskView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}


//隐藏
- (void)hidePickView {
    
    TT_INVALIDATE_TIMER(_timer);
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height, kScreenWidth, _bgViewHeith);
    } completion:^(BOOL finished) {
        TTVIEW_RELEASE_SAFELY(self.contanerView);
        TTVIEW_RELEASE_SAFELY(self.maskView);
        [self removeFromSuperview];
    }];
}


- (void)immediateRemoveView {
    TT_INVALIDATE_TIMER(_timer);
    TTVIEW_RELEASE_SAFELY(self.contanerView);
    TTVIEW_RELEASE_SAFELY(self.maskView);
    [self removeFromSuperview];
}



/**
 延迟销毁视图
 
 @param second 秒
 */
- (void)delayRemoveViewWithSecond:(NSInteger)second {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)setSecond:(NSTimeInterval)second {
    _second = second;
    [self delayRemoveViewWithSecond:second];
}


- (void)countDown {
    _second --;
    if (_second < 1) {
        [self hidePickView];
    }
}




- (UICollectionViewLayout*)layout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 35/2;
    layout.minimumInteritemSpacing = 14;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    NSInteger state = [UIApplication sharedApplication].statusBarOrientation;
    
    if (state == UIDeviceOrientationLandscapeRight || state == UIDeviceOrientationLandscapeLeft) {
        layout.itemSize = CGSizeMake((kScreenWidth -STATUS_BAR_XH- 4 * PADDING_15 - 4 * PADDING_15)/5.0, self.bgViewHeith-headViewHeight-cancleHeight);
        
    }else{
        if (IS_IPAD) {
            layout.itemSize = CGSizeMake(85, 164/2+30+15);
        } else {
            layout.itemSize = CGSizeMake(55, 164/2+5);
        }
    }
    
    
    return layout;
}



- (UICollectionView*)contanerView {
    
    if (!_contanerView) {
        _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, headViewHeight, kScreenWidth, self.bgViewHeith-headViewHeight-cancleHeight) collectionViewLayout:[self layout]];
        [_contanerView registerClass:[UMShareCell class]  forCellWithReuseIdentifier:NSStringFromClass([UMShareCell class])];
        
        _contanerView.backgroundColor = COLOR_F8F9FA_3C4651;
        _contanerView.delegate = self;
        _contanerView.dataSource = self;
    }
    return _contanerView;
}

#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArr.count;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, PADDING_15, 0, PADDING_15);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UMShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UMShareCell class]) forIndexPath:indexPath];
    cell.imageName = self.imageArr[indexPath.row];
    cell.title = self.textArr[indexPath.row];
    return cell;
}



#pragma mark <UICollectionViewLayouDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //self.selectBlock(@"dd", [self.platformArr[indexPath.row] intValue]);
    /** 1-web  2-图片 */
    NSString *share_type = self.shareModel.share_type;
    UMSocialPlatformType platformType = [self.platformArr[indexPath.row] intValue];
    
    if (UMSocialPlatformType_WechatSession == platformType || UMSocialPlatformType_WechatTimeLine == platformType) {
        // 微信
        [self shareWechatToPlatformType:platformType shareModel:self.shareModel];
    }else{
        if ([share_type isEqualToString:@"1"] || isEmpty(share_type)) {
            [self shareHtmlWithModel:self.shareModel platformType:platformType];
        }else if ([share_type isEqualToString:@"2"]) {
            [self shareImageToPlatformType:platformType shareModel:self.shareModel];
        }
    }
    [self hidePickView];
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
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                //分享成功
                if ([strongSelf.delegate respondsToSelector:@selector(uMShareImageSucess:)]) {
                    [strongSelf.delegate uMShareImageSucess:_shareModel];
                }
            }else{
                UMSocialLogInfo(@"response data is %@",data);
                //分享失败
                if ([strongSelf.delegate respondsToSelector:@selector(uMShareImageFail:)]) {
                    [strongSelf.delegate uMShareImageFail:_shareModel];
                }
            }
        }
    }];
}



- (void)shareWechatToPlatformType:(UMSocialPlatformType)platformType  shareModel:(ShareModel*)shareModel {
    
    if (shareModel.share_image != nil) {
        [self sendToPlatformType:platformType image:shareModel.share_image shareModel:shareModel];
        
    }else{
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:HKURL(shareModel.img_url) options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            [self sendToPlatformType:platformType image:image shareModel:shareModel];
        }];
    }
}



- (void)sendToPlatformType:(UMSocialPlatformType)platformType  image:(UIImage*)image shareModel:(ShareModel*)shareModel {
    
    id object = nil;
    NSString *share_type = self.shareModel.share_type;
    BOOL isWeb = [share_type isEqualToString:@"1"] || isEmpty(share_type);
    if (isWeb) {
        // 1-web
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = shareModel.web_url;
        object = webpageObject;
    }else{
        //2-图片
        WXImageObject *ext = [WXImageObject object];
        NSData * data = UIImagePNGRepresentation(image);
        ext.imageData = data;
        object = ext;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    //    float imageSize = [UIImagePNGRepresentation(image) length]/1000;
    //    //  大小不能超过64K
    //    if (imageSize > 64) {
    ////
    //    }else{
    //        [message setThumbImage:image];
    //    }
    message.title = shareModel.title;
    message.description = shareModel.info;
    message.mediaObject = object;
    
    if (image != nil && isWeb) {
        UIImage * pressImg = nil;
        
        float imageSize = [UIImagePNGRepresentation(image) length]/1000;
        if (imageSize > 30) {
            pressImg = [self compressImageSize:image toByte:2 * 1000];
            //pressImg = [self compressImage:image toMaxFileSize:64];
            float imageSize = [UIImagePNGRepresentation(pressImg) length]/1000;
            NSLog(@"img的大小：%f",imageSize);
        }else{
            pressImg = image;
        }
        
        if (pressImg) {//缩略图
            NSData * data = UIImagePNGRepresentation(pressImg);
            [message setThumbData:data];
        }
    }
    
    
    
    
    
    SendMessageToWXReq* req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    
    if (UMSocialPlatformType_WechatSession == platformType) {
        req.scene = WXSceneSession; //微信聊天
    }
    if (UMSocialPlatformType_WechatTimeLine == platformType) {
        req.scene = WXSceneTimeline; //微信朋友圈
    }
    
    [HKWechatLoginShareCallback sharedInstance].wechatShareCallback = nil;
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WXApi sendReq:req completion:^(BOOL success) {
            StrongSelf;
            if (success) {
                [HKWechatLoginShareCallback sharedInstance].wechatShareCallback = ^{
                    if (isWeb ) {
                        if ([strongSelf.delegate respondsToSelector:@selector(uMShareWebSucess:)]) {
                            [strongSelf.delegate uMShareWebSucess:shareModel];
                        }
                    }else{
                        if ([strongSelf.delegate respondsToSelector:@selector(uMShareImageSucess:)]) {
                            [strongSelf.delegate uMShareImageSucess:shareModel];
                        }
                    }
                };
            }
        }];
    });
    
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
    UIImage * img = [self compressBySizeWithMaxLength:1024 * 20 withImg:image];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:model.info
                                                                         thumImage:(img==nil) ?thumbURL :img];
    shareObject.webpageUrl = model.web_url;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObject;
    //调用分享接口
    WeakSelf;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        StrongSelf;
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            showTipDialog(Cancel_Share);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据       // [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ?[UIScreen mainScreen].bounds.size.width :[UIScreen mainScreen].bounds.size.height )
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                if ([strongSelf.delegate respondsToSelector:@selector(uMShareWebSucess:)]) {
                    [strongSelf.delegate uMShareWebSucess:model];
                }
                //[strongSelf shareVideoWithModel:model];
            }else{
                if ([strongSelf.delegate respondsToSelector:@selector(uMShareWebFail:)]) {
                    [strongSelf.delegate uMShareWebFail:model];
                }
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

//像素压缩，最大不能超过（如200k）
//- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    NSData *imageData = UIImageJPEGRepresentation(image, compression);
//    while (([imageData length]/1024)> maxFileSize && compression > maxCompression) {
//        compression -= 0.1;
//        imageData = UIImageJPEGRepresentation(image, compression);
//    }
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
//    return compressedImage;
//}

/*!
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *  @param image 当前要压缩的图 maxLength 压缩后的大小
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
- (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


-(UIImage *)compressBySizeWithMaxLength:(NSUInteger)maxLength withImg:(UIImage *)img{
    UIImage *resultImage = img;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    UIImage *compressedImage = [UIImage imageWithData:data];
    return compressedImage;
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




@end





/**************************  section 头视图   **************************/

@interface UMpopHeadView ()

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *bottomLine;

@end


@implementation UMpopHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, headViewHeight)];
    if (self) {
        [self addSubview:self.titleLabel];
        //[self addSubview:self.bottomLine];
        self.backgroundColor = COLOR_F8F9FA_3C4651;
    }
    return self;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectMake(0, 0, self.width, self.height) title:@"分享到"
                                    titleColor:COLOR_7B8196 titleFont:@"15" titleAligment:NSTextAlignmentCenter];
        _titleLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_A8ABBE];
    }
    return _titleLabel;
}

- (UIView*)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = COLOR_dddddd;
        _bottomLine.frame = CGRectMake(0, self.titleLabel.height-0.5, kScreenWidth, 0.5);
    }
    return _bottomLine;
}



@end




