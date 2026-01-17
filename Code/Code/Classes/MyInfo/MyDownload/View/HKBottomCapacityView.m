//
//  HKBottomCapacityView.m
//  Code
//
//  Created by hanchuangkeji on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBottomCapacityView.h"
#import "NSTimer+FOF.h"

@interface HKBottomCapacityView()

@property (weak, nonatomic) IBOutlet UILabel *capacityTitleLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;

@end

@implementation HKBottomCapacityView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 定时设置空间剩余空间
//    [self setupSpaceStringLoop];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.capacityLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
    self.capacityTitleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196];
    self.capacityLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_27323F dark:COLOR_A8ABBE];
    self.lineView.backgroundColor = [UIColor hkdm_colorWithColorLight: COLOR_EFEFF6 dark:COLOR_3D4752];
}

//- (void)removeFromSuperview {
//    [super removeFromSuperview];
//
//    if (self.timer.isValid) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}
//
//- (void)setupSpaceStringLoop {
//
//    // 立马计算
//    [self setSpace];
//    NSTimer *timer = [NSTimer tb_scheduledTimerWithTimeInterval:3.0 block:^{
//        // 循环立马计算
//        [self setSpace];
//    } repeats:YES];
//    self.timer = timer;
//}

- (void)setSpace {
    // 判断储存剩余储存空间 150M
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long space) {
        CGFloat spaceLeft = space / 1024.0 / 1024.0 / 1024.0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *spaceString = [NSString stringWithFormat:@"%0.1fG", spaceLeft];
            self.capacityLB.text = spaceString;
            //NSLog(@"计算剩余空间");
        });
        
    }];
}

- (void)setCapacity:(CGFloat)capacity totalNeed:(CGFloat)total{
    self.capacityLB.hidden = YES;
    self.capacityTitleLB.hidden = YES;
    self.capacityLabel.hidden = NO;
    
    
    CGFloat capacityG = capacity/1024.0;
    if (total > 1024) {
        CGFloat totalG = total/1024.0;
        [self setupAttributeString:[NSString stringWithFormat:@"共需要：%0.1fG  /  剩余空间：%0.1fG",totalG,capacityG] capacityTextColor:@"共需要：" totalTextColor:@"/  剩余空间："];
    }else if (total <= 0){
        [self setupAttributeString:[NSString stringWithFormat:@"剩余空间：%0.1fG",capacityG] capacityTextColor:@"" totalTextColor:@"剩余空间："];
    }else{
        [self setupAttributeString:[NSString stringWithFormat:@"共需要：%0.1fM  /  剩余空间：%0.1fG",total,capacityG] capacityTextColor:@"共需要：" totalTextColor:@"/  剩余空间："];
    }
}


#pragma mark - 富文本部分字体飘灰
- (void)setupAttributeString:(NSString *)text capacityTextColor:(NSString *)capacityText totalTextColor:(NSString *)totalText{
    NSRange capacityTextRange = [text rangeOfString:capacityText];
    NSRange totalTextRange = [text rangeOfString:totalText];

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (capacityText.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:COLOR_A8ABBE
                             range:capacityTextRange];
    }
    if (totalText.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:COLOR_A8ABBE
                             range:totalTextRange];
    }
    self.capacityLabel.attributedText = attributeStr;
}


@end
