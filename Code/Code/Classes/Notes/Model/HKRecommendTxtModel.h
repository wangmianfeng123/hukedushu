//
//  HKRecommendTxtModel.h
//  Code
//
//  Created by Ivan li on 2021/4/6.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKRecommendTxtModel : NSObject
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, copy)NSString * avatar;  //
@property (nonatomic, copy)NSString * image_url;  //
@property (nonatomic, copy)NSString * video_id;  //
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * type;  //1:评论 2:笔记
@property (nonatomic, copy)NSString * relation_id;  //评论id/笔记id
@property (nonatomic, assign)int thumbs;  //
@property (nonatomic, strong)NSNumber * score;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic , assign) BOOL is_thumb ;//是否点赞过

//@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, assign) CGFloat imageH;
@property (nonatomic , assign) CGFloat cellHeight ;
@end

NS_ASSUME_NONNULL_END
