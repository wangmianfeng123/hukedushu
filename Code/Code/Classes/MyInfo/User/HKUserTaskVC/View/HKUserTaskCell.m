//
//  HKUserTaskCell.m
//  Code
//
//  Created by Ivan li on 2018/7/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserTaskCell.h"
#import "HKTaskModel.h"

@implementation HKUserTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKUserTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKUserTaskCell"];
    if (!cell) {
        cell = [[HKUserTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKUserTaskCell"];
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
    
    [self.contentView addSubview:self.picImageView];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.scanCountLB];
    [self.contentView addSubview:self.praiseCountLB];
    [self.contentView addSubview:self.commentCountLB];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.picImageView.mas_left).offset(-2);
    }];
    
    [self.scanCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(PADDING_20);
    }];
    
    [self.praiseCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanCountLB);
        make.left.equalTo(self.scanCountLB.mas_right).offset(PADDING_10);
    }];
    
    [self.commentCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanCountLB);
        make.left.equalTo(self.praiseCountLB.mas_right).offset(PADDING_10);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.top.equalTo(self.contentView).offset(PADDING_15);
        make.bottom.equalTo(self.contentView).offset(-PADDING_15);
        make.width.equalTo(@150);
    }];
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLB;
}


- (UIImageView*)picImageView {
    if (!_picImageView) {
        _picImageView = [UIImageView new];
        _picImageView.clipsToBounds = YES;
        _picImageView.layer.cornerRadius = PADDING_5;
    }
    return  _picImageView;
}


- (UILabel*)scanCountLB {
    if (!_scanCountLB) {
        _scanCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _scanCountLB;
}


- (UILabel*)praiseCountLB {
    if (!_praiseCountLB) {
        _praiseCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _praiseCountLB;
}

- (UILabel*)commentCountLB {
    if (!_commentCountLB) {
        _commentCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _commentCountLB;
}



- (void)setModel:(HKTaskModel *)model {
    _model = model;
    _titleLB.text = model.title;
    _scanCountLB.text = [NSString stringWithFormat:@"%@人看过",model.study_num];
    _praiseCountLB.text = [NSString stringWithFormat:@"%ld赞",model.thumbs];
    _commentCountLB.text = [NSString stringWithFormat:@"%@评论",model.comment_total];
    [self.picImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:imageName(HK_Placeholder)];
}



@end








