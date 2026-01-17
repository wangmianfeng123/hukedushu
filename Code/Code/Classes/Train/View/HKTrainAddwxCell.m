//
//  HKTrainAddwxCell.m
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTrainAddwxCell.h"
#import "UIView+HKLayer.h"
@interface HKTrainAddwxCell ()
@property (weak, nonatomic) IBOutlet UIButton *addWxBtn;
@property (weak, nonatomic) IBOutlet UIButton *thumbsLikeBtn;

@end

@implementation HKTrainAddwxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
