

//
//  HKGuideView.m
//  Code
//
//  Created by Ivan li on 2018/1/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGuideView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "SDCycleScrollView.h"

#define HIDDEN_TIME   0.5

#define Start_Experience  @"立即开始学习"

@interface HKGuideView ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,copy)NSArray                 *imageArray;
@property (nonatomic,strong)UIPageControl           *imagePageControl;
@property (nonatomic,assign)NSInteger               slideIntoNumber;
@property (nonatomic,strong)MPMoviePlayerController *playerController;

@property (nonatomic,strong)NSMutableArray  <UIImageView*>*imageIVArr;

//@property (nonatomic,strong)SDCycleScrollView   *scrollView;

@property(nonatomic,assign)NSInteger imageIndex;

/// YES 加载GIF（全部GIF）
@property(nonatomic,assign)BOOL isLoadGif;

@end

@implementation HKGuideView

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden  isLoadGif:(BOOL)isLoadGif {
    if ([super initWithFrame:frame]) {
        self.slideInto = NO;
        if (isHidden == YES) {
            self.imageArray = imageNameArray;
        }
        self.imageArray = imageNameArray;
        self.isLoadGif = isLoadGif;
        
        if (isLoadGif) {
            self.imageIndex = 0;
//            [self addSubview:self.scrollView];
            
        }else{
            // 设置引导视图的scrollview
            UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
            [guidePageView setBackgroundColor:[UIColor lightGrayColor]];
            [guidePageView setContentSize:CGSizeMake(SCREEN_WIDTH*imageNameArray.count, SCREEN_HEIGHT)];
            [guidePageView setBounces:NO];
            [guidePageView setPagingEnabled:YES];
            [guidePageView setShowsHorizontalScrollIndicator:NO];
            [guidePageView setDelegate:self];
            [self addSubview:guidePageView];
            
            // 设置引导页上的跳过按钮
            UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.8, SCREEN_WIDTH*0.1, 50, 25)];
            [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            [skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [skipButton setBackgroundColor:[UIColor grayColor]];
            [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [skipButton.layer setCornerRadius:(skipButton.height * 0.5)];
            [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            skipButton.hidden = YES;
            [self addSubview:skipButton];
            
            // 添加在引导视图上的多张引导图片
            for (int i=0; i<imageNameArray.count; i++) {
                
                
                UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                bgView.backgroundColor = [UIColor whiteColor];
                
                __block UIImageView *imageView = [[UIImageView alloc]init];
                imageView.clipsToBounds = YES;
                imageView.contentMode = IS_IPAD ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleToFill;
                
                if ([[self contentTypeForImageURL:imageNameArray[i]] isEqualToString:@"gif"]) {
                    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
//                    imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                    imageView.image = [UIImage sd_imageWithGIFData:imageData];
                    //[imageView setValue:@(5) forKey:@"loopCountdown"];
                }else {
                    imageView.image = [UIImage imageNamed:imageNameArray[i]];
                }
                [bgView addSubview:imageView];
                imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(bgView);
//                    make.centerY.equalTo(bgView.mas_centerY).offset(-30*Ratio);
//                    make.left.greaterThanOrEqualTo(bgView.mas_left).offset(1);
//                    make.right.greaterThanOrEqualTo(bgView.mas_left).offset(-1);
//                }];
                
                
                [guidePageView addSubview:bgView];
                
            }
            
// 设置在最后一张图片上显示进入体验按钮
//                if (i == imageNameArray.count-1 && isHidden == NO) {
                    [self setUserInteractionEnabled:YES];
                    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    //[startButton setTitle:Start_Experience forState:UIControlStateNormal];
                    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [startButton.titleLabel setFont:HK_FONT_SYSTEM(16)];
                    [startButton setBackgroundImage:imageName(@"btn_start1") forState:UIControlStateNormal];
                    [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    //[startButton sizeToFit];
            startButton.size = IS_IPAD ? CGSizeMake(172 * iPadRatio, 40 * iPadRatio):CGSizeMake(172 * Ratio, 40 * Ratio);
                    startButton.x = (SCREEN_WIDTH - startButton.width ) * 0.5;
                    //startButton.y =  IS_IPHONE_XS ? (SCREEN_HEIGHT - KTabBarHeight49-55 * Ratio)-40* Ratio : (SCREEN_HEIGHT - KTabBarHeight49-30* Ratio)-40* Ratio;
                    startButton.y = IS_IPAD? (SCREEN_HEIGHT - KTabBarHeight49-15 * iPadRatio)-40* iPadRatio : IS_IPHONE_XS ? (SCREEN_HEIGHT - KTabBarHeight49-55 * Ratio)-40* Ratio : (SCREEN_HEIGHT - KTabBarHeight49-30* Ratio)-40* Ratio;
                    
                    [self addSubview:startButton];
//                }
            
            // 设置引导页上的页面控制器
            self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 140) * 0.5, (SCREEN_HEIGHT - KTabBarHeight49-30* Ratio)-30* Ratio, 140, 20)];
            //self.imagePageControl.y =  IS_IPHONE_XS ? (SCREEN_HEIGHT - KTabBarHeight49-55 * Ratio)-30* Ratio : (SCREEN_HEIGHT - KTabBarHeight49-30* Ratio)-30* Ratio;
            self.imagePageControl.y = IS_IPAD? SCREEN_HEIGHT - 120 - startButton.height : IS_IPHONE_XS ? (SCREEN_HEIGHT - KTabBarHeight49-10 * Ratio) : (SCREEN_HEIGHT - KTabBarHeight49-10 * Ratio);
            self.imagePageControl.currentPage = 0;
            self.imagePageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            self.imagePageControl.numberOfPages = imageNameArray.count;

            self.imagePageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF"]; //HKColorFromHex(0xF1F3F8, 1.0);
            self.imagePageControl.currentPageIndicatorTintColor =  [UIColor colorWithHexString:@"#FF7340"];//HKColorFromHex(0xADB1B9, 1.0);

            [self addSubview:self.imagePageControl];
        }
    }
    return self;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    [self.imagePageControl setCurrentPage:page];
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == NO) {
        //[self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count-1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                //[self buttonClick:nil];
            }
        }
    }
    
