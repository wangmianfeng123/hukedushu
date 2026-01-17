//
//  HKArticleRelationCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleRelationCell.h"

@interface HKArticleRelationCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *likeLB;
@property (weak, nonatomic) IBOutlet UILabel *readCountLB;
@property (weak, nonatomic) IBOutlet UIButton *isExclusiveBtn;

@end

@implementation HKArticleRelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 圆角
    self.avatorIV.clipsToBounds = YES;
    self.avatorIV.layer.cornerRadius = 5.0;
    self.userHeaderIV.clipsToBounds = YES;
    self.userHeaderIV.layer.cornerRadius = 10.0;
}

- (void)setModel:(HKArticleRelactionModel *)model {
    _model = model;
    self.titleLB.text = model.title;
    [self.avatorIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    [self.userHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.user_header] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = model.user_name;
    self.likeLB.text = [NSString stringWithFormat:@"%@赞", model.likeCount];
    /// v2.17 隐藏
    self.readCountLB.text = nil;
    //self.readCountLB.text = [NSString stringWithFormat:@"%@人阅读", model.readCount];
    self.isExclusiveBtn.hidden = !model.isExclusive;
}


@end
