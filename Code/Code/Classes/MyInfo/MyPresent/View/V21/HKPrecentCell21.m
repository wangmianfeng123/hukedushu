//
//  HKPrecentCell21.m
//  Code
//
//  Created by hanchuangkeji on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPrecentCell21.h"

@interface HKPrecentCell21()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *deitalLB;
@property (weak, nonatomic) IBOutlet UIButton *addCoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation HKPrecentCell21

- (void)awakeFromNib {
    [super awakeFromNib];

    // 设置圆角
    self.addCoinBtn.clipsToBounds = YES;
    self.addCoinBtn.layer.cornerRadius = 8.0;
    self.finishBtn.clipsToBounds = YES;
    self.finishBtn.layer.cornerRadius = 13.0;
    
    [self.finishBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateDisabled];
    [self.finishBtn setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xEFEFF6, 1.0) size:CGSizeMake(66, 26)] forState:UIControlStateDisabled];
    
    // 全选选中样式
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.deitalLB.textColor = COLOR_A8ABBE_7B8196;
}



- (void)setModel:(HKTasktModel *)model {
    _model = model;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_url]] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.title;
    self.deitalLB.text = model.descrip;
    [self.addCoinBtn setTitle:model.gold forState:UIControlStateNormal];
    self.finishBtn.enabled = !model.is_complete;
    self.finishBtn.userInteractionEnabled = self.finishBtn.enabled;
    self.userInteractionEnabled = self.finishBtn.enabled;
}

- (IBAction)finishBtnClick:(id)sender {
    !self.btnClickBlock? : self.btnClickBlock(self.model);
}

@end
