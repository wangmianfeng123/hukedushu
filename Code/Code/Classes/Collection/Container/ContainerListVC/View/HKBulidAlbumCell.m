


//
//  HKBulidAlbumCell.m
//  Code
//
//  Created by Ivan li on 2018/7/30.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBulidAlbumCell.h"
#import "HKContainerModel.h"
#import "HKContainerModel.h"
#import "HKAlbumShadowImageView.h"



@interface HKBulidAlbumCell()

/** 封面 */
@property(nonatomic,strong)UIImageView *coverImageView;
/** 专辑标题 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *bottomLineLabel;

@end



@implementation HKBulidAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKBulidAlbumCell";
    HKBulidAlbumCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKBulidAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor  = COLOR_FFFFFF_3D4752;
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bottomLineLabel];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(11);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        //make.size.mas_equalTo(CGSizeMake(60, 36));
        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(30*3, 18*3) :CGSizeMake(30*2, 18*2));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverImageView);
        make.left.equalTo(self.coverImageView.mas_right).offset(11);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-1);
    }];
    
//    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(33/2);
//        make.bottom.right.equalTo(self.contentView);
//        make.height.equalTo(@1);
//    }];
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 5;
    }
    return _coverImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightMedium);
    }
    return _titleLabel;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bottomLineLabel;
}


- (void)setModel:(HKAlbumModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    [_coverImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:imageName(HK_Placeholder)];
}

@end







