//
//  HKInterestCell.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKInterestCell.h"
#import "UIView+HKLayer.h"
#import "HKMomentDetailModel.h"

@interface HKInterestCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImgV;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation HKInterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor =COLOR_FFFFFF_3D4752;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.shadowView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
    self.contentLabel.textColor = COLOR_7B8196_A8ABBE;
    [self.avatorImgV addCornerRadius:20];
    
    [self.contentView addCornerRadius:6];
    [self addShadowCornerRadius:6 shadowOffset:CGSizeZero shadowRadius:3];
    
//    [self.attentionBtn addCornerRadius:12.5 addBoderWithColor:[UIColor blackColor]];
//    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.avatorImgV addGestureRecognizer:tap];
}

- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 6;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowColor = [UIColor colorWithHexString:@"#D2D6E4"].CGColor;
    view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.clipsToBounds = NO;
}

- (IBAction)attentionBtnClick {
    self.attentionBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.attentionBtn.userInteractionEnabled = YES;
    });
    if ([self.delegate respondsToSelector:@selector(interestCellDidAttentionBtn:)]) {
        [self.delegate interestCellDidAttentionBtn:self.model];
    }
}

- (void)tapClick{
    if ([self.delegate respondsToSelector:@selector(interestCellDidHeaderBtn:)]) {
        [self.delegate interestCellDidHeaderBtn:self.model];
    }
}

-(void)setModel:(HKrecommendUserModel *)model{
    _model = model;    
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:HK_PlaceholderImage];
    self.nameLabel.text = model.username;
    
    if (model.descSuffix.length) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@\n%@",model.descPrefix,model.descSuffix];
    }else{
        self.contentLabel.text = model.descPrefix;
    }
    
    
    
    if (model.subscribed) {
        [self.attentionBtn addCornerRadius:12.5 addBoderWithColor:[UIColor clearColor] BoderWithWidth:0.0];
        [self.attentionBtn setBackgroundColor:COLOR_EFEFF6_7B8196];
        [self.attentionBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];

    }else{
        [self.attentionBtn addCornerRadius:12.5 addBoderWithColor:COLOR_27323F_EFEFF6 BoderWithWidth:1.0];
        [self.attentionBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        [self.attentionBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
}
@end
