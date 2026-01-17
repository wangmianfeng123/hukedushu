//
//  HKLiveCommentVC.h
//  Code
//
//  Created by Ivan li on 2020/12/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCommentVC : HKBaseVC
/** 更新评论数量 */
//@property(nonatomic,copy)CommentCountChangeBlock commentCountChangeBlock;

@property(nonatomic,copy)NSString *videoId;

@end

NS_ASSUME_NONNULL_END
