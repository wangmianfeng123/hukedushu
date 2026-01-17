//
//  HKBookTabMainOfficialBookCell.m
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTabMainOfficialBookCell.h"
#import "HKBookCoverImageView.h"
#import "HKCustomMarginLabel.h"
#import "HKBookModel.h"
#import "UIImage+Helper.h"


@interface HKBookTabMainOfficialBookCell()
/// 主题
@property (strong, nonatomic)  UILabel *themeLB;
/// 标题
@property (strong, nonatomic)  UILabel *titleLB;
/// 描述
@property (strong, nonatomic)  HKCustomMarginLabel *descrLB;
/// 学习人数
@property (strong, nonatomic)  UILabel *learnCountLB;
/// 背景
@property (strong, nonatomic)  UIImageView *bgImageView;
/// 阴影背景
@property (strong, nonatomic)  UIImageView *shadowIV;
/// 播放
@property (strong, nonatomic)  UIButton *playBtn;

@end



@implementation HKBookTabMainOfficialBookCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.shadowIV];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.coverIV];
    [self.bgImageView addSubview:self.titleLB];
    
    [self.bgImageView addSubview:self.themeLB];
    [self.bgImageView addSubview:self.descrLB];
    
    [self.bgImageView addSubview:self.learnCountLB];
    [self.bgImageView addSubview:self.playBtn];
    
    [self makeConstraints];
    
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLB.textColor = COLOR_27323F_EFEFF6;
    self.descrLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_A8ABBE];
    self.descrLB.backgroundColor = COLOR_F8F9FA_333D48;
}


- (void)makeConstraints {
    
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(18);
        make.top.equalTo(self.bgImageView).offset(12);
        make.right.lessThanOrEqualTo(self.bgImageView);
    }]; 
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLB);
        make.top.equalTo(self.themeLB.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(62, 94));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(self.bgImageView).offset(-15);
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
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.learnCountLB);
        make.right.equalTo(self.bgImageView).offset(-15);
    }];
}


- (UIImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = COLOR_FFFFFF_3D4752;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = 5;
    }
    return _bgImageView;
}


- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.userInteractionEnabled = YES;
        _shadowIV.image = imageName(@"bg_shadow_readingbook_v2_18");
    }
    return _shadowIV;
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



- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _themeLB.font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
        
        NSString *title = @" 每天陪你读本书";
        NSMutableAttributedString  *attrString = [NSMutableAttributedString mutableAttributedString:title font:HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold) titleColor:COLOR_27323F_EFEFF6 image:imageName(@"ic_everydayread_v2_18") bounds:CGRectMake(0, -4, 22, 22) index:0];
              
        _themeLB.attributedText = attrString;
    }
    return _themeLB;
}





- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLB;
}



- (UILabel*)learnCountLB {
    if (!_learnCountLB) {
        _learnCountLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _learnCountLB;
}




- (HKCustomMarginLabel*)descrLB {
    if (!_descrLB) {
        _descrLB = [[HKCustomMarginLabel alloc] init];
        _descrLB.textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        _descrLB.textColor =  COLOR_7B8196;
        _descrLB.font = HK_FONT_SYSTEM(12);
        _descrLB.textAlignment = NSTextAlignmentLeft;
        _descrLB.backgroundColor = COLOR_F8F9FA;
        _descrLB.clipsToBounds = YES;
        _descrLB.layer.cornerRadius = 5;
        _descrLB.hidden = YES;
        _descrLB.numberOfLines = 2;
    }
    return _descrLB;
}


- (UIButton*)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setTitle:@"我要听" forState:UIControlStateNormal];
        [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_playBtn setImage:imageName(@"ic_start_v2_18") forState:UIControlStateNormal];
        [_playBtn setImage:imageName(@"ic_start_v2_18") forState:UIControlStateHighlighted];
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(88, 22) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        _playBtn.clipsToBounds = YES;
        _playBtn.layer.cornerRadius = 11;
        
        _playBtn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
        
        [_playBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_playBtn sizeToFit];
        [_playBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        [_playBtn setHKEnlargeEdge:20];
    }
    return _playBtn;
}


- (void)playBtnClick:(UIButton*)btn {
    
    if (self.playBtnClickBlock) {
        self.playBtnClickBlock(self.model);
    }
}


- (void)setModel:(HKBookModel *)model {
    
    _model = model;
    self.coverIV.model = model;
    self.titleLB.text = model.title;
    
    int count = [model.listen_number intValue];
    if (count>0) {
        NSString *number = [NSString stringWithFormat:@"%@", model.listen_number];
        NSString *endStr = [NSString stringWithFormat:@"人已学"];
        UIColor *color = [UIColor colorWithHexString:@"#9297AC"];
        
        NSMutableAttributedString *attributedString = [NSMutableAttributedString mutableAttributedString:number endString:endStr LineSpace:0 color:color endColor:COLOR_A8ABBE_7B8196 font:HK_FONT_SYSTEM_BOLD(13) endFont:HK_FONT_SYSTEM(13) isWrap:NO textAlignment:NSTextAlignmentLeft];
        
        self.learnCountLB.attributedText = attributedString;
    }
    
    self.descrLB.text = model.short_introduce;
    self.descrLB.hidden = isEmpty(model.short_introduce);
}



@end
