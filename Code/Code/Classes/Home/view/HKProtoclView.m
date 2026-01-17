//
//  HKProtoclView.m
//  Code
//
//  Created by eon Z on 2024/4/26.
//  Copyright © 2024 pg. All rights reserved.
//

#import "HKProtoclView.h"

@interface HKProtoclView ()<UITextViewDelegate>
@property(nonatomic,weak)UITextView *linkTV;
@end

@implementation HKProtoclView


+ (HKProtoclView *)createView{
    HKProtoclView * authView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKProtoclView class]) owner:nil options:nil].lastObject;
//    authView.frame = CGRectMake(0, 0, 260, 308);
    return authView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setSubView];//设置子view
        [self setLinkText];//设置文本
    });
    
}

//设置子view
- (void)setSubView{
    UIFont *linkFont = [UIFont systemFontOfSize:14.0];
    CGFloat linkW = self.width;
    
    UITextView *linkTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 65, linkW, 250)];
    self.linkTV = linkTV;
    linkTV.userInteractionEnabled = YES;
    linkTV.font = linkFont;
    linkTV.textColor = [UIColor redColor];
    [self addSubview:linkTV];
    linkTV.editable = NO;//必须禁止输入，否则点击将弹出输入键盘
    linkTV.scrollEnabled = NO;
    linkTV.delegate = self;
    linkTV.textContainerInset = UIEdgeInsetsMake(0,0, 0, 0);//文本距离边界值
}


//设置文本
- (void)setLinkText{
    
    NSString *linkStr = @"为保障您的合法权益，更好地向您提供产品和服务\n依据我国最新的法律法规及监管部门的要求，更新了《虎课网用户协议》和《虎课网用户隐私条款》。请您在继续操作前认真阅读并充分理解相关条款。\n您可阅读完整版 《虎课网用户协议》和《虎课网用户隐私条款》 ";
    UIFont *linkFont = [UIFont systemFontOfSize:14.0];
    CGFloat linkW = self.width;
    CGSize linkSize = [self getAttributionHeightWithString:linkStr lineSpace:2 kern:1 font:linkFont width:linkW];
    self.linkTV.frame = CGRectMake(0+3, 55+5, linkW, 170);
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:linkStr];
    [attributedString addAttribute:NSLinkAttributeName value:@"login://" range:[[attributedString string] rangeOfString:@"《虎课网用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"register://" range:[[attributedString string] rangeOfString:@"《虎课网用户隐私条款》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"login://" range:[[attributedString string] rangeOfString:@" 《虎课网用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"register://" range:[[attributedString string] rangeOfString:@"《虎课网用户隐私条款》 "]];
    
//    CGSize size = CGSizeMake(12, 12);
//    UIImage *image = [UIImage imageNamed:self.select == YES ? @"selected" : @"unSelected"];
//    UIGraphicsBeginImageContextWithOptions(size, false, 0);
//    [image drawInRect:CGRectMake(0, 0.25, 12, 12)];
//    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = resizeImage;
//    NSMutableAttributedString *imageString = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:textAttachment];
//    [imageString addAttribute:NSLinkAttributeName value:@"checkbox://" range:NSMakeRange(0, imageString.length)];
//    [attributedString insertAttributedString:imageString atIndex:0];
////    [attributedString addAttribute:NSFontAttributeName value:linkFont range:NSMakeRange(0, attributedString.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = 1.5;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(1),
                                NSFontAttributeName:linkFont};
    [attributedString addAttributes:attriDict range:NSMakeRange(0, attributedString.length)];
    
    self.linkTV.attributedText = attributedString;
    self.linkTV.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#457DFF"], NSUnderlineColorAttributeName: [UIColor redColor], NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    //#457DFF
}

/*
 *  设置行间距和字间距
 *
 *  @param string    字符串
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *  @param font      字体大小
 *
 *  @return 富文本
 */
- (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

/* 获取富文本的高度
 *
 * @param string    文字
 * @param lineSpace 行间距
 * @param kern      字间距
 * @param font      字体大小
 * @param width     文本宽度
 *
 * @return size
 */
- (CGSize)getAttributionHeightWithString:(NSString *)string lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{
                                NSParagraphStyleAttributeName:paragraphStyle,
                                NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
    return size;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
   if ([[URL scheme] isEqualToString:@"login"]) {
       
       if (self.delegateClickBlock) {
           self.delegateClickBlock(0);
       }
        return NO;
    }else if ([[URL scheme] isEqualToString:@"register"]) {
        if (self.delegateClickBlock) {
            self.delegateClickBlock(1);
        }
        return NO;
    }
    return YES;
}

- (IBAction)sureBtnClick {
    if (self.sureBlock) {
        self.sureBlock();
    }
    
}
- (IBAction)cancelBtnClick {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
