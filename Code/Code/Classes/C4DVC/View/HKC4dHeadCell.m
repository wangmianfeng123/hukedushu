//
//  HKC4dHeadCell.m
//  Code
//
//  Created by Ivan li on 2017/11/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKC4dHeadCell.h"
#import "VideoModel.h"

@interface HKC4dHeadCell()

@property(nonatomic,strong)UIImageView *bgImageView;//背景

@property(nonatomic,strong)UIImageView *tagImageView;

@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *courseNumLabel;

@property(nonatomic,strong)UILabel *lineLabel;

@property(nonatomic,strong)UILabel *exerciseNumLabel;

@end


@implementation HKC4dHeadCell


+ (instancetype)initCellWithTableView:(UITableView *)tableview{
    
    static  NSString  *identif = @"HKC4dHeadCell";
    HKC4dHeadCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[HKC4dHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = COLOR_F6F6F6;
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.tagImageView];
    [self.bgImageView addSubview:self.arrowImageView];
    [self.bgImageView addSubview:self.titleLabel];
    
    [self.bgImageView addSubview:self.courseNumLabel];
    [self.bgImageView addSubview:self.lineLabel];
    [self.bgImageView addSubview:self.exerciseNumLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    WeakSelf;
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PADDING_10, 13, PADDING_10, 13));
    }];
    
    [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgImageView.mas_left).offset(PADDING_15);
        make.centerY.equalTo(weakSelf.bgImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_30*2));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_top).offset(PADDING_30);
        make.left.equalTo(weakSelf.tagImageView.mas_right).offset(PADDING_20);
    }];
    
    [_courseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_15);
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.courseNumLabel.mas_right).offset(PADDING_10);
        make.centerY.equalTo(weakSelf.courseNumLabel);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(12);
    }];
    
    [_exerciseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineLabel.mas_right).offset(PADDING_10);
        make.top.height.equalTo(weakSelf.courseNumLabel);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.bgImageView.mas_right).offset(-PADDING_15);
    }];
}

- (UIImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = PADDING_5;
        _bgImageView.backgroundColor = [UIColor colorWithHexString:@"#b2b4da"];
    }
    return _bgImageView;
}


- (UIImageView*)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc]init];
        _tagImageView.image = imageName(@"c4d_icon");
    }
    return _tagImageView;
}



- (UIImageView*)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = imageName(@"arrow_white");
    }
    return _arrowImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"新手入门" titleColor:COLOR_ffffff titleFont:IS_IPHONE6PLUS ? @"16":@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel*)courseNumLabel {
    if (!_courseNumLabel) {
        _courseNumLabel  = [UILabel labelWithTitle:CGRectZero title:@"25" titleColor:COLOR_ffffff titleFont:IS_IPHONE6PLUS ? @"13":@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _courseNumLabel;
}


- (UILabel*)exerciseNumLabel {
    if (!_exerciseNumLabel) {
        _exerciseNumLabel  = [UILabel labelWithTitle:CGRectZero title:@"30" titleColor:COLOR_ffffff titleFont:IS_IPHONE6PLUS ? @"13":@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _exerciseNumLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = COLOR_ffffff;
    }
    return _lineLabel;
}



- (void)setModel:(C4DHeadModel *)model {
    _model = model;
    _courseNumLabel.text =[NSString stringWithFormat:@"%@课",model.master_video_total];
    _exerciseNumLabel.text = [NSString stringWithFormat:@"%@练习",model.slave_video_total];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
