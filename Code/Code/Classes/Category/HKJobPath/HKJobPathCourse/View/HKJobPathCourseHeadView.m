//
//  HKJobPathCourseHeadView.m
//  Code
//
//  Created by Ivan li on 2019/6/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseHeadView.h"
#import "UIButton+ImageTitleSpace.h"
#import "UIImage+Helper.h"
#import "TYAttributedLabel.h"
#import "HKJobPathModel.h"
#import "NSString+MD5.h"
#import "UIView+HKLayer.h"

@interface HKJobPathCourseHeadView()

@property (nonatomic,strong) UILabel *titleLB;
/** 标签 背景 */
@property (nonatomic,strong) UIView *tagsContentView;

@property (nonatomic,strong) UIButton *openBtn;

@property (nonatomic,assign) BOOL isOpen;
/** 背景 */
@property (nonatomic,strong) UIImageView *bgIV;

@property (nonatomic,strong) UIView *contentBgView;

@property (nonatomic,strong) TYAttributedLabel *descrLB;

@property (nonatomic,copy) NSString *descString;

@property (nonatomic,strong) NSMutableArray <UIButton*>*viewArr;

@end


@implementation HKJobPathCourseHeadView


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
    return  self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tagsContentView.width = self.width;
    self.tagsContentView.y = CGRectGetMaxY(self.titleLB.frame) + 10;
    self.tagsContentView.height = CGRectGetMaxY(self.tagsContentView.subviews.lastObject.frame);
    
    self.descrLB.x = 30;
    self.descrLB.width = self.width - 60;
    self.descrLB.y = CGRectGetMaxY(self.tagsContentView.frame) + 15;
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.goVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descrLB.mas_bottom).offset(8);
        make.left.equalTo(self.descrLB.mas_left);
        make.height.mas_equalTo(22);
//        make.size.mas_equalTo(CGSizeMake(190, 22));
        //make.bottom.equalTo(self.descrLB.mas_bottom).offset(20);
    }];
    
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.goVipBtn.mas_bottom).offset(20);
    }];
    
    if (self.guideModel.is_show) {
        if (self.heightChangeBlock) {
            self.heightChangeBlock((CGRectGetMaxY(self.goVipBtn.frame) +20), CGRectGetMaxY(self.tagsContentView.frame));
        }
    }else{
        if (self.heightChangeBlock) {
            self.heightChangeBlock((CGRectGetMaxY(self.descrLB.frame) +20), CGRectGetMaxY(self.tagsContentView.frame));
        }
    }
    
}



- (void)setDescrTextColor:(UIColor *)color {
    
    self.descrLB.textColor = color;
}


//- (void)showDescrLb:(BOOL)show {
////    self.descrLB.hidden = show;
//    self.tagsContentView.hidden = show;
//}

- (void)showContentBgView:(BOOL)show  alpha:(CGFloat)alpha {
    
    self.titleLB.hidden = show;
    
    self.descrLB.hidden = show;
    self.descrLB.textColor = [self.descrLB.textColor colorWithAlphaComponent:alpha];
    //self.titleLB.textColor = [self.titleLB.textColor colorWithAlphaComponent:alpha];
    
    for (UIButton *btn in self.viewArr) {
        btn.hidden = show;
    }
}



- (void)createUI {
 
    [self addSubview:self.bgIV];
    [self addSubview:self.contentBgView];
    
    [self.contentBgView addSubview:self.titleLB];
    [self.contentBgView addSubview:self.tagsContentView];
    [self.contentBgView addSubview:self.descrLB];
    [self.contentBgView addSubview:self.goVipBtn];
}



#pragma mark - 行数
- (NSInteger)textRow:(NSString*)text {
    if (isEmpty(text)) {
        return 0;
    }
    NSString *desc = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger count = [CommonFunction getTextRow:desc font:HK_FONT_SYSTEM(13) lineSpacing:0 width:self.width - 60 lineBreakMode:0];
    return  count;
}


- (NSString *)line3Char:(NSString *)content {
    
    for (NSInteger i = 1; i <= content.length; i++) {
        NSString *stringChar = [content substringToIndex:i];
        NSString * stringCharTemp = [NSString stringWithFormat:@"%@...", stringChar];
        
        NSInteger row = [self textRow:stringCharTemp];
        if (row >3) {
            return [[stringChar substringToIndex:stringChar.length - 1] stringByAppendingString:@"..."];
        }
    }
    return @"";
}



- (void)setdescrLBText:(NSString*)text isAddBtn:(BOOL)isAddBtn{
    
    if (!isEmpty(text)) {
        NSMutableAttributedString *attributedString = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:3 textSpace:0 font:13 titleColor:[UIColor whiteColor]];
        
        self.descrLB.attributedText = attributedString;
        if (isAddBtn) {
            [self.descrLB appendView:self.openBtn alignment:TYDrawAlignmentCenter];
        }
        [self.descrLB sizeToFit];
    }
}



