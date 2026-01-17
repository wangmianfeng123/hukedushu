//
//  HKMyInfoNotificationCell.m
//  Code 11
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyInfoNotificationCell.h"
#import "HKMyInfoNotificationModel.h"
#import "HKShortVideoCommentModel.h"
#import "HKBookCommentModel.h"


@interface HKMyInfoNotificationCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentIVWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentIVHeight;
@property (weak, nonatomic) IBOutlet UIView *middelTapView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end


@implementation HKMyInfoNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置圆角
    self.headerIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIVClick)];
    [self.headerIV addGestureRecognizer:tap];
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    self.redPoint.clipsToBounds = YES;
    self.redPoint.layer.cornerRadius = 3;
    self.contentLB.numberOfLines = 0;
    self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -5, 0, 0);
    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 2.5;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyViewClick)];
    [self.middelTapView addGestureRecognizer:tag];
    [self hkDarkModel];
}



- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.timeLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196];
    self.separatorView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
}


- (void)replyViewClick {
    !self.replyBtnClickBlock? : self.replyBtnClickBlock(self.model? self.model : self.shortVideoCommentModel,self.bookCommentModel);
}


- (void)headerIVClick {
    !self.avatorClickBlock? : self.avatorClickBlock(self.model? self.model : self.shortVideoCommentModel,self.bookCommentModel);
}


- (IBAction)replyBtnClick:(id)sender {
    !self.replyBtnClickBlock? : self.replyBtnClickBlock(self.model? self.model : self.shortVideoCommentModel,self.bookCommentModel);
}



- (void)setModel:(HKMyInfoNotificationModel *)model {
    _model = model;
    self.redPoint.hidden = model.is_read;
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.timeLB.text = model.created_at_string;
    
    // 富文本content
    NSString *contentString = [NSString stringWithFormat:@"%@回复你：\n%@", model.username, model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:8];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196_A8ABBE range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, contentString.length - model.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length - model.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, model.username.length)];
    
    self.contentLB.attributedText = attrString;
    self.contentLB.height = self.model.contentLBHeigth;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];
    
    // 短视频
    if (model.isShortVideo) {
        self.contentIVWidth.constant = 40.0;
        self.contentIVHeight.constant = 71.0;
    }
}

- (void)setShortVideoCommentModel:(HKShortVideoCommentModel *)model {
    _shortVideoCommentModel = model;
    
    self.redPoint.hidden = model.is_read;
    
    NSString *headerURL = model.is_reply? model.commentUser.avator : model.parentCommentUser.avator;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:imageName(HK_Placeholder)];
    self.timeLB.text = model.created_at_string;
    
    // 富文本content
    NSString *replyOrCommentString = model.is_reply? @"回复" : @"评论";
    NSString *replyOrCommentName = model.is_reply? model.commentUser.username : model.parentCommentUser.username;
    NSString *contentString = [NSString stringWithFormat:@"%@%@你：\n%@", replyOrCommentName, replyOrCommentString, model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:8];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196_A8ABBE range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, contentString.length - model.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length - model.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, replyOrCommentName.length)];
    
    self.contentLB.attributedText = attrString;
    self.contentLB.height = self.model.contentLBHeigth;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];
    
    // 短视频
    self.contentIVWidth.constant = 40.0;
    self.contentIVHeight.constant = 71.0;
}



- (void)setBookCommentModel:(HKBookCommentModel *)bookCommentModel {
    _bookCommentModel = bookCommentModel;
    
    self.redPoint.hidden = bookCommentModel.is_read;
    [self.headerIV sd_setImageWithURL:HKURL(bookCommentModel.avatar) placeholderImage:imageName(HK_Placeholder)];
    self.timeLB.text = bookCommentModel.created_at;
    
    // 富文本content
    NSString *contentString = [NSString stringWithFormat:@"%@回复你：\n%@", bookCommentModel.username, bookCommentModel.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:8];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196_A8ABBE range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, contentString.length - bookCommentModel.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length - bookCommentModel.content.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, bookCommentModel.username.length)];
    
    self.contentLB.attributedText = attrString;
    self.contentLB.height = bookCommentModel.contentLBHeigth;
    
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:bookCommentModel.cover]) placeholderImage:imageName(HK_Placeholder)];
    self.contentIVWidth.constant = 42.0;
    self.contentIVHeight.constant = 63.0;
    
    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 2.5;
}

@end