//    // 最后一页隐藏pageControl
//    if (page + 1 == self.imagePageControl.numberOfPages) {
//        self.imagePageControl.hidden = YES;
//    } else {
//        self.imagePageControl.hidden = NO;
//    }
}




- (void)buttonClick:(UIButton *)button {
    // 移除通知
    HK_NOTIFICATION_POST(KRemoveGuidePageNotification, nil);
    [UIView animateWithDuration:HIDDEN_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HIDDEN_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0.3];
        });
    }];
    
    
}


- (void)removeGuidePage {
    [self removeFromSuperview];
}



//- (void)dealloc {
//    
//    TTVIEW_RELEASE_SAFELY(_scrollView);
//}



#pragma mark - 视频引导页面
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    
    if ([super initWithFrame:frame]) {
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-30-40, SCREEN_WIDTH-40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:Start_Experience forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        [self.playerController.view addSubview:movieStartButton];
        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:HIDDEN_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}


#pragma mark - 通过图片Data数据第一个字节来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}


#pragma mark - 通过图片字符串的截取来获取图片的扩展名
- (NSString *)contentTypeForImageURL:(NSString *)url {
    NSString *extensionName = url.pathExtension;
    if ([extensionName.lowercaseString isEqualToString:@"jpeg"]) {
        return @"jpeg";
    }
    if ([extensionName.lowercaseString isEqualToString:@"gif"]) {
        return @"gif";
    }
    if ([extensionName.lowercaseString isEqualToString:@"png"]) {
        return @"png";
    }
    return nil;
}



