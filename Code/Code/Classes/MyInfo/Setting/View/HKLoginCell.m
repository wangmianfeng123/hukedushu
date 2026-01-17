//
//  HKLoginCell.m
//  Code
//
//  Created by Ivan li on 2021/2/3.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLoginCell.h"

@interface HKLoginCell ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation HKLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = COLOR_FFFFFF_333D48;
}

- (void)loadData{
    if (isLogin()) {
        self.loginBtn.hidden = NO;
        self.loginBtn.clipsToBounds = YES;
        self.loginBtn.layer.cornerRadius = 50 * 0.5;
        [self.loginBtn setBackgroundColor:HKColorFromHex(0xFF3221, 1.0)];
        [self.loginBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        self.loginBtn.hidden = YES;
        [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
}
- (IBAction)loginBtnClick {
    if (self.didLoginBlock) {
        self.didLoginBlock();
    }
}
@end
