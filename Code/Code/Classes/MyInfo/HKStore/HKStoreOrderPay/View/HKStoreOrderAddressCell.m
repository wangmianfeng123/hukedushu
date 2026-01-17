//
//  HKStoreOrderAddressCell.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStoreOrderAddressCell.h"

@interface HKStoreOrderAddressCell()

@property (nonatomic,strong) UILabel *nameLB;

@property (nonatomic,strong) UILabel *phoneLB;

@property (nonatomic,strong) UILabel *addressLB;
/// 更换地址
@property (nonatomic,strong) UIButton *addressSwitchBtn;

@end


@implementation HKStoreOrderAddressCell

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

    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.phoneLB];
    [self.contentView addSubview:self.addressLB];
    [self.contentView addSubview:self.addressSwitchBtn];
    
    [self testValue];
    
    [self layout];
}


- (void)layout {
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLB);
        make.left.equalTo(self.nameLB.mas_right).offset(20);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
    }];
    
    [self.addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.nameLB.mas_bottom).offset(15);
        make.right.lessThanOrEqualTo(self.addressSwitchBtn.mas_left).offset(-1);
    }];
    
    [self.addressSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLB);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
}



- (UILabel*)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:0];
    }
    return _nameLB;
}


- (UILabel*)phoneLB {
    if (!_phoneLB) {
        _phoneLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:0];
    }
    return _phoneLB;
}


- (UILabel*)addressLB {
    if (!_addressLB) {
        _addressLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
    }
    return _addressLB;
}



- (UIButton*)addressSwitchBtn {
    if (!_addressSwitchBtn) {
        _addressSwitchBtn = [UIButton buttonWithTitle:@"更换地址" titleColor:COLOR_27323F titleFont:@"14" imageName:nil];
        [_addressSwitchBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        [_addressSwitchBtn addTarget:self action:@selector(addressSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addressSwitchBtn setHKEnlargeEdge:20];
    }
    return _addressSwitchBtn;
}


- (void)addressSwitchBtnClick:(UIButton*)btn {
    
    if (self.changeAddressBlock) {
        self.changeAddressBlock(nil, btn);
    }
}




- (void)testValue {
    self.nameLB.text = @"泡芙胖胖";
    self.phoneLB.text = @"12345637899";
    self.addressLB.text = @"上海市浦东新区泡芙胖胖的家";
}


@end
