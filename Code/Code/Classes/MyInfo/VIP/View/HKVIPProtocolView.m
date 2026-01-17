//
//  HKVIPProtocolView.m
//  Code
//
//  Created by yxma on 2020/11/4.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKVIPProtocolView.h"

@interface HKVIPProtocolView ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoBuyBtn;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

@implementation HKVIPProtocolView

+ (HKVIPProtocolView *)createView{
    HKVIPProtocolView * protolView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
//    protolView.frame = frame;
    return protolView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectBtn.selected = YES;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bgview.backgroundColor = COLOR_FFFFFF_3D4752;
    
}

- (IBAction)vipServeBtnClick {
    if (self.agreementBtnBlock) {
        self.agreementBtnBlock();
    }
}

- (IBAction)autoBuyBtnClick {
    if (self.autoBuyBtnBlock) {
        self.autoBuyBtnBlock();
    }
}

- (IBAction)seleBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.seletBtnBlock) {
        self.seletBtnBlock(sender.selected);
    }
}

-(void)setIsOpenAutoBuy:(BOOL)isOpenAutoBuy{
//    if (isOpenAutoBuy) {
        self.autoBuyBtn.hidden = NO;
        [self.autoBuyBtn setTitle:@"《隐私协议》" forState:UIControlStateNormal];
//    }else{
//        self.autoBuyBtn.hidden = YES;
//        [self.autoBuyBtn setTitle:@"" forState:UIControlStateNormal];
//    }
}


@end
