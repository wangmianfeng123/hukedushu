//
//  HKArticleCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCell.h"


@interface HKArticleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UIButton *exclusiveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLB;
@property (weak, nonatomic) IBOutlet UILabel *readCountLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeft;

@end

@implementation HKArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatorIV.clipsToBounds = YES;
    self.avatorIV.layer.cornerRadius = 5.0;
    self.userHeaderIV.clipsToBounds = YES;
    self.userHeaderIV.layer.cornerRadius = self.userHeaderIV.height * 0.5;
    
    if (IS_IPHONEMORE4_7INCH) {
        self.contentLeft.constant = 17;
    }
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.userNameLB.textColor = COLOR_A8ABBE_7B8196;
    self.likeCountLB.textColor = COLOR_A8ABBE_7B8196;
}


- (void)setModel:(HKArticleModel *)model {
    _model = model;
    self.titleLB.text = model.title;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_pic]] placeholderImage:imageName(HK_Placeholder)];
    
    self.exclusiveBtn.hidden = !model.is_exclusive;
    [self.userHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.userNameLB.text = model.name;
    self.likeCountLB.text = [NSString stringWithFormat:@"%@赞", model.appreciate_num];
    /// v2.17 隐藏
    //self.readCountLB.text = [NSString stringWithFormat:@"%ld人阅读", model.show_num];
}


@end
