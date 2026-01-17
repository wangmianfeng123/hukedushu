//
//  HKVipPrivilegeInTopCell.m
//  Code
//
//  Created by eon Z on 2021/11/8.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVipPrivilegeInTopCell.h"

@interface HKVipPrivilegeInTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;

@end


@implementation HKVipPrivilegeInTopCell




- (void)awakeFromNib {
    [super awakeFromNib];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.desLB.textColor = COLOR_A8ABBE_7B8196;
    //self.contentView.backgroundColor = [UIColor hkdm_colorWithColorLight:[UIColor clearColor] dark:COLOR_333D48];
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)setModel:(HKVipPrivilegeModel *)model {
    _model = model;
    
    if (isEmpty(model.icon)) {
        self.headerIV.image = imageName(model.header);  //2.16 之前版本
    }else{
        [self.headerIV sd_setImageWithURL:HKURL(model.icon)];
    }
    self.nameLB.text = model.name;
    self.desLB.text = model.des;
}

@end
