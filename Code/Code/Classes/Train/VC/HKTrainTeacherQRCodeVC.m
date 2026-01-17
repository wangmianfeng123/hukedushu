//
//  HKTrainTeacherQRCodeVC.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/23.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainTeacherQRCodeVC.h"
#import "HKImagePickerController.h"
#import "HKTrainDetailModel.h"

@interface HKTrainTeacherQRCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeIV;
@property (weak, nonatomic) IBOutlet UIButton *saveImageBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *codeLB;

@end

@implementation HKTrainTeacherQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 保存图片的样式
//    UIColor *color = [UIColor colorWithHexString:@"#ff675e"];
//    UIColor *color1 = [UIColor colorWithHexString:@"#ff7b42"];
//    UIColor *color2 = [UIColor colorWithHexString:@"#ff9423"];
//    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(215, 38) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    
    UIColor *color = [UIColor colorWithHexString:@"#FFBF00"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FF7E00"];
    UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(215, 40) gradientColors:@[(id)color,(id)color1] percentage:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
    
    //UIImage *image = [UIImage imageWithColor:COLOR_7BC144 size:CGSizeMake(215, 38)];
    [self.saveImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    self.saveImageBtn.clipsToBounds = YES;
    self.saveImageBtn.layer.cornerRadius = self.saveImageBtn.height * 0.5;
    
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    // 网络二维码
    [self.qrCodeIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:self.qrCodeURL]) placeholderImage:imageName(HK_Placeholder)];
    NSString *wxCode = self.teacher_weixin;
    self.codeLB.text = !isEmpty(wxCode) ?wxCode :nil;
}

- (IBAction)exitBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveIageBtnClick:(id)sender {
    if (self.qrCodeURL) {
        [HKImagePickerController hk_savedPhotosAlbum:self.qrCodeURL];
    }
    
    //[self pasteWxCode];
    // 退出
    [self exitBtnClick:nil];
    
    [MobClick event:um_train_weixin_save_click];
}


/// 复制微信号
- (void)pasteWxCode {
    NSString *wxCode = self.teacher_weixin;
    if (!isEmpty(wxCode)) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = wxCode;
        [MBProgressHUD showTipMessageInWindow:@"复制成功，前往微信添加导师微信" timer:2 bgColor:COLOR_000000 alpha:0.7 font:HK_FONT_SYSTEM(14)];
    }
}

@end
