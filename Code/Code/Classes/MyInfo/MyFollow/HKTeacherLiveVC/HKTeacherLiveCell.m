
//
//  HKTeacherLiveCell.m
//  Code
//
//  Created by Ivan li on 2019/9/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKTeacherLiveCell.h"
#import "HKTrainModel.h"


@interface HKTeacherLiveCell()
/** 报名人数 */
@property(nonatomic,strong)UILabel *signCountLB;
/** 标题 */
@property(nonatomic,strong)UILabel *titleLB;
/** 课程数量 */
@property(nonatomic,strong)UILabel *courseLB;
/** 封面 */
@property(nonatomic,strong)UIImageView *coverIV;

@end


@implementation HKTeacherLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.courseLB];
    [self.contentView addSubview:self.signCountLB];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(155, 95));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.left.equalTo(self.coverIV.mas_right).offset(13);
        make.right.lessThanOrEqualTo(self.contentView).offset(-1);
    }];
    
    [self.signCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(6);
        make.left.equalTo(self.titleLB);
        make.right.lessThanOrEqualTo(self.contentView).offset(-1);
    }];
    
    [self.courseLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signCountLB.mas_bottom).offset(3);
        make.left.equalTo(self.signCountLB);
        make.right.lessThanOrEqualTo(self.contentView).offset(-1);
    }];
}


- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:0];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        _titleLB.numberOfLines = 2;
    }
    return _titleLB;
}



- (UILabel*)signCountLB {
    if (!_signCountLB) {
        _signCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:0];
    }
    return _signCountLB;
}



- (UILabel*)courseLB {
    if (!_courseLB) {
        _courseLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:0];
    }
    return _courseLB;
}





- (void)setModel:(HKTrainModel *)model {
    _model = model;
    
    self.titleLB.text = [NSString stringWithFormat:@"%@", model.title];
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.cover]) placeholderImage:HK_PlaceholderImage];
    //234人已报名
    self.signCountLB.text = isEmpty(model.subscribe_num)?nil :[NSString stringWithFormat:@"%@人已报名",model.subscribe_num];
    //共4节
    self.courseLB.text = (model.lesson_num >0) ?[NSString stringWithFormat:@"共%ld节",model.lesson_num] :nil;
}



@end

