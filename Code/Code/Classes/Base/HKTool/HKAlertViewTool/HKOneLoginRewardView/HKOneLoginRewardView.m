//
//  HKOneLoginRewardView.m
//  Code
//
//  Created by Ivan li on 2019/8/22.
//  Copyright © 2019 pg. All rights reserved.
//


#import "HKOneLoginRewardView.h"
#import "UIButton+Badge.h"
#import <CoreText/CoreText.h>
#import "HKVersionModel.h"


@interface HKOneLoginRewardView()

@property (nonatomic , strong ) UIImageView *upIV; //图片

@property (nonatomic , strong ) UIImageView *downIV; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UILabel *themeLabel; //主题

@property (nonatomic , strong ) UIButton *colseButton;

@property (nonatomic , strong ) UIView *bgView;

@property (nonatomic,strong) HKInitConfigModel *configModel;

@end


@implementation HKOneLoginRewardView



#pragma mark -- 显示 极验 注册成功 后奖励 AlertView
+ (void)showOneLoginRewardAlertViewWithFrame:(CGRect)frame configModel:(HKInitConfigModel*)configModel {
    
    HKOneLoginRewardView *view = [[self alloc] initWithFrame:CGRectEqualToRect(frame, CGRectZero) ?CGRectMake(0, 0, 290, 214+76+85) :frame];
    view.configModel = configModel;
    view.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeQueue(YES)
    .LeePriority(1)
    .LeeCornerRadius(0)
    .LeeHeaderColor([UIColor clearColor])
    .LeeHeaderInsets(UIEdgeInsetsZero)
    .LeeMaxWidth(320)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



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


- (void)createUI {
    [self addSubview:self.bgView];
    [self addSubview:self.upIV];
    [self addSubview:self.downIV];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.themeLabel];
    [self addSubview:self.colseButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-85);
        make.top.equalTo(self).offset(76);
    }];
    
    [self.upIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.bgView.mas_top);
    }];
    
    [self.downIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.titleLabel.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(60);
        make.left.right.equalTo(self.bgView);
    }];
    
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
        make.left.right.equalTo(self.bgView);
    }];
    
    [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(38);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self setColseButtonBadge];
}




- (void)setColseButtonBadge {
    self.colseButton.badgeValue = @"礼物在等你哟~";
    self.colseButton.badgeBGColor = [UIColor colorWithHexString:@"#FF6B54"];
    self.colseButton.badgeTextColor = [UIColor whiteColor];
    self.colseButton.badgeFont = HK_FONT_SYSTEM(14);
    self.colseButton.badgePadding = 14;
    self.colseButton.badgeTopPadding = 4;
    self.colseButton.badgeOriginX = 25;
    self.colseButton.badgeOriginY = -14;
}



- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}


- (UIImageView*)upIV {
    if (!_upIV) {
        _upIV = [[UIImageView alloc] init];
        _upIV.image = imageName(@"pic_bulb_top_v2_15");
    }
    return _upIV;
}


- (UIImageView*)downIV {
    if (!_downIV) {
        _downIV = [[UIImageView alloc] init];
        _downIV.image = imageName(@"bg_gift_open_v2_16");
    }
    return _downIV;
}




- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"恭喜获得" titleColor:COLOR_27323F titleFont:@"16" titleAligment:1];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


- (UILabel*)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [UILabel labelWithTitle:CGRectZero title:@"可在【我的】中查看哦~" titleColor:COLOR_7B8196 titleFont:@"14" titleAligment:1];
        _themeLabel.numberOfLines = 0;
    }
    return _themeLabel;
}


- (void)setConfigModel:(HKInitConfigModel *)configModel {
    _configModel = configModel;
    
    [self setThemeLabelText:configModel.name desc:configModel.desc];
}


- (void)setThemeLabelText:(NSString*)text desc:(NSString*)desc{
    if (isEmpty(text)) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@\n%@", text,desc];
    
    UIFont *font = HK_FONT_SYSTEM_WEIGHT(20, UIFontWeightSemibold);
    
    NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:COLOR_27323F
                                                                              TotalString:str
                                                                           SubStringArray:@[text]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    // 字间距
    long number = 1;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributed addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[str length])];
    CFRelease(num);
    
    self.themeLabel.attributedText = attributed;
}


- (UIButton*)colseButton {
    if (!_colseButton) {
        _colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colseButton setImage:[UIImage imageNamed:@"ic_signclose_v2_1"] forState:UIControlStateNormal];
        [_colseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_colseButton setHKEnlargeEdge:20];
        [_colseButton sizeToFit];
    }
    return _colseButton;
}


- (UILabel*)badge {
    
    UILabel *label = [UILabel labelWithTitle:CGRectZero title:@"礼物在等你哟~" titleColor:[UIColor whiteColor] titleFont:@"14" titleAligment:1];
    label.backgroundColor = [UIColor colorWithHexString:@"#FF6B54"];
    label.size = CGSizeMake(123, 27);
    [label sizeToFit];
    return label;
}


- (void)closeButtonAction:(UIButton*)btn {
    if (self.closeBlock) {
        self.closeBlock();
    }
}




@end
