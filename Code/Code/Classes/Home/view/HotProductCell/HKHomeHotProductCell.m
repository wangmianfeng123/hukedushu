//
//  HKHomeHotProductCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/7/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeHotProductCell.h"

@interface HKHomeHotProductCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *vipHeaderIV;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;


@end

@implementation HKHomeHotProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.rightImageView.clipsToBounds = YES;
    self.rightImageView.layer.cornerRadius = 5.0;
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
}

- (void)setModel:(HKTaskModel *)model {
    _model = model;
    self.nameLB.text = model.title;
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.userNameLB.text = model.username;
    self.detailLB.text = [NSString stringWithFormat:@"%@人看过   %ld赞   %@评论", model.study_num, model.thumbs, model.comment_total];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.vipHeaderIV.hidden = model.vip_class.length == 0 || model.vip_class.integerValue == 0;
    self.vipHeaderIV.image = [HKvipImage comment_vipImageWithType:model.vip_class];
}

@end
