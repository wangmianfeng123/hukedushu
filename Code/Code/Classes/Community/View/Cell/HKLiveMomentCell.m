//
//  HKLiveMomentCell.m
//  Code
//
//  Created by Ivan li on 2021/1/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveMomentCell.h"
#import "HKMomentDetailModel.h"
#import "UIButton+WebCache.h"
#import "UIView+HKLayer.h"
//#import <FLAnimatedImage/FLAnimatedImage.h>

@interface HKLiveMomentCell ()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLabel;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuwenLabel;
@property (weak, nonatomic) IBOutlet UIView *labelBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTopMargin;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgV;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherLabelLeftMargin;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelTopMargin;
@property (weak, nonatomic) IBOutlet UIView *commentBgView;

@end

@implementation HKLiveMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    self.nameLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeDesLabel.textColor = COLOR_7B8196_A8ABBE;
    self.firstLabel.textColor = COLOR_7B8196_A8ABBE;
    self.secondLabel.textColor = COLOR_7B8196_A8ABBE;
    self.totalCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.commentBgView.backgroundColor = COLOR_F8F9FA_333D48;

    [self.headerBtn addCornerRadius:20];

    [self.commentBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.commentBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.likeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.likeBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.likeBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
    
    [self.attentionBtn setBackgroundColor:COLOR_EFEFF6_7B8196];
    [self.attentionBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    [self.attentionBtn addCornerRadius:11 addBoderWithColor:[UIColor blackColor] BoderWithWidth:1.0];
    self.titleLabel.textColor = COLOR_27323F_FFFFFF;
    [self.coverView addCornerRadius:5];
    self.labelBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [UILabel changeLineSpaceForLabel:self.firstLabel WithSpace:3];
    [UILabel changeLineSpaceForLabel:self.secondLabel WithSpace:3];
    
    self.teacherLabel.textColor = COLOR_FF7820;
    self.teacherLabel.backgroundColor = COLOR_FFF0E6;
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = COLOR_FF3221;
    [self.teacherLabel addCornerRadius:7];
    [self.topLabel addCornerRadius:7];
    [self.commentBgView addCornerRadius:5];
    [self.shareBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_share_trend_2_34" darkImageName:@"ic_comment_trend_dark_2_31"] forState:UIControlStateNormal];
    
//    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalCommentTapClick)];
//    self.totalCommentLabel.userInteractionEnabled = YES;
//    [self.totalCommentLabel addGestureRecognizer:tap2];

}

-(void)setModel:(HKMomentDetailModel *)model{
//    if (model == nil) return;
    _model = model;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
    self.nameLabel.text = model.user.username;
    self.timeDesLabel.text = model.topic.created_at;
    self.vipImgV.image = [HKvipImage comment_vipImageWithType:[NSString stringWithFormat:@"%@",model.user.userVipType]];
    self.commentBgView.hidden = model.recentlyReplies.count ? NO : YES;
    
    if ([model.topic.reply_count intValue] == 0) {
        self.totalLabelHeight.constant = 0.0;
        self.totalLabelTopMargin.constant = 0.0;
    }else{
        if ([model.topic.reply_count intValue] > 2) {
            self.totalLabelHeight.constant = 15.0;
            self.totalLabelTopMargin.constant = 5.0;
        }else{
            self.totalLabelHeight.constant = 0.0;
            self.totalLabelTopMargin.constant = 0.0;
        }
        
    }
    self.totalCommentLabel.text = [NSString stringWithFormat:@"共%@条解答 >",model.topic.reply_count];
    
    
    if ([model.topic.reply_count intValue] == 0) {
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.reply_count] forState:UIControlStateNormal];
    }

    if ([model.topic.likes_count intValue] == 0) {
        [self.likeBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.likes_count] forState:UIControlStateNormal];
    }
    
    if (model.user.subscribed) {
        [self.attentionBtn addCornerRadius:11 addBoderWithColor:[UIColor clearColor] BoderWithWidth:0.0];
        [self.attentionBtn setBackgroundColor:COLOR_EFEFF6_7B8196];
        [self.attentionBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];

    }else{
        [self.attentionBtn addCornerRadius:11 addBoderWithColor:COLOR_27323F_EFEFF6 BoderWithWidth:1.0];
        //[self.attentionBtn setBackgroundColor:COLOR_FFFFFF_333D48];
        [self.attentionBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        [self.attentionBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    [self.likeBtn setImage:model.topic.isLiked ?[UIImage imageNamed:@"praise_red"] : [UIImage hkdm_imageWithNameLight:@"ic_good_trend_2_31" darkImageName:@"ic_good_trend_dark_2_31"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:model.topic.isLiked ? [UIColor colorWithHexString:@"FFB205"] : COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_comment_trend_2_31" darkImageName:@"ic_comment_trenddarks_2_31"] forState:UIControlStateNormal];

    
    
    if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){//社区动态 - 视频
        self.labelBgView.hidden = YES;
        self.startTimeLabel.hidden = YES;
        self.timeLabel.hidden = NO;
        
        self.timeLabel.text = model.dynamic.duration;
        self.tuwenLabel.hidden = model.dynamic.hasContent ? NO : YES;

    }else if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
        self.labelBgView.hidden = NO;
        self.startTimeLabel.hidden = NO;
        self.timeLabel.hidden = YES;
        self.tuwenLabel.hidden = YES;
        self.startTimeLabel.text = model.dynamic.startAt;
    }

    [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.cover]]];
    //https://pic.huke88.com/video/cover/2021-03-19/DFF5CB92-A7DD-CBF2-9A2A-C6772A7570BF.gif
    //[self.coverImgV sd_setImageWithURL:[NSURL URLWithString:@"https://pic.huke88.com/video/cover/2021-03-19/DFF5CB92-A7DD-CBF2-9A2A-C6772A7570BF.gif"]];

    self.titleLabel.text = model.dynamic.title;

    if (model.recentlyReplies.count) {
        self.firstLabelTopMargin.constant = 15.0;
        if (model.recentlyReplies.count > 1) {
            self.secondTopMargin.constant = 5.0;
        }else{
            self.secondTopMargin.constant = 0.0;
            self.secondLabel.text = @"";
        }
        [self loadReplyData:model.recentlyReplies];
    }else{
        self.firstLabelTopMargin.constant = 0.0;
        self.secondTopMargin.constant = 0.0;
        self.firstLabel.text = @"";
        self.secondLabel.text = @"";
    }
    
    self.attentionBtn.hidden = model.user.hideSubscribe ? YES : NO;
    
    
    if ([model.user.userVipType intValue] != 0) {
            //vip存在
            if (model.user.isTeacher) {
                self.teacherLabel.hidden = NO;
                self.teacherLabelLeftMargin.constant = 30;
                if (model.topic.is_top) {
                    self.topLabel.hidden = NO;
                    self.topLabelLeftMargin.constant = 75;
                }else{
                    self.topLabel.hidden = YES;
                }
            }else{
                self.teacherLabel.hidden = YES;
                if (model.topic.is_top) {
                    self.topLabel.hidden = NO;
                    self.topLabelLeftMargin.constant = 30;
                }else{
                    self.topLabel.hidden = YES;
                }
            }
        }else{
            //VIP不存在
            if (model.user.isTeacher) {
                self.teacherLabelLeftMargin.constant = 5;
                self.teacherLabel.hidden = NO;
                if (model.topic.is_top) {
                    self.topLabelLeftMargin.constant = 50;
                    self.topLabel.hidden = NO;
                }else{
                    self.topLabel.hidden = YES;
                }
            }else{
                self.teacherLabel.hidden = YES;
                if (model.topic.is_top) {
                    self.topLabelLeftMargin.constant = 5;
                    self.topLabel.hidden = NO;
                }else{
                    self.topLabel.hidden = YES;
                }
            }
        }
}

