//
//  StarView.h
//  Code
//
//  Created by Ivan li on 2017/9/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    StarTypeDefault = 0,       //默认
    StarTypeVeryEasy = 0, //太简单
    StarTypeVeryEasySelected =1,  //选中
    
    StarTypeEasy=2,    //简单
    StarTypeEasySelected = 3,
    
    StarTypeMiddle=4,       //适中
    StarTypeMiddleSelected=5,
    
    StarTypeHard=6,  //
    StarTypeHardSelected=7,
    
    StarTypeVeryHard=8,
    StarTypeVeryHardSlected =9
}StarType;


@protocol StarViewDelegate <NSObject>
@optional
- (void)submitComment:(NSInteger)selectIndex  comment:(NSString*)comment;

@end

@interface StarView : UIView<UITextViewDelegate>

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *firstBtn;

@property(nonatomic,strong)UIButton *secondBtn;

@property(nonatomic,strong)UIButton *thirdBtn;

@property(nonatomic,strong)UIButton *fourthBtn;

@property(nonatomic,strong)UIButton *fifthBtn;

@property(nonatomic,assign)NSInteger selectIndex; //选择星的数量；

@property(nonatomic,assign)NSInteger hardIndex; //难度选择

@property(nonatomic,assign,readonly)StarType starType;

@property(nonatomic,weak)id <StarViewDelegate> deletate;
/** 提交按钮 选择背景 */
@property(nonatomic,strong)UIImage  *submitSelectBgImage;

@property(nonatomic,strong)UIImage  *submitNomalBgImage;

@property(nonatomic,assign)HKCommentType commentType;

@end

