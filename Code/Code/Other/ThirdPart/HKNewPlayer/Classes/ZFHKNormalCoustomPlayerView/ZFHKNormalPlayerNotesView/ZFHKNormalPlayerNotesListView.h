//
//  ZFHKNormalPlayerNotesListView.h
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalPlayerNotesListView : UIView
/** 视频详情 */
@property (nonatomic,strong,nullable) DetailModel *videoDetailModel;
@property (nonatomic , strong) void(^didPlayTimeBtnBlock)(int time);

@end

NS_ASSUME_NONNULL_END