- (void)loadReplyData:(NSArray *)replys{
    if (replys.count > 1) {
        HKMonmentReplyModel * model = replys[0];
        NSMutableAttributedString *attrString = [self addParagraphStyle:model];
        self.firstLabel.attributedText = attrString;

        HKMonmentReplyModel * model1 = replys[1];
        NSMutableAttributedString *attrString1 = [self addParagraphStyle:model1];
        self.secondLabel.attributedText = attrString1;
        
    }else{
        HKMonmentReplyModel * model = replys[0];
        NSMutableAttributedString *attrString = [self addParagraphStyle:model];
        self.firstLabel.attributedText = attrString;
    }
}

- (NSMutableAttributedString *)addParagraphStyle:(HKMonmentReplyModel *)model{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//行间距
    //清除首尾空格
    NSString *contentString = [NSString stringWithFormat:@" %@：%@",model.username,model.content];
    NSRange userNameRange = [contentString rangeOfString:[NSString stringWithFormat:@"%@：",model.username]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    //self.firstCommentLabel.attributedText = attrString;
    
    //3.初始化NSTextAttachment对象
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, -2, 13, 13);//设置frame
    attchment.image = [UIImage hkdm_imageWithNameLight:@"ic_comment_detail_2_31" darkImageName:@"ic_comment_detail_dark_2_31"];//[UIImage imageNamed:@""];//设置图片
    
    //4.创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    [attrString insertAttributedString:string atIndex:0];//插入到第几个下标
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:userNameRange];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return attrString;
}


- (IBAction)headerBtnClick {
    if ([self.delegate respondsToSelector:@selector(liveMomentCellDidHeaderBtn:)]) {
        [self.delegate liveMomentCellDidHeaderBtn:self.model];
    }
}


- (IBAction)attentionBtnClick {
    if ([self.delegate respondsToSelector:@selector(liveMomentCellDidAttentionBtn:)]) {
        [self.delegate liveMomentCellDidAttentionBtn:self.model];
    }
}

- (IBAction)likeBtnClick {
    self.likeBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.likeBtn.userInteractionEnabled = YES;
    });
    if ([self.delegate respondsToSelector:@selector(liveMomentCellDidLikeBtn:)]) {
        [self.delegate liveMomentCellDidLikeBtn:self.model];
    }
}

- (void)tapClick{
    if ([self.delegate respondsToSelector:@selector(liveMomentCellDidCoverView:)]) {
        [self.delegate liveMomentCellDidCoverView:self.model];
        if ([self.model.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[self.model.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){//社区动态 - 视频
            [MobClick event: community_content_class];
        }else if ([self.model.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[self.model.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
            [MobClick event: community_content_liveclass];
        }
    }
}

- (IBAction)shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(liveMomentCellDidShareBtn:)]) {
        [self.delegate liveMomentCellDidShareBtn:self.model];
    }
}
@end
