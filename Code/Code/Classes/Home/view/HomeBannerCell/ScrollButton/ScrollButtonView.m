//
//  ScrollButtonView.m
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//


#import "ScrollButtonView.h"
#import "UIView+SNFoundation.h"
#import <SDWebImage/UIButton+WebCache.h>


@interface ScrollButtonView(){
 
}
@end

@implementation ScrollButtonView

- (instancetype)initWithFrame:(CGRect)frame
                 andTitlesArr: (NSArray *)titles
                 andImageArr: (NSArray *)images
                  andTapBlock: (Myblock)block
{
    self = [super initWithFrame:frame];
    
    NSString *temp ;
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
        _scroller.showsHorizontalScrollIndicator = NO;
        
        _butTitles  = titles;
        _butImages = images;
        
        /**
         *  最小按钮宽度为屏幕1/5,再小就不好操作了
         */
        CGFloat butWidth = SCREEN_WIDTH/5;
        if (titles.count<5)
        {
            butWidth = SCREEN_WIDTH/titles.count;
        }else{
            
            butWidth = IS_IPHONE6PLUS ?80:75;
            if (titles.count*75 <SCREEN_WIDTH) {
                butWidth = SCREEN_WIDTH/5;
            }
        }
        
        _scroller.contentSize = CGSizeMake(butWidth * titles.count, frame.size.height);
        for (int i = 0 ; i < _butTitles.count; i++)
        {
            __block UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setTitle:_butTitles[i] forState:UIControlStateNormal];
            [but setTitle:_butTitles[i] forState:UIControlStateSelected];
            [but setTitle:_butTitles[i] forState:UIControlStateHighlighted];
            
            [but setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//            [but setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateSelected];
//            [but setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateHighlighted];
            
            [but sd_setBackgroundImageWithURL:[NSURL URLWithString:_butImages[i]] forState:UIControlStateNormal placeholderImage:imageName(HK_Placeholder)];
            [but sd_setBackgroundImageWithURL:[NSURL URLWithString:_butImages[i]] forState:UIControlStateSelected placeholderImage:imageName(HK_Placeholder)];
            [but sd_setBackgroundImageWithURL:[NSURL URLWithString:_butImages[i]] forState:UIControlStateHighlighted placeholderImage:imageName(HK_Placeholder)];
            
            but.size = but.currentImage.size;
            but.titleLabel.textAlignment = NSTextAlignmentCenter;
            but.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?13:12];
            but.frame = CGRectMake(butWidth*i+3, PADDING_15, 60, 60);
            
            //but.frame = CGRectMake(65*i+3, PADDING_15, 60, 60);

            //__block CGFloat W = but.size.width;
            //CGFloat H = but.size.height;
            //CGFloat S = (SCREEN_WIDTH -titles.count * W)/6;
            //but.frame = CGRectMake(S+(W+S)*i, PADDING_15, W, H);
            
            but.tag = i+1;
            //[but setTitleEdgeInsets:UIEdgeInsetsMake(but.imageView.frame.size.height+PADDING_25,-W-3, 0, -3)];
            [but setTitleEdgeInsets:UIEdgeInsetsMake(60+20,-but.imageView.frame.size.width, 0, -3)];
            [but addTarget:self action:@selector(ButTap:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scroller addSubview:but];
            temp =  _butImages[i];
        }
        [self addSubview:_scroller];
        self.block = block;
    }
    

    
    return self;
}
// 按钮点击事件;
- (void)ButTap: (UIButton *)sender {
    
    self.block(sender.tag);
    
//    for (int i = 0; i < _butTitles.count; i++)
//    {
//        UIButton * but = (UIButton*)[_scroller viewWithTag:i+1];
//        but.selected = NO;
//        //恢复原大小
//        [UIView animateWithDuration:0.35 animations:^{
//             but.titleLabel.font = [UIFont systemFontOfSize:14];
//        }];
//       
//    }
//    sender.selected = !sender.selected;
//    //文字变大
//    [UIView animateWithDuration:0.35 animations:^{
//        sender.titleLabel.font = [UIFont systemFontOfSize:18];
//    }];
//    [sender setBackgroundColor:[UIColor whiteColor]];
    
}
@end
