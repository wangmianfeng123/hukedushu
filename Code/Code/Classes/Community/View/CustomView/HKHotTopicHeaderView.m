//
//  HKHotTopicHeaderView.m
//  Code
//
//  Created by Ivan li on 2021/1/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHotTopicHeaderView.h"
#import "UIView+HKLayer.h"
#import "HKMomentDetailModel.h"

@interface HKHotTopicHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation HKHotTopicHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.imgV addCornerRadius:5];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.readCountLabel.textColor = COLOR_A8ABBE_7B8196;
    self.discussLabel.textColor = COLOR_A8ABBE_7B8196;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    //ic_share_topic_2_34
    [self.shareBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_share_topic_2_34" darkImageName:@"ic_share_topic_dark_2_34"] forState:UIControlStateNormal];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    [self addGestureRecognizer:tap];
}

//- (void)tapClick{
//    if (self.didTapBlock) {
//        self.didTapBlock();
//    }
//}

-(void)setInfo:(HKSubjectInfoModel *)info{
    _info = info;
    //[self.imgV sd_setImageWithURL:[NSURL URLWithString:info.icon_url] placeholderImage:HK_PlaceholderImage];
    self.titleLabel.text = [NSString stringWithFormat:@"#%@#",info.name];
    if ([info.view_count intValue]) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@阅读",info.view_count];
    }
    if ([info.reply_count intValue]) {
        self.discussLabel.text = [NSString stringWithFormat:@"%@讨论",info.reply_count];
    }
}
- (IBAction)shareBtnClick {
    if (self.didShareBlock) {
        self.didShareBlock();
    }
}

@end
