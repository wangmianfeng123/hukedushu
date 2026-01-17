
//
//  UMpopView.m
//  Code
//
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
////

#import "HKUMpopView.h"
#import "UMShareCell.h"


#define itemWH (SCREEN_WIDTH - (cols - 1) * margin*Ratio) / cols

static NSInteger const cols = 3; //列

static CGFloat margin = 65; //间隔

static CGFloat cancleHeight = PADDING_25*2 ; //取消按钮高度

static CGFloat headViewHeight = 55 ; //头视图高度

static CGFloat cancleViewHeight = 60 ; //底部取消视图高度

static CGFloat animationTime = 0.25; //动画时间。从下面移动到上面

static NSInteger const minimumLineSpacing = PADDING_20; //20-item 竖间距



@interface HKUMpopView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *contanerView;

@property(nonatomic,strong)UIView *maskView; //背景视图

@property(nonatomic,strong)UMShareCell *cell;

@property(nonatomic,strong)UIButton  *cancleBtn;

@property(nonatomic,strong)UIView  *cancleView;

@property(nonatomic,assign)CGFloat bgViewHeith;

@end



@implementation HKUMpopView




- (instancetype)init{
    self = [super init];
    if (self) {
        [self setSharePlatform];
        [self setUI];
        [self showPickView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc pop");
}


#pragma mark - 检查客户端是否支持分享
- (BOOL)isHKSupportClientShare:(NSInteger)clientCode {
    //    UMSocialPlatformType_QQ; -- UMSocialPlatformType_Sina --UMSocialPlatformType_WechatSession;
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}

BOOL isHKSupportClientShare(NSInteger clientCode) {
    return [[UMSocialManager defaultManager]isSupport:clientCode];
}



+ (BOOL)isHaveSharePlatform {
    if ( isHKSupportClientShare(UMSocialPlatformType_QQ) || isHKSupportClientShare(UMSocialPlatformType_WechatSession)
        || isHKSupportClientShare(UMSocialPlatformType_Qzone) || isHKSupportClientShare(UMSocialPlatformType_WechatTimeLine)
        || isHKSupportClientShare(UMSocialPlatformType_Sina)){
        
        return YES;
    }else{
        return NO;
    }
}




#pragma mark - 初始化 已安装的平台
- (void)setSharePlatform {
    
    if ([self isHKSupportClientShare:UMSocialPlatformType_QQ]) {
        [self.imageArr addObject:@"qq_login"];
        [self.textArr addObject:@"QQ"];
        [self.platformArr addObject:@"4"];
    }
    
    if ([self isHKSupportClientShare:UMSocialPlatformType_Qzone]) {
        [self.imageArr addObject:@"qq_zone"];
        [self.textArr addObject:@"QQ空间"];
        [self.platformArr addObject:@"5"];
    }
    
    if ([self isHKSupportClientShare:UMSocialPlatformType_WechatSession]) {
        [self.imageArr addObject:@"weChat_login"];
        [self.textArr addObject:@"微信"];
        [self.platformArr addObject:@"1"];
    }
    
    if ([self isHKSupportClientShare:UMSocialPlatformType_WechatTimeLine]) {
        [self.imageArr addObject:@"wechat_friend"];
        [self.textArr addObject:@"朋友圈"];
        [self.platformArr addObject:@"2"];
    }
    
    if ([self isHKSupportClientShare:UMSocialPlatformType_Sina]) {
        [self.imageArr addObject:@"weibo"];
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
    self.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); //[self frontWindow].bounds;
    //[[self frontWindow] addSubview:self];
    [self addSubview:self.maskView];
    [self fuzzy];
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
        NSInteger count = self.imageArr.count;
        NSInteger rows = (count - 1) / cols + 1; //计算有多少行
        _bgViewHeith = itemWH * rows + headViewHeight + cancleViewHeight + ((rows<=1)? 0 :minimumLineSpacing) +40;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith)];
        _maskView.backgroundColor = [UIColor whiteColor];
    }
    return _maskView;
}



- (UIView*)cancleView {
    if (!_cancleView) {
        _cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.maskView.height-cancleViewHeight, SCREEN_WIDTH, cancleViewHeight)];
        _cancleView.backgroundColor = COLOR_F6F6F6;
        [_cancleView addSubview:self.cancleBtn];
    }
    return _cancleView;
}


- (UIButton *)cancleBtn{
    
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithTitle:@"取消" titleColor:COLOR_666666 titleFont:@"15" imageName:nil];
        _cancleBtn.frame=CGRectMake(0, 10, self.width, cancleHeight);
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
    [self hidePickView];
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
    
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(removeUMpopView:)]) {
            [self.delegate removeUMpopView:@"hk"];
        }
    }];
}


- (UICollectionViewLayout*)layout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.minimumInteritemSpacing = margin*Ratio;
    if (IS_IPAD) {
        layout.minimumInteritemSpacing = minimumLineSpacing;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH) / 7.0, (SCREEN_WIDTH) / 7.0);
    } else {
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-80-2*(margin*Ratio))/3, itemWH);
    }
    return layout;
}



- (UICollectionView*)contanerView {
    
    if (!_contanerView) {
        _contanerView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) collectionViewLayout:[self layout]];
        [_contanerView registerClass:[UMShareCell class]  forCellWithReuseIdentifier:NSStringFromClass([UMShareCell class])];
        [_contanerView registerClass:[HKUMpopHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKUMpopHeadView"];
        _contanerView.backgroundColor = [UIColor whiteColor];
        _contanerView.delegate = self;
        _contanerView.dataSource = self;
        
        NSInteger count = self.imageArr.count;
        NSInteger rows = (count - 1) / cols + 1;
        CGRect rect =  _contanerView.frame;
        rect.size.height = rows * itemWH + headViewHeight + ((rows<=1)? 0 :minimumLineSpacing) + 40; //  40-section 的上下偏移距离
        _contanerView.frame = rect ;
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
    return UIEdgeInsetsMake(PADDING_15, PADDING_40, PADDING_25, PADDING_40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *header = nil;
    if (kind == UICollectionElementKindSectionHeader){
        HKUMpopHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKUMpopHeadView" forIndexPath:indexPath];
        header = headView;
        return header;
    }
    return [UICollectionReusableView new];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH,55);
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
    [self hidePickView];
}


@end





/**************************  section 头视图   **************************/

@interface HKUMpopHeadView ()

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *bottomLine;

@end


@implementation HKUMpopHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewHeight)];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
    }
    return self;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectMake(0, 0, self.width, self.height) title:@"分享到"
                                    titleColor:COLOR_333333 titleFont:@"15" titleAligment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView*)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = COLOR_dddddd;
        _bottomLine.frame = CGRectMake(0, self.titleLabel.height-0.5, SCREEN_WIDTH, 0.5);
    }
    return _bottomLine;
}

@end









