//
//  HKMomentCell.m
//  Code
//
//  Created by Ivan li on 2021/1/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentCell.h"
#import "UIView+HKLayer.h"
#import "HKMomentDetailModel.h"
#import "UIButton+WebCache.h"
//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "HKMonmentTypeModel.h"

@interface HKMomentCell ()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgViewTopMargin;//图片view顶部间隙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgViewHeight;//图片view高度
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTopMargin;//来源视频view顶部间隙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommandCoureHeight;
@property (weak, nonatomic) IBOutlet UIView *recommandCoureView;
@property (weak, nonatomic) IBOutlet UIImageView *courseCoverImgV;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseAvatorImgV;
@property (weak, nonatomic) IBOutlet UILabel *coureTeachLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagTopMargin; //标签顶部间隙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstCommentTopMargin;//第一条评论顶部间隙
@property (weak, nonatomic) IBOutlet UILabel *firstCommentLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTopMargin;//第二条评论顶部间隙
@property (weak, nonatomic) IBOutlet UILabel *secondCommentLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgV;

@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherLabelLeftMargin;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UILabel *totalCommentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalLabelTopMargin;

@end

@implementation HKMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    self.nameLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeDesLabel.textColor = COLOR_7B8196_A8ABBE;
    self.contentLabel.textColor = COLOR_27323F_EFEFF6;
    self.resourceLabel.textColor = COLOR_A8ABBE_7B8196;
    self.courseNameLabel.textColor = COLOR_27323F_EFEFF6;
    self.coureTeachLabel.textColor = COLOR_7B8196_A8ABBE;
    self.firstCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.secondCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.totalCommentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.commentBgView.backgroundColor = COLOR_F8F9FA_333D48;
    
    self.teacherLabel.textColor = COLOR_FF7820;
    self.teacherLabel.backgroundColor = COLOR_FFF0E6;
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = COLOR_FF3221;
    [self.teacherLabel addCornerRadius:7];
    [self.topLabel addCornerRadius:7];

    [self.recommandCoureView addCornerRadius:4];
    self.recommandCoureView.backgroundColor = COLOR_F8F9FA_333D48;
    
    [self.headerBtn addCornerRadius:20];
    [self.commentBgView addCornerRadius:5];
    [self.tagBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    self.tagBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 10);
    [self.tagBtn setBackgroundColor:COLOR_EFEFF6];
    [self.tagBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
    [self.tagBtn addCornerRadius:11];

    [self.commentBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.commentBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    
    [self.likeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.likeBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.likeBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
    
    [self.courseAvatorImgV addCornerRadius:10];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.recommandCoureView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatorTapClick)];
    [self.courseAvatorImgV addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalCommentTapClick)];
    self.totalCommentLabel.userInteractionEnabled = YES;
    [self.totalCommentLabel addGestureRecognizer:tap2];
    
    
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:5];
    [UILabel changeLineSpaceForLabel:self.firstCommentLabel WithSpace:3];
    [UILabel changeLineSpaceForLabel:self.secondCommentLabel WithSpace:3];
    [self.shareBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_share_trend_2_34" darkImageName:@"ic_comment_trend_dark_2_31"] forState:UIControlStateNormal];
    
}

- (void)tapClick{
    if ([self.delegate respondsToSelector:@selector(momentCellDidCourseView:)]) {
        [self.delegate momentCellDidCourseView:self.model];
        [MobClick event: community_content_relevantclass];
    }
}

- (void)avatorTapClick{
    if ([self.delegate respondsToSelector:@selector(momentCellDidCourseAvator:)]) {
        [self.delegate momentCellDidCourseAvator:self.model];
    }
}

- (void)totalCommentTapClick{
    if ([self.delegate respondsToSelector:@selector(momentCellDidTotalLabel:)]) {
        [self.delegate momentCellDidTotalLabel:self.indexPath];
        [MobClick event: community_content_moreanswer];
    }
}

- (IBAction)tagBtnClick {
    if ([self.delegate respondsToSelector:@selector(momentCellDidTagBtn:)]) {
        [self.delegate momentCellDidTagBtn:self.model];
        [MobClick event: community_content_topic];
    }
}

