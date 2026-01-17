//
//  HKStudyLoginView.h
//  Code
//
//  Created by ivan on 2020/6/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HKStudyLoginView :UITableViewCell

/// 本机号码登录
@property(nonatomic,copy) void (^registerBtnClickBlock)(UIButton *btn);
/// 第三方登录
@property(nonatomic,copy) void (^socialphoneLoginBlock)(UIButton *btn,UIButton *selectBtn);
/// 隐私协议
@property(nonatomic,copy) void (^privacyBtnClickBlock)(UIButton *privacyBtn);
/// 虎克用户协议
@property(nonatomic,copy) void (^agreementBtnClickBlock)(UIButton *agreementBtn);
/// 其他手机 登录
@property(nonatomic,copy) void (^otherPhoneBtnClickBlock)(UIButton *btn);

//@property(nonatomic,copy) void (^checkBoxClickBlock)(UIButton *btn);
@property (nonatomic ,assign)BOOL isChose;
@end

