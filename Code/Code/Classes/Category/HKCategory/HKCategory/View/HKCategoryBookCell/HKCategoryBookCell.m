//
//  HKCategoryBookCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/7/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKCategoryBookCell.h"
#import "UIView+Banner.h"

@interface HKCategoryBookCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;

@property (weak, nonatomic) IBOutlet UIButton *freeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *listenIV;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *authorLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UILabel *learnCountLB;

@property (weak, nonatomic) IBOutlet UIButton *recomBtn;

@property (strong, nonatomic)  UIImageView *shadowIV;

@end

@implementation HKCategoryBookCell

- (void)awakeFromNib {
    [super awakeFromNib];


    // 圆角
    self.freeBtn.clipsToBounds = YES;
    self.freeBtn.layer.cornerRadius = 5.0;
    self.freeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.freeBtn.layer.borderWidth = 1.0;

    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 5.0;

    // 主编推荐
    UIColor *color = [UIColor colorWithHexString:@"#FF6363"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ed6f65"];
    UIColor *color2 = [UIColor colorWithHexString:@"#f19742"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(50, 17) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self.recomBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
    // 圆角
    [self.recomBtn addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight]; // 切除了左上，右下


    [self.contentView insertSubview:self.shadowIV belowSubview:self.listenIV];
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.coverIV);
        make.height.mas_equalTo(32.0);
    }];
}


- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.image = imageName(@"hk_book_shadow_black");
    }
    return _shadowIV;
}


- (void)setModel:(HKBookModel *)model {

    _model = model;

    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];

    self.freeBtn.hidden = !model.is_free;

    self.titleLB.text = model.title;

    self.authorLB.text = model.author;

    self.timeLB.text = [NSString stringWithFormat:@"时长 %@", model.time];

    self.learnCountLB.text = [NSString stringWithFormat:@"%@人已学", model.listen_number];

    self.recomBtn.hidden = !model.is_recommend;

}

@end