- (TYAttributedLabel*)descrLB {
    if (!_descrLB) {
        _descrLB = [TYAttributedLabel new];
        _descrLB.backgroundColor = [UIColor clearColor];
        _descrLB.textColor = [UIColor whiteColor];
        
        _descrLB.lineBreakMode = kCTLineBreakByCharWrapping;
        _descrLB.font = HK_FONT_SYSTEM(13);
        _descrLB.numberOfLines = 0;
    }
    return _descrLB;
}



- (UIView*)tagsContentView {
    if (!_tagsContentView) {
        _tagsContentView = [UIView new];
    }
    return _tagsContentView;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"23" titleAligment:0];
        
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(23, UIFontWeightSemibold);
        [_titleLB sizeToFit];
        _titleLB.width = self.width - 30;
        _titleLB.height = 65/2;
        _titleLB.x = 30;
        _titleLB.y = KNavBarHeight64;
    }
    return _titleLB;
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        UIImage *image = [UIImage changeImageSize:imageName(@"bg_v2_13") AndSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgIV.image = image;
    }
    return _bgIV;
}


- (UIView*)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [UIView new];
        _contentBgView.backgroundColor = [UIColor clearColor];
    }
    return _contentBgView;
}



- (UIButton*)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setImage:imageName(@"ic_go_v2_13") forState:UIControlStateNormal];
        [_openBtn setImage:imageName(@"ic_go_v2_13") forState:UIControlStateHighlighted];
        
        [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.size = CGSizeMake(10, 10);
        [_openBtn setHKEnlargeEdge:20];
    }
    return _openBtn;
}

//- (UIButton*)goVipBtn {
//    if (!_goVipBtn) {
//        _goVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_goVipBtn setTitle:@"全站通vip畅学59大职业路径" forState:UIControlStateNormal];
//        [_goVipBtn addTarget:self action:@selector(goVipBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_goVipBtn addCornerRadius:5 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
//        _goVipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_goVipBtn setTitleColor:[UIColor colorWithHexString:@"#FF7820"] forState:UIControlStateNormal];
//    }
//    return _openBtn;
//}

- (UIButton*)goVipBtn {
    
    if (!_goVipBtn) {
        _goVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_goVipBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_goVipBtn setTitle:@"全站通vip畅学59大职业路径" forState:UIControlStateNormal];
        [_goVipBtn setTitleColor:[UIColor colorWithHexString:@"#FF7820"] forState:UIControlStateNormal];
        [_goVipBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 12:12]];
        _goVipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _goVipBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [_goVipBtn addTarget:self action:@selector(goVipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_goVipBtn addCornerRadius:5 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
    }
    return _goVipBtn;
}


- (void)goVipBtnClick{
    NSLog(@"--------");
    if (self.didVipBtnBlock) {
        self.didVipBtnBlock();
        [MobClick event:careerpath_TotalVip];
        [HKALIYunLogManage sharedInstance].button_id = @"12";
    }
}


- (void)openBtnClick:(UIButton*)btn {
    
    if (!self.isOpen) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        self.isOpen = YES;
        NSString *text = [NSString stringWithFormat:@"%@ ",self.descString];
        [self setdescrLBText:text isAddBtn:YES];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
        self.isOpen = NO;
        
        NSString *text = [self line3Char:self.descString];
        [self setdescrLBText:text isAddBtn:YES];
    }
}




- (void)setTitleArr:(NSArray *)titleAry contentView:(UIView*)contentView {
    
    for (UIButton *btn in self.viewArr) {
        [btn removeFromSuperview];
    }
    [self.viewArr removeAllObjects];
    
    for (int i = 0; i < titleAry.count; i++) {
        
        UIColor *bgColor = (i >=1) ?[UIColor clearColor] : [UIColor whiteColor];
        UIColor *titleColor = (i >=1) ?[UIColor whiteColor] : COLOR_27323F;
        
        UIButton *but = nil;
        switch (i) {
            case 0:{
                bgColor = [bgColor colorWithAlphaComponent:0.75];
                but = [self buttonWithTitle:titleAry[i] imageName:nil backgroundColor:bgColor titleColor:titleColor];
            }
                break;
            case 1: case 2:{
                but = [self buttonWithTitle:titleAry[i] imageName:nil backgroundColor:bgColor titleColor:titleColor];
                but.layer.cornerRadius = 5.0;
                but.layer.borderWidth = 1.0;
                but.layer.borderColor = [COLOR_ffffff colorWithAlphaComponent:0.6].CGColor;
                but.clipsToBounds = YES;
            }
                break;
            default:
                break;
        }
        
//        UIColor *bgColor = (i >1) ?[UIColor clearColor] : [UIColor whiteColor];
//        UIColor *titleColor = (i >1) ?[UIColor whiteColor] : COLOR_27323F;
        
//        switch (i) {
//            case 0:{
//                bgColor = [bgColor colorWithAlphaComponent:0.75];
//                but = [self buttonWithTitle:titleAry[i] imageName:@"ic_hot_v2_13" backgroundColor:bgColor titleColor:titleColor];
//            }
//                break;
//            case 1:{
//                bgColor = [bgColor colorWithAlphaComponent:0.75];
//                but = [self buttonWithTitle:titleAry[i] imageName:nil backgroundColor:bgColor titleColor:titleColor];
//            }
//                break;
//            case 2: case 3:{
//                but = [self buttonWithTitle:titleAry[i] imageName:nil backgroundColor:bgColor titleColor:titleColor];
//                but.layer.cornerRadius = 5.0;
//                but.layer.borderWidth = 1.0;
//                but.layer.borderColor = [COLOR_ffffff colorWithAlphaComponent:0.6].CGColor;
//                but.clipsToBounds = YES;
//            }
//                break;
//            default:
//                break;
//        }
        
        [self.viewArr addObject:but];
        [contentView addSubview:but];
    }
    
    CGFloat currentX = 30.0;
    CGFloat currentY = 0;
    
    NSInteger countRow = 0;
    CGFloat countCol = 0;
    CGFloat margin = 5;
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        
        if (currentX + subView.width + margin * countRow > self.width) {
            subView.x = 30;
            subView.y = (currentY += subView.height) + margin * (++countCol);
            currentX = subView.width + 30;
            countRow = 1;
        } else {
            subView.x = (currentX += subView.width) - subView.width + margin * countRow;
            subView.y = currentY + margin * countCol;
            countRow ++;
        }
    }
    contentView.height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
}



