//
//  VipExplainCell.m
//  Code
//
//  Created by Ivan li on 2017/9/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "VipExplainCell.h"
#import "HKVerticalButton.h"

@implementation VipExplainCell

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
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.vipInfoLabel];
    [self.contentView addSubview:self.lineLabel];
    
    [self.contentView addSubview:self.studyBtn];
    [self.contentView addSubview:self.downBtn];
    [self.contentView addSubview:self.textBtn];
    [self.contentView addSubview:self.idBtn];
    
    [self.contentView addSubview:self.courseBtn];
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.fileBtn];
    [self.contentView addSubview:self.customerBtn];
    
    WeakSelf;
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(PADDING_20);
        make.left.equalTo(weakSelf.contentView);
        //make.bottom.equalTo(weakSelf.contentView).offset(-PADDING_20);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(14);
    }];
    
    [_vipInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(weakSelf.tagLabel);
        make.left.equalTo(weakSelf.tagLabel.mas_right).offset(11);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.vipInfoLabel.mas_bottom).offset(PADDING_20);
        make.height.mas_equalTo(0.25);
        make.left.right.equalTo(weakSelf);
        //make.left.equalTo(weakSelf.contentView.mas_left);
        //make.right.equalTo(weakSelf.contentView.mas_right);
    }];
    
    
    /** @param axisType 布局方向 * @param fixedSpacing 两个item之间的间距(最左面的item和左边, 最右边item和右边都不是这个)
     * @param leadSpacing 第一个item到父视图边距 * @param tailSpacing 最后一个item到父视图边距*/
    [@[_studyBtn, _downBtn, _textBtn,_idBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:15 tailSpacing:15];
    
    [@[_studyBtn, _downBtn, _textBtn,_idBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(75);
        make.height.mas_equalTo(60);
    }];
    
    [@[_courseBtn, _commentBtn, _fileBtn, _customerBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:15 tailSpacing:15];
    
    [@[_courseBtn, _commentBtn, _fileBtn,_customerBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.studyBtn.mas_bottom).offset(PADDING_30);
        make.height.mas_equalTo(60);
    }];
}





- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                  titleColor:nil
                                   titleFont:nil titleAligment:NSTextAlignmentLeft];
        //_tagLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19:18];
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"#d4b27e"];
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}


- (UILabel*)vipInfoLabel {
    
    if (!_vipInfoLabel) {
        _vipInfoLabel  = [UILabel labelWithTitle:CGRectZero title:@"VIP特权"
                                      titleColor:[UIColor colorWithHexString:@"#333333"]
                                       titleFont:nil titleAligment:NSTextAlignmentLeft];
        _vipInfoLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        [_vipInfoLabel sizeToFit];
    }
    return _vipInfoLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    return _lineLabel;
}



- (UIButton*)studyBtn {
    if (!_studyBtn) {
        _studyBtn = [self coustomBtnWithTitle:@"无限下载" imageName:@"vip_study"];
    }
    return _studyBtn;
}

- (void)titleForBtn:(NSArray<NSString *> *)titleArray {
    if (titleArray) {
        NSString *title = [titleArray firstObject];
        [_studyBtn setTitle:title forState:UIControlStateNormal];;
    }
}

- (UIButton*)downBtn {
    if (!_downBtn) {
        _downBtn = [self coustomBtnWithTitle:@"教程下载" imageName:@"vip_down"];
    }
    return _downBtn;
}

- (UIButton*)textBtn {
    
    if (!_textBtn) {
        _textBtn = [self coustomBtnWithTitle:@"图文教程" imageName:@"vip_tech"];
    }
    return _textBtn;
}


- (UIButton*)idBtn {
    
    if (!_idBtn) {
        _idBtn = [self coustomBtnWithTitle:@"尊贵身份" imageName:@"vip_id"];
    }
    return _idBtn;
}


- (UIButton*)courseBtn {
    
    if (!_courseBtn) {
        _courseBtn = [self coustomBtnWithTitle:@"教程需求" imageName:@"vip_course"];
    }
    return _courseBtn;
}


- (UIButton*)fileBtn {
    
    if (!_fileBtn) {
        _fileBtn = [self coustomBtnWithTitle:@"源文件下载" imageName:@"vip_file"];
        //[_fileBtn setTitleEdgeInsets:UIEdgeInsetsMake(70, -55, 0, -10)];
        [_fileBtn setTitleEdgeInsets:IS_IPHONE5S ?UIEdgeInsetsMake(70, -55, 0, -10) : UIEdgeInsetsMake(70, -55, 0, -5)];
    }
    return _fileBtn;
}


- (UIButton*)commentBtn {
    
    if (!_commentBtn) {
        _commentBtn = [self coustomBtnWithTitle:@"优先点评" imageName:@"vip_comment"];
    }
    return _commentBtn;
}

- (UIButton*)customerBtn {
    
    if (!_customerBtn) {
        _customerBtn = [self coustomBtnWithTitle:@"客服优先" imageName:@"vip_customer"];
    }
    return _customerBtn;
}



- (UIButton*)coustomBtnWithTitle:(NSString *)title imageName:(NSString*)imageName {
    
    UIButton *btn = [HKVerticalButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor blueColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(70, -45, 0, 0)];
//    if (IS_IPHONE5S) {
//
//    }else{
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [btn setImage:imageName(imageName) forState:UIControlStateNormal];
    [btn setImage:imageName(imageName) forState:UIControlStateHighlighted];
    return btn;
}












@end

