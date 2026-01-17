//
//  HomeMyFollowVideoV3Cell.m
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HomeMyFollowVideoV3Cell.h"
#import "HKUserModel.h"
#import "UIView+HKLayer.h"
#import "HKRecommendTxtModel.h"

@interface HomeMyFollowVideoV3Cell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HomeMyFollowVideoV3Cell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.topImgView.clipsToBounds = YES;
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    self.scoreLabel.textColor = COLOR_7B8196_A8ABBE;
    self.descLabel.textColor = COLOR_7B8196_A8ABBE;
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    
    [self.avatarImgView addCornerRadius:10];
    [UILabel changeLineSpaceForLabel:self.descLabel WithSpace:3];
    [self.bgView addCornerRadius:6];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self addShadow:self.shadowView];
    
    //[self.teacherHomeBtn addCornerRadius:7.5 addBoderWithColor:[UIColor colorWithHexString:@"#27323F"] BoderWithWidth:0.5];
    
    UITapGestureRecognizer * tapClick1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
    [self.avatarImgView addGestureRecognizer:tapClick1];
    UITapGestureRecognizer * tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
    [self.nameLabel addGestureRecognizer:tapClick];
}


- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 7;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowColor = COLOR_D2D6E4_27323F.CGColor;
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.clipsToBounds = NO;
}

- (void)headerClick{
    !self.followTeacherSelectedBlock? : self.followTeacherSelectedBlock(self.model);
}

//- (IBAction)teacherHomeBtnClick {
//    !self.followTeacherSelectedBlock? : self.followTeacherSelectedBlock(self.model);
//}

-(void)setModel:(HKRecommendTxtModel *)model{
    _model = model;
    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.image_url]] placeholderImage:imageName(HK_Placeholder)];
    self.descLabel.text = model.content;
    self.nameLabel.text = model.username;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:imageName(HK_Placeholder)];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分：%0.1f",[model.score doubleValue]];
    self.titleLabel.text = model.title;
}

//- (void)setModel:(HKUserModel *)model {
//    _model = model;
//    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:model.video.img_cover_url_big] placeholderImage:imageName(HK_Placeholder)];
//    self.descLabel.text = model.video.video_title;
//    self.nameLabel.text = model.name;
//    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
//
//
//
////    _model = model;
////    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
////    self.nameLB.text = model.name;
////    self.desLB.text = model.title;
////    self.followBtn.selected = model.is_follow;
////
////    // 第一个视频
////    if (model.video_list.count >= 1) {
////        self.coverIV2.hidden = NO;
////        self.titleLB2.hidden = NO;
////        VideoModel *videoModel = model.video_list[0];
////        [self.coverIV1 sd_setImageWithURL:[NSURL URLWithString:videoModel.img_cover_url_big] placeholderImage:imageName(HK_Placeholder)];
////        self.titleLB1.text = videoModel.video_title;
////    }
//}

@end