//
//
//
//- (id)init {
//
//    if (self = [super init]) {
//        [self createUI];
//        [self createObserver];
//    }
//    return self;
//}
//
//
//- (void)dealloc {
//    [MyNotification removeObserver:self];
//    NSLog(@"%@",NSStringFromClass([self class]));
//}
//
//
//#pragma mark - 监听难度选择
//- (void)createObserver {
//
//    [MyNotification addObserver:self
//                       selector:@selector(commentLevelNotification:)
//                           name:KCommentLevelNotification
//                         object:nil];
//}
//
//
//
//
//- (void)commentLevelNotification:(NSNotification *)noti {
//
//    NSDictionary *dict = noti.userInfo;
//    NSInteger  hardIndex  = [dict[@"selectIndex"] integerValue];
//    self.hardIndex = hardIndex;
//    [self feedbackInfoDidChange];
//}
//
//
//
//- (void)createUI {
//    self.backgroundColor = [UIColor whiteColor];
//    self.selectIndex = 0;
//    [self addSubview:self.titleLabel];
//
//    [self addSubview:self.firstBtn];
//    [self addSubview:self.secondBtn];
//
//    [self addSubview:self.thirdBtn];
//    [self addSubview:self.fourthBtn];
//    [self addSubview:self.fifthBtn];
//
//    [self addSubview:self.feedbackView];
//    [self addSubview:self.pointLabel];
//
//    [self addSubview:self.submitBtn];
//    [self makeConstraints];
//}
//
//
//
//
//- (void)makeConstraints {
//
//    WeakSelf;
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.top.equalTo(weakSelf).offset(PADDING_20);
//    }];
//
//    /** @param axisType 布局方向 * @param fixedSpacing 两个item之间的间距(最左面的item和左边, 最右边item和右边都不是这个)
//     * @param leadSpacing 第一个item到父视图边距 * @param tailSpacing 最后一个item到父视图边距*/
//    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PADDING_10 leadSpacing:PADDING_20*2 tailSpacing:PADDING_20*2];
//
//    [@[_firstBtn, _secondBtn, _thirdBtn,_fourthBtn,_fifthBtn]  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(PADDING_20);
//        make.height.mas_equalTo(PADDING_30);
//    }];
//
//
//    [_feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.firstBtn.mas_bottom).offset(60);
//        make.right.equalTo(weakSelf.mas_right).offset(-PADDING_15);
//        make.left.equalTo(weakSelf.mas_left).offset(PADDING_15);
//        make.height.mas_equalTo(IS_IPHONE6PLUS ?180:150);
//    }];
//
//    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.feedbackView.mas_top).offset(10);
//        make.left.equalTo(weakSelf.feedbackView.mas_left).offset(PADDING_15);
//        make.right.equalTo(weakSelf.feedbackView);
//    }];
//
//    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(IS_IPHONE_X ? (-40) :0);
//        make.height.mas_equalTo(PADDING_25*2);
//    }];
//}
//
//
//
//- (UILabel*)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"点击星星评分"
//                                    titleColor:COLOR_7B8196
//                                     titleFont:nil
//                                 titleAligment:NSTextAlignmentLeft];
//        _titleLabel.font = HK_FONT_SYSTEM(13);
//    }
//    return _titleLabel;
//}
//
//
//
//- (UILabel*)leftLabel {
//    if (!_leftLabel) {
//        _leftLabel  = [UILabel new];
//        _leftLabel.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//    }
//    return _leftLabel;
//}
//
//
//- (UILabel*)rightLabel {
//    if (!_rightLabel) {
//        _rightLabel  = [UILabel new];
//        _rightLabel.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//    }
//    return _rightLabel;
//}
//
//
//
//
//- (UIButton*)firstBtn {
//
//    if (!_firstBtn) {
//        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _firstBtn.tag = 0;
//        [_firstBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [_firstBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
//        [_firstBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _firstBtn;
//}
//
//
//- (UIButton*)secondBtn {
//
//    if (!_secondBtn) {
//        _secondBtn = [UIButton new];
//        [_secondBtn addTarget:self action:@selector(buttonPressed:)forControlEvents:UIControlEventTouchUpInside];
//        _secondBtn.tag = 1;
//        [_secondBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [_secondBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
//    }
//    return _secondBtn;
//}
//
//
//- (UIButton*)thirdBtn {
//
//    if (!_thirdBtn) {
//        _thirdBtn = [UIButton new];
//        [_thirdBtn addTarget:self
//                      action:@selector(buttonPressed:)
//            forControlEvents:UIControlEventTouchUpInside];
//
//        _thirdBtn.tag = 2;
//        [_thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [_thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
//
//    }
//    return _thirdBtn;
//}
//
//- (UIButton*)fourthBtn {
//
//    if (!_fourthBtn) {
//        _fourthBtn = [UIButton new];
//        [_fourthBtn addTarget:self
//                       action:@selector(buttonPressed:)
//             forControlEvents:UIControlEventTouchUpInside];
//
//        _fourthBtn.tag = 3;
//        [_fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [_fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
//
//    }
//    return _fourthBtn;
//}
//
//- (UIButton*)fifthBtn {
//
//    if (!_fifthBtn) {
//        _fifthBtn = [UIButton new];
//
//        [_fifthBtn addTarget:self
//                      action:@selector(buttonPressed:)
//            forControlEvents:UIControlEventTouchUpInside];
//        _fifthBtn.tag = 4;
//        [_fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [_fifthBtn setImage:imageName(imageName_selected) forState:UIControlStateHighlighted];
//    }
//    return _fifthBtn;
//}
//
//
//- (UIButton*)submitBtn {
//
//    if (!_submitBtn) {
//
//        _submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:[UIColor whiteColor] titleFont:nil imageName:nil];
//
//        _submitBtn.backgroundColor = RGB(210, 210, 210, 1);
//        [_submitBtn setEnabled:NO];
//        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?19 :18]];
//    }
//    return _submitBtn;
//}
//
//
//
//- (UITextView*)feedbackView {
//
//    if (!_feedbackView) {
//
//        _feedbackView = [UITextView new];
//        _feedbackView.delegate = self;
//        _feedbackView.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
//        _feedbackView.keyboardType = UIKeyboardTypeDefault;
//        _feedbackView.textAlignment = NSTextAlignmentLeft;
//        _feedbackView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
//        _feedbackView.clipsToBounds = YES;
//        _feedbackView.layer.cornerRadius = 3;
//        _feedbackView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedbackInfoDidChange) name:UITextViewTextDidChangeNotification object:_feedbackView];
//    }
//    return _feedbackView;
//}
//
//- (UILabel*)pointLabel{
//
//    if (!_pointLabel) {
//        _pointLabel = [UILabel new];
//        _pointLabel.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
//        _pointLabel.text = KCommentPlaceholder;
//        _pointLabel.numberOfLines = 0;
//        _pointLabel.textColor = [UIColor colorWithHexString:@"#A8ABBE"];
//        _pointLabel.enabled = NO;//lable必须设置为不可用
//        _pointLabel.backgroundColor = [UIColor clearColor];
//        [_pointLabel sizeToFit];
//    }
//    return _pointLabel;
//}
//
//
//
//#pragma mark - 难度 评分 留言 判断
//- (void)feedbackInfoDidChange {
//
//    if (_feedbackView.text.length > 4 && self.selectIndex >0 && self.hardIndex >0) {
//        [self.submitBtn setEnabled:YES];
//        [self.submitBtn setBackgroundImage:self.submitSelectBgImage forState:UIControlStateNormal];
//    }else{
//        [self.submitBtn setEnabled:NO];
//        [self.submitBtn setBackgroundImage:self.submitNomalBgImage forState:UIControlStateNormal];
//    }
//}
//
//
//#pragma mark - 通过颜色 设置背景图片
//- (void)setSubmitBtnBgImageWithColor:(UIColor *)color color1:(UIColor *)color1 color2:(UIColor *)color2 {
//    [_submitBtn gradientButtonWithSize:_submitBtn.size colorArray:@[(id)color,(id)color1,(id)color2] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftTopToRightBottom];
//}
//
//
//- (UIImage*)submitSelectBgImage {
//
//    if (!_submitSelectBgImage) {
//        UIColor *color2 = [UIColor colorWithHexString:@"#FF961F"];
//        UIColor *color1 = [UIColor colorWithHexString:@"#FF7F3F"];
//        UIColor *color = [UIColor colorWithHexString:@"#FF6A5A"];
//
//        _submitSelectBgImage = [[UIImage alloc]createImageWithSize:_submitBtn.size gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
//    }
//    return _submitSelectBgImage;
//}
//
//
//
//
//- (UIImage*)submitNomalBgImage {
//    if (!_submitNomalBgImage) {
//        UIColor *color = RGB(210, 210, 210, 1);
//        _submitNomalBgImage = [UIImage createImageWithColor:color];
//    }
//    return _submitNomalBgImage;
//}
//
//
//
//#pragma mark - textView delegate
//-(void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length == 0) {
//        self.pointLabel.text = KCommentPlaceholder;
//    }else{
//        self.pointLabel.text=nil;
//    }
//}
//
//
//
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
//
//
//
//- (void)submitAction:(id)sender {
//
//    if ([self.deletate respondsToSelector:@selector(submitComment:comment:)]) {
//        [self.deletate submitComment:self.selectIndex comment:self.feedbackView.text];
//    }
//}
//
//
//
//- (void)buttonPressed:(id)sender
//{
//    NSInteger index = [(UIButton *)sender tag];
//
//    if (index == 0) {
//        _starType = ((_starType == StarTypeVeryEasySelected) ? StarTypeVeryEasy  :StarTypeVeryEasySelected );
//        [self setButtonsBackground];
//    }
//    if (index == 1) {
//        _starType = ((_starType == StarTypeEasySelected) ?StarTypeEasy  : StarTypeEasySelected);
//        [self setButtonsBackground];
//    }
//    if (index == 2) {
//        _starType = ((_starType == StarTypeMiddleSelected) ? StarTypeMiddle : StarTypeMiddleSelected);
//        [self setButtonsBackground];
//    }
//    if (index == 3) {
//        _starType = ((_starType == StarTypeHardSelected) ? StarTypeHard : StarTypeHardSelected);
//        [self setButtonsBackground];
//    }
//    if (index == 4) {
//        _starType = ((_starType == StarTypeVeryHardSlected) ? StarTypeVeryHard : StarTypeVeryHardSlected);
//        [self setButtonsBackground];
//    }
//}
//
//
//
//
//- (void)setButtonsBackground {
//
//    NSInteger selectIndex = _starType / 2;
//    self.selectIndex = selectIndex + 1;
//    [self feedbackInfoDidChange];
//
//    if (selectIndex == 0) {
//
//        self.titleLabel.text = @"非常差";
//        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.secondBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//
//    }else if (selectIndex == 1) {
//
//        self.titleLabel.text = @"差";
//        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.thirdBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//
//    }else if (selectIndex == 2) {
//
//        self.titleLabel.text = @"一般";
//        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.fourthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//
//    }else if (selectIndex == 3){
//
//        self.titleLabel.text = @"好";
//        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.fifthBtn setImage:imageName(imageName_normal) forState:UIControlStateNormal];
//
//    }else if (selectIndex == 4) {
//
//        self.titleLabel.text = @"非常好";
//        [self.firstBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.secondBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.thirdBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.fourthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//        [self.fifthBtn setImage:imageName(imageName_selected) forState:UIControlStateNormal];
//    }
//}
//
//
//@end
//
//
//
//
//
//
//
//
