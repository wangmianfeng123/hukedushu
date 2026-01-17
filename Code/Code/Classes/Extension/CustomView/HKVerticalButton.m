//
//  HKVerticalButton.m
//

#import "HKVerticalButton.h"

@implementation HKVerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    // 调整图片
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 0;
    self.imageView.width = self.imageView.image.size.width;
    self.imageView.height = self.imageView.image.size.height;
    
    // 调整文字
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.titleLabel.font.pointSize + 0.5;
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.y = self.height - self.titleLabel.height;
}

@end
