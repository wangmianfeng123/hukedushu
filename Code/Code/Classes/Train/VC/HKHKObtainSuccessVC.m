//
//  HKHKObtainSuccessVC.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHKObtainSuccessVC.h"
#import <UMShare/UMShare.h>
#import "HKWechatLoginShareCallback.h"
#import "HKCommonRequest.h"

@interface HKHKObtainSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;

@end

@implementation HKHKObtainSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createLeftBarButton];
    [self setTitle:@"领取成功"];
    
    self.startLabel.text = [NSString stringWithFormat:@"训练营将于%@开放打卡学习",self.start];
    [self.qrImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.teacher_qrcode]]];
    
}


- (IBAction)saveImgBtnClick {
    if (self.teacher_qrcode.length) {
        [HKImagePickerController hk_savedPhotosAlbum:self.teacher_qrcode];
        [self shareImg:self.qrImgV.image];
    }
}


-(void)backAction{
    NSArray *temArray = self.navigationController.viewControllers;
    if (temArray.count >= 2) {
        [self.navigationController popToViewController:[temArray objectAtIndex:temArray.count - 3] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)shareImg:(UIImage *) image{
    [MobClick event:newcamp_sharevx];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
     id object = ext;
    
    WXMediaMessage *message = [WXMediaMessage message];
        


//     float imageSize = [UIImagePNGRepresentation(image) length]/1024/8;
//    //  大小不能超过64K
//    if (imageSize > 64) {
//
//    }
//    else
//    {
//        [message setThumbImage:image];
//    }
    message.mediaObject = object;
    SendMessageToWXReq* req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession; //微信聊天
    [HKWechatLoginShareCallback sharedInstance].wechatShareCallback = nil;
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success && self.shareM) {
            [HKWechatLoginShareCallback sharedInstance].wechatShareCallback = ^{
                [HKCommonRequest shareDataSucess:self.shareM success:^(id responseObject) {

                } failure:^(NSError *error) {
                    
                }];
                
            };
        }
    }];
}

@end
