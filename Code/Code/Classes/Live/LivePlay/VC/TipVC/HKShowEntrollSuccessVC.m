//
//  HKShowEntrollSuccessVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/12/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKShowEntrollSuccessVC.h"

@interface HKShowEntrollSuccessVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *openNotificationBtn;

@end

@implementation HKShowEntrollSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    
    
    self.openNotificationBtn.clipsToBounds = YES;
    self.openNotificationBtn.layer.cornerRadius = self.openNotificationBtn.height * 0.5;
    UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
    UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(160, 49) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self.openNotificationBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
}

- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openNotificationBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [CommonFunction openNotificationSetting];
}


@end
