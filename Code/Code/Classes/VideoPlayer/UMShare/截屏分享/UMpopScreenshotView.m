//
//  UMpopScreenshotView.m
//  Code
//
//  Created by Ivan li on 2018/5/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "UMpopScreenshotView.h"
#import "UMShareCell.h"



static CGFloat cancleHeight = PADDING_25*2 ; //取消按钮高度

static CGFloat headViewHeight = 230/2 ; //头视图高度

static CGFloat cancleViewHeight = 50 ; //底部取消视图高度

static CGFloat animationTime = 0.25; //动画时间。从下面移动到上面



@interface UMpopScreenshotView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    NSTimer *_timer;
}


@property(nonatomic,strong)UICollectionView *contanerView;

@property(nonatomic,strong)UIView *maskView; //背景视图

@property(nonatomic,strong)UMShareCell *cell;

@property(nonatomic,strong)UIButton *cancleBtn;

@property(nonatomic,strong)UIView  *cancleView;

@property(nonatomic,assign)CGFloat bgViewHeith;

@end





static UMpopScreenshotView *_instance = nil;

@implementation UMpopScreenshotView


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



- (void)createUI {
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
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}


BOOL _isSupportClientShare(NSInteger clientCode) {
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}


+ (BOOL)isHaveSharePlatform {
    if ( _isSupportClientShare(UMSocialPlatformType_QQ) || _isSupportClientShare(UMSocialPlatformType_WechatSession)
        || _isSupportClientShare(UMSocialPlatformType_Qzone) || _isSupportClientShare(UMSocialPlatformType_WechatTimeLine)
        || _isSupportClientShare(UMSocialPlatformType_Sina)){
        
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
    [[self frontWindow] addSubview:self];
    [self addSubview:self.maskView];
    [self fuzzy];
    
    UMpopScreenshotHeadView *shotHeadView = [[UMpopScreenshotHeadView alloc]initWithFrame:CGRectZero];
    shotHeadView.shotImage = self.shotScreenImage;
    [self.maskView addSubview:shotHeadView];
    
    [self.maskView addSubview:self.contanerView];
    [self.maskView addSubview:self.cancleView];
}


#pragma mark - FrontWindow
- (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
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
        _bgViewHeith = (IS_IPAD ?240 :210) +55;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith)];
        _maskView.backgroundColor = [UIColor whiteColor];
    }
    return _maskView;
}



- (UIView*)cancleView {
    if (!_cancleView) {
        _cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.maskView.height-cancleViewHeight, SCREEN_WIDTH, cancleViewHeight)];
        [_cancleView addSubview:self.cancleBtn];
    }
    return _cancleView;
}


- (UIButton *)cancleBtn{
    
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithTitle:@"取消" titleColor:COLOR_27323F titleFont:@"17" imageName:nil];
        _cancleBtn.frame= CGRectMake(0, 0, self.width, cancleHeight);
        _cancleBtn.backgroundColor = [UIColor whiteColor];
        [_cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}


- (void)cancleAction {
    [self hidePickView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch =  [touches anyObject];
    if ([touch.view isKindOfClass:[UMpopScreenshotHeadView class]]) {
        
    }else{
        [self hidePickView];
    }
}


//显示
- (void)showPickView{
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height - _bgViewHeith , SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}


//隐藏
- (void)hidePickView{
    
    TT_INVALIDATE_TIMER(_timer);
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith);
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
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (IS_IPAD) {
        layout.itemSize = CGSizeMake(85, 164/2+30);
    } else {
        layout.itemSize = CGSizeMake(55, 164/2);
    }
    return layout;
}



- (UICollectionView*)contanerView {
    
    if (!_contanerView) {
        _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, headViewHeight, SCREEN_WIDTH, self.bgViewHeith-headViewHeight-cancleHeight) collectionViewLayout:[self layout]];
        [_contanerView registerClass:[UMShareCell class]  forCellWithReuseIdentifier:NSStringFromClass([UMShareCell class])];
        
        _contanerView.backgroundColor = COLOR_F8F9FA;
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
    NSLog(@"collectionView");
    self.selectBlock(@"dd", [self.platformArr[indexPath.row] intValue]);
    [self hidePickView];
}




#pragma mark - 分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType  image:(UIImage*)image {
    
    //设置分享内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:image];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                UMSocialLogInfo(@"response message is %@",resp.message);//分享结果消息
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);//第三方原始返回的数据
                
                ShareModel *model = [ShareModel new];
                model.type = @"7";
                [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}






#pragma mark -  友盟网页分享
- (void)UMshareWebToPlatformType:(UMSocialPlatformType)platformType  model:(ShareModel*)model image:(UIImage*)image {
    //- (void)UMshareWebToPlatformType:(UMSocialPlatformType)platformType  model:(DetailModel*)model image:(UIImage*)image {
    
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
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                if ([strongSelf.delegate respondsToSelector:@selector(uMScreenshotShareSucess:)]) {
                    [strongSelf.delegate uMScreenshotShareSucess:model];
                }
            }else{
                if ([strongSelf.delegate respondsToSelector:@selector(uMScreenshotShareFail:)]) {
                    [strongSelf.delegate uMScreenshotShareFail:model];
                }
                UMSocialLogInfo(@"response data is %@",data);
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




@end





/**************************  section 头视图   **************************/


@interface UMpopScreenshotHeadView ()

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *bottomLine;

@property(nonatomic,strong)UIImageView *shotImageIV;

@end


@implementation UMpopScreenshotHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewHeight)];
    if (self) {
        
        self.backgroundColor = COLOR_F8F9FA;
        [self addSubview:self.shotImageIV];
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
        
        [_shotImageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(PADDING_15);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shotImageIV.mas_right).offset(PADDING_15);
            make.centerY.equalTo(self);
        }];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.left.equalTo(self).offset(PADDING_15);
            make.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"分享截屏给好友"
                                    titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView*)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = COLOR_EFEFF6;
    }
    return _bottomLine;
}


- (UIImageView*)shotImageIV {
    if (!_shotImageIV) {
        _shotImageIV = [UIImageView new];
        _shotImageIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shotImageIV;
}


- (void)setShotImage:(UIImage *)shotImage {
    _shotImage = shotImage;
    _shotImageIV.image = shotImage;
}


@end


