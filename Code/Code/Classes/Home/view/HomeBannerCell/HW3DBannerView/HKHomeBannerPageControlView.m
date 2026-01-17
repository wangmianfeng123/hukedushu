


#import "HKHomeBannerPageControlView.h"


#define dotW 10 // 圆点宽
#define dotH 5  // 圆点高
#define magrin 8    // 圆点间距

@implementation HKHomeBannerPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        //[self setValue:[UIImage imageNamed:@"banner_select"] forKeyPath:@"_currentPageImage"];
        //[self setValue:[UIImage imageNamed:@"banner_gray"] forKeyPath:@"_pageImage"];
        self.currentImage = [UIImage imageNamed:@"banner_select"];
        self.inactiveImage = [UIImage imageNamed:@"banner_gray"];

        self.currentImageSize = self.currentImage.size;
        self.inactiveImageSize = self.inactiveImage.size;
        self.pageIndicatorTintColor = [UIColor clearColor];
        self.currentPageIndicatorTintColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    //计算圆点间距
//    CGFloat marginX = dotW + magrin;
//
//    //计算整个pageControll的宽度
//    CGFloat newW = (self.subviews.count - 1 ) * marginX;
//
//    //设置新frame
//    self.frame = CGRectMake(SCREEN_WIDTH/2-(newW + dotW)/2, self.frame.origin.y, newW + dotW, self.frame.size.height);
//
//    //遍历subview,设置圆点frame
//    for (int i=0; i<[self.subviews count]; i++) {
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//
//        if (i == self.currentPage) {
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotH)];
//        }else {
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotH)];
//        }
//    }
//
//}




- (void)setCurrentPage:(NSInteger)currentPage{

    [super setCurrentPage:currentPage];
//    [self updateDots];

}


- (void)updateDots{

    for (int i = 0; i < [self.subviews count]; i++) {

        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        if (i == self.currentPage){
            dot.image = self.currentImage;
            dot.size = self.currentImageSize;
        }else{
            dot.image = self.inactiveImage;
            dot.size = self.inactiveImageSize;
        }
//            dot.centerY = self.centerY;
    }
}


- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{

    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
    if (dot == nil) {
        dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *)view;
    }
    return dot;
}




@end

