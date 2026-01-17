//
//  HKStoreOrderPayCell.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStoreOrderPayCell.h"
#import "HKPaymentView.h"

@interface HKStoreOrderPayCell()

@property (nonatomic,strong) UILabel *paymentLB;

@property (nonatomic,strong) HKPaymentView *paymentView;

@end


@implementation HKStoreOrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.paymentLB];
    [self.contentView addSubview:self.paymentView];
    
    [self.paymentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-1);
    }];
    
    [self.paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paymentLB.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(150);
    }];
}


- (UILabel*)paymentLB {
    if (!_paymentLB) {
        _paymentLB = [UILabel labelWithTitle:CGRectZero title:@"支付方式" titleColor:COLOR_27323F titleFont:@"16" titleAligment:0];
    }
    return _paymentLB;
}


- (HKPaymentView*)paymentView {
    if (!_paymentView) {
        _paymentView = [HKPaymentView new];
    }
    return _paymentView;
}



@end
