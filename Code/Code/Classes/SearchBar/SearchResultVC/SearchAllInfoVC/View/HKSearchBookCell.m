//
//  HKSearchBookCell.m
//  Code
//
//  Created by Ivan li on 2021/5/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKSearchBookCell.h"
#import "HKBookCoverImageView.h"
#import "HKCustomMarginLabel.h"
#import "HKBookModel.h"

@interface HKSearchBookCell()

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  HKCustomMarginLabel *descrLB;

@property (strong, nonatomic)  UILabel *timeLB;

@property (strong, nonatomic)  UILabel *learnCountLB;


@end

@implementation HKSearchBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createUI];
}


-(instancetype)init{
    if ([super init]) {
        [self createUI];
    }
    return self;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//        [self createUI];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLB];
    
    [self.contentView addSubview:self.descrLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.learnCountLB];
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 105));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.coverIV);
    }];
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(3);
    }];
    
    [self.learnCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverIV);
        make.left.equalTo(self.titleLB);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.learnCountLB);
        make.left.equalTo(self.learnCountLB.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
    }];
    
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.timeLB.textColor = COLOR_A8ABBE_7B8196;
    self.descrLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_A8ABBE];
    self.descrLB.backgroundColor = COLOR_F8F9FA_333D48;
}



- (HKBookCoverImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [HKBookCoverImageView new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFit;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightMedium);
        _titleLB.numberOfLines = 2;
    }
    return _titleLB;
}



- (UILabel*)learnCountLB {
    if (!_learnCountLB) {
        _learnCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _learnCountLB;
}



- (UILabel*)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _timeLB;
}


- (HKCustomMarginLabel*)descrLB {
    if (!_descrLB) {
        _descrLB  = [[HKCustomMarginLabel alloc] init];
        _descrLB.textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        _descrLB.textColor =  COLOR_7B8196;
        _descrLB.font = HK_FONT_SYSTEM(13);
        _descrLB.textAlignment = NSTextAlignmentLeft;
        _descrLB.backgroundColor = COLOR_F8F9FA;
        _descrLB.clipsToBounds = YES;
        _descrLB.layer.cornerRadius = 5;
        _descrLB.hidden = YES;
        _descrLB.numberOfLines = 2;
    }
    return _descrLB;
}




- (void)setModel:(HKBookModel *)model {
    
    _model = model;
    
    self.coverIV.model = model;
    //self.coverIV.shadowIV.hidden = YES;
    
    self.titleLB.text = model.title;
    
    self.timeLB.text = [NSString stringWithFormat:@"时长 %@", model.time];
    
    self.learnCountLB.text = [NSString stringWithFormat:@"%@人已学", model.listen_number];
    
    self.descrLB.text = model.short_introduce;
    
    self.descrLB.hidden = isEmpty(model.short_introduce);
}



@end