//- (SDCycleScrollView*)scrollView {
//
//    if (!_scrollView) {
//
//        if ([[self contentTypeForImageURL:self.imageArray[0]] isEqualToString:@"gif"]) {
//            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds shouldInfiniteLoop:NO imageNamesGroup:@[@"dd"]];
//            _scrollView.showPageControl = NO;
//        }else{
//            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds shouldInfiniteLoop:NO imageNamesGroup:self.imageArray];
//            _scrollView.showPageControl = YES;
//            _scrollView.pageControlBottomOffset = 40;
//            _scrollView.pageDotColor  =  HKColorFromHex(0xF1F3F8, 1.0);
//            _scrollView.currentPageDotColor = HKColorFromHex(0xADB1B9, 1.0);
//        }
//
//        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _scrollView.autoScrollTimeInterval = 5;
//        _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//
//        _scrollView.autoScroll = NO;
//        _scrollView.delegate = self;
//        _scrollView.backgroundColor = [UIColor whiteColor];
//        [_scrollView disableScrollGesture];
//    }
//    return _scrollView;
//}



//- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
//
//    return [HKGuideCell class];
//}


//- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
//
//        __weak HKGuideCell *guideCell = (HKGuideCell*)cell;
//        if ([[self contentTypeForImageURL:self.imageArray[self.imageIndex]] isEqualToString:@"gif"]) {
//            if (guideCell) {
//
//                WeakSelf;
////                guideCell.imageView.animatedImage = [self animatedImage];
//                guideCell.imageView.image = [self animatedImage];
//
////                guideCell.imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
////
////                    if (0 == loopCountRemaining) {
////                        switch (index) {
////                            case 0: case 2: case 4: {
////                                weakSelf.imageIndex ++;
////                                guideCell.imageView.animatedImage = [weakSelf animatedImage];
////                                guideCell.imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
////
////                                    if (0 == loopCountRemaining) {
////                                        switch (weakSelf.imageIndex) {
////                                            case 0: case 2: case 4: {
////                                                weakSelf.imageIndex ++;
////                                            }
////                                                break;
////                                            case 1: case 3: case 5:
////
////                                                break;
////
////                                            default:
////                                                break;
////                                        }
////                                    }
////                                };
////                            }
////
////                                break;
////                            case 1: case 3: case 5:
////
////                                break;
////
////                            default:
////                                break;
////                        }
////                    }
////                };
//            }
//        }else{
//            if (guideCell) {
//                guideCell.imageView.image = [UIImage imageNamed:self.imageArray[index]];
//            }
//        }
//}


//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//
//
//    if ([[self contentTypeForImageURL:self.imageArray[0]] isEqualToString:@"gif"]) {
//        // gif
//        if (0 == self.imageIndex || 2 == self.imageIndex || 4 == self.imageIndex) {
//            return;
//        }
//
//        __weak HKGuideCell *guideCell = (HKGuideCell*)[cycleScrollView.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//        if (self.imageIndex+1 >= self.imageArray.count) {
//            [guideCell.imageView stopAnimating];
//            [self buttonClick:nil];
//            return;
//        }
//
//        self.imageIndex ++;
////        guideCell.imageView.animatedImage = [self animatedImage];
//        guideCell.imageView.image = [self animatedImage];
//
////        WeakSelf;
////        guideCell.imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
////
////            if (0 == loopCountRemaining) {
////                switch (weakSelf.imageIndex) {
////                    case 0: case 2: case 4: {
////                        weakSelf.imageIndex ++;
////                        guideCell.imageView.animatedImage = [weakSelf animatedImage];
////                    }
////                        break;
////                    case 1: case 3: case 5:
////
////                        break;
////
////                    default:
////                        break;
////                }
////            }
////        };
//    }else{
//        [cycleScrollView makeScrollViewScrollToIndex:index+1];
//        if (index+1 >= self.imageArray.count) {
//            [self buttonClick:nil];
//        }
//    }
//}



//- (UIImage*)animatedImage {
//
//    if (self.imageIndex >= self.imageArray.count) {
//        return nil;
//    }
//    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageArray[self.imageIndex] ofType:nil]];
////    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
//    UIImage *animatedImage = [UIImage sd_imageWithGIFData:imageData];
//
//    if (animatedImage.sd_imageLoopCount >= 9) {
//        // loopCount == 10的动画  执行一次 （ 10 以下的数字 获取到 loopCount 都是 0）
//        [animatedImage setValue:@(1) forKey:@"loopCount"];
//    }else{
//        [animatedImage setValue:@(90000000) forKey:@"loopCount"];
//    }
//    return animatedImage;
//}




@end






@implementation HKGuideCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}




@end


