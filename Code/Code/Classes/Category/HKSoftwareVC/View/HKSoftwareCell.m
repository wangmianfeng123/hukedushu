//
//  HKSoftwareCell.m
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareCell.h"
#import "UIView+HKLayer.h"
#import "HKCustomMarginLabel.h"

@interface HKSoftwareCell()


@property(nonatomic,strong)UIImageView *iconImageView;
/** 软件标题 */
@property(nonatomic,strong)UILabel *titleLabel;
/** 更新状态 */
@property(nonatomic,strong)UILabel *updateLabel;
/** 详情介绍 */
@property(nonatomic,strong)UILabel *detailLabel;
/** 观看人数 */
@property(nonatomic,strong)UILabel *watchLabel;
/** 课程数 */
@property(nonatomic,strong)UILabel *courseLabel;
/** 练习数 */
@property(nonatomic,strong)UILabel *exciseLabel;
/** 竖线 */
@property(nonatomic,strong)UILabel *lineLabel;
/** 数字排序标签 */
@property(nonatomic,strong)UILabel *indexLabel;

@property(nonatomic,strong)UILabel *bottomLineLabel;
/** 课程证书 */
@property(nonatomic,strong)HKCustomMarginLabel *cerLabel;

@end



@implementation HKSoftwareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKSoftwareCell";
    HKSoftwareCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKSoftwareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
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
    [self.contentView addSubview:self.indexLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];

    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.cerLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView addSubview:self.watchLabel];
    [self.contentView addSubview:self.exciseLabel];
    [self.contentView addSubview:self.lineLabel];
    [self.contentView addSubview:self.updateLabel];
    [self.contentView addSubview:self.bottomLineLabel];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.detailLabel.textColor = COLOR_A8ABBE_7B8196;
    
    self.courseLabel.textColor = COLOR_A8ABBE_7B8196;
    self.watchLabel.textColor = COLOR_A8ABBE_7B8196;
    self.exciseLabel.textColor = COLOR_A8ABBE_7B8196;

    self.bottomLineLabel.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
        
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(52/2);
        make.top.equalTo(self.contentView).offset(65/2);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(25/2);
        make.top.equalTo(_iconImageView);
    }];
    
    
    [_updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(PADDING_5);
        make.centerY.equalTo(_titleLabel);
        make.width.mas_equalTo(85/2);
        make.height.mas_equalTo(15);
    }];

    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(2);
    }];
    
    [_cerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_detailLabel.mas_bottom).offset(PADDING_5);
        //make.width.equalTo(@65);
        make.height.equalTo(@15);
    }];
    
    [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cerLabel.mas_right).offset(5);
        make.top.equalTo(_detailLabel.mas_bottom).offset(PADDING_5);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 12));
        make.centerY.equalTo(_watchLabel);
        make.left.equalTo(_watchLabel.mas_right).offset(PADDING_5);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_watchLabel);
        make.left.equalTo(self.lineLabel.mas_right).offset(PADDING_5);
    }];
    
    [_exciseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_watchLabel);
        make.left.equalTo(self.courseLabel.mas_right).offset(13);
    }];
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(33/2);
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (UILabel*)updateLabel {
    if (!_updateLabel) {
        _updateLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                    titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _updateLabel.backgroundColor = COLOR_F3F3F6;
        _updateLabel.clipsToBounds = YES;
        _updateLabel.layer.cornerRadius = 5;
        _updateLabel.hidden = YES;
    }
    return _updateLabel;
}


- (UILabel*)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        [_detailLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _detailLabel;
}


- (UILabel*)watchLabel {
    if (!_watchLabel) {
        _watchLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                      titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _watchLabel;
}

- (UILabel*)courseLabel {
    if (!_courseLabel) {
        _courseLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _courseLabel;
}

- (UILabel*)exciseLabel {
    if (!_exciseLabel) {
        _exciseLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _exciseLabel;
}

- (HKCustomMarginLabel*)cerLabel {
    if (!_cerLabel) {
        _cerLabel  = [[HKCustomMarginLabel alloc] init];
        _cerLabel.textColor = [UIColor colorWithHexString:@"#A2A2BE"];
        _cerLabel.font = [UIFont systemFontOfSize:11];
        _cerLabel.textAlignment = NSTextAlignmentCenter;
        _cerLabel.backgroundColor = [UIColor colorWithHexString:@"#EFEFF6"];
        _cerLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [_cerLabel addCornerRadius:7.5];
    }
    return _cerLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = COLOR_CFCFD9;
    }
    return _lineLabel;
}

- (UILabel*)indexLabel {
    if (!_indexLabel) {
        _indexLabel  = [UILabel new];
        _indexLabel.textColor = COLOR_7B8196;
        _indexLabel.font = HK_FONT_SYSTEM(17);
    }
    return _indexLabel;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA;
    }
    return _bottomLineLabel;
}




- (void)setModel:(VideoModel *)model type:(NSInteger)type {
    
    _model = model;
    self.type = type;
    _titleLabel.text = model.name;//model.abbr;
    _detailLabel.text = model.simple_introduce;
    
    
    _watchLabel.text = [NSString stringWithFormat:@"%@人已学", model.study_num];
    _courseLabel.text = [NSString stringWithFormat:@"%@课", model.master_video_total];
    _exciseLabel.text = [NSString stringWithFormat:@"%@练习", model.slave_video_total];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    
    ///** is_end：1-已完结 0-更新中*/
    if ([model.is_end isEqualToString:@"1"]) {
        _updateLabel.text = @"已完结";
        _updateLabel.textColor = COLOR_A8ABBE_27323F;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_7B8196];
        _updateLabel.backgroundColor = bgColor;
    }else{
        _updateLabel.text = @"更新中";
        _updateLabel.textColor = [UIColor whiteColor];
        _updateLabel.backgroundColor = COLOR_FFD710;
    }
    
    if (model.app_cert_show) {
        if (model.is_completed) {
            _cerLabel.text = [NSString stringWithFormat:@"已经获得证书"];
        }else{
            _cerLabel.text = [NSString stringWithFormat:@"课程证书"];
        }
    }else{
        _cerLabel.text = @"";
    }
}




@end


