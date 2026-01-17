//
//  HKStoreOrderGoodInfoCell.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStoreOrderGoodInfoCell.h"


@interface HKStoreOrderGoodInfoCell()

@property (nonatomic,strong) UILabel *titleLB;
///  封面
@property (nonatomic,strong) UIImageView *coverIV;

@property (nonatomic,strong) UILabel *priceLB;

@end




@implementation HKStoreOrderGoodInfoCell

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

    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.priceLB];
        
    [self testValue];
    [self makeConstraints];
}




- (void)makeConstraints {
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.coverIV);
    }];
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.bottom.equalTo(self.coverIV);
        make.right.equalTo(self.contentView).offset(-5);
    }];
}




- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
    }
    return _titleLB;
}


- (UILabel*)priceLB {
    if (!_priceLB) {
        _priceLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
    }
    return _priceLB;
}


- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
    }
    return _coverIV;
}


- (void)testValue {
    self.titleLB.text = @"泡芙胖胖";
    self.priceLB.text = @"500";
    [self.coverIV sd_setImageWithURL:HKURL(nil) placeholderImage:HK_PlaceholderImage];
}


@end
