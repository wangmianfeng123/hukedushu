//
//  HKVerticalButton.m
//

#import "HKLeftRightBtn.h"

@implementation HKLeftRightBtn

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
    
    // 整体宽度 title + image
    CGFloat realWidth = self.imageView.width + self.titleLabel.width + 3;// 3个间距
    CGFloat padding = (self.width - realWidth ) / 2.0;
    
    // 调整图片
    self.imageView.width = self.imageView.width;
    self.imageView.height = self.imageView.height;
    self.imageView.x = self.width - padding - self.imageView.width;
    self.imageView.centerY = self.height * 0.5;
    
    // 调整文字
    self.titleLabel.width = self.titleLabel.width;
    self.titleLabel.height = self.titleLabel.height;
    self.titleLabel.x = padding;
    self.titleLabel.centerY = self.height * 0.5;

}

@end
