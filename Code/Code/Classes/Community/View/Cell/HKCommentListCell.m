//
//  HKCommentListCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommentListCell.h"
#import "HKCommentModel.h"
#import "UIView+HKLayer.h"
#import "UIButton+WebCache.h"

@interface HKCommentListCell ()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;


@property (weak, nonatomic) IBOutlet UIView *replyView;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelTopMargin;

@property (weak, nonatomic) IBOutlet UILabel *seconLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelTopMargin;

@property (weak, nonatomic) IBOutlet UILabel *thridLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridLabelTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridBottomMargin;

@property (weak, nonatomic) IBOutlet UIButton *lookMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replayViewTopMargin;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelLeftMargin;

@end

@implementation HKCommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headerBtn addCornerRadius:20];
    self.nameLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeLabel.textColor = COLOR_7B8196_A8ABBE;
    self.contentLabel.textColor = COLOR_27323F_EFEFF6;
    self.replyView.backgroundColor = COLOR_F8F9FA_333D48;
    self.firstLabel.textColor = COLOR_7B8196_A8ABBE;
    self.seconLabel.textColor = COLOR_7B8196_A8ABBE;
    self.thridLabel.textColor = COLOR_7B8196_A8ABBE;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    [self.likeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.moreBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_more_reply_2_31" darkImageName:@"ic_more_reply_dark_2_31"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer * contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapClick)];
    [self.contentLabel addGestureRecognizer:contentTap];
    
    UITapGestureRecognizer * labelTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapClick:)];
    [self.firstLabel addGestureRecognizer:labelTap1];

    UITapGestureRecognizer * labelTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapClick:)];
    [self.seconLabel addGestureRecognizer:labelTap2];

    UITapGestureRecognizer * labelTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapClick:)];
    [self.thridLabel addGestureRecognizer:labelTap3];
    
    self.teacherLabel.textColor = COLOR_FF7820;
    self.teacherLabel.backgroundColor = COLOR_FFF0E6;
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = COLOR_FF3221;
    [self.teacherLabel addCornerRadius:7];
    [self.topLabel addCornerRadius:7];

}

- (void)contentTapClick{
    if ([self.delegate respondsToSelector:@selector(commentListCellDidLabel:subReplyModel:)]) {
        [self.delegate commentListCellDidLabel:self.commentModel subReplyModel:nil];
    }
}

- (void)labelTapClick:(UITapGestureRecognizer *)tap{
    if (tap.view.tag < self.commentModel.subs.count) {
        HKCommentModel * model = self.commentModel.subs[tap.view.tag];
        if ([self.delegate respondsToSelector:@selector(commentListCellDidLabel:subReplyModel:)]) {
            [self.delegate commentListCellDidLabel:self.commentModel subReplyModel:model];
        }
    }
}

- (IBAction)lookMoreBtnClick {
    if (self.didLookMoreBlock) {
        self.didLookMoreBlock(self.commentModel);
    }
}

