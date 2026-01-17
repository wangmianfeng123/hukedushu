//
//  HKWorksMomentCell.m
//  Code
//
//  Created by Ivan li on 2021/1/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKWorksMomentCell.h"
#import "UIView+HKLayer.h"
#import "HKMomentDetailModel.h"
#import "UIButton+WebCache.h"
//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "HKCustomMarginLabel.h"

@interface HKWorksMomentCell ()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopMargin;

@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentToCoverMargin;

@property (weak, nonatomic) IBOutlet UIView *imgsV;

@property (weak, nonatomic) IBOutlet UIView *fourImgView;
@property (weak, nonatomic) IBOutlet UIImageView *firstFImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondFimg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdFimg;
@property (weak, nonatomic) IBOutlet UIImageView *fourthFimg;


@property (weak, nonatomic) IBOutlet UIView *threeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *firstTimg;
@property (weak, nonatomic) IBOutlet UIImageView *secondTimg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdTimg;

@property (weak, nonatomic) IBOutlet UILabel *FirstCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTopMargin;


@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewTopMargin;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgV;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic , strong) HKCustomMarginLabel * countLabel;


@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelLeftMargin;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *totalCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelTopMargin;
@end

@implementation HKWorksMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    self.nameLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeDesLabel.textColor = COLOR_7B8196_A8ABBE;
    self.contentLabel.textColor = COLOR_27323F_EFEFF6;
    self.FirstCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.secondCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.totalCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.commentBgView.backgroundColor = COLOR_F8F9FA_333D48;
    self.imgsV.backgroundColor =COLOR_F8F9FA_333D48;
    [self.imgsV addCornerRadius:5];

    [self.headerBtn addCornerRadius:20];
    [self.coverView addCornerRadius:5];
    [self.commentBgView addCornerRadius:5];
    
    [self.commentBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.commentBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    
    [self.likeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.likeBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.likeBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.firstTimg addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.secondTimg addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.thirdTimg addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.firstFImg addGestureRecognizer:tap3];
    
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.secondFimg addGestureRecognizer:tap4];
    
    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.thirdFimg addGestureRecognizer:tap5];
    
    UITapGestureRecognizer * tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.fourthFimg addGestureRecognizer:tap6];
    
    [self.coverView addSubview:self.countLabel];
    
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:5];
    [UILabel changeLineSpaceForLabel:self.FirstCommentLabel WithSpace:3];
    [UILabel changeLineSpaceForLabel:self.secondCommentLabel WithSpace:3];

    self.teacherLabel.textColor = COLOR_FF7820;
    self.teacherLabel.backgroundColor = COLOR_FFF0E6;
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = COLOR_FF3221;
    [self.teacherLabel addCornerRadius:7];
    [self.topLabel addCornerRadius:7];
    
    [self.shareBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_share_trend_2_34" darkImageName:@"ic_comment_trend_dark_2_31"] forState:UIControlStateNormal];
    
//    UITapGestureRecognizer * totalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalCommentTapClick)];
//    self.totalCommentLabel.userInteractionEnabled = YES;
//    [self.totalCommentLabel addGestureRecognizer:totalTap];
}

//- (void)totalCommentTapClick{
//    [MobClick event: community_content_moreanswer];
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverView).offset(10);
        make.left.equalTo(self.coverView).offset(10);
    }];
    //self.countLabel.origin = CGPointMake(10, 10);
}

-(HKCustomMarginLabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel  = [[HKCustomMarginLabel alloc] init];
        _countLabel.textInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        _countLabel.textColor = COLOR_ffffff;
        _countLabel.font = HK_FONT_SYSTEM(13);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        //_countLabel.alpha = 0.5;
        _countLabel.clipsToBounds = YES;
        _countLabel.layer.cornerRadius = 4;
        //_tipLB.userInteractionEnabled = YES;
    }
    return _countLabel;
}

- (void)tapClick:(UITapGestureRecognizer *)tap{    
    if ([self.delegate respondsToSelector:@selector(worksMomentCellDidImgs:index:)]) {
        [self.delegate worksMomentCellDidImgs:_model.dynamic.images index:tap.view.tag];
    }
}

