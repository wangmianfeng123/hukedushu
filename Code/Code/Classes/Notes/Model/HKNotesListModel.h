//
//  HKNotesListModel.h
//  Code
//
//  Created by Ivan li on 2021/1/4.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKNotesListModel : NSObject
@property (nonatomic, copy)NSString * video_id;  //
@property (nonatomic, copy)NSString * count;  //
@property (nonatomic, copy)NSString * created_at;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, strong)NSMutableArray * notes;  //
@end

@interface HKNotesModel : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * video_id;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * notes;  //
@property (nonatomic, copy)NSString * screenshot;  //
@property (nonatomic, copy)NSString * point_of_time;  //
@property (nonatomic, copy)NSString * likes_count;  //
@property (nonatomic, copy)NSString * created_at;  //
@property (nonatomic, strong)NSNumber * liked;  //
@property (nonatomic, strong)NSNumber * is_private;  //
@property (nonatomic, strong)NSNumber * seconds;  //

@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, copy)NSString * avatar;  //

@property (nonatomic , assign) BOOL isPalyMenuNote ;//宽度不一样，文本高度也不一样
@property (nonatomic , assign) CGFloat imgH;//图片的高度
@property (nonatomic , assign) CGFloat contentHeight ;
@property (nonatomic , assign) CGFloat cellHeight ;
@property (nonatomic , assign)  BOOL  unfold;  //1展开 0收缩
@property (nonatomic , copy)  NSString *  contentType;  //1展开 0收缩

@end


@interface HKNotesVideoModel : NSObject
@property (nonatomic, copy)NSString * video_id;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * number;  //
@property (nonatomic, copy)NSString * image_url;  //
@property (nonatomic, copy)NSString * gif_url;  //
@property (nonatomic, copy)NSString * cover;  //
@property (nonatomic, strong)NSMutableArray * notes;  //
@end


NS_ASSUME_NONNULL_END
