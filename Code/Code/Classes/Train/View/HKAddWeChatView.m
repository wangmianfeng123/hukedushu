//
//  HKAddWeChatView.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKAddWeChatView.h"
#import "UIView+HKLayer.h"

@interface HKAddWeChatView ()
@property (weak, nonatomic) IBOutlet UIButton *addWxBtn;
@property (weak, nonatomic) IBOutlet UIButton *thumbsLikeBtn;

@end

@implementation HKAddWeChatView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.addWxBtn addCornerRadius:17 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
    [self.thumbsLikeBtn addCornerRadius:17 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
}

- (IBAction)addWxBtnClick {
    if (self.addWxBlock) {
        [MobClick event:training_camp_wechat_view];
        self.addWxBlock();
    }
}

- (IBAction)thumbsLikeBtnClick {
    if (self.thumbsLikeBlock) {
        [MobClick event:training_camp_invite_like];
        self.thumbsLikeBlock();
    }
}

@end
