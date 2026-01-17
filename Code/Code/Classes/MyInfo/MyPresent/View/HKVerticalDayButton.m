//
//  HKVerticalDayButton.m
//

#import "HKVerticalDayButton.h"

@interface HKVerticalDayButton()

@property (nonatomic, weak)UILabel *daysLB;// 天数

@end


@implementation HKVerticalDayButton

- (void)setup
{
    // 设置font
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (UILabel *)daysLB {
    if (_daysLB == nil) {
        // 添加天数LB
        UILabel *daysLB = [[UILabel alloc] init];
        daysLB.textAlignment = NSTextAlignmentCenter;
        self.daysLB = daysLB;
        daysLB.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:daysLB];
    }
    return _daysLB;
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

- (void)setTextTop:(NSString *)topText bottom:(NSString *)bottomText {
    [self setTitle:topText forState:UIControlStateNormal];
    self.daysLB.text = bottomText;
    self.daysLB.textColor = HKColorFromHex(0x333333, 1.0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.frame = self.imageView.bounds;
    
    // 天数
    self.daysLB.x = 0;
    self.daysLB.y = self.imageView.height + 10;
    self.daysLB.width = self.width;
    self.daysLB.height = self.height - self.daysLB.y;
}

@end
