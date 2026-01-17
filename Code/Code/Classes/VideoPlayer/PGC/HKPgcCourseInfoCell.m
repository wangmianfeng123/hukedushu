


//
//  HKPgcTeacherInfoCell.m
//  Code
//
//  Created by Ivan li on 2017/12/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPgcCourseInfoCell.h"
#import <YYText/YYText.h>
#import "DetailModel.h"
#import "HKLineLabel.h"

@interface HKPgcCourseInfoCell()

@property(nonatomic,strong)UILabel *topLineLabel;
/** 黑色标签 */
@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UILabel *courseLabel;

@property(nonatomic,strong)UILabel *courseTitleLabel;

@property(nonatomic,strong)UILabel *timeLabel;
/** 时间 购买人数之间的 灰线*/
@property(nonatomic,strong)UILabel *timeLineLabel;

@property(nonatomic,strong)UILabel *buyNumLabel;

@property(nonatomic,strong)UILabel *grayLineLabel;

@property(nonatomic,strong)UILabel *priceLabel;
/** 价格 下面的 描述 */
@property(nonatomic,strong)UILabel *priceDescLabel;
/** 详细描述 */
//@property(nonatomic,strong)UILabel *courseDetailInfoLabel;
/** 底部 灰线*/
@property(nonatomic,strong)UILabel *bottomLineLabel;

/** 折扣标签 */
@property(nonatomic,strong)UIImageView *discountImageView;

/** 原价 */
@property(nonatomic,strong)HKLineLabel *oldPriceLabel;

@end

@implementation HKPgcCourseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView {
    
    HKPgcCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKPgcCourseInfoCell"];
    if (!cell) {
        cell = [[HKPgcCourseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKPgcCourseInfoCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createUI {
    
    NSArray *arr = @[self.topLineLabel,self.tagLabel,self.grayLineLabel,self.courseLabel,self.courseTitleLabel,
                     self.timeLabel,self.timeLineLabel,self.buyNumLabel,self.priceLabel,
                     self.priceDescLabel,self.bottomLineLabel,self.discountImageView,self.oldPriceLabel];
    for (id temp in arr) {
        [self.contentView addSubview:temp];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [_topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, PADDING_15));
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_courseLabel);
        make.left.equalTo(self.contentView);
        make.width.mas_equalTo(2);
    }];
    
    [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(PADDING_20+PADDING_15);
        make.left.equalTo(self.contentView.mas_left).offset(13);
    }];
    
    [_courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseLabel.mas_bottom).offset(PADDING_20);
        make.left.equalTo(_courseLabel);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseTitleLabel.mas_bottom).offset(PADDING_15);
        make.left.equalTo(_courseLabel);
    }];
    
    [_timeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_timeLabel);
        make.left.equalTo(_timeLabel.mas_right).offset(PADDING_10);
        make.width.mas_equalTo(0.5);
    }];
    
    [_buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_timeLabel);
        make.left.equalTo(_timeLineLabel.mas_right).offset(PADDING_10);
    }];
    
    [_grayLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLineLabel.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.height.mas_equalTo(0.5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_grayLineLabel.mas_bottom).offset(PADDING_20);
        make.left.equalTo(_grayLineLabel);
    }];
    
    [_discountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(PADDING_10);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.priceLabel);
        make.left.equalTo(self.discountImageView.mas_right).offset(PADDING_10);
    }];
    
    [_priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(PADDING_15);
        make.left.equalTo(_priceLabel);
    }];
    
    
    
    [_bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.height.mas_equalTo(0.5);
    }];
    
//    [_courseDetailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_priceDescLabel.mas_bottom).offset(PADDING_30);
//        make.left.equalTo(self.contentView.mas_left).offset(13);
//        make.right.equalTo(self.contentView.mas_right).offset(-13);
//    }];
}


- (UILabel*)topLineLabel {
    if (!_topLineLabel) {
        _topLineLabel= [UILabel new];
        _topLineLabel.backgroundColor = COLOR_F6F6F6;
    }
    return  _topLineLabel;
}



- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel= [UILabel new];
        _tagLabel.backgroundColor = COLOR_333333;
    }
    return  _tagLabel;
}


- (UILabel*)courseLabel {
    if (!_courseLabel) {
        _courseLabel= [UILabel labelWithTitle:CGRectZero title:@"课程介绍" titleColor:COLOR_333333
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_courseLabel setFont:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?16:15)];
    }
    return  _courseLabel;
}


- (UILabel*)courseTitleLabel {
    if (!_courseTitleLabel) {
        _courseTitleLabel= [UILabel labelWithTitle:CGRectZero title:@"(课程标题)" titleColor:COLOR_333333
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_courseTitleLabel setFont:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?16:15)];
    }
    return  _courseTitleLabel;
}


- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel= [UILabel labelWithTitle:CGRectZero title:@"16小时" titleColor:COLOR_999999
                                         titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_timeLabel setFont:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?13:12)];
    }
    return  _timeLabel;
}

- (UILabel*)timeLineLabel {
    if (!_timeLineLabel) {
        _timeLineLabel= [UILabel new];
        _timeLineLabel.backgroundColor = COLOR_999999;
    }
    return _timeLineLabel;
}



- (UILabel*)buyNumLabel {
    if (!_buyNumLabel) {
        _buyNumLabel= [UILabel labelWithTitle:CGRectZero title:@"16小时" titleColor:COLOR_999999
                                  titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_buyNumLabel setFont:HK_FONT_SYSTEM(IS_IPHONE6PLUS ?13:12)];
    }
    return  _buyNumLabel;
}


- (UILabel*)grayLineLabel {
    if (!_grayLineLabel) {
        _grayLineLabel= [UILabel new];
        _grayLineLabel.backgroundColor = COLOR_F6F6F6;
    }
    return  _grayLineLabel;
}

- (UILabel*)priceLabel {
    if (!_priceLabel) {
        _priceLabel= [UILabel labelWithTitle:CGRectZero title:@"16小时" titleColor:[UIColor colorWithHexString:@"#ff6600"]
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_priceLabel setFont:HK_FONT_SYSTEM(17)];
    }
    return  _priceLabel;
}

- (UILabel*)priceDescLabel {
    if (!_priceDescLabel) {
        _priceDescLabel= [UILabel labelWithTitle:CGRectZero title:@"付款后永久有限" titleColor:COLOR_999999
                                   titleFont:nil titleAligment:NSTextAlignmentLeft];
        [_priceDescLabel setFont:HK_FONT_SYSTEM(IS_IPHONE6PLUS ?13:12)];
    }
    return  _priceDescLabel;
}


- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel= [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F6F6F6;
    }
    return  _bottomLineLabel;
}


- (UIImageView*)discountImageView {
    if (!_discountImageView) {
        _discountImageView = [[UIImageView alloc]init];
        _discountImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_discountImageView.hidden = YES;
    }
    return _discountImageView;
}


- (HKLineLabel*)oldPriceLabel {
    
    if (!_oldPriceLabel) {
        _oldPriceLabel  = [HKLineLabel new];
        _oldPriceLabel.textColor = COLOR_999999;
        _oldPriceLabel.strikeThroughEnabled = YES;
        _oldPriceLabel.strikeThroughColor = COLOR_999999;
        //[HKLineLabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _oldPriceLabel.font = HK_FONT_SYSTEM(12);
    }
    return _oldPriceLabel;
}




//- (UILabel*)courseDetailInfoLabel {
//    if (!_courseDetailInfoLabel) {
//        _courseDetailInfoLabel = [UILabel new];
//        _courseDetailInfoLabel.font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ?13:12);
//        _courseDetailInfoLabel.textColor = COLOR_333333;
//        _courseDetailInfoLabel.textAlignment = NSTextAlignmentLeft;
//        _courseDetailInfoLabel.numberOfLines = 0;
//    }
//    return _courseDetailInfoLabel;
//}

- (void)setCoursrInfo:(NSString *)coursrInfo {
    
    _coursrInfo = coursrInfo;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:coursrInfo];
    // 2. 为文本设置属性
    text.yy_font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ?13:12);
    text.yy_lineSpacing = 12;
//    _courseDetailInfoLabel.attributedText = text;
}

- (void)setModel:(DetailModel *)model {
    _model = model;
    HKCourseModel * coureseModel = model.course_data;
    _courseTitleLabel.text = coureseModel.cource_title; //PGC 标题
    _timeLabel.text = [NSString stringWithFormat:@"共%@",coureseModel.cource_duration]; // 视频时长
    _buyNumLabel.text = [NSString stringWithFormat:@"%@人购买",coureseModel.pay_people];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",coureseModel.now_price];
    
    if (!isEmpty(coureseModel.tag_1)) {
        _discountImageView.image = imageName(@"special_orange");
        _oldPriceLabel.text = coureseModel.price;
    }
}



- (CGSize)sizeThatFits:(CGSize)size {
    
    CGFloat totalHeight = 442/2;
    //totalHeight += [self.courseDetailInfoLabel sizeThatFits:CGSizeMake(size.width - 2*13, size.height)].height;
    return CGSizeMake(size.width, totalHeight);
}





@end
