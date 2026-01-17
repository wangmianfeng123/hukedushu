//
//  HKArticleRelationHeaderView.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleRelationHeaderView.h"

@interface HKArticleRelationHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *themeLB;

@end

@implementation HKArticleRelationHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置点赞按钮样式
    self.likeBtn.clipsToBounds = YES;
    self.likeBtn.layer.cornerRadius = 55.0 * 0.5;
    [self.likeBtn setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xFFD305, 1.0) size:CGSizeMake(55, 55)] forState:UIControlStateNormal];
    [self.likeBtn setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xFFFAE4, 1.0) size:CGSizeMake(55, 55)] forState:UIControlStateSelected];
    [self.likeBtn setImage:imageName(@"ic_good_v2_3") forState:UIControlStateNormal];
    [self.likeBtn setImage:imageName(@"ic_goodpre_v2_3") forState:UIControlStateSelected];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.likeBtn setTitleColor:HKColorFromHex(0xFFFFFF, 1.0) forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:HKColorFromHex(0xFF7820, 1.0) forState:UIControlStateSelected];
    self.likeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.themeLB.textColor = COLOR_27323F_EFEFF6;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (IBAction)likeBtnClick:(id)sender {
    !self.likeBtnClickBlock? : self.likeBtnClickBlock(sender);
}

- (void)setLikeBtn:(NSString *)count isLike:(BOOL)isLike {
    self.likeBtn.selected = isLike;
    count = (!count || count.intValue == 0)? nil : count;
    [self.likeBtn setTitle:count forState:UIControlStateNormal];
}



@end


//@implementation HKArticleRelationHeaderViewButton
//
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    // 无数量或者数量为0
//    if (self.titleLabel.text.length) {
//        self.titleLabel.hidden = NO;
//        self.imageView.frame = CGRectMake(0, 0, self.width, self.height * 0.5);
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill | UIViewContentModeBottom | UIViewContentModeCenter;
//        
//        self.titleLabel.frame = CGRectMake(0, self.height * 0.5 + 4, self.width, 12.5);
//    } else {
//        self.imageView.frame = self.bounds;
//        self.imageView.contentMode = UIViewContentModeCenter;
//        self.titleLabel.hidden = YES;
//    }
//}
//
//@end