-(void)setModel:(HKMomentDetailModel *)model{
    _model = model;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
    self.nameLabel.text = model.user.username;
    self.timeDesLabel.text = model.topic.created_at;
    self.courseCoverImgV.clipsToBounds = YES;
    self.vipImgV.image = [HKvipImage comment_vipImageWithType:[NSString stringWithFormat:@"%@",model.user.userVipType]];
    
    self.commentBgView.hidden = model.recentlyReplies.count ? NO : YES;
    
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
    
    
    
    
    if (model.recentlyReplies.count == 0) {
        self.totalLabelHeight.constant = 0.0;
        self.totalLabelTopMargin.constant = 0.0;
        self.totalCommentLabel.text = @"";
    }else{
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
    }
        
    if ([model.topic.reply_count intValue] == 0) {
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.reply_count] forState:UIControlStateNormal];
    }
    [self.commentBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_comment_trend_2_31" darkImageName:@"ic_comment_trenddarks_2_31"] forState:UIControlStateNormal];
        
    
    
    if (model.user.subscribed) {
        [self.attentionBtn addCornerRadius:11 addBoderWithColor:[UIColor clearColor] BoderWithWidth:0.0];
        [self.attentionBtn setBackgroundColor:COLOR_EFEFF6_7B8196];
        [self.attentionBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];

    }else{
        [self.attentionBtn addCornerRadius:11 addBoderWithColor:COLOR_27323F_EFEFF6 BoderWithWidth:1.0];
        [self.attentionBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        [self.attentionBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    if ([model.topic.likes_count intValue] == 0) {
        [self.likeBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",model.topic.likes_count] forState:UIControlStateNormal];
    }
    [self.likeBtn setImage:model.topic.isLiked ?[UIImage imageNamed:@"praise_red"] :[UIImage hkdm_imageWithNameLight:@"ic_good_trend_2_31" darkImageName:@"ic_good_trend_dark_2_31"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:model.topic.isLiked ? [UIColor colorWithHexString:@"FFB205"] : COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    
    self.contentLabelTopMargin.constant = model.topic.content.length ? 10 : 0.0;
    self.contentLabel.text = model.topic.content;
        
    CGFloat imgViewHeight = [self calculateImgBgViewHeight:model];
    if (model.dynamic.isEmpty) {
        self.imgBgViewTopMargin.constant = 0.0;
        self.imgBgViewHeight.constant = 0.0;
        self.courseTopMargin.constant = 0.0;
        self.resourceLabel.hidden = YES;
        //self.recommandCoureHeight.constant = 0.0;
    }else  {//有图片无来源视频
        if (model.dynamic.images.count) {
            self.imgBgViewTopMargin.constant = 10.0;
            self.imgBgViewHeight.constant = imgViewHeight;
        }else{
            self.imgBgViewTopMargin.constant = 0.0;
            self.imgBgViewHeight.constant = 0.0;
        }
    }
    if (model.video.videoId.length) {
        self.resourceLabel.hidden = NO;
        self.courseTopMargin.constant = 30.0;
        self.recommandCoureHeight.constant = 60.0;
    }else{
        self.resourceLabel.hidden = YES;
        self.courseTopMargin.constant = 0.0;
        self.recommandCoureHeight.constant = 0.0;
    }
    [self loadRecommandCoureData:model.video];
    //标签及以下部分的布局判断
    self.tagTopMargin.constant = model.subjects.count ? 10.0:0.0;
    [self loadTagsData:model.subjects];
    if (model.recentlyReplies.count) {
        self.firstCommentTopMargin.constant = 15.0;
        if (model.recentlyReplies.count > 1) {
            self.secondTopMargin.constant = 5.0;
        }else{
            self.secondTopMargin.constant = 0.0;
            self.secondCommentLabel.text = @"";
        }
        [self loadReplyData:model.recentlyReplies];
    }else{
        self.firstCommentTopMargin.constant = 0.0;
        self.secondTopMargin.constant = 0.0;
        self.firstCommentLabel.text = @"";
        self.secondCommentLabel.text = @"";
    }
    
    self.attentionBtn.hidden = model.user.hideSubscribe ? YES : NO;
}

- (CGFloat)calculateImgBgViewHeight:(HKMomentDetailModel *)model{
    
    CGFloat imgW =((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH)-30-20)/3.0;
    CGFloat margin = 10;
    //NSInteger imgCount = 9;
    [self.imgBgView removeAllSubviews];
    
    CGFloat Height = 0.0;
    if (model.dynamic.images.count == 0) {
        return 0;
    }else if (model.dynamic.images.count == 1) {
        CGFloat imgW = (IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) * 0.5;
        CGFloat imgH = (IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) * 0.5;
        
        UIImageView * image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.userInteractionEnabled = YES;
        image.tag = 0;
        [image addCornerRadius:8];
        [image sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[0]]]];
        [self.imgBgView addSubview:image];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick:)];
        [image addGestureRecognizer:tap];

        if (imgW > ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30) || imgH >388) {
            if (imgW>((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30) && imgH >388) {
                image.frame = CGRectMake(0, 0, ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30), 388);

            }else if (imgW >((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30)){
                image.frame = CGRectMake(0, 0, ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30), ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 30)*688.0/568.0);

            }else if (imgH > 388){
                image.frame = CGRectMake(0, 0, 388 * 568.0/688.0, 388);
            }
        }else{
            image.frame = CGRectMake(0, 0, imgW, imgH);
        }
        Height = image.height + margin;
        
    }else{
        NSInteger columnCount = 0;
        if (model.dynamic.images.count == 4) {
            columnCount = 2;
        }else{
            columnCount = 3;
        }
        
        
        NSInteger imgCount = model.dynamic.images.count;
        if (imgCount>9) {
            imgCount = 9;
        }
        for (int i = 0; i<imgCount; i++) {
            CGFloat row = i/columnCount;
            CGFloat column = i%columnCount;
            
            CGFloat imgX = (imgW +margin) * column;
            CGFloat imgY = row * (imgW + margin);
            
            UIImageView * img = [[UIImageView alloc] init];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.userInteractionEnabled = YES;

            img.tag = i;
            [img addCornerRadius:4];
            img.frame = CGRectMake(imgX, imgY, imgW, imgW);
            [self.imgBgView addSubview:img];
            [img sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.dynamic.images[i]]]];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick:)];
            [img addGestureRecognizer:tap];
        }
        NSInteger row = ceil((CGFloat)imgCount/columnCount);
        Height = (imgW + margin) * row;
    }
    return Height;
}

