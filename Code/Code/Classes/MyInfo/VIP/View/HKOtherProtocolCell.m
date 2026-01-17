//
//  HKOtherProtocolCell.m
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKOtherProtocolCell.h"

@implementation HKOtherProtocolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = COLOR_FFFFFF_333D48;
    self.backgroundColor = COLOR_FFFFFF_333D48;
 
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.agreementBtn];
    [self.contentView addSubview:self.selectBtn];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
    
    CGFloat left = (SCREEN_WIDTH - self.selectBtn.width - self.agreementBtn.width -5)/2;
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(5);
        make.centerY.equalTo(self.selectBtn);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(left);
    }];
}


- (UIView*)grayView {
    if (!_grayView) {
        _grayView = [UIView new];
        _grayView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _grayView;
}

- (UIButton*)agreementBtn {
    if (!_agreementBtn) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8AFB8 dark:COLOR_7B8196];
        _agreementBtn =  [UIButton buttonWithTitle:@"支付即同意 《VIP会员服务协议》" titleColor:textColor titleFont:@"11" imageName:nil];
        [_agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _agreementBtn.tag = 24;
        [_agreementBtn sizeToFit];
    }
    return _agreementBtn;
}


- (void)agreementBtnClick:(UIButton*)btn {
    if (self.agreementBtnClickBlock) {
        self.agreementBtnClickBlock();
    }
}


- (UIButton*)selectBtn {
    if (!_selectBtn) {
        _selectBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_round_normal_v2_10" darkImageName:@"ic_round_normal_v2_10_dark"];
        [_selectBtn setImage:normalImage forState:UIControlStateNormal];
        
        UIImage *selectImage = [UIImage hkdm_imageWithNameLight:@"ic_round_selected_v2_10" darkImageName:@"ic_round_selected_v2_10_dark"];
        [_selectBtn setImage:selectImage forState:UIControlStateSelected];
        [_selectBtn setEnlargeEdgeWithTop:20 right:5 bottom:30 left:30];
        [_selectBtn sizeToFit];
        // 默认选中
        _selectBtn.selected = YES;
        //_selectBtn.hidden = YES;
    }
    return _selectBtn;
}

- (void)selectBtnBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    //self.isSelectAgree = btn.selected;
    if (self.selectBtnClickBlock) {
        self.selectBtnClickBlock(btn.selected);
    }
}

@end
