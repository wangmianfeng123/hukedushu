//
//  HKVerticalPriceButton.m
//

#import "HKVerticalPriceButton.h"

@interface HKVerticalPriceButton()

@property (nonatomic, weak)UIView *secondBG;
@property (nonatomic, weak)UIView *thirdBG;
@property (nonatomic, weak)UILabel *middleCountLB;

@property (nonatomic, strong)UIColor *normalBG2Color;
@property (nonatomic, strong)UIColor *selectedBG2Color;
@property (nonatomic, strong)UIColor *normalBG3Color;
@property (nonatomic, strong)UIColor *selectedBG3Color;

@end

@implementation HKVerticalPriceButton

- (void)setup
{
    // 默认设置
    self.backgroundColor = [UIColor clearColor];
    self.normalBG2Color = HKColorFromHex(0xFFE6D6, 1.0);
    self.selectedBG2Color = HKColorFromHex(0xFFB378, 1.0);
    self.normalBG3Color = HKColorFromHex(0xFFFFFF, 1.0);
    self.selectedBG3Color = HKColorFromHex(0xFFF894, 1.0);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = HKColorFromHex(0xFF7820, 1.0);
    
    // 第3层背景
    UIView *thirdBG = [[UIView alloc] init];
    thirdBG.backgroundColor = self.normalBG3Color;
    self.thirdBG = thirdBG;
    [self addSubview:thirdBG];
    [self sendSubviewToBack:thirdBG];
    
    // 第二层背景
    UIView *secondBG = [[UIView alloc] init];
    secondBG.backgroundColor = self.normalBG2Color;
    self.secondBG = secondBG;
    [self addSubview:secondBG];
    [self sendSubviewToBack:secondBG];
    
    // 中间数量
    UILabel *middleCountLB = [[UILabel alloc] init];
    self.middleCountLB = middleCountLB;
    middleCountLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:middleCountLB];
    [self bringSubviewToFront:middleCountLB];
    middleCountLB.textColor = HKColorFromHex(0xFF7505, 1.0);
    middleCountLB.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    middleCountLB.text = @"10";
    
    // 圆角
    self.thirdBG.clipsToBounds = YES;
    self.thirdBG.layer.cornerRadius = 5.0;
    self.secondBG.clipsToBounds = YES;
    self.secondBG.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.secondBG.backgroundColor = self.selectedBG2Color;
        self.thirdBG.backgroundColor = self.selectedBG3Color;
    }else {
        self.secondBG.backgroundColor = self.normalBG2Color;
        self.thirdBG.backgroundColor = self.normalBG3Color;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置第二层的背景
    self.secondBG.y = 2.0;
    self.secondBG.width = self.width;
    self.secondBG.height = self.height - self.secondBG.y;
    
    // 设置第3层的背景
    self.thirdBG.y = 0.0;
    self.thirdBG.x = 0.0;
    self.thirdBG.width = self.width - 5.0;
    self.thirdBG.height = self.height - 6.0;
    
    // 调整图片
    self.imageView.width = 43;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.thirdBG.centerX;
    self.imageView.y = 12.0;
    
    // 调整文字
    self.titleLabel.width = self.width;
    self.titleLabel.height = 15.1;
    self.titleLabel.centerX = self.thirdBG.centerX;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 3;
    
    // 中间数量
    self.middleCountLB.frame = self.imageView.frame;
    
    // 调整位置
    [self sendSubviewToBack:self.thirdBG];
    [self sendSubviewToBack:self.secondBG];
    [self bringSubviewToFront:self.middleCountLB];
    
    self.titleLabel.textColor = HKColorFromHex(0xFF7820, 1.0);
}

- (void)setMiddleCountLBText:(NSString *)string {
    self.middleCountLB.text = string;
}

@end
