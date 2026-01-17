//
//  DetailModel.m
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "DetailModel.h"
#import <YYText/YYText.h>
#import "HKCategoryTreeModel.h"
#import "CategoryModel.h"
#import "HKBuyVipModel.h"

@implementation SocialChannelModel

@end


@implementation ShareModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"channel_list" : [SocialChannelModel class]};
}


- (NSString*)img_url {
    
    if (isEmpty(_image_url)) {
        return _img_url;
    }
    return _image_url;
}


@end




@implementation SoftwareInfoModel

@end



@implementation DetailModel

- (NSString *)video_type {
    
    if (_video_type == nil) {
        _video_type = @"0";
    }
    return _video_type;
}
//+(JSONKeyMapper*)keyMapper {
//
//    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id": @"ID",  @"class":@"categoryId"}];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{ @"ID" : @"id",  @"categoryId" : @"class" , @"video_titel" :@"video_title"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"salve_video_list" : [HKPracticeModel class],@"recommend_video_list":[VideoModel class],@"dir_list": [HKCourseModel class],@"course_data":[HKCourseModel class],  @"software_info":[SoftwareInfoModel class],@"dir_recommend_video_list":[VideoModel class],@"tags":[HKcategoryChilderenModel class],@"album":[HomeCategoryModel class],
             @"limited_playback_vip_list":[HKBuyVipModel class]
    };//
}




- (CGSize)headSize {
    if (_headSize.width <= 0) {
        _headSize = [self stringSizeWithText:self.class_name];
    }
    return _headSize;
}

- (CGFloat)headHeight {
    if (_headHeight <= 0 ) {
        _headHeight = [self stringHeightWithText:self.video_titel];
    }
    return _headHeight;
}



- (void)setClass_name:(NSString *)class_name {
    _class_name = class_name;
    if (_headSize.width <= 0) {
        _headSize = [self stringSizeWithText:self.class_name];
    }
}


- (void)setVideo_titel:(NSString *)video_titel {

    _video_titel = video_titel;
    
    if (_headHeight <= 0 ) {
        _headHeight = [self stringHeightWithText:video_titel];
    }
}






//- (void)setVideo_titel:(NSString *)video_titel {
//    if (isEmpty(video_titel)) {
//        _video_titel = self.video_title;
//    }else{
//        _video_titel = video_titel;
//    }
//}
//
//
//- (void)setVideo_title:(NSString *)video_title {
//    if (isEmpty(video_title)) {
//        _video_title = self.video_titel;
//    }else{
//        _video_title = video_title;
//    }
//    if (_headHeight <= 0 ) {
//        _headHeight = [self stringHeightWithText:self.video_title];
//    }
//}




//- (NSString *)video_titel {
//    return _video_titel.length? _video_titel : _video_title;
//}
//
//
//
//- (NSString *)video_title {
//
//    NSString *str = _video_title.length? _video_title: _video_titel;
//        if (_headHeight <= 0 ) {
//            _headHeight = [self stringHeightWithText:str];
//        }
//    return str;
//}




/** 文本Size */
- (CGSize)stringSizeWithText:(NSString *)text {
    
    if (isEmpty(text)) {
        return CGSizeMake(25, 20);
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    UIFont *font = HK_FONT_SYSTEM(IS_IPHONE6PLUS ? 13:12);
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrString.length)];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) text:attrString];
    CGSize size = layout.textBoundingSize;
    
    if (size.width != 0) {
        size.width += 25;
        size.height = 20;
    }
    return size;
}


/** 文本高度 */
- (CGFloat)stringHeightWithText:(NSString *)text {
    
    if (isEmpty(text)) {
        self.textLines = 1;
        return 30;
    }
    UIFont *font = HK_FONT_SYSTEM_WEIGHT(IS_IPHONE5S ? 16:17, UIFontWeightMedium);
    CGFloat height = [CommonFunction getTextHeight:text font:font lineSpacing:5 width:SCREEN_WIDTH - PADDING_15*2 - [self headSize].width];
    
    self.textLines = (height > 30) ?2 :1;
    return height;
}





@end





@implementation HkCertificateModel : NSObject

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package":[HKMapModel class]};
}
@end
