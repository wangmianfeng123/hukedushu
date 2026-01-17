


//
//  SeriseCourseCell.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriseCourseCell.h"
#import "SeriseCourseTagView.h"
#import "SeriseCourseModel.h"
#import "HKShadowImageView.h"
#import "HKCoverBaseIV.h"

@interface SeriseCourseCell ()

@property(nonatomic,strong)HKCoverBaseIV *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)SeriseCourseTagView *courseTagView;// 课时数

@property(nonatomic,strong)SeriseCourseTagView *watchTagView;//观看数量

@property(nonatomic,strong)UIView *lineView;//分割线
/** 图片阴影 */
@property(nonatomic,strong)HKShadowImageView *bgImageView;
/** 系列课 更新状态 */
@property(nonatomic,strong)UILabel *stateLabel;

@end





@implementation SeriseCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    SeriseCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeriseCourseCell"];
    if (!cell) {
        cell = [[SeriseCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeriseCourseCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];

    [self.contentView addSubview:self.watchTagView];
    [self.contentView addSubview:self.courseTagView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView insertSubview:self.bgImageView belowSubview:self.iconImageView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView).offset(-9);
        make.right.left.bottom.equalTo(_iconImageView);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(30);
        make.width.mas_equalTo(325*Ratio);
        make.height.mas_equalTo(168*Ratio);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.courseTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    [self.watchTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.courseTagView);
        make.left.equalTo(self.courseTagView.mas_right).offset(PADDING_15);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.courseTagView);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_13);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}



- (HKCoverBaseIV*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[HKCoverBaseIV alloc]init];
        _iconImageView.contentMode =UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
    }
    return _iconImageView;
}

- (HKShadowImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[HKShadowImageView alloc]init];
        _bgImageView.cornerRadius = 5;
        //_bgImageView.offSet = 5;
        _bgImageView.offSet = 4.5;
    }
    return _bgImageView;
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_333333];
        _titleLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 16:15);
    }
    return _titleLabel;
}



- (UILabel*)stateLabel {
    if (!_stateLabel) {
        _stateLabel  = [[UILabel alloc] init];
        [_stateLabel setTextColor:COLOR_333333];
        _stateLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 13:12);
    }
    return _stateLabel;
}

- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_F6F6F6;
    }
    return _lineView;
}


- (SeriseCourseTagView*)courseTagView {
    if (!_courseTagView) {
        _courseTagView = [[SeriseCourseTagView alloc]init];
    }
    return _courseTagView;
}


- (SeriseCourseTagView*)watchTagView {
    if (!_watchTagView) {
        _watchTagView = [[SeriseCourseTagView alloc]init];
    }
    return _watchTagView;
}




- (void)setModel:(SeriseCourseModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    
    _iconImageView.courseCount = model.total_course;
    _iconImageView.hasPictext = !model.has_pictext;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    
    NSString *lesson = [NSString stringWithFormat:@"%@节课",model.lesson_total];
    NSString *watch = [NSString stringWithFormat:@"%@人看过",model.watch_nums];
    [_courseTagView setImageWithName:nil text:lesson isHidden:YES];
    [_watchTagView setImageWithName:nil text:watch isHidden:YES];
    
    //update_status：0-已完结 1-更新中
    BOOL isEnd = [model.update_status isEqualToString:@"0"];
    _stateLabel.text = isEnd ?@"已完结" :@"更新中";;
}



@end



