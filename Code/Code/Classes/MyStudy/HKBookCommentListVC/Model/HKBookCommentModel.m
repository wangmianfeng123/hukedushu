//
//  HKBookCommentModel.m
//  Code
//
//  Created by Ivan li on 2019/8/27.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentModel.h"
#import <YYText/YYText.h>
#import "NSString+MD5.h"

@implementation HKBookCommentModel

-(id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{

    return [self isEqual:object];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"children":[HKBookCommentModel class] };
}


- (CGFloat)cellInfoHeight {
    
    if (0 == _cellInfoHeight) {
        CGFloat height = 65; ///文本之上的距离
        // 评论高度
        CGFloat contentH = [NSString heightWithStr:self.content spacing:PADDING_5 titleFont:HK_FONT_SYSTEM(14) width:SCREEN_WIDTH - 80];
        height += contentH;
        // 图片高度
        height += (isEmpty(self.image_url)? 12: 110+24);
        _cellInfoHeight = height;
    }
    return _cellInfoHeight;
}


- (CGFloat)cellHeight {
    if (_cellHeight == 0) {

        // 富文本content
        NSString *contentString = [NSString stringWithFormat:@"%@ 回复 %@：%@", _username,_reply_to_username, _content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:4.0];
        paragraphStyle.headIndent = 10;  //行首缩进
        //paragraphStyle.firstLineHeadIndent = 10.0;//首行缩进
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(13) range:NSMakeRange(0, contentString.length)];
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 90, CGFLOAT_MAX);
        
        CGFloat H = [attrString boundingRectWithSize:size
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      context:nil].size.height;
        
        H = H + HK_FONT_SYSTEM(13).ascender + HK_FONT_SYSTEM(13).descender;
        //H = H+4;
        _cellHeight = H;
    }
    return _cellHeight;
}




- (CGFloat)cellMyNotiHeight {
    if (_cellMyNotiHeight == 0) {
        
        // 富文本content
        NSString *contentString = [NSString stringWithFormat:@"%@回复你：\n%@", _username, _content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:8];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(13) range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196 range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        
        [attrString addAttribute:NSForegroundColorAttributeName value: COLOR_27323F range:NSMakeRange(0, contentString.length - _content.length)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(14) range:NSMakeRange(0, contentString.length - _content.length)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightBold) range:NSMakeRange(0, _username.length)];
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 12 - 8 - 4 - 45 - 15 - 92, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attrString];
        
        _contentLBHeigth = layout.textBoundingSize.height + 0.5 + 8;
        _cellMyNotiHeight = 15 + _contentLBHeigth + 10 + 12 + 13;
        CGFloat minHeight =  15 + 45 + 12 + 13;
        _cellMyNotiHeight = _cellMyNotiHeight > minHeight ? _cellMyNotiHeight : minHeight;
    }
    return _cellMyNotiHeight;
}



@end




@implementation HKBookTopModel


-(id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}

@end


@implementation HKBookMidCommentModel


-(id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}


@end


@implementation HKBookBottomModel


-(id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}


@end




@implementation HKBookActionModel

- (id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}

@end



@implementation HKBookMidCommentTopModel

- (id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}

@end


@implementation HKBookMidCommentBottomModel

- (id<NSObject>)diffIdentifier{
    return self;
}

-(BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}

@end

