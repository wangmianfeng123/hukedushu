//
//  HKChooseNoteCell.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKChooseNoteCell.h"
#import "UIView+HKLayer.h"
#import "HKRecommendTxtModel.h"
#import "UIButton+WebCache.h"
#import "UIButton+HKExtension.h"


@interface HKChooseNoteCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatorBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation HKChooseNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.clipsToBounds = YES;
    
    [self.avatorBtn addCornerRadius:10];
    [self.bgView addCornerRadius:6];
    [self addShadow:self.shadowView];
    
    self.typeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.typeLabel addCornerRadius:3];
    
    [self.zanBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    
//    UITapGestureRecognizer * tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
//    [self.nameLabel addGestureRecognizer:tapClick];

    self.contentView.backgroundColor = COLOR_FFFFFF_333D48;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.scoreLabel.textColor = COLOR_7B8196_A8ABBE;
    
    self.contentLabel.textColor = COLOR_7B8196_A8ABBE;
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    
    [UILabel changeLineSpaceForLabel:self.contentLabel WithSpace:3];
    //[UILabel changeWordSpaceForLabel:self.contentLabel WithSpace:1];
}

- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 7;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowColor = COLOR_D2D6E4_27323F.CGColor;
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.clipsToBounds = NO;
}

-(void)setModel:(HKRecommendTxtModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.image_url]] placeholderImage:imageName(HK_Placeholder)];
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.username;
    [self.avatorBtn sd_setImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
//    [self.avatorBtn sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.scoreLabel.text = [NSString stringWithFormat:@"评分：%0.1f",[model.score doubleValue]];
    if ([model.type isEqualToString:@"1"]) {
        self.typeLabel.text = @"评论";
    }else{
        self.typeLabel.text = @"笔记";
    }
    
    [self.zanBtn setImage:model.is_thumb?[UIImage imageNamed:@"praise_red"] : [UIImage imageNamed:@"praise_gray"] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:model.is_thumb ? [UIColor colorWithHexString:@"FFB205"] : COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    if (model.thumbs == 0) {
        [self.zanBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.zanBtn setTitle:[NSString stringWithFormat:@"%d",model.thumbs] forState:UIControlStateNormal];
    }
}

- (IBAction)zanBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(chooseNoteCellDidZanClick:)]) {
        [self.delegate chooseNoteCellDidZanClick:self.model];
    }
}

@end