-(void)setModel:(HKMomentDetailModel *)model{
//    if (model == nil) return;
    _model = model;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
    self.nameLabel.text = model.user.username;
    self.timeDesLabel.text = model.topic.created_at;
    self.contentLabel.text = model.dynamic.descriptions;
    self.contentLabelTopMargin.constant = model.dynamic.descriptions.length ? 10:0.0;
    self.vipImgV.image = [HKvipImage comment_vipImageWithType:[NSString stringWithFormat:@"%@",model.user.userVipType]];
    self.titleBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.countLabel.text = [NSString stringWithFormat:@"共%lu张图",(unsigned long)model.dynamic.images.count];
    self.countLabel.hidden = model.dynamic.images.count > 1 ? NO :YES;
    [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.cover]]];
    self.titleLabel.text = model.dynamic.title;
    self.commentBgView.hidden = model.recentlyReplies.count ? NO : YES;
    
    CGFloat imgH = (SCREEN_WIDTH - 30-30) * 0.25;
    if (model.dynamic.images.count > 1) {
        self.imgsV.hidden = NO;
        self.commentToCoverMargin.constant = imgH + 20 + 10 + 5;
        if (model.dynamic.images.count == 2) {
            self.fourImgView.hidden = NO;
            self.threeImgView.hidden = YES;
            
            self.firstFImg.hidden = YES;
            self.secondFimg.hidden = NO;
            self.thirdFimg.hidden = NO;
            self.fourthFimg.hidden = YES;
            
            [self.secondFimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[0]]]];
            self.secondFimg.tag = 0;
            [self.thirdFimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[1]]]];
            self.thirdFimg.tag = 1;
        }else if (model.dynamic.images.count == 3){
            self.fourImgView.hidden = YES;
            self.threeImgView.hidden = NO;
            [self.firstTimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[0]]]];
            self.firstTimg.tag = 0;
            [self.secondTimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[1]]]];
            self.secondTimg.tag = 1;
            [self.thirdTimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[2]]]];
            self.thirdTimg.tag = 2;
        }else{
            self.fourImgView.hidden = NO;
            self.threeImgView.hidden = YES;
            
            self.firstFImg.hidden = NO;
            self.secondFimg.hidden = NO;
            self.thirdFimg.hidden = NO;
            self.fourthFimg.hidden = NO;
            
            [self.firstFImg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[0]]]];
            self.firstFImg.tag = 0;
            [self.secondFimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[1]]]];
            self.secondFimg.tag = 1;
            [self.thirdFimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[2]]]];
            self.thirdFimg.tag = 2;
            [self.fourthFimg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[3]]]];
            self.fourthFimg.tag = 3;
        }
        
    }else{
        self.imgsV.hidden = YES;
        self.commentToCoverMargin.constant = 15;
    }
    
    if (model.recentlyReplies.count) {
        self.toolViewTopMargin.constant = 15.0;
        if (model.recentlyReplies.count > 1) {
            self.secondTopMargin.constant = 5.0;
        }else{
            self.secondTopMargin.constant = 0.0;
            self.secondCommentLabel.text = @"";
        }
        [self loadReplyData:model.recentlyReplies];
    }else{
        self.toolViewTopMargin.constant = -5;
        self.secondTopMargin.constant = 0.0;
        self.FirstCommentLabel.text = @"";
        self.secondCommentLabel.text = @"";
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
    self.attentionBtn.hidden = model.user.hideSubscribe ? YES : NO;
    
    if ([model.topic.likes_count intValue] == 0) {
        [self.likeBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.likes_count] forState:UIControlStateNormal];
    }
    [self.likeBtn setImage:model.topic.isLiked ?[UIImage imageNamed:@"praise_red"] : [UIImage hkdm_imageWithNameLight:@"ic_good_trend_2_31" darkImageName:@"ic_good_trend_dark_2_31"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:model.topic.isLiked ? [UIColor colorWithHexString:@"FFB205"] : COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_comment_trend_2_31" darkImageName:@"ic_comment_trenddarks_2_31"] forState:UIControlStateNormal];
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
    
    if ([model.topic.reply_count intValue] == 0) {
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.reply_count] forState:UIControlStateNormal];
    }
    

    self.totalCommentLabel.text = [NSString stringWithFormat:@"共%@条解答 >",model.topic.reply_count];
    
    
    
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
        self.FirstCommentLabel.attributedText = attrString;

        HKMonmentReplyModel * model1 = replys[1];
        NSMutableAttributedString *attrString1 = [self addParagraphStyle:model1];
        self.secondCommentLabel.attributedText = attrString1;
    }else{
        HKMonmentReplyModel * model = replys[0];
        NSMutableAttributedString *attrString = [self addParagraphStyle:model];
        self.FirstCommentLabel.attributedText = attrString;
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
    if ([self.delegate respondsToSelector:@selector(worksMomentCellDidHeaderBtn:)]) {
        [self.delegate worksMomentCellDidHeaderBtn:self.model];
    }
}

- (IBAction)attentionBtnClick {
    if ([self.delegate respondsToSelector:@selector(worksMomentCellDidAttentionBtn:)]) {
        [self.delegate worksMomentCellDidAttentionBtn:self.model];
    }
}

- (IBAction)likeBtnClick {
    self.likeBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.likeBtn.userInteractionEnabled = YES;
    });

    if ([self.delegate respondsToSelector:@selector(worksMomentCellDidLikeBtn:)]) {
        [self.delegate worksMomentCellDidLikeBtn:self.model];
    }
}

- (IBAction)shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(worksMomentCellDidShareBtn:)]) {
        [self.delegate worksMomentCellDidShareBtn:self.model];
    }
}
@end
