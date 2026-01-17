//
//  HKPrecentImageShareVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/6/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPrecentImageShareVC.h"
#import "UMpopScreenshotView.h"
#import "UIView+SNFoundation.h"
#import "UMpopView.h"
#import "HKArticleDetailVC.h"
#import "UIView+Banner.h"
#import "HKPresentHeaderModel.h"
#import "HKBookModel.h"

@interface HKPrecentImageShareVC ()<UMpopViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shareViewIV;
@property (weak, nonatomic) IBOutlet UILabel *shareViewTitleLB;
@property (weak, nonatomic) IBOutlet UIButton *shareViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayBtn;
@property (weak, nonatomic) IBOutlet UIView *videoBlackBG;

// **** 约束 ****
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHeight;
// **** 约束 ****
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (nonatomic, strong)UIImage *precentImage;

@property (nonatomic, strong)UIImageView *realShareImage;
//耳机图标
@property (strong, nonatomic)  UIImageView *listenIV;
//阴影背景
@property (strong, nonatomic)  UIImageView *shadowIV;

@end

@implementation HKPrecentImageShareVC

- (UIImageView *)realShareImage {
    if (_realShareImage == nil) {
        _realShareImage = [[UIImageView alloc] init];
    }
    return _realShareImage;
}



- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.image = imageName(@"hk_book_shadow_black");
        _shadowIV.clipsToBounds = YES;
        _shadowIV.layer.cornerRadius = 5.0;
    }
    return _shadowIV;
}


- (UIImageView*)listenIV {
    if (!_listenIV) {
        _listenIV = [UIImageView new];
        _listenIV.image = imageName(@"ic_video_v2_14");
    }
    return _listenIV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.coinBtn.clipsToBounds = YES;
    self.coinBtn.layer.cornerRadius = self.coinBtn.height * 0.5;
    [self.coinBtn setTitle:self.model.share_gold_str forState:UIControlStateNormal];
    self.coinBtn.hidden = self.model.share_gold_str.length == 0;
//    if (self.model.sign_img_url.length == 0) {
//        self.model.sign_img_url = @"https://pic.ibaotu.com/00/77/80/34R888piCQmg.jpg-0.jpg!ww700";
//    }
    
    NSString *str1 = [self.model.sign_img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:str1]];
    [self.imageView sd_setImageWithURL:url placeholderImage:imageName(@"present_share_place_holder") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            self.precentImage = image;
        }
    }];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }];
    
    // 重新设置约束
//    CGFloat width = IS_IPAD? UIScreenWidth - 100 * 2 : UIScreenWidth - 22 * 2;
//    CGFloat maxiPadWidth = (UIScreenWidth - 200 * 2) < 200? 200 : (UIScreenWidth - 200 * 2);
    CGFloat maxiPadWidth = UIScreenWidth * 0.35;

    CGFloat width = IS_IPAD? maxiPadWidth : UIScreenWidth - 22 * 2;
    CGFloat height = 832 * width / 660;
    //self.imageViewTop.constant = (IS_IPHONE_X || IS_IPAD)? 130 : IS_IPHONE6PLUS? 82 : 52;
    self.imageHeight.constant = height;
    self.imageWidth.constant = width;
    self.shareViewHeight.constant = self.model.rec.type? (154 * width / 660) : 0; // 如果没有推荐，高度为0
    
    self.shareViewIV.clipsToBounds = YES;
    self.shareViewIV.layer.cornerRadius = 2.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewTap)];
    [self.shareView addGestureRecognizer:tap];
    
    // 圆角
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.2)), dispatch_get_main_queue(), ^{

        
        if (self.model.rec.type) {
            // 圆角
            [self.imageView addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft]; // 切除了左上 右上
        } else {
            // 圆角
            [self.imageView addRoundedCornersWithRadius:5 byRoundingCorners: UIRectCornerAllCorners]; // 全部
        }
        [self.shareView addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight]; // 切除了左下 右下
    });

    
    // 推荐教程
    if (self.model.rec) {
        self.videoBlackBG.hidden = self.videoPlayBtn.hidden = YES;
        // 视频
        if (self.model.rec.type == 1) {
            self.videoBlackBG.hidden = self.videoPlayBtn.hidden = NO;
            [self.shareViewIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.model.rec.video.img_cover_url]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
            self.shareViewTitleLB.text = self.model.rec.video.title;
            
        } else if (self.model.rec.type == 2) {
            
            // 文章
            [self.shareViewIV sd_setImageWithURL:[NSURL URLWithString:self.model.rec.article.cover_pic] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
            self.shareViewTitleLB.text = self.model.rec.article.title;
        } else if (self.model.rec.type == 3) {
            //虎课读书
            self.shareViewTitleLB.text = self.model.rec.book.title;
            [self.shareViewIV sd_setImageWithURL:[NSURL URLWithString:self.model.rec.book.cover] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
            [self.shareViewIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.shareView);
                make.left.equalTo(self.imageView).offset(18);
                make.size.mas_equalTo(CGSizeMake(32, 49));
            }];
            
            [self.view addSubview:self.shadowIV];
            [self.view addSubview:self.listenIV];
            [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.shareViewIV);
            }];
            [self.listenIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.shareViewIV);
            }];
        }
    }
}

- (void)shareViewTap {
    !self.recBlockClick? : self.recBlockClick();
    
    // 退出控制器
    [self closeBtnClick:nil];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

}

- (IBAction)closeBtnClick:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.closeBtn.hidden = YES;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)shareBtnClick:(id)sender {
//    if (!self.precentImage) return;
    
    WeakSelf;
    NSString *str1 = [self.model.share_data.img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:str1]];
    [self.realShareImage sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
        if (!error) {
            weakSelf.model.share_data.share_type = @"2";
            weakSelf.model.share_data.share_image = image;
            [weakSelf shareWithUI:weakSelf.model.share_data];
        }
    }];
    
    [MobClick event:UM_RECORD_TSKCENTER_SUCCESS_SHARE];
    
    //图片拼接
//    UIImage *image = [UIImage combineWithtopImageFill:self.precentImage bottomImage:imageName(@"hk_screenshot") withMargin:0];
//    self.model.share_data.share_type = @"2";
//    self.model.share_data.share_image = image;
//    [self shareWithUI:self.model.share_data];
}


/** 友盟分享 */
- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
}


- (void)uMShareImageSucess:(id)sender {
    
    if ([sender isKindOfClass:[ShareModel class]] && self.model.share_gold_str.length) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    } else {
        [self closeBtnClick:nil];
    }
    
}

#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }

    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        [self closeBtnClick:nil];
    } failure:^(NSError *error) {
        
    }];
}



- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]] && self.model.share_gold_str.length) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    } else {
        [self closeBtnClick:nil];
    }
}



@end

