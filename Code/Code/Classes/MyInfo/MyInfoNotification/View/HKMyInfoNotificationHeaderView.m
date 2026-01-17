//
//  HKMyInfoNotificationHeaderView.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyInfoNotificationHeaderView.h"

@interface HKMyInfoNotificationHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UILabel *descrLB;

@property (weak, nonatomic) IBOutlet UIView *spaceView;

@end

static NSString *string = @"您当前关闭了系统通知，无法及时收到消息。若要开启，请在手机的“设置”中，找到“虎课”并且开启通知。立即开启";

@implementation HKMyInfoNotificationHeaderView

- (CGFloat)textHeight {

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGFloat height = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.0 - 104.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return height + 10.0 + 10.0 + 16.0 + 10.0;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.openBtn.clipsToBounds = YES;
    self.openBtn.layer.cornerRadius = self.openBtn.height * 0.5;
    
    self.tipLB.textColor = COLOR_27323F_EFEFF6;
    self.descrLB.textColor = COLOR_27323F_EFEFF6;
    self.backgroundColor = COLOR_F8F9FA_333D48;
    self.spaceView.backgroundColor = COLOR_FFFFFF_333D48;
    
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"my_not_exit_btn" darkImageName:@"my_not_exit_btn_dark"];
    [self.closeBtn setImage:normalImage forState:UIControlStateNormal];
}

- (IBAction)openBtnClick:(id)sender {
    !self.openBtnClickBlock? : self.openBtnClickBlock();
}

- (IBAction)closeBtnClick:(id)sender {
    
    // 保存后不再开启
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:colseNotKey forKey:colseNotKey];
    [userdefaults synchronize];
    !self.closeBtnClickBlock? : self.closeBtnClickBlock();
}



@end
