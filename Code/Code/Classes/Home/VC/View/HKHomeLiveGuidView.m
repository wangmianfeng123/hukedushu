//
//  HKHomeLiveGuidView.m
//  Code
//
//  Created by yxma on 2020/11/13.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeLiveGuidView.h"
#import "HKLiveRemindModel.h"
#import "UIView+HKLayer.h"

@interface HKHomeLiveGuidView ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *boderView;
@property (nonatomic , strong) UIVisualEffectView * effe;

@end

@implementation HKHomeLiveGuidView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    self.effe = [[UIVisualEffectView alloc] initWithEffect:blur];
//    self.effe.layer.cornerRadius = 12;
//    self.effe.layer.masksToBounds = YES;
//    [self.bgView addSubview:self.effe];
    
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF6"];
    [self.signLabel addCornerRadius:7.5];
    [self.bgView addCornerRadius:12];
    //[self.bgView addShadowWithColor:[UIColor blackColor] alpha:0.5 radius:5 offset:CGSizeMake(0, 0)];
    [self.leftImgV addCornerRadius:17.5 addBoderWithColor:[UIColor redColor]];
    [self.boderView addCornerRadius:17.5 addBoderWithColor:[UIColor colorWithHexString:@"#FF4E4E"] BoderWithWidth:1];
    _isAnitaiton = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self insertSubview:self.effe atIndex:0];
//    self.effe.frame = self.bgView.bounds;
    //self.effe.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height - 12);
    
    [self zoomView];
}

-(void)setModel:(HKLiveRemindModel *)model{
    _model = model;
    [self.leftImgV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@"plv_img_default_avatar"]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = [NSString stringWithFormat:@"%@老师直播课，戳这里进入 >",model.teacherName];
}


- (void)zoomView {    
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.boderView.transform = CGAffineTransformMakeScale(1.35, 1.35); // 边框放大
        self.boderView.alpha = 0.01; // 透明度渐变
    } completion:^(BOOL finished) {
        // 恢复默认
        self.boderView.transform = CGAffineTransformMakeScale(1, 1);
        self.boderView.alpha = 1;
        
        if (self.isAnitaiton) {
            // 缩放动画
            [self zoomView];
        }
    }];
}
@end
