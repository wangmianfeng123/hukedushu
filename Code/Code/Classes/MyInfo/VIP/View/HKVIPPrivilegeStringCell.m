//
//  HKVIPPrivilegeStringCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKVIPPrivilegeStringCell.h"

@interface HKVIPPrivilegeStringCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HKVIPPrivilegeStringCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLB.textColor = COLOR_694C2F_EFEFF6;
    self.contentLB.textColor = COLOR_27323F_EFEFF6;
    self.bgView.backgroundColor = COLOR_FFFFFF_333D48;
}


//- (void)setVipInfoExModel:(HKVipInfoExModel *)vipInfoExModel {
//
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:vipInfoExModel.privilegeContent];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setParagraphSpacing:8];
//
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [vipInfoExModel.privilegeContent length])];
//
//    [self.contentLB setAttributedText:attributedString];
//
//    _vipInfoExModel = vipInfoExModel;
//    self.titleLB.text = vipInfoExModel.privilegeTitle;
//
//
//}

-(void)setPrivilegeContent:(NSString *)privilegeContent{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:privilegeContent];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //[paragraphStyle setParagraphSpacing:20];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [privilegeContent length])];
    [self.contentLB setAttributedText:attributedString];
    self.titleLB.text = @"特权说明";
}

-(void)setTxt:(NSString *)txt{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, txt.length)];
    [self.contentLB setAttributedText:attributedString];
    self.titleLB.text = @"自动续费服务声明";
}

@end