- (UIButton*)buttonWithTitle:(NSString*)title imageName:(NSString*)imageName backgroundColor:(UIColor*)backgroundColor titleColor:(UIColor*)titleColor {
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(butCilckAction:) forControlEvents:UIControlEventTouchUpInside];
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 5;
    [but setTitleColor:titleColor forState:UIControlStateNormal];
    [but setTitleColor:titleColor forState:UIControlStateHighlighted];
    [but setTitle:title forState:UIControlStateNormal];
    
    if (!isEmpty(imageName)) {
        [but setImage:imageName(imageName) forState:UIControlStateNormal];
        [but setImage:imageName(imageName) forState:UIControlStateHighlighted];
        [but layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    
    UIImage *image = [UIImage createImageWithColor:(backgroundColor) ?backgroundColor :[UIColor clearColor]];
    [but setBackgroundImage:image forState:UIControlStateNormal];
    [but setBackgroundImage:image forState:UIControlStateHighlighted];
    
    but.titleLabel.font = HK_FONT_SYSTEM(12);
    [but sizeToFit];
    but.height = 22;
    but.width += 15;
    return but;
}



- (void)butCilckAction:(UIButton*)btn {
    
}


- (void)testValue {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleLB.text = @"平面设计师职业路径";
        
        NSArray *arr = @[@"6128人已学",@"共计29小时",@"4个章节",@"116节课",@"6128人已学",@"共计29小时"];
        [self setTitleArr:arr contentView:self.tagsContentView];
        
        [self testTYAttridescrLB];
    });
}



- (void)testTYAttridescrLB {
    self.descString = @"平面设计是一个创意工作，它包含海报、书籍画册、LOGO等设计，设计师需要具备设计手法和敏锐的美感，对文字也要有一定的素养。本套课平面设计是一个创意工作，它包含海报、书籍画册、LOGO等设计，设计师需要具备设计手法和敏锐的美感，对文字也要有一定的素养。本套课程聚";
    //self.descString = @"平面设计是一个创意工作，它包含海报、书籍画册、LOGO等设计，设计师需要具备设计手法和敏";
    [self setDescText];
}


- (void)setDescText {
    NSInteger row = [self textRow:self.descString];
    NSString *text = self.descString;
    if ((row >3)) {
        text = [self line3Char:self.descString];
    }
    [self setdescrLBText:text isAddBtn:(row >3)];
}



- (void)setJobPathModel:(HKJobPathModel *)jobPathModel {
    _jobPathModel = jobPathModel;
    
    self.titleLB.text = isEmpty(jobPathModel.title)? @"": jobPathModel.title;
    self.descString = jobPathModel.desc;
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString *str = nil;
    /// v2.17 隐藏
    //str = [NSString stringWithFormat:@"%@人已学",jobPathModel.study_number];
    //[arr addObject:str];
    
    str = [NSString stringWithFormat:@"共计%@",isEmpty(jobPathModel.total_time)?@"" :jobPathModel.total_time];
    [arr addObject:str];
    
    str = [NSString stringWithFormat:@"%ld个章节",(long)jobPathModel.chapter_count];
    [arr addObject:str];
    
    str = [NSString stringWithFormat:@"%ld节课",(long)jobPathModel.course_count];
    [arr addObject:str];
    
    //NSArray *arr = @[@"6128人已学",@"共计29小时",@"4个章节",@"116节课",@"6128人已学",@"共计29小时"];
    [self setTitleArr:arr contentView:self.tagsContentView];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setDescText];
}

-(void)setGuideModel:(HKJobPathHeadGuideModel *)guideModel{
    _guideModel = guideModel;
    if (guideModel.is_show) {
        self.goVipBtn.hidden = NO;
        [self.goVipBtn setTitle:guideModel.string forState:UIControlStateNormal];
    }else{
        self.goVipBtn.hidden = YES;
    }
}


- (NSMutableArray <UIButton*>*)viewArr {
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}


@end


