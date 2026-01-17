

//
//  HKTaskPraiseCell.m
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskPraiseCell.h"
#import "HKTaskPraiseBtn.h"
#import "HKTaskModel.h"

@implementation HKTaskPraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKTaskPraiseCell";
    HKTaskPraiseCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKTaskPraiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.hkPraiseBtn];
    
    [self.hkPraiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(PADDING_30);
        make.bottom.equalTo(self.contentView).offset(-PADDING_20*2);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
}


- (HKTaskPraiseBtn*)hkPraiseBtn {
    if (!_hkPraiseBtn) {
        _hkPraiseBtn = [[HKTaskPraiseBtn alloc]init];
        [_hkPraiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hkPraiseBtn;
}


- (void)praiseBtnClick:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkTaskPraiseAction:cell:indexPath:)]) {
        [self.delegate hkTaskPraiseAction:self.model cell:self indexPath:self.indexPath];
    }
}


- (void)setModel:(HKTaskDetailModel *)model {
    _model = model;
    self.hkPraiseBtn.model = model;
}



@end
