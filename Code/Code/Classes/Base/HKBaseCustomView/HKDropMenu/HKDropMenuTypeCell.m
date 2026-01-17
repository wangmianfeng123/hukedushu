//
//  HKDropMenuTypeCell.m
//  Code
//
//  Created by Ivan li on 2020/12/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDropMenuTypeCell.h"
#import "UIView+HKLayer.h"
#import "HKDropMenuModel.h"


@interface HKDropMenuTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation HKDropMenuTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgView addCornerRadius:12.5];
}


- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    _dropMenuModel = dropMenuModel;
//    if (dropMenuModel.hiddenArrow) {
//        _iconView.hidden = YES;
//        _titleLabel.hidden = NO;
//        _titleLabel.text = dropMenuModel.title;
//        _titleLabel.textColor = _dropMenuModel.titleSeleted ? [UIColor colorWithHexString:@"#FF7820"]:COLOR_7B8196_A8ABBE;
//    }else{
        _iconView.hidden = NO;
//        _titleLabel.hidden = YES;
        _nameLabel.text = dropMenuModel.title;
        if (_dropMenuModel.titleSeleted) {
            _imgV.image = [UIImage imageNamed:dropMenuModel.menuHighlightedImageName];
        }else{
            _imgV.image = [UIImage imageNamed:dropMenuModel.menuImageName] ;
        }
        _nameLabel.textColor = _dropMenuModel.titleSeleted ? [UIColor colorWithHexString:@"#FF7820"]:COLOR_7B8196_A8ABBE;
//    }
    _bgView.backgroundColor = _dropMenuModel.titleSeleted ? [UIColor colorWithHexString:@"#FFF0E6"]:COLOR_F8F9FA_333D48;
}

-(void)setNeedAdjusted:(BOOL)needAdjusted{
    _needAdjusted = needAdjusted;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftMargin.constant = self.needAdjusted ? self.width - 60 : 0.01;
    
}


@end
