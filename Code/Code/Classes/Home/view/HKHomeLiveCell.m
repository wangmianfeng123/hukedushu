#import "HKHomeLiveCell.h"
#import "HKLiveListModel.h"
#import "HKLiveCoverIV.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"


@interface HKHomeLiveCell()

@property (nonatomic, assign) HKLiveType liveType;
///// 免费标签
@property (nonatomic, strong)UILabel *freeLB;
///// 原来价格
//@property (nonatomic, strong)UILabel *priceLB;
///// 折扣价格
//@property (nonatomic, strong)UILabel *discountPriceLB;
///// 团购
//@property (nonatomic, strong)HKCustomMarginLabel *groupLB;

@end



@implementation HKHomeLiveCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.freeLB];
    
//    [self.contentView addSubview:self.priceLB];
//    [self.contentView addSubview:self.discountPriceLB];
//    [self.contentView addSubview:self.groupLB];
    
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.nameLabel.textColor = COLOR_7B8196_A8ABBE;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {

    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(211);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV.mas_bottom).offset(10);
        make.left.right.equalTo(self.coverIV);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(PADDING_5);
        make.right.lessThanOrEqualTo(self.freeLB.mas_left).offset(-2);
        make.centerY.equalTo(self.iconIV);
    }];
    
    [self.freeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.iconIV);
    }];
    
//    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.iconIV);
//        make.right.equalTo(self.contentView).offset(-PADDING_15);
//    }];
//
//    [self.groupLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.iconIV);
//        make.right.equalTo(self.priceLB.mas_left).offset(-PADDING_10);
//     }];
//
//    [self.discountPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.iconIV);
//        make.right.equalTo(self.groupLB.mas_left).offset(-PADDING_10);
//        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).offset(2);
//    }];
}



- (HKLiveCoverIV*)coverIV {
    if (!_coverIV) {
        _coverIV = [[HKLiveCoverIV alloc]init];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5.0;
    }
    return _coverIV;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]init];
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 10.0;
    }
    return _iconIV;
}



- (void)iconIVClick:(id)sender {
    self.avatarClickBlock ?self.avatarClickBlock(self.model) :nil;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"17" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

    
    
- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        //抗压缩的优先级
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}


- (UILabel*)freeLB {
    if (!_freeLB) {
        _freeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF3221 titleFont:@"16" titleAligment:NSTextAlignmentRight];
        _freeLB.hidden = YES;
    }
    return _freeLB;
}

    


- (void)setModel:(HKLiveListModel *)model {
    
    _model = model;
    _titleLabel.text = model.name;
    _nameLabel.text = model.teacher_name;
    
    [self.iconIV sd_setImageWithURL:HKURL(model.teacher_avator) placeholderImage:imageName(HK_Placeholder)];
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.surface_url]) placeholderImage:imageName(HK_Placeholder)];
    
    [self liveType:model];
    self.coverIV.liveType = self.liveType;
    
    /// 感兴趣人数
    self.coverIV.status = model.view;
    [self.coverIV setHiddenText:NO];
    self.coverIV.serLB.text = model.start_live_at_str;
    self.coverIV.serLB.hidden = isEmpty(model.start_live_at_str);
    self.coverIV.serLB.font = HK_FONT_SYSTEM(14);
    [self.coverIV setTextFont:HK_FONT_SYSTEM_BOLD(14)];
    
    if (isEmpty(model.price_desc)) {
        self.freeLB.text = nil;
        self.freeLB.hidden = YES;
    }else{
        self.freeLB.text = model.price_desc;;
        self.freeLB.hidden = NO;
    }
}



/** 直播状态 */
- (void)liveType:(HKLiveListModel *)model {
    //当前直播状态0:未开始，1:开始直播,2:直播结束
    switch (model.live_status) {
        case 0:
        {
            if (model.is_in_a_hour) {
                self.liveType = HKLiveTypeWaiting;
            }else{
                self.liveType = HKLiveTypeEnrolment;
            }
        }
            break;
        case 1:
            self.liveType = HKLiveTypePlaying;
            break;
        case 2:
            self.liveType = HKLiveTypePlayEnd;
            break;
    }
}


@end