-(void)setCommentModel:(HKCommentModel *)commentModel{
    _commentModel = commentModel;
    _nameLabel.text = commentModel.username;
        
    if ([commentModel.likes_count intValue] == 0) {
        [self.likeBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",commentModel.likes_count] forState:UIControlStateNormal];
    }
    
    [self.likeBtn setImage:commentModel.isLiked ?[UIImage imageNamed:@"ic_good_reply_sel_dark_2_31"] : [UIImage hkdm_imageWithNameLight:@"ic_good_reply_nor_2_31" darkImageName:@"ic_good_reply_dark_2_31"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:commentModel.isLiked ? [UIColor colorWithHexString:@"FFB205"] : COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
    self.timeLabel.text = commentModel.created_at;
    
    
    self.contentLabel.text = commentModel.content; //1级
    if (commentModel.subs.count == 0) {
        self.firstLabel.text = @"";
        self.firstLabelTopMargin.constant = 0.0;
        self.seconLabel.text = @"";
        self.secondLabelTopMargin.constant = 0.0;
        self.thridLabel.text = @"";
        self.thridLabelTopMargin.constant = 0.0;
        self.replayViewTopMargin.constant =  0.0;
    }else{
        self.replayViewTopMargin.constant =  10.0;
        if (commentModel.subs.count >2) {
            self.firstLabelTopMargin.constant = 10.0;
            HKCommentModel * comm = commentModel.subs[0];
            if ([comm.reply_to_username isEqualToString:comm.username] || comm.reply_to_username.length==0) {
                //self.firstLabel.text = [NSString stringWithFormat:@"%@: %@", comm.username, comm.content];
                
                NSMutableAttributedString *attrString  = [self addParagraphStyle:comm];
                self.firstLabel.attributedText = attrString;
                
            }else{
                //self.firstLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm.username, comm.reply_to_username, comm.content];
                NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm];
                self.firstLabel.attributedText = attrString;

            }
            
            
            self.secondLabelTopMargin.constant = 5.0;
            HKCommentModel * comm1 = commentModel.subs[1];
            if ([comm1.reply_to_username isEqualToString:comm1.username] || comm1.reply_to_username.length==0) {
                //self.seconLabel.text = [NSString stringWithFormat:@"%@: %@", comm1.username, comm1.content];
                NSMutableAttributedString *attrString  = [self addParagraphStyle:comm1];
                self.seconLabel.attributedText = attrString;
            }else{
                //self.seconLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm1.username, comm1.reply_to_username, comm1.content];
                NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm1];
                self.seconLabel.attributedText = attrString;
            }
            
            self.thridLabelTopMargin.constant = 5.0;
            HKCommentModel * comm2 = commentModel.subs[2];
            if ([comm2.reply_to_username isEqualToString:comm2.username] || comm2.reply_to_username.length==0) {
                //self.thridLabel.text = [NSString stringWithFormat:@"%@: %@", comm2.username, comm2.content];
                
                NSMutableAttributedString *attrString  = [self addParagraphStyle:comm2];
                self.thridLabel.attributedText = attrString;
            }else{
                //self.thridLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm2.username, comm2.reply_to_username, comm2.content];
                NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm2];
                self.thridLabel.attributedText = attrString;
            }
        }else{
            if (commentModel.subs.count == 1) {
                self.firstLabelTopMargin.constant = 10.0;
                self.secondLabelTopMargin.constant = 0.0;
                self.thridLabelTopMargin.constant = 0.0;
                
                HKCommentModel * comm = commentModel.subs[0];
                if ([comm.reply_to_username isEqualToString:comm.username] || comm.reply_to_username.length==0) {
                    //self.firstLabel.text = [NSString stringWithFormat:@"%@: %@", comm.username, comm.content];
                    NSMutableAttributedString *attrString  = [self addParagraphStyle:comm];
                    self.firstLabel.attributedText = attrString;

                }else{
                    //self.firstLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm.username, comm.reply_to_username, comm.content];
                    NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm];
                    self.firstLabel.attributedText = attrString;

                }
                self.seconLabel.text = @"";
                self.thridLabel.text = @"";

            }else{
                self.firstLabelTopMargin.constant = 10.0;
                self.secondLabelTopMargin.constant = 5.0;
                self.thridLabelTopMargin.constant = 0.0;
                
                HKCommentModel * comm = commentModel.subs[0];
                if ([comm.reply_to_username isEqualToString:comm.username] || comm.reply_to_username.length==0) {
                    //self.firstLabel.text = [NSString stringWithFormat:@"%@: %@", comm.username, comm.content];
                    NSMutableAttributedString *attrString  = [self addParagraphStyle:comm];
                    self.firstLabel.attributedText = attrString;

                }else{
                    //self.firstLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm.username, comm.reply_to_username, comm.content];
                    NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm];
                    self.firstLabel.attributedText = attrString;

                }
                
                HKCommentModel * comm1 = commentModel.subs[1];
                if ([comm1.reply_to_username isEqualToString:comm1.username] || comm1.reply_to_username.length==0) {
                    NSMutableAttributedString *attrString  = [self addParagraphStyle:comm1];
                    self.seconLabel.attributedText = attrString;

                }else{
                    //self.seconLabel.text = [NSString stringWithFormat:@"%@ 回复 %@:%@", comm1.username, comm1.reply_to_username, comm1.content];
                    NSMutableAttributedString *attrString  = [self addOtherParagraphStyle:comm1];
                    self.seconLabel.attributedText = attrString;
                }
                self.thridLabel.text = @"";
            }
        }
    }
    
    if ([commentModel.reply_count intValue] >3) {
        self.thridBottomMargin.constant = 30.0;
        self.lookMoreBtn.hidden = NO;
    }else{
        self.thridBottomMargin.constant =  commentModel.subs.count ? 10.0:0;
        self.lookMoreBtn.hidden = YES;
    }
        
    self.teacherLabel.hidden = commentModel.isTeacher ? NO : YES;
    self.topLabel.hidden = commentModel.is_top ? NO : YES;
    self.topLabelLeftMargin.constant = commentModel.isTeacher ? 50:5;
}

- (NSMutableAttributedString *)addParagraphStyle:(HKCommentModel *)model{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//行间距
    NSString *contentString = [NSString stringWithFormat:@"%@：%@", model.username, model.content];
    NSRange userNameRange = [contentString rangeOfString:model.username];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
    return attrString;
}

- (NSMutableAttributedString *)addOtherParagraphStyle:(HKCommentModel *)model{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//行间距
    NSString *contentString = [NSString stringWithFormat:@"%@ 回复 %@：%@", model.username, model.reply_to_username, model.content];
    NSRange userNameRange = [contentString rangeOfString:model.username];
    NSRange replyUserNameRange = [contentString rangeOfString:model.reply_to_username];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:userNameRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_3D8BFF range:replyUserNameRange];
    return attrString;
}


- (IBAction)moreBtnClick {
    if ([self.delegate respondsToSelector:@selector(commentListCellDidMoreBtn:)]) {
        [self.delegate commentListCellDidMoreBtn:self.commentModel];
    }
}

- (IBAction)likeBtnClick {
    if ([self.delegate respondsToSelector:@selector(commentListCellDidLikeBtn:)]) {
        [self.delegate commentListCellDidLikeBtn:self.commentModel];
    }
}

- (IBAction)headerBtnClick {
    if ([self.delegate respondsToSelector:@selector(commentListCellDidHeaderBtn:)]) {
        [self.delegate commentListCellDidHeaderBtn:self.commentModel];
    }
}
@end
