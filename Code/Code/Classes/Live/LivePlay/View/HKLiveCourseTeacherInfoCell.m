//
//  HKLiveCourseTeacherInfoCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseTeacherInfoCell.h"

@interface HKLiveCourseTeacherInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopCons;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@end


@implementation HKLiveCourseTeacherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.self.followBtn setTitleColor:HKColorFromHex(0x808598, 1.0) forState:UIControlStateSelected];
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = self.followBtn.height * 0.5;
    self.self.followBtn.layer.borderWidth = 1;
    self.self.followBtn.layer.borderColor = HKColorFromHex(0x27323F, 1.0).CGColor;
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
    self.headerIV.userInteractionEnabled = YES;
    [self.headerIV addGestureRecognizer:tap];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.detailLB.textColor = COLOR_27323F_EFEFF6;
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
    self.infoLB.textColor = COLOR_A8ABBE_7B8196;
    self.desLB.textColor = COLOR_7B8196_A8ABBE;
}


- (void)headerTap {
    
    !self.headerIVTapBlock? : self.headerIVTapBlock();
}
- (IBAction)followCourseClick:(id)sender {
    !self.followTeacherClickBlock? : self.followTeacherClickBlock();
}


- (void)setModel:(HKLiveDetailModel *)model {
    
    // 没有目录
    if (model.series_courses.count > 0 && self.headerTopCons.constant > 0) {
        self.headerTopCons.constant = self.headerTopCons.constant - 50;
        self.detailLB.hidden = YES;
    }
    
    _model = model;
    self.nameLB.text = model.teacher.name;
    
    // 如果没有介绍，名字直接居中
    if (!model.teacher.organization_name.length) {
        self.nameCon.constant = 0;
    }
    self.infoLB.text = model.teacher.organization_name;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.teacher.content];
    UIFont *font = [UIFont systemFontOfSize:14];
    [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, model.teacher.content.length)];
    [text addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, model.teacher.content.length)];
    self.desLB.attributedText = text;
//    self.desLB.backgroundColor = [UIColor yellowColor];
    [self.desLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.teacher.contentHeight);
    }];
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.teacher.avator] placeholderImage:imageName(HK_Placeholder)];
    
    // 关注按钮
    self.followBtn.selected = model.teacher.is_subscription.intValue > 0;
    if (!self.followBtn.selected) {
        self.self.followBtn.layer.borderWidth = 1;
        self.self.followBtn.layer.borderColor = HKColorFromHex(0x27323F, 1.0).CGColor;
        [self.self.followBtn setBackgroundColor:HKColorFromHex(0xFFFFFF, 1.0)];
    } else {
        self.self.followBtn.layer.borderWidth = 1;
        self.self.followBtn.layer.borderColor = HKColorFromHex(0xFFFFFF, 1.0).CGColor;
        [self.self.followBtn setBackgroundColor:HKColorFromHex(0xefeff5, 1.0)];
    }
    
}
@end
