//
//  HKLiveRcommandSubCell.m
//  Code
//
//  Created by eon Z on 2021/12/15.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveRcommandSubCell.h"
#import "UIView+HKLayer.h"
#import "HKLiveListModel.h"
#import "HKLiveCardView.h"


@interface HKLiveRcommandSubCell ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *cardContentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end

@implementation HKLiveRcommandSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.topLabel.textColor = COLOR_27323F_A8ABBE;
    [self.moreBtn setTitleColor:[COLOR_A8ABBE colorWithAlphaComponent:0.9] forState:UIControlStateNormal];
    [self.moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:3];
    self.moreBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
    [self.bgView addCornerRadius:5];
    [self.topView addCornerRadius:5];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView addShadowCornerRadius:5.0 shadowOffset:CGSizeMake(0, 0) shadowRadius:3.0];
    
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        BOOL isHKNight = (mode == DMUserInterfaceStyleDark) ? YES :NO;
        self.bgImgV.image = isHKNight ? [UIImage new]:[UIImage imageNamed:@"bg_list_2_39"];
        self.iconImgV.hidden = isHKNight ? YES : NO;
    }
}


-(void)setCardArray:(NSArray *)cardArray{
    _cardArray = cardArray;
    
    [self.cardContentView removeAllSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < cardArray.count; i ++) {
            HKLiveCardView * cardView = [HKLiveCardView viewFromXib];
            cardView.backgroundColor = [UIColor clearColor];
            cardView.frame = CGRectMake(0, i * 82, self.contentView.width - 10, 82);
            cardView.liveModel = _cardArray[i];
            cardView.tag = i;
            [self.cardContentView addSubview:cardView];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [cardView addGestureRecognizer:tap];
        }
    });
}

- (IBAction)moreBtnClick {
    if (self.moreBtnBlock) {
        self.moreBtnBlock();
    }
}
 
- (void)tapClick:(UITapGestureRecognizer *)tap{
    if (self.tapClickBlock) {
        self.tapClickBlock(self.cardArray[tap.view.tag]);
    }
}
@end
