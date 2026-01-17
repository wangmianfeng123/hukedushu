//
//  HKShareTrainView.m
//  Code
//
//  Created by Ivan li on 2020/12/21.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKShareTrainView.h"
#import <UMShare/UMShare.h>
#import "HKWechatLoginShareCallback.h"
#import "UIView+HKLayer.h"

@interface HKShareTrainView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *shareWeChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *longpressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopMargin;
@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLaebel2;

@end

@implementation HKShareTrainView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel1.textColor = COLOR_7B8196_A8ABBE;
    self.titleLaebel2.textColor = COLOR_7B8196_A8ABBE;
    self.shareWeChatLabel.hidden = NO;
    self.longpressLabel.hidden = YES;
    self.titleTopMargin.constant = 44.0;
    self.weChatView.hidden = NO;
    self.wechatHeight.constant = 60.0;
    self.lineViewTopMargin.constant = 20.0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatClick)];
    [self.weChatView addGestureRecognizer:tap];
    
    [self.bgView addCornerRadius:10.0];
}

- (void)weChatClick{
    [MobClick event: training_camp_qrcode_wechat];
    [self makePosterView];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (IBAction)closeBtnClick{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)makePosterView{
    self.shareWeChatLabel.hidden = YES;
    self.longpressLabel.hidden = NO;
    self.titleTopMargin.constant = 68.0;
    self.weChatView.hidden = YES;
    self.wechatHeight.constant = 0.0;
    self.lineViewTopMargin.constant = 30.0;
    
    //绘制海报
    if (self.qrCodeURL.length) {
        [HKImagePickerController hk_savedPhotosAlbum:self.qrCodeURL];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage * image = [self screenshotForView:self.bgView];



            if (image) {
                [self shareImg:image];
            }
        });
    }
}

-(void)setQrCodeURL:(NSString *)qrCodeURL{
    _qrCodeURL = qrCodeURL;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:qrCodeURL]] placeholderImage:imageName(HK_Placeholder)];
}

- (void)shareImg:(UIImage *) image{
    [MobClick event:newcamp_sharevx];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
     id object = ext;
    WXMediaMessage *message = [WXMediaMessage message];
        


//    float imageSize = [UIImagePNGRepresentation(image) length]/1024/8;
//    //  大小不能超过64K
//    if (imageSize > 64) {
//        
//    }else{
//        [message setThumbImage:image];
//    }
    message.mediaObject = object;
    SendMessageToWXReq* req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession; //微信聊天
    [HKWechatLoginShareCallback sharedInstance].wechatShareCallback = nil;
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

- (UIImage *)screenshotForView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

