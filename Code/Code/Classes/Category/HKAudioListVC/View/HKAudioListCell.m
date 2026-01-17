
//
//  HKAudioListCell.m
//  Code
//
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAudioListCell.h"
#import "VideoModel.h"

@interface HKAudioListCell()

/** 大图 */
@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UIImageView *timeImageView;

@property(nonatomic,strong)UIImageView *countImageView;

@property(nonatomic,strong)UILabel *titleLabel;
/** 时长 */
@property(nonatomic,strong)UILabel *timeLabel;
/** 观看人数 */
@property(nonatomic,strong)UILabel *countLabel;

@property(nonatomic,strong)UILabel *bottomLineLabel;


@end


@implementation HKAudioListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKAudioListCell";
    HKAudioListCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKAudioListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor  = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.timeImageView];
        [self.contentView addSubview:self.countImageView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.bottomLineLabel];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(8);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(18);
    }];
    
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(12.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.timeImageView);
        make.left.equalTo(weakSelf.timeImageView.mas_right).offset(PADDING_5);
    }];
    
    [_countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.timeImageView);
        make.left.equalTo(weakSelf.timeLabel.mas_right).offset(PADDING_20);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.countImageView);
        make.left.equalTo(weakSelf.countImageView.mas_right).offset(PADDING_5);
    }];
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(33/2);
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}


- (UIImageView*)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]init];
        _timeImageView.image = imageName(@"bell_gray");
        _timeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _timeImageView;
}


- (UIImageView*)countImageView {
    if (!_countImageView) {
        _countImageView = [[UIImageView alloc]init];
        _countImageView.image = imageName(@"headset_gray");
        _countImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _countImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"我喜欢的歌曲" titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel  = [UILabel labelWithTitle:CGRectZero title:@"11222" titleColor:COLOR_A8ABBE_7B8196
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}


- (UILabel*)countLabel {
    if (!_countLabel) {
        _countLabel  = [UILabel labelWithTitle:CGRectZero title:@"3344" titleColor:COLOR_A8ABBE_7B8196
                                     titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _countLabel;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bottomLineLabel;
}




- (void)setModel:(VideoModel *)model {
    
    _model = model;
    
    _titleLabel.text = model.title;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.duration];
    
    _countLabel.text = model.play_num;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover_url]] placeholderImage:imageName(HK_Placeholder)];
}



@end
