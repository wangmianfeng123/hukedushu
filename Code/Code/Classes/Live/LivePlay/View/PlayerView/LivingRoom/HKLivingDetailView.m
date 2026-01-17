//
//  HKLivingDetailView.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLivingDetailView.h"
#import "HKLiveListModel.h"
#import "HKGroupModel.h"

@interface HKLivingDetailView()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *onLineCount;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

@implementation HKLivingDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = 8.0;
    self.followBtn.layer.borderWidth = 1.0;
    
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = 21.0;
    
    self.headerIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
    [self.headerIV addGestureRecognizer:tap];
    
    self.followBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
}


- (void)headerTap {
    !self.headerIVClickBlock? : self.headerIVClickBlock();
}

- (IBAction)followBtnClick:(id)sender {
    
    !self.followBtnClickBlock? : self.followBtnClickBlock();
}

- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.teacher.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.teacher.name;
    
    // 已经关注教师
    if (model.teacher.is_subscription.intValue == 1) {
        self.followBtn.layer.borderColor = HKColorFromHex(0x7B8196, 1.0).CGColor;
        [self.followBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        self.followBtn.layer.borderColor = HKColorFromHex(0xEFEFF6, 1.0).CGColor;
        [self.followBtn setTitleColor:HKColorFromHex(0xEFEFF6, 1.0) forState:UIControlStateNormal];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    // 在线人数
    self.onLineCount.text = [NSString stringWithFormat:@"%@人在线", model.live.onLineCount.length? model.live.onLineCount: @"0"];
    
}
    /**
    NSString *group_account = model.teacher.im_group.group_account;
    if (isEmpty(group_account)) {
        // 已经关注教师
        if (model.teacher.is_subscription.intValue == 1) {
            self.followBtn.layer.borderColor = HKColorFromHex(0x7B8196, 1.0).CGColor;
            [self.followBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
            [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            self.followBtn.layer.borderColor = HKColorFromHex(0xEFEFF6, 1.0).CGColor;
            [self.followBtn setTitleColor:HKColorFromHex(0xEFEFF6, 1.0) forState:UIControlStateNormal];
            [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
    }else{
        self.followBtn.layer.borderColor = COLOR_3D8BFF.CGColor;
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"进入群组" forState:UIControlStateNormal];
        [self.followBtn setBackgroundColor:COLOR_3D8BFF];
    }
     **/
    

@end
