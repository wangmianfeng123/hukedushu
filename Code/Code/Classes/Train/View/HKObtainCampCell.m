//
//  HKObtainCampCell.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKObtainCampCell.h"
#import "UIView+HKLayer.h"
#import "HKNewDeviceTrainModel.h"
@interface HKObtainCampCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *obtainBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation HKObtainCampCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.leftImgView addCornerRadius:5];
    [self.obtainBtn addCornerRadius:11.5 addBoderWithColor:[UIColor colorWithHexString:@"#FF3221"]];
}

- (IBAction)obtainBtnClick {
    if (self.obtainClickBlock) {
        self.obtainClickBlock();
    }
}

-(void)setModel:(HKNewDeviceTrainModel *)model{
    _model = model;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img]]];
    self.titleLabel.text = model.name;
    self.timeLabel.text = [NSString stringWithFormat:@"开课时间：%@",model.start];
    
}
@end
