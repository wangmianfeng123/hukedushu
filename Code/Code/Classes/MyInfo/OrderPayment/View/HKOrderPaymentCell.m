//
//  HKOrderPaymentCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKOrderPaymentCell.h"
#import "HKPgcCategoryModel.h"
#import "HKAlbumShadowImageView.h"




@interface HKOrderPaymentCell()

@property (weak, nonatomic) IBOutlet UIButton *studyNowBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderNOLB;

@property (weak, nonatomic) IBOutlet UIImageView *orderAvatorIV;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLB;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatorIV;
@property (weak, nonatomic) IBOutlet UILabel *usernameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *valideLB;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLB;

@end

@implementation HKOrderPaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userAvatorIV.clipsToBounds = YES;
    self.userAvatorIV.layer.cornerRadius = PADDING_25/2;
    
    self.studyNowBtn.clipsToBounds = YES;
    self.studyNowBtn.layer.cornerRadius = 0.5;
    self.studyNowBtn.layer.borderColor = HKColorFromHex(0xff6600, 1.0).CGColor;
    self.studyNowBtn.layer.borderWidth = 0.5;
    
    self.realPriceLB.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    
    //self.orderAvatorIV.clipsToBounds = YES;
    self.orderAvatorIV.contentMode = UIViewContentModeScaleAspectFill;
    self.orderAvatorIV.layer.cornerRadius = 5;
    
    [self.contentView insertSubview:self.bgImageView belowSubview:self.orderAvatorIV];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.top.equalTo(_orderAvatorIV).offset(-6);
        //make.right.bottom.equalTo(_orderAvatorIV);
        
        make.top.equalTo(_orderAvatorIV).offset(-9);
        make.right.left.bottom.equalTo(_orderAvatorIV);
    }];
}




- (HKAlbumShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKAlbumShadowImageView alloc]init];
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}




- (void)setModel:(HKPgcCourseModel *)model {
    _model = model;
    self.orderNOLB.text = [NSString stringWithFormat:@"订单编号：%@",model.order_number];
    [self.orderAvatorIV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];;
    
    self.orderTitleLB.text = model.title;
    [self.userAvatorIV sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:imageName(HK_Placeholder)];
    self.usernameLB.text = model.name;
    self.priceLB.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.valideLB.text = @"课程有效期：永久有效";
    self.realPriceLB.text = [NSString stringWithFormat:@"实付：¥%@",model.now_price];
}



// 分割线
- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 20;
    
    [super setFrame:frame];
}


- (IBAction)studyNowBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(immediateStudy:)]) {
        [self.delegate immediateStudy:self.model];
    }
    
}

@end
