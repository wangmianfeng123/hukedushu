//
//  HKFetchMedalView.m
//  Code
//
//  Created by Ivan li on 2021/8/5.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKFetchMedalView.h"
#import "UIView+HKLayer.h"
#import "HKhtmlModel.h"
#import "UpYunFormUploader.h"

@interface HKFetchMedalView ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgV;
@property (weak, nonatomic) IBOutlet UIImageView *completed_icon;
@property (weak, nonatomic) IBOutlet UILabel *medalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImgV;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leveImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leveImgMargin;

@end

@implementation HKFetchMedalView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.centerView addCornerRadius:10];
    [self.headerImgV addCornerRadius:20];
    [self.logoImg addCornerRadius:3];
}


-(void)setModel:(HKMedalModel *)model{
    _model = model;
    
    self.nameLabel.text = model.userInfo.username;
    //self.orderLabel.text = [NSString stringWithFormat:@"第%d位获得勋章",model.medalInfo.order];
    self.medalLabel.text = model.medalInfo.name;
    self.txtLabel.text = model.medalInfo.desc;
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatar] placeholderImage:HK_PlaceholderImage];
    [self.qrCodeImgV sd_setImageWithURL:[NSURL URLWithString:model.images.qrCode]];
    [self.backgroundImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.images.backgroundImg]]];
    [self.completed_icon sd_setImageWithURL:[NSURL URLWithString:model.medalInfo.completed_icon]];
    [self.levelImgV sd_setImageWithURL:[NSURL URLWithString:model.medalInfo.levelImg]];
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:model.images.logo]];
    
    NSString *temp = [NSString stringWithFormat:@"第%d位获得勋章",model.medalInfo.order];
    NSString * orderstr = [NSString stringWithFormat:@"%d",model.medalInfo.order];
    NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:[UIColor colorWithHexString:@"FF9C54"] TotalString:temp SubStringArray:@[orderstr]];
    [self.orderLabel setAttributedText: attributed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self uploadImg];
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_model.medalInfo.level != 0) {
        self.leveImgWidth.constant = 38.0;
    }else{
        self.leveImgWidth.constant = 0.0;
    }
}

- (void)uploadImg{
    UIImage * img = [self screenshotForView:self];
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    [self getServerUpyunPolicy:imgData];

}

/** 1--获取又拍云 图片上传签名  2---上传图片 */
- (void)getServerUpyunPolicy:(NSData*)imageData {
    [HKHttpTool POST:@"/up-yun/generate-upload-token" parameters:@{@"type":@"3"} success:^(id responseObject) {
        if (HKReponseOK) {
            NSString *policy = responseObject[@"data"][@"policy"];
            NSString *signature = responseObject[@"data"][@"signature"];
            NSString *operatorName = responseObject[@"data"][@"operator"];

            if ([HkNetworkManageCenter shareInstance].networkStatus > 0) {

                [self upYunloadWithData:imageData policy:policy signature:signature operatorName:operatorName];
            }else{
                showTipDialog(NETWORK_ALREADY_LOST);
            }
        }
    } failure:^(NSError *error) {
            showTipDialog(@"图片上传失败");
    }];
}

//服务器端签名的表单上传
- (void)upYunloadWithData:(NSData*)imageData policy:(NSString*)policy   signature:(NSString*)signature  operatorName:(NSString*)operator {
    //从 app 服务器获取的上传策略 policy
    //NSString *policy = UPY_POLICY;
    //从 app 服务器获取的上传策略签名 signature
    //NSString *signature = UPY_SIGNATURE;

    /*  测试本地图片
     NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
     NSString *filePath = [resourcePath stringByAppendingPathComponent:@"huke.png"];
     NSData *fileData = [NSData dataWithContentsOfFile:filePath];
     */

    @weakify(self);
    //操作员
    NSString *operatorName = operator;//UPY_OPERATER;
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    [up uploadWithOperator:operatorName
                    policy:policy
                 signature:signature
                  fileData:imageData
                  fileName:nil
                   success:^(NSHTTPURLResponse *response,
                             NSDictionary *responseBody) {
                       NSLog(@"上传成功 responseBody：%@", responseBody);
                       NSString *imageUrl = responseBody[@"url"];
                       // 将url 保存给服务器
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           @strongify(self)
                           if (!isEmpty(imageUrl)) {
                               //获取到图片路径然后上传服务器
                               if (_fetchUrlBlock) {
                                   self.fetchUrlBlock(imageUrl);
                               }
                           }
                       });
                   }
                   failure:^(NSError *error,
                             NSHTTPURLResponse *response,
                             NSDictionary *responseBody) {
                       NSLog(@"上传失败 error：%@", error);
                       NSLog(@"上传失败 code=%ld, responseHeader：%@", (long)response.statusCode, response.allHeaderFields);
                       NSLog(@"上传失败 message：%@", responseBody);
                       //主线程刷新ui
                       dispatch_async(dispatch_get_main_queue(), ^(){
                           [HKProgressHUD hideHUD];
                           showTipDialog(@"上传失败");
                       });
                   }
                  progress:^(int64_t completedBytesCount,
                             int64_t totalBytesCount) {
                      NSLog(@"upload progress: %lld / %lld", completedBytesCount, totalBytesCount);
                  }];
}

//+ (NSMutableAttributedString *) transCurrentStr:(NSString *)currentString;
//{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:currentString];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,str.length)];
//    //设置固定范围字体颜色不同
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,str.length)];
//    // 调整行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:6];
//    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
//    return str;
//
//}


- (UIImage *)screenshotForView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
