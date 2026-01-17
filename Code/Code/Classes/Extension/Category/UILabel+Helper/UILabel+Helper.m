//
//  UILabel+Helper.m
//  Code
//
//  Created by pg on 16/3/20.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "UILabel+Helper.h"

@implementation UILabel (Helper)


+ (UILabel *) labelWithTitle:(CGRect)rect title:(NSString *)title  titleColor:(UIColor *)color
                   titleFont:(NSString *)font  titleAligment:(NSInteger)aligment
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    
    if (!isBlankString(title))
        [label setText:title];
    
    if (!isBlankString(font))
        [label setFont:[UIFont systemFontOfSize:[font floatValue]]];
        
    [label setTextColor:color];
    
    [label setTextAlignment:aligment];
    
    return label;
}


+ (void)showStats:(NSString *)stats atView:(UIView *)view {
    
    UILabel *message = [[UILabel alloc] init];
    message.layer.cornerRadius = 10;
    message.clipsToBounds = YES;
    message.backgroundColor = RGBA(0, 0, 0, 0.8);
    message.numberOfLines = 0;
    message.font = [UIFont systemFontOfSize:15];
    message.textColor = [UIColor whiteColor];
    message.textAlignment = NSTextAlignmentCenter;
    message.alpha = 0;
    
    message.text = stats;
    CGSize size = [stats boundingRectWithSize:CGSizeMake(MAXFLOAT, 50)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                      context:nil].size;
    message.frame = CGRectMake(0, 0, size.width + 20, size.height + 10);
    message.center = view.center;
    [view addSubview:message];
    
    [UIView animateWithDuration:0.5 animations:^{
        message.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            message.alpha = 0;
        } completion:^(BOOL finished) {
            [message removeFromSuperview];
            
        }];
    }];
}




+ (UILabel *) labelWithTitleAndImage:(NSString *)title  image:(NSString *)image
                          titleColor:(UIColor *)color
                           titleFont:(NSString *) font
{
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    [label setTextColor:color];
    
    if (!isBlankString(font))
        [label setFont:[UIFont systemFontOfSize:[font floatValue]]];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = imageName(image);
    
    [bgLabel addSubview:label];
    
    [bgLabel addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(bgLabel).offset(PADDING_5);
        make.width.equalTo(@20);
        make.centerX.equalTo(bgLabel.mas_centerX);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(PADDING_5);
        make.centerX.equalTo(bgLabel.mas_centerX);
    }];
    return bgLabel;
}



+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}












@end
