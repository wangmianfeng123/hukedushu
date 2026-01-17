//
//  HKOneYearProtocolCell.m
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKOneYearProtocolCell.h"

@interface HKOneYearProtocolCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoBuyBtn;

@end

@implementation HKOneYearProtocolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectBtn.selected = YES;
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
    if (isOpenAutoBuy) {
        self.autoBuyBtn.hidden = NO;
        [self.autoBuyBtn setTitle:@"《自动续费服务协议》" forState:UIControlStateNormal];
    }else{
        self.autoBuyBtn.hidden = YES;
        [self.autoBuyBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

//-(void)setDataArray:(NSArray *)dataArray{
//    _dataArray = dataArray;
//}

@end
