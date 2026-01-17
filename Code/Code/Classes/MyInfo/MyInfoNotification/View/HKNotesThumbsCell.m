//
//  HKNotesThumbsCell.m
//  Code
//
//  Created by Ivan li on 2021/1/5.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKNotesThumbsCell.h"
#import "HKMyProductLikeCell.h"
#import "UIView+HKLayer.h"
#import "HKNotiTabModel.h"

@interface HKNotesThumbsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLabel;

@end

@implementation HKNotesThumbsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor =COLOR_F8F9FA_333D48;
    self.descLabel.textColor = COLOR_7B8196_A8ABBE;
    self.nameLabel.textColor = COLOR_27323F_FFFFFF;
    self.typeLabel.textColor = COLOR_27323F_FFFFFF;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.bottomTimeLabel.textColor = COLOR_A8ABBE_7B8196;
    [self.avatorImgV addCornerRadius:22.5];

    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapClick)];
    [self.avatorImgV addGestureRecognizer:tap];
}

-(void)setModel:(HKMyProductLikeCellModel *)model{
    _model = model;
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:imageName(HK_Placeholder)];
    self.timeLabel.text = model.created_at;
    self.descLabel.text = model.content;
    self.nameLabel.text = model.username;
    self.typeLabel.text = [NSString stringWithFormat:@"赞了你的%@",model.notice_title];
    
    // 标题
    //NSString *tempString = [NSString stringWithFormat:@"%@赞了你的作品", model.username];
    //NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tempString];
    //[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, tempString.length)];
    //[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 weight:UIFontWeightBold] range:NSMakeRange(0, model.username.length)];
    
}

-(void)setTabID:(NSNumber *)tabID{
    _tabID = tabID;
}

-(void)setMessageModel:(HKNotiMessageModel *)messageModel{
    _messageModel = messageModel;
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:messageModel.connectUser.avatar] placeholderImage:imageName(HK_Placeholder)];
    self.timeLabel.text = messageModel.created_at;
    self.bottomTimeLabel.text = messageModel.created_at;
    self.nameLabel.text = messageModel.connectUser.username;
    
    
    
    if ([_tabID intValue] == 1) { //回复
        self.typeLabel.text = [NSString stringWithFormat:@"%@%@",messageModel.contextPrefix,messageModel.contextSuffix];
        self.descLabel.text = messageModel.connect.content;

    }else if ([_tabID intValue] == 2){
        self.typeLabel.text = messageModel.contextPrefix;
        self.descLabel.text = messageModel.contextSuffix;

    }
    
    
    self.attentionBtn.hidden = messageModel.isSubscribe ? NO : YES;
    self.timeLabel.hidden = messageModel.isSubscribe ? YES : NO;
    self.bottomTimeLabel.hidden = messageModel.isSubscribe ? NO : YES;
    
    if (messageModel.connectUser.isSubscribed) {
        [self.attentionBtn addCornerRadius:10 addBoderWithColor:[UIColor clearColor] BoderWithWidth:0.0];
        [self.attentionBtn setBackgroundColor:COLOR_EFEFF6_7B8196];
        [self.attentionBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];

    }else{
        [self.attentionBtn addCornerRadius:10 addBoderWithColor:COLOR_27323F_EFEFF6 BoderWithWidth:1.0];
        [self.attentionBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        [self.attentionBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"回关TA" forState:UIControlStateNormal];
    }
}

- (void)headerTapClick{
    if (self.didAvatorBlock) {
        self.didAvatorBlock();
    }
}

- (IBAction)attentionBtnClick {
    if ([self.delegate respondsToSelector:@selector(myNotesThumbsCellModel:)]) {
        [self.delegate myNotesThumbsCellModel:self.messageModel];
    }
}
@end