- (void)loadRecommandCoureData:(HKMonmentVideoModel *)videoModel{
    self.courseNameLabel.text = videoModel.title;
    self.coureTeachLabel.text = videoModel.teacherName;
    [self.courseAvatorImgV sd_setImageWithURL:[NSURL URLWithString:videoModel.teacherAvatar]];
    [self.courseCoverImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover]]];
}

- (void)loadReplyData:(NSArray *)replys{
    if (replys.count > 1) {
        HKMonmentReplyModel * model = replys[0];
        NSMutableAttributedString *attrString = [self addParagraphStyle:model];
        self.firstCommentLabel.attributedText = attrString;
        
        HKMonmentReplyModel * model1 = replys[1];
        NSMutableAttributedString *attrString1 = [self addParagraphStyle:model1];
        self.secondCommentLabel.attributedText = attrString1;
    }else{
        HKMonmentReplyModel * model = replys[0];
        NSMutableAttributedString *attrString = [self addParagraphStyle:model];
        self.firstCommentLabel.attributedText = attrString;
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
//    [paragraphStyle setLineSpacing:3];
     paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return attrString;
}

- (void)loadTagsData:(NSArray *)tags{
    if (tags.count) {
        self.tagBtn.hidden = NO;
        self.tagBtnHeight.constant = 22;
        HKMonmentTagModel * model = tags[0];
        [self.tagBtn addCornerRadius:11];
        [self.tagBtn setTitle:model.name forState:UIControlStateNormal];
    }else{
        self.tagBtn.hidden = YES;
        [self.tagBtn setTitle:@"" forState:UIControlStateNormal];
        self.tagBtnHeight.constant = 0.0;

    }
}


- (IBAction)headerBtnClick {
    if ([self.delegate respondsToSelector:@selector(momentCellDidHeaderBtn:)]) {
        [self.delegate momentCellDidHeaderBtn:self.model];
    }
}

- (IBAction)attentionClick {
    if ([self.delegate respondsToSelector:@selector(momentCellDidAttentionBtn:)]) {
        [self.delegate momentCellDidAttentionBtn:self.model];
        [MobClick event: community_content_follow];
    }
}

- (IBAction)likeBtnClick {
    self.likeBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.likeBtn.userInteractionEnabled = YES;
    });
    if ([self.delegate respondsToSelector:@selector(momentCellDidLikeBtn:)]) {
        [self.delegate momentCellDidLikeBtn:self.model];
    }
}

- (void)imgTapClick:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(momentCellDidImgArray:andIndex:)]) {
        [self.delegate momentCellDidImgArray:self.model.dynamic.images andIndex:tap.view.tag];
    }
}

- (IBAction)commentBtnClick {
    if ([self.delegate respondsToSelector:@selector(momentCellDidCommentBtn:)]) {
        [self.delegate momentCellDidCommentBtn:self.model];
    }
}

- (IBAction)shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(momentCellDidShareBtn:)]) {
        [self.delegate momentCellDidShareBtn:self.model];
    }
}

@end
